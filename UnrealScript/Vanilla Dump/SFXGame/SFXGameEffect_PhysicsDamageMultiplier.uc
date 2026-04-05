Class SFXGameEffect_PhysicsDamageMultiplier extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').PhysicsDamageTakenBonus.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').PhysicsDamageTakenBonus);
    }
}
public function OnApplied()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').PhysicsDamageTakenBonus.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').PhysicsDamageTakenBonus);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}