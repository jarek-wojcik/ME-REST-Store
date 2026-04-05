Class SFXPawn_PlayerParty extends SFXPawn
    placeable
    abstract
    config(Game);

enum EHelmetStateController
{
    HSC_Kismet,
    HSC_Conversation,
    HSC_Cinematic,
    HSC_UserOptions_Default,
};
enum EHelmetState
{
    HS_Default,
    HS_ForcedOn,
    HS_ForcedOn_Full,
    HS_ForcedOff,
};
struct PowerStartingRank 
{
    var Class<SFXPowerCustomActionBase> PowerClass;
    var float Rank;
};
struct PowerAutoLevelUp 
{
    var(PowerAutoLevelUp) Class<SFXPowerCustomActionBase> PowerClass;
    var(PowerAutoLevelUp) float Rank;
    var(PowerAutoLevelUp) int EvolvedChoice;
};

var array<PowerUnlockRequirement> PowerUnlockRequirements;
var array<Class<SFXPowerCustomActionBase>> SquadScreenPowerOrder;
var array<PowerStartingRank> StartingPowerRanks;
var array<PowerAutoLevelUp> AutoLevelUpInfo;
var transient int CharacterLevel;
var(SFXPawn_PlayerParty) Actor UIWorldArchetype;
var config float fTimeToRevive;
var config float fPostResInvulnerability;
var config float fReviveRange;
var SFXPawn Reviver;
var(SFXPawn_PlayerParty) bool bHelmetHidesHead;
var(SFXPawn_PlayerParty) bool bHelmetHidesHair;
var(SFXPawn_PlayerParty) bool bHelmetAffectsVO;
var(SFXPawn_PlayerParty) bool bHelmetIsFull;
var bool bBeingRevived;
var bool bRecentlyResurrected;
var bool bDamagedHarvester;
var transient EHelmetState ForcedHelmetState[4];

public simulated function PostBeginPlay()
{
    local WwiseAudioComponent PawnAudioComponent;
    
    PawnAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Self);
    if (PawnAudioComponent != None)
    {
        SFXSetAudioComponentRTPCs(PawnAudioComponent);
    }
    InitDefaultHelmetState();
    Super.PostBeginPlay();
}
public event function bool Resurrect(float PercentOfHealthRegained, bool bIsInstantaneous)
{
    if (!Super(BioPawn).Resurrect(PercentOfHealthRegained, bIsInstantaneous))
    {
        return FALSE;
    }
    bRecentlyResurrected = TRUE;
    SetTimer(fPostResInvulnerability, FALSE, 'ResurrectionTimer', );
    return TRUE;
}
public event function SetRTPCHelmetIsEnabled(WwiseAudioComponent WwiseComponent)
{
    if (WwiseComponent != None)
    {
        if (m_oHeadGearMesh != None && m_oHeadGearMesh.SkeletalMesh != None && m_oHeadGearMesh.bAttached == TRUE && bHelmetAffectsVO)
        {
            WwiseComponent.SetWwiseRTPC("Pawn_Wearing_Helmet", 1.0);
        }
        else
        {
            WwiseComponent.SetWwiseRTPC("Pawn_Wearing_Helmet", 0.0);
        }
    }
}
public simulated function EPowerResistance GetPowerResistance(Pawn Caster, Vector HitLocation, Vector HitNormal, out float Damage, out Vector Force, Class<DamageType> DamageType, out Actor TargetOverride)
{
    return 1;
}
public function bool InGodMode()
{
    return bRecentlyResurrected || Super(Pawn).InGodMode();
}
public simulated function bool ModifyDamage(out float Damage, Vector Momentum, out DamageCalculationAlgorithm DamageCalc, const out TraceHitInfo HitInfo, Vector HitLocation, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser)
{
    local Vector InstigatorLocation;
    local SFXDifficultyHandler DH;
    local SFXGameConfig gameconfig;
    local SFXWeapon SourceWeapon;
    
    if (Super(BioPawn).ModifyDamage(Damage, Momentum, DamageCalc, HitInfo, HitLocation, DamageType, instigatedBy, DamageCauser) == FALSE)
    {
        return FALSE;
    }
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None)
    {
        if (IsInCover())
        {
            gameconfig = SFXGRI(WorldInfo.GRI).gameconfig;
            if (gameconfig.bCoverProtectedCone && IsInCoverLeaning() == FALSE && CurrentLink != None && CurrentLink.Slots[CurrentSlotIdx].bUnsafeCover == FALSE)
            {
                if (instigatedBy != None)
                {
                    InstigatorLocation = instigatedBy.Pawn.location;
                }
                else
                {
                    InstigatorLocation = DamageCauser.location;
                }
                if (DamageType.default.bIgnoresCoverDirection == FALSE && Normal(HitLocation - InstigatorLocation) Dot Vector(CurrentLink.GetSlotRotation(CurrentSlotIdx)) < -0.300000012 && VSize(HitLocation - InstigatorLocation) > 300.0)
                {
                    DamageCalc.Global_CoverMultiplier = 0.0 - DH.CoverDamageReduction;
                    if (SFXWeapon(DamageCauser) != None)
                    {
                        SourceWeapon = SFXWeapon(DamageCauser);
                    }
                    else if (SFXProjectile(DamageCauser) != None)
                    {
                        SourceWeapon = SFXWeapon(SFXProjectile(DamageCauser).ProjectileOwner);
                    }
                    if (SourceWeapon != None && SFXPlayerController(Controller) != None)
                    {
                        SFXPlayerController(Controller).OnCoverConeProtected(SourceWeapon);
                    }
                    if (SFXProjectile(DamageCauser) != None)
                    {
                        return FALSE;
                    }
                    if (DH.CoverDamageReduction == 1.0)
                    {
                        return FALSE;
                    }
                    return TRUE;
                }
            }
        }
        else
        {
            DamageCalc.Global_OutOfCoverMultiplier = DH.NoCoverDamageBonus;
        }
    }
    return TRUE;
}
public function ApplyAppropriateModsIfNoneExist(array<Name> PreviousWeaponNames);

