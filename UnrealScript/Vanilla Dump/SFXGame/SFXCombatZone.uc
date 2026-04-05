Class SFXCombatZone extends Volume
    native
    placeable;

var(SFXCombatZone) const editconst duplicatetransient Guid CombatZoneGuid;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushColor = {B = 0, G = 140, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bForceAllowKismetModification = TRUE
}