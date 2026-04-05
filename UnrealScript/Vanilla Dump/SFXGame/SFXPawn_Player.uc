Class SFXPawn_Player extends SFXPawn_PlayerParty
    placeable
    abstract
    config(Game);

struct ArmorEffectDescription 
{
    var string ArmorEffect;
    var array<stringref> EffectDescription;
    var array<string> EffectToken;
};
struct PermanentGameEffect 
{
    var string UniqueName;
    var string className;
    var float Value;
    var EPermanentGameEffect_Type Type;
    var EGAWAssetType GAWAssetType;
    var EGAWAssetSubType GAWAssetSubType;
};
enum EPermanentGameEffect_Type
{
    PermanentGEType_Player,
    PermanentGEType_Weapon,
    PermanentGEType_GAWAsset,
};
struct HelmetMetaData 
{
    var bool bHidesHead;
    var bool bHidesHair;
    var bool bAffectsVO;
};
struct CompositeSourceMeshes 
{
    var array<SkeletalMesh> Parts;
    var SkeletalMesh BaseMesh;
};

var ScaledFloat WeaponEncumbranceModifiers[6];
var transient MorphHeadSaveRecord PendingMorphHeadData;
var(SFXPawn_Player) string firstName;
var(SFXPawn_Player) string PlayerClassName;
var(SFXPawn_Player) string faceCode;
var transient string m_sWwiseRTPCNameUseCasual;
var editinline transient export array<SkeletalMeshComponent> AsyncAppearanceMeshes;
var config array<PermanentGameEffect> PermanentGameEffects;
var array<SFXGameEffect> EncumbranceCapacityBonuses;
var transient array<SFXAsyncAssetRequest> PendingMorphHeadResources;
var config array<ArmorEffectDescription> ArmorEffectDescriptions;
var delegate<AsyncUpdating_OnCompleted> __AsyncUpdating_OnCompleted__Delegate;
var(SFXPawn_Player) ScreenShakeStruct HitShake;
var(SFXPawn_Player) ScreenShakeStruct ZoomHitShake;
var ScreenShakeStruct CoverShake;
var(SFXPawn_Player) Guid CharacterGUID;
var Vector CamperAverageLoc;
var transient Name AsyncGroupName;
var Name PermanentGameEffect_CategoryPrefix;
var Name EncumbranceEffectName;
var Name PrimaryWeapon;
var Name SecondaryWeapon;
var config Vector2D PopUpDamageMultiplier;
var(SFXPawn_Player) int CasualID;
var(SFXPawn_Player) transient int OverrideCasualID;
var(SFXPawn_Player) int FullBodyID;
var(SFXPawn_Player) int TorsoID;
var(SFXPawn_Player) int ShoulderID;
var(SFXPawn_Player) int ArmID;
var(SFXPawn_Player) int LegID;
var(SFXPawn_Player) int SpecID;
var(SFXPawn_Player) int Tint1ID;
var(SFXPawn_Player) int Tint2ID;
var(SFXPawn_Player) int PatternID;
var(SFXPawn_Player) int PatternColorID;
var(SFXPawn_Player) int HelmetID;
var(SFXPawn_Player) int EmissiveID;
var(SFXPawn_Player) SFXVocalizationBank PlayerCombatVoc;
var(SFXPawn_Player) SFXVocalizationBank PlayerExplorationVoc;
var(SFXPawn_Player) SFXVocalizationBank PlayerStealthVoc;
var(SFXPawn_Player) SFXVocalizationBank GenericPlayerCombatVoc;
var(SFXPawn_Player) transient int OverrideHelmetID;
var transient SkeletalMesh BaseHelmetMesh;
var transient HelmetMetaData BaseHelmetData;
var transient SkeletalMesh OverrideHelmetMesh;
var transient HelmetMetaData OverrideHelmetData;
var(SFXPawn_Player) PhysicsAsset MalePhys;
var(SFXPawn_Player) PhysicsAsset FemalePhys;
var(SFXPawn_Player) SFXCharacterClass PlayerClass;
var transient float OutOfAmmoTimestamp;
var config float OutOfAmmoSwapThreshold;
var WwiseEvent ShieldImpactSound;
var WwiseEvent ImpactSound;
var(SFXPawn_Player) transient float TotalXP;
var(SFXPawn_Player) Texture2D m_GUI_Icon;
var int CampingTickCounter;
var float CampingTolerance;
var float CamperBusterDelay;
var float EncumbranceCapacity;
var float EncumbranceMinCooldown;
var float EncumbranceMaxCooldown;
var repnotify float CurrentWeaponEncumbrance;
var WwiseEvent EnterCoverSound;
var WwiseEvent EnterCoverVoc;
var ForceFeedbackWaveform CoverForceFeedback;
var WwiseEvent CoverEnterFoleySound;
var float LastCoverEnterDistance;
var config float PopUpDamageMultiplierDuration;
var config int MaxTotalReputation;
var config float ParagonScarBias;
var config float FullParagonScarBiasValue;
var config float NoParagonScarBiasValue;
var(SFXPawn_Player) bool bUseCasualAppearance;
var transient bool bUsingOverrideHelmet;
var transient bool bFullHelmetRequired;
var transient bool bIsFullAmmo;
var transient bool bOverrideHideScars;
var(SFXPawn_Player) bool bIgnoreHeadOffsetsInMeshMerge;
var transient bool bInPersonalization;
var transient bool bAsyncUpdatingAppearance;
var transient bool bCanRoll;
var transient bool bCanBeStopped;
var transient bool bHasPendingSavedMorphHead;
var transient bool bHasPendingExistingMorphHead;
var(SFXPawn_Player) EPlayerAppearanceType CombatAppearance;
var(SFXPawn_Player) EOriginType Origin;
var(SFXPawn_Player) ENotorietyType Notoriety;

public simulated function BioBaseRemovedFromWorld()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        appScreenDebugMessage("Player lost the floor it was standing on.");
    }
}
public event function CollectAnimListForCooking(BioPawn Pawn, out array<Name> OutResults)
{
    Super(BioPawn).CollectAnimListForCooking(Pawn, OutResults);
    if (SFXPawn_Player(Pawn) != None && SFXPawn_Player(Pawn).PlayerClass != None)
    {
        SFXPawn_Player(Pawn).PlayerClass.CollectAnimListForCooking(OutResults);
    }
}
public simulated function CopyPawnAppearance(BioPawn SourcePawn)
{
    local SFXPawn_Player SourcePlayer;
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase Power2;
    
    Super(BioPawn).CopyPawnAppearance(SourcePawn);
    SourcePlayer = SFXPawn_Player(SourcePawn);
    if (SourcePlayer != None)
    {
        SourcePlayer.UpdateAppearance();
        CombatAppearance = SourcePlayer.CombatAppearance;
        CasualID = SourcePlayer.CasualID;
        FullBodyID = SourcePlayer.FullBodyID;
        TorsoID = SourcePlayer.TorsoID;
        ShoulderID = SourcePlayer.ShoulderID;
        ArmID = SourcePlayer.ArmID;
        LegID = SourcePlayer.LegID;
        SpecID = SourcePlayer.SpecID;
        Tint1ID = SourcePlayer.Tint1ID;
        Tint2ID = SourcePlayer.Tint2ID;
        PatternID = SourcePlayer.PatternID;
        PatternColorID = SourcePlayer.PatternColorID;
        HelmetID = SourcePlayer.HelmetID;
        EmissiveID = SourcePlayer.EmissiveID;
        if (SourcePawn.PowerManager != None && PowerManager != None)
        {
            foreach SourcePawn.PowerManager.Powers(Power, )
            {
                if (SFXPowerCustomAction_ParagonRenegade(Power) != None)
                {
                    foreach PowerManager.Powers(Power2, )
                    {
                        if (Power.Class == Power2.Class)
                        {
                            Power2.Rank = Power.Rank;
                        }
                    }
                }
            }
        }
        UpdateAppearance();
    }
}
public simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        KillAndFreeze(LastHitBy, dmgType, "FellOutOfWorld");
    }
}
public function Texture2D GetGUIIcon()
{
    return m_GUI_Icon;
}
public function bool IsTestFrameworkSetupComplete()
{
    return TRUE;
}
public function NotifyFinishedCoverAlign()
{
    local SFXPlayerController MyPlayerController;
    
    Super(BioPawn).NotifyFinishedCoverAlign();
    if (IsLocallyControlled())
    {
        MyPlayerController = SFXPlayerController(Controller);
        if (MyPlayerController != None)
        {
            MyPlayerController.CheckQuickCoverAction();
        }
        PlayCoverPresentation();
    }
}
public simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        KillAndFreeze(LastHitBy, None, "OutsideWorldBounds");
    }
}
public simulated function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, Pawn DamageCauser)
{
    local Pawn InstigatorPawn;
    local Class<SFXDamageType> DmgTypeClass;
    local SFXPlayerController PC;
    local ScreenShakeStruct Shake;
    local float ShakeScale;
    local SFXGRI GRI;
    
    GRI = SFXGRI(WorldInfo.GRI);
    Super(SFXPawn).PlayHit(Damage, instigatedBy, HitLocation, DamageType, Momentum, HitInfo, DamageCauser);
    InstigatorPawn = FindAttackingPawn(instigatedBy, DamageCauser);
    PC = DrivenVehicle != None ? SFXPlayerController(DrivenVehicle.Controller) : SFXPlayerController(Controller);
    DmgTypeClass = Class<SFXDamageType>(DamageType);
    if (GRI != None)
    {
        if (DmgTypeClass != None && DmgTypeClass.default.bIsMelee)
        {
            GRI.TriggerVocalizationEvent(95, Self);
        }
        if (!HasAnyShieldResistance())
        {
            GRI.TriggerVocalizationEvent(27, Self);
        }
        if (SFXPawn_Player(DamageCauser) != None)
        {
            GRI.TriggerVocalizationEvent(81, Self);
        }
    }
    if (PC != None && IsLocallyControlled() && DmgTypeClass != None)
    {
        if (DmgTypeClass.default.CE_PlayerFrameBufferEffect != None)
        {
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(DmgTypeClass.default.CE_PlayerFrameBufferEffect, Self);
        }
        if (ClassIsChildOf(DamageType, Class'SFXDamageType_Weapon'))
        {
            if (HasAnyShieldResistance())
            {
                PC.ClientPlayForceFeedbackWaveform(DmgTypeClass.default.ShieldHitFFWaveform);
                PC.PlaySound(ShieldImpactSound, TRUE);
            }
            else
            {
                PC.ClientPlayForceFeedbackWaveform(DmgTypeClass.default.DamagedFFWaveform);
                PC.PlaySound(ImpactSound, TRUE);
            }
            if (InstigatorPawn != None && InstigatorPawn.IsHostile(PC.Pawn))
            {
                PC.QueueDamageIndicator(InstigatorPawn);
            }
        }
        if (!DmgTypeClass.default.bNoShake)
        {
            if (PC.IsZoomed() == FALSE)
            {
                Shake = HitShake;
            }
            else
            {
                Shake = ZoomHitShake;
            }
            ShakeScale = 1.0;
            if (SFXWeapon(Weapon) != None)
            {
                ShakeScale = SFXWeapon(Weapon).ZoomDamageShakeModifier.Value;
            }
            if (ShakeScale != 1.0)
            {
                Shake.RotAmplitude *= ShakeScale;
                Shake.LocAmplitude *= ShakeScale;
                Shake.FOVAmplitude *= ShakeScale;
                Shake.RotFrequency *= ShakeScale;
            }
            SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(Shake);
        }
    }
}
public simulated function PostBeginPlay()
{
    if (SFXGRI(WorldInfo.GRI).bMultiplayer == FALSE)
    {
        SetTimer(1.25, FALSE, 'ApplyBonuses', );
        SetTimer(CamperBusterDelay, TRUE, 'SPCamperBuster', );
    }
    Loadout = PlayerClass.Loadout;
    SetTimer(1.0, FALSE, 'AutoMap', );
    Super.PostBeginPlay();
    SetTimer(0.5, FALSE, 'InitializePlayerVoc', );
}
public simulated function PreClientTravel();

