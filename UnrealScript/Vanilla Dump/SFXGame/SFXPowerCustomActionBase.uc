Class SFXPowerCustomActionBase extends BioCustomAction
    native
    abstract
    config(Game);

struct native PowerStatBarInfo 
{
    var PowerData Data;
    var float EvolvedBonuses[6];
    var float BarLength;
    var stringref srDisplayTotalToken;
    var stringref srStatBarDisplayTitle;
    var EPowerStatBarFormula Formula;
};
enum EPowerStatBarFormula
{
    EPowerStatBarFormula_Normal,
    EPowerStatBarFormula_Percent,
    EPowerStatBarFormula_Distance,
};
const NumberOfEvolvedChoices = 6;
const MaxRank = 6;
struct native PowerData 
{
    var init array<SFXGameEffect> DynamicBonuses;
    var float RankBonuses[6];
    var float BaseValue;
    var float CurrentValue;
    var EPowerDataFormula Formula;
};
enum EPowerDataFormula
{
    Normal,
    BonusIsHardValue,
    DivideByBonusSum,
};
struct native EvolvedChoiceInfo 
{
    var stringref Name;
    var stringref Description;
};
struct native RankInfo2 
{
    var int Icon;
    var stringref Name;
    var stringref Description;
    var stringref Evolved1Name;
    var stringref Evolved1Description;
    var stringref Evolved2Name;
    var stringref Evolved2Description;
};
enum EEvolveChoice
{
    EvolveChoice1,
    EvolveChoice2,
    EvolveChoice3,
    EvolveChoice4,
    EvolveChoice5,
    EvolveChoice6,
};
enum EPowerType
{
    PowerType_Instant,
    PowerType_Projectile,
    PowerType_Melee,
    PowerType_Buff,
};

var config PowerData CooldownTime;
var config PowerData HenchmanCooldownTime;
var config PowerData MinimumRange;
var config PowerData MaximumRange;
var config PowerData ImpactRadius;
var config PowerData MaximumImpactTargets;
var config PowerData MaximumRagdollTargets;
var config PowerData EffectDuration;
var config PowerData Damage;
var config PowerData Force;
var config PowerData VFXIntensity;
var config PowerData ProjectileSpeed;
var config PowerData ConeHalfAngle;
var array<RankInfo2> Ranks;
var array<int> RankCosts;
var array<PowerStatBarInfo> PowerStatBars;
var delegate<OnActorImpacted> __OnActorImpacted__Delegate;
var EvolvedChoiceInfo EvolvedChoicesInfo[6];
var int EvolvedChoices[6];
var int EvolvedRankCosts[6];
var transient Vector m_vLocationToAimAt;
var transient Vector LastProjectileVelocity;
var Name PowerName;
var int PowerCustomActionID;
var float Rank;
var transient Actor m_oTargetToAimAt;
var float DelayBeforeFirstUse;
var float DelayBetweenUses;
var float TimeUntilNextUse;
var float CurrentCooldownTime;
var float TotalCooldownTime;
var float GlobalCooldownTime;
var stringref DisplayName;
var stringref Description;
var stringref DataDescription;
var stringref ImpactText;
var int Icon;
var GFxMovieInfo IconResource;
var stringref TalentDescription;
var stringref Evolved1DisplayName;
var stringref Evolved1TalentDescription;
var stringref Evolved2DisplayName;
var stringref Evolved2TalentDescription;
var int WheelDisplayIndex;
var config float InstantCastIgnoreCoverDist;
var stringref srTokenizedPowerData;
var stringref srFractionSeparator;
var bool bEnabled;
var bool bEvolved1;
var bool bEvolved2;
var transient bool m_bPlayerOrderedPowerUse;
var bool AISelectable;
var bool AimingIgnoresObstructions;
var bool UsesSharedCooldown;
var bool DisplayInHUD;
var bool DisplayInCharacterRecord;
var bool IsHenchmenUnique;
var bool IsBonusPower;
var EPowerType PowerType;
var EPowerType HenchmanPowerType;

