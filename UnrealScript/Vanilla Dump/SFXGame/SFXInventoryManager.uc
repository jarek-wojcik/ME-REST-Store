Class SFXInventoryManager extends InventoryManager
    native
    nativereplication
    config(Weapon);

enum CREDCurveSet
{
    CREDCurve_NoReward,
    CREDCurve_Minor,
    CREDCurve_Small,
    CREDCurve_Medium,
    CREDCurve_Large,
    CREDCurve_Major,
};

var ScaledFloat MaxGrenadeBonus;
var Class<SFXWeapon> CurrentWeaponSelection;
var Rotator WeaponRecoilOffset;
var Rotator TotalRecoil;
var Rotator Drift;
var Rotator DriftTarget;
var(SFXInventoryManager) int Credits;
var(SFXInventoryManager) int Medigel;
var(SFXInventoryManager) int Grenades;
var(SFXInventoryManager) int Eezo;
var(SFXInventoryManager) int Iridium;
var(SFXInventoryManager) int Palladium;
var(SFXInventoryManager) int Platinum;
var(SFXInventoryManager) int Probes;
var(SFXInventoryManager) float CurrentFuel;
var config int MaxCredits;
var config int MaxEezo;
var config int MaxIridium;
var config int MaxPalladium;
var config int MaxPlatinum;
var config int MaxMedigel;
var config int MaxGrenades;
var config int MaxGrenadesMP;
var config int MaxProbes;
var config float MaxFuel;
var config float FuelEfficiency;
var config int ExtraMedigelPlotInt;
var float DriftPitch;
var float DriftYaw;
var float DriftInterpSpeed;
var float DriftInterpResetSize;
var float DriftInterpMinSize;
var float DriftNoiseMagPitch;
var float DriftNoiseMagYaw;
var float DriftRampUpRate;
var float DriftRampUpDelay;
var(SFXInventoryManager) Light AttachedFlashlight;
var(SFXInventoryManager) Light AttachedAmbientLight;
var RvrClientEffectInterface AttachedFlashlightVFX;
var(SFXInventoryManager) float AmbientLightCachedBrightness;
var(SFXInventoryManager) float FlashlightCachedBrightness;
var(SFXInventoryManager) float FlashlightCachedRadius;
var Color FlashlightCachedColor;
var Color AmbientLightCachedColor;
var repnotify int ReplicatedWeaponIndex;
var transient bool bWeaponFired;
var privatewrite bool bFlashlightAttached;
var bool bCanPickUpGrenades;