public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'CurrentWeaponEncumbrance':
            ApplyWeaponEncumbrance();
            break;
        default:
            Super(SFXPawn).ReplicatedEvent(VarName);
            break;
    }
}
public simulated function SyncPawnAppearance(BioPawn SourcePawn)
{
    local SFXPawn_Player SourcePlayer;
    
    SourcePlayer = SFXPawn_Player(SourcePawn);
    if (SourcePlayer != None)
    {
        bUseCasualAppearance = SourcePlayer.bUseCasualAppearance;
    }
    Super(BioPawn).SyncPawnAppearance(SourcePawn);
}
public simulated function UpdateAppearance()
{
    UpdateAppearanceAsync(None, TRUE);
}
private final simulated function ApplyAppearance()
{
    ValidateAppearanceIDs();
    UpdateHeadAppearance();
    UpdateHairAppearance();
    UpdateBodyAppearance();
    UpdateParameters();
    ForceUpdateComponents(TRUE, FALSE);
    UpdateGameEffects();
    if (bAsyncUpdatingAppearance && !bInPersonalization)
    {
        BlockForTextureStreaming();
    }
    CacheCrucialAnimNodes();
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    if (IsInCover == TRUE)
    {
        Force = vect(0.0, 0.0, 0.0);
    }
    return Super(SFXPawn).ImpactWithPower(Resistance, Caster, HitLocation, HitNormal, Damage, Force, DamageType);
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    local BioRemoteLogger Logger;
    
    Logger = Class'BioRemoteLogger'.static.GetLogger();
    if (Logger != None && IsHumanControlled())
    {
        Logger.SendMapEvent(101, Killer.location, string(Killer.Name), "", "", "", 0, 0, 0, 0);
    }
    return Super(SFXPawn).Died(Killer, DamageType, HitLocation);
}
public simulated function HandleMomentum(Vector Momentum, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local float Force;
    local SFXDifficultyHandler DH;
    local Vector VelDir;
    local Vector MomDir;
    
    if (Physics == EPhysics.PHYS_Walking && CurrentCustomAction == 0 && IsInCover() == FALSE && bCanBeStopped && !IsInAnimatedTransition() && bStorming == FALSE && InGodMode() == FALSE)
    {
        DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
        if (bIgnoreForces || DH.StoppingPowerScalar <= 0.0 || Momentum == vect(0.0, 0.0, 0.0))
        {
            return;
        }
        Momentum *= DH.StoppingPowerScalar;
        Force = VSize(Velocity);
        if (VSize(Momentum) > Force)
        {
            Momentum = Normal(Momentum) * Force;
        }
        if (Velocity.Z > default.JumpZ && Momentum.Z > float(0))
        {
            Momentum.Z *= 0.5;
        }
        VelDir = Normal(Velocity);
        MomDir = -Normal(Momentum);
        if (MomDir Dot VelDir >= 0.0)
        {
            Velocity -= Velocity * (MomDir Dot VelDir);
        }
    }
}
public simulated function bool ModifyDamage(out float Damage, Vector Momentum, out DamageCalculationAlgorithm DamageCalc, const out TraceHitInfo HitInfo, Vector HitLocation, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser)
{
    local Pawn DamageCauserPawn;
    local float fTimeSinceStart;
    
    if (Super.ModifyDamage(Damage, Momentum, DamageCalc, HitInfo, HitLocation, DamageType, instigatedBy, DamageCauser) == FALSE)
    {
        return FALSE;
    }
    DamageCauserPawn = Class'BioPawn'.static.FindAttackingPawn(instigatedBy, DamageCauser);
    if (DamageCauserPawn != None && DamageCauserPawn.IsPlayerPawn())
    {
        return FALSE;
    }
    fTimeSinceStart = WorldInfo.GameTimeSeconds - LastPopOutOfCoverTime;
    if (fTimeSinceStart < PopUpDamageMultiplierDuration)
    {
        DamageCalc.Global_PlayerPopupMultiplier = Lerp(PopUpDamageMultiplier.X, PopUpDamageMultiplier.Y, fTimeSinceStart / PopUpDamageMultiplierDuration);
    }
    return TRUE;
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    local PlayerController PC;
    
    Super(SFXPawn).PlayDying(DamageType, HitLoc);
    PC = PlayerController(Controller);
    if (PC != None && IsLocallyControlled())
    {
        PC.ClientPlayForceFeedbackWaveform(DamageType.default.KilledFFWaveform);
    }
}
public function PossessedBy(Controller C, bool bVehicleTransition)
{
    local SFXModule_GameEffectManager Manager;
    
    Super(BioPawn).PossessedBy(C, bVehicleTransition);
    if (!bVehicleTransition)
    {
        Manager = GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.RemoveEffectsByCategory('PersonalizationEffects');
        }
        UpdateGameEffects();
    }
}
public simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local Vector CamRot;
    local Vector CamCross;
    local Vector PlayerRot;
    local float CamDot;
    local float Angle;
    local BioPlayerController PC;
    
    Super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    if (IsInCover())
    {
        CamRot = Vector(out_ViewRotation);
        PlayerRot = Vector(Rotation);
        CamRot.Z = 0.0;
        PlayerRot.Z = 0.0;
        CamRot = Normal(CamRot);
        PlayerRot = Normal(PlayerRot);
        CamDot = CamRot Dot PlayerRot;
        CamCross = PlayerRot Cross CamRot;
        Angle = CoverType == ECoverType.CT_Standing ? 0.899999976 : 0.879999995;
        PC = BioPlayerController(Controller);
        if (PC != None && PC.IsZoomed())
        {
            Angle -= 0.100000001;
        }
        if (IsAtLeftEdgeSlot() && (CoverAction == ECoverAction.CA_LeanLeft || CoverAction == ECoverAction.CA_BlindLeft))
        {
            if (CamDot < Angle && CamCross.Z > float(0))
            {
                if (CoverType == ECoverType.CT_MidLevel)
                {
                    if (int(BioPlayerInput(PlayerController(Controller).PlayerInput).bWantsToZoom) != 0)
                    {
                        CoverAction = ECoverAction.CA_PopUp;
                    }
                    else
                    {
                        CoverAction = ECoverAction.CA_BlindUp;
                    }
                }
            }
        }
        else if (IsAtRightEdgeSlot() && (CoverAction == ECoverAction.CA_LeanRight || CoverAction == ECoverAction.CA_BlindRight))
        {
            if (CamDot < Angle && CamCross.Z < float(0))
            {
                if (CoverType == ECoverType.CT_MidLevel)
                {
                    if (int(BioPlayerInput(PlayerController(Controller).PlayerInput).bWantsToZoom) != 0)
                    {
                        CoverAction = ECoverAction.CA_PopUp;
                    }
                    else
                    {
                        CoverAction = ECoverAction.CA_BlindUp;
                    }
                }
            }
        }
    }
}
public final simulated function AbortAsyncUpdateAppearance()
{
    ClearAsyncAssetLoader();
}
private final function SkeletalMeshComponent AddMeshForTexturePrestream(SkeletalMesh PrestreamMesh)
{
    local SkeletalMeshComponent NewComponent;
    
    NewComponent = new (Self) Class'SkeletalMeshComponent';
    NewComponent.SetHidden(TRUE);
    NewComponent.SetSkeletalMesh(PrestreamMesh);
    AttachComponent(NewComponent);
    AsyncAppearanceMeshes.AddItem(NewComponent);
    return NewComponent;
}
public function AddPlayerInventory()
{
    local SFXInventoryManager InventoryManager;
    local SFXWeapon ChkWeapon;
    
    InventoryManager = SFXInventoryManager(InvManager);
    if (InventoryManager != None)
    {
        CreateWeapons(Loadout);
        ScaleWeapons(Loadout, GetScaledLevel());
        foreach InventoryManager.InventoryActors(Class'SFXWeapon', ChkWeapon)
        {
            if (InventoryManager.CurrentWeaponSelection == None)
            {
                InventoryManager.CurrentWeaponSelection = ChkWeapon.Class;
            }
            else if (WeaponOnDeck == None)
            {
                WeaponOnDeck = ChkWeapon;
            }
        }
        if (bCombatPawn)
        {
            InventoryManager.SetWeaponBySelected();
        }
    }
}
public final function AddWeaponEncumbranceBonus(SFXGameEffect Bonus)
{
    local SFXGameEffect Effect;
    local float fBonus;
    
    if (Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (EncumbranceCapacityBonuses.Find(Bonus) == -1)
    {
        EncumbranceCapacityBonuses.AddItem(Bonus);
        foreach EncumbranceCapacityBonuses(Effect, )
        {
            fBonus += Effect.EffectValue;
        }
        EncumbranceCapacity = PlayerClass.StartingEncumbranceCapacity + fBonus;
        UpdateWeaponEncumbrance();
    }
}
public function ApplyAppropriateModsIfNoneExist(array<Name> PreviousWeaponNames)
{
    local SFXWeapon ChkWeapon;
    local SFXModule_WeaponModManager ModManager;
    local Name PreviousWeaponName;
    local Name ChkWeaponClassName;
    local SFXEngine Eng;
    local int idx;
    local int Idx2;
    local WeaponModSaveRecord NewRecord;
    local bool bAppliedMods;
    local Class<SFXWeaponMod> ModClass;
    local int ModLevel;
    
    if (InvManager == None)
    {
        return;
    }
    Eng = Class'SFXEngine'.static.GetSFXEngine();
    if (Eng == None)
    {
        return;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', ChkWeapon)
    {
        ModManager = ChkWeapon.GetModule(Class'SFXModule_WeaponModManager');
        if (ModManager == None)
        {
            continue;
        }
        if (ModManager.WeaponMods.Length > 0)
        {
            continue;
        }
        ChkWeaponClassName = Name(PathName(ChkWeapon.Class));
        bAppliedMods = FALSE;
        foreach PreviousWeaponNames(PreviousWeaponName, )
        {
            if (int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(PreviousWeaponName)) != int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(ChkWeaponClassName)))
            {
                continue;
            }
            idx = Eng.PlayerWeaponMods.Find('WeaponClassName', PreviousWeaponName);
            if (idx < 0)
            {
                continue;
            }
            else
            {
                bAppliedMods = TRUE;
                for (Idx2 = 0; Idx2 < Eng.PlayerWeaponMods[idx].WeaponModClassNames.Length; Idx2++)
                {
                    ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(Eng.PlayerWeaponMods[idx].WeaponModClassNames[Idx2]));
                    if (ModClass.static.IsUnlocked(ModLevel))
                    {
                        ModManager.AddMod(ModClass, ModLevel);
                    }
                }
                Idx2 = Eng.PlayerWeaponMods.Find('WeaponClassName', Name(PathName(ChkWeapon.Class)));
                if (Idx2 < 0)
                {
                    NewRecord.WeaponClassName = Name(PathName(ChkWeapon.Class));
                    NewRecord.WeaponModClassNames = Eng.PlayerWeaponMods[idx].WeaponModClassNames;
                    Eng.PlayerWeaponMods.AddItem(NewRecord);
                }
            }
        }
        if (!bAppliedMods)
        {
            ChkWeapon.ApplyDefaultWeaponMods();
        }
        else if (ModManager != None)
        {
            ModManager.SetWeaponModHidden(FALSE);
        }
    }
}
public function ApplyBonuses()
{
    local BioWorldInfo World;
    local int idx;
    local int GECount;
    local BioPawn member;
    local SFXShield_Base Shield;
    local SFXEngine MyEngine;
    local Name ConstructedCategoryName;
    local SFXModule_GameEffectManager PlayerGEManager;
    local array<SFXModule_GameEffectManager> WeaponGEManagers;
    local SFXModule_GameEffectManager WeaponGEManager;
    local Class<SFXGameEffect> EffectClass;
    local SFXWeapon CurrentWeapon;
    local SFXPowerCustomActionBase AmmoPower;
    local SFXPowerCustomActionBase PowerBase;
    local SFXPowerCustomAction Power;
    
    World = BioWorldInfo(WorldInfo);
    if (World != None)
    {
        if (World.m_playerSquad != None)
        {
            for (idx = 0; idx < World.m_playerSquad.Members.Length; idx++)
            {
                member = BioPawn(World.m_playerSquad.Members[idx]);
                Shield = member.GetShields();
                if (Shield != None)
                {
                    Shield.SetCurrentShields(Shield.GetMaxShields());
                }
            }
        }
    }
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', CurrentWeapon)
        {
            if (SFXHeavyWeapon(CurrentWeapon) == None && CurrentWeapon.AmmoPowerName != 'None' && CurrentWeapon.AmmoPowerSourceTag != 'None')
            {
                AmmoPower = Class'SFXPowerCustomAction_AmmoPowerBase'.static.GetSourceAmmoPower(CurrentWeapon.AmmoPowerName, CurrentWeapon.AmmoPowerSourceTag);
                if (AmmoPower != None)
                {
                    AmmoPower.ReloadAmmoPower(Self, CurrentWeapon);
                }
            }
        }
    }
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return;
    }
    PlayerGEManager = GetModule(Class'SFXModule_GameEffectManager');
    if (PlayerGEManager == None)
    {
        return;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', CurrentWeapon)
    {
        WeaponGEManager = CurrentWeapon.GetModule(Class'SFXModule_GameEffectManager');
        if (WeaponGEManager != None)
        {
            WeaponGEManagers.AddItem(WeaponGEManager);
        }
    }
    GECount = PermanentGameEffects.Length;
    for (idx = 0; idx < GECount; idx++)
    {
        ConstructedCategoryName = ConstructedPermanentGECategoryName(Name(PermanentGameEffects[idx].UniqueName));
        if (MyEngine.GetPlayerVariable(ConstructedCategoryName) >= 1)
        {
            EffectClass = Class'SFXGameEffect'.static.LoadGameEffectClass(PermanentGameEffects[idx].className);
            if (EffectClass == None)
            {
                continue;
            }
            if (PermanentGameEffects[idx].Type == EPermanentGameEffect_Type.PermanentGEType_Player)
            {
                PlayerGEManager.RemoveEffectsByTypeAndCategory(EffectClass, ConstructedCategoryName);
                PlayerGEManager.CreateAndApplyEffect(EffectClass, ConstructedCategoryName, 0.0, 2, PermanentGameEffects[idx].Value, Self.Controller);
                continue;
            }
            if (PermanentGameEffects[idx].Type == EPermanentGameEffect_Type.PermanentGEType_Weapon)
            {
                foreach WeaponGEManagers(WeaponGEManager, )
                {
                    WeaponGEManager.RemoveEffectsByTypeAndCategory(EffectClass, ConstructedCategoryName);
                    WeaponGEManager.CreateAndApplyEffect(EffectClass, ConstructedCategoryName, 0.0, 2, PermanentGameEffects[idx].Value, Self.Controller);
                }
            }
        }
    }
    if (SFXPawn_PlayerNonCombat(Self) == None)
    {
        foreach PowerManager.Powers(PowerBase, )
        {
            Power = SFXPowerCustomAction(PowerBase);
            if (Power != None)
            {
                Power.RestoreSaveState();
            }
        }
    }
}
public function ApplyCustomizationToActor(Actor InTarget, optional SFXCustomizationInstance InSettings = None, optional int UIWorldConfigFlags = 0)
{
    local SFXStuntActor StuntActor;
    local SkeletalMesh HelmetToApply;
    local bool bHideScars;
    
    if (InSettings == None)
    {
        InSettings = CreateTemporaryCustomizationInstance();
    }
    StuntActor = SFXStuntActor(InTarget);
    if (StuntActor != None)
    {
        ResetSkeletalMesh(StuntActor.BodyMesh, Mesh.SkeletalMesh);
        ResetSkeletalMesh(StuntActor.HeadMesh, HeadMesh.SkeletalMesh);
        StuntActor.MorphHead = MorphHead;
        if ((UIWorldConfigFlags & 1) == 0)
        {
            HelmetToApply = m_oHeadGearMesh.SkeletalMesh;
        }
        ResetSkeletalMesh(StuntActor.HeadGearMesh, HelmetToApply);
        ResetSkeletalMesh(StuntActor.HairMesh, m_oHairMesh.SkeletalMesh);
        if (HelmetToApply != None)
        {
            if (bHelmetHidesHead)
            {
                StuntActor.DetachComponent(StuntActor.HeadMesh);
                StuntActor.DetachComponent(StuntActor.HairMesh);
            }
            else if (bHelmetHidesHair)
            {
                StuntActor.DetachComponent(StuntActor.HairMesh);
            }
        }
        bHideScars = (UIWorldConfigFlags & 2) != 0;
        UpdateMaterialParameters(InSettings, StuntActor, StuntActor.HeadMesh, bHideScars);
        StuntActor.ForceUpdateComponents(TRUE, FALSE);
    }
}
public final function ApplyPendingMorphHead()
{
    local MorphFeature Feature;
    local OffsetBonePos Offset;
    local ScalarParameter ScalarParam;
    local ColorParameter ColorParam;
    local TextureParameter TextureParam;
    local array<int> BuffersToRefresh;
    local int idx;
    
    if (HasPendingMorphData() && !bHasPendingExistingMorphHead)
    {
        MorphHead = BioMorphFace(FindObject(bIsFemale ? Class'SFXPlayerCustomization'.default.FemaleCustomMorphHead : Class'SFXPlayerCustomization'.default.MaleCustomMorphHead, Class'BioMorphFace'));
        if (PathName(MorphHead.m_oHairMesh) != string(PendingMorphHeadData.HairMesh))
        {
            MorphHead.m_oHairMesh = SkeletalMesh(FindObject(string(PendingMorphHeadData.HairMesh), Class'SkeletalMesh'));
        }
        if (MorphHead.m_oOtherMeshes.Length != PendingMorphHeadData.AccessoryMeshes.Length)
        {
            MorphHead.m_oOtherMeshes.Length = PendingMorphHeadData.AccessoryMeshes.Length;
            for (idx = 0; idx < PendingMorphHeadData.AccessoryMeshes.Length; idx++)
            {
                MorphHead.m_oOtherMeshes[idx] = SkeletalMesh(FindObject(string(PendingMorphHeadData.AccessoryMeshes[idx]), Class'SkeletalMesh'));
            }
        }
        MorphHead.m_aMorphFeatures.Length = PendingMorphHeadData.MorphFeatures.Length;
        for (idx = 0; idx < PendingMorphHeadData.MorphFeatures.Length; idx++)
        {
            Feature.sFeatureName = PendingMorphHeadData.MorphFeatures[idx].Feature;
            Feature.Offset = PendingMorphHeadData.MorphFeatures[idx].Offset;
            MorphHead.m_aMorphFeatures[idx] = Feature;
        }
        MorphHead.m_aFinalSkeleton.Length = PendingMorphHeadData.OffsetBones.Length;
        for (idx = 0; idx < PendingMorphHeadData.OffsetBones.Length; idx++)
        {
            Offset.nName = PendingMorphHeadData.OffsetBones[idx].Name;
            Offset.vPos = PendingMorphHeadData.OffsetBones[idx].Offset;
            MorphHead.m_aFinalSkeleton[idx] = Offset;
        }
        for (idx = 0; idx < PendingMorphHeadData.LOD0Vertices.Length; idx++)
        {
            MorphHead.SetPosition(0, idx, PendingMorphHeadData.LOD0Vertices[idx]);
        }
        BuffersToRefresh.AddItem(0);
        MorphHead.RefreshBuffers(BuffersToRefresh);
        MorphHead.m_oMaterialOverrides.m_aScalarOverrides.Length = PendingMorphHeadData.ScalarParameters.Length;
        for (idx = 0; idx < PendingMorphHeadData.ScalarParameters.Length; idx++)
        {
            ScalarParam.nName = PendingMorphHeadData.ScalarParameters[idx].Name;
            ScalarParam.sValue = PendingMorphHeadData.ScalarParameters[idx].Value;
            MorphHead.m_oMaterialOverrides.m_aScalarOverrides[idx] = ScalarParam;
        }
        MorphHead.m_oMaterialOverrides.m_aColorOverrides.Length = PendingMorphHeadData.VectorParameters.Length;
        for (idx = 0; idx < PendingMorphHeadData.VectorParameters.Length; idx++)
        {
            ColorParam.nName = PendingMorphHeadData.VectorParameters[idx].Name;
            ColorParam.cValue = PendingMorphHeadData.VectorParameters[idx].Value;
            MorphHead.m_oMaterialOverrides.m_aColorOverrides[idx] = ColorParam;
        }
        MorphHead.m_oMaterialOverrides.m_aTextureOverrides.Length = PendingMorphHeadData.TextureParameters.Length;
        for (idx = 0; idx < PendingMorphHeadData.TextureParameters.Length; idx++)
        {
            TextureParam.nName = PendingMorphHeadData.TextureParameters[idx].Name;
            TextureParam.m_pTexture = Texture2D(FindObject(string(PendingMorphHeadData.TextureParameters[idx].Texture), Class'Texture2D'));
            MorphHead.m_oMaterialOverrides.m_aTextureOverrides[idx] = TextureParam;
        }
    }
    ResetPendingMorphData();
}
public final function bool ApplyPermanentPlayerGameEffect(Name UniqueName)
{
    local SFXModule_GameEffectManager PlayerGEManager;
    local SFXModule_GameEffectManager WeaponGEManager;
    local array<SFXModule_GameEffectManager> WeaponGEManagers;
    local SFXGameEffect NewEffect;
    local int idx;
    local SFXEngine MyEngine;
    local Name ConstructedCategoryName;
    local Class<SFXGameEffect> EffectClass;
    local bool bEffectCreated;
    local SFXWeapon CurrentWeapon;
    
    ConstructedCategoryName = ConstructedPermanentGECategoryName(UniqueName);
    idx = PermanentGameEffects.Find('UniqueName', string(UniqueName));
    if (idx < 0)
    {
        return FALSE;
    }
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return FALSE;
    }
    MyEngine.SetPlayerVariable(ConstructedCategoryName, 1);
    PlayerGEManager = GetModule(Class'SFXModule_GameEffectManager');
    if (PlayerGEManager == None)
    {
        return FALSE;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', CurrentWeapon)
    {
        WeaponGEManager = CurrentWeapon.GetModule(Class'SFXModule_GameEffectManager');
        if (WeaponGEManager != None)
        {
            WeaponGEManagers.AddItem(WeaponGEManager);
        }
    }
    EffectClass = Class'SFXGameEffect'.static.LoadGameEffectClass(PermanentGameEffects[idx].className);
    if (EffectClass == None)
    {
        return FALSE;
    }
    if (PermanentGameEffects[idx].Type == EPermanentGameEffect_Type.PermanentGEType_Player)
    {
        PlayerGEManager.RemoveEffectsByTypeAndCategory(EffectClass, ConstructedCategoryName);
        NewEffect = PlayerGEManager.CreateAndApplyEffect(EffectClass, ConstructedCategoryName, 0.0, 2, PermanentGameEffects[idx].Value, Self.Controller);
        if (NewEffect != None)
        {
            bEffectCreated = TRUE;
        }
    }
    else if (PermanentGameEffects[idx].Type == EPermanentGameEffect_Type.PermanentGEType_Weapon)
    {
        foreach WeaponGEManagers(WeaponGEManager, )
        {
            WeaponGEManager.RemoveEffectsByTypeAndCategory(EffectClass, ConstructedCategoryName);
            NewEffect = WeaponGEManager.CreateAndApplyEffect(EffectClass, ConstructedCategoryName, 0.0, 2, PermanentGameEffects[idx].Value, Self.Controller);
            if (NewEffect != None)
            {
                bEffectCreated = TRUE;
            }
        }
    }
    return bEffectCreated;
}
public final simulated function ApplyWeaponEncumbrance()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    local SFXGameEffect_PowerBonus PowerBonus;
    
    if (PowerManager == None)
    {
        return;
    }
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Category == EncumbranceEffectName)
            {
                Effect.CurrentTime = Effect.Duration + 1.0;
                Effect.DurationType = EDurationType.DurationType_Temporary;
                PowerBonus = SFXGameEffect_PowerBonus(Effect);
                if (PowerBonus != None)
                {
                    PowerBonus.RemoveBonuses();
                }
            }
        }
    }
    PowerManager.ApplyPowerBonus(Self, 'CooldownTime', CurrentWeaponEncumbrance, 0.0, EncumbranceEffectName);
}
public delegate function AsyncUpdating_OnCompleted(out array<Object> LoadedAssets);

