Class SFXNav_InteractionHenchCustom extends SFXNav_InteractionPoint
    placeable;

var(InteractionAnim) Name StartAnim;
var(InteractionAnim) Name LoopAnim;
var(InteractionAnim) Name EndAnim;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    InteractionCustomActionID = 198
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    CollisionComponent = CollisionCylinder
}