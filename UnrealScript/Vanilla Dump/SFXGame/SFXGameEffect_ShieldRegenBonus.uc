Class SFXGameEffect_ShieldRegenBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn OwnerPawn;
    local SFXShield_Base Shields;
    
    Super.OnRemoved();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        Shields = OwnerPawn.GetShields();
        if (Shields != None)
        {
            Shields.ShieldRegenDelay.Bonuses.RemoveItem(Self);
            Shields.ScaleShields();
        }
    }
}
public function OnApplied()
{
    local BioPawn OwnerPawn;
    local SFXShield_Base Shields;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        Shields = OwnerPawn.GetShields();
        if (Shields != None)
        {
            Shields.ShieldRegenDelay.Bonuses.AddItem(Self);
            Shields.ScaleShields();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}