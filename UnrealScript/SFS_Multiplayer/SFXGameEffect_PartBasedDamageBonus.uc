Class SFXGameEffect_PartBasedDamageBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveConstraintDamageBonus.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveConstraintDamageBonus);
    }
}
public function OnApplied()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveConstraintDamageBonus.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveConstraintDamageBonus);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}