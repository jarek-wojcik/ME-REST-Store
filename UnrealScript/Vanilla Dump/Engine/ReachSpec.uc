Class ReachSpec
    native;

const BLOCKEDPATHCOST = 10000000;

var const editconst transient native Pointer NavOctreeObject;
var(ReachSpec) const editconst ActorReference End;
var Vector Direction;
var int Distance;
var(ReachSpec) const editconst NavigationPoint Start;
var(ReachSpec) const editconst int CollisionRadius;
var(ReachSpec) const editconst int CollisionHeight;
var int reachFlags;
var int MaxLandingVelocity;
var Actor BlockedBy;
var int m_nBlockedCount;
var const editconst bool bAddToNavigationOctree;
var bool bCanCutCorners;
var bool bCheckForObstructions;
var const bool bSkipPrune;
var const bool bIsMantle;
var(ReachSpec) editconst bool bDisabled;
var byte bPruned;
var byte PathColorIndex;

public final native function int CostFor(Pawn P);

public final native function Vector GetDirection();

public final native function NavigationPoint GetEnd();

public native function bool IsBlocked();

public function bool IsBlockedFor(Pawn P)
{
    return CostFor(P) >= 10000000;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAddToNavigationOctree = TRUE
    bCanCutCorners = TRUE
    bCheckForObstructions = TRUE
}