Class SFXGameEffect_DelayedCryoFreeze extends SFXGameEffect;

var delegate<OnFrozenPawnDied> __OnFrozenPawnDied__Delegate;
var Guid FreezeCrustGuid;
var RvrClientEffectInterface CE_DeathEffect;
var RvrClientEffectInterface CE_FreezeTemplate;
var WwiseEvent FrozenDeathSound;
var WwiseEvent FreezingSound;
var BioPawn OwnerPawn;
var clearcrosslevel SFXPowerCustomAction Power;
var bool bPlayFrozenDeathSound;
var bool bOwnerDied;

public function OnRemoved()
{
    local SFXGameEffect_CryoFreeze FreezeEffect;
    local SFXGameEffect_HealthRegenPenalty HoTDebuffEffect;
    local SFXModule_GameEffectManager Manager;
    
    Super.OnRemoved();
    Owner.CustomTimeDilation = 1.0;
    if (Power != None)
    {
        Power.AddComboEffect(OwnerPawn, Class'SFXGameEffect_PowerCombo_Cryo', EffectValue);
    }
    if (OwnerPawn == None || bOwnerDied)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_FreezeTemplate, FreezeCrustGuid, TRUE);
        return;
    }
    if (int(OwnerPawn.GetCurrentResistance()) != 0)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_FreezeTemplate, FreezeCrustGuid, TRUE);
        return;
    }
    else
    {
        Manager = OwnerPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            FreezeEffect = SFXGameEffect_CryoFreeze(Manager.CreateEffect(Class'SFXGameEffect_CryoFreeze', Category, EffectValue, 1, 1.0, Instigator));
            if (FreezeEffect != None)
            {
                FreezeEffect.__OnFrozenPawnDied__Delegate = OnFrozenPawnDied;
                FreezeEffect.FreezeCrustGuid = FreezeCrustGuid;
                FreezeEffect.OnApplied();
            }
            HoTDebuffEffect = SFXGameEffect_HealthRegenPenalty(Manager.CreateEffect(Class'SFXGameEffect_HealthRegenPenalty', Category, EffectValue, 1, 1.0, Instigator));
            if (HoTDebuffEffect != None)
            {
                HoTDebuffEffect.OnApplied();
            }
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    local RvrClientEffectTarget TargetInfo;
    
    Super.OnUpdate(DeltaSeconds);
    if (Duration > float(0))
    {
        Owner.CustomTimeDilation = FClamp(1.0 - CurrentTime / Duration, 0.0500000007, 1.0);
    }
    if (!bOwnerDied && OwnerPawn != None && OwnerPawn.IsDead())
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
    local RvrClientEffectTarget TargetInfo;
    local BioCustomAction Action;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        OwnerPawn.StopVocalization();
        if (OwnerPawn.GetCurrentCustomAction(Action))
        {
            if (SFXCustomAction_DamageReaction(Action) == None)
            {
                Duration = 0.0;
            }
        }
    }
    TargetInfo.Instigator = Owner;
    FreezeCrustGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_FreezeTemplate, TargetInfo);
    Owner.PlaySound(FreezingSound);
}
public delegate function OnFrozenPawnDied(BioPawn oPawn);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CE_DeathEffect = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Death_VCFX'
    CE_FreezeTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Freeze_VCFX'
    FrozenDeathSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cryo_explode'
    FreezingSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cryo_freeze'
    bPlayFrozenDeathSound = TRUE
    bPreventGibs = TRUE
    bPreventEatable = TRUE
}