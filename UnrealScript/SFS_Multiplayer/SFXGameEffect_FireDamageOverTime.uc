Class SFXGameEffect_FireDamageOverTime extends SFXGameEffect_DamageOverTime;

var float TotalDamageDone;
var float PowerComboDamageThreshold;
var clearcrosslevel SFXPowerCustomAction ComboPower;
var bool bComboEffectApplied;
var bool bCanCauseCombo;

public function DoDamage()
{
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local Actor oTarget;
    local Vector HitNormal;
    local Vector Force;
    local float fDamage;
    local BioPawn oTargetPawn;
    
    if (Owner != None)
    {
        oTarget = Owner;
        HitNormal = Vector(oTarget.Rotation);
        Force = vect(0.0, 0.0, 0.0);
        fDamage = EffectValue * DamageInterval;
        TotalDamageDone += fDamage;
        Resistance = oTarget.GetPowerResistance(None, oTarget.location, HitNormal, fDamage, Force, DamageType, oTargetOverride);
        if (oTargetOverride != None)
        {
            oTarget = oTargetOverride;
        }
        oTargetPawn = BioPawn(oTarget);
        if (oTarget.ImpactWithPower(Resistance, Instigator != None ? Instigator.Pawn : None, oTarget.location, HitNormal, fDamage, Force, DamageType))
        {
            if (oTargetPawn != None)
            {
                oTargetPawn.ReplicateAnimatedReaction(oTargetPawn.CurrentCustomAction);
            }
        }
        if (bCanCauseCombo && TotalDamageDone > PowerComboDamageThreshold && !bComboEffectApplied && ComboPower != None && oTargetPawn != None && oTargetPawn.HasAnyShieldResistance() == FALSE && Resistance != EPowerResistance.Resistance_Full)
        {
            bComboEffectApplied = TRUE;
            ComboPower.AddComboEffect(Owner, Class'SFXGameEffect_PowerCombo_Fire', Duration - CurrentTime);
        }
    }
}
public function OnApplied()
{
    local BioPlayerController PC;
    local BioPawn Target;
    
    Super.OnApplied();
    Target = BioPawn(Owner);
    if (Target != None && Target.bAchievementFireGranted == FALSE)
    {
        PC = BioPlayerController(CheckOwnerInstigator(Instigator));
        if (PC != None)
        {
            PC.UpdateAccomplishmentProgression('ONFIRECOUNT');
            Target.bAchievementFireGranted = TRUE;
        }
    }
}
public function AddFireDamage(float AddedDamage, float NewDuration)
{
    local SFXGameEffect_PowerCombo_Fire ComboEffect;
    local SFXModule_GameEffectManager Manager;
    
    if (AddedDamage > float(0) && NewDuration > float(0))
    {
        EffectValue = EffectValue * (Duration - CurrentTime) / NewDuration + AddedDamage;
        Duration = NewDuration;
        CurrentTime = 0.0;
        if (bComboEffectApplied && ComboPower != None)
        {
            Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                ComboEffect = SFXGameEffect_PowerCombo_Fire(Manager.GetFirstEffectOfTypeAndCategory(Class'SFXGameEffect_PowerCombo_Fire', ComboPower.Name));
                if (ComboEffect != None)
                {
                    ComboEffect.CurrentTime = 0.0;
                    ComboEffect.Duration = NewDuration;
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PowerComboDamageThreshold = 30.0
    bCanCauseCombo = TRUE
    DamageType = Class'SFXDamageType_Power_Fire'
}