public final function AttachHelmet(bool bAttachHelmet, optional bool bUpdateComponents = TRUE)
{
    local bool bHasValidHelmet;
    
    bHasValidHelmet = m_oHeadGearMesh != None && m_oHeadGearMesh.SkeletalMesh != None;
    if (bAttachHelmet && bHasValidHelmet)
    {
        if (m_oHeadGearMesh.bAttached == FALSE)
        {
            AttachComponent(m_oHeadGearMesh);
        }
        HeadMesh.SetHidden(bHelmetHidesHead);
        m_oHairMesh.SetHidden(bHelmetHidesHead || bHelmetHidesHair);
    }
    else
    {
        if (m_oHeadGearMesh != None && m_oHeadGearMesh.bAttached == TRUE)
        {
            DetachComponent(m_oHeadGearMesh);
        }
        HeadMesh.SetHidden(FALSE);
        m_oHairMesh.SetHidden(FALSE);
    }
    if (bUpdateComponents)
    {
        ForceUpdateComponents(TRUE, FALSE);
    }
}
public function AttemptKillingBlow(Pawn Killer);

public simulated function CollapseWeapon()
{
    local SFXWeapon Wpn;
    
    Wpn = SFXWeapon(Weapon);
    if (Wpn != None && Wpn.IsInState('WeaponPuttingDown', ))
    {
        Wpn.Collapse();
    }
}
public simulated function EnableUsage(bool enable)
{
    local SFXSimpleUseModule UseMod;
    
    UseMod = GetModule(Class'SFXSimpleUseModule');
    if (UseMod != None)
    {
        if (enable)
        {
            UseMod.SetTargetable(TRUE);
            UseMod.__OnUsed__Delegate = Used;
            UseMod.fUseRange = fReviveRange;
            UseMod.m_TargetTipText = ETargetTipText.TargetTipText_Revive;
        }
        else
        {
            UseMod.m_TargetTipText = ETargetTipText.TargetTipText_Talk;
            UseMod.SetTargetable(FALSE);
            UseMod.__OnUsed__Delegate = None;
        }
    }
}
public simulated function ExpandWeapon()
{
    local SFXWeapon Wpn;
    
    Wpn = SFXWeapon(Weapon);
    if (Wpn != None && Wpn.IsInState('WeaponEquipping', ))
    {
        Wpn.Expand();
    }
}
public simulated function FadeOutDrawAnim()
{
    local SFXWeapon ChkWeapon;
    
    ChkWeapon = SFXWeapon(Weapon);
    if (ChkWeapon != None)
    {
        ChkWeapon.EquipNearFinished();
        SetupWeaponAnimations(ChkWeapon, SFXWeapon(WeaponFromLastGameState));
    }
}
public simulated function FadeOutHolsterAnim()
{
    local SFXWeapon ChkWeapon;
    
    ChkWeapon = SFXWeapon(Weapon);
    if (ChkWeapon != None && InvManager.PendingWeapon != None)
    {
        ChkWeapon.UnEquipFinished();
    }
}
public final simulated function ForceSquadHelmet(EHelmetStateController InController, EHelmetState InState)
{
    local EHelmetState OriginalState;
    
    OriginalState = GetCurrentHelmetState();
    ForcedHelmetState[int(InController)] = InState;
    if (int(OriginalState) != int(GetCurrentHelmetState()))
    {
        RestoreDefaultHelmetState();
    }
}
public simulated function EHelmetState GetCurrentHelmetState()
{
    local int CurController;
    
    for (CurController = 0; CurController < 4; ++CurController)
    {
        if (int(ForcedHelmetState[CurController]) != 0)
        {
            return ForcedHelmetState[CurController];
        }
    }
    return EHelmetState.HS_Default;
}
public final simulated function SFXGUI_PlayerCountdown GetPlayerCountdownMovie(BioPlayerController BioPC)
{
    local SFXGUIInteraction SFXUIController;
    
    if (BioPC != None)
    {
        SFXUIController = BioPC.GetSFXUIController();
        return SFXUIController.CastGetMovie(Class'SFXGUI_PlayerCountdown', BioPC, SFXUIController.MovieTag_PlayerCountdown);
    }
    return None;
}
public function Name GetUIAppearanceTag()
{
    return 'None';
}
public simulated function InitDefaultHelmetState()
{
    local SFXPRI PRI;
    
    PRI = SFXPRI(WorldInfo.GetALocalPlayerController().PlayerReplicationInfo);
    if (PRI != None)
    {
        if (PRI.HenchmenHelmetPreference == EHenchHelmetOptions.HHO_DefaultOn || PRI.HenchmenHelmetPreference == EHenchHelmetOptions.HHO_ConversationOff)
        {
            ForcedHelmetState[3] = 1;
        }
        else if (PRI.HenchmenHelmetPreference == EHenchHelmetOptions.HHO_DefaultOff)
        {
            ForcedHelmetState[3] = 3;
        }
    }
    RestoreDefaultHelmetState();
}
public function InstancePrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    local Inventory Item;
    local Class<BioCustomAction> CustomActionClass;
    
    foreach InvManager.InventoryActors(Class'Inventory', Item)
    {
        if (SFXWeapon(Item) != None)
        {
            SFXWeapon(Item).Class.static.PrecacheVFX(ObjectPool, ClientEffects);
        }
        else if (SFXShield_Base(Item) != None)
        {
            SFXShield_Base(Item).Class.static.PrecacheVFX(ObjectPool, ClientEffects);
        }
    }
    foreach CustomActionClasses(CustomActionClass, )
    {
        CustomActionClass.static.PrecacheVFX(ObjectPool, ClientEffects);
    }
    foreach PowerCustomActionClasses(CustomActionClass, )
    {
        CustomActionClass.static.PrecacheVFX(ObjectPool, ClientEffects);
    }
    ClientEffects.PrimeClass(Class);
}
public function bool IsReadyForExecution(SFXPawn Killer);

