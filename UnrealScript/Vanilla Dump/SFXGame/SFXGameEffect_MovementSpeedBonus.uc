Class SFXGameEffect_MovementSpeedBonus extends SFXGameEffect;

var transient float OriginalDesiredSpeed;

public function OnRemoved()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None)
    {
        BP.DesiredSpeedMultiplier.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.DesiredSpeedMultiplier);
        BP.SetDesiredSpeed(OriginalDesiredSpeed);
    }
}
public function OnApplied()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None)
    {
        OriginalDesiredSpeed = BP.DesiredSpeed;
        BP.DesiredSpeedMultiplier.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.DesiredSpeedMultiplier);
        BP.SetDesiredSpeed(OriginalDesiredSpeed);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}