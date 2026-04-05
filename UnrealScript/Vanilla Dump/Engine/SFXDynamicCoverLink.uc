Class SFXDynamicCoverLink extends CoverLink
    native
    placeable
    config(Game);

var(SFXDynamicCoverLink) Actor m_aContainingActor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bBlocked = TRUE
    bNotBased = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bCollideWhenPlacing = FALSE
}