public function AutoMap()
{
    if (WorldInfo.IsConsoleBuild(0))
    {
        AutoMapXbox();
    }
    else
    {
        AutoMapPC();
    }
    UpdateMappedPowerDisplay();
}
public function AutoMapPC()
{
    local SFXGUIInteraction oGM;
    local SFXSFHandler_PCPowerWheel oPowerWheel;
    local BioPlayerController BPC;
    local SFXPowerCustomActionBase Power;
    local int i;
    local int J;
    
    if (Controller == None)
    {
        return;
    }
    BPC = BioPlayerController(Controller);
    oGM = Class'SFXGUIInteraction'.static.GetInstance();
    oPowerWheel = SFXSFHandler_PCPowerWheel(oGM.GetMovie(BPC, oGM.MovieTag_PowerWheel));
    if (oGM == None || oPowerWheel == None)
    {
        return;
    }
    oPowerWheel.SetupPlayerPowers();
    for (i = 0; i < oPowerWheel.m_aPowerIcons.Length; i++)
    {
        if (oPowerWheel.m_aPowerIcons[i].pPawn == Self)
        {
            Power = oPowerWheel.m_aPowerIcons[i].pPower;
            for (J = 0; Power != None && J < 8; J++)
            {
                if ((!SFXGRI(WorldInfo.GRI).bCanSpawnHenchmen || BPC.m_aHotKeyDefines[J].nmPawn == 'Player') && oPowerWheel.m_aPowerIcons[i].nmPowerName == BPC.m_aHotKeyDefines[J].nmPower)
                {
                    Power = None;
                }
            }
            if (Power != None)
            {
                for (J = 0; J < 8; J++)
                {
                    if (BPC.m_aHotKeyDefines[J].nmPawn == 'None')
                    {
                        oPowerWheel.NewSetQuickSlotPower(J, i, TRUE, TRUE);
                        Power = None;
                        break;
                    }
                }
            }
        }
    }
}
public function AutoMapXbox()
{
    local array<Name> MappedPowers;
    local BioPlayerInput BPI;
    local int idx;
    local SFXPowerCustomActionBase Power;
    
    if (Controller == None)
    {
        return;
    }
    BPI = BioPlayerInput(BioPlayerController(Controller).PlayerInput);
    if (BPI != None)
    {
        MappedPowers = PlayerClass.default.MappedPowers;
        idx = 0;
        while (idx < MappedPowers.Length)
        {
            Power = FindPower(MappedPowers[idx]);
            if (Power != None)
            {
                MappedPowers[idx] = Power.Class.Name;
                idx++;
                continue;
            }
            MappedPowers.Remove(idx, 1);
        }
        Power = FindPower(BPI.m_nmMappedPower);
        if (Power != None)
        {
            BPI.m_nmMappedPower = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower = 'None';
        }
        Power = FindPower(BPI.m_nmMappedPower2);
        if (Power != None)
        {
            BPI.m_nmMappedPower2 = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower2 = 'None';
        }
        Power = FindPower(BPI.m_nmMappedPower3);
        if (Power != None)
        {
            BPI.m_nmMappedPower3 = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower3 = 'None';
        }
        MappedPowers.RemoveItem(BPI.m_nmMappedPower);
        MappedPowers.RemoveItem(BPI.m_nmMappedPower2);
        MappedPowers.RemoveItem(BPI.m_nmMappedPower3);
        if (BPI.m_nmMappedPower3 == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower3 = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
        if (BPI.m_nmMappedPower2 == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower2 = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
        if (BPI.m_nmMappedPower == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
    }
}
public function SFXWeapon BackupWeapon(optional SFXWeapon PreferredWeapon)
{
    local SFXWeapon BestWeapon;
    local SFXWeapon Weap;
    
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weap)
    {
        if (Weap == Weapon)
        {
            continue;
        }
        if (PreferredWeapon != None && Weap == PreferredWeapon)
        {
            BestWeapon = Weap;
            break;
        }
        if (Weap.OutOfAmmo() || Weap.SwitchPriority <= 0)
        {
            continue;
        }
        if (BestWeapon == None)
        {
            BestWeapon = Weap;
        }
        else if (BestWeapon.SwitchPriority < Weap.SwitchPriority)
        {
            BestWeapon = Weap;
        }
    }
    return BestWeapon;
}
private final simulated function SkeletalMesh BuildHelmetMesh(int Id, bool bUseFullArmourHelmets, out HelmetMetaData HelmetDetails)
{
    local array<EHelmetPart> Parts;
    local CompositeSourceMeshes HelmetSource;
    local CustomizableElement Element;
    local EHelmetPart CurrentPart;
    local SkeletalMesh SkelMesh;
    local SFXCompositeSkeletalMesh CompositeMesh;
    
    SkelMesh = None;
    if (bUseFullArmourHelmets || Id > 0)
    {
        Parts.AddItem(0);
        Parts.AddItem(1);
        Parts.AddItem(2);
        foreach Parts(CurrentPart, )
        {
            SkelMesh = Class'SFXPlayerCustomization'.static.GetHelmetMesh(Id, bIsFemale, CurrentPart, bUseFullArmourHelmets ? Class'SFXPlayerCustomization'.default.FullBodyHelmetAppearances : Class'SFXPlayerCustomization'.default.HelmetAppearances, Element);
            if (SkelMesh != None)
            {
                if (HelmetSource.BaseMesh == None)
                {
                    HelmetSource.BaseMesh = SkelMesh;
                    HelmetDetails.bAffectsVO = Element.Mesh.bHasBreather;
                    HelmetDetails.bHidesHead = Element.Mesh.bHideHead;
                    HelmetDetails.bHidesHair = Element.Mesh.bHideHair;
                }
                else
                {
                    HelmetSource.Parts.AddItem(SkelMesh);
                }
            }
        }
        if (HelmetSource.Parts.Length > 0 && HelmetSource.BaseMesh != None)
        {
            CompositeMesh = SFXCompositeSkeletalMesh(m_oHeadGearMesh.SkeletalMesh);
            if (CompositeMesh == None || !CompositeMesh.MatchesMerge(HelmetSource.BaseMesh, HelmetSource.Parts, None))
            {
                SkelMesh = Class'SFXCompositeSkeletalMesh'.static.MergeMeshes(HelmetSource.BaseMesh, HelmetSource.Parts, None);
            }
            else
            {
                SkelMesh = CompositeMesh;
            }
        }
        else if (HelmetSource.BaseMesh != None)
        {
            SkelMesh = HelmetSource.BaseMesh;
        }
    }
    return SkelMesh;
}
public static function int CalculateScarIndex(bool bHideScars, int CharmSkill, int IntimidateSkill, int ReputationSkill)
{
    local float ParagonRatio;
    local float RenegadeRatio;
    local float ParagonOffset;
    local float ParagonPercent;
    local float RenegadePercent;
    local float ScarThreshold;
    local int idx;
    local float fScarBiasRatio;
    
    if (!bHideScars)
    {
        fScarBiasRatio = 1.0 - FClamp((float(CharmSkill + IntimidateSkill + ReputationSkill) - default.FullParagonScarBiasValue) / (default.NoParagonScarBiasValue - default.FullParagonScarBiasValue), 0.0, 1.0);
        ParagonOffset = fScarBiasRatio * default.ParagonScarBias * float(default.MaxTotalReputation);
        InternalGetParagonRenegadePercentage(float(CharmSkill), ParagonOffset, float(IntimidateSkill), float(ReputationSkill), ParagonPercent, RenegadePercent);
        if (ParagonPercent + RenegadePercent > float(0))
        {
            ParagonRatio = ParagonPercent / (ParagonPercent + RenegadePercent);
            RenegadeRatio = RenegadePercent / (ParagonPercent + RenegadePercent);
        }
        ScarThreshold = ParagonRatio - RenegadeRatio;
        for (idx = 0; idx < Class'SFXPlayerCustomization'.default.Scars.Length; idx++)
        {
            if (ScarThreshold >= Class'SFXPlayerCustomization'.default.Scars[idx].Threshold.X && ScarThreshold <= Class'SFXPlayerCustomization'.default.Scars[idx].Threshold.Y)
            {
                return idx;
            }
        }
    }
    return Class'SFXPlayerCustomization'.default.Scars.Length - 1;
}
public simulated function ClearAsyncAssetLoader()
{
    local SFXAsyncAssetLoader oAssetLoader;
    local SkeletalMeshComponent SkelMeshIter;
    
    oAssetLoader = BioDynamicLoadInterface(Class'Engine'.static.GetEngine()).GetAsyncAssetLoader();
    oAssetLoader.ClearAsyncGroup(AsyncGroupName);
    PrestreamTextures(-1.0, FALSE);
    ClearTimer('OnAsyncAppearanceTexturesPreloaded');
    foreach AsyncAppearanceMeshes(SkelMeshIter, )
    {
        DetachComponent(SkelMeshIter);
    }
    AsyncAppearanceMeshes.Length = 0;
    __AsyncUpdating_OnCompleted__Delegate = None;
    bAsyncUpdatingAppearance = FALSE;
}
public static final function Name ConstructedPermanentGECategoryName(Name UniqueName)
{
    local Name ConstructedCategoryName;
    
    ConstructedCategoryName = Name(default.PermanentGameEffect_CategoryPrefix $ UniqueName);
    return ConstructedCategoryName;
}
public final function SFXCustomizationInstance CreateTemporaryCustomizationInstance()
{
    local SFXCustomizationInstance_Player NewInstance;
    
    NewInstance = new Class'SFXCustomizationInstance_Player';
    NewInstance.bUseCasualAppearance = bUseCasualAppearance;
    NewInstance.CombatAppearance = CombatAppearance;
    NewInstance.CasualID = CasualID;
    NewInstance.FullBodyID = FullBodyID;
    NewInstance.TorsoID = TorsoID;
    NewInstance.ShoulderID = ShoulderID;
    NewInstance.ArmID = ArmID;
    NewInstance.LegID = LegID;
    NewInstance.SpecID = SpecID;
    NewInstance.Tint1ID = Tint1ID;
    NewInstance.Tint2ID = Tint2ID;
    NewInstance.PatternID = PatternID;
    NewInstance.PatternColorID = PatternColorID;
    NewInstance.HelmetID = HelmetID;
    NewInstance.EmissiveID = EmissiveID;
    return NewInstance;
}
public function bool CreateWeapon(Class<SFXWeapon> WeaponClass, optional bool bEquipWeapon = FALSE)
{
    local bool bRetval;
    local SFXEngine Engine;
    local int idx;
    local int Idx2;
    local SFXModule_WeaponModManager ModManager;
    local SFXWeapon NewWeapon;
    local Class<SFXWeaponMod> ModClass;
    local int ModLevel;
    local SFXModule_GameEffectManager GEManager;
    local SFXGameEffect GameEffect;
    
    bRetval = Super(BioPawn).CreateWeapon(WeaponClass, bEquipWeapon);
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine == None)
    {
        return bRetval;
    }
    idx = Engine.PlayerWeaponMods.Find('WeaponClassName', Name(PathName(WeaponClass)));
    if (idx >= 0 && InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', NewWeapon)
        {
            if (NewWeapon.Class != WeaponClass)
            {
                continue;
            }
            ModManager = NewWeapon.GetModule(Class'SFXModule_WeaponModManager');
            if (ModManager == None)
            {
                continue;
            }
            ModManager.RemoveAllMods();
            for (Idx2 = 0; Idx2 < Engine.PlayerWeaponMods[idx].WeaponModClassNames.Length; Idx2++)
            {
                ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(Engine.PlayerWeaponMods[idx].WeaponModClassNames[Idx2]));
                if (ModClass != None && ModClass.static.IsUnlocked(ModLevel))
                {
                    ModManager.AddMod(ModClass, ModLevel);
                }
            }
            GEManager = GetModule(Class'SFXModule_GameEffectManager');
            if (GEManager != None)
            {
                foreach GEManager.GameEffects(GameEffect, )
                {
                    if (SFXGameEffect_PassiveWeaponBonus(GameEffect) != None)
                    {
                        SFXGameEffect_PassiveWeaponBonus(GameEffect).ApplyBonus(NewWeapon);
                    }
                }
            }
        }
    }
    return bRetval;
}
public function CreateWeapons(SFXLoadoutData ChkLoadout, optional bool bForceFromEngineLoadout)
{
    local SFXEngine Engine;
    local Class<SFXWeapon> WClass;
    local int nIndex;
    local int WeaponAddedCount;
    local Name WClassName;
    local SFXWeapon oWeapon;
    local int GroupIdx;
    local int EntryIdx;
    local array<SFXWeapon> RemoveList;
    local AnimSet Set;
    
    Engine = SFXEngine(BioPlayerController(Controller).Player.Outer);
    if (Engine == None)
    {
        return;
    }
    if (Engine.bUsedSetMission == FALSE && Engine.PlayerLoadoutGroups.Length == 0)
    {
        Engine.PlayerLoadoutGroups.AddItem(4);
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', oWeapon)
    {
        Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(oWeapon.Class, GroupIdx, EntryIdx);
        if (Engine.PlayerLoadoutGroups.Find(byte(GroupIdx)) == -1 || bForceFromEngineLoadout)
        {
            RemoveList.AddItem(oWeapon);
        }
    }
    foreach RemoveList(oWeapon, )
    {
        if (oWeapon.AnimType >= WeaponAnimType.WeaponAnimType_Pistol && int(oWeapon.AnimType) < WeaponAnimSpecs.Length)
        {
            foreach WeaponAnimSpecs[int(oWeapon.AnimType)].m_animSets(Set, )
            {
                RmvAnimSet(Set);
            }
            RmvAnimSet(WeaponAnimSpecs[int(oWeapon.AnimType)].m_drawAnimSet);
        }
        InvManager.RemoveFromInventory(oWeapon);
        oWeapon.Destroy();
    }
    for (nIndex = 0; nIndex < 6; nIndex++)
    {
        if (int(byte(nIndex)) == 5 && IsA('SFXPawn_PlayerNonCombat') == TRUE)
        {
            continue;
        }
        if (Class'SFXPlayerSquadLoadoutData'.static.IsPlayerUsingWeaponGroup(byte(nIndex)))
        {
            WClass = None;
            if (Engine.PlayerLoadoutWeapons[nIndex] != 'None')
            {
                WClassName = Engine.PlayerLoadoutWeapons[nIndex];
                WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WClassName);
            }
            if (WClass == None)
            {
                WClassName = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(nIndex)[0].className;
                Engine.PlayerLoadoutWeapons[nIndex] = WClassName;
                PrimaryWeapon = WClassName;
                if (PrimaryWeapon == 'None' && WeaponAddedCount == 0)
                {
                    PrimaryWeapon = WClassName;
                }
                else if (SecondaryWeapon == 'None' && WeaponAddedCount == 1)
                {
                    SecondaryWeapon = WClassName;
                }
                WeaponAddedCount++;
                WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WClassName);
            }
            if (WClass != None)
            {
                CreateWeapon(WClass);
            }
        }
    }
    UpdateWeaponEncumbrance();
}
public final function EnqueueExistingMorphHead(BioMorphFace InMorphHead)
{
    MorphHead = InMorphHead;
    bHasPendingExistingMorphHead = TRUE;
}
public final function EnqueueIconicHeadForLoad()
{
    local SFXAsyncAssetRequest AsyncRequest;
    
    if (bIsFemale)
    {
        AsyncRequest.AssetClass = Class'SkeletalMesh';
        AsyncRequest.AltCookedPackageName = 'None';
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.FemaleIconicHeadMesh;
        PendingMorphHeadResources.AddItem(AsyncRequest);
        AsyncRequest.AssetClass = Class'FaceFXAsset';
        AsyncRequest.AltCookedPackageName = 'None';
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.FemaleIconicFaceFXAsset;
        PendingMorphHeadResources.AddItem(AsyncRequest);
    }
    else
    {
        AsyncRequest.AssetClass = Class'SkeletalMesh';
        AsyncRequest.AltCookedPackageName = 'None';
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.MaleIconicHeadMesh;
        PendingMorphHeadResources.AddItem(AsyncRequest);
        AsyncRequest.AssetClass = Class'FaceFXAsset';
        AsyncRequest.AltCookedPackageName = 'None';
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.MaleIconicFaceFXAsset;
        PendingMorphHeadResources.AddItem(AsyncRequest);
    }
    MorphHead = None;
    bHasPendingExistingMorphHead = TRUE;
}
public final function EnqueueMorphHeadForLoad(MorphHeadSaveRecord InRecord)
{
    local SFXAsyncAssetRequest AsyncRequest;
    local int idx;
    
    PendingMorphHeadData = InRecord;
    AsyncRequest.AssetClass = Class'BioMorphFace';
    AsyncRequest.AltCookedPackageName = 'None';
    if (bIsFemale)
    {
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.FemaleCustomMorphHead;
    }
    else
    {
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.MaleCustomMorphHead;
    }
    PendingMorphHeadResources.AddItem(AsyncRequest);
    AsyncRequest.AssetClass = Class'FaceFXAsset';
    if (bIsFemale)
    {
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.FemaleMorphHeadFaceFXAsset;
    }
    else
    {
        AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.MaleMorphHeadFaceFXAsset;
    }
    PendingMorphHeadResources.AddItem(AsyncRequest);
    if (InRecord.HairMesh != 'None')
    {
        AsyncRequest.AssetClass = Class'SkeletalMesh';
        AsyncRequest.FullAssetPath = string(InRecord.HairMesh);
        PendingMorphHeadResources.AddItem(AsyncRequest);
    }
    for (idx = 0; idx < InRecord.AccessoryMeshes.Length; ++idx)
    {
        AsyncRequest.AssetClass = Class'SkeletalMesh';
        AsyncRequest.FullAssetPath = string(InRecord.AccessoryMeshes[idx]);
        PendingMorphHeadResources.AddItem(AsyncRequest);
    }
    for (idx = 0; idx < InRecord.TextureParameters.Length; ++idx)
    {
        if (InRecord.TextureParameters[idx].Texture != 'None')
        {
            AsyncRequest.AssetClass = Class'Texture2D';
            AsyncRequest.FullAssetPath = string(InRecord.TextureParameters[idx].Texture);
            PendingMorphHeadResources.AddItem(AsyncRequest);
        }
    }
    bHasPendingSavedMorphHead = TRUE;
}
private final simulated function MaterialInstanceConstant EnsureMIC(SkeletalMeshComponent MeshCmpt, optional int MatIdx)
{
    local MaterialInstanceConstant MIC;
    local MaterialInterface Parent;
    
    if (MeshCmpt == None || MeshCmpt.SkeletalMesh == None)
    {
        return None;
    }
    if (MatIdx < MeshCmpt.Materials.Length)
    {
        MIC = MaterialInstanceConstant(MeshCmpt.Materials[MatIdx]);
    }
    if (MIC == None || MIC.Outer != MeshCmpt)
    {
        if (MIC == None && MeshCmpt.SkeletalMesh != None && MatIdx < MeshCmpt.SkeletalMesh.Materials.Length)
        {
            Parent = MeshCmpt.SkeletalMesh.Materials[MatIdx];
        }
        if (Parent != None)
        {
            MIC = new (MeshCmpt) Class'MaterialInstanceConstant';
            MIC.SetParent(Parent);
            MeshCmpt.SetMaterial(MatIdx, MIC);
        }
    }
    return MIC;
}
public final function EquipWeaponToPlayerAndSquad(Class<SFXWeapon> NewWeaponClass)
{
    local Pawn MemberPawn;
    local SFXPawn_Henchman Henchman;
    local array<Name> PreviousWeaponNames;
    
    PreviousWeaponNames = Class'SFXPlayerSquadLoadoutData'.static.GetCurrentPlayerWeaponNames();
    foreach Squad.Members(MemberPawn, )
    {
        Henchman = SFXPawn_Henchman(MemberPawn);
        if (Henchman != None && Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponClass(Henchman.Tag, NewWeaponClass) == TRUE)
        {
            Henchman.CreateWeapon(NewWeaponClass, TRUE);
            Henchman.ApplyAppropriateModsIfNoneExist(PreviousWeaponNames);
        }
        else if (MemberPawn == Self)
        {
            CreateWeapon(NewWeaponClass);
            SetWeaponImmediatelyByClass(NewWeaponClass);
            ApplyAppropriateModsIfNoneExist(PreviousWeaponNames);
        }
    }
}
public final simulated function int FindOverrideHelmet()
{
    local int idx;
    local CustomizableElement Helmet;
    local string HelmetName;
    local string ChkName;
    
    if (GetBaseHelmetElement(Helmet))
    {
        HelmetName = bIsFemale ? Helmet.Mesh.Female : Helmet.Mesh.Male;
        if (HelmetName != "")
        {
            if (Helmet.Mesh.bHasBreather)
            {
                return -1;
            }
            else
            {
                for (idx = 0; idx < Class'SFXPlayerCustomization'.default.HelmetAppearances.Length; idx++)
                {
                    ChkName = bIsFemale ? Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.Female : Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.Male;
                    if (ChkName == HelmetName && Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.bHasBreather)
                    {
                        return Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Id;
                    }
                }
            }
        }
    }
    for (idx = 0; idx < Class'SFXPlayerCustomization'.default.HelmetAppearances.Length; idx++)
    {
        ChkName = bIsFemale ? Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.Female : Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.Male;
        if (ChkName != "" && Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Mesh.bHasBreather)
        {
            return Class'SFXPlayerCustomization'.default.HelmetAppearances[idx].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.HelmetAppearances.Length > 0)
    {
        return Class'SFXPlayerCustomization'.default.HelmetAppearances[0].Id;
    }
    return -1;
}
public function SFXPowerCustomActionBase FindPower(Name nmPowerClass)
{
    local SFXPowerCustomActionBase oPower;
    
    if (nmPowerClass == 'None' || nmPowerClass == 'None')
    {
        return None;
    }
    foreach PowerManager.Powers(oPower, )
    {
        if (oPower.Rank > float(0) && oPower.IsA(nmPowerClass))
        {
            return oPower;
        }
    }
    return None;
}
public final simulated function GetApperanceAssetsForAsyncLoad(out array<SFXAsyncAssetRequest> Assets)
{
    local SFXAsyncAssetRequest AsyncRequest;
    local int Id;
    
    if (bUseCasualAppearance)
    {
        Assets.AddItem(GetMeshAssetRequest(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, Class'SFXPlayerCustomization'.default.CasualAppearances));
        Id = OverrideCasualID >= 0 ? OverrideCasualID : CasualID;
        AsyncRequest.AssetClass = Class'MaterialInstance';
        AsyncRequest.AltCookedPackageName = 'None';
        if (bIsFemale)
        {
            AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.CasualAppearances[Id].Mesh.FemaleMaterialOverride;
        }
        else
        {
            AsyncRequest.FullAssetPath = Class'SFXPlayerCustomization'.default.CasualAppearances[Id].Mesh.MaleMaterialOverride;
        }
        Assets.AddItem(AsyncRequest);
    }
    else if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        Assets.AddItem(GetMeshAssetRequest(FullBodyID, Class'SFXPlayerCustomization'.default.FullBodyAppearances));
        GetHelmetApperanceAssetsForAsyncLoad(Assets);
    }
    else
    {
        Assets.AddItem(GetMeshAssetRequest(ShoulderID, Class'SFXPlayerCustomization'.default.ShoulderAppearances));
        Assets.AddItem(GetMeshAssetRequest(ArmID, Class'SFXPlayerCustomization'.default.ArmAppearances));
        Assets.AddItem(GetMeshAssetRequest(LegID, Class'SFXPlayerCustomization'.default.LegAppearances));
        Assets.AddItem(GetMeshAssetRequest(TorsoID, Class'SFXPlayerCustomization'.default.TorsoAppearances));
        GetHelmetApperanceAssetsForAsyncLoad(Assets);
    }
}
public final function string GetArmorEffectDescription(array<string> ArmorEffects)
{
    local int idx;
    local int Idx2;
    local string Description;
    local string ArmorEffect;
    
    Description = "";
    foreach ArmorEffects(ArmorEffect, )
    {
        for (idx = 0; idx < ArmorEffectDescriptions.Length; idx++)
        {
            if (ArmorEffect != ArmorEffectDescriptions[idx].ArmorEffect)
            {
                continue;
            }
            for (Idx2 = 0; Idx2 < ArmorEffectDescriptions[idx].EffectDescription.Length; Idx2++)
            {
                ClearCustomTokens();
                SetCustomToken(0, ArmorEffectDescriptions[idx].EffectToken[Idx2]);
                SetCustomToken(1, Description);
                Description = Class'SFXGame'.static.GetSimpleString(ArmorEffectDescriptions[idx].EffectDescription[Idx2], TRUE);
                ClearCustomTokens();
            }
        }
    }
    return Description;
}
public final simulated function bool GetBaseHelmetElement(out CustomizableElement OutElement)
{
    local int idx;
    
    if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        idx = Class'SFXPlayerCustomization'.default.FullBodyHelmetAppearances.Find('Id', FullBodyID);
        if (idx != -1)
        {
            OutElement = Class'SFXPlayerCustomization'.default.FullBodyHelmetAppearances[idx];
            return TRUE;
        }
    }
    else
    {
        idx = Class'SFXPlayerCustomization'.default.HelmetAppearances.Find('Id', HelmetID);
        if (idx != -1)
        {
            OutElement = Class'SFXPlayerCustomization'.default.HelmetAppearances[idx];
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function int GetBaseHelmetID()
{
    if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        return FullBodyID;
    }
    return HelmetID;
}
public function int GetCharmSkill()
{
    local SFXGame Game;
    local float fCharmSkill;
    local SFXPowerCustomAction_ParagonRenegade Power;
    local int nIndex;
    
    Game = SFXGame(WorldInfo.Game);
    if (Game != None)
    {
        fCharmSkill = float(Game.GetParagonPoints());
    }
    if (PowerManager != None)
    {
        for (nIndex = 0; nIndex < PowerManager.Powers.Length; nIndex++)
        {
            Power = SFXPowerCustomAction_ParagonRenegade(PowerManager.Powers[nIndex]);
            if (Power != None)
            {
                Power.ModifyCharmSkill(fCharmSkill);
            }
        }
    }
    return int(fCharmSkill);
}
public final function GetCurrentScarStruct(bool bHideScars, out ScarInfo Scar)
{
    local BioGlobalVariableTable VarTable;
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(WorldInfo);
    if (BWI != None)
    {
        VarTable = BWI.GetGlobalVariables();
    }
    bHideScars = bOverrideHideScars || bHideScars || VarTable == None || VarTable.GetBool(Class'SFXPlayerCustomization'.default.CosmeticSurgeryPlotID) || VarTable.GetBool(Class'SFXPlayerCustomization'.default.CosmeticSUrgeryPlotID_ME3);
    Scar = Class'SFXPlayerCustomization'.default.Scars[CalculateScarIndex(bHideScars, GetCharmSkill(), GetIntimidateSkill(), GetReputationSkill())];
}
public simulated function string GetFullName()
{
    local stringref LastName;
    
    LastName = Class'SFXPawn_Player'.static.GetLastNameStringRef();
    return firstName @ Class'SFXGame'.static.GetSimpleString(LastName);
}
public simulated function GetGameEffects(int Id, out array<CustomizableElement> Meshes, out array<Class<SFXGameEffect>> Effects)
{
    local int idx;
    local Class<SFXGameEffect> Effect;
    local string EffectName;
    
    idx = Meshes.Find('Id', Id);
    if (idx != -1)
    {
        foreach Meshes[idx].GameEffects(EffectName, )
        {
            Effect = Class<SFXGameEffect>(Class'SFXEngine'.static.GetSeekFreeObject(EffectName, Class'Class'));
            if (Effect != None)
            {
                Effects.AddItem(Effect);
            }
        }
    }
}
public final simulated function GetHelmetApperanceAssetsForAsyncLoad(out array<SFXAsyncAssetRequest> Assets)
{
    local array<EHelmetPart> Parts;
    local EHelmetPart CurrentPart;
    local SFXAsyncAssetRequest oRequestedAsset;
    local CustomizableElement Element;
    local int HelmetIDToUse;
    local CustomizableElement HelmetElement;
    
    HelmetIDToUse = GetBaseHelmetID();
    if (GetBaseHelmetElement(HelmetElement))
    {
        bHelmetIsFull = HelmetElement.Mesh.bHasBreather;
    }
    if (RequiresFullHelmet() && !bHelmetIsFull)
    {
        OverrideHelmetID = FindOverrideHelmet();
    }
    else
    {
        OverrideHelmetID = -1;
    }
    Parts.AddItem(0);
    Parts.AddItem(1);
    Parts.AddItem(2);
    foreach Parts(CurrentPart, )
    {
        if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full || HelmetIDToUse > 0)
        {
            oRequestedAsset = GetHelmetMeshAssetRequestByElement(HelmetElement, CurrentPart);
            if (oRequestedAsset.FullAssetPath != "")
            {
                Assets.AddItem(oRequestedAsset);
            }
        }
        if (OverrideHelmetID > 0)
        {
            oRequestedAsset = GetHelmetMeshAssetRequest(OverrideHelmetID, CurrentPart, Class'SFXPlayerCustomization'.default.HelmetAppearances, Element);
            if (oRequestedAsset.FullAssetPath != "")
            {
                Assets.AddItem(oRequestedAsset);
            }
        }
    }
}
public simulated function GetHelmetGameEffects(out array<Class<SFXGameEffect>> Effects)
{
    if (bUsingOverrideHelmet)
    {
        GetGameEffects(OverrideHelmetID, Class'SFXPlayerCustomization'.default.HelmetAppearances, Effects);
    }
    else if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Parts)
    {
        GetGameEffects(HelmetID, Class'SFXPlayerCustomization'.default.HelmetAppearances, Effects);
    }
    else
    {
        GetGameEffects(FullBodyID, Class'SFXPlayerCustomization'.default.FullBodyHelmetAppearances, Effects);
    }
}
private final simulated function SFXAsyncAssetRequest GetHelmetMeshAssetRequest(int Id, EHelmetPart Part, const out array<CustomizableElement> ArrayToSearch, out CustomizableElement Element)
{
    local SFXAsyncAssetRequest AsyncRequest;
    local int idx;
    
    AsyncRequest.AssetClass = Class'SkeletalMesh';
    AsyncRequest.AltCookedPackageName = 'None';
    idx = ArrayToSearch.Find('Id', Id);
    if (idx != -1)
    {
        Element = ArrayToSearch[idx];
        AsyncRequest = GetHelmetMeshAssetRequestByElement(Element, Part);
    }
    return AsyncRequest;
}
private final simulated function SFXAsyncAssetRequest GetHelmetMeshAssetRequestByElement(out CustomizableElement Element, EHelmetPart Part)
{
    local SFXAsyncAssetRequest AsyncRequest;
    
    AsyncRequest.AssetClass = Class'SkeletalMesh';
    AsyncRequest.AltCookedPackageName = 'None';
    switch (Part)
    {
        case EHelmetPart.HelmetPart_Helmet:
            AsyncRequest.FullAssetPath = bIsFemale ? Element.Mesh.Female : Element.Mesh.Male;
            break;
        case EHelmetPart.HelmetPart_Visor:
            AsyncRequest.FullAssetPath = bIsFemale ? Element.Mesh.FemaleVisor : Element.Mesh.MaleVisor;
            break;
        case EHelmetPart.HelmetPart_Breather:
            AsyncRequest.FullAssetPath = bIsFemale ? Element.Mesh.FemaleFaceplate : Element.Mesh.MaleFaceplate;
            break;
        default:
    }
    return AsyncRequest;
}
public function int GetIntimidateSkill()
{
    local SFXGame Game;
    local float fIntimidateSkill;
    local SFXPowerCustomAction_ParagonRenegade Power;
    local int nIndex;
    
    Game = SFXGame(WorldInfo.Game);
    if (Game != None)
    {
        fIntimidateSkill = float(Game.GetRenegadePoints());
    }
    if (PowerManager != None)
    {
        for (nIndex = 0; nIndex < PowerManager.Powers.Length; nIndex++)
        {
            Power = SFXPowerCustomAction_ParagonRenegade(PowerManager.Powers[nIndex]);
            if (Power != None)
            {
                Power.ModifyIntimidateSkill(fIntimidateSkill);
            }
        }
    }
    return int(fIntimidateSkill);
}
protected function bool GetKnockbackReactions(float Angle, float SideAngle, out array<EAICustomAction> OutActions)
{
    if (IsInCover() == TRUE)
    {
        return FALSE;
    }
    return Super(BioPawn).GetKnockbackReactions(Angle, SideAngle, OutActions);
}
public static function stringref GetLastNameStringRef()
{
    return $125303;
}
private final simulated function SFXAsyncAssetRequest GetMeshAssetRequest(int Id, out array<CustomizableElement> Meshes)
{
    local SFXAsyncAssetRequest AsyncRequest;
    local int idx;
    local CustomizableElement Element;
    
    AsyncRequest.AssetClass = Class'SkeletalMesh';
    AsyncRequest.AltCookedPackageName = 'None';
    idx = Meshes.Find('Id', Id);
    if (idx != -1)
    {
        Element = Meshes[idx];
        AsyncRequest.FullAssetPath = bIsFemale ? Element.Mesh.Female : Element.Mesh.Male;
    }
    return AsyncRequest;
}
public function GetParagonRenegadePercentage(out float ParagonPercent, out float RenegadePercent)
{
    InternalGetParagonRenegadePercentage(float(GetCharmSkill()), 0.0, float(GetIntimidateSkill()), float(GetReputationSkill()), ParagonPercent, RenegadePercent);
}
public function int GetReputationSkill()
{
    local SFXGame Game;
    local float fRepSkill;
    local SFXPowerCustomAction_ParagonRenegade Power;
    local int nIndex;
    
    Game = SFXGame(WorldInfo.Game);
    if (Game != None)
    {
        fRepSkill = float(Game.GetReputationPoints());
    }
    if (PowerManager != None)
    {
        for (nIndex = 0; nIndex < PowerManager.Powers.Length; nIndex++)
        {
            Power = SFXPowerCustomAction_ParagonRenegade(PowerManager.Powers[nIndex]);
            if (Power != None)
            {
                Power.ModifyReputationSkill(fRepSkill);
            }
        }
    }
    return int(fRepSkill);
}
public simulated function int GetScaledLevel()
{
    return 1;
}
public function Name GetUIAppearanceTag()
{
    return bIsFemale ? 'FemShep' : 'None';
}
public final simulated function float GetWeaponEncumbranceCooldown(float Encumbrance)
{
    return -FClamp(EncumbranceMinCooldown + Encumbrance - EncumbranceCapacity, EncumbranceMinCooldown, EncumbranceMaxCooldown);
}
public function GiveWeaponToPlayer(SFXWeapon NewWeapon, optional bool DeleteTossedWeapons = TRUE)
{
    local SFXWeapon ChkWeapon;
    local SFXInventoryManager InvMan;
    local bool bTossWeapon;
    
    InvMan = SFXInventoryManager(InvManager);
    if (InvMan == None)
    {
        return;
    }
    foreach InvMan.InventoryActors(Class'SFXWeapon', ChkWeapon)
    {
        bTossWeapon = FALSE;
        bTossWeapon = ShouldTossWeapon(ChkWeapon, NewWeapon);
        if (bTossWeapon)
        {
            if (DeleteTossedWeapons)
            {
                ChkWeapon.Destroy();
            }
            else
            {
                TossWeapon(ChkWeapon);
            }
            if (Name(PathName(ChkWeapon.Class)) == PrimaryWeapon)
            {
                PrimaryWeapon = 'None';
            }
            else if (Name(PathName(ChkWeapon.Class)) == SecondaryWeapon)
            {
                SecondaryWeapon = 'None';
            }
        }
    }
    NewWeapon.GiveTo(Self);
    SetWeaponImmediately(NewWeapon);
    NewWeapon.AnnouncePickup(Self);
    NewWeapon.LifeSpan = 0.0;
    NewWeapon.ApplyDefaultWeaponMods();
    UpdatePlayerLoadoutInfo();
    if (ClassIsChildOf(NewWeapon.Class, Class'SFXHeavyWeapon') == FALSE)
    {
        if (PrimaryWeapon == 'None')
        {
            PrimaryWeapon = Name(PathName(NewWeapon.Class));
        }
        else if (SecondaryWeapon == 'None')
        {
            SecondaryWeapon = Name(PathName(NewWeapon.Class));
        }
    }
}
public final function bool HasPendingMorphData()
{
    return bHasPendingSavedMorphHead || bHasPendingExistingMorphHead;
}
public simulated function InitDefaultHelmetState()
{
    ForcedHelmetState[3] = 1;
}
public simulated function InitializePlayerVoc()
{
    CombatVoc = GenericPlayerCombatVoc;
    StealthVoc = PlayerStealthVoc;
    ExplorationVoc = PlayerExplorationVoc;
    if (IsLocallyControlled())
    {
        CombatVoc = PlayerCombatVoc;
    }
}
private static final function InternalGetParagonRenegadePercentage(float Paragon, float ParagonOffset, float Renegade, float Reputation, out float ParagonPercent, out float RenegadePercent)
{
    local float ParagonToRenegadeRatio;
    local float RenegadeToParagonRatio;
    local float ParagonPlusRenegade;
    
    ParagonPlusRenegade = Paragon + Renegade;
    if (ParagonPlusRenegade != float(0))
    {
        ParagonToRenegadeRatio = Paragon / ParagonPlusRenegade;
        RenegadeToParagonRatio = Renegade / ParagonPlusRenegade;
    }
    else
    {
        ParagonToRenegadeRatio = 0.5;
        RenegadeToParagonRatio = 0.5;
    }
    Paragon += Reputation * ParagonToRenegadeRatio + ParagonOffset;
    Renegade += Reputation * RenegadeToParagonRatio;
    ParagonPercent = Paragon / float(default.MaxTotalReputation);
    RenegadePercent = Renegade / float(default.MaxTotalReputation);
    ParagonPlusRenegade = ParagonPercent + RenegadePercent;
    if (ParagonPlusRenegade > 1.0)
    {
        ParagonPercent = ParagonPercent / ParagonPlusRenegade;
        RenegadePercent = RenegadePercent / ParagonPlusRenegade;
    }
}
public simulated function bool IsUpdatingAppearanceAsync()
{
    return bAsyncUpdatingAppearance;
}
private final simulated function KillAndFreeze(Controller Killer, Class<DamageType> dmgType, string Cause)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (IsDead() == FALSE)
        {
            if (dmgType == None)
            {
                dmgType = Class'SFXDamageType_Suicide';
            }
            Died(Killer, dmgType, vect(0.0, 0.0, 0.0));
        }
        else
        {
            SetPhysics(0);
        }
    }
}
public simulated function LoadCharacterClassData()
{
    local int nIndex;
    
    if (PlayerClass != None)
    {
        for (nIndex = 0; nIndex < PlayerClass.CustomActionClasses.Length; nIndex++)
        {
            if (PlayerClass.CustomActionClasses[nIndex] != None)
            {
                CustomActionClasses[nIndex] = PlayerClass.CustomActionClasses[nIndex];
            }
        }
        for (nIndex = 0; nIndex < PlayerClass.PowerCustomActionClasses.Length; nIndex++)
        {
            if (PlayerClass.PowerCustomActionClasses[nIndex] != None)
            {
                PowerCustomActionClasses[nIndex] = PlayerClass.PowerCustomActionClasses[nIndex];
            }
        }
        for (nIndex = 0; nIndex < PlayerClass.PowerUnlockRequirements.Length; nIndex++)
        {
            PowerUnlockRequirements.AddItem(PlayerClass.PowerUnlockRequirements[nIndex]);
        }
        for (nIndex = 0; nIndex < PlayerClass.SquadScreenPowerOrder.Length; nIndex++)
        {
            SquadScreenPowerOrder.AddItem(PlayerClass.SquadScreenPowerOrder[nIndex]);
        }
        for (nIndex = 0; nIndex < PlayerClass.StartingPowerRanks.Length; nIndex++)
        {
            StartingPowerRanks.AddItem(PlayerClass.StartingPowerRanks[nIndex]);
        }
        EncumbranceCapacity = PlayerClass.StartingEncumbranceCapacity;
        EncumbranceMinCooldown = PlayerClass.EncumbranceMinCooldown;
        EncumbranceMaxCooldown = PlayerClass.EncumbranceMaxCooldown;
        for (nIndex = 0; nIndex < 6; nIndex++)
        {
            WeaponEncumbranceModifiers[nIndex] = PlayerClass.WeaponEncumbranceModifiers[nIndex];
            Class'SFXGame'.static.ReCalculate(WeaponEncumbranceModifiers[nIndex]);
        }
        AutoLevelUpInfo = PlayerClass.AutoLevelUpInfo;
        PlayerClass.AutoLevelUpInfo.Length = 0;
        CameraHookScale = PlayerClass.CameraHookScale;
        CameraHookOffset = PlayerClass.CameraHookOffset;
        CameraArmScale = PlayerClass.CameraArmScale;
        CameraArmOffset = PlayerClass.CameraArmOffset;
        BloodColor = PlayerClass.BloodColor;
    }
    Super(BioPawn).LoadCharacterClassData();
}
public function OnAsyncAppearanceTexturesPreloaded()
{
    local array<Object> LoadedAssets;
    local SFXAsyncAssetLoader oAssetLoader;
    
    if (bAsyncUpdatingAppearance && bInPersonalization && TexturePrestreamIsRequired())
    {
        SetTimer(0.0500000007, FALSE, 'OnAsyncAppearanceTexturesPreloaded', );
        return;
    }
    ApplyAppearance();
    if (__AsyncUpdating_OnCompleted__Delegate != None)
    {
        oAssetLoader = BioDynamicLoadInterface(Class'Engine'.static.GetEngine()).GetAsyncAssetLoader();
        oAssetLoader.GetAssetsForGroup(AsyncGroupName, LoadedAssets);
        __AsyncUpdating_OnCompleted__Delegate(LoadedAssets);
        __AsyncUpdating_OnCompleted__Delegate = None;
    }
    ClearAsyncAssetLoader();
}
public final simulated function OnAsyncAssetsLoaded()
{
    ApplyPendingMorphHead();
    if (bAsyncUpdatingAppearance && bInPersonalization)
    {
        PrestreamTexturesRequiredForAppearance();
    }
    OnAsyncAppearanceTexturesPreloaded();
}
public final function PlayCoverPresentation()
{
    local SFXPlayerController MyPlayerController;
    
    MyPlayerController = SFXPlayerController(Controller);
    MyPlayerController.PlayScaledCameraShake(CoverShake, LastCoverEnterDistance / 375.0);
    PlaySound(EnterCoverSound, TRUE);
    PlaySound(EnterCoverVoc, TRUE);
}
public function PlayerCoverAcquired(CovPosInfo CovInfo, byte SlotIdx)
{
    Super(BioPawn).PlayerCoverAcquired(CovInfo, SlotIdx);
    PlaySound(CoverEnterFoleySound);
    LastCoverEnterDistance = VSize(CovInfo.location - location);
}
public function PrestreamTexturesRequiredForAppearance()
{
    local CustomizableElement DummyElement;
    local HelmetMetaData DummyHelmetData;
    local SkeletalMeshComponent TempComponent;
    local MaterialInterface MaterialOverride;
    
    if (bUseCasualAppearance)
    {
        TempComponent = AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, bIsFemale, Class'SFXPlayerCustomization'.default.CasualAppearances, DummyElement));
        MaterialOverride = Class'SFXPlayerCustomization'.static.GetMaterialOverride(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, bIsFemale, Class'SFXPlayerCustomization'.default.CasualAppearances, DummyElement);
        TempComponent.SetMaterial(0, MaterialOverride);
    }
    else if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(FullBodyID, bIsFemale, Class'SFXPlayerCustomization'.default.FullBodyAppearances, DummyElement));
        AddMeshForTexturePrestream(BuildHelmetMesh(FullBodyID, TRUE, DummyHelmetData));
    }
    else
    {
        AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(ShoulderID, bIsFemale, Class'SFXPlayerCustomization'.default.ShoulderAppearances, DummyElement));
        AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(ArmID, bIsFemale, Class'SFXPlayerCustomization'.default.ArmAppearances, DummyElement));
        AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(LegID, bIsFemale, Class'SFXPlayerCustomization'.default.LegAppearances, DummyElement));
        AddMeshForTexturePrestream(Class'SFXPlayerCustomization'.static.GetMesh(TorsoID, bIsFemale, Class'SFXPlayerCustomization'.default.TorsoAppearances, DummyElement));
        AddMeshForTexturePrestream(BuildHelmetMesh(HelmetID, FALSE, DummyHelmetData));
    }
    PrestreamTextures(-1.0, TRUE);
}
public final function RemoveWeaponEncumbranceBonus(SFXGameEffect Bonus)
{
    local SFXGameEffect Effect;
    local float fBonus;
    
    if (Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (EncumbranceCapacityBonuses.Find(Bonus) != -1)
    {
        EncumbranceCapacityBonuses.RemoveItem(Bonus);
        foreach EncumbranceCapacityBonuses(Effect, )
        {
            fBonus += Effect.EffectValue;
        }
        EncumbranceCapacity = PlayerClass.StartingEncumbranceCapacity + fBonus;
        UpdateWeaponEncumbrance();
    }
}
public final function bool RequiresFullHelmet()
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(WorldInfo);
    return bFullHelmetRequired || BWI != None && BWI.m_bPlayerRequiresFullHelmet;
}
public final function ResetPendingMorphData()
{
    PendingMorphHeadData.HairMesh = 'None';
    PendingMorphHeadData.AccessoryMeshes.Length = 0;
    PendingMorphHeadData.MorphFeatures.Length = 0;
    PendingMorphHeadData.OffsetBones.Length = 0;
    PendingMorphHeadData.LOD0Vertices.Length = 0;
    PendingMorphHeadData.LOD1Vertices.Length = 0;
    PendingMorphHeadData.LOD2Vertices.Length = 0;
    PendingMorphHeadData.LOD3Vertices.Length = 0;
    PendingMorphHeadData.ScalarParameters.Length = 0;
    PendingMorphHeadData.VectorParameters.Length = 0;
    PendingMorphHeadData.TextureParameters.Length = 0;
    PendingMorphHeadResources.Length = 0;
    bHasPendingSavedMorphHead = FALSE;
    bHasPendingExistingMorphHead = FALSE;
}
public final function ResetSkeletalMesh(SkeletalMeshComponent InComponent, SkeletalMesh InMesh)
{
    local int MatIdx;
    
    for (MatIdx = 0; MatIdx < InComponent.GetNumElements(); ++MatIdx)
    {
        InComponent.SetMaterial(MatIdx, None);
    }
    InComponent.SetSkeletalMesh(InMesh);
}
public simulated function RestoreDefaultHelmetState(optional bool bForceUpdate = TRUE)
{
    local EHelmetState CurHelmetState;
    
    CurHelmetState = GetCurrentHelmetState();
    if (CurHelmetState == EHelmetState.HS_ForcedOn_Full && !bHelmetIsFull)
    {
        if (!bFullHelmetRequired)
        {
            bFullHelmetRequired = TRUE;
            if (OverrideHelmetID <= 0)
            {
                ClientMessage("Forcing a full helmet resulted in rebuilding appearances - expect a hitch with cooked content!");
                UpdateAppearance();
            }
            else
            {
                UpdateHelmetComponent();
            }
        }
    }
    else if (bFullHelmetRequired)
    {
        UpdateHelmetComponent();
        bFullHelmetRequired = FALSE;
    }
    Super.RestoreDefaultHelmetState(bForceUpdate);
}
private final simulated function SetFaceFXAsset(string dynamicLoadPath)
{
    local SFXModule_Conversation ConvoMod;
    local FaceFXAsset Face;
    
    Face = FaceFXAsset(FindObject(dynamicLoadPath, Class'FaceFXAsset'));
    if (Face != None)
    {
        ConvoMod = GetModule(Class'SFXModule_Conversation');
        if (ConvoMod != None && ConvoMod.m_pDefaultFaceFXAsset == None)
        {
            ConvoMod.m_pDefaultFaceFXAsset = Face;
        }
    }
}
public simulated function bool ShouldShowHUDGrenadeCounter()
{
    return FindPower('SFXPowerCustomAction_GrenadeBase') != None && SFXInventoryManager(InvManager).GetMaxGrenades() > 0;
}
public function bool ShouldTossWeapon(SFXWeapon ChkWeapon, SFXWeapon NewWeapon)
{
    local bool bTossWeapon;
    
    bTossWeapon = bTossWeapon || SFXHeavyWeapon(ChkWeapon) != None && SFXHeavyWeapon(NewWeapon) != None;
    bTossWeapon = bTossWeapon || SFXWeapon_SMG_Base(ChkWeapon) != None && SFXWeapon_SMG_Base(NewWeapon) != None;
    bTossWeapon = bTossWeapon || SFXWeapon_Pistol_Base(ChkWeapon) != None && SFXWeapon_Pistol_Base(NewWeapon) != None;
    bTossWeapon = bTossWeapon || SFXWeapon_AssaultRifle_Base(ChkWeapon) != None && SFXWeapon_AssaultRifle_Base(NewWeapon) != None;
    bTossWeapon = bTossWeapon || SFXWeapon_Shotgun_Base(ChkWeapon) != None && SFXWeapon_Shotgun_Base(NewWeapon) != None;
    bTossWeapon = bTossWeapon || SFXWeapon_SniperRifle_Base(ChkWeapon) != None && SFXWeapon_SniperRifle_Base(NewWeapon) != None;
    return bTossWeapon;
}
public function SPCamperBuster()
{
    if (VSize(location - CamperAverageLoc) > CampingTolerance)
    {
        CamperAverageLoc = location;
        CampingTickCounter = 0;
        return;
    }
    CamperAverageLoc = (CamperAverageLoc * float(CampingTickCounter) + location) / float((CampingTickCounter + 1));
    if (float(CampingTickCounter) * CamperBusterDelay > float(60))
    {
        return;
    }
    CampingTickCounter++;
}
public function bool SwitchToBackupWeapon()
{
    local SFXWeapon BestWeapon;
    local SFXWeapon PotentialWeapon;
    local BioPlayerController PC;
    local BioPlayerInput BPInput;
    local Name PotentialWeaponName;
    
    if (Weapon == None || Weapon.IsInState('WeaponEquipping', ) || Weapon.IsInState('WeaponPuttingDown', ))
    {
        return FALSE;
    }
    PC = BioPlayerController(Controller);
    if (PC != None)
    {
        BPInput = BioPlayerInput(PC.PlayerInput);
        if (BPInput == None || BPInput.IsCombatEnabled() == FALSE)
        {
            return FALSE;
        }
    }
    if (IsPerformingBlockingAction() || IsUsingPower())
    {
        return FALSE;
    }
    if (IsInCoverLeaning())
    {
        return FALSE;
    }
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', PotentialWeapon)
        {
            if (PotentialWeapon == Weapon || !PotentialWeapon.bQuickSwitchEligible)
            {
                continue;
            }
            PotentialWeaponName = Name(PathName(PotentialWeapon.Class));
            if (PotentialWeaponName == SecondaryWeapon)
            {
                BestWeapon = PotentialWeapon;
                break;
            }
            BestWeapon = PotentialWeapon;
        }
    }
    if (BestWeapon != None)
    {
        BioPlayerController(Controller).SetZoomed(FALSE);
        BioPlayerController(Controller).OrderWeaponSwitch(Self, BestWeapon);
        return TRUE;
    }
    return FALSE;
}
public function TransferModsToNewWeapon(array<Name> PreviousWeaponNames, Name NewWeaponClass)
{
    local Name PreviousWeaponName;
    local SFXEngine Eng;
    local int idx;
    local int Idx2;
    local WeaponModSaveRecord NewRecord;
    
    if (InvManager == None)
    {
        return;
    }
    Eng = Class'SFXEngine'.static.GetSFXEngine();
    if (Eng == None)
    {
        return;
    }
    foreach PreviousWeaponNames(PreviousWeaponName, )
    {
        if (int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(PreviousWeaponName)) != int(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategoryFromClassName(NewWeaponClass)))
        {
            continue;
        }
        idx = Eng.PlayerWeaponMods.Find('WeaponClassName', PreviousWeaponName);
        if (idx < 0)
        {
            continue;
        }
        else
        {
            Idx2 = Eng.PlayerWeaponMods.Find('WeaponClassName', NewWeaponClass);
            if (Idx2 < 0)
            {
                NewRecord.WeaponClassName = NewWeaponClass;
                NewRecord.WeaponModClassNames = Eng.PlayerWeaponMods[idx].WeaponModClassNames;
                Eng.PlayerWeaponMods.AddItem(NewRecord);
            }
        }
    }
}
public final simulated function UpdateAppearanceAsync(optional delegate<AsyncUpdating_OnCompleted> CompletedDelegate = None, optional bool bBlockForAssetLoad = FALSE)
{
    local array<SFXAsyncAssetRequest> assetsToLoad;
    local SFXAsyncAssetLoader oAssetLoader;
    local int idx;
    
    ValidateAppearanceIDs();
    oAssetLoader = BioDynamicLoadInterface(Class'Engine'.static.GetEngine()).GetAsyncAssetLoader();
    oAssetLoader.ClearAsyncGroup(AsyncGroupName);
    GetApperanceAssetsForAsyncLoad(assetsToLoad);
    for (idx = 0; idx < PendingMorphHeadResources.Length; ++idx)
    {
        assetsToLoad.AddItem(PendingMorphHeadResources[idx]);
    }
    PendingMorphHeadResources.Length = 0;
    if (!bBlockForAssetLoad)
    {
        bAsyncUpdatingAppearance = TRUE;
        if (CompletedDelegate != None)
        {
            __AsyncUpdating_OnCompleted__Delegate = CompletedDelegate;
        }
        oAssetLoader.AsyncLoadAssets(AsyncGroupName, assetsToLoad, OnAsyncAssetsLoaded);
    }
    else
    {
        oAssetLoader.AsyncLoadAssets(AsyncGroupName, assetsToLoad);
        Class'Engine'.static.FlushAsyncLoading();
        if (oAssetLoader.IsAsyncGroupLoaded(AsyncGroupName))
        {
            OnAsyncAssetsLoaded();
        }
    }
}
private final simulated function UpdateBodyAppearance()
{
    local SkeletalMesh SkelMesh;
    local MaterialInterface MaterialOverride;
    local CompositeSourceMeshes BodySource;
    local CustomizableElement Element;
    local SFXCompositeSkeletalMesh CompositeMesh;
    local WwiseAudioComponent PawnAudioComponent;
    local SkeletalMeshComponent ChildMeshComponent;
    local SFXModule_LookAt LookAtMod;
    local SkeletalMeshComponent HeadComponentToUse;
    
    BaseHelmetMesh = None;
    OverrideHelmetMesh = None;
    BaseHelmetData.bHidesHead = FALSE;
    BaseHelmetData.bHidesHair = FALSE;
    BaseHelmetData.bAffectsVO = FALSE;
    OverrideHelmetData.bHidesHead = FALSE;
    OverrideHelmetData.bHidesHair = FALSE;
    OverrideHelmetData.bAffectsVO = FALSE;
    if (bUseCasualAppearance)
    {
        BodySource.BaseMesh = Class'SFXPlayerCustomization'.static.GetMesh(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, bIsFemale, Class'SFXPlayerCustomization'.default.CasualAppearances, Element);
        MaterialOverride = Class'SFXPlayerCustomization'.static.GetMaterialOverride(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, bIsFemale, Class'SFXPlayerCustomization'.default.CasualAppearances, Element);
        UpdateMeshComponent(m_oHeadGearMesh, None);
    }
    else if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        BodySource.BaseMesh = Class'SFXPlayerCustomization'.static.GetMesh(FullBodyID, bIsFemale, Class'SFXPlayerCustomization'.default.FullBodyAppearances, Element);
        UpdateHelmetComponent();
    }
    else
    {
        SkelMesh = Class'SFXPlayerCustomization'.static.GetMesh(ShoulderID, bIsFemale, Class'SFXPlayerCustomization'.default.ShoulderAppearances, Element);
        if (SkelMesh != None)
        {
            BodySource.Parts.AddItem(SkelMesh);
        }
        SkelMesh = Class'SFXPlayerCustomization'.static.GetMesh(ArmID, bIsFemale, Class'SFXPlayerCustomization'.default.ArmAppearances, Element);
        if (SkelMesh != None)
        {
            BodySource.Parts.AddItem(SkelMesh);
        }
        SkelMesh = Class'SFXPlayerCustomization'.static.GetMesh(LegID, bIsFemale, Class'SFXPlayerCustomization'.default.LegAppearances, Element);
        if (SkelMesh != None)
        {
            BodySource.Parts.AddItem(SkelMesh);
        }
        BodySource.BaseMesh = Class'SFXPlayerCustomization'.static.GetMesh(TorsoID, bIsFemale, Class'SFXPlayerCustomization'.default.TorsoAppearances, Element);
        UpdateHelmetComponent();
    }
    RestoreDefaultHelmetState(FALSE);
    if (BodySource.Parts.Length > 0 && BodySource.BaseMesh != None)
    {
        CompositeMesh = SFXCompositeSkeletalMesh(Mesh.SkeletalMesh);
        HeadComponentToUse = !bIgnoreHeadOffsetsInMeshMerge && HeadMesh.bAttached ? HeadMesh : None;
        if (CompositeMesh == None || !CompositeMesh.MatchesMerge(BodySource.BaseMesh, BodySource.Parts, HeadComponentToUse))
        {
            SkelMesh = Class'SFXCompositeSkeletalMesh'.static.MergeMeshes(BodySource.BaseMesh, BodySource.Parts, HeadComponentToUse);
        }
        else
        {
            SkelMesh = CompositeMesh;
        }
    }
    else if (BodySource.BaseMesh != None)
    {
        SkelMesh = BodySource.BaseMesh;
    }
    PawnAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(Self);
    if (PawnAudioComponent != None)
    {
        PawnAudioComponent.SetWwiseRTPC(m_sWwiseRTPCNameUseCasual, float(bUseCasualAppearance));
    }
    UpdateMeshComponent(Mesh, SkelMesh);
    foreach ComponentList(Class'SkeletalMeshComponent', ChildMeshComponent)
    {
        if (ChildMeshComponent.ParentAnimComponent == Mesh)
        {
            ChildMeshComponent.UpdateParentBoneMap();
        }
    }
    Mesh.SetMaterial(0, MaterialOverride);
    Mesh.InitRBPhys();
    bSpawnPHATInstance = TRUE;
    Mesh.SetHasPhysicsAssetInstance(TRUE);
    LookAtMod = GetModule(Class'SFXModule_LookAt');
    if (LookAtMod != None)
    {
        LookAtMod.Cleanup();
        LookAtMod.Setup();
    }
}
public simulated function UpdateGameEffects()
{
    local array<Class<SFXGameEffect>> Effects;
    local SFXModule_GameEffectManager Manager;
    
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        ClientMessage("Unable to give effect - Player does not have an SFXModule_GameEffectManager");
        return;
    }
    if (bUseCasualAppearance)
    {
        GetGameEffects(OverrideCasualID >= 0 ? OverrideCasualID : CasualID, Class'SFXPlayerCustomization'.default.CasualAppearances, Effects);
    }
    else if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        GetGameEffects(FullBodyID, Class'SFXPlayerCustomization'.default.FullBodyAppearances, Effects);
        GetHelmetGameEffects(Effects);
    }
    else
    {
        GetHelmetGameEffects(Effects);
        GetGameEffects(ShoulderID, Class'SFXPlayerCustomization'.default.ShoulderAppearances, Effects);
        GetGameEffects(ArmID, Class'SFXPlayerCustomization'.default.ArmAppearances, Effects);
        GetGameEffects(LegID, Class'SFXPlayerCustomization'.default.LegAppearances, Effects);
        GetGameEffects(TorsoID, Class'SFXPlayerCustomization'.default.TorsoAppearances, Effects);
    }
    Manager.UpdateEffectsByCategory(Effects, 'PersonalizationEffects', Controller);
}
private final simulated function UpdateHairAppearance()
{
    if (MorphHead != None)
    {
        if (m_oHairMesh == None)
        {
            m_oHairMesh = new (Self) Class'SkeletalMeshComponent';
        }
        m_oHairMesh.SetSkeletalMesh(MorphHead.m_oHairMesh);
        m_oHairMesh.bTransformFromAnimParent = 1;
        m_oHairMesh.SetParentAnimComponent(Mesh);
        m_oHairMesh.SetShadowParent(Mesh);
        m_oHairMesh.SetLightEnvironment(LightEnvironment);
    }
}
private final simulated function UpdateHeadAppearance()
{
    local SkeletalMesh SkelMesh;
    local int i;
    
    if (MorphHead != None)
    {
        SkelMesh = MorphHead.m_oBaseHead;
        if (bIsFemale)
        {
            SetFaceFXAsset(Class'SFXPlayerCustomization'.default.FemaleMorphHeadFaceFXAsset);
        }
        else
        {
            SetFaceFXAsset(Class'SFXPlayerCustomization'.default.MaleMorphHeadFaceFXAsset);
        }
    }
    else if (bIsFemale)
    {
        SkelMesh = SkeletalMesh(FindObject(Class'SFXPlayerCustomization'.default.FemaleIconicHeadMesh, Class'SkeletalMesh'));
        SetFaceFXAsset(Class'SFXPlayerCustomization'.default.FemaleIconicFaceFXAsset);
    }
    else
    {
        SkelMesh = SkeletalMesh(FindObject(Class'SFXPlayerCustomization'.default.MaleIconicHeadMesh, Class'SkeletalMesh'));
        SetFaceFXAsset(Class'SFXPlayerCustomization'.default.MaleIconicFaceFXAsset);
    }
    HeadMesh.bOverrideParentSkeleton = TRUE;
    if (SkelMesh != None)
    {
        HeadMesh.SetSkeletalMesh(SkelMesh);
        for (i = 0; i < HeadMesh.Materials.Length; i++)
        {
            HeadMesh.SetMaterial(i, None);
        }
    }
}
private final simulated function UpdateHelmetComponent()
{
    local EHelmetState CurForcedState;
    local SkeletalMesh SkelMesh;
    
    if (CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        BaseHelmetMesh = BuildHelmetMesh(FullBodyID, TRUE, BaseHelmetData);
    }
    else
    {
        BaseHelmetMesh = BuildHelmetMesh(HelmetID, FALSE, BaseHelmetData);
    }
    OverrideHelmetMesh = BuildHelmetMesh(OverrideHelmetID, FALSE, OverrideHelmetData);
    CurForcedState = GetCurrentHelmetState();
    bUsingOverrideHelmet = FALSE;
    if (bInPersonalization)
    {
        SkelMesh = BaseHelmetMesh;
    }
    else if (CurForcedState == EHelmetState.HS_ForcedOn_Full)
    {
        if (bHelmetIsFull)
        {
            SkelMesh = BaseHelmetMesh;
        }
        else
        {
            bUsingOverrideHelmet = TRUE;
            SkelMesh = OverrideHelmetMesh;
        }
    }
    else if (CurForcedState == EHelmetState.HS_ForcedOn || CurForcedState == EHelmetState.HS_Default)
    {
        SkelMesh = BaseHelmetMesh;
    }
    if (SkelMesh == BaseHelmetMesh)
    {
        bHelmetHidesHair = BaseHelmetData.bHidesHair;
        bHelmetHidesHead = BaseHelmetData.bHidesHead;
        bHelmetAffectsVO = BaseHelmetData.bAffectsVO;
    }
    else
    {
        bHelmetHidesHair = OverrideHelmetData.bHidesHair;
        bHelmetHidesHead = OverrideHelmetData.bHidesHead;
        bHelmetAffectsVO = OverrideHelmetData.bAffectsVO;
    }
    UpdateMeshComponent(m_oHeadGearMesh, SkelMesh);
}
public function UpdateMappedPowerDisplay();

