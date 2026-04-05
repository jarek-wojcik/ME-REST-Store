Class SFXNav_ForcedPathNode extends NavigationPoint
    native
    placeable;

var(SFXNav_ForcedPathNode) float m_fForcedRadius;
var(SFXNav_ForcedPathNode) float m_fForcedHeight;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_fForcedRadius = 34.0
    m_fForcedHeight = 100.0
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}