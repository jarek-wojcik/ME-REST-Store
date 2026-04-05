Class CoverSlotMarker extends NavigationPoint
    native;

var(CoverSlotMarker) editconst CoverInfo OwningSlot;
var bool bLastChoice;
var transient bool bIgnoreSizeLimits;

public event simulated function string GetDebugAbbrev()
{
    return "CSM";
}
public final event simulated function string GetDebugString()
{
    return OwningSlot.Link.GetDebugString(OwningSlot.SlotIdx);
}
public simulated native function Vector GetSlotLocation();

public simulated native function Rotator GetSlotRotation();

public final native function bool IsValidClaim(Pawn ChkClaim, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck);

public simulated native function SetSlotEnabled(bool bEnable);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 40.0
        CollisionRadius = 40.0
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    Components = (None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bCollideWhenPlacing = FALSE
}