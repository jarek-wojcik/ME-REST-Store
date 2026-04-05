Class SFXPowerManager
    native
    config(Game);

const NumEvolvedChoicesCanBuy = 3;
const NumEvolvedChoices = 6;
struct native PowerSaveInfo 
{
    var int EvolvedChoices[6];
    var Name PowerName;
    var Name PowerClassName;
    var float CurrentRank;
    var int WheelDisplayIndex;
};

var transient array<SFXPowerCustomActionBase> Powers;
var array<delegate<OnPowerReleased>> PowerReleasedDelegates;
var array<delegate<OnBioticCombo>> BioticComboDelegates;
var array<delegate<OnPowerImpacted>> PowerImpactedDelegates;
var delegate<OnPowerReleased> __OnPowerReleased__Delegate;
var delegate<OnBioticCombo> __OnBioticCombo__Delegate;
var delegate<OnPowerImpacted> __OnPowerImpacted__Delegate;
var transient BioPawn MyPawn;
var transient AnimSet LastPowerAnimSet;
var config transient stringref RankUnlockText;
var config transient stringref RequiredUnlockText;
var config transient int PassiveRankIcon;
var config transient int LockedRankIcon;
var config transient int UnlockedRankIcon;
var config transient int EvolveRank;
var int CooldownMethod;
var int NumFreePowers;
var int PowerCastCounter;
var int DisableCasterCrusts;
var bool SharedCooldownDisabled;

public final function CombatEnded()
{
    local SFXPowerCustomActionBase Power;
    
    foreach Powers(Power, )
    {
        SFXPowerCustomAction(Power).CombatEnded();
    }
}
public native function SFXPowerCustomActionBase GetPower(Name nmPowerName);

public native function SFXPowerCustomActionBase GetPowerByClass(Class<Object> PowerClass);

public event function GetPowerWheelPowers(out array<SFXPowerCustomActionBase> PowerList)
{
    local int nIndex;
    
    ProcessWheelDisplayOrder();
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        if (Powers[nIndex].IsEnabled() && Powers[nIndex].DisplayInHUD && Powers[nIndex].Rank > float(0))
        {
            PowerList[PowerList.Length] = Powers[nIndex];
        }
    }
}
public delegate function OnBioticCombo(SFXPowerCustomAction oPower, BioPawn oImpacted);

public delegate function OnPowerImpacted(SFXPowerCustomAction oPower);

public delegate function OnPowerReleased(SFXPowerCustomAction oPower);

public native function Tick(float fDeltaTime);

