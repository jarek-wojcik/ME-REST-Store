Class SFXGameEffect_BioticPowerDamageTakenBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXModule_Damage DmgModule;
    
    Super.OnRemoved();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            DmgModule.BioticPowerDamageTakenMultiplier.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.BioticPowerDamageTakenMultiplier);
        }
    }
}
public function OnApplied()
{
    local SFXModule_Damage DmgModule;
    
    Super.OnApplied();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            DmgModule.BioticPowerDamageTakenMultiplier.Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.BioticPowerDamageTakenMultiplier);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}