public simulated function PlayerRevivedMessage();

public simulated function RestoreDefaultHelmetState(optional bool bForceUpdate = TRUE)
{
    local bool bShowHelmet;
    
    bShowHelmet = ShouldShowHelmet();
    AttachHelmet(bShowHelmet, bForceUpdate);
}
public function ResurrectionTimer()
{
    local SFXModule_GameEffectManager GEManager;
    local SFXDifficultyHandler DH;
    
    bRecentlyResurrected = FALSE;
    GEManager = GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager != None)
    {
        DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
        GEManager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', 'CADamageReduction', DH.ReviveDamageReductionLength, 1, -DH.ReviveDamageReductionAmount, Controller);
    }
}
public function SetExecutioner(Pawn Killer);

public simulated function SetPowerStartingRanks()
{
    local int nIndex;
    local SFXPowerCustomActionBase oPower;
    
    if (PowerManager != None)
    {
        for (nIndex = 0; nIndex < StartingPowerRanks.Length; nIndex++)
        {
            oPower = PowerManager.GetPowerByClass(StartingPowerRanks[nIndex].PowerClass);
            if (oPower != None && StartingPowerRanks[nIndex].Rank > oPower.Rank)
            {
                oPower.Rank = StartingPowerRanks[nIndex].Rank;
            }
        }
    }
}
public simulated function SetupWeaponAnimations(SFXWeapon NewWeapon, SFXWeapon OldWeapon, optional bool bDrawOnly)
{
    local AnimSet Set;
    
    Mesh.bDisableWarningWhenAnimNotFound = TRUE;
    if (!bDrawOnly)
    {
        if (OldWeapon != None && OldWeapon != NewWeapon)
        {
            if (OldWeapon.AnimType >= WeaponAnimType.WeaponAnimType_Pistol && int(OldWeapon.AnimType) < WeaponAnimSpecs.Length)
            {
                foreach WeaponAnimSpecs[int(OldWeapon.AnimType)].m_animSets(Set, )
                {
                    RmvAnimSet(Set);
                }
                if (OldWeapon.ReloadAnimInfo != None && OldWeapon.ReloadAnimInfo.AnimSet != None)
                {
                    RmvAnimSet(OldWeapon.ReloadAnimInfo.AnimSet);
                }
                RmvAnimSet(WeaponAnimSpecs[int(OldWeapon.AnimType)].m_drawAnimSet);
            }
        }
        if (NewWeapon != None)
        {
            if (NewWeapon.AnimType >= WeaponAnimType.WeaponAnimType_Pistol && int(NewWeapon.AnimType) < WeaponAnimSpecs.Length)
            {
                foreach WeaponAnimSpecs[int(NewWeapon.AnimType)].m_animSets(Set, )
                {
                    AddAnimSet(Set);
                }
                if (NewWeapon.ReloadAnimInfo != None && NewWeapon.ReloadAnimInfo.AnimSet != None)
                {
                    AddAnimSet(NewWeapon.ReloadAnimInfo.AnimSet);
                }
            }
        }
    }
    if (NewWeapon != None)
    {
        AddAnimSet(WeaponAnimSpecs[int(NewWeapon.AnimType)].m_drawAnimSet);
    }
    Super(BioPawn).SetupWeaponAnimations(NewWeapon, OldWeapon, bDrawOnly);
}
public simulated function ShieldsDown()
{
    local SFXModule_DamageParty DmgMod;
    
    DmgMod = GetModule(Class'SFXModule_DamageParty');
    if (DmgMod != None)
    {
        DmgMod.OnShieldBreached();
    }
}
public simulated function ShieldsUp()
{
    local SFXModule_DamagePlayer DmgMod;
    
    DmgMod = GetModule(Class'SFXModule_DamagePlayer');
    if (DmgMod != None)
    {
        DmgMod.CurrentBleedoutState = EBleedoutState.BleedOutState_None;
    }
}
public function bool ShouldShowHelmet()
{
    local EHelmetState CurHelmetState;
    
    CurHelmetState = GetCurrentHelmetState();
    if (CurHelmetState == EHelmetState.HS_ForcedOn_Full || CurHelmetState == EHelmetState.HS_ForcedOn)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function StartRevive(SFXPawn_PlayerParty TargetPawn)
{
    if (TargetPawn == None)
    {
        return;
    }
    if (SFXWeapon(Weapon) != None)
    {
        SFXWeapon(Weapon).CancelReload();
    }
    StopReloadWeapon();
    if (Role == ENetRole.ROLE_Authority)
    {
        StartCustomAction(5, TargetPawn);
    }
}
public simulated function SwapDrawAnim()
{
    local SFXWeapon NewWeapon;
    
    NewWeapon = SFXWeapon(Weapon);
    if (NewWeapon != None && NewWeapon.IsInState('WeaponEquipping', ))
    {
        NewWeapon.DetachWeapon();
        NewWeapon.AttachWeaponTo(Mesh, RightHandSocketName);
        SetupWeaponAnimations(NewWeapon, SFXWeapon(WeaponFromLastGameState), TRUE);
    }
}
public simulated function SwapHolsterAnim()
{
    local SFXWeapon ChkWeapon;
    
    ChkWeapon = SFXWeapon(Weapon);
    if (ChkWeapon != None && ChkWeapon.IsInState('WeaponPuttingDown', ))
    {
        ChkWeapon.DetachWeapon();
        ChkWeapon.AttachWeaponTo(Mesh, AttachSlots[int(ChkWeapon.CharacterSlot)]);
    }
}
public function TransferModsToNewWeapon(array<Name> PreviousWeaponNames, Name NewWeaponClass);

public function UpdateReviveHud(bool bSuccess, bool bReviverPawn)
{
    local SFXGUI_PlayerCountdown movie;
    
    if (Controller == None || Controller.IsLocalPlayerController() == FALSE)
    {
        return;
    }
    movie = GetPlayerCountdownMovie(BioPlayerController(Controller));
    if (movie != None)
    {
        if (bReviverPawn)
        {
            if (bSuccess)
            {
                movie.PlayAnimation(2, fTimeToRevive);
            }
            else
            {
                movie.AbortAnimation(2);
            }
        }
        else if (bSuccess)
        {
            movie.PauseAnimation(0);
            movie.PlayAnimation(1, fTimeToRevive);
        }
        else
        {
            movie.AbortAnimation(1);
            movie.ResumeAnimation(0);
        }
    }
}
public function Used(Actor User)
{
    local SFXPawn_PlayerParty PawnUser;
    
    PawnUser = SFXPawn_PlayerParty(User);
    if (PawnUser == None || bIsDowned == FALSE || bIsDead || Role != ENetRole.ROLE_Authority || PawnUser.IsDead() == TRUE)
    {
        return;
    }
    PawnUser.StartRevive(Self);
}

simulated state InRagdoll 
{
    public simulated function bool ShouldDieOnRagdoll()
    {
        if (bKillOnRagdoll)
        {
            return TRUE;
        }
        return FALSE;
    }
    
    stop;
};
simulated state Downed 
{
    public event simulated function EndState(Name NextStateName)
    {
        Super(BioPawn).EndState(NextStateName);
        EnableUsage(FALSE);
        SetCollision(default.bCollideActors, default.bBlockActors, );
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        local Class<SFXDamageType> DamageType;
        
        Super.BeginState(PreviousStateName);
        DamageType = Class<SFXDamageType>(KilledByDamageType);
        if (bIsDead == FALSE && (DamageType == None || DamageType.default.bMPKillDamage == FALSE))
        {
            EnableUsage(TRUE);
        }
        SetCollision(FALSE, FALSE, );
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
        MinTimeBetweenFullUpdates = 0.150000006
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
        RBCollideWithChannels = {Untitled4 = TRUE}
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=FootstepShakeFF0
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
    End Template
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
    End Template
    Begin Object Class=SFXModule_Locomotion Name=Locomotion0
    End Object
    Begin Template Class=SFXModule_Damage Name=DmgMod0
    End Template
    CharacterLevel = 1
    fTimeToRevive = 1.5
    fPostResInvulnerability = 4.0
    fReviveRange = 512.0
    bHelmetAffectsVO = TRUE
    FootstepForceFeedback = FootstepShakeFF0
    bLimitConsoleLOD = FALSE
    bCanDropAmmo = FALSE
    SupportedSyncActions = ('AtlasSync', 'PhantomSync', 'KaiLengSync', 'HuskSync', 'BruteSync', 'BansheeSync')
    CombatWalkSpeed = 130.0
    CombatGroundSpeed = 350.0
    CoverGroundSpeed = 375.0
    CoverCrouchGroundSpeed = 400.0
    StormSpeed = 700.0
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    PowerThreshold_Standard = 50.0
    PowerThreshold_Knockback = 400.0
    PowerManager = PowerMgr
    SupportsCombatGrammar = TRUE
    AccelRate = 1500.0
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               DmgMod0, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0, 
               Locomotion0
              )
    CollisionComponent = CollisionCylinder
    bIgnoreRigidBodyPawns = TRUE
}