public function SFXPowerCustomActionBase AddPower(Class<Object> PowerClass)
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase PowerInList;
    local int nIndex;
    local Class<SFXPowerCustomActionBase> PowerClassCast;
    local int PowerID;
    
    PowerClassCast = Class<SFXPowerCustomActionBase>(PowerClass);
    if (PowerClassCast == None)
    {
        return None;
    }
    PowerID = PowerClassCast.default.PowerCustomActionID;
    if (PowerID == 0)
    {
        return None;
    }
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        PowerInList = Powers[nIndex];
        if (PowerInList != None && PowerInList.Class == PowerClassCast)
        {
            return None;
        }
    }
    if (MyPawn != None)
    {
        MyPawn.PowerCustomActionClasses[PowerID] = PowerClassCast;
        MyPawn.VerifyCAHasBeenInstanced(132, PowerID);
    }
    Power = SFXPowerCustomActionBase(MyPawn.PowerCustomActions[PowerID]);
    if (Power != None)
    {
        Powers.AddItem(Power);
        for (nIndex = 0; nIndex < Powers.Length; nIndex++)
        {
            PowerInList = Powers[nIndex];
            if (PowerInList != None)
            {
                PowerInList.OnPowerAdded(Power);
            }
        }
    }
    return Power;
}
public function SFXPowerCustomActionBase AddPowerByClassName(Name PowerClassName)
{
    local Class<SFXPowerCustomActionBase> PowerClass;
    local string PCNString;
    
    PCNString = string(PowerClassName);
    PowerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.GetSeekFreeObject(PCNString, Class'Class'));
    if (PowerClass == None)
    {
        return None;
    }
    return AddPower(PowerClass);
}
public function ApplyPowerBonus(BioPawn oPawn, Name Parameter, float Bonus, float Duration, optional Name Category, optional SFXPowerCustomActionBase SourcePower, optional bool bApplyToSourcePower = FALSE, optional bool bApplyToBiotics = TRUE, optional bool bApplyToTech = TRUE, optional bool bApplyToCombat = TRUE, optional bool bApplyToWeapons = TRUE)
{
    local SFXGameEffect_PowerBonus oBonus;
    local SFXModule_GameEffectManager oManager;
    
    if (oPawn == None || oPawn.PowerManager == None)
    {
        return;
    }
    if (Category == 'None')
    {
        Category = Parameter;
    }
    oManager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (oManager != None)
    {
        oBonus = SFXGameEffect_PowerBonus(oManager.CreateEffect(Class'SFXGameEffect_PowerBonus', Category, Duration, Duration > float(0) ? 1 : 2, Bonus, MyPawn.Controller));
        if (oBonus != None)
        {
            oBonus.AffectedParameter = Parameter;
            oBonus.bApplyToBiotics = bApplyToBiotics;
            oBonus.bApplyToTech = bApplyToTech;
            oBonus.bApplyToCombat = bApplyToCombat;
            oBonus.bApplyToWeapons = bApplyToWeapons;
            if (!bApplyToSourcePower && SourcePower != None)
            {
                oBonus.IgnoredPowers.AddItem(SourcePower.Class);
            }
            oBonus.OnApplied();
        }
    }
}
public function BioticCombo(SFXPowerCustomAction oPower, BioPawn oTarget)
{
    local delegate<OnBioticCombo> oComboCallback;
    
    foreach BioticComboDelegates(oComboCallback, )
    {
        oComboCallback(oPower, oTarget);
    }
}
public function BioCheatManager GetCheatManager()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController PC;
    
    if (MyPawn != None)
    {
        oWorldInfo = BioWorldInfo(MyPawn.WorldInfo);
        if (oWorldInfo != None)
        {
            PC = oWorldInfo.GetLocalPlayerController();
            if (PC != None)
            {
                return BioCheatManager(PC.CheatManager);
            }
        }
    }
    return None;
}
public static function int GetRefundAmount(Class<SFXPowerCustomActionBase> Power, int Rank)
{
    local int Refund;
    local int Index;
    
    Refund = 0;
    if (Power != None)
    {
        for (Index = 0; Index < Rank; Index++)
        {
            Refund += Power.default.RankCosts[Index];
        }
    }
    return Refund;
}
public function float GetSharedCooldown()
{
    local SFXPowerCustomActionBase Power;
    
    foreach Powers(Power, )
    {
        if (Power.UsesSharedCooldown)
        {
            return Power.CurrentCooldownTime;
        }
    }
    return 0.0;
}
public function GetSquadRecordPowers(out array<SFXPowerCustomActionBase> PowerList)
{
    local int nIndex;
    local Class<SFXPowerCustomActionBase> PowerClass;
    local SFXPawn_PlayerParty oPawn;
    local SFXPowerCustomActionBase oPower;
    
    oPawn = SFXPawn_PlayerParty(MyPawn);
    if (oPawn == None)
    {
        return;
    }
    foreach oPawn.SquadScreenPowerOrder(PowerClass, )
    {
        oPower = GetPowerByClass(PowerClass);
        if (oPower != None && oPower.DisplayInCharacterRecord)
        {
            PowerList.AddItem(oPower);
        }
    }
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        if (Powers[nIndex].DisplayInCharacterRecord && PowerList.Find(Powers[nIndex]) == -1)
        {
            PowerList.AddItem(Powers[nIndex]);
        }
    }
}
public function InitializeJoinInProgress()
{
    local SFXPowerCustomActionBase Power;
    
    foreach Powers(Power, )
    {
        Power.DoJoinInProgress();
    }
}
public function InitializePowerList()
{
    local BioCustomAction CustomAction;
    local SFXPowerCustomActionBase Power;
    local SFXPawn_PlayerParty oPlayerPartyPawn;
    local SFXEngine Engine;
    
    if (MyPawn == None)
    {
        return;
    }
    Powers.Length = 0;
    foreach MyPawn.PowerCustomActions(CustomAction, )
    {
        Power = SFXPowerCustomActionBase(CustomAction);
        if (Power != None)
        {
            Powers.AddItem(Power);
        }
    }
    oPlayerPartyPawn = SFXPawn_PlayerParty(MyPawn);
    if (oPlayerPartyPawn != None)
    {
        oPlayerPartyPawn.SetPowerStartingRanks();
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Engine != None && Engine.CurrentSaveGame != None)
        {
            Engine.CurrentSaveGame.LoadPawnPowers(MyPawn);
        }
    }
    foreach Powers(Power, )
    {
        Power.OnPowersLoaded();
    }
}
public function LoadPowers(out array<PowerSaveInfo> PowerList)
{
    local int nIndex;
    local int nIndex2;
    local SFXPowerCustomActionBase Power;
    local Class<SFXPowerCustomActionBase> PowerClass;
    local int EvolveChoice;
    local string PowerClassString;
    
    for (nIndex = 0; nIndex < PowerList.Length; nIndex++)
    {
        Power = None;
        PowerClass = None;
        PowerClassString = string(PowerList[nIndex].PowerClassName);
        PowerClass = Class<SFXPowerCustomActionBase>(FindObject(PowerClassString, Class'Class'));
        if (PowerClass != None)
        {
            Power = GetPowerByClass(PowerClass);
        }
        if (Power == None)
        {
            if (SFXPawn_Player(MyPawn) != None)
            {
                if (PowerClass == None)
                {
                    PowerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.GetSeekFreeObject(PowerClassString, Class'Class'));
                }
                if (PowerClass != None && PowerClass.default.IsBonusPower)
                {
                    Power = AddPower(PowerClass);
                }
            }
        }
        if (Power != None)
        {
            Power.ResetPower();
            Power.Rank = PowerList[nIndex].CurrentRank;
            Power.WheelDisplayIndex = PowerList[nIndex].WheelDisplayIndex;
            for (EvolveChoice = 1; EvolveChoice <= 3; EvolveChoice++)
            {
                for (nIndex2 = 0; nIndex2 < 6; nIndex2++)
                {
                    if (PowerList[nIndex].EvolvedChoices[nIndex2] == EvolveChoice)
                    {
                        Power.EvolvePower(byte(nIndex2));
                        break;
                    }
                }
            }
        }
    }
    if (MyPawn != None)
    {
        MyPawn.OnPowersLoaded();
    }
}
public function OnOwnerDestroyed()
{
    local SFXPowerCustomActionBase Power;
    
    foreach Powers(Power, )
    {
        Power.OnOwnerDestroyed();
    }
}
public final function OnPawnEquippedNewWeapon()
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomAction_PassivePower PassivePower;
    
    foreach Powers(Power, )
    {
        PassivePower = SFXPowerCustomAction_PassivePower(Power);
        if (PassivePower != None)
        {
            PassivePower.ApplyGlobalBonus();
        }
    }
}
public final function OnPawnLoadedWeapons()
{
    local SFXPowerCustomActionBase Power;
    
    foreach Powers(Power, )
    {
        if (Power != None)
        {
            Power.OnPawnLoadedWeapons();
        }
    }
}
public function PowerImpacted(SFXPowerCustomAction oPower)
{
    local delegate<OnPowerImpacted> oImpactedCallback;
    
    foreach PowerImpactedDelegates(oImpactedCallback, )
    {
        oImpactedCallback(oPower);
    }
}
public function PowerReleased(SFXPowerCustomAction oPower)
{
    local delegate<OnPowerReleased> oReleasedCallback;
    
    foreach PowerReleasedDelegates(oReleasedCallback, )
    {
        oReleasedCallback(oPower);
    }
}
public function ProcessWheelDisplayOrder()
{
    local int nPower;
    local int nSortedIndex;
    local int nHighIndex;
    local bool bAddToEnd;
    local array<int> aSortedIndices;
    
    nHighIndex = -1;
    for (nPower = 0; nPower < Powers.Length; ++nPower)
    {
        if (Powers[nPower].DisplayInHUD && Powers[nPower].IsEnabled())
        {
            bAddToEnd = TRUE;
            if (Powers[nPower].WheelDisplayIndex < nHighIndex)
            {
                for (nSortedIndex = 0; nSortedIndex < aSortedIndices.Length; ++nSortedIndex)
                {
                    if (Powers[aSortedIndices[nSortedIndex]].WheelDisplayIndex >= Powers[nPower].WheelDisplayIndex)
                    {
                        aSortedIndices.InsertItem(nSortedIndex, nPower);
                        bAddToEnd = FALSE;
                        break;
                    }
                }
            }
            if (bAddToEnd)
            {
                aSortedIndices.AddItem(nPower);
                nHighIndex = Powers[nPower].WheelDisplayIndex;
            }
        }
    }
    for (nHighIndex = 0; nHighIndex < aSortedIndices.Length; ++nHighIndex)
    {
        Powers[aSortedIndices[nHighIndex]].WheelDisplayIndex = nHighIndex;
    }
}
public function RefundAllTalentPoints()
{
    local int nIndex;
    local int nRankIndex;
    local SFXPowerCustomActionBase Power;
    local int TalentRefund;
    
    for (nIndex = Powers.Length - 1; nIndex >= 0; nIndex--)
    {
        Power = Powers[nIndex];
        if (Power != None && Power.DisplayInCharacterRecord)
        {
            for (nRankIndex = 0; float(nRankIndex) < Power.Rank; nRankIndex++)
            {
                TalentRefund += Power.RankCosts[nRankIndex];
            }
            Power.ResetPower();
        }
    }
    if (MyPawn != None)
    {
        MyPawn.AddTalentPoints(TalentRefund);
    }
}
public function RegisterBioticComboCallback(delegate<OnBioticCombo> oCallback)
{
    if (oCallback != None)
    {
        BioticComboDelegates.AddItem(oCallback);
    }
}
public function RegisterPowerImpactedCallback(delegate<OnPowerImpacted> oImpactedCallback)
{
    if (oImpactedCallback != None)
    {
        PowerImpactedDelegates.AddItem(oImpactedCallback);
    }
}
public function RegisterPowerReleasedCallback(delegate<OnPowerReleased> oReleasedCallback)
{
    if (oReleasedCallback != None)
    {
        PowerReleasedDelegates.AddItem(oReleasedCallback);
    }
}
public function bool RemovePower(Class<Object> PowerClass)
{
    local SFXPowerCustomActionBase Power;
    
    if (PowerClass == None)
    {
        return FALSE;
    }
    Power = GetPowerByClass(PowerClass);
    if (Power == None)
    {
        return FALSE;
    }
    Powers.RemoveItem(Power);
    if (MyPawn != None)
    {
        MyPawn.PowerCustomActionClasses[Power.PowerCustomActionID] = None;
        MyPawn.PowerCustomActions[Power.PowerCustomActionID] = None;
    }
    return TRUE;
}
public function SavePowers(out array<PowerSaveInfo> PowerList)
{
    local int nIndex;
    local int nIndex2;
    
    PowerList.Length = Powers.Length;
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        PowerList[nIndex].PowerName = Powers[nIndex].PowerName;
        PowerList[nIndex].CurrentRank = Powers[nIndex].Rank;
        for (nIndex2 = 0; nIndex2 < 6; nIndex2++)
        {
            PowerList[nIndex].EvolvedChoices[nIndex2] = Powers[nIndex].EvolvedChoices[nIndex2];
        }
        PowerList[nIndex].PowerClassName = Name(PathName(Powers[nIndex].Class));
        PowerList[nIndex].WheelDisplayIndex = Powers[nIndex].WheelDisplayIndex;
    }
}
public function SetSharedCooldown(float fCooldown)
{
    local SFXPowerCustomActionBase Power;
    
    if (SharedCooldownDisabled)
    {
        return;
    }
    foreach Powers(Power, )
    {
        if (Power.UsesSharedCooldown)
        {
            Power.CurrentCooldownTime = fCooldown;
            Power.TotalCooldownTime = fCooldown;
        }
    }
}
public function StartFirstTimeDelay()
{
    local SFXPowerCustomActionBase Power;
    local int nIndex;
    
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        Power = Powers[nIndex];
        if (Power != None && Power.DelayBeforeFirstUse > 0.0)
        {
            Power.TimeUntilNextUse = Power.DelayBeforeFirstUse;
        }
    }
}
public function UnregisterBioticComboCallback(delegate<OnBioticCombo> oCallback)
{
    BioticComboDelegates.RemoveItem(oCallback);
}
public function UnregisterPowerImpactedCallback(delegate<OnPowerImpacted> oImpactedCallback)
{
    PowerImpactedDelegates.RemoveItem(oImpactedCallback);
}
public function UnregisterPowerReleasedCallback(delegate<OnPowerReleased> oReleasedCallback)
{
    PowerReleasedDelegates.RemoveItem(oReleasedCallback);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RankUnlockText = $169080
    RequiredUnlockText = $169082
    LockedRankIcon = 28
    UnlockedRankIcon = 29
    EvolveRank = 4
    CooldownMethod = 1
    NumFreePowers = 2
}