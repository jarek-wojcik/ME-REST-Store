Class SFXGameEffect_CryoFreeze extends SFXGameEffect_WeldPhysics;

var delegate<OnFrozenPawnDied> __OnFrozenPawnDied__Delegate;
var Guid FreezeCrustGuid;
var float ThawTime;
var float FrozenPhysicsDamageIncrease;
var SFXGameEffect_PhysicsDamageMultiplier PhysicsDamageMultiplier;
var RvrClientEffectInterface CE_FreezeTemplate;
var RvrClientEffectInterface CE_DeathEffect;
var BioPawn OwnerPawn;
var WwiseEvent FrozenDeathSound;
var bool bThawStarted;
var bool bOwnerDied;
var bool bPlayFrozenDeathSound;

public function OnRemoved()
{
    Super.OnRemoved();
    if (PhysicsDamageMultiplier != None)
    {
        PhysicsDamageMultiplier.CurrentTime = PhysicsDamageMultiplier.Duration + 1.0;
    }
    if (!bThawStarted)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_FreezeTemplate, FreezeCrustGuid, TRUE);
    }
}
public function OnUpdate(float DeltaSeconds)
{
    local RvrClientEffectTarget TargetInfo;
    
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    if (!bThawStarted && Duration - CurrentTime < ThawTime)
    {
        bThawStarted = TRUE;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_FreezeTemplate, FreezeCrustGuid, TRUE);
    }
    else if (!bOwnerDied && OwnerPawn != None && OwnerPawn.IsDead())
    {
        bOwnerDied = TRUE;
        if (__OnFrozenPawnDied__Delegate != None)
        {
            __OnFrozenPawnDied__Delegate(OwnerPawn);
        }
        if (OwnerPawn.CanPlayDeathEffect())
        {
            TargetInfo.Instigator = Owner;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_DeathEffect, TargetInfo);
            OwnerPawn.OnCorpseDestroyed();
        }
        if (bPlayFrozenDeathSound)
        {
            Owner.PlaySound(FrozenDeathSound);
        }
    }
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        Manager = OwnerPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            PhysicsDamageMultiplier = SFXGameEffect_PhysicsDamageMultiplier(Manager.CreateEffect(Class'SFXGameEffect_PhysicsDamageMultiplier', Category, Duration, 1, FrozenPhysicsDamageIncrease, Instigator));
            if (PhysicsDamageMultiplier != None)
            {
                PhysicsDamageMultiplier.OnApplied();
            }
        }
    }
}
public delegate function OnFrozenPawnDied(BioPawn oPawn);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ThawTime = 1.0
    FrozenPhysicsDamageIncrease = 1.0
    CE_FreezeTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Freeze_VCFX'
    CE_DeathEffect = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Death_VCFX'
    FrozenDeathSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cryo_explode'
    bPlayFrozenDeathSound = TRUE
    Priority = 10
    bCorpseDestroyed = TRUE
    bPreventEatable = TRUE
}