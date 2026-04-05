Class SFXGameEffect_ArmorWeakness extends SFXGameEffect;

public function OnRemoved()
{
    local SFXModule_Damage DmgModule;
    
    Super.OnRemoved();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            DmgModule.AIArmorDamageReduction.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.AIArmorDamageReduction);
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
            DmgModule.AIArmorDamageReduction.Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(DmgModule.AIArmorDamageReduction);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}