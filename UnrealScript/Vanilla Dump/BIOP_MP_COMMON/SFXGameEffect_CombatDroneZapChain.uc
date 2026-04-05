Class SFXGameEffect_CombatDroneZapChain extends SFXGameEffect;

var array<Actor> AffectedActors;
var Class<SFXDamageType> DamageType;
var Vector DamageOrigin;
var Name BeamAttachBoneName;
var int NumChargesLeft;
var float MaxJumpDistance;
var float JumpDelay;
var float JumpTimer;
var float IncapacitateChance;
var Actor Target;
var clearcrosslevel SFXPowerCustomAction_CombatDroneZap Power;
var BioPawn Caster;
var float Damage;
var float Force;
var Actor LastHitActor;
var editinline export ParticleSystemComponent PSC_Beam;
var ParticleSystem ImpactTemplate;
var RvrClientEffectInterface CE_TargetCrustTemplate;
var WwiseEvent ImpactSound;
var WwiseEvent BeamSound;
var float CrustDuration;
var bool bEffectDone;
var bool bBeamActive;

public function OnRemoved()
{
    local BioPawn oLastHitPawn;
    local KActor oKActor;
    
    Super.OnRemoved();
    if (PSC_Beam != None)
    {
        bBeamActive = FALSE;
        PSC_Beam.SetActive(FALSE);
        PSC_Beam.SetHidden(TRUE);
        oLastHitPawn = BioPawn(LastHitActor);
        if (oLastHitPawn != None && oLastHitPawn.Mesh != None)
        {
            oLastHitPawn.Mesh.DetachComponent(PSC_Beam);
        }
        else
        {
            oKActor = KActor(LastHitActor);
            if (oKActor != None && oKActor.StaticMeshComponent != None)
            {
                oKActor.DetachComponent(PSC_Beam);
            }
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    Super.OnUpdate(DeltaSeconds);
    if (bBeamActive && PSC_Beam != None && Target != None)
    {
        PSC_Beam.SetVectorParameter('Impact', Target.location);
    }
    if (!bEffectDone && (Owner != None && Owner.Role == ENetRole.ROLE_Authority))
    {
        JumpTimer += DeltaSeconds;
        if (JumpTimer > JumpDelay)
        {
            SelectAndImpactNextTarget();
            bEffectDone = TRUE;
        }
    }
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactEmitter(default.ImpactTemplate);
}
public function OnApplied()
{
    local BioPawn oLastHitPawn;
    local Vector HitNormal;
    local SFXKActor oKActor;
    local float fDamage;
    local Vector vForce;
    local Actor oTargetOverride;
    local EPowerResistance Resistance;
    local SFXAI_Core oAI;
    local SFXPawn oTargetPawn;
    local RvrClientEffectTarget CETarget;
    
    Super.OnApplied();
    Target = Owner;
    fDamage = Damage;
    HitNormal = Normal(DamageOrigin - Target.location);
    vForce = -HitNormal * Force;
    if (IncapacitateChance > 0.0 && FRand() < IncapacitateChance)
    {
        DamageType = Class'SFXDamageType_CombatDroneAttackImproved';
    }
    else
    {
        DamageType = Class'SFXDamageType_CombatDroneAttack';
    }
    Resistance = Target.GetPowerResistance(Caster, Target.location, HitNormal, fDamage, vForce, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        AffectedActors.AddItem(Target);
        Target = oTargetOverride;
    }
    oTargetPawn = SFXPawn(Target);
    if (Target.ImpactWithPower(Resistance, Caster, Target.location, HitNormal, fDamage, vForce, DamageType))
    {
        if (oTargetPawn != None)
        {
            oTargetPawn.ReplicateAnimatedReaction(oTargetPawn.CurrentCustomAction);
        }
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        if (oTargetPawn != None)
        {
            oAI = SFXAI_Core(oTargetPawn.Controller);
            if (oAI != None)
            {
                oAI.IgnoredTargets.RemoveItem(Caster);
                if (oAI.PreferredTarget == None && !oTargetPawn.bIgnoresPets)
                {
                    oAI.PreferredTarget = Caster;
                }
            }
            CETarget.Instigator = oTargetPawn;
            CETarget.SpawnValue.X = CrustDuration;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_TargetCrustTemplate, CETarget);
        }
    }
    Target.PlaySound(ImpactSound, TRUE);
    if (LastHitActor == None)
    {
        SFXGRI(Target.WorldInfo.GRI).PlayTransientSound(BeamSound, LastHitActor.location + (Target.location - LastHitActor.location) * 0.5);
    }
    else if (Caster != None)
    {
        SFXGRI(Target.WorldInfo.GRI).PlayTransientSound(BeamSound, Caster.location + (Target.location - Caster.location) * 0.5);
    }
    SFXGRI(Owner.WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(Owner, ImpactTemplate, Target.location, Rotator(HitNormal));
    if (LastHitActor != None)
    {
        oLastHitPawn = BioPawn(LastHitActor);
        if (oLastHitPawn != None && oLastHitPawn.Mesh != None)
        {
            if (oLastHitPawn.Class.Name == 'SFXPawn_CombatDrone' || oLastHitPawn.Class.Name == 'SFXPawn_ProtectorDrone')
            {
                oLastHitPawn.Mesh.AttachComponent(PSC_Beam, 'Root');
            }
            else
            {
                oLastHitPawn.Mesh.AttachComponent(PSC_Beam, BeamAttachBoneName);
            }
            PSC_Beam.SetDepthPriorityGroup(oLastHitPawn.Mesh.DepthPriorityGroup);
            PSC_Beam.SetTickGroup(3);
            PlayBeamEffect(PSC_Beam, Target.location);
        }
        else
        {
            oKActor = SFXKActor(LastHitActor);
            if (oKActor != None && oKActor.StaticMeshComponent != None)
            {
                oKActor.AttachComponent(PSC_Beam);
                PSC_Beam.SetDepthPriorityGroup(oKActor.StaticMeshComponent.DepthPriorityGroup);
                PSC_Beam.SetTickGroup(3);
                PlayBeamEffect(PSC_Beam, Target.location);
            }
        }
    }
    NumChargesLeft--;
    if (NumChargesLeft <= 0 || Resistance == EPowerResistance.Resistance_Full)
    {
        bEffectDone = TRUE;
        return;
    }
    AffectedActors.AddItem(Target);
}
public function bool ImpactAdditionalTarget(Actor oActor)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_CombatDroneZapChain Effect;
    
    Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Effect = SFXGameEffect_CombatDroneZapChain(Manager.CreateEffect(Class'SFXGameEffect_CombatDroneZapChain', Category, 0.0, 2, 0.0, Instigator));
        if (Effect != None)
        {
            Effect.NumChargesLeft = NumChargesLeft;
            Effect.MaxJumpDistance = MaxJumpDistance;
            Effect.JumpDelay = JumpDelay;
            Effect.Caster = Caster;
            Effect.Power = Power;
            Effect.Damage = Damage;
            Effect.Force = Force;
            Effect.DamageOrigin = Target.location;
            Effect.LastHitActor = Target;
            Effect.AffectedActors = AffectedActors;
            Effect.DamageType = DamageType;
            Effect.OnApplied();
            NumChargesLeft = 0;
            return TRUE;
        }
    }
    return FALSE;
}
public final function PlayBeamEffect(ParticleSystemComponent PS, Vector TargetLocation)
{
    if (PS != None)
    {
        bBeamActive = TRUE;
        PS.SetHidden(FALSE);
        PS.ActivateSystem();
        PS.SetVectorParameter('Impact', TargetLocation);
    }
}
public function SelectAndImpactNextTarget()
{
    local array<Actor> NearbyActors;
    local AreaEffectParameters Param;
    local Actor oActor;
    
    if (Power == None || Target == None)
    {
        return;
    }
    Param.BlockedByObjects = TRUE;
    Param.DistancedSorted = TRUE;
    Param.ImpactPlaceables = TRUE;
    Power.GetNearbyActors(NearbyActors, Target.location, MaxJumpDistance, MaxJumpDistance, Param);
    foreach NearbyActors(oActor, )
    {
        if (NumChargesLeft <= 0)
        {
            return;
        }
        else if (AffectedActors.Find(oActor) == -1 && ImpactAdditionalTarget(oActor))
        {
            if (Power.ShouldReplicate())
            {
                Power.ReplicatePowerSubsequentImpact(BioPawn(oActor), BioPawn(oActor).CurrentCustomAction);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=BeamPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_Arc.Particles.Arc_attack_Beam'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    BeamAttachBoneName = 'God'
    PSC_Beam = BeamPSC0
    ImpactTemplate = ParticleSystem'BioVFX_C_Wpn_Arc.Particles.Arc_Imp'
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_drone_attack_impact'
    BeamSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_drone_attack_vfx'
    CrustDuration = 1.5
}