public final simulated function UpdateMaterialParameters(SFXCustomizationInstance InSettings, Actor InTargetActor, SkeletalMeshComponent InHeadMesh, bool bHideScars)
{
    local BioMaterialOverride IconicOverride;
    local ScarInfo Scar;
    
    if (InSettings != None)
    {
        InSettings.ApplyMaterialTinting(InTargetActor);
    }
    if (InHeadMesh != None)
    {
        GetCurrentScarStruct(bHideScars, Scar);
        Class'SFXPlayerCustomization'.static.ApplyScarParameters(Scar, bIsFemale, InHeadMesh);
    }
    if (MorphHead != None)
    {
        MorphHead.ApplyMaterialOverridesToActor(InTargetActor);
    }
    else
    {
        IconicOverride = Class'SFXPlayerCustomization'.static.FindIconicMaterialOverride(bIsFemale);
        if (IconicOverride != None)
        {
            IconicOverride.ApplyOverride(InTargetActor);
        }
    }
}
public final simulated function UpdateMeshComponent(SkeletalMeshComponent InComponent, SkeletalMesh InMesh)
{
    local Name nmActiveEffectsMaterial;
    local int i;
    local bool bPreserveAnimation;
    
    if (InComponent == None)
    {
        return;
    }
    if (InMesh == None)
    {
        for (i = 0; i < InComponent.GetNumElements(); ++i)
        {
            InComponent.SetMaterial(i, None);
        }
        InComponent.SetSkeletalMesh(InMesh);
        InComponent.ClearEffectsMaterial();
        return;
    }
    if (InComponent.SkeletalMesh == None || InComponent.SkeletalMesh != InMesh)
    {
        nmActiveEffectsMaterial = InComponent.GetEffectsMaterial();
        InComponent.ClearEffectsMaterial();
        for (i = 0; i < InComponent.GetNumElements(); ++i)
        {
            InComponent.SetMaterial(i, None);
        }
        bPreserveAnimation = FALSE;
        if (bInPersonalization && InComponent.SkeletalMesh != None && InComponent.SkeletalMesh.Class == InMesh.Class && Class'SkeletalMeshComponent'.static.RefSkeletonsMatch(InComponent.SkeletalMesh, InMesh))
        {
            bPreserveAnimation = TRUE;
        }
        if ((bUseCasualAppearance || CombatAppearance == EPlayerAppearanceType.PlayerAppearanceType_Full) && InComponent.SkeletalMesh != InMesh)
        {
            bPreserveAnimation = FALSE;
        }
        InComponent.SetSkeletalMesh(InMesh, bPreserveAnimation);
        InComponent.SetEffectsMaterial(nmActiveEffectsMaterial);
    }
}
public final simulated function UpdateParameters()
{
    UpdateMaterialParameters(CreateTemporaryCustomizationInstance(), Self, HeadMesh, FALSE);
}
public function UpdatePlayerLoadoutInfo()
{
    local SFXWeapon ChkWeapon;
    local SFXInventoryManager InvMan;
    local SFXEngine Engine;
    local int GroupIdx;
    local int EntryIdx;
    local int i;
    
    if (SFXPawn_PlayerNonCombat(Self) != None)
    {
        return;
    }
    InvMan = SFXInventoryManager(InvManager);
    if (PlayerController(Controller) != None)
    {
        Engine = SFXEngine(PlayerController(Controller).Player.Outer);
        if (Engine != None)
        {
            Engine.PlayerLoadoutGroups.Length = 0;
            for (i = 0; i < 6; i++)
            {
                Engine.PlayerLoadoutWeapons[i] = 'None';
            }
            foreach InvMan.InventoryActors(Class'SFXWeapon', ChkWeapon)
            {
                Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(ChkWeapon.Class, GroupIdx, EntryIdx);
                Engine.PlayerLoadoutGroups.AddItem(byte(GroupIdx));
                if (Engine.PlayerLoadoutWeapons[GroupIdx] != Name(PathName(ChkWeapon.Class)))
                {
                    Engine.PlayerLoadoutWeapons[GroupIdx] = Name(PathName(ChkWeapon.Class));
                }
            }
        }
    }
}
public final function UpdatePrimaryAndSecondaryWeapons(optional Name NewWeaponName = 'None')
{
    local Name NameHolder;
    
    if (NewWeaponName == 'None' || NewWeaponName == SecondaryWeapon)
    {
        NameHolder = PrimaryWeapon;
        PrimaryWeapon = SecondaryWeapon;
        SecondaryWeapon = NameHolder;
    }
    else if (NewWeaponName != PrimaryWeapon)
    {
        SecondaryWeapon = PrimaryWeapon;
        PrimaryWeapon = NewWeaponName;
    }
}
public final function UpdateWeaponEncumbrance()
{
    local float fEncumbrance;
    local SFXWeapon oWeapon;
    local int WeaponID;
    local int WeaponClassID;
    local bool bWeaponFound;
    
    if (InvManager == None || Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', oWeapon)
    {
        if (SFXHeavyWeapon(oWeapon) == None)
        {
            Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(oWeapon.Class, WeaponClassID, WeaponID);
            if (WeaponClassID >= 0 && WeaponClassID < 6)
            {
                bWeaponFound = TRUE;
                if (oWeapon.EncumbranceWeight.Value + (WeaponEncumbranceModifiers[WeaponClassID].Value - 1.0) > float(0))
                {
                    fEncumbrance += oWeapon.EncumbranceWeight.Value + (WeaponEncumbranceModifiers[WeaponClassID].Value - 1.0);
                }
            }
        }
    }
    if (bWeaponFound)
    {
        CurrentWeaponEncumbrance = GetWeaponEncumbranceCooldown(fEncumbrance);
    }
    ApplyWeaponEncumbrance();
}
public simulated function UpdateWeaponVisibility_DEPRECATED()
{
    local SFXWeapon ChkWeapon;
    
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', ChkWeapon)
        {
            if (ChkWeapon != None && ChkWeapon.Mesh != None)
            {
                if (bUseCasualAppearance && !bCombatPawn)
                {
                    ChkWeapon.SetWeaponHidden(TRUE);
                }
            }
        }
    }
}
public function UseReviveConsumablePower();

