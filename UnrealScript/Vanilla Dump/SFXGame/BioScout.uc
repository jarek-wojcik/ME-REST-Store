Class BioScout extends Scout
    native
    transient
    config(Game);

var config bool m_bAggressivePathPruning;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_bAggressivePathPruning = TRUE
    PathSizes = ({Desc = 'Common', Radius = 34.0, Height = 90.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Large', Radius = 40.0, Height = 95.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'VeryLarge', Radius = 105.0, Height = 145.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Max', Radius = 135.0, Height = 146.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Vehicle', Radius = 140.0, Height = 195.0, CrouchHeight = 0.0, PathColor = 0}
                )
    TestJumpZ = 1000.0
    bHightlightOneWayReachSpecs = TRUE
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}