public simulated function Inventory CreateInventory(Class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local Inventory Inv;
    
    if (NewInventoryItemClass != None)
    {
        Inv = Spawn(NewInventoryItemClass, Instigator);
        if (Inv != None)
        {
            if (SFXWeapon(Inv) != None)
            {
                SFXWeapon(Inv).CharacterSlot = 5;
            }
            if (!AddInventory(Inv, bDoNotActivate))
            {
                Inv.Destroy();
                Inv = None;
            }
        }
    }
    return Inv;
}
public event function EmptyInventory()
{
    local Inventory oListItem;
    
    foreach InventoryActors(Class'Inventory', oListItem)
    {
        RemoveFromInventory(oListItem);
        oListItem.Destroy();
    }
}
public function float GetMaxFuel()
{
    return MaxFuel;
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Class'SFXGame'.static.ReCalculate(MaxGrenadeBonus);
}
public event simulated function ReplicatedEvent(Name VarName)
{
    Super(Actor).ReplicatedEvent(VarName);
    switch (VarName)
    {
        case 'ReplicatedWeaponIndex':
            ReplicatedWeaponUpdated();
            break;
        default:
    }
}
public simulated function SetWeaponFromSlot(EAttachSlot Slot)
{
    local SFXWeapon Weap;
    
    Weap = GetWeaponInSlot(Slot);
    if (Weap != None)
    {
        SetCurrentWeapon(Weap);
    }
}
public event simulated function bool SetWeaponImmediately(SFXWeapon WpnForSwitch)
{
    local SFXWeapon Wpn;
    local SFXWeapon LastWeapon;
    local SFXPawn_Player PlayerPawn;
    
    if (Instigator == None)
    {
        return FALSE;
    }
    LastWeapon = SFXWeapon(Instigator.Weapon);
    PlayerPawn = SFXPawn_Player(Instigator);
    if (PlayerPawn != None)
    {
        PlayerPawn.UpdatePrimaryAndSecondaryWeapons(Name(PathName(WpnForSwitch.Class)));
    }
    if (WpnForSwitch != None)
    {
        WpnForSwitch.bWeaponPutDown = FALSE;
        if (PlayerPawn != None)
        {
            LastWeapon = SFXWeapon(PlayerPawn.WeaponOnDeck);
        }
        WpnForSwitch.DetachWeapon();
        BioPawn(Instigator).EnableLeftHandIK();
    }
    else
    {
        BioPawn(Instigator).DisableLeftHandIK();
    }
    Wpn = SFXWeapon(Instigator.Weapon);
    if (Wpn != None)
    {
        Wpn.bInstantExpansion = TRUE;
        Wpn.Collapse();
        Wpn.GotoState('Inactive', , , );
        Wpn.DetachWeapon();
        if (GetWeaponInSlot(Wpn.AttachSlot, TRUE) == None)
        {
            Wpn.AssignToSlot(Wpn.AttachSlot);
        }
        BioPawn(Instigator).SetupWeaponAnimations(None, Wpn);
    }
    Instigator.Weapon = WpnForSwitch;
    if (WpnForSwitch != None)
    {
        BioPawn(Instigator).SetupWeaponAnimations(WpnForSwitch, None);
        WpnForSwitch.AttachWeaponTo(Instigator.Mesh, BioPawn(Instigator).RightHandSocketName);
        WpnForSwitch.bInstantExpansion = TRUE;
        WpnForSwitch.Expand();
        WpnForSwitch.Instigator = Instigator;
        WpnForSwitch.GotoState('Active', , , );
        CurrentWeaponSelection = WpnForSwitch.Class;
    }
    Instigator.PlayWeaponSwitch(Wpn, WpnForSwitch);
    if (Role == ENetRole.ROLE_Authority)
    {
        ReplicatedWeaponChange(WpnForSwitch, TRUE);
    }
    else if (Role == ENetRole.ROLE_AutonomousProxy)
    {
        ServerSetWeaponImmediately(WpnForSwitch);
    }
    if (PlayerPawn != None)
    {
        PlayerPawn.WeaponOnDeck = PlayerPawn.BackupWeapon(LastWeapon);
        PlayerPawn.UpdatePlayerLoadoutInfo();
        if (PlayerPawn.Controller != None)
        {
            BioPlayerController(PlayerPawn.Controller).SetZoomed(FALSE);
        }
    }
    return TRUE;
}
public function bool AwardResource(ETreasureType ttype, int nBudgetPercent, optional bool bAbsoluteAmount = FALSE, optional bool bIsSalvage = FALSE)
{
    local bool bResult;
    
    bResult = GiveCash(ttype, nBudgetPercent, bAbsoluteAmount, bIsSalvage);
    bResult = bResult || GiveAmmo(ttype, nBudgetPercent);
    bResult = bResult || GiveMediGel(ttype, nBudgetPercent, bAbsoluteAmount);
    bResult = bResult || GiveGrenades(ttype, nBudgetPercent, bAbsoluteAmount);
    return bResult;
}
public simulated function bool CancelWeaponChange()
{
    return FALSE;
}
public simulated function ChangedWeapon()
{
    local SFXWeapon Weapon;
    local BioPawn Pawn;
    
    Pawn = BioPawn(Instigator);
    if (Pawn != None)
    {
        Pawn.WeaponFromLastGameState = Instigator.Weapon;
        if (Pawn.Weapon != None && PendingWeapon != None)
        {
            Pawn.WeaponOnDeck = Instigator.Weapon;
        }
        if (BioPlayerController(Pawn.Controller) != None && BioPlayerController(Pawn.Controller).IsLocalPlayerController() && PendingWeapon != None)
        {
            BioPlayerController(Pawn.Controller).HintSystem.HintEvent('ChangeWeapon', PendingWeapon.Class.Name);
        }
    }
    Super.ChangedWeapon();
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon != None)
    {
        CurrentWeaponSelection = Weapon.Class;
    }
}
public simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local SFXWeapon Weapon;
    local Weapon BestWeapon;
    local Weapon BestDefaultWeapon;
    local float Rating;
    local float BestRating;
    local float BestDefaultRating;
    local SFXGRI GRI;
    
    if (WorldInfo == None)
    {
        return None;
    }
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI == None)
    {
        return None;
    }
    foreach InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (GRI.bIsMultiplayerCharacter || SFXPawn_Player(Owner) == None)
        {
            Rating = Weapon.WeaponLevel;
        }
        else
        {
            Rating = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponPriority(Weapon.Class);
        }
        if (BestDefaultWeapon == None || Rating > BestDefaultRating)
        {
            BestDefaultWeapon = Weapon;
            BestDefaultRating = Rating;
        }
        if (bForceADifferentWeapon && IsActiveWeapon(Weapon))
        {
            continue;
        }
        if (Weapon.HasAnyAmmo() && (BestWeapon == None || Rating > BestRating) && !Weapon.bQuickSwitchEligible)
        {
            BestWeapon = Weapon;
            BestRating = Rating;
        }
    }
    if (BestWeapon == None)
    {
        BestWeapon = BestDefaultWeapon;
    }
    return BestWeapon;
}
protected simulated function InternalSetCurrentWeapon(Weapon DesiredWeapon)
{
    local SFXPawn_Player Player;
    
    Player = SFXPawn_Player(Instigator);
    if (Player != None && DesiredWeapon != None)
    {
        Player.UpdatePrimaryAndSecondaryWeapons(Name(PathName(DesiredWeapon.Class)));
    }
    Super.InternalSetCurrentWeapon(DesiredWeapon);
}
public simulated function NextWeapon()
{
    local Weapon StartWeapon;
    local SFXWeapon CandidateWeapon;
    local SFXWeapon W;
    local bool bBreakNext;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != None)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(Class'SFXWeapon', W)
    {
        if ((W == None || W.bQuickSwitchEligible) && (bBreakNext || StartWeapon == None))
        {
            CandidateWeapon = W;
            break;
        }
        if (W == StartWeapon)
        {
            bBreakNext = TRUE;
        }
    }
    if (CandidateWeapon == None)
    {
        foreach InventoryActors(Class'SFXWeapon', W)
        {
            if (W == None || W.bQuickSwitchEligible)
            {
                CandidateWeapon = W;
                break;
            }
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}
public simulated function PrevWeapon()
{
    local Weapon StartWeapon;
    local SFXWeapon CandidateWeapon;
    local SFXWeapon W;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != None)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(Class'SFXWeapon', W)
    {
        if (W == StartWeapon)
        {
            break;
        }
        if (W == None || W.bQuickSwitchEligible)
        {
            CandidateWeapon = W;
        }
    }
    if (CandidateWeapon == None)
    {
        foreach InventoryActors(Class'SFXWeapon', W)
        {
            if (W == None || W.bQuickSwitchEligible)
            {
                CandidateWeapon = W;
            }
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}
public reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
    SetCurrentWeapon(DesiredWeapon);
}
public simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
    InternalSetCurrentWeapon(DesiredWeapon);
    if (Role == ENetRole.ROLE_Authority)
    {
        ReplicatedWeaponChange(DesiredWeapon, FALSE);
    }
    else if (Instigator != None)
    {
        if (Instigator.Role == ENetRole.ROLE_AutonomousProxy)
        {
            ServerSetCurrentWeapon(DesiredWeapon);
        }
    }
}
public simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon != None)
    {
        Weapon.RestoreFlashlightToNormal();
    }
    BioPawn(Instigator).WeaponOnDeck = DesiredWeapon;
    Super.SetPendingWeapon(DesiredWeapon);
}
public simulated function StartFire(byte FireModeNum)
{
    local SFXWeapon W;
    
    W = SFXWeapon(Instigator.Weapon);
    if (W != None)
    {
        if (int(FireModeNum) == 0)
        {
            FireModeNum = W.DefaultFireMode;
        }
        W.StartFire(FireModeNum);
    }
}
public simulated function StopFire(byte FireModeNum)
{
    local SFXWeapon W;
    
    W = SFXWeapon(Instigator.Weapon);
    if (W != None)
    {
        if (int(FireModeNum) == 0)
        {
            FireModeNum = W.DefaultFireMode;
        }
        W.StopFire(FireModeNum);
    }
}
public simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon);

