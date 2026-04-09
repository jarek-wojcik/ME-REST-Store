Class SFXGameEffect_StopShieldRegen extends SFXGameEffect;

var BioPawn Pawn;
var SFXShield_Base Shield;

public function OnUpdate(float DeltaSeconds)
{
    Super.OnUpdate(DeltaSeconds);
    if (Shield != None)
    {
        Shield.ResetShieldRegenTimer();
    }
}
public function OnApplied()
{
    Super.OnApplied();
    Pawn = BioPawn(Owner);
    if (Pawn != None)
    {
        Shield = Pawn.GetShields();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}