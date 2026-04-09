Class SFXGameEffect_LMGDamageTakenBonus extends SFXGameEffect
    config(Game);

var config float MaxDamageReduction;
var bool bIsActive;

public function OnRemoved()
{
    local SFXModule_Damage DmgModule;
    
    Super.OnRemoved();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            bIsActive = FALSE;
            DmgModule.DamageMultiplier.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.DamageMultiplier);
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    local BioPawn BP;
    local SFXModule_Damage DmgModule;
    
    Super.OnUpdate(DeltaSeconds);
    BP = BioPawn(Owner);
    DmgModule = Owner.GetModule(Class'SFXModule_Damage');
    if (DmgModule == None)
    {
        return;
    }
    if (BP.IsInCover())
    {
        if (!bIsActive)
        {
            if (DmgModule.DamageMultiplier.Value >= MaxDamageReduction)
            {
                return;
            }
            bIsActive = TRUE;
            DmgModule.DamageMultiplier.Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.DamageMultiplier);
        }
    }
    else if (bIsActive)
    {
        bIsActive = FALSE;
        DmgModule.DamageMultiplier.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(DmgModule.DamageMultiplier);
    }
    if (DmgModule.DamageMultiplier.Value < MaxDamageReduction + EffectValue && bIsActive)
    {
        bIsActive = FALSE;
        DmgModule.DamageMultiplier.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(DmgModule.DamageMultiplier);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxDamageReduction = -0.5
}