Class SFXStealthVolume extends Volume
    placeable;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local BioPawn BP;
    local Pawn SquadMember;
    
    BP = BioPawn(Other);
    if (BP != None && BP.IsPlayerOwned())
    {
        BP.bInStealthVolume = TRUE;
        if (BP.Squad != None)
        {
            foreach BP.Squad.Members(SquadMember, )
            {
                BioPawn(SquadMember).bInStealthVolume = TRUE;
            }
        }
    }
    Super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
}
public event function UnTouch(Actor Other)
{
    local BioPawn BP;
    local Pawn SquadMember;
    
    BP = BioPawn(Other);
    if (BP != None && BP.IsPlayerOwned())
    {
        BP.bInStealthVolume = FALSE;
        if (BP.Squad != None)
        {
            foreach BP.Squad.Members(SquadMember, )
            {
                BioPawn(SquadMember).bInStealthVolume = FALSE;
            }
        }
    }
    Super(Actor).UnTouch(Other);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
}