Class SFXGameEffect_WeaponWeightModifier extends SFXGameEffect;

var array<ELoadoutWeapons> WeaponClasses;

public function OnRemoved()
{
    local SFXPawn_Player Player;
    local int idx;
    
    Super.OnRemoved();
    Player = SFXPawn_Player(Owner);
    if (Player != None && WeaponClasses.Length > 0)
    {
        for (idx = 0; idx < WeaponClasses.Length; idx++)
        {
            Player.WeaponEncumbranceModifiers[int(WeaponClasses[idx])].Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(Player.WeaponEncumbranceModifiers[int(WeaponClasses[idx])]);
        }
        Player.UpdateWeaponEncumbrance();
    }
}
public function OnApplied()
{
    local SFXPawn_Player Player;
    local int idx;
    
    Super.OnApplied();
    Player = SFXPawn_Player(Owner);
    if (Player != None && WeaponClasses.Length > 0)
    {
        for (idx = 0; idx < WeaponClasses.Length; idx++)
        {
            Player.WeaponEncumbranceModifiers[int(WeaponClasses[idx])].Bonuses.AddItem(Self);
            Class'SFXGame'.static.ReCalculate(Player.WeaponEncumbranceModifiers[int(WeaponClasses[idx])]);
        }
        Player.UpdateWeaponEncumbrance();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}