public event function bool CanUsePower(Actor oTarget);

public event function ChoosePowerTarget(out Actor oTarget, out Vector vTargetLocation, optional bool bPlayerOrdered, optional Actor oDesiredSelectionTarget, optional Actor oDesiredTarget, optional Vector vDesiredTargetLocation)
{
    m_bPlayerOrderedPowerUse = bPlayerOrdered;
    if (PowerType == EPowerType.PowerType_Buff)
    {
        oTarget = m_oPawn;
        vTargetLocation = m_oPawn.location;
    }
    else if (m_bPlayerOrderedPowerUse || SFXPawn_Player(m_oPawn) != None)
    {
        ChooseTargetForPlayer(oTarget, vTargetLocation, oDesiredSelectionTarget, oDesiredTarget, vDesiredTargetLocation);
    }
    m_oTargetToAimAt = oTarget;
    m_vLocationToAimAt = vTargetLocation;
}
protected function ChooseTargetForPlayer(out Actor oTarget, out Vector vTargetLocation, optional Actor oDesiredSelectionTarget, optional Actor oDesiredTarget, optional Vector vDesiredTargetLocation)
{
    local SFXPlayerCamera Camera;
    local BioPlayerController PC;
    local float fMaxRange;
    local Vector vStartLocation;
    local Vector vEndLocation;
    local Actor oCurrentTarget;
    local BioPawn oPawnTarget;
    local Actor oHitActor;
    local Actor oFallbackActor;
    local Vector vHitLocation;
    local Vector vHitNormal;
    local Vector vFallbackLocation;
    local BioWorldInfo oWorldInfo;
    local Rotator rRotation;
    local float fIgnoreCoverDist;
    local EPowerType CurrentPowerType;
    
    if (m_oPawn == None)
    {
        return;
    }
    oWorldInfo = BioWorldInfo(m_oPawn.WorldInfo);
    if (oWorldInfo == None)
    {
        return;
    }
    PC = SFXPlayerController(m_oPawn.Controller);
    if (PC == None)
    {
        PC = oWorldInfo.GetLocalPlayerController();
    }
    if (PC == None)
    {
        return;
    }
    Camera = SFXPlayerCamera(PC.PlayerCamera);
    if (Camera == None)
    {
        return;
    }
    fMaxRange = MaximumRange.CurrentValue;
    GetStartLocationForLOSCheck(vStartLocation, BioPawn(PC.Pawn));
    if (oDesiredSelectionTarget == None)
    {
        oCurrentTarget = PC.m_oPlayerSelection.m_oCurrentSelectionTarget;
    }
    else
    {
        oCurrentTarget = oDesiredSelectionTarget;
    }
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        CurrentPowerType = HenchmanPowerType;
    }
    else
    {
        CurrentPowerType = PowerType;
    }
    if (CurrentPowerType == EPowerType.PowerType_Instant && PC.Pawn != None && BioPawn(PC.Pawn).IsInCover())
    {
        fIgnoreCoverDist = InstantCastIgnoreCoverDist;
    }
    if (oCurrentTarget != None && IsValidTarget(oCurrentTarget))
    {
        if (oCurrentTarget == Camera.m_aTraceInfo.m_oCollVectorActor)
        {
            oTarget = Camera.m_aTraceInfo.m_oCollVectorActor;
            vTargetLocation = Camera.m_aTraceInfo.m_vCollVectorLocation;
            return;
        }
        oPawnTarget = BioPawn(oCurrentTarget);
        if (oPawnTarget == None || oPawnTarget.GetAimNodeLocation(4, vEndLocation) == FALSE)
        {
            vEndLocation = oCurrentTarget.location;
        }
        if (PowerType == EPowerType.PowerType_Projectile || AimingIgnoresObstructions)
        {
            oTarget = oCurrentTarget;
            vTargetLocation = vEndLocation;
            return;
        }
        oWorldInfo.m_oPowerManager.CheckLOSToLocation(PC.Pawn, vStartLocation, vEndLocation, fMaxRange, TRUE, oHitActor, vHitLocation, vHitNormal, fIgnoreCoverDist);
        if (oHitActor == oCurrentTarget)
        {
            oTarget = oHitActor;
            vTargetLocation = vHitLocation;
            return;
        }
        oFallbackActor = oHitActor;
        vFallbackLocation = vHitLocation;
        if (oPawnTarget != None && oPawnTarget.GetAimNodeLocation(1, vEndLocation))
        {
            oWorldInfo.m_oPowerManager.CheckLOSToLocation(PC.Pawn, vStartLocation, vEndLocation, fMaxRange, TRUE, oHitActor, vHitLocation, vHitNormal, fIgnoreCoverDist);
            if (oHitActor == oCurrentTarget)
            {
                oTarget = oHitActor;
                vTargetLocation = vHitLocation;
                return;
            }
        }
    }
    if (IsZero(vFallbackLocation) == FALSE)
    {
        oHitActor = oFallbackActor;
        vHitLocation = vFallbackLocation;
    }
    else if (oDesiredTarget == None && IsZero(vDesiredTargetLocation))
    {
        rRotation = Camera.CameraCache.POV.Rotation;
        vEndLocation = Camera.CameraCache.POV.location + fMaxRange * Vector(rRotation);
        oWorldInfo.m_oPowerManager.CheckLOSToLocation(PC.Pawn, vStartLocation, vEndLocation, fMaxRange, TRUE, oHitActor, vHitLocation, vHitNormal, fIgnoreCoverDist);
    }
    else
    {
        oHitActor = oDesiredTarget;
        vHitLocation = vDesiredTargetLocation;
    }
    if (oHitActor != None)
    {
        if (oHitActor.bWorldGeometry)
        {
            oHitActor = None;
        }
        else if (PC.IsCombatTargetable(oHitActor) == FALSE)
        {
            if (BioPawn(oHitActor) != None)
            {
                if (!BioPawn(oHitActor).IsInvisible())
                {
                    oHitActor = None;
                }
            }
            else
            {
                oHitActor = None;
            }
        }
    }
    oTarget = oHitActor;
    vTargetLocation = vHitLocation;
}
public event function string ConvertStatForDisplay(float Number)
{
    local array<string> splitStrings;
    
    splitStrings = SplitString(string(Number), ".", TRUE);
    if (splitStrings.Length != 2)
    {
        return string(int(Number));
    }
    if (Number - float(int(Number)) >= 0.00999999978)
    {
        ClearCustomTokens();
        SetCustomToken(0, splitStrings[0]);
        SetCustomToken(1, string(srFractionSeparator));
        SetCustomToken(2, Left(splitStrings[1], 2));
        return Class'SFXGame'.static.GetSimpleString(srTokenizedPowerData, TRUE);
    }
    else
    {
        return string(int(Number));
    }
}
public event function bool DoAreaExplosionForActor(Actor oActor, Vector location, int ImpactCount, float fDamage, Class<SFXDamageType> DamageType, float fForce, AreaEffectParameters Param, int MaxRagdollOverride, delegate<OnActorImpacted> ImpactCallback, optional Class<SFXDamageType> MaxRagdollDmgTypeOverride);

