Class SFXGameEffect_MaxGrenadeBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn BP;
    local SFXInventoryManager Inv;
    
    Super.OnRemoved();
    BP = BioPawn(Owner);
    if (BP != None)
    {
        Inv = SFXInventoryManager(BP.InvManager);
        if (Inv != None)
        {
            Inv.MaxGrenadeBonus.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(Inv.MaxGrenadeBonus);
        }
    }
}
public function OnApplied()
{
    local BioPawn BP;
    local SFXInventoryManager Inv;
    
    Super.OnApplied();
    BP = BioPawn(Owner);
    if (BP != None)
    {
        Inv = SFXInventoryManager(BP.InvManager);
        if (Inv != None)
        {
            Inv.MaxGrenadeBonus.Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(Inv.MaxGrenadeBonus);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}