private final simulated function ValidateAppearanceIDs()
{
    if (Class'SFXPlayerCustomization'.default.CasualAppearances.Find('Id', CasualID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.CasualAppearances.Length > 0)
        {
            CasualID = Class'SFXPlayerCustomization'.default.CasualAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.FullBodyAppearances.Find('Id', FullBodyID) == -1)
    {
        CombatAppearance = EPlayerAppearanceType.PlayerAppearanceType_Parts;
        FullBodyID = 0;
    }
    if (Class'SFXPlayerCustomization'.default.TorsoAppearances.Find('Id', TorsoID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.TorsoAppearances.Length > 0)
        {
            TorsoID = Class'SFXPlayerCustomization'.default.TorsoAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.ShoulderAppearances.Find('Id', ShoulderID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.ShoulderAppearances.Length > 0)
        {
            ShoulderID = Class'SFXPlayerCustomization'.default.ShoulderAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.ArmAppearances.Find('Id', ArmID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.ArmAppearances.Length > 0)
        {
            ArmID = Class'SFXPlayerCustomization'.default.ArmAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.LegAppearances.Find('Id', LegID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.LegAppearances.Length > 0)
        {
            LegID = Class'SFXPlayerCustomization'.default.LegAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.HelmetAppearances.Find('Id', HelmetID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.HelmetAppearances.Length > 0)
        {
            HelmetID = Class'SFXPlayerCustomization'.default.HelmetAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.SpecAppearances.Find('Id', SpecID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.SpecAppearances.Length > 0)
        {
            SpecID = Class'SFXPlayerCustomization'.default.SpecAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.Tint1Appearances.Find('Id', Tint1ID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.Tint1Appearances.Length > 0)
        {
            Tint1ID = Class'SFXPlayerCustomization'.default.Tint1Appearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.Tint2Appearances.Find('Id', Tint2ID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.Tint2Appearances.Length > 0)
        {
            Tint2ID = Class'SFXPlayerCustomization'.default.Tint2Appearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.PatternAppearances.Find('Id', PatternID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.PatternAppearances.Length > 0)
        {
            PatternID = Class'SFXPlayerCustomization'.default.PatternAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.PatternColorAppearances.Find('Id', PatternColorID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.PatternColorAppearances.Length > 0)
        {
            PatternColorID = Class'SFXPlayerCustomization'.default.PatternColorAppearances[0].Id;
        }
    }
    if (Class'SFXPlayerCustomization'.default.EmissiveAppearances.Find('Id', EmissiveID) == -1)
    {
        if (Class'SFXPlayerCustomization'.default.EmissiveAppearances.Length > 0)
        {
            EmissiveID = Class'SFXPlayerCustomization'.default.EmissiveAppearances[0].Id;
        }
    }
}

simulated state Downed 
{
    ignores HitWall, Falling, PhysicsVolumeChange, Bump, HeadVolumeChange
    ;
    public event simulated function OnEnterRagdoll()
    {
        bPlayerInRagdoll = bIsAPlayer;
    }
    public event simulated function EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
        if (SFXGRI(WorldInfo.GRI).WaveCoordinator != None)
        {
            SFXGRI(WorldInfo.GRI).WaveCoordinator.PawnRevived(Self);
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        if (SFXGRI(WorldInfo.GRI).WaveCoordinator != None)
        {
            SFXGRI(WorldInfo.GRI).WaveCoordinator.PawnDowned(Self);
        }
    }
    public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation);
    
    public function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
    
    public function BreathTimer();
    
    
    stop;
};
state Ragdoll 
{
    public event function BeginState(Name PreviousStateName)
    {
        Super(Object).BeginState(PreviousStateName);
        if (BioPlayerController(Controller) != None)
        {
            BioPlayerController(Controller).SetZoomed(FALSE);
        }
    }
    
    stop;
};
state Dying 
{
    public event function Timer();
    
    public function BeginState(Name PreviousStateName);
    
    
Begin:
    stop;
};

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        CurrentWeaponEncumbrance;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
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
    Begin Object Class=ForceFeedbackWaveform Name=CoverEnterSound0
        Samples = ({Duration = 0.0, LeftAmplitude = 0, RightAmplitude = 0, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}, 
                   {Duration = 0.5, LeftAmplitude = 45, RightAmplitude = 45, LeftFunction = EWaveformFunction.WF_LinearIncreasing, RightFunction = EWaveformFunction.WF_LinearIncreasing}
                  )
    End Object
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
    Begin Template Class=SFXModule_Locomotion Name=Locomotion0
    End Template
    Begin Object Class=SFXModule_DamagePlayer Name=DmgMod1
        MaxHealth = {X = 500.0, Y = 500.0}
    End Object
    WeaponEncumbranceModifiers[0] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[1] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[2] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[3] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[4] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[5] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    m_sWwiseRTPCNameUseCasual = "Casual_Clothing"
    PermanentGameEffects = ({
                             UniqueName = "Intel_AdvancedBioticAmps_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_AdvancedBioticAmps_PowerCooldown", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_Feron_AmmoCapacity", 
                             className = "SFXGameContent.SFXGameEffect_PassiveMaxAmmoBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_Feron_Shields", 
                             className = "SFXGameContent.SFXGameEffect_ShieldPercentBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_LegionIntel1_Shields", 
                             className = "SFXGameContent.SFXGameEffect_ShieldPercentBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_LegionIntel1_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_LegionIntel2_ShieldRegen", 
                             className = "SFXGame.SFXGameEffect_ShieldRegenBonus", 
                             Value = -0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_LegionIntel2_PowerCooldown", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_PrejekPaddlefish_WeaponDamage", 
                             className = "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                             Value = 0.100000001, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_PrejekPaddlefish_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.100000001, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_SamaraMission_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_IntelligenceArchives_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_IntelligenceArchives_Health", 
                             className = "SFXGameContent.SFXGameEffect_HealthPercentBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_IntactReaperGun_WeaponDamage", 
                             className = "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_IntactReaperGun_AmmoCapacity", 
                             className = "SFXGameContent.SFXGameEffect_PassiveMaxAmmoBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_DestroyedMiniReaper_PowerCooldown", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BioticResearchData_PowerCooldown", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BioticResearchData_PowerDamage", 
                             className = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BattleOfArcturus_WeaponDamage", 
                             className = "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BattleOfArcturus_Shields", 
                             className = "SFXGameContent.SFXGameEffect_ShieldPercentBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BattleFootage_AmmoCapacity", 
                             className = "SFXGameContent.SFXGameEffect_PassiveMaxAmmoBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_BattleFootage_WeaponDamage", 
                             className = "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }, 
                            {
                             UniqueName = "Intel_MedicalUpgrade_Health", 
                             className = "SFXGameContent.SFXGameEffect_HealthPercentBonus", 
                             Value = 0.0500000007, 
                             Type = EPermanentGameEffect_Type.PermanentGEType_Player, 
                             GAWAssetType = EGAWAssetType.GAWAssetType_Military, 
                             GAWAssetSubType = EGAWAssetSubType.GAWAssetSubType_None
                            }
                           )
    ArmorEffectDescriptions = ({
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_AmmoCapacityBonus", 
                                EffectDescription = ($718122), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ConstraintDamageBonus", 
                                EffectDescription = ($683403), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_HealthBonus", 
                                EffectDescription = ($683396), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_MeleeDamageBonus", 
                                EffectDescription = ($683400), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerCooldownBonus", 
                                EffectDescription = ($718121), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerDamageBonus", 
                                EffectDescription = ($683399), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldBonus", 
                                EffectDescription = ($683395), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldRegenBonus", 
                                EffectDescription = ($683401), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_WeaponDamageBonus", 
                                EffectDescription = ($683402), 
                                EffectToken = ("10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_AmmoCapacityBonus_Weak", 
                                EffectDescription = ($718122), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ConstraintDamageBonus_Weak", 
                                EffectDescription = ($683403), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_HealthBonus_Weak", 
                                EffectDescription = ($683396), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_MeleeDamageBonus_Weak", 
                                EffectDescription = ($683400), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerCooldownBonus_Weak", 
                                EffectDescription = ($718121), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerDamageBonus_Weak", 
                                EffectDescription = ($683399), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldBonus_Weak", 
                                EffectDescription = ($683395), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldRegenBonus_Weak", 
                                EffectDescription = ($683401), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_PartBasedArmor_WeaponDamageBonus_Weak", 
                                EffectDescription = ($683402), 
                                EffectToken = ("5")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_BloodDragon", 
                                EffectDescription = ($683395, $683399, $718121), 
                                EffectToken = ("20", "30", "10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Cerberus", 
                                EffectDescription = ($683396, $683395, $683402, $718122), 
                                EffectToken = ("20", "10", "20", "10")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Collector", 
                                EffectDescription = ($683396, $683395, $683401), 
                                EffectToken = ("20", "20", "20")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Inferno", 
                                EffectDescription = ($683399, $718121), 
                                EffectToken = ("30", "30")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Reckoning", 
                                EffectDescription = ($683396, $683395, $683402, $683400), 
                                EffectToken = ("10", "10", "10", "20")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Tank", 
                                EffectDescription = ($683396, $683395, $683402, $718122), 
                                EffectToken = ("10", "10", "10", "20")
                               }, 
                               {
                                ArmorEffect = "SFXGameContent.SFXGameEffect_UniqueArmor_Terminus", 
                                EffectDescription = ($683395, $718122, $683400), 
                                EffectToken = ("30", "15", "15")
                               }
                              )
    HitShake = {
                RotAmplitude = {X = 110.0, Y = 70.0, Z = 50.0}, 
                RotFrequency = {X = 0.200000003, Y = 0.200000003, Z = 0.200000003}, 
                RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                ShakeName = 'None', 
                TimeToGo = 0.0, 
                TimeDuration = 0.150000006, 
                RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                FOVAmplitude = 0.0, 
                FOVFrequency = 0.0, 
                FOVSinOffset = 0.0, 
                TargetingDampening = 0.0, 
                bOverrideTargetingDampening = FALSE, 
                FOVParam = EShakeParam.ESP_OffsetRandom
               }
    ZoomHitShake = {
                    RotAmplitude = {X = 140.0, Y = 80.0, Z = 60.0}, 
                    RotFrequency = {X = 0.200000003, Y = 0.200000003, Z = 0.200000003}, 
                    RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                    LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                    LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                    ShakeName = 'None', 
                    TimeToGo = 0.0, 
                    TimeDuration = 0.100000001, 
                    RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                    LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                    FOVAmplitude = 0.0, 
                    FOVFrequency = 0.0, 
                    FOVSinOffset = 0.0, 
                    TargetingDampening = 0.0, 
                    bOverrideTargetingDampening = FALSE, 
                    FOVParam = EShakeParam.ESP_OffsetRandom
                   }
    CoverShake = {
                  RotAmplitude = {X = 36.0, Y = 36.0, Z = 64.0}, 
                  RotFrequency = {X = 36.0, Y = 0.0, Z = 134.0}, 
                  RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                  LocAmplitude = {X = 4.0, Y = 3.0, Z = 3.0}, 
                  LocFrequency = {X = 26.0, Y = 17.0, Z = 17.0}, 
                  LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                  ShakeName = 'None', 
                  TimeToGo = 0.0, 
                  TimeDuration = 0.600000024, 
                  RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                  LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                  FOVAmplitude = 2.5, 
                  FOVFrequency = 5.5, 
                  FOVSinOffset = 0.0, 
                  TargetingDampening = 0.0, 
                  bOverrideTargetingDampening = FALSE, 
                  FOVParam = EShakeParam.ESP_OffsetRandom
                 }
    AsyncGroupName = 'AsyncAppearanceUpdate'
    PermanentGameEffect_CategoryPrefix = 'PermanentPlayerGameEffect_'
    EncumbranceEffectName = 'WeaponEncumbranceModifier'
    PopUpDamageMultiplier = {X = -0.800000012, Y = -0.200000003}
    OverrideCasualID = -1
    OverrideHelmetID = -1
    OutOfAmmoSwapThreshold = 0.400000006
    ShieldImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_impact_player_armor'
    ImpactSound = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_impact_player_flesh'
    m_GUI_Icon = Texture2D'GUI_Icons.CharacterPortraits.Icon_N7'
    CampingTolerance = 300.0
    CamperBusterDelay = 1.0
    EnterCoverSound = WwiseEvent'Wwise_Generic_Foley.Play_foley_movement_EnterFoley'
    EnterCoverVoc = WwiseEvent'Wwise_VO_Exertions.Play_Exertion_Jumping_Medium_Down'
    CoverForceFeedback = CoverEnterSound0
    CoverEnterFoleySound = None
    PopUpDamageMultiplierDuration = 1.5
    MaxTotalReputation = 1055
    ParagonScarBias = 1.0
    FullParagonScarBiasValue = 180.0
    NoParagonScarBiasValue = 600.0
    bCanRoll = TRUE
    bCanBeStopped = TRUE
    PrettyName = $125303
    FootstepForceFeedback = FootstepShakeFF0
    bCanDriveAtlas = TRUE
    CustomActionClasses = (None, 
                           Class'SFXCustomAction_Ragdoll', 
                           None, 
                           Class'SFXCustomAction_SyncPawnPartner_Base', 
                           Class'SFXCustomAction_Utilize', 
                           None, 
                           None, 
                           Class'SFXCustomAction_BovineFortitude', 
                           Class'SFXCustomAction_Frozen', 
                           None, 
                           Class'SFXCustomAction_MountedGunReload', 
                           Class'SFXCustomAction_HolsterWeapon', 
                           Class'SFXCustomAction_DrawWeapon', 
                           Class'SFXCustomAction_EnterMountedGun', 
                           Class'SFXCustomAction_ExitMountedGun', 
                           None, 
                           None, 
                           Class'SFXCustomAction_HackDoor', 
                           Class'SFXCustomAction_OmniWave', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_Cover90TurnRight', 
                           Class'SFXCustomAction_Cover90TurnRightStanding', 
                           Class'SFXCustomAction_Cover90TurnLeft', 
                           Class'SFXCustomAction_Cover90TurnLeftStanding', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_BackTakeDown', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_HeavyStdCoverMeleeRight', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_PlayerShieldStandardImpact', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_ExplosionBack', 
                           Class'SFXCustomAction_ExplosionForward', 
                           Class'SFXCustomAction_ExplosionLeft', 
                           Class'SFXCustomAction_ExplosionRight', 
                           Class'SFXCustomAction_ShieldFace'
                          )
    SupportedCustomReachSpecs = (Class'SFXLadderReachSpec', Class'SFXJumpReachSpec')
    SupportedSyncActions = ('AtlasSync', 'PhantomSync', 'KaiLengSync', 'HuskSync', 'BruteSync', 'BansheeSync', 'DriveAtlas')
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    AimOffsetInterpSpeed = 0.0
    BloodColor = {B = 1, G = 1, R = 12, A = 255}
    PowerManager = PowerMgr
    bSpawnPHATInstance = FALSE
    bDisablePlayerPortArmsEvenIfFriendly = TRUE
    bHeadGearVisible = TRUE
    bShouldSpawnWeapons = FALSE
    bScalePowers = FALSE
    InventoryManagerClass = Class'SFXPlayerInventoryManager'
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    ViewPitchMin = -10922.0
    ViewPitchMax = 10922.0
    BioSoftwareSkinned = TRUE
    bCanMantle = TRUE
    bCanClimbUp = TRUE
    bCanSwatTurn = TRUE
    bCanPickupInventory = TRUE
    bDontPossess = TRUE
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0, 
               Locomotion0, 
               DmgMod1
              )
    RotationRate = {Pitch = 16384, Yaw = 500000, Roll = 16384}
    CollisionComponent = CollisionCylinder
}