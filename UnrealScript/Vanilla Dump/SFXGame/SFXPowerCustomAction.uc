Class SFXPowerCustomAction extends SFXPowerCustomActionBase
    abstract
    config(Game);

struct EvolvedSoundStruct 
{
    var WwiseEvent Sound;
    var bool bAnyEvolved;
    var bool bReplaceBaseSound;
    var EEvolveChoice EvolveChoice;
};
enum ECastingPhase
{
    CP_Start,
    CP_End,
};
enum EClientNoCooldownDecision
{
    NoCooldown_NoDecision,
    NoCooldown_Success,
    NoCooldown_Failure,
};
struct DelayedPowerComboData 
{
    var Vector HitLocation;
    var Vector HitNormal;
    var SFXGameEffect_PowerCombo ComboEffect;
    var BioPawn TargetPawn;
};
enum EBioCapabilityTypes
{
    BioCaps_Normal,
    BioCaps_Death,
};

var array<Actor> m_ImpactedActors;
var array<SFXProjectile_PowerCustomAction> Projectiles;
var array<Class<SFXGameEffect_PowerCombo>> ComboDetonators;
var config array<string> PowerComboTypes;
var BodyStance BS_StartCastAnimation;
var BodyStance BS_EndCastAnimation;
var array<EvolvedSoundStruct> EvolvedImpactSounds;
var array<EvolvedSoundStruct> EvolvedReleaseSounds;
var array<EvolvedSoundStruct> EvolvedCastSounds;
var array<EvolvedSoundStruct> HenchmanEvolvedImpactSounds;
var array<EvolvedSoundStruct> HenchmanEvolvedReleaseSounds;
var array<EvolvedSoundStruct> HenchmanEvolvedCastSounds;
var Class<SFXDamageType> DefaultDamageType;
var Class<SFXDamageType> NonRagdollDamageType;
var Class<SFXProjectile_PowerCustomAction> ProjectileClass;
var Class<SFXRumble_Power> DetonationRumbleClass;
var Class<SFXShake_Power> DetonationScreenShakeClass;
var config AreaEffectParameters DetonationParameters;
var DelayedPowerComboData DelayedPowerCombo;
var transient Vector m_vDetonationHitLocation;
var transient Vector m_vDetonationHitNormal;
var Vector CustomCasterCrustParameters;
var Name ProjectileAttachPoint;
var Name ReleaseEffectBoneName;
var float ProjectileRadius;
var float ReleaseTime;
var float TimeSinceStart;
var float LastPhysicsCallbackTime;
var float MinTimeBetweenPhysicsCallbacks;
var config float PhysicsToDamageMultiplier;
var config float PowerAssistFullControlValue;
var config float PowerAssistPartialControlValue;
var config float PowerComboDelay;
var stringref Recommended_TargetVulnerable;
var stringref NotRecommended_TargetOrganic;
var stringref NotRecommended_TargetMachine;
var stringref NotRecommended_TargetHasShields;
var stringref NotRecommended_TargetHasBiotics;
var stringref NotRecommended_TargetHasArmor;
var stringref NotRecommended_NoMedigel;
var stringref NotRecommended_NoSquadMemberDead;
var stringref NotRecommended_NoSquadMemberInjured;
var stringref NotRecommended_WeaponPowerAlreadyOn;
var stringref NotRecommended_TargetImmune;
var const stringref StatBarTitle_Damage;
var const stringref StatBarTitle_DamagePerSecond;
var const stringref StatBarTitle_Force;
var const stringref StatBarTitle_Cooldown;
var const stringref StatBarTitle_Duration;
var const stringref StatBarTitle_ImpactRadius;
var const stringref StatBarTitle_Range;
var const stringref StatBarTitle_ParagonRenegade;
var const stringref StatBarTitle_PowerDamage;
var const stringref StatBarTitle_WeaponDamage;
var const stringref StatBarTitle_WeightCapacity;
var const stringref StatBarTitle_HealthShield;
var const stringref StatBarTitle_MeleeDamage;
var const stringref StatBarTitle_HealthDamage;
var const stringref StatBarTitle_ArmorDamage;
var const stringref StatBarTitle_BarrierDamage;
var const stringref StatBarTitle_ShieldBarrierDamage;
var const stringref StatBarTitle_FreezeDuration;
var const stringref StatBarTitle_DamageReduction;
var const stringref StatBarToken_RawValue;
var const stringref StatBarToken_Force;
var const stringref StatBarToken_Time;
var const stringref StatBarToken_Distance;
var const stringref StatBarToken_Percent;
var const stringref StatBarToken_PositivePercent;
var const stringref StatBarToken_NegativePercent;
var AnimSet CastAnimSet;
var AnimSet HenchCastAnimSet;
var CameraAnim CastCameraAnim;
var float CameraAnimPlayRate;
var float CameraAnimBlendIn;
var float CameraAnimBlendOut;
var float CameraAnimDuration;
var float fAnimPlayRate;
var float fStartAnimBlendInTime;
var float fStartAnimBlendOutTime;
var float fEndAnimBlendInTime;
var float fEndAnimBlendOutTime;
var float fAnimStartTime;
var RvrClientEffectInterface CE_CasterCrustTemplate;
var RvrClientEffectInterface CE_TargetCrustTemplate;
var RvrClientEffectInterface CE_ReleaseEffectTemplate;
var RvrClientEffectInterface CE_ProjectileTemplate;
var RvrClientEffectInterface CE_ImpactTemplate;
var WwiseEvent ImpactSound;
var WwiseEvent ReleaseSound;
var WwiseEvent CastSound;
var WwiseEvent HenchmanImpactSound;
var WwiseEvent HenchmanReleaseSound;
var WwiseEvent HenchmanCastSound;
var WwiseEvent ImpactDistanceLayer;
var WwiseEvent HenchmanImpactDistanceLayer;
var WwiseEvent CancelCastSound;
var WwiseEvent HenchmanCancelCastSound;
var bool bProjectileUsePawnRotation;
var bool bCustomImpactLogic;
var bool ImpactDeadPawns;
var bool ImpactFriends;
var bool ImpactPlaceables;
var bool BlockedByObjects;
var bool BuffAppliesToSquad;
var bool bPowerStarted;
var bool bPowerReleased;
var bool RestoreCoverAction;
var bool WaitingOnLeanOut;
var bool LeanOutToCast;
var bool bOverrideComboDetonate;
var bool bDynamicLoadAnimSet;
var bool bPlayStartCastAnim;
var bool bPlayEndCastAnim;
var bool bAllowAnimInterrupt;
var bool bCustomCasterCrustParameters;
var bool bReleaseFBUsesEffectDuration;
var bool bCustomImpactSound;
var EBioCapabilityTypes CapabilityType;
var EBioCapMode Discipline;
var ECoverAction InitialCoverAction;
var ECastingPhase CastingPhase;
var ERootMotionMode ERootMotionMode;

