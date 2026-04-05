Class SFXGameEffect_ElectricComboBeam extends SFXGameEffect;

var Name BeamAttachBoneName;
var Actor SourceActor;
var editinline export ParticleSystemComponent PSC_Beam;
var RvrClientEffectInterface CE_ImpactTemplate;
var RvrClientEffectInterface CE_CrustTemplate;
var float CrustDuration;
var WwiseEvent BeamSound;
var bool bBeamActive;

public function OnRemoved()
{
    local BioPawn SourcePawn;
    local KActor oKActor;
    
    Super.OnRemoved();
    if (PSC_Beam != None)
    {
        bBeamActive = FALSE;
        PSC_Beam.SetActive(FALSE);
        PSC_Beam.SetHidden(TRUE);
        SourcePawn = BioPawn(SourceActor);
        if (SourcePawn != None && SourcePawn.Mesh != None)
        {
            SourcePawn.Mesh.DetachComponent(PSC_Beam);
        }
        else
        {
            oKActor = KActor(SourceActor);
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
    if (bBeamActive && PSC_Beam != None && Owner != None)
    {
        PSC_Beam.SetVectorParameter('Impact', Owner.location);
    }
}
public function OnApplied()
{
    local SFXKActor oKActor;
    local RvrClientEffectTarget CETarget;
    local BioPawn SourcePawn;
    local BioPawn OwnerPawn;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        OwnerPawn.BreakStealth();
    }
    CETarget.Instigator = Owner;
    CETarget.SpawnValue.X = CrustDuration;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_CrustTemplate, CETarget);
    if (SourceActor != None)
    {
        SourcePawn = BioPawn(SourceActor);
        if (SourcePawn != None && SourcePawn.Mesh != None)
        {
            SourcePawn.Mesh.AttachComponent(PSC_Beam, BeamAttachBoneName);
            PSC_Beam.SetDepthPriorityGroup(SourcePawn.Mesh.DepthPriorityGroup);
            PSC_Beam.SetTickGroup(3);
            PlayBeamEffect(PSC_Beam, Owner.location);
        }
        else
        {
            oKActor = SFXKActor(SourceActor);
            if (oKActor != None && oKActor.StaticMeshComponent != None)
            {
                oKActor.AttachComponent(PSC_Beam);
                PSC_Beam.SetDepthPriorityGroup(oKActor.StaticMeshComponent.DepthPriorityGroup);
                PSC_Beam.SetTickGroup(3);
                PlayBeamEffect(PSC_Beam, Owner.location);
            }
        }
        Owner.PlaySound(BeamSound, TRUE);
    }
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
    CE_CrustTemplate = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_VCFX'
    CrustDuration = 1.0
    BeamSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_S_overload_charged'
}