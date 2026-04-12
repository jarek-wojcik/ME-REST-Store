Class SFXGameEffect_WeightCapacity extends SFXGameEffect;

public function OnRemoved()
{
    local SFXPawn_Player Player;
    
    Super.OnRemoved();
    Player = SFXPawn_Player(Owner);
    if (Player != None)
    {
        Player.RemoveWeaponEncumbranceBonus(Self);
    }
}
public function OnApplied()
{
    local SFXPawn_Player Player;
    
    Super.OnApplied();
    Player = SFXPawn_Player(Owner);
    if (Player != None)
    {
        Player.AddWeaponEncumbranceBonus(Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}