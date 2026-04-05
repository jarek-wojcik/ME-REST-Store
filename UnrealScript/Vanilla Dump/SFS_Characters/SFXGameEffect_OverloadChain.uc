Class SFXGameEffect_OverloadChain extends SFXGameEffect;

var array<Actor> AffectedActors;
var Class<SFXDamageType> NormalDamageType;
var Class<SFXDamageType> RobotDamageType;
var Class<SFXDamageType> OrganicRagdollDamageType;
var Class<SFXRumble_Power> ImpactControllerRumble;
var Class<SFXShake_Power> ImpactCameraShake;
var Vector DamageOrigin;
var Name BeamAttachBoneName;
var int NumChargesLeft;
var float MaxJumpDistance;
var float JumpDelay;
var float JumpTimer;
var Actor Target;
var int RagdollOrganics;
var clearcrosslevel SFXPowerCustomAction_Overload Power;
var BioPawn Caster;
var float Damage;
var int CumulativeHits;
var float DamageLossPerHit;
var float Force;
var float OrganicDamagePct;
var Actor LastHitActor;
var instanced ParticleSystemComponent PSC_Beam;
var RvrClientEffectInterface CE_ImpactTemplate;
var float ElectricComboDuration;
var WwiseEvent BeamSound;
var float ShieldRegenPenalty;
var float ShieldRegenPenaltyDuration;
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
public function OnApplied()
{
    local SFXPawn oTargetPawn;
    local SFXPawn oLastHitPawn;
    local Vector HitNormal;
    local Class<SFXDamageType> DamageType;
    local SFXKActor oKActor;
    local float fDamage;
    local Vector vForce;
    local Actor oTargetOverride;
    local EPowerResistance Resistance;
    local bool bAssistApplied;
    local SFXModule_GameEffectManager Manager;
    
    Super.OnApplied();
    Target = Owner;
    HitNormal = Normal(DamageOrigin - Target.location);
    fDamage = Damage;
    vForce = -HitNormal * Force;
    oTargetPawn = SFXPawn(Target);
    if (oTargetPawn != None && oTargetPawn.RaceType != ERaceType.RaceType_Machine)
    {
        DamageType = NormalDamageType;
        fDamage *= OrganicDamagePct;
        if (RagdollOrganics > 0)
        {
            Resistance = Target.GetPowerResistance(Caster, Target.location, HitNormal, fDamage, vForce, OrganicRagdollDamageType, oTargetOverride);
            if (oTargetOverride != None)
            {
                Target = oTargetOverride;
                oTargetPawn = SFXPawn(Target);
            }
            if (Target.ImpactWithPower(Resistance, Caster, Target.location, HitNormal, fDamage, vForce, OrganicRagdollDamageType))
            {
                if (oTargetPawn != None)
                {
                    oTargetPawn.ReplicateAnimatedReaction(oTargetPawn.CurrentCustomAction);
                }
            }
            if (oTargetPawn != None && Resistance == EPowerResistance.Resistance_None)
            {
                oTargetPawn.AddPowerAssistEvent(Caster, Power.DisplayName, Power.PowerAssistPartialControlValue);
                bAssistApplied = TRUE;
                RagdollOrganics--;
            }
            Target = Owner;
        }
    }
    else
    {
        DamageType = RobotDamageType;
    }
    Resistance = Target.GetPowerResistance(Caster, Target.location, HitNormal, fDamage, vForce, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        AffectedActors.AddItem(Target);
        Target = oTargetOverride;
    }
    oTargetPawn = SFXPawn(Target);
    if (oTargetPawn != None && Resistance != EPowerResistance.Resistance_Full)
    {
        oTargetPawn.BreakStealth();
        Power.AddComboEffect(oTargetPawn, Class'SFXGameEffect_PowerCombo_Electric', ElectricComboDuration);
        Manager = oTargetPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && !Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ShieldRegenBonus', Category))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_ShieldRegenBonus', Category, ShieldRegenPenaltyDuration, 1, ShieldRegenPenalty, Instigator, Causer);
        }
    }
    if (Target.ImpactWithPower(Resistance, Caster, Target.location, HitNormal, fDamage, vForce, DamageType))
    {
        if (oTargetPawn != None)
        {
            oTargetPawn.ReplicateAnimatedReaction(oTargetPawn.CurrentCustomAction);
        }
    }
    if (!bAssistApplied && oTargetPawn != None && Resistance == EPowerResistance.Resistance_None)
    {
        oTargetPawn.AddPowerAssistEvent(Caster, Power.DisplayName, Power.PowerAssistPartialControlValue);
    }
    Power.CheckForPowerCombo(Target, Resistance, Target.location, HitNormal);
    if (SFXPawn_Henchman(Caster) != None)
    {
        Power.PlayImpactSounds(Owner.location, Power.HenchmanImpactSound, Power.HenchmanEvolvedImpactSounds);
    }
    else
    {
        Power.PlayImpactSounds(Owner.location, Power.ImpactSound, Power.EvolvedImpactSounds);
    }
    Power.PlayPowerControllerRumble(ImpactControllerRumble, Target.location);
    Power.PlayPowerScreenShake(ImpactCameraShake, Target.location);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ImpactTemplate, Target.location, HitNormal);
    if (LastHitActor != None)
    {
        oLastHitPawn = SFXPawn(LastHitActor);
        if (oLastHitPawn != None && oLastHitPawn.Mesh != None)
        {
            oLastHitPawn.Mesh.AttachComponent(PSC_Beam, BeamAttachBoneName);
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
        Target.PlaySound(BeamSound, TRUE);
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
    local SFXGameEffect_OverloadChain Effect;
    local BioPawn oPawn;
    
    if (Power != None)
    {
        Power.TestAchievement(oActor);
    }
    Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Effect = SFXGameEffect_OverloadChain(Manager.CreateEffect(Class'SFXGameEffect_OverloadChain', Category, 0.0, 2, 0.0, Instigator));
        if (Effect != None)
        {
            Effect.NumChargesLeft = NumChargesLeft;
            Effect.MaxJumpDistance = MaxJumpDistance;
            Effect.JumpDelay = JumpDelay;
            Effect.Caster = Caster;
            Effect.Power = Power;
            Effect.Damage = Damage - Damage * DamageLossPerHit;
            Effect.CumulativeHits = CumulativeHits + 1;
            Effect.DamageLossPerHit = DamageLossPerHit;
            Effect.Force = Force;
            Effect.DamageOrigin = Target.location;
            Effect.LastHitActor = Target;
            Effect.AffectedActors = AffectedActors;
            Effect.NormalDamageType = NormalDamageType;
            Effect.RobotDamageType = RobotDamageType;
            Effect.RagdollOrganics = RagdollOrganics;
            Effect.OrganicDamagePct = OrganicDamagePct;
            Effect.ShieldRegenPenalty = ShieldRegenPenalty;
            Effect.ShieldRegenPenaltyDuration = ShieldRegenPenaltyDuration;
            oPawn = BioPawn(Owner);
            if (oPawn != None && oPawn.IsInvisible())
            {
                oPawn.BreakStealth();
            }
            Effect.OnApplied();
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
    
    if (Power == None)
    {
        return;
    }
    Param.BlockedByObjects = TRUE;
    Param.DistancedSorted = TRUE;
    Param.ImpactPlaceables = TRUE;
    Power.GetNearbyActors(NearbyActors, Target.location, MaxJumpDistance, MaxJumpDistance, Param);
    foreach NearbyActors(oActor, )
    {
        if (AffectedActors.Find(oActor) == -1 && ImpactAdditionalTarget(oActor))
        {
            if (Power.ShouldReplicate())
            {
                Power.ReplicatePowerSubsequentImpact(BioPawn(oActor), BioPawn(oActor).CurrentCustomAction, , CumulativeHits);
            }
            break;
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
    OrganicRagdollDamageType = Class'SFXDamageType_Overload_Ragdoll'
    ImpactControllerRumble = Class'SFXRumble_Power_HeavyImpact'
    ImpactCameraShake = Class'SFXShake_Power_HeavyImpact'
    BeamAttachBoneName = 'God'
    PSC_Beam = BeamPSC0
    CE_ImpactTemplate = RvrClientEffect'BioVFX_T_TechPowers.05_Overload.VCFX.Overload_Imp_VCFX'
    BeamSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_S_overload_charged'
}