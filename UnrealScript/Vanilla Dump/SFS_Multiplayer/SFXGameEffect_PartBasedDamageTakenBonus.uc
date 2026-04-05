Class SFXGameEffect_PartBasedDamageTakenBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXModule_Damage DmgModule;
    
    Super.OnRemoved();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            DmgModule.PartBasedDamageMultiplier.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.PartBasedDamageMultiplier);
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
            DmgModule.PartBasedDamageMultiplier.Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.PartBasedDamageMultiplier);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}