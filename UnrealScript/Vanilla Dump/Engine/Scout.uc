Class Scout extends Pawn
    native
    transient
    config(Game);

struct native PathSizeInfo 
{
    var Name Desc;
    var float Radius;
    var float Height;
    var float CrouchHeight;
    var byte PathColor;
};

var array<PathSizeInfo> PathSizes;
var Class<ReachSpec> DefaultReachSpecClass;
var float TestJumpZ;
var float TestGroundSpeed;
var float TestMaxFallSpeed;
var float TestFallSpeed;
var const float MaxLandingVelocity;
var int MinNumPlayerStarts;
var float NavMeshGen_StepSize;
var float NavMeshGen_EntityHalfHeight;
var float NavMeshGen_StartingHeightOffset;
var float NavMeshGen_MaxDropHeight;
var float NavMeshGen_MaxStepHeight;
var float NavMeshGen_VertZDeltaSnapThresh;
var float NavMeshGen_MinPolyArea;
var float NavMeshGen_BorderBackfill_CheckDist;
var float NavMeshGen_MinMergeDotAreaThreshold;
var float NavMeshGen_MinMergeDotSmallArea;
var float NavMeshGen_MinMergeDotLargeArea;
var float NavMeshGen_MaxPolyHeight;
var float NavMeshGen_HeightMergeThreshold;
var float NavMeshGen_EdgeMaxDelta;
var float NavMeshGen_MaxGroundCheckSize;
var float NavMeshGen_MinEdgeLength;
var(Scout) bool bHightlightOneWayReachSpecs;

public event simulated function PreBeginPlay()
{
    if (bCollideActors)
    {
        SetCollision(FALSE, FALSE, );
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    PathSizes = ({Desc = 'Human', Radius = 48.0, Height = 80.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Common', Radius = 72.0, Height = 100.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Max', Radius = 120.0, Height = 120.0, CrouchHeight = 0.0, PathColor = 0}, 
                 {Desc = 'Vehicle', Radius = 260.0, Height = 120.0, CrouchHeight = 0.0, PathColor = 0}
                )
    DefaultReachSpecClass = Class'ReachSpec'
    TestJumpZ = 420.0
    TestGroundSpeed = 600.0
    TestMaxFallSpeed = 2500.0
    TestFallSpeed = 1200.0
    MinNumPlayerStarts = 1
    NavMeshGen_StepSize = 30.0
    NavMeshGen_EntityHalfHeight = 72.0
    NavMeshGen_StartingHeightOffset = 150.0
    NavMeshGen_MaxDropHeight = 60.0
    NavMeshGen_MaxStepHeight = 35.0
    NavMeshGen_VertZDeltaSnapThresh = 20.0
    NavMeshGen_MinPolyArea = 25.0
    NavMeshGen_BorderBackfill_CheckDist = 70.0
    NavMeshGen_MinMergeDotAreaThreshold = 2.0
    NavMeshGen_MinMergeDotLargeArea = 0.949999988
    NavMeshGen_MaxPolyHeight = 120.0
    NavMeshGen_HeightMergeThreshold = 10.0
    NavMeshGen_EdgeMaxDelta = 2.0
    NavMeshGen_MaxGroundCheckSize = 30.0
    NavMeshGen_MinEdgeLength = 25.0
    AccelRate = 1.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bCollideActors = FALSE
    bCollideWorld = FALSE
    bBlockActors = FALSE
    bProjTarget = FALSE
    bPathColliding = TRUE
    RemoteRole = ENetRole.ROLE_None
}