public function bool CanImpactActor(Actor oActor)
{
    if (oActor == None)
    {
        return FALSE;
    }
    if (oActor.IsA('Pawn') || oActor.IsA('KActor') || oActor.IsA('SFXPlaceable'))
    {
        if (oActor.CollisionComponent != None && oActor.CollisionType != ECollisionType.COLLIDE_NoCollision)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CanUsePower(Actor oTarget)
{
    local float fDistance;
    local string sPowerInfo;
    local BioPawn oPawnTarget;
    local Vector vAimLocation;
    local Actor oHitActor;
    local Vector vHitLocation;
    local Vector vHitNormal;
    
    if (m_oPawn.Role == ENetRole.ROLE_SimulatedProxy)
    {
        return TRUE;
    }
    if (!bEnabled || Rank < 1.0)
    {
        return FALSE;
    }
    if (CurrentCooldownTime > float(0) && (m_oPawn.RemoteRole != ENetRole.ROLE_AutonomousProxy || CurrentCooldownTime > GetPowerCooldown() * 0.300000012))
    {
        return FALSE;
    }
    if (oTarget != None && PowerType != EPowerType.PowerType_Buff)
    {
        fDistance = VSize(oTarget.location - m_oPawn.location);
        if (fDistance < MinimumRange.CurrentValue || fDistance > MaximumRange.CurrentValue)
        {
            return FALSE;
        }
    }
    if (SFXPawn_Player(m_oPawn) == None && SFXPawn_Henchman(m_oPawn) == None)
    {
        if (TimeUntilNextUse > 0.0)
        {
            return FALSE;
        }
        if (oTarget != None && PowerType != EPowerType.PowerType_Buff)
        {
            if (!AimingIgnoresObstructions)
            {
                oPawnTarget = BioPawn(oTarget);
                if (oPawnTarget != None)
                {
                    oPawnTarget.GetAimNodeLocation(4, vAimLocation);
                    BioWorldInfo(m_oPawn.WorldInfo).m_oPowerManager.CheckLOSToLocation(m_oPawn, m_oPawn.location, vAimLocation, MaximumRange.CurrentValue, TRUE, oHitActor, vHitLocation, vHitNormal, 0.0);
                    if (oHitActor != oTarget)
                    {
                        return FALSE;
                    }
                }
            }
        }
        if (ShouldUsePower(oTarget, sPowerInfo) == FALSE)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function CombatEnded();

public function bool DoAreaExplosionForActor(Actor oActor, Vector location, int ImpactCount, float fDamage, Class<SFXDamageType> DamageType, float fForce, AreaEffectParameters Param, int MaxRagdollOverride, delegate<OnActorImpacted> ImpactCallback, optional Class<SFXDamageType> MaxRagdollDmgTypeOverride)
{
    local BioPawn oPawn;
    local Vector Direction;
    local Vector vForce;
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local int nMaxRagdoll;
    
    if (oActor == None)
    {
        return FALSE;
    }
    Direction = Normal(oActor.location - location);
    Direction = Vector(Rotator(Direction) + Param.HitDirectionOffset);
    oPawn = BioPawn(oActor);
    if (oPawn != None)
    {
        oPawn.NotifyImpactedByPower(Self, m_oPawn);
    }
    vForce = Direction * fForce;
    nMaxRagdoll = int(MaximumRagdollTargets.CurrentValue);
    if (MaxRagdollOverride > 0)
    {
        nMaxRagdoll = MaxRagdollOverride;
    }
    if (nMaxRagdoll > 0 && ImpactCount >= nMaxRagdoll)
    {
        if (MaxRagdollDmgTypeOverride != None)
        {
            DamageType = MaxRagdollDmgTypeOverride;
        }
        else
        {
            DamageType = GetNonRagdollDamageType();
        }
    }
    Resistance = oActor.GetPowerResistance(m_oPawn, oActor.location, -Direction, fDamage, vForce, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        oActor = oTargetOverride;
    }
    oActor.ImpactWithPower(Resistance, m_oPawn, oActor.location, -Direction, fDamage, vForce, DamageType);
    if (ImpactCallback == None || ImpactCallback(Resistance, oActor, ImpactCount, oActor.location, -Direction))
    {
        PlayImpactEffects(oActor, oActor.location, -Direction);
        if (ShouldReplicate() == TRUE)
        {
            ReplicatePowerSubsequentImpact(oPawn, oPawn.CurrentCustomAction, , ImpactCount);
        }
        return TRUE;
    }
    return FALSE;
}
public function bool DoPowerDetonatedForActor(Actor oActor, Vector HitLocation, Vector HitNormal, int nImpactCount, bool bFirstTarget, optional SFXProjectile_PowerCustomAction oProjectile)
{
    local BioPawn oPawn;
    local Vector Direction;
    local Vector vForce;
    local float fDamage;
    local float fForce;
    local Class<SFXDamageType> DamageType;
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local bool bHasImpacted;
    
    oPawn = BioPawn(oActor);
    Direction = -HitNormal;
    fForce = GetImpactForce(oActor);
    if (Abs(fForce) > float(0))
    {
        if (oProjectile != None)
        {
            if (bFirstTarget && SFXProjectile_PowerCustomAction_Grenade(oProjectile) == None)
            {
                Direction = Normal(oProjectile.Velocity);
            }
            else
            {
                Direction = Normal(oActor.location - HitLocation);
            }
        }
        else if (!bFirstTarget)
        {
            Direction = Normal(oActor.location - HitLocation);
        }
        Direction = Vector(Rotator(Direction) + DetonationParameters.HitDirectionOffset);
        vForce = Direction * fForce;
    }
    if (oPawn != None)
    {
        oPawn.NotifyImpactedByPower(Self, m_oPawn);
    }
    fDamage = GetImpactDamage(oActor, DamageType);
    if (MaximumRagdollTargets.CurrentValue > float(0) && float(nImpactCount) >= MaximumRagdollTargets.CurrentValue)
    {
        DamageType = GetNonRagdollDamageType();
    }
    Resistance = oActor.GetPowerResistance(m_oPawn, HitLocation, -Direction, fDamage, vForce, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        oActor = oTargetOverride;
    }
    oActor.ImpactWithPower(Resistance, m_oPawn, HitLocation, -Direction, fDamage, vForce, DamageType);
    bHasImpacted = OnImpact(Resistance, oActor, nImpactCount, HitLocation, -Direction);
    if (bHasImpacted)
    {
        PlayImpactEffects(oActor, HitLocation, HitNormal);
        if (!bOverrideComboDetonate)
        {
            CheckForPowerCombo(oActor, Resistance, HitLocation, HitNormal);
        }
    }
    if (ShouldReplicate() == TRUE)
    {
        ReplicateImpact(oPawn, nImpactCount, bFirstTarget, HitLocation, HitNormal, oPawn.CurrentCustomAction);
    }
    return bHasImpacted;
}
public function GetPowerAnimInfo(out AnimSet AnimSet, out array<Name> AnimNames)
{
    local Name Anim;
    
    AnimSet = CastAnimSet;
    foreach BS_StartCastAnimation.AnimName(Anim, )
    {
        if (Anim != 'None' && AnimNames.Find(Anim) == -1)
        {
            AnimNames.AddItem(Anim);
        }
    }
    foreach BS_EndCastAnimation.AnimName(Anim, )
    {
        if (Anim != 'None' && AnimNames.Find(Anim) == -1)
        {
            AnimNames.AddItem(Anim);
        }
    }
}
public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    if (!default.bDynamicLoadAnimSet)
    {
        GetAnimsUsedByBodyStance(default.BS_StartCastAnimation, UsedAnims);
        GetAnimsUsedByBodyStance(default.BS_EndCastAnimation, UsedAnims);
    }
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal);

public function bool PlayBodyStance(BodyStance BodyStance, float fStanceBlendInTime, float fStanceBlendOutTime)
{
    if (m_oPawn.PlayBodyStance(BodyStance, fAnimPlayRate, fStanceBlendInTime, fStanceBlendOutTime, , FALSE, , fAnimStartTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BodyStance, TRUE);
        if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BodyStance, 2, 2);
            m_oPawn.Mesh.RootMotionMode = ERootMotionMode;
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        return TRUE;
    }
    return FALSE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(BioCustomAction).PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheProjectile(default.ProjectileClass);
}
public function ReplaceAnimSetWithDynamic(AnimSet DynAnimSet)
{
    CastAnimSet = DynAnimSet;
}
public function StartCustomAction()
{
    local BioPlayerController PC;
    local SFXAI_Henchman HenchAI;
    local bool bTransitionFromPartial;
    local bool InstantPowerUse;
    
    HenchAI = SFXAI_Henchman(m_oPawn.Controller);
    InstantPowerUse = HenchAI != None && HenchAI.bUsingInstantPower;
    if (!InstantPowerUse)
    {
        Super(BioCustomAction).StartCustomAction();
    }
    else if (VocalizationEvent != ESFXVocalizationEventID.SFXVocalizationEvent_None && SFXGRI(m_oPawn.WorldInfo.GRI) != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(VocalizationEvent, m_oPawn, None, 0.0);
    }
    if (CastAnimSet == None || InstantPowerUse)
    {
        StartPower();
        ReleasePower();
        if (InstantPowerUse)
        {
            StopCustomAction();
        }
        else
        {
            EndThisCustomAction();
        }
        return;
    }
    PC = BioPlayerController(m_oPawn.Controller);
    if (CastCameraAnim != None && PC != None && PC.PlayerCamera != None)
    {
        PC.PlayerCamera.PlayCameraAnim(CastCameraAnim, CameraAnimPlayRate, 1.0, CameraAnimBlendIn, CameraAnimBlendOut, FALSE, FALSE, CameraAnimDuration, TRUE);
    }
    bTransitionFromPartial = m_oPawn.CoverAction == ECoverAction.CA_BlindLeft || m_oPawn.CoverAction == ECoverAction.CA_BlindRight || m_oPawn.CoverAction == ECoverAction.CA_BlindUp;
    if (LeanOutToCast && m_oPawn.IsInCover() && (m_oPawn.IsInCoverLeaning() == FALSE || bTransitionFromPartial))
    {
        InitialCoverAction = m_oPawn.CoverAction;
        if (bTransitionFromPartial)
        {
            InitialCoverAction = ECoverAction.CA_Default;
        }
        if (ChangeCoverAction() == FALSE)
        {
            EndThisCustomAction();
            return;
        }
        WaitingOnLeanOut = TRUE;
        RestoreCoverAction = TRUE;
    }
    else
    {
        StartCastAnimations();
    }
}
public event function TickCustomAction(float fDeltaTime)
{
    local SFXAI_Henchman Henchman;
    local SFXModule_GameEffectManager GameEffectManager;
    local float CooldownMultiplier;
    
    Super(BioCustomAction).TickCustomAction(fDeltaTime);
    TimeSinceStart += fDeltaTime;
    if (CurrentCooldownTime > float(0))
    {
        GameEffectManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        CooldownMultiplier = 1.0;
        if (GameEffectManager != None)
        {
            CooldownMultiplier = GameEffectManager.GlobalCooldownBonus.Value;
        }
        CurrentCooldownTime -= fDeltaTime * CooldownMultiplier;
        if (CurrentCooldownTime < float(0))
        {
            CurrentCooldownTime = 0.0;
        }
        if (CurrentCooldownTime == float(0))
        {
            Henchman = m_oPawn != None ? SFXAI_Henchman(m_oPawn.Controller) : None;
            if (Henchman != None)
            {
                Henchman.PowerCooldownFinished();
            }
        }
    }
    if (TimeUntilNextUse > 0.0)
    {
        TimeUntilNextUse -= fDeltaTime;
        if (TimeUntilNextUse < 0.0)
        {
            TimeUntilNextUse = 0.0;
        }
    }
    if (WaitingOnLeanOut && !m_oPawn.IsInCover())
    {
        WaitingOnLeanOut = FALSE;
        StartCastAnimations();
    }
    else if (WaitingOnLeanOut && m_oPawn.IsInAnimatedTransition() == FALSE)
    {
        if (!m_oPawn.IsInCoverLeaning())
        {
            if (ChangeCoverAction() == FALSE)
            {
                EndThisCustomAction();
            }
            return;
        }
        WaitingOnLeanOut = FALSE;
        StartCastAnimations();
    }
    else if (bPowerStarted && !bPowerReleased && TimeSinceStart >= ReleaseTime && !m_oPawn.IsBlindFiring())
    {
        ReleasePower();
    }
}
public function bool AddActorToImpactedList(out array<Actor> ImpactedActors, Actor oActor, Vector vImpactLocation)
{
    local int nCount;
    local int nIndex;
    local float fDistanceToActor;
    local float fDistActorInList;
    local Actor oActorInList;
    
    if (oActor == None)
    {
        return FALSE;
    }
    nCount = ImpactedActors.Length;
    if (nCount == 0)
    {
        ImpactedActors.InsertItem(0, oActor);
        return TRUE;
    }
    fDistanceToActor = VSize(oActor.location - vImpactLocation);
    for (nIndex = 0; nIndex < nCount; nIndex++)
    {
        oActorInList = ImpactedActors[nIndex];
        if (oActorInList != None)
        {
            fDistActorInList = VSize(oActorInList.location - vImpactLocation);
            if (fDistanceToActor < fDistActorInList)
            {
                ImpactedActors.InsertItem(nIndex, oActor);
                return TRUE;
            }
        }
    }
    ImpactedActors.InsertItem(nCount, oActor);
    return TRUE;
}
public final function SFXGameEffect_PowerCombo AddComboEffect(Actor Target, Class<SFXGameEffect_PowerCombo> ComboClass, float Duration)
{
    local SFXGameEffect_PowerCombo ComboEffect;
    local SFXModule_GameEffectManager Manager;
    
    if (Target == None)
    {
        return None;
    }
    Manager = Target.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        ComboEffect = SFXGameEffect_PowerCombo(Manager.CreateEffect(ComboClass, Name, Duration, 1, 0.0, m_oPawn.Controller));
        if (ComboEffect != None)
        {
            ComboEffect.SourcePower = Self;
            ComboEffect.OnApplied();
            return ComboEffect;
        }
    }
    return None;
}
public function AddEvolvedRankBonus(out PowerData Data, float Bonus)
{
    local int NumEvolved;
    
    NumEvolved = GetNumEvolveChoices();
    NumEvolved--;
    Data.RankBonuses[m_oPawn.PowerManager.EvolveRank - 1 + NumEvolved] = Bonus;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    switch (Parameter)
    {
        case 'CooldownTime':
            ApplyBonusToParameter(CooldownTime, Bonus, bRemove);
            ApplyBonusToParameter(HenchmanCooldownTime, Bonus, bRemove);
            break;
        case 'MinimumRange':
            ApplyBonusToParameter(MinimumRange, Bonus, bRemove);
            break;
        case 'MaximumRange':
            ApplyBonusToParameter(MaximumRange, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(ImpactRadius, Bonus, bRemove);
            break;
        case 'MaximumImpactTargets':
            ApplyBonusToParameter(MaximumImpactTargets, Bonus, bRemove);
            break;
        case 'EffectDuration':
            ApplyBonusToParameter(EffectDuration, Bonus, bRemove);
            break;
        case 'Damage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
            break;
        case 'Force':
            ApplyBonusToParameter(Force, Bonus, bRemove);
            break;
        case 'VFXIntensity':
            ApplyBonusToParameter(VFXIntensity, Bonus, bRemove);
            break;
        case 'ProjectileSpeed':
            ApplyBonusToParameter(ProjectileSpeed, Bonus, bRemove);
            break;
        case 'ConeHalfAngle':
            ApplyBonusToParameter(ConeHalfAngle, Bonus, bRemove);
            break;
        default:
    }
}
public function ApplyBonusToParameter(out PowerData Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    if (Bonus == None)
    {
        return;
    }
    if (bRemove)
    {
        Parameter.DynamicBonuses.RemoveItem(Bonus);
    }
    else if (Parameter.DynamicBonuses.Find(Bonus) == -1)
    {
        Parameter.DynamicBonuses.AddItem(Bonus);
    }
    RecalculatePowerData(Parameter);
}
public function ApplyForceToActor(Actor oActor, Vector vForce)
{
    local BioPawn oPawn;
    local SFXKActor oKActor;
    
    oPawn = BioPawn(oActor);
    if (oPawn != None)
    {
        oPawn.AddRagdollImpulse(vForce, m_oPawn.Controller, oPawn.location);
    }
    else
    {
        oKActor = SFXKActor(oActor);
        if (oKActor != None && !oKActor.bImmovable)
        {
            oKActor.CollisionComponent.AddForce(vForce, oKActor.location, 'None');
        }
    }
}
public function ApplyHealthBonus(BioPawn oPawn, float fHealthValue, bool bHealthValueIsPercent, float fDuration, Name Category)
{
    local SFXGameEffect_HealthBonus oEffect;
    local SFXModule_GameEffectManager oManager;
    
    if (oPawn != None)
    {
        oManager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (oManager != None)
        {
            oEffect = SFXGameEffect_HealthBonus(oManager.CreateEffect(Class'SFXGameEffect_HealthBonus', Category, fDuration, fDuration > float(0) ? 1 : 2, fHealthValue, m_oPawn.Controller));
            if (oEffect != None)
            {
                oEffect.bEffectValueIsPercent = bHealthValueIsPercent;
                oEffect.OnApplied();
            }
        }
    }
}
public function bool ApplyPermanentGameEffect(Actor oTarget, Class<SFXGameEffect> className, float fEffectValue, Name nmCategory, Controller Instigator)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (oTarget != None)
    {
        Manager = oTarget.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Effect = Manager.CreateEffect(className, nmCategory, 0.0, 2, fEffectValue, Instigator);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
            return TRUE;
        }
    }
    return FALSE;
}
public function ApplyShieldBonus(BioPawn oPawn, float fShieldValue, bool bShieldValueIsPercent, float fDuration, Name Category, optional bool bRemoveEffectWhenShieldsDown)
{
    local SFXGameEffect_ShieldBonus oEffect;
    local SFXModule_GameEffectManager oManager;
    
    if (oPawn != None)
    {
        oManager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (oManager != None)
        {
            oEffect = SFXGameEffect_ShieldBonus(oManager.CreateEffect(Class'SFXGameEffect_ShieldBonus', Category, fDuration, fDuration > float(0) ? 1 : 2, fShieldValue, m_oPawn.Controller));
            if (oEffect != None)
            {
                oEffect.bEffectValueIsPercent = bShieldValueIsPercent;
                oEffect.bRemoveEffectWhenShieldsDown = bRemoveEffectWhenShieldsDown;
                oEffect.OnApplied();
            }
        }
    }
}
public function bool ApplyTemporaryGameEffect(Actor oTarget, Class<SFXGameEffect> className, float fDuration, float fEffectValue, Name nmCategory, Controller Instigator)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (oTarget != None)
    {
        Manager = oTarget.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Effect = Manager.CreateEffect(className, nmCategory, fDuration, 1, fEffectValue, Instigator);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
            return TRUE;
        }
    }
    return FALSE;
}
public function AreaExplosion(Vector location, float fRadius, float fDamage, Class<SFXDamageType> DamageType, float fForce, AreaEffectParameters Param, int MaxImpactCount, optional delegate<OnActorImpacted> ImpactCallback = None, optional int MaxRagdollOverride, optional Class<SFXDamageType> MaxRagdollDmgTypeOverride = None)
{
    local Actor oActor;
    local int nImpactCount;
    
    if (m_oPawn.Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    m_ImpactedActors.Length = 0;
    GetNearbyActors(m_ImpactedActors, location, fRadius, fRadius, Param);
    nImpactCount = 0;
    foreach m_ImpactedActors(oActor, )
    {
        if (SFXGRI(m_oPawn.WorldInfo.GRI).PreAsyncWorker.DoAreaExplosionForActor(Self, oActor, location, nImpactCount, fDamage, DamageType, fForce, Param, MaxRagdollOverride, ImpactCallback, MaxRagdollDmgTypeOverride))
        {
            if (BioPawn(oActor) != None)
            {
                nImpactCount++;
                if (MaxImpactCount > 0 && nImpactCount >= MaxImpactCount)
                {
                    break;
                }
            }
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local BodyStance Current;
    
    if (CastingPhase == ECastingPhase.CP_End || bPlayEndCastAnim == FALSE || PlayBodyStance(BS_EndCastAnimation, fEndAnimBlendInTime, fEndAnimBlendOutTime) == FALSE)
    {
        if (RestoreCoverAction)
        {
            RestoreCoverAction = FALSE;
            m_oPawn.SetCoverAction(InitialCoverAction);
            m_oPawn.SetAnimatedTransitionPending();
        }
        if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
            Current = GetCurrentBodyStance();
            m_oPawn.SetBodyStanceRootBoneAxisOption(Current, 1, 1, 1);
        }
        EndThisCustomAction();
    }
    if (CastingPhase == ECastingPhase.CP_Start)
    {
        CastingPhase = ECastingPhase.CP_End;
    }
}
public function bool CanBeRagdolledByPowers(BioPawn oPawn)
{
    if (oPawn == None)
    {
        return FALSE;
    }
    if (oPawn.CustomActionClasses[1] == None)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool ChangeCoverAction()
{
    local ECoverAction DesiredCoverAction;
    local ECoverDirection DesiredCoverDirection;
    local SFXAI_Core AI;
    
    DesiredCoverAction = ECoverAction.CA_Default;
    AI = SFXAI_Core(m_oPawn.Controller);
    if (AI != None)
    {
        DesiredCoverAction = AI.PendingCoverAction;
        switch (DesiredCoverAction)
        {
            case ECoverAction.CA_BlindLeft:
                DesiredCoverAction = ECoverAction.CA_LeanLeft;
                break;
            case ECoverAction.CA_BlindRight:
                DesiredCoverAction = ECoverAction.CA_LeanRight;
                break;
            case ECoverAction.CA_BlindUp:
                DesiredCoverAction = ECoverAction.CA_PopUp;
                break;
            default:
                break;
        }
    }
    else if (m_oPawn.CoverAction == ECoverAction.CA_BlindLeft || m_oPawn.CoverAction == ECoverAction.CA_BlindRight || m_oPawn.CoverAction == ECoverAction.CA_BlindUp)
    {
        m_oPawn.SetCoverDirection(m_oPawn.CoverDirection);
        if (m_oPawn.CoverAction == ECoverAction.CA_BlindLeft)
        {
            m_oPawn.SetCoverAction(7);
        }
        else if (m_oPawn.CoverAction == ECoverAction.CA_BlindRight)
        {
            m_oPawn.SetCoverAction(8);
        }
        else
        {
            m_oPawn.SetCoverAction(0);
        }
        m_oPawn.SetAnimatedTransitionPending();
        return TRUE;
    }
    if (DesiredCoverAction == ECoverAction.CA_Default)
    {
        if (m_oPawn.CoverDirection == ECoverDirection.CD_Left && m_oPawn.CanDoCoverAction(3, TRUE, TRUE))
        {
            DesiredCoverAction = ECoverAction.CA_LeanLeft;
            DesiredCoverDirection = ECoverDirection.CD_Left;
        }
        else if (m_oPawn.CoverDirection == ECoverDirection.CD_Right && m_oPawn.CanDoCoverAction(4, TRUE, TRUE))
        {
            DesiredCoverAction = ECoverAction.CA_LeanRight;
            DesiredCoverDirection = ECoverDirection.CD_Right;
        }
        else if (m_oPawn.CanDoCoverAction(5, TRUE, TRUE))
        {
            DesiredCoverAction = ECoverAction.CA_PopUp;
            DesiredCoverDirection = m_oPawn.CoverDirection;
        }
    }
    if (DesiredCoverAction != ECoverAction.CA_Default)
    {
        m_oPawn.SetCoverDirection(DesiredCoverDirection);
        m_oPawn.SetCoverAction(DesiredCoverAction);
        m_oPawn.SetAnimatedTransitionPending();
    }
    if (m_oPawn.IsInCoverLeaning())
    {
        return TRUE;
    }
    return FALSE;
}
public final function CheckForPowerCombo(Actor Target, EPowerResistance Resistance, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    local SFXGameEffect_PowerCombo ComboEffect;
    local SFXGameEffect_PowerCombo LatestComboEffect;
    local BioPawn TargetPawn;
    
    if (m_oPawn == None || m_oPawn.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (ComboDetonators.Length == 0)
    {
        return;
    }
    TargetPawn = BioPawn(Target);
    if (TargetPawn == None || Resistance == EPowerResistance.Resistance_Full)
    {
        return;
    }
    Manager = Target.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    foreach Manager.GameEffects(Effect, )
    {
        ComboEffect = SFXGameEffect_PowerCombo(Effect);
        if (ComboEffect != None)
        {
            if (ComboDetonators.Find(ComboEffect.Class) != -1)
            {
                if (ComboEffect.SourcePower.PowerName != PowerName && (!ComboEffect.bOnlyOnDeath || TargetPawn.IsDead()))
                {
                    if (LatestComboEffect == None || ComboEffect.CurrentTime < LatestComboEffect.CurrentTime)
                    {
                        LatestComboEffect = ComboEffect;
                    }
                }
            }
        }
    }
    if (LatestComboEffect != None)
    {
        DoPowerCombo(LatestComboEffect, TargetPawn, HitLocation, HitNormal);
    }
}
public function CleanUpProjectile(optional SFXProjectile_PowerCustomAction oProjectile)
{
    local int i;
    local SFXProjectile_PowerCustomAction oProjIter;
    
    for (i = Projectiles.Length - 1; i >= 0; i--)
    {
        oProjIter = Projectiles[i];
        if (oProjIter == None || oProjIter == oProjectile || oProjIter.bActive == FALSE || oProjIter.IsShuttingDown() == TRUE)
        {
            Projectiles.Remove(i, 1);
        }
    }
    if (oProjectile != None && oProjectile.Power == Self)
    {
        oProjectile.ShutDown();
    }
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        m_oPawn.StartPowerCustomAction(m_oPawn.ReplicatedCustomActionInfo.PowerCustomActionType, m_oPawn.ReplicatedCustomActionInfo.Target, m_oPawn.ReplicatedCustomActionInfo.TargetLocation, bForced);
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    DoPowerDetonatedForActor(oActor, HitLocation, HitNormal, ImpactCount, bFirstTarget);
    if (BioPawn(oActor) != None)
    {
        BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
    }
}
public function ClientDoPowerCombo(Class<SFXGameEffect_PowerCombo> EffectClass, int SourcePowerID, BioPawn SourcePowerInstigator, BioPawn TargetPawn, Vector HitLocation, Vector HitNormal)
{
    local SFXGameEffect Effect;
    local SFXGameEffect_PowerCombo ComboEffect;
    local SFXGameEffect_PowerCombo LatestComboEffect;
    local SFXModule_GameEffectManager Manager;
    local SFXPowerCustomAction SourcePower;
    
    if (TargetPawn == None)
    {
        return;
    }
    Manager = TargetPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    foreach Manager.GameEffects(Effect, )
    {
        ComboEffect = SFXGameEffect_PowerCombo(Effect);
        if (ComboEffect != None)
        {
            if (ComboEffect.Class == EffectClass)
            {
                if (LatestComboEffect == None || ComboEffect.CurrentTime < LatestComboEffect.CurrentTime)
                {
                    LatestComboEffect = ComboEffect;
                }
            }
        }
    }
    if (LatestComboEffect == None && SourcePowerInstigator != None)
    {
        SourcePower = SFXPowerCustomAction(SourcePowerInstigator.PowerCustomActions[SourcePowerID]);
        if (SourcePower != None)
        {
            LatestComboEffect = SourcePower.AddComboEffect(TargetPawn, EffectClass, 0.00100000005);
        }
    }
    if (LatestComboEffect != None)
    {
        DoPowerCombo(LatestComboEffect, TargetPawn, HitLocation, HitNormal);
    }
}
public final function ClientDoPowerComboImpact(Actor oActor, int CustomActionReactionType, float PowerRank, int PowerComboTypeUniqueID, int MiscFlags)
{
    local string PowerComboClass;
    
    PowerComboClass = GetPowerComboClassFromUniqueID(PowerComboTypeUniqueID);
    if (PowerComboClass == "")
    {
        return;
    }
    ClientDoPowerComboImpactFromEffect(oActor, CustomActionReactionType, PowerComboClass, PowerRank, MiscFlags);
}
public function ClientDoPowerComboImpactFromEffect(Actor oTarget, int CustomActionReactionType, string EffectClassName, float DetonatorPowerRank, int MiscFlags)
{
    local BioPawn TargetPawn;
    local SFXGameEffect_PowerCombo TemporaryComboEffect;
    local Class<SFXGameEffect_PowerCombo> EffectClass;
    local SFXModule_GameEffectManager Manager;
    
    TargetPawn = BioPawn(oTarget);
    if (TargetPawn == None)
    {
        return;
    }
    Manager = TargetPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    EffectClass = Class<SFXGameEffect_PowerCombo>(FindObject(EffectClassName, Class'Class'));
    if (EffectClass == None)
    {
        return;
    }
    TemporaryComboEffect = AddComboEffect(TargetPawn, EffectClass, 0.00100000005);
    if (TemporaryComboEffect != None)
    {
        TemporaryComboEffect.ClientDoPowerComboImpact(oTarget, CustomActionReactionType, DetonatorPowerRank, MiscFlags);
        Manager.RemoveEffect(TemporaryComboEffect);
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback);

public final function DelayedDoPowerCombo()
{
    DoPowerCombo(DelayedPowerCombo.ComboEffect, DelayedPowerCombo.TargetPawn, DelayedPowerCombo.HitLocation, DelayedPowerCombo.HitNormal, TRUE);
    DelayedPowerCombo.ComboEffect = None;
    DelayedPowerCombo.TargetPawn = None;
    DelayedPowerCombo.HitLocation = vect(0.0, 0.0, 0.0);
    DelayedPowerCombo.HitNormal = vect(0.0, 0.0, 0.0);
}
public final function bool DetonationHitsTarget(Vector HitLocation, float MaxRange, Actor HitActor, AreaEffectParameters DetonationParams)
{
    local Actor oLOSHitActor;
    local Vector vLOSHitLocation;
    local Vector vLOSHitNormal;
    local Pawn oPawn;
    local float fDotProduct;
    
    if (HitActor == None || HitActor.bDeleteMe || CanImpactActor(HitActor) == FALSE)
    {
        return FALSE;
    }
    if (DetonationParams.ConeAngle > float(0))
    {
        fDotProduct = Normal(DetonationParams.ConeDirection) Dot Normal(HitActor.location - HitLocation);
        if (fDotProduct < Cos(DetonationParams.ConeAngle / 2.0 * 0.0174532924))
        {
            return FALSE;
        }
    }
    oPawn = Pawn(HitActor);
    if (oPawn != None)
    {
        if (DetonationParams.ImpactFriends == FALSE && m_oPawn.IsHostile(oPawn) == FALSE)
        {
            return FALSE;
        }
        if (DetonationParams.ImpactDeadPawns == FALSE && oPawn.IsDead())
        {
            return FALSE;
        }
    }
    else if (IsPlaceable(HitActor))
    {
        if (DetonationParams.ImpactPlaceables == FALSE)
        {
            return FALSE;
        }
    }
    if (DetonationParams.BlockedByObjects && !BioWorldInfo(m_oPawn.WorldInfo).m_oPowerManager.CheckLOSToActor(m_oPawn, HitActor, HitLocation, MaxRange, TRUE, TRUE, oLOSHitActor, vLOSHitLocation, vLOSHitNormal))
    {
        return FALSE;
    }
    return TRUE;
}
public final function DoPowerCombo(SFXGameEffect_PowerCombo ComboEffect, BioPawn TargetPawn, Vector HitLocation, Vector HitNormal, optional bool bDelayed = FALSE)
{
    local SFXModule_GameEffectManager Manager;
    local array<Name> EffectsToRemove;
    local int Index;
    
    if (TargetPawn == None || ComboEffect == None)
    {
        return;
    }
    Manager = TargetPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (!bDelayed && PowerComboDelay > float(0))
    {
        m_oPawn.SetTimer(PowerComboDelay, FALSE, 'DelayedDoPowerCombo', Self);
        DelayedPowerCombo.ComboEffect = ComboEffect;
        DelayedPowerCombo.TargetPawn = TargetPawn;
        DelayedPowerCombo.HitLocation = HitLocation;
        DelayedPowerCombo.HitNormal = HitNormal;
    }
    else
    {
        ComboEffect.OnPowerComboDetonated(Self, HitLocation, HitNormal);
        if (ShouldReplicate())
        {
            ReplicatePowerCombo(ComboEffect, HitLocation, HitNormal);
        }
    }
    EffectsToRemove = ComboEffect.EffectsRemovedOnCombo;
    for (Index = Manager.GameEffects.Length - 1; Index >= 0; Index--)
    {
        if (EffectsToRemove.Find(Manager.GameEffects[Index].Class.Name) != -1)
        {
            Manager.RemoveEffectAt(Index);
        }
    }
}
public function EndThisCustomAction()
{
    Super(BioCustomAction).EndThisCustomAction();
}
public function BodyStance GetCurrentBodyStance()
{
    if (CastingPhase == ECastingPhase.CP_Start)
    {
        return BS_StartCastAnimation;
    }
    else
    {
        return BS_EndCastAnimation;
    }
}
public function Vector GetDefaultClientEffectParams()
{
    local Vector Param;
    
    Param.X = EffectDuration.CurrentValue;
    Param.Y = ImpactRadius.CurrentValue / 100.0;
    return Param;
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    DamageType = DefaultDamageType;
    return Damage.CurrentValue;
}
public function float GetImpactForce(Actor oImpacted)
{
    return Force.CurrentValue;
}
public function bool GetNearbyActors(out array<Actor> ImpactedActors, Vector HitLocation, float Radius, float MaxRange, AreaEffectParameters Param)
{
    local Actor oActor;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(m_oPawn.WorldInfo);
    if (oWorldInfo == None)
    {
        return FALSE;
    }
    foreach m_oPawn.CollidingActors(Class'Actor', oActor, Radius, HitLocation, TRUE, , )
    {
        if (DetonationHitsTarget(HitLocation, MaxRange, oActor, Param))
        {
            if (Param.DistancedSorted)
            {
                AddActorToImpactedList(ImpactedActors, oActor, HitLocation);
            }
            else
            {
                ImpactedActors.AddItem(oActor);
            }
        }
    }
    return TRUE;
}
public function Class<SFXDamageType> GetNonRagdollDamageType()
{
    return NonRagdollDamageType;
}
public static function int GetPhysicsLevel(Actor oImpacted, optional bool bIgnoreResistance = FALSE)
{
    local SFXGameConfig oConfig;
    local BioPawn oPawn;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn != None)
    {
        if (oPawn.IsHumanControlled() || SFXPawn_Henchman(oPawn) != None)
        {
            return 5;
        }
        oConfig = SFXGRI(oPawn.WorldInfo.GRI).gameconfig;
        if (oConfig != None && bIgnoreResistance == FALSE && oConfig.bShieldsBlockPowers && oPawn.HasAnyShieldResistance())
        {
            return 5;
        }
        return BioPawn(oImpacted).m_nPhysicsLevel;
    }
    return 0;
}
public static function float GetPhysicsLevelResistance(Actor oTarget)
{
    local int PhysicsLevel;
    local float Resistance;
    
    Resistance = 0.0;
    if (oTarget != None)
    {
        PhysicsLevel = GetPhysicsLevel(oTarget, TRUE);
        if (PhysicsLevel > 0)
        {
            Resistance = float((PhysicsLevel + 1)) * 0.100000001;
        }
    }
    return Resistance;
}
public function string GetPowerComboClassFromUniqueID(int PowerComboTypeUniqueID)
{
    return Class'SFXEngine'.static.GetStrFromSFXUniqueID(PowerComboTypeUniqueID);
}
public function int GetPowerComboTypeUniqueIDFromClass(string className)
{
    if (PowerComboTypes.Find(className) == -1)
    {
    }
    return Class'SFXEngine'.static.GetSFXUniqueIDFromStr(className);
}
public function float GetPowerCooldown()
{
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        return HenchmanCooldownTime.CurrentValue;
    }
    else
    {
        return CooldownTime.CurrentValue;
    }
}
public function bool GetProjectileAttachPoint(out Vector AttachPoint)
{
    local Rotator Rot;
    
    if (m_oPawn != None && m_oPawn.Mesh != None)
    {
        if (m_oPawn.Mesh.MatchRefBone(ProjectileAttachPoint) != -1)
        {
            AttachPoint = m_oPawn.Mesh.GetBoneLocation(ProjectileAttachPoint);
        }
        else if (m_oPawn.Mesh.GetSocketWorldLocationAndRotation(ProjectileAttachPoint, AttachPoint, Rot) == FALSE)
        {
            AttachPoint = m_oPawn.location;
        }
    }
    return TRUE;
}
public final function int GetSaveGamePowerState()
{
    if (!SFXGRI(m_oPawn.WorldInfo.GRI).IsMultiplayerGame())
    {
        return Class'SFXEngine'.static.GetSFXEngine().GetPlayerVariable(GetUniquePowerPlayerVariable());
    }
    return 0;
}
public final function Name GetUniquePowerPlayerVariable()
{
    return Name(m_oPawn.Tag $ Class.Name);
}
public function bool HasRemainingShieldOfType(BioPawn oPawn, Class<SFXShield_Base> ShieldClass)
{
    local SFXShield_Base Shield;
    
    if (oPawn != None && oPawn.InvManager != None)
    {
        foreach oPawn.InvManager.InventoryActors(Class'SFXShield_Base', Shield)
        {
            if (ClassIsChildOf(Shield.Class, ShieldClass) && Shield.GetCurrentShields() > float(0))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public static function bool ImpactPlaceable(Actor oCaster, Actor oImpacted, Vector Momentum, float PlotPlaceableDamage, optional bool bForceDamage)
{
    local KActor oKActor;
    local SFXKActor oSFXKActor;
    local BioPawn oCasterPawn;
    local BioPhysicsActor PhysActor;
    local float fDamage;
    
    oCasterPawn = BioPawn(oCaster);
    if (oCasterPawn == None)
    {
        return FALSE;
    }
    oKActor = KActor(oImpacted);
    if (oKActor == None)
    {
        return FALSE;
    }
    oImpacted.ExceededPhysicsThreshold(oCaster);
    oSFXKActor = SFXKActor(oImpacted);
    if (!bForceDamage && oSFXKActor != None && !oSFXKActor.bImmovable)
    {
        oKActor.CollisionComponent.AddForce(Momentum, oKActor.location, 'None');
    }
    else
    {
        PhysActor = BioPhysicsActor(oImpacted);
        if (PhysActor == None || PhysActor.m_bToughPlaceable)
        {
            fDamage = PlotPlaceableDamage;
        }
        else
        {
            fDamage = 10000.0;
        }
        oKActor.TakeDamage(fDamage, oCasterPawn.Controller, vect(0.0, 0.0, 0.0), Momentum, Class'SFXDamageType_Default');
    }
    return TRUE;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (m_oPawn != None && (m_oPawn.IsInState('InRagdoll', ) || m_oPawn.IsInState('RagdollRecovery', )))
    {
        return FALSE;
    }
    if (m_oPawn.Weapon != None && (m_oPawn.Weapon.IsInState('WeaponEquipping', ) || m_oPawn.Weapon.IsInState('WeaponPuttingDown', )))
    {
        return FALSE;
    }
    if (CanUsePower(m_oTargetToAimAt) || bForced)
    {
        return Super(BioCustomAction).InternalCanDoCustomAction(SyncPawn, bForced);
    }
    return FALSE;
}
public static function bool IsMachineRace(Actor oImpacted)
{
    local BioPawn BP;
    
    if (BioPawn(oImpacted) != None)
    {
        BP = BioPawn(oImpacted);
        if (BP.RaceType == ERaceType.RaceType_Machine)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public static function bool IsOfRace(Actor oImpacted, ECharacterType eRace)
{
    local BioPawn oImpactedPawn;
    
    oImpactedPawn = BioPawn(oImpacted);
    if (oImpactedPawn == None)
    {
        return FALSE;
    }
    return int(oImpactedPawn.CharacterType) == int(eRace);
}
public static function bool IsPlaceable(Actor oImpacted)
{
    if (BioPawn(oImpacted) != None)
    {
        return FALSE;
    }
    if (KActor(oImpacted) != None || oImpacted.IsA('SFXPlaceable'))
    {
        return TRUE;
    }
    return FALSE;
}
public function bool LoadAnimSet()
{
    if (m_oPawn.PowerManager != None && m_oPawn.PowerManager.LastPowerAnimSet != None)
    {
        m_oPawn.ClearRegisteredCustomAnimsets(m_oPawn.PowerManager.LastPowerAnimSet.Name);
        m_oPawn.PowerManager.LastPowerAnimSet = None;
    }
    if (HenchCastAnimSet != None && SFXPawn_Henchman(m_oPawn) != None)
    {
        m_oPawn.RegisterCustomAnimset(HenchCastAnimSet.Name, HenchCastAnimSet);
        m_oPawn.PowerManager.LastPowerAnimSet = HenchCastAnimSet;
        return TRUE;
    }
    else if (CastAnimSet != None)
    {
        m_oPawn.RegisterCustomAnimset(CastAnimSet.Name, CastAnimSet);
        m_oPawn.PowerManager.LastPowerAnimSet = CastAnimSet;
        return TRUE;
    }
    return FALSE;
}
public function OnClientPowerProjectileSpawned(SFXProjectile_PowerCustomAction NewProjectile)
{
    local SFXProjectile LocalProjectile;
    
    CleanUpProjectile();
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_AutonomousProxy && NewProjectile.Role == ENetRole.ROLE_SimulatedProxy && NewProjectile.bClientPredictProjectile == TRUE)
    {
        if (Projectiles.Length > 0)
        {
            LocalProjectile = Projectiles[0];
            if (LocalProjectile != None && LocalProjectile.Role == ENetRole.ROLE_Authority)
            {
                LocalProjectile.SetPredictionTarget(NewProjectile);
                NewProjectile.SetPrediction(TRUE, TRUE);
                Projectiles.Remove(0, 1);
            }
        }
    }
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    local Actor oActor;
    local int nImpactCount;
    local int nMaxImpactCount;
    local bool bFirstTarget;
    
    PlayDetonationEffects(HitLocation, HitNormal, oProjectile);
    m_vDetonationHitLocation = HitLocation;
    m_vDetonationHitNormal = HitNormal;
    m_ImpactedActors.Length = 0;
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority && !bCustomImpactLogic)
    {
        if (ImpactRadius.CurrentValue > float(0))
        {
            GetNearbyActors(m_ImpactedActors, HitLocation, ImpactRadius.CurrentValue, MaximumRange.CurrentValue, DetonationParameters);
        }
        else if (DetonationHitsTarget(HitLocation, MaximumRange.CurrentValue, HitActor, DetonationParameters))
        {
            m_ImpactedActors.AddItem(HitActor);
        }
        nImpactCount = 0;
        bFirstTarget = TRUE;
        nMaxImpactCount = int(MaximumImpactTargets.CurrentValue);
        foreach m_ImpactedActors(oActor, )
        {
            if (SFXGRI(m_oPawn.WorldInfo.GRI).PreAsyncWorker.DoPowerDetonationForActor(Self, oActor, HitLocation, HitNormal, nImpactCount, bFirstTarget, oProjectile))
            {
                if (BioPawn(oActor) != None)
                {
                    nImpactCount++;
                    if (nMaxImpactCount > 0 && nImpactCount >= nMaxImpactCount)
                    {
                        break;
                    }
                }
            }
            bFirstTarget = FALSE;
        }
    }
    if (oProjectile != None)
    {
        CleanUpProjectile(oProjectile);
    }
    if (m_oPawn != None && m_oPawn.PowerManager != None)
    {
        m_oPawn.PowerManager.PowerImpacted(Self);
    }
}
public function OnSourcePowerBioticDetonation();

public function PlayCasterSounds(WwiseEvent BaseSound, out array<EvolvedSoundStruct> EvolvedSounds)
{
    local int idx;
    local bool bReplaceBaseSound;
    
    for (idx = 0; idx < EvolvedSounds.Length; idx++)
    {
        if (EvolvedSounds[idx].Sound == None)
        {
            continue;
        }
        if (EvolvedSounds[idx].bAnyEvolved && GetNumEvolveChoices() > 0 || IsEvolvedWithChoice(EvolvedSounds[idx].EvolveChoice))
        {
            m_oPawn.PlaySound(EvolvedSounds[idx].Sound, TRUE);
            bReplaceBaseSound = EvolvedSounds[idx].bReplaceBaseSound;
            break;
        }
    }
    if (!bReplaceBaseSound && BaseSound != None)
    {
        m_oPawn.PlaySound(BaseSound, TRUE);
    }
}
public function PlayDetonationEffects(Vector ImpactLocation, Vector ImpactNormal, optional SFXProjectile_PowerCustomAction oProjectile)
{
    if (CE_ImpactTemplate != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ImpactTemplate, ImpactLocation, ImpactNormal, GetDefaultClientEffectParams());
    }
    if (DetonationRumbleClass != None)
    {
        PlayPowerControllerRumble(DetonationRumbleClass, ImpactLocation);
    }
    if (DetonationScreenShakeClass != None)
    {
        PlayPowerScreenShake(DetonationScreenShakeClass, ImpactLocation);
    }
    if (!bCustomImpactSound)
    {
        if (m_oPawn.IsLocallyControlled() && m_oPawn.IsHumanControlled())
        {
            SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(ImpactDistanceLayer, ImpactLocation);
            PlayImpactSounds(ImpactLocation, ImpactSound, EvolvedImpactSounds);
        }
        else
        {
            SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(HenchmanImpactDistanceLayer, ImpactLocation);
            PlayImpactSounds(ImpactLocation, HenchmanImpactSound, HenchmanEvolvedImpactSounds);
        }
    }
    if (oProjectile != None)
    {
        oProjectile.MakeNoise(1.0, 'NoiseType_PowerImpact');
    }
    else
    {
        m_oPawn.MakeNoise(1.0, 'NoiseType_PowerImpact');
    }
}
public function PlayImpactEffects(Actor oImpacted, Vector ImpactLocation, Vector ImpactNormal)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn != None)
    {
        if (CE_TargetCrustTemplate != None)
        {
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_TargetCrustTemplate, oPawn, GetDefaultClientEffectParams());
        }
    }
}
public function PlayImpactSounds(Vector ImpactLocation, WwiseEvent BaseSound, out array<EvolvedSoundStruct> EvolvedSounds)
{
    local int idx;
    local bool bReplaceBaseSound;
    
    for (idx = 0; idx < EvolvedSounds.Length; idx++)
    {
        if (EvolvedSounds[idx].Sound == None)
        {
            continue;
        }
        if (EvolvedSounds[idx].bAnyEvolved && GetNumEvolveChoices() > 0 || IsEvolvedWithChoice(EvolvedSounds[idx].EvolveChoice))
        {
            SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(EvolvedSounds[idx].Sound, ImpactLocation);
            bReplaceBaseSound = EvolvedSounds[idx].bReplaceBaseSound;
            break;
        }
    }
    if (!bReplaceBaseSound && BaseSound != None)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(BaseSound, ImpactLocation);
    }
}
public final function PlayParticleSystemOnSocket(ParticleSystem PS_Template, BioPawn TargetPawn, Name SocketName, Rotator Rotation)
{
    local SFXObjectPool Pool;
    local ParticleSystemComponent PSC_Instance;
    
    if (PS_Template != None && SocketName != 'None' && TargetPawn != None)
    {
        Pool = SFXGRI(m_oPawn.WorldInfo.GRI).ObjectPool;
        if (Pool != None)
        {
            PSC_Instance = Pool.GetGenericParticleSystemComponent(PS_Template);
            if (PSC_Instance != None)
            {
                Pool.AttachParticleSystemComponentToSocket(PSC_Instance, TargetPawn.Mesh, SocketName);
                PSC_Instance.SetRotation(Rotation);
                PSC_Instance.SetActive(TRUE);
            }
        }
    }
}
public function PlayPowerControllerRumble(Class<SFXRumble_Power> RumbleClass, Vector HitLocation)
{
    local SFXPlayerController PC;
    local float fDistance;
    local ForceFeedbackWaveform Rumble;
    local int idx;
    local float fScale;
    
    if (RumbleClass != None)
    {
        foreach m_oPawn.WorldInfo.AllControllers(Class'SFXPlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                continue;
            }
            Rumble = RumbleClass.default.TheWaveForm;
            if (PC.Pawn == None)
            {
                continue;
            }
            fDistance = VSize(PC.Pawn.location - HitLocation);
            if (fDistance > RumbleClass.default.MaxDetonationRumbleDistance)
            {
                continue;
            }
            else if (fDistance > RumbleClass.default.MinDetonationRumbleDistance)
            {
                fScale = 1.0 - (fDistance - RumbleClass.default.MinDetonationRumbleDistance) / (RumbleClass.default.MaxDetonationRumbleDistance - RumbleClass.default.MinDetonationRumbleDistance);
                fScale *= fScale;
                for (idx = 0; idx < Rumble.Samples.Length; idx++)
                {
                    Rumble.Samples[idx].LeftAmplitude *= fScale;
                    Rumble.Samples[idx].RightAmplitude *= fScale;
                }
            }
            PC.ClientPlayForceFeedbackWaveform(Rumble);
        }
    }
}
public function PlayPowerScreenShake(Class<SFXShake_Power> ScreenShakeClass, Vector HitLocation)
{
    local SFXPlayerController PC;
    local float fDistance;
    local float fScale;
    local ScreenShakeStruct Shake;
    
    if (ScreenShakeClass != None)
    {
        foreach m_oPawn.WorldInfo.AllControllers(Class'SFXPlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                continue;
            }
            Shake = ScreenShakeClass.default.TheShake;
            if (PC.Pawn == None)
            {
                continue;
            }
            fDistance = VSize(PC.Pawn.location - HitLocation);
            if (fDistance > ScreenShakeClass.default.MaxDetonationShakeDistance)
            {
                continue;
            }
            else if (fDistance > ScreenShakeClass.default.MinDetonationShakeDistance)
            {
                fScale = 1.0 - (fDistance - ScreenShakeClass.default.MinDetonationShakeDistance) / (ScreenShakeClass.default.MaxDetonationShakeDistance - ScreenShakeClass.default.MinDetonationShakeDistance);
                fScale *= fScale;
                Shake.RotAmplitude *= fScale;
                Shake.LocAmplitude *= fScale;
                Shake.FOVAmplitude *= fScale;
            }
            SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(Shake);
        }
    }
}
public function PlayReleaseEffects()
{
    local RvrClientEffectTarget TargetInfo;
    
    if (m_oPawn == None || m_oPawn.PowerManager == None)
    {
        return;
    }
    if (CE_ReleaseEffectTemplate != None)
    {
        TargetInfo.Instigator = m_oPawn;
        if (ReleaseEffectBoneName != 'None')
        {
            TargetInfo.HitBone = ReleaseEffectBoneName;
        }
        TargetInfo.SpawnValue = GetDefaultClientEffectParams();
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_ReleaseEffectTemplate, TargetInfo);
    }
    m_oPawn.MakeNoise(1.0, 'NoiseType_PowerRelease');
}
public function RagdollPhysicsImpact(Pawn oPawn, Actor oImpactActor, Vector vImpactDir)
{
    local BioPawn oBioPawn;
    local SFXModule_Damage DmgModule;
    local float fDamage;
    local Vector HitLocation;
    local Vector Momentum;
    local float fVelocity;
    local SFXModule_GameEffectManager Manager;
    
    oBioPawn = BioPawn(oPawn);
    if (oBioPawn == None || oBioPawn.PowerManager == None)
    {
        return;
    }
    if (oBioPawn.WorldInfo.GameTimeSeconds - LastPhysicsCallbackTime < MinTimeBetweenPhysicsCallbacks)
    {
        return;
    }
    LastPhysicsCallbackTime = oBioPawn.WorldInfo.GameTimeSeconds;
    DmgModule = oPawn.GetModule(Class'SFXModule_Damage');
    if (DmgModule == None)
    {
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    fVelocity = VSize(oPawn.Velocity);
    if (fVelocity <= float(0))
    {
        fVelocity = VSize(vImpactDir);
    }
    fDamage = fVelocity * PhysicsToDamageMultiplier;
    fDamage *= Manager.PhysicsDamageTakenBonus.Value;
    oBioPawn.TakeDamage(fDamage, m_oPawn.Controller, HitLocation, Momentum, Class'SFXDamageType_PowerPhysics');
}
public function ReleaseBuffPower()
{
    local int nImpactCount;
    local BioPawn TargetPawn;
    local BioPawn oSquadMember;
    local int Index;
    local int nMaxImpactTargets;
    
    if (m_oTargetToAimAt != None)
    {
        nImpactCount = 0;
        nMaxImpactTargets = int(MaximumImpactTargets.CurrentValue);
        if (OnImpact(2, m_oTargetToAimAt, nImpactCount, m_oTargetToAimAt.location, vect(0.0, 0.0, 1.0)))
        {
            nImpactCount++;
        }
        if (BuffAppliesToSquad && nMaxImpactTargets != 1)
        {
            TargetPawn = BioPawn(m_oTargetToAimAt);
            if (TargetPawn != None && TargetPawn.Squad != None)
            {
                for (Index = 0; Index < TargetPawn.Squad.Members.Length; Index++)
                {
                    oSquadMember = BioPawn(TargetPawn.Squad.Members[Index]);
                    if (oSquadMember != None && oSquadMember != TargetPawn)
                    {
                        if (OnImpact(2, oSquadMember, nImpactCount, oSquadMember.location, vect(0.0, 0.0, 1.0)))
                        {
                            nImpactCount++;
                            if (nMaxImpactTargets > 0 && nImpactCount >= nMaxImpactTargets)
                            {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
public function ReleaseInstantPower()
{
    local Vector vLocation;
    local Vector vNormal;
    local SFXPlaceableBase oCP;
    local SFXSimpleUseModule UseModule;
    
    oCP = SFXPlaceableBase(m_oTargetToAimAt);
    if (oCP != None)
    {
        UseModule = oCP.GetModule(Class'SFXSimpleUseModule');
        if (UseModule != None)
        {
            vLocation = UseModule.m_TargetOffset + oCP.location;
        }
        else
        {
            vLocation = m_vLocationToAimAt;
        }
    }
    else if (m_oTargetToAimAt != None)
    {
        if (BioPawn(m_oTargetToAimAt) == None || BioPawn(m_oTargetToAimAt).GetAimNodeLocation(4, vLocation) == FALSE)
        {
            vLocation = m_oTargetToAimAt.location;
        }
    }
    else
    {
        vLocation = m_vLocationToAimAt;
    }
    vNormal = Normal(m_oPawn.location - vLocation);
    OnPowerDetonated(vLocation, vNormal, , m_oTargetToAimAt);
}
public function ReleaseMeleePower()
{
    OnPowerDetonated(m_oPawn.location, -Vector(m_oPawn.Rotation));
}
public function ReleasePower()
{
    local EPowerType eType;
    local BioPawn oPawnTarget;
    
    bPowerStarted = FALSE;
    bPowerReleased = TRUE;
    StartPowerCooldown();
    oPawnTarget = BioPawn(m_oTargetToAimAt);
    if (oPawnTarget != None)
    {
        oPawnTarget.OnCastAt(m_oPawn, Self);
    }
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        eType = HenchmanPowerType;
    }
    else
    {
        eType = PowerType;
    }
    switch (eType)
    {
        case EPowerType.PowerType_Projectile:
            ReleaseProjectilePower();
            break;
        case EPowerType.PowerType_Instant:
            ReleaseInstantPower();
            break;
        case EPowerType.PowerType_Melee:
            ReleaseMeleePower();
            break;
        case EPowerType.PowerType_Buff:
            ReleaseBuffPower();
            break;
        default:
    }
    PlayReleaseEffects();
    if (m_oPawn != None && m_oPawn.PowerManager != None)
    {
        m_oPawn.PowerManager.PowerReleased(Self);
    }
    if (m_oPawn.IsLocallyControlled() && m_oPawn.IsHumanControlled())
    {
        PlayCasterSounds(ReleaseSound, EvolvedReleaseSounds);
    }
    else
    {
        PlayCasterSounds(HenchmanReleaseSound, HenchmanEvolvedReleaseSounds);
    }
}
public function SFXProjectile_PowerCustomAction ReleaseProjectilePower()
{
    local Vector ProjectileLocation;
    local Rotator ProjectileRotation;
    local Vector HitLocation;
    local Vector HitNormal;
    local Actor HitActor;
    local SFXAI_Core AIController;
    local SFXProjectile_PowerCustomAction Projectile;
    
    if (m_oPawn == None || m_oPawn.Role == ENetRole.ROLE_SimulatedProxy || m_oPawn.Role == ENetRole.ROLE_AutonomousProxy && ProjectileClass.default.bClientPredictProjectile == FALSE)
    {
        return None;
    }
    if (GetProjectileAttachPoint(ProjectileLocation) == FALSE)
    {
        return None;
    }
    if (SFXPawn_Player(m_oPawn) != None)
    {
        HitActor = m_oPawn.Trace(HitLocation, HitNormal, m_vLocationToAimAt, ProjectileLocation, TRUE, vect(0.0, 0.0, 0.0), , );
        if (HitActor != None && HitActor != m_oTargetToAimAt)
        {
            ProjectileLocation = m_oPawn.location + Vector(m_oPawn.Rotation) * 30.0;
            ProjectileLocation.Z += 30.0;
            if (m_oPawn.Trace(HitLocation, HitNormal, m_vLocationToAimAt, ProjectileLocation, TRUE, vect(0.0, 0.0, 0.0), , ) != None)
            {
                GetStartLocationForLOSCheck(ProjectileLocation, m_oPawn);
            }
        }
    }
    if (!bProjectileUsePawnRotation)
    {
        ProjectileRotation = Rotator(m_vLocationToAimAt - ProjectileLocation);
    }
    else
    {
        ProjectileRotation = m_oPawn.Controller.Rotation;
    }
    Projectile = SFXGRI(m_oPawn.WorldInfo.GRI).ObjectPool.GetProjectile(ProjectileClass, m_oPawn, m_oPawn.Instigator, ProjectileLocation, ProjectileRotation);
    if (Projectile == None)
    {
        return None;
    }
    if (m_oPawn.Role == ENetRole.ROLE_AutonomousProxy)
    {
        Projectile.SetPrediction(TRUE, FALSE);
    }
    Projectiles.AddItem(Projectile);
    Projectile.TargetActor = m_oTargetToAimAt;
    Projectile.TargetLocation = m_vLocationToAimAt;
    if (Projectile.InitializePowerProjectile(m_oPawn, ProjectileSpeed.CurrentValue, ProjectileRadius, Self) == FALSE)
    {
        return None;
    }
    AIController = SFXAI_Core(m_oPawn.Controller);
    if (AIController != None)
    {
        AIController.m_bPowerProjectileReleased = TRUE;
    }
    return Projectile;
}
public function Replicate()
{
    Super(BioCustomAction).Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.Target = m_oTargetToAimAt;
        m_oPawn.ReplicatedCustomActionInfo.TargetLocation = m_vLocationToAimAt;
    }
}
public function ReplicateImpact(BioPawn Target, optional int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    if (Target != None)
    {
        Target.AcquireReplicatedCustomActionImpact();
        Super(BioCustomAction).ReplicateImpact(Target, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
        Target.ReplicatedCustomActionImpactInfo.CustomActionType = 132;
        Target.ReplicatedCustomActionImpactInfo.PowerCustomActionType = PowerCustomActionID;
        Target.ReleaseReplicatedCustomActionImpact();
    }
}
public function ReplicatePowerCombo(SFXGameEffect_PowerCombo ComboEffect, Vector HitLocation, Vector HitNormal)
{
    if (m_oPawn != None && ComboEffect != None)
    {
        m_oPawn.ReplicatedPowerComboInfo.TriggerCounter++;
        m_oPawn.ReplicatedPowerComboInfo.DetonatorPowerID = byte(PowerCustomActionID);
        m_oPawn.ReplicatedPowerComboInfo.DetonatorPowerInstigator = m_oPawn;
        m_oPawn.ReplicatedPowerComboInfo.EffectClass = ComboEffect.Class;
        m_oPawn.ReplicatedPowerComboInfo.SourcePowerID = byte(ComboEffect.SourcePower.PowerCustomActionID);
        m_oPawn.ReplicatedPowerComboInfo.SourcePowerInstigator = ComboEffect.SourcePower.m_oPawn;
        m_oPawn.ReplicatedPowerComboInfo.HitLocation = HitLocation;
        m_oPawn.UpdateCAPowerComboReplicationTime();
    }
}
public function ReplicatePowerComboImpact(BioPawn Target, int CustomActionReactionType, float PowerRank, int PowerComboTypeUniqueID, int MiscFlags)
{
    if (Target != None && m_oPawn != None)
    {
        Target.ReplicatedPowerComboImpactInfo.TriggerCounter++;
        Target.ReplicatedPowerComboImpactInfo.PowerType = PowerCustomActionID;
        Target.ReplicatedPowerComboImpactInfo.Instigator = m_oPawn;
        Target.ReplicatedPowerComboImpactInfo.CustomActionReactionType = CustomActionReactionType;
        if (PowerRank < 0.0 || PowerRank > 255.0)
        {
        }
        Target.ReplicatedPowerComboImpactInfo.PowerRank = byte(int(PowerRank));
        Target.ReplicatedPowerComboImpactInfo.PowerComboTypeUniqueID = PowerComboTypeUniqueID;
        Target.ReplicatedPowerComboImpactInfo.MiscFlags = byte(MiscFlags);
        Target.UpdateCAPowerComboImpactReplicationTime();
    }
}
public function ReplicatePowerSubsequentImpact(BioPawn Target, optional int CustomActionReactionType = 0, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (Target != None && m_oPawn != None)
    {
        Target.AcquireReplicatedPowerSubsequentImpact();
        Target.ReplicatedPowerSubsequentImpactInfo.TriggerCounter++;
        Target.ReplicatedPowerSubsequentImpactInfo.PowerType = PowerCustomActionID;
        Target.ReplicatedPowerSubsequentImpactInfo.Instigator = m_oPawn;
        Target.ReplicatedPowerSubsequentImpactInfo.CustomActionReactionType = CustomActionReactionType;
        Target.ReplicatedPowerSubsequentImpactInfo.Duration = byte(int(Duration * 10.0));
        if (Duration < 0.0 || int(Duration * 10.0) > 255)
        {
        }
        Target.ReplicatedPowerSubsequentImpactInfo.ImpactCount = ImpactCount;
        Target.ReplicatedPowerSubsequentImpactInfo.Delay = byte(int(Delay * 10.0));
        if (Delay < 0.0 || int(Delay * 10.0) > 255)
        {
        }
        Target.ReplicatedPowerSubsequentImpactInfo.DoCallback = DoCallback;
        Target.ReleaseReplicatedPowerSubsequentImpact();
    }
}
public function ReplicationDecodeDelayAndResistance(int EncodedData, out float fDelay, out EPowerResistance Resistance)
{
    Resistance = byte(EncodedData / 100);
    fDelay = float((EncodedData - int(Resistance) * 100)) / 10.0;
}
public function int ReplicationEncodeDelayAndResistance(float fDelay, EPowerResistance Resistance)
{
    if (fDelay >= 10.0)
    {
    }
    return int(fDelay * 10.0) + int(Resistance) * 100;
}
public function ResetPowerCooldown()
{
    if (m_oPawn == None || m_oPawn.PowerManager == None)
    {
        return;
    }
    if (UsesSharedCooldown)
    {
        m_oPawn.PowerManager.SetSharedCooldown(0.0);
    }
    else
    {
        CurrentCooldownTime = 0.0;
        TotalCooldownTime = 0.0;
    }
}
public function RestoreSaveState();

public final function SetSaveGamePowerState(int nState)
{
    if (!SFXGRI(m_oPawn.WorldInfo.GRI).IsMultiplayerGame())
    {
        Class'SFXEngine'.static.GetSFXEngine().SetPlayerVariable(GetUniquePowerPlayerVariable(), nState);
    }
}
public function bool ShouldUsePowerOnShields(BioPawn Target, Class<SFXDamageType> DamageType, out string sOptionalInfo)
{
    if (int(Target.GetCurrentResistance()) == 1)
    {
        if (DamageType.default.Resistance.Shield < 1.5)
        {
            sOptionalInfo = string(NotRecommended_TargetHasShields);
            return FALSE;
        }
    }
    else if (int(Target.GetCurrentResistance()) == 2)
    {
        if (DamageType.default.Resistance.Biotic < 1.5)
        {
            sOptionalInfo = string(NotRecommended_TargetHasBiotics);
            return FALSE;
        }
    }
    else if (int(Target.GetCurrentResistance()) == 3)
    {
        if (DamageType.default.Resistance.Armour < 1.5)
        {
            sOptionalInfo = string(NotRecommended_TargetHasArmor);
            return FALSE;
        }
    }
    return TRUE;
}
public function StartCastAnimations()
{
    StartPower();
    if (bDynamicLoadAnimSet)
    {
        LoadAnimSet();
    }
    CastingPhase = ECastingPhase.CP_Start;
    if (!bPlayStartCastAnim || PlayBodyStance(BS_StartCastAnimation, fStartAnimBlendInTime, fStartAnimBlendOutTime) == FALSE)
    {
        CastingPhase = ECastingPhase.CP_End;
        if (PlayBodyStance(BS_EndCastAnimation, fEndAnimBlendInTime, fEndAnimBlendOutTime) == FALSE)
        {
            EndThisCustomAction();
        }
    }
}
public function StartPower()
{
    TimeSinceStart = 0.0;
    bPowerReleased = FALSE;
    bPowerStarted = TRUE;
    if (m_oPawn.PowerManager.DisableCasterCrusts <= 0)
    {
        if (CE_CasterCrustTemplate != None)
        {
            if (bCustomCasterCrustParameters)
            {
                Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_CasterCrustTemplate, m_oPawn, CustomCasterCrustParameters);
            }
            else
            {
                Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_CasterCrustTemplate, m_oPawn, GetDefaultClientEffectParams());
            }
        }
    }
    if (m_oPawn.IsBlindFiring() == FALSE)
    {
        if (m_oPawn.IsLocallyControlled() && m_oPawn.IsHumanControlled())
        {
            PlayCasterSounds(CastSound, EvolvedCastSounds);
        }
        else
        {
            PlayCasterSounds(HenchmanCastSound, HenchmanEvolvedCastSounds);
        }
    }
}
public function StartPowerCooldown()
{
    local float fCooldown;
    local BioCheatManager CheatManager;
    
    if (m_oPawn == None || m_oPawn.PowerManager == None)
    {
        return;
    }
    CheatManager = m_oPawn.PowerManager.GetCheatManager();
    if (CheatManager != None)
    {
        if (CheatManager.m_bEnablePowerCooldown == FALSE)
        {
            return;
        }
    }
    fCooldown = GetPowerCooldown();
    if (UsesSharedCooldown)
    {
        m_oPawn.PowerManager.SetSharedCooldown(fCooldown);
    }
    else
    {
        CurrentCooldownTime = fCooldown;
        TotalCooldownTime = fCooldown;
    }
}
public function StopCustomAction()
{
    local BodyStance CurrentStance;
    local SFXAI_Henchman HenchAI;
    local bool InstantPowerUse;
    
    HenchAI = SFXAI_Henchman(m_oPawn.Controller);
    InstantPowerUse = HenchAI != None && HenchAI.bUsingInstantPower;
    if (!bPowerReleased)
    {
        if (SFXPawn_Player(m_oPawn) != None)
        {
            m_oPawn.PlaySound(CancelCastSound);
        }
        else
        {
            m_oPawn.PlaySound(HenchmanCancelCastSound);
        }
    }
    if (InstantPowerUse)
    {
        bPowerStarted = FALSE;
        return;
    }
    Super(BioCustomAction).StopCustomAction();
    bPowerStarted = FALSE;
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    }
    CurrentStance = GetCurrentBodyStance();
    m_oPawn.StopBodyStance(CurrentStance, fEndAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(CurrentStance, FALSE);
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.SetBodyStanceRootBoneAxisOption(CurrentStance, 1, 1, 1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PowerComboTypes = ("SFXGameContent.SFXGameEffect_PowerCombo_Biotic", "SFXGameContent.SFXGameEffect_PowerCombo_Electric", "SFXGameContent.SFXGameEffect_PowerCombo_Cryo", "SFXGameContent.SFXGameEffect_PowerCombo_Fire")
    BS_StartCastAnimation = {
                             AnimName = ('None', 
                                         'BC_Start', 
                                         'BC_Start', 
                                         'BC_Start_Cover_Neutral', 
                                         'BC_Start', 
                                         'BC_Start_Cover_Neutral_Mid', 
                                         'BC_Start', 
                                         'BC_Start', 
                                         'None', 
                                         'None', 
                                         'None', 
                                         'BC_Start'
                                        )
                            }
    BS_EndCastAnimation = {
                           AnimName = ('None', 
                                       'BC_End', 
                                       'BC_End', 
                                       'BC_End_Cover_Neutral', 
                                       'BC_End', 
                                       'BC_End_Cover_Neutral_Mid', 
                                       'BC_End', 
                                       'BC_End', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'BC_End'
                                      )
                          }
    DefaultDamageType = Class'SFXDamageType_Default'
    NonRagdollDamageType = Class'SFXDamageType_Power'
    ProjectileClass = Class'SFXProjectile_PowerCustomAction'
    DetonationParameters = {
                            ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                            HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                            ConeAngle = 0.0, 
                            ImpactFriends = FALSE, 
                            ImpactDeadPawns = FALSE, 
                            ImpactPlaceables = TRUE, 
                            BlockedByObjects = TRUE, 
                            DistancedSorted = TRUE
                           }
    ProjectileAttachPoint = 'RightWrist'
    ProjectileRadius = 1.0
    MinTimeBetweenPhysicsCallbacks = 0.5
    PhysicsToDamageMultiplier = 0.100000001
    PowerAssistFullControlValue = 1.0
    PowerAssistPartialControlValue = 0.25
    PowerComboDelay = 0.100000001
    Recommended_TargetVulnerable = $340074
    NotRecommended_TargetOrganic = $340062
    NotRecommended_TargetMachine = $340063
    NotRecommended_TargetHasShields = $340065
    NotRecommended_TargetHasBiotics = $340067
    NotRecommended_TargetHasArmor = $340068
    NotRecommended_NoMedigel = $340367
    NotRecommended_NoSquadMemberDead = $340069
    NotRecommended_NoSquadMemberInjured = $340070
    NotRecommended_WeaponPowerAlreadyOn = $340223
    NotRecommended_TargetImmune = $341124
    StatBarTitle_Damage = $581896
    StatBarTitle_DamagePerSecond = $702979
    StatBarTitle_Force = $584618
    StatBarTitle_Cooldown = $582114
    StatBarTitle_Duration = $583005
    StatBarTitle_ImpactRadius = $582116
    StatBarTitle_Range = $702481
    StatBarTitle_ParagonRenegade = $586290
    StatBarTitle_PowerDamage = $585775
    StatBarTitle_WeaponDamage = $585776
    StatBarTitle_WeightCapacity = $662232
    StatBarTitle_HealthShield = $702494
    StatBarTitle_MeleeDamage = $668295
    StatBarTitle_HealthDamage = $586056
    StatBarTitle_ArmorDamage = $586057
    StatBarTitle_BarrierDamage = $700205
    StatBarTitle_ShieldBarrierDamage = $700172
    StatBarTitle_FreezeDuration = $586252
    StatBarTitle_DamageReduction = $590733
    StatBarToken_RawValue = $582860
    StatBarToken_Force = $584617
    StatBarToken_Time = $582115
    StatBarToken_Distance = $582117
    StatBarToken_Percent = $585771
    StatBarToken_PositivePercent = $586054
    StatBarToken_NegativePercent = $700195
    CameraAnimPlayRate = 1.0
    CameraAnimBlendIn = 0.200000003
    CameraAnimBlendOut = 0.200000003
    fAnimPlayRate = 1.0
    fStartAnimBlendInTime = 0.300000012
    fStartAnimBlendOutTime = 0.100000001
    fEndAnimBlendInTime = 0.100000001
    fEndAnimBlendOutTime = 0.100000001
    CancelCastSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cancel_P'
    HenchmanCancelCastSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cancel_NP'
    LeanOutToCast = TRUE
    bDynamicLoadAnimSet = TRUE
    bPlayStartCastAnim = TRUE
    bPlayEndCastAnim = TRUE
    ProjectileSpeed = {BaseValue = 2000.0}
    RankCosts = (1, 2, 3, 4, 5, 6)
    bEnabled = TRUE
    AISelectable = TRUE
    UsesSharedCooldown = TRUE
    DisplayInHUD = TRUE
    DisplayInCharacterRecord = TRUE
    OverrideList = (Class'SFXCustomAction_Ragdoll', 
                    Class'SFXCustomAction_AnimatedRagdoll', 
                    Class'SFXCustomAction_Frozen', 
                    Class'SFXCustomAction_SwatTurn', 
                    Class'SFXCustomAction_CoverSlipBase', 
                    Class'BioCustomAction_CoverMantle', 
                    Class'BioCustomAction_CoverClimb', 
                    Class'SFXCustomAction_PlayerEvadeBase', 
                    Class'SFXCustomAction_PlayerMeleeBase', 
                    Class'SFXCustomAction_PlayerHeavyMeleeBase'
                   )
    bDisableLeftHandIK = TRUE
    bAllowChargeHolding = TRUE
    bDisableAiming = FALSE
    bBlockingAction = FALSE
    bClientPredictCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_Medium
}