public event function bool DoPowerDetonatedForActor(Actor oActor, Vector HitLocation, Vector HitNormal, int nImpactCount, bool bFirstTarget, optional SFXProjectile_PowerCustomAction oProjectile);

public native function float GetArrayValue(out array<float> ArrayValues, optional int nRankToUse = -1);

public event function float GetCurrentValueAtRank(out PowerData Data, int nRank)
{
    local int nIndex;
    local SFXGameEffect GE;
    local float fBonus;
    local float fRankSum;
    local float fTotalBonus;
    local float Result;
    
    if (nRank > 6)
    {
        nRank = 6;
    }
    foreach Data.DynamicBonuses(GE, )
    {
        switch (GE.Class.default.BonusFormula)
        {
            case EBonusFormula.BonusFormula_Add:
                fBonus += GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_Substract:
                fBonus -= GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_LargestValue:
                if (GE.EffectValue > fBonus)
                {
                    fBonus = GE.EffectValue;
                }
                break;
            case EBonusFormula.BonusFormula_Custom:
                GE.ComputeCustomEffectValue(fBonus);
                break;
            default:
        }
    }
    for (nIndex = 0; nIndex < nRank; nIndex++)
    {
        fRankSum += Data.RankBonuses[nIndex];
    }
    switch (Data.Formula)
    {
        case EPowerDataFormula.BonusIsHardValue:
            Result = (Data.BaseValue + fRankSum) * (1.0 + fBonus);
            break;
        case EPowerDataFormula.DivideByBonusSum:
            fTotalBonus = fRankSum + fBonus;
            if (fTotalBonus >= float(0))
            {
                Result = Data.BaseValue * (1.0 / (1.0 + fTotalBonus));
                break;
            }
            else
            {
                Result = Data.BaseValue * (1.0 + Abs(fTotalBonus));
                break;
            }
        default:
            Result = Data.BaseValue * (1.0 + fRankSum + fBonus);
            break;
    }
    return Result;
}
public native function bool GetDataDescription(int nRankIndex, out string sDescription);

