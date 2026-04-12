Class SFXGameEffect_BatarianNet_Shared extends SFXGameEffect_WeldPhysics;

var Class<SFXDamageType> ElectricPulseDamageType;
var Guid TargetCrustGuid;
var Name BeamAttachBoneName;
var clearcrosslevel SFXPawn OwnerPawn;
var float IncapacitateDuration;
var float IncapacitateResistThreshold;
var RvrClientEffectInterface CE_TargetCrust;
var RvrClientEffectInterface CE_ExitCrust;
var RvrClientEffectInterface CE_ElectricPulseCrust;
var float ElectricPulseFrequency;
var float ElectricPulseDamage;
var float ElectricPulseRange;
var float ElectricPulseForce;
var instanced ParticleSystemComponent PSC_Beam;
var float BeamDuration;
var clearcrosslevel BioPawn BeamTarget;
var WwiseEvent ElectricPulseSound;
var WwiseEvent WWise_On;
var WwiseEvent WWise_Off;
var clearcrosslevel SFXPowerCustomActionMP_BatarianNet_Shared Power;
var bool bWasInMatinee;
var bool bWasDisabled;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    local RvrClientEffectTarget Target;
    
    Super.OnRemoved();
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_TargetCrust, TargetCrustGuid, TRUE);
    Target.Instigator = Owner;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_ExitCrust, Target, Owner);
    if (OwnerPawn == None)
    {
        return;
    }
    OwnerPawn.ClearTimer('ElectricPulse', Self);
    if (OwnerPawn.SnapshotNode != None)
    {
        OwnerPawn.SnapshotNode.m_bCaptureOnRelevant = TRUE;
    }
    if (bWasInMatinee || bWasDisabled)
    {
        OwnerPawn.AddRagdollImpulse(vect(0.0, 0.0, 0.0), Instigator, vect(0.0, 0.0, 0.0));
    }
    if (OwnerPawn.PowerControlResistance < IncapacitateResistThreshold)
    {
        Manager = OwnerPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_Ragdoll', Category, IncapacitateDuration, 1, 0.0, Instigator, Causer);
        }
    }
    OwnerPawn.PlaySound(WWise_Off);
}
public function OnUpdate(float DeltaSeconds)
{
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    NullVelocity();
}
public function OnApplied()
{
    local SFXAI_Core AI;
    
    OwnerPawn = SFXPawn(Owner);
    if (OwnerPawn == None)
    {
        return;
    }
    AI = SFXAI_Core(OwnerPawn.Controller);
    if (AI != None)
    {
        bWasDisabled = AI.IsInState('Disabled', TRUE);
    }
    bWasInMatinee = OwnerPawn.Physics == EPhysics.PHYS_Interpolating;
    StartCrustVFX();
    Super.OnApplied();
    NullVelocity();
    if (ElectricPulseFrequency > float(0))
    {
        OwnerPawn.SetTimer(ElectricPulseFrequency, TRUE, 'ElectricPulse', Self);
    }
    OwnerPawn.PlaySound(WWise_On);
}
public final function StopBeam()
{
    PSC_Beam.SetActive(FALSE);
    PSC_Beam.SetHidden(TRUE);
    if (BeamTarget != None)
    {
        BeamTarget.Mesh.DetachComponent(PSC_Beam);
    }
    BeamTarget = None;
}
public function NullVelocity()
{
    if (OwnerPawn != None && OwnerPawn.IsDead() == FALSE)
    {
        OwnerPawn.Velocity.X = 0.0;
        OwnerPawn.Velocity.Y = 0.0;
        OwnerPawn.Velocity.Z = 0.0;
        OwnerPawn.Mesh.SetRBLinearVelocity(OwnerPawn.Velocity);
        OwnerPawn.Mesh.SetRBAngularVelocity(OwnerPawn.Velocity);
    }
}
public final function StartCrustVFX()
{
    local RvrClientEffectManager Manager;
    local RvrClientEffectTarget Target;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        Target.Instigator = Owner;
        TargetCrustGuid = Manager.StartOnTarget(CE_TargetCrust, Target, Owner);
    }
    else
    {
        Owner.SetTimer(0.100000001, FALSE, 'StartCrustVFX', Self);
    }
}
public function CreateBeam(BioPawn NearestPawn, Vector ImpactLocation)
{
    local RvrClientEffectTarget CETarget;
    
    if (NearestPawn == None)
    {
        return;
    }
    BeamTarget = NearestPawn;
    if (BeamTarget.Mesh != None)
    {
        BeamTarget.Mesh.AttachComponent(PSC_Beam, BeamAttachBoneName);
        PSC_Beam.SetDepthPriorityGroup(BeamTarget.Mesh.DepthPriorityGroup);
        PSC_Beam.SetTickGroup(3);
        PSC_Beam.SetHidden(FALSE);
        PSC_Beam.ActivateSystem();
        PSC_Beam.SetVectorParameter('Impact', ImpactLocation);
    }
    CETarget.Instigator = NearestPawn;
    CETarget.SpawnValue.X = BeamDuration;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_ElectricPulseCrust, CETarget);
    if (ElectricPulseSound != None)
    {
        OwnerPawn.PlaySound(ElectricPulseSound, TRUE);
    }
    if (Power != None && Power.ShouldReplicate())
    {
        Power.ReplicateImpact(BeamTarget, -2);
    }
}
public final function ElectricPulse()
{
    local BioPawn NearbyPawn;
    local Actor oTargetOverride;
    local EPowerResistance Resistance;
    local BioPawn NearestPawn;
    local float NearestDistance;
    local float fDist;
    local Vector vHitNormal;
    local float fDamage;
    local Vector vForce;
    
    StopBeam();
    if (OwnerPawn == None || OwnerPawn.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    NearestDistance = 10000000.0;
    foreach OwnerPawn.WorldInfo.AllPawns(Class'BioPawn', NearbyPawn, OwnerPawn.location, ElectricPulseRange)
    {
        if (NearbyPawn != OwnerPawn && !NearbyPawn.IsDead() && NearbyPawn.GetTeam().TeamIndex == 1)
        {
            fDist = VSizeSq(OwnerPawn.location - NearbyPawn.location);
            if (fDist < NearestDistance)
            {
                NearestDistance = fDist;
                NearestPawn = NearbyPawn;
            }
        }
    }
    if (NearestPawn != None)
    {
        vHitNormal = Normal(OwnerPawn.location - NearestPawn.location);
        fDamage = ElectricPulseDamage;
        vForce = -vHitNormal * ElectricPulseForce;
        Resistance = NearestPawn.GetPowerResistance(Power.m_oPawn, NearestPawn.location, vHitNormal, fDamage, vForce, ElectricPulseDamageType, oTargetOverride);
        if (Resistance != EPowerResistance.Resistance_Full)
        {
            if (oTargetOverride != None)
            {
                NearestPawn = BioPawn(oTargetOverride);
            }
            if (NearestPawn != None)
            {
                if (NearestPawn.ImpactWithPower(Resistance, Power.m_oPawn, NearestPawn.location, vHitNormal, fDamage, vForce, ElectricPulseDamageType))
                {
                    NearestPawn.ReplicateAnimatedReaction(NearestPawn.CurrentCustomAction);
                }
            }
        }
        CreateBeam(NearestPawn, OwnerPawn.location);
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
    CE_TargetCrust = RvrClientEffect'BioVFX_DLC_MP1_Bat.VCFX.Net_Wrap_Impact_VCFX'
    CE_ExitCrust = RvrClientEffect'BioVFX_DLC_MP1_Bat.VCFX.Net_Exit_Explo_VCFX'
    CE_ElectricPulseCrust = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_DOT_VCFX'
    PSC_Beam = BeamPSC0
    BeamDuration = 0.5
    ElectricPulseSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_S_overload_charged'
}