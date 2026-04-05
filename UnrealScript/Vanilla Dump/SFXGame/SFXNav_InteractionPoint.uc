Class SFXNav_InteractionPoint extends PathNode
    placeable
    abstract;

var int InteractionCustomActionID;
var(InteractionAnim) SFXAnimSetCookSpec AnimInfo;
var(InteractionAnim) SFXAnimSetCookSpec PistolAnimInfo;
var(InteractionPoint) bool bPreciseLocation;
var(InteractionPoint) bool bPreciseRotation;
var(InteractionPoint) bool bModifyPerception;

public function bool StartInteraction(BioPawn oPawn)
{
    if (oPawn != None)
    {
        if (oPawn.CanDoCustomAction(InteractionCustomActionID))
        {
            return oPawn.StartCustomAction(InteractionCustomActionID);
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    bModifyPerception = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    CollisionComponent = CollisionCylinder
}