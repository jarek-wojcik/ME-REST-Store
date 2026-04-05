Class NxGenericForceFieldBrush extends Volume
    native
    placeable;

enum FFB_ForceFieldCoordinates
{
    FFB_CARTESIAN,
    FFB_SPHERICAL,
    FFB_CYLINDRICAL,
    FFB_TOROIDAL,
};

var const transient native array<Pointer> ConvexMeshes;
var const transient native array<Pointer> ExclusionShapes;
var const transient native array<Pointer> ExclusionShapePoses;
var const transient native Pointer ForceField;
var const transient native Pointer LinearKernel;
var(NxGenericForceFieldBrush) Vector Constant;
var(NxGenericForceFieldBrush) Vector PositionMultiplierX;
var(NxGenericForceFieldBrush) Vector PositionMultiplierY;
var(NxGenericForceFieldBrush) Vector PositionMultiplierZ;
var(NxGenericForceFieldBrush) Vector PositionTarget;
var(NxGenericForceFieldBrush) Vector VelocityMultiplierX;
var(NxGenericForceFieldBrush) Vector VelocityMultiplierY;
var(NxGenericForceFieldBrush) Vector VelocityMultiplierZ;
var(NxGenericForceFieldBrush) Vector VelocityTarget;
var(NxGenericForceFieldBrush) Vector Noise;
var(NxGenericForceFieldBrush) Vector FalloffLinear;
var(NxGenericForceFieldBrush) Vector FalloffQuadratic;
var(NxGenericForceFieldBrush) int ExcludeChannel;
var(NxGenericForceFieldBrush) RBCollisionChannelContainer CollideWithChannels;
var(NxGenericForceFieldBrush) float TorusRadius;
var(NxGenericForceFieldBrush) const ERBCollisionChannel RBChannel;
var(NxGenericForceFieldBrush) FFB_ForceFieldCoordinates Coordinates;

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (BrushComponent != None)
    {
        bProjTarget = BrushComponent.BlockZeroExtent;
    }
}
public simulated function bool StopsProjectile(Projectile P)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        bDisableAllRigidBody = FALSE
    End Template
    ExcludeChannel = 1
    CollideWithChannels = {
                           Default = TRUE, 
                           Nothing = FALSE, 
                           Pawn = TRUE, 
                           Vehicle = TRUE, 
                           Water = TRUE, 
                           GameplayPhysics = TRUE, 
                           EffectPhysics = TRUE, 
                           Untitled1 = TRUE, 
                           Untitled2 = TRUE, 
                           Untitled3 = TRUE, 
                           Untitled4 = FALSE, 
                           Cloth = TRUE, 
                           FluidDrain = TRUE, 
                           SoftBody = TRUE, 
                           FracturedMeshPart = FALSE, 
                           BlockingVolume = FALSE, 
                           DeadPawn = FALSE
                          }
    TorusRadius = 1.0
    RBChannel = ERBCollisionChannel.RBCC_Untitled1
    BrushColor = {B = 100, G = 255, R = 100, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
    bProjTarget = TRUE
}