public final function AddWeaponDynamicLights(Light oLight, optional Light oAmbientLight, optional RvrClientEffectInterface CE_WeaponEffect = None)
{
    local SpotLightComponent oSpotLightComp;
    local SFXWeapon Weapon;
    
    if (bFlashlightAttached)
    {
        return;
    }
    bFlashlightAttached = TRUE;
    if (oAmbientLight != None)
    {
        AttachedAmbientLight = oAmbientLight;
        AmbientLightCachedBrightness = oAmbientLight.LightComponent.Brightness;
        AmbientLightCachedColor = oAmbientLight.LightComponent.LightColor;
    }
    if (oLight != None)
    {
        AttachedFlashlight = oLight;
        AttachedFlashlightVFX = CE_WeaponEffect;
        oSpotLightComp = SpotLightComponent(oLight.LightComponent);
        if (oSpotLightComp != None)
        {
            FlashlightCachedBrightness = oSpotLightComp.Brightness;
            FlashlightCachedColor = oSpotLightComp.LightColor;
            FlashlightCachedRadius = oSpotLightComp.OuterConeAngle;
        }
        Weapon = SFXWeapon(Instigator.Weapon);
        if (Weapon != None)
        {
            Weapon.AttachFlashlight();
        }
    }
}
public function AdjustResource(EInventoryResourceTypes eInvResType, int Amount, optional bool bShowNotification, optional bool bIgnoreBudget = FALSE)
{
    local int DisplayAmount;
    local int NewAmount;
    local BioPlayerController PC;
    local array<TelemetryAttribute> aTelAttribs;
    local string sTelAttVal;
    local int nLogEventID;
    local BioRemoteLogger GLogger;
    
    if (Amount > 0)
    {
        BioWorldInfo(Instigator.WorldInfo).m_oTreasure.TriggerResourceHint(eInvResType, Amount);
    }
    switch (eInvResType)
    {
        case EInventoryResourceTypes.INV_RESOURCE_CREDITS:
            if (!bIgnoreBudget)
            {
                Amount = SFXGRI(Instigator.WorldInfo.GRI).gameconfig.RecordTreasure(0, Amount);
            }
            NewAmount = int(FMin(float(Credits + Amount), float(MaxCredits)));
            DisplayAmount = NewAmount - Credits;
            Credits = NewAmount;
            nLogEventID = 47;
            aTelAttribs.Add(2);
            sTelAttVal = "cchg";
            aTelAttribs[0].Type = ETelemetryAttributeType.AttributeType_Int;
            aTelAttribs[0].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
            aTelAttribs[0].nData = Amount;
            sTelAttVal = "cred";
            aTelAttribs[1].Type = ETelemetryAttributeType.AttributeType_Int;
            aTelAttribs[1].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
            aTelAttribs[1].nData = Credits;
            Class'SFXTelemetry'.static.SendArray('TelemetryHook_Credits', aTelAttribs);
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_CreditRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_MEDIGEL:
            if (Medigel == 0 && !SFXGRI(Instigator.WorldInfo.GRI).IsMultiplayerGame())
            {
                PC = BioPlayerController(Instigator.Controller);
                if (PC != None && PC.IsLocalPlayerController())
                {
                    PC.HintSystem.HintEvent('ReceivedFirstMedigel');
                }
            }
            NewAmount = int(FMin(float(Medigel + Amount), float(GetMaxMedigel())));
            DisplayAmount = NewAmount - Medigel;
            Medigel = NewAmount;
            nLogEventID = 46;
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_MedigelRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_GRENADES:
            if (Grenades == 0 && bCanPickUpGrenades && !SFXGRI(Instigator.WorldInfo.GRI).IsMultiplayerGame())
            {
                PC = BioPlayerController(Instigator.Controller);
                if (PC != None && PC.IsLocalPlayerController())
                {
                    PC.HintSystem.HintEvent('ReceivedFirstGrenade');
                }
            }
            NewAmount = int(FMin(float(Grenades + Amount), float(GetMaxGrenades())));
            DisplayAmount = NewAmount - Grenades;
            Grenades = NewAmount;
            nLogEventID = 83;
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO:
            if (!bIgnoreBudget)
            {
                Amount = SFXGRI(Instigator.WorldInfo.GRI).gameconfig.RecordTreasure(4, Amount);
            }
            NewAmount = int(FMin(float(Eezo + Amount), float(MaxEezo)));
            DisplayAmount = NewAmount - Eezo;
            Eezo = NewAmount;
            nLogEventID = 58;
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_ElementZeroRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM:
            if (!bIgnoreBudget)
            {
                Amount = SFXGRI(Instigator.WorldInfo.GRI).gameconfig.RecordTreasure(5, Amount);
            }
            NewAmount = int(FMin(float(Iridium + Amount), float(MaxIridium)));
            DisplayAmount = NewAmount - Iridium;
            Iridium = NewAmount;
            nLogEventID = 59;
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_IridiumRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM:
            if (!bIgnoreBudget)
            {
                Amount = SFXGRI(Instigator.WorldInfo.GRI).gameconfig.RecordTreasure(6, Amount);
            }
            NewAmount = int(FMin(float(Palladium + Amount), float(MaxPalladium)));
            DisplayAmount = NewAmount - Palladium;
            Palladium = NewAmount;
            nLogEventID = 60;
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_PalladiumRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM:
            if (!bIgnoreBudget)
            {
                Amount = SFXGRI(Instigator.WorldInfo.GRI).gameconfig.RecordTreasure(7, Amount);
            }
            NewAmount = int(FMin(float(Platinum + Amount), float(MaxPlatinum)));
            DisplayAmount = NewAmount - Platinum;
            Platinum = NewAmount;
            nLogEventID = 62;
            PC = BioPlayerController(Instigator.Controller);
            if (PC != None && bShowNotification)
            {
                PC.HintSystem.AddNotification_PlatinumRecovery(DisplayAmount);
            }
            break;
        case EInventoryResourceTypes.INV_RESOURCE_PROBES:
            NewAmount = int(FMin(float(Probes + Amount), float(GetMaxProbes())));
            DisplayAmount = NewAmount - Probes;
            Probes = NewAmount;
            nLogEventID = 64;
            break;
        default:
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None && nLogEventID != 0)
    {
        GLogger.SendMapEvent(nLogEventID, Instigator.location, "", string(eInvResType), "", "", Amount, NewAmount, 0, 0);
    }
}
public simulated function bool ApplySniperDrift(float DeltaTime)
{
    local SFXWeapon Weapon;
    local bool IsPitchPositive;
    
    if (DriftNoiseMagYaw == float(0) && DriftNoiseMagPitch == float(0))
    {
        return FALSE;
    }
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon == None || Weapon.IsZoomed() == FALSE)
    {
        DriftTarget.Pitch = 0;
        DriftTarget.Yaw = 0;
        DriftPitch = float(DriftTarget.Pitch);
        DriftYaw = float(DriftTarget.Yaw);
        DriftInterpSpeed = 0.0;
        return FALSE;
    }
    IsPitchPositive = DriftTarget.Pitch > 0;
    if (Abs(DriftPitch - float(DriftTarget.Pitch)) + Abs(DriftYaw - float(DriftTarget.Yaw)) < DriftInterpResetSize)
    {
        while (Abs(DriftPitch - float(DriftTarget.Pitch)) + Abs(DriftYaw - float(DriftTarget.Yaw)) < DriftInterpMinSize)
        {
            DriftTarget.Yaw = int((FRand() - 0.5) * DriftNoiseMagYaw);
            DriftTarget.Pitch = int(Abs((FRand() - 0.5) * DriftNoiseMagPitch));
            DriftTarget.Pitch = IsPitchPositive ? -1 * DriftTarget.Pitch : DriftTarget.Pitch;
            DriftInterpSpeed = 0.0;
            DriftRampUpDelay = default.DriftRampUpDelay;
        }
    }
    if (DeltaTime > float(0) && DriftInterpSpeed < default.DriftInterpSpeed)
    {
        if (DriftRampUpDelay > float(0))
        {
            DriftRampUpDelay -= DeltaTime;
        }
        else
        {
            DriftInterpSpeed += default.DriftInterpSpeed * DeltaTime * DriftRampUpRate;
            DriftInterpSpeed = FClamp(DriftInterpSpeed, 0.0, default.DriftInterpSpeed);
        }
    }
    DriftPitch = FInterpTo(DriftPitch, float(DriftTarget.Pitch), DeltaTime, DriftInterpSpeed);
    DriftYaw = FInterpTo(DriftYaw, float(DriftTarget.Yaw), DeltaTime, DriftInterpSpeed);
    Drift.Pitch = Round(DriftPitch);
    Drift.Yaw = Round(DriftYaw);
    return TRUE;
}
public simulated function Inventory GetInventoryByIndex(int Index)
{
    local int i;
    local Inventory InvIter;
    
    i = 0;
    InvIter = InventoryChain;
    while (InvIter != None)
    {
        if (Index == i)
        {
            return InvIter;
        }
        i++;
        InvIter = InvIter.Inventory;
    }
    return None;
}
public simulated function int GetInventoryIndex(Inventory oInventory)
{
    local int i;
    local Inventory InvIter;
    
    i = 0;
    InvIter = InventoryChain;
    while (InvIter != None)
    {
        if (oInventory == InvIter)
        {
            return i;
        }
        i++;
        InvIter = InvIter.Inventory;
    }
    return -1;
}
public simulated function int GetMaxGrenades()
{
    if (SFXGRI(Instigator.WorldInfo.GRI).IsMultiplayerGame())
    {
        return int(float(MaxGrenadesMP) + MaxGrenadeBonus.Value - 1.0);
    }
    else
    {
        return int(float(MaxGrenades) + MaxGrenadeBonus.Value - 1.0);
    }
}
public function int GetMaxMedigel()
{
    if (BioWorldInfo(Instigator.WorldInfo) != None)
    {
        return MaxMedigel + BioWorldInfo(Instigator.WorldInfo).GetGlobalVariables().GetInt(ExtraMedigelPlotInt);
    }
    return MaxMedigel;
}
public function int GetMaxProbes()
{
    return MaxProbes;
}
public simulated function int GetResource(EInventoryResourceTypes eInvResType)
{
    switch (eInvResType)
    {
        case EInventoryResourceTypes.INV_RESOURCE_CREDITS:
            return Credits;
        case EInventoryResourceTypes.INV_RESOURCE_MEDIGEL:
            return Medigel;
        case EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO:
            return Eezo;
        case EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM:
            return Iridium;
        case EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM:
            return Palladium;
        case EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM:
            return Platinum;
        case EInventoryResourceTypes.INV_RESOURCE_PROBES:
            return Probes;
        case EInventoryResourceTypes.INV_RESOURCE_GRENADES:
            return Grenades;
        case EInventoryResourceTypes.INV_RESOURCE_SALVAGE:
        default:
    }
    return 0;
}
public simulated function SFXWeapon GetWeaponByCategory(ELoadoutWeapons Slot, optional bool bIgnoreWielded)
{
    local SFXWeapon Weap;
    
    foreach InventoryActors(Class'SFXWeapon', Weap)
    {
        if (int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(Name(PathName(Weap.Class)))) == int(Slot))
        {
            if (!bIgnoreWielded || Weap != Instigator.Weapon)
            {
                return Weap;
            }
        }
    }
    return None;
}
public simulated function SFXWeapon GetWeaponInSlot(EAttachSlot Slot, optional bool bIgnoreWielded)
{
    local SFXWeapon Weap;
    
    foreach InventoryActors(Class'SFXWeapon', Weap)
    {
        if (int(Weap.CharacterSlot) == int(Slot))
        {
            if (!bIgnoreWielded || Weap != Instigator.Weapon)
            {
                return Weap;
            }
        }
    }
    return None;
}
public function bool GiveAmmo(ETreasureType ttype, int ResourceAmount)
{
    local SFXWeapon Weapon;
    
    if (ttype != ETreasureType.AMMO_TREASURE)
    {
        return FALSE;
    }
    foreach InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) == None)
        {
            Weapon.AddAmmo(Weapon.GetMaxSpareAmmo());
        }
    }
    return TRUE;
}
public function bool GiveCash(ETreasureType ttype, int nBudgetPercent, bool bAbsoluteAmount, bool bIsSalvage)
{
    local int nAmount;
    local bool bResult;
    local SFXGame Game;
    
    if (ttype != ETreasureType.CREDITS_TREASURE || nBudgetPercent <= 0)
    {
        return FALSE;
    }
    Game = SFXGame(WorldInfo.Game);
    if (Game == None)
    {
        return FALSE;
    }
    if (!bAbsoluteAmount)
    {
        nBudgetPercent = int(FClamp(float(nBudgetPercent) * 1.0, 0.0, 100.0));
    }
    nAmount = nBudgetPercent;
    if (bAbsoluteAmount)
    {
        bResult = Game.AwardCredits(nAmount);
    }
    else
    {
        bResult = Game.AwardCreditPercent(float(nAmount) / 100.0);
    }
    return bResult;
}
public function bool GiveGrenades(ETreasureType ttype, int ResourceAmount, bool bAbsoluteAmount)
{
    if (ttype != ETreasureType.GRENADE_TREASURE || ResourceAmount <= 0)
    {
        return FALSE;
    }
    if (!bAbsoluteAmount)
    {
        ResourceAmount = int(float(ResourceAmount) / 50.0);
        ResourceAmount = ResourceAmount <= 0 ? 1 : ResourceAmount;
    }
    if (GiveInventoryTreasure(3, ResourceAmount, FALSE, FALSE) > 0)
    {
        return TRUE;
    }
}
public function int GiveInventoryTreasure(EInventoryResourceTypes InvType, int Amount, optional bool bIsSalvage, optional bool bIgnoreBudget = FALSE)
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    local int nCurrentAmount;
    local int nGivenAmount;
    local bool bTickerResource;
    
    bTickerResource = InvType != EInventoryResourceTypes.INV_RESOURCE_CREDITS || bIsSalvage == FALSE;
    bTickerResource = bTickerResource && Amount > 0;
    oController = BioPlayerController(WorldInfo.GetALocalPlayerController());
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    nCurrentAmount = oInventory.GetResource(InvType);
    oInventory.AdjustResource(InvType, Amount, bTickerResource, bIgnoreBudget);
    nGivenAmount = oInventory.GetResource(InvType) - nCurrentAmount;
    if (bIsSalvage && Amount > 0 && InvType == EInventoryResourceTypes.INV_RESOURCE_CREDITS)
    {
        BioHintSystem(oController.HintSystem).AddNotification_SalvageRecovery(nGivenAmount);
        SFXPawn(oController.Pawn).StartCustomAction(4);
    }
    return nGivenAmount;
}
public function bool GiveMediGel(ETreasureType ttype, int ResourceAmount, bool bAbsoluteAmount)
{
    local int MedigelGranted;
    local BioPlayerController PC;
    local float XPForExcessMedigel;
    local SFXGame Game;
    local SFXGRI GRI;
    local SFXDifficultyHandler DH;
    
    if (WorldInfo == None || ttype != ETreasureType.MEDIGEL_TREASURE || ResourceAmount <= 0)
    {
        return FALSE;
    }
    Game = SFXGame(WorldInfo.Game);
    if (Game == None)
    {
        return FALSE;
    }
    GRI = SFXGRI(Game.GameReplicationInfo);
    if (GRI == None)
    {
        return FALSE;
    }
    DH = GRI.DifficultyHandler;
    if (DH == None)
    {
        return FALSE;
    }
    if (!bAbsoluteAmount)
    {
        ResourceAmount = int(float(ResourceAmount * 5) * 0.00999999978);
        ResourceAmount = ResourceAmount <= 0 ? 1 : ResourceAmount;
    }
    MedigelGranted = GiveInventoryTreasure(1, ResourceAmount, FALSE, FALSE);
    PC = BioPlayerController(SFXPawn_Player(Owner).Controller);
    if (MedigelGranted < ResourceAmount && PC != None)
    {
        XPForExcessMedigel = DH.GetFloat('XPForExcessMedigel', 'SPGlobal');
        PC.GrantXP(float((ResourceAmount - MedigelGranted)) * XPForExcessMedigel, FALSE);
        return TRUE;
    }
    if (MedigelGranted > 0)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function bool IsClientReadyToInitialize()
{
    local SFXWeapon Weapon;
    
    foreach InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (!Weapon.IsClientReadyToInitialize())
        {
            return FALSE;
        }
    }
    return TRUE;
}
public simulated function ProcessDamage(out float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser)
{
    local SFXShield_Base Shield;
    
    foreach InventoryActors(Class'SFXShield_Base', Shield)
    {
        Shield.ApplyDamage(Damage, HitInfo, HitLocation, Momentum, DamageType, instigatedBy, DamageCauser);
    }
}
public final function RemoveHeavyWeapons()
{
    local SFXHeavyWeapon HeavyWeapon;
    
    foreach InventoryActors(Class'SFXHeavyWeapon', HeavyWeapon)
    {
        RemoveFromInventory(HeavyWeapon);
        HeavyWeapon.Destroy();
    }
}
public final function RemoveWeaponDynamicLights()
{
    local SFXWeapon Weapon;
    
    if (!bFlashlightAttached)
    {
        return;
    }
    bFlashlightAttached = FALSE;
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon != None)
    {
        Weapon.DetachFlashlight();
    }
    if (AttachedAmbientLight != None)
    {
        AttachedAmbientLight.bEnabled = FALSE;
        AttachedAmbientLight = None;
    }
    if (AttachedFlashlight != None)
    {
        AttachedFlashlight.bEnabled = FALSE;
        AttachedFlashlight = None;
    }
    AttachedFlashlightVFX = None;
}
public function ReplicatedWeaponChange(Weapon NewWeapon, bool InstantSwitch)
{
    local int Index;
    
    Index = GetInventoryIndex(NewWeapon);
    if (Index != -1)
    {
        ReplicatedWeaponIndex = Index;
    }
}
public simulated function ReplicatedWeaponUpdated()
{
    local Inventory oInventory;
    local SFXWeapon oNewWeapon;
    
    oInventory = GetInventoryByIndex(ReplicatedWeaponIndex);
    if (Instigator == None || InventoryChain == None || oInventory == None)
    {
        if (!IsTimerActive('ReplicatedWeaponUpdated'))
        {
            SetTimer(0.100000001, TRUE, 'ReplicatedWeaponUpdated', );
        }
        return;
    }
    ClearTimer('ReplicatedWeaponUpdated');
    oNewWeapon = SFXWeapon(oInventory);
    if (oNewWeapon == None || oNewWeapon == Instigator.Weapon || oNewWeapon == PendingWeapon)
    {
        return;
    }
    InternalSetCurrentWeapon(oNewWeapon);
}
public reliable server function ServerSetWeaponImmediately(SFXWeapon WpnForSwitch)
{
    SetWeaponImmediately(WpnForSwitch);
}
public function SetMaxFuel(float F)
{
    MaxFuel = F;
}
public simulated function SetWeaponBySelected()
{
    local SFXWeapon Weap;
    local SFXWeapon WeapToSet;
    local BioPawn Pawn;
    
    foreach InventoryActors(Class'SFXWeapon', Weap)
    {
        if (ClassIsChildOf(Weap.Class, CurrentWeaponSelection))
        {
            if (WeapToSet == None || Weap.GetAIRating() > WeapToSet.GetAIRating())
            {
                WeapToSet = Weap;
            }
        }
    }
    if (WeapToSet == None)
    {
        WeapToSet = SFXWeapon(GetBestWeapon());
    }
    Pawn = BioPawn(Instigator);
    if (Pawn != None)
    {
        SetWeaponImmediately(WeapToSet);
    }
    else
    {
        SetCurrentWeapon(WeapToSet);
    }
}
public simulated function SetWeaponIfAvailable(SFXWeapon WeapToSwitch)
{
    local SFXWeapon Weap;
    
    foreach InventoryActors(Class'SFXWeapon', Weap)
    {
        if (Weap == WeapToSwitch)
        {
            SetCurrentWeapon(Weap);
            break;
        }
    }
}
public simulated function SetWeaponRecoil(float PitchRecoil)
{
    local float YawRecoil;
    local float BaseRecoilCap;
    local BioPawn Pawn;
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(Instigator.Weapon);
    Pawn = BioPawn(Instigator);
    if (Weapon == None || Pawn == None)
    {
        return;
    }
    YawRecoil = 0.0;
    if (Weapon.IsZoomed())
    {
        YawRecoil = 0.0;
    }
    YawRecoil += Sin(WorldInfo.GameTimeSeconds * Weapon.RecoilYawFrequency);
    YawRecoil *= PitchRecoil * Weapon.RecoilYawScale * 0.5;
    BaseRecoilCap = Weapon.RecoilCap * 182.044449;
    if (Weapon.IsZoomed())
    {
        BaseRecoilCap = Weapon.ZoomRecoilCap * 182.044449;
    }
    if (Abs(float(TotalRecoil.Yaw)) < BaseRecoilCap)
    {
        if (float(TotalRecoil.Yaw) + YawRecoil > BaseRecoilCap)
        {
            YawRecoil = BaseRecoilCap - float(TotalRecoil.Yaw);
        }
        WeaponRecoilOffset.Yaw += int(YawRecoil);
        TotalRecoil.Yaw += int(YawRecoil);
    }
    if (Abs(float(TotalRecoil.Pitch)) < BaseRecoilCap)
    {
        if (float(TotalRecoil.Pitch) + PitchRecoil > BaseRecoilCap)
        {
            PitchRecoil = BaseRecoilCap - float(TotalRecoil.Pitch);
        }
        WeaponRecoilOffset.Pitch += int(PitchRecoil);
        TotalRecoil.Pitch += int(PitchRecoil);
    }
}
public simulated function UpdateKickback(float DeltaTime, out Rotator out_DeltaRot)
{
    local Rotator DeltaRecoil;
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(Instigator.Weapon);
    if (WeaponRecoilOffset != rot(0, 0, 0))
    {
        DeltaRecoil.Pitch = int(float(WeaponRecoilOffset.Pitch) - FInterpTo(float(WeaponRecoilOffset.Pitch), 0.0, DeltaTime, Weapon.RecoilInterpSpeed));
        DeltaRecoil.Yaw = int(float(WeaponRecoilOffset.Yaw) - FInterpTo(float(WeaponRecoilOffset.Yaw), 0.0, DeltaTime, Weapon.RecoilInterpSpeed));
        if (DeltaRecoil == rot(0, 0, 0))
        {
            WeaponRecoilOffset.Yaw = 0;
            WeaponRecoilOffset.Pitch = 0;
            WeaponRecoilOffset.Roll = 0;
        }
        else
        {
            WeaponRecoilOffset -= DeltaRecoil;
            out_DeltaRot += DeltaRecoil;
        }
    }
}
public simulated function UpdateKickbackFade(float DeltaTime, out Rotator out_DeltaRot)
{
    local SFXWeapon Weapon;
    local Rotator DeltaRecoil;
    local float fFadeSpeed;
    local Rotator CurrentKickback;
    
    Weapon = SFXWeapon(Instigator.Weapon);
    if (Weapon == None)
    {
        return;
    }
    CurrentKickback = TotalRecoil - WeaponRecoilOffset;
    if (CurrentKickback == rot(0, 0, 0))
    {
        return;
    }
    fFadeSpeed = Weapon.IsZoomed() ? Weapon.RecoilZoomFadeSpeed : Weapon.RecoilFadeSpeed;
    fFadeSpeed = fFadeSpeed * Weapon.GetWeaponRecoil();
    fFadeSpeed = fFadeSpeed * 182.044449;
    fFadeSpeed = fFadeSpeed * Weapon.GetRateOfFire();
    fFadeSpeed = fFadeSpeed / float(60);
    DeltaRecoil.Pitch = int(fFadeSpeed * DeltaTime);
    DeltaRecoil.Pitch *= float((CurrentKickback.Pitch > 0 ? 1 : -1));
    DeltaRecoil.Yaw = 0;
    DeltaRecoil.Yaw = int(float(CurrentKickback.Yaw) - FInterpTo(float(CurrentKickback.Yaw), 0.0, DeltaTime, 5.0));
    if (CurrentKickback.Pitch >= 0)
    {
        DeltaRecoil.Pitch = int(FClamp(float(DeltaRecoil.Pitch), Weapon.RecoilMinFade * DeltaTime, float(CurrentKickback.Pitch)));
        DeltaRecoil.Pitch = int(FClamp(float(DeltaRecoil.Pitch), 0.0, float(CurrentKickback.Pitch)));
    }
    else
    {
        DeltaRecoil.Pitch = int(FClamp(float(DeltaRecoil.Pitch), float(CurrentKickback.Pitch), -1.0 * Weapon.RecoilMinFade * DeltaTime));
        DeltaRecoil.Pitch = int(FClamp(float(DeltaRecoil.Pitch), float(CurrentKickback.Pitch), 0.0));
    }
    if (CurrentKickback.Yaw >= 0)
    {
        DeltaRecoil.Yaw = int(FClamp(float(DeltaRecoil.Yaw), Weapon.RecoilMinFade * DeltaTime, float(CurrentKickback.Yaw)));
        DeltaRecoil.Yaw = int(FClamp(float(DeltaRecoil.Yaw), 0.0, float(CurrentKickback.Yaw)));
    }
    else
    {
        DeltaRecoil.Yaw = int(FClamp(float(DeltaRecoil.Yaw), float(CurrentKickback.Yaw), -1.0 * Weapon.RecoilMinFade * DeltaTime));
        DeltaRecoil.Yaw = int(FClamp(float(DeltaRecoil.Yaw), float(CurrentKickback.Yaw), 0.0));
    }
    if (DeltaRecoil == rot(0, 0, 0))
    {
        TotalRecoil.Yaw = 0;
        TotalRecoil.Pitch = 0;
        TotalRecoil.Roll = 0;
    }
    else
    {
        TotalRecoil -= DeltaRecoil;
        out_DeltaRot += DeltaRecoil;
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        Grenades, ReplicatedWeaponIndex;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxGrenadeBonus = {
                       Bonuses = (), 
                       X = 1.0, 
                       Y = 1.0, 
                       MaxLevel = 100, 
                       Level = 0, 
                       Value = 0.0, 
                       StaticBonus = 1.0
                      }
    Probes = 10
    MaxCredits = 9999999
    MaxEezo = 9999999
    MaxIridium = 9999999
    MaxPalladium = 9999999
    MaxPlatinum = 9999999
    MaxMedigel = 3
    MaxGrenades = 3
    MaxGrenadesMP = 1
    MaxProbes = 30
    MaxFuel = 1000.0
    FuelEfficiency = 1.5
    ExtraMedigelPlotInt = 10300
    DriftInterpSpeed = 3.0
    DriftInterpResetSize = 10.0
    DriftInterpMinSize = 50.0
    DriftRampUpRate = 0.400000006
    DriftRampUpDelay = 0.5
    ReplicatedWeaponIndex = -1
    PendingFire = (0, 0, 0, 0, 0)
    NetPriority = 2.20000005
    bOnlyRelevantToOwner = FALSE
    bAlwaysRelevant = TRUE
}