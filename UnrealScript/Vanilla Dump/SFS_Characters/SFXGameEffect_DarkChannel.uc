Class SFXGameEffect_DarkChannel extends SFXGameEffect_DamageOverTime
    config(Game);

var Guid CrustGuid;
var Name BeamAttachBoneName;
var config float JumpRadius;
var RvrClientEffectInterface CE_TargetCrustTemplate;
var clearcrosslevel SFXPowerCustomAction_DarkChannel Power;
var instanced ParticleSystemComponent PSC_Beam;
var BioPawn LastHitPawn;
var float RemoveTimer;
var BioPawn OwnerPawn;
var WwiseEvent JumpSound;
var WwiseEvent StartLoopSound;
var WwiseEvent StopLoopSound;
var bool DelayedRemove;

public function OnRemoved()
{
    Super.OnRemoved();
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_TargetCrustTemplate, CrustGuid, TRUE);
    if (OwnerPawn != None)
    {
        OwnerPawn.StopSound(StartLoopSound);
        OwnerPawn.PlaySound(StopLoopSound, TRUE);
    }
    if (PSC_Beam != None)
    {
        PSC_Beam.SetActive(FALSE);
        PSC_Beam.SetHidden(TRUE);
        if (OwnerPawn != None && OwnerPawn.Mesh != None)
        {
            OwnerPawn.Mesh.DetachComponent(PSC_Beam);
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    if (DelayedRemove)
    {
        RemoveTimer += DeltaSeconds;
    }
    if (RemoveTimer > 1.0)
    {
        CurrentTime = Duration + 1.0;
    }
}
public function DoDamage()
{
    local BioPawn oPawn;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_DarkChannel NewEffect;
    
    Super.DoDamage();
    if (OwnerPawn != None && OwnerPawn.IsDead() && !DelayedRemove)
    {
        DelayedRemove = TRUE;
        foreach OwnerPawn.CollidingActors(Class'BioPawn', oPawn, JumpRadius, OwnerPawn.location, , , )
        {
            if (!oPawn.IsDead() && int(oPawn.GetTeamNum()) == 1)
            {
                Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
                if (Manager != None)
                {
                    Manager.RemoveEffectsByType(Class'SFXGameEffect_DarkChannel');
                    NewEffect = SFXGameEffect_DarkChannel(Manager.CreateEffect(Class'SFXGameEffect_DarkChannel', Power.Name, Duration - CurrentTime, 1, EffectValue, Instigator));
                    if (NewEffect != None)
                    {
                        NewEffect.Power = Power;
                        NewEffect.LastHitPawn = OwnerPawn;
                        NewEffect.OnApplied();
                    }
                    OwnerPawn.PlaySound(JumpSound, TRUE);
                    Power.CurrentTarget = oPawn;
                    OwnerPawn.Mesh.AttachComponent(PSC_Beam, BeamAttachBoneName);
                    PSC_Beam.SetDepthPriorityGroup(OwnerPawn.Mesh.DepthPriorityGroup);
                    PSC_Beam.SetTickGroup(3);
                    PSC_Beam.SetHidden(FALSE);
                    PSC_Beam.ActivateSystem();
                    PSC_Beam.SetVectorParameter('Impact', oPawn.location);
                    break;
                }
            }
        }
    }
}
public function OnApplied()
{
    local EPowerResistance Resistance;
    local Vector HitNormal;
    local float fDamage;
    local Vector vForce;
    local Actor oTargetOverride;
    local Actor Target;
    local RvrClientEffectTarget CETarget;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (CE_TargetCrustTemplate != None)
    {
        CETarget.Instigator = Owner;
        CETarget.SpawnValue.X = Duration - CurrentTime;
        CrustGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_TargetCrustTemplate, CETarget);
    }
    if (OwnerPawn != None)
    {
        OwnerPawn.PlaySound(StartLoopSound, TRUE);
    }
    if (Power != None)
    {
        Power.AddComboEffect(Owner, Class'SFXGameEffect_PowerCombo_Biotic', Duration);
        if (LastHitPawn == None)
        {
            vForce = -Vector(Owner.Rotation) * 300.0;
        }
        else
        {
            vForce = Normal(Owner.location - LastHitPawn.location) * 300.0;
        }
        Target = Owner;
        Resistance = Target.GetPowerResistance(Power.m_oPawn, Target.location, HitNormal, fDamage, vForce, DamageType, oTargetOverride);
        if (oTargetOverride != None)
        {
            Target = oTargetOverride;
        }
        Target.ImpactWithPower(Resistance, Power.m_oPawn, Target.location, HitNormal, fDamage, vForce, DamageType);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=BeamPSC0
        Template = ParticleSystem'BioVFX_Hch_Prothean.Particles.DarkChannel_Beam'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    BeamAttachBoneName = 'God'
    JumpRadius = 800.0
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_Hch_Prothean.VCFX.DarkChannel_TargetCrust_VCFX'
    PSC_Beam = BeamPSC0
    JumpSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_S_darkchan_jump'
    StartLoopSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_S_darkchan_loop'
    StopLoopSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Stop_power_biotic_S_darkchan_loop'
}