public native function bool GetDescription(int nRankIndex, out string sDescription);

public event function float GetDisplayBonusAtRank(out PowerData Data, int nRank)
{
    local SFXGameEffect GE;
    local float fBonus;
    local float fRankSum;
    local int nIndex;
    
    if (nRank <= 0)
    {
        return Data.BaseValue;
    }
    if (nRank > 6)
    {
        nRank = 6;
    }
    foreach Data.DynamicBonuses(GE, )
    {
        switch (GE.Class.default.BonusFormula)
        {
            case EBonusFormula.BonusFormula_Add:
                fBonus += GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_Substract:
                fBonus -= GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_LargestValue:
                if (GE.EffectValue > fBonus)
                {
                    fBonus = GE.EffectValue;
                }
                break;
            case EBonusFormula.BonusFormula_Custom:
                GE.ComputeCustomEffectValue(fBonus);
                break;
            default:
        }
    }
    switch (Data.Formula)
    {
        case EPowerDataFormula.BonusIsHardValue:
            break;
        default:
            for (nIndex = 0; nIndex < nRank; nIndex++)
            {
                fRankSum += Data.RankBonuses[nIndex];
            }
            break;
    }
    return fRankSum + fBonus;
}
public event function string GetHUDWheelIconInfo()
{
    return "";
}
public native function bool GetParsedString(stringref srValue, int nRankIndex, out string sOutput);

public event function bool GetPawnPowerUnlockData(out float nRequiredLevel, out stringref srCustomUnlockText)
{
    local SFXPawn_PlayerParty oSFXPawn;
    local int nIndex;
    
    oSFXPawn = SFXPawn_PlayerParty(m_oPawn);
    if (oSFXPawn == None)
    {
        return FALSE;
    }
    for (nIndex = 0; nIndex < oSFXPawn.PowerUnlockRequirements.Length; nIndex++)
    {
        if (oSFXPawn.PowerUnlockRequirements[nIndex].PowerClass == Class)
        {
            nRequiredLevel = float(oSFXPawn.PowerUnlockRequirements[nIndex].RequiredLevel);
            srCustomUnlockText = oSFXPawn.PowerUnlockRequirements[nIndex].CustomUnlockText;
            return TRUE;
        }
    }
    return FALSE;
}
public event function GetPowerAnimInfo(out AnimSet AnimSet, out array<Name> AnimNames);

