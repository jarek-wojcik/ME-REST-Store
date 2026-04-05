Class BioPlaypenVolume extends Volume
    native;

var(BioPlaypenVolume) const editconst duplicatetransient Guid PlaypenGuid;
var bool bSubtractive;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    bConsiderWhilePathBuilding = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bForceAllowKismetModification = TRUE
}