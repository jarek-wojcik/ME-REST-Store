Class BioSquadCombat extends BioBaseSquadDesignCombat
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioSquadLinesComponent Name=SquadLines
        ReplacementPrimitive = None
    End Template
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Components = (None, SquadLines)
}