public native function float GetRankBonus(out PowerData Data, int nRankToUse);

public function GetStartLocationForLOSCheck(out Vector vStartLocation, optional BioPawn oPawn)
{
    local BioPlayerController PC;
    local SFXPlayerCamera Camera;
    local Vector vCasterLocation;
    local Vector vCameraRotation;
    local float fDotProduct;
    
    if (oPawn == None)
    {
        oPawn = m_oPawn;
    }
    PC = BioPlayerController(oPawn.Controller);
    if (PC != None && PC.IsLocalPlayerController())
    {
        Camera = SFXPlayerCamera(PC.PlayerCamera);
        if (Camera == None)
        {
            return;
        }
        vCasterLocation = oPawn.location - Camera.CameraCache.POV.location;
        vCameraRotation = Vector(Camera.CameraCache.POV.Rotation);
        fDotProduct = vCasterLocation Dot vCameraRotation;
        vStartLocation = vCameraRotation * fDotProduct;
        vStartLocation += Camera.CameraCache.POV.location;
    }
    else
    {
        vStartLocation = oPawn.GetPawnViewLocation();
    }
}
public native function GetStringFromStringRef(stringref TheStringRef, out string TheString, optional bool bParse = FALSE, optional int nParseIndex = 0);

public function bool IsEnabled()
{
    return bEnabled;
}
public native function bool IsTargetInRange(Actor Target);

public delegate function bool OnActorImpacted(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal);

private final native function bool ParseString(int nRankIndex, out string sParsedString);

private final native function ProcessToken(int nRankIndex, out string sToken);

public event function RecalculatePowerData(out PowerData Data, optional bool bReset = FALSE)
{
    local int nIndex;
    
    if (bReset)
    {
        for (nIndex = m_oPawn.PowerManager.EvolveRank - 1; nIndex < 6; nIndex++)
        {
            Data.RankBonuses[nIndex] = 0.0;
        }
    }
    Data.CurrentValue = GetCurrentValueAtRank(Data, int(Rank));
}
public event function ReplaceAnimSetWithDynamic(AnimSet DynAnimSet);

public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    sOptionalInfo = "";
    return TRUE;
}
public function DoJoinInProgress();

