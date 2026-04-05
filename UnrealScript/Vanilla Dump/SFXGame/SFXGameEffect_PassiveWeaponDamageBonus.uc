Class SFXGameEffect_PassiveWeaponDamageBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveDamageBonus.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveDamageBonus);
    }
}
public function OnApplied()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveDamageBonus.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').WeaponPassiveDamageBonus);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}