public function EvolvePower(EEvolveChoice choice)
{
    local int NumEvolved;
    local int BonusIndex;
    
    NumEvolved = GetNumEvolveChoices();
    BonusIndex = m_oPawn.PowerManager.EvolveRank - 1 + NumEvolved;
    Ranks[BonusIndex].Description = EvolvedChoicesInfo[int(choice)].Description;
    EvolvedChoices[int(choice)] = NumEvolved + 1;
}
public final function int GetNumEvolveChoices()
{
    local int NumEvolved;
    local int nIndex;
    
    for (nIndex = 0; nIndex < 6; nIndex++)
    {
        if (EvolvedChoices[nIndex] > 0)
        {
            NumEvolved++;
        }
    }
    return NumEvolved;
}
private final function int GetPowerStatBarBonus(out PowerData Data, float Bonus, float BarLength)
{
    switch (Data.Formula)
    {
        case EPowerDataFormula.Normal:
            return int(Bonus * Data.BaseValue / BarLength * 100.0);
        case EPowerDataFormula.BonusIsHardValue:
            return int(Bonus / BarLength * 100.0);
        case EPowerDataFormula.DivideByBonusSum:
            return int(Bonus * Data.BaseValue / BarLength * 100.0);
        default:
    }
    return 0;
}
public function bool GetPowerStatBarData(int RankIdx, int nEvolve, int BarIdx, out PowerEvolveStatDetails Details)
{
    local EEvolveChoice EvolveChoice;
    local PowerData DataCopy;
    local PowerData PreviewDataCopy;
    local PowerData NoBonusDataCopy;
    local float fPreviewValue;
    local int idx;
    local int nEvolveRank;
    local string sPreviewValue;
    
    if (BarIdx >= PowerStatBars.Length)
    {
        return FALSE;
    }
    NoBonusDataCopy = PowerStatBars[BarIdx].Data;
    NoBonusDataCopy.DynamicBonuses.Length = 0;
    if (NoBonusDataCopy.Formula == EPowerDataFormula.DivideByBonusSum)
    {
        NoBonusDataCopy.Formula = EPowerDataFormula.Normal;
    }
    NoBonusDataCopy.CurrentValue = GetCurrentValueAtRank(NoBonusDataCopy, Max(int(Rank), 1));
    if (PowerStatBars[BarIdx].BarLength == float(0))
    {
        DataCopy = NoBonusDataCopy;
        DataCopy.RankBonuses[3] = FMax(PowerStatBars[BarIdx].EvolvedBonuses[0], PowerStatBars[BarIdx].EvolvedBonuses[1]);
        DataCopy.RankBonuses[4] = FMax(PowerStatBars[BarIdx].EvolvedBonuses[2], PowerStatBars[BarIdx].EvolvedBonuses[3]);
        DataCopy.RankBonuses[5] = FMax(PowerStatBars[BarIdx].EvolvedBonuses[4], PowerStatBars[BarIdx].EvolvedBonuses[5]);
        PowerStatBars[BarIdx].BarLength = GetCurrentValueAtRank(DataCopy, 6);
    }
    Details.Title = string(PowerStatBars[BarIdx].srStatBarDisplayTitle);
    Details.Pct = int(NoBonusDataCopy.CurrentValue / PowerStatBars[BarIdx].BarLength * 100.0);
    PreviewDataCopy = PowerStatBars[BarIdx].Data;
    if (float(RankIdx) > Rank - float(1))
    {
        for (idx = int(Rank); idx < 6; idx++)
        {
            PreviewDataCopy.RankBonuses[idx] = 0.0;
        }
        if (RankIdx >= 3)
        {
            switch (RankIdx)
            {
                case 3:
                    EvolveChoice = nEvolve == 1 ? EEvolveChoice.EvolveChoice1 : EEvolveChoice.EvolveChoice2;
                    nEvolveRank = 3;
                    break;
                case 4:
                    EvolveChoice = nEvolve == 1 ? EEvolveChoice.EvolveChoice3 : EEvolveChoice.EvolveChoice4;
                    nEvolveRank = 4;
                    break;
                case 5:
                    EvolveChoice = nEvolve == 1 ? EEvolveChoice.EvolveChoice5 : EEvolveChoice.EvolveChoice6;
                    nEvolveRank = 5;
                    break;
                default:
            }
            PreviewDataCopy.RankBonuses[nEvolveRank] = PowerStatBars[BarIdx].EvolvedBonuses[int(EvolveChoice)];
            Details.BonusPct = GetPowerStatBarBonus(NoBonusDataCopy, PowerStatBars[BarIdx].EvolvedBonuses[int(EvolveChoice)], PowerStatBars[BarIdx].BarLength);
        }
        else if (RankIdx > 0)
        {
            PreviewDataCopy.RankBonuses[RankIdx] = PowerStatBars[BarIdx].Data.RankBonuses[RankIdx];
            Details.BonusPct = GetPowerStatBarBonus(NoBonusDataCopy, NoBonusDataCopy.RankBonuses[RankIdx], PowerStatBars[BarIdx].BarLength);
        }
    }
    PreviewDataCopy.CurrentValue = GetCurrentValueAtRank(PreviewDataCopy, RankIdx + 1);
    fPreviewValue = PreviewDataCopy.CurrentValue;
    switch (PowerStatBars[BarIdx].Formula)
    {
        case EPowerStatBarFormula.EPowerStatBarFormula_Percent:
            fPreviewValue *= 100.0;
            break;
        case EPowerStatBarFormula.EPowerStatBarFormula_Distance:
            fPreviewValue /= 100.0;
            break;
        default:
    }
    fPreviewValue = float(Round(fPreviewValue * 100.0)) / 100.0;
    sPreviewValue = ConvertStatForDisplay(fPreviewValue);
    ClearCustomTokens();
    SetCustomToken(0, sPreviewValue);
    Details.TotalTitle = Class'SFXGame'.static.GetSimpleString(PowerStatBars[BarIdx].srDisplayTotalToken, TRUE);
    ClearCustomTokens();
    return TRUE;
}
public function bool IsEvolvedWithChoice(EEvolveChoice choice)
{
    return EvolvedChoices[int(choice)] > 0;
}
public function bool IsValidTarget(Actor oTarget)
{
    local KActor oKActor;
    local SFXPlaceableBase CombatPlaceable;
    local SFXSelectionModule Module;
    local BioPawn oPawn;
    
    oPawn = BioPawn(oTarget);
    if (oPawn != None)
    {
        return oPawn.IsHostile(m_oPawn);
    }
    else
    {
        oKActor = KActor(oTarget);
        if (oKActor != None)
        {
            Module = oKActor.GetModule(Class'SFXSelectionModule');
            if (Module != None && Module.m_bCombatTargetable == TRUE)
            {
                return TRUE;
            }
        }
        CombatPlaceable = SFXPlaceableBase(oTarget);
        if (CombatPlaceable != None)
        {
            Module = CombatPlaceable.GetModule(Class'SFXSelectionModule');
            if (Module != None && Module.m_bCombatTargetable == TRUE)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function OnOwnerDestroyed();

public function OnOwnerDied();

public function OnPawnLoadedWeapons();

public function OnPowerAdded(SFXPowerCustomActionBase Power)
{
    if (Power == Self)
    {
        RecalculateAllPowerInfo();
    }
}
public function OnPowerRankIncreased()
{
    RecalculateAllPowerInfo();
}
public function OnPowersLoaded()
{
    RecalculateAllPowerInfo();
}
public function OnSquadMemberAdded(Pawn Pawn);

public function PopulatePowerStatBarEvolves();

public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    RecalculatePowerData(CooldownTime, bReset);
    RecalculatePowerData(HenchmanCooldownTime, bReset);
    RecalculatePowerData(MinimumRange, bReset);
    RecalculatePowerData(MaximumRange, bReset);
    RecalculatePowerData(ImpactRadius, bReset);
    RecalculatePowerData(MaximumImpactTargets, bReset);
    RecalculatePowerData(MaximumRagdollTargets, bReset);
    RecalculatePowerData(EffectDuration, bReset);
    RecalculatePowerData(Damage, bReset);
    RecalculatePowerData(Force, bReset);
    RecalculatePowerData(VFXIntensity, bReset);
    RecalculatePowerData(ProjectileSpeed, bReset);
    RecalculatePowerData(ConeHalfAngle, bReset);
}
public function RecalculateAllPowerInfo(optional bool bReset = FALSE)
{
    RecalculateAllPowerData(bReset);
}
public function ReloadAmmoPower(BioPawn Target, SFXWeapon Weapon);

public function ResetPower()
{
    local int nEvolveIndex;
    
    Rank = 0.0;
    for (nEvolveIndex = 0; nEvolveIndex < 6; nEvolveIndex++)
    {
        EvolvedChoices[nEvolveIndex] = 0;
    }
    RecalculateAllPowerInfo(TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EvolvedRankCosts[0] = 4
    EvolvedRankCosts[1] = 4
    EvolvedRankCosts[2] = 5
    EvolvedRankCosts[3] = 5
    EvolvedRankCosts[4] = 6
    EvolvedRankCosts[5] = 6
    IconResource = GFxMovieInfo'GUI_SF_PowerIcons.PowerIcons'
    InstantCastIgnoreCoverDist = 150.0
    srTokenizedPowerData = $347303
    srFractionSeparator = $720547
    bReplicateCustomAction = TRUE
}