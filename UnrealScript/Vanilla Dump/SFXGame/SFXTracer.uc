Class SFXTracer extends Actor
    native
    transient;

enum ESFXTracerState
{
    eSFXTracerState_Idle,
    eSFXTracerState_ScaleUp,
    eSFXTracerState_ScaleDown,
};

var Vector MeshScale;
var Vector DesiredEndPoint;
var Vector StartPoint;
var float MeshScaleTime;
var float Speed;
var float MaxSpeed;
var float TrailWaitTime;
var editinline export StaticMeshComponent Mesh;
var editinline export ParticleSystemComponent Trail;
var float ScaleTimeFactor;
var float UnscaledMeshLength;
var float ScaleTimeCount;
var float Lifetime;
var ESFXTracerState ActiveState;

public simulated function FellOutOfWorld(Class<DamageType> dmgType);

public final native function InitTracer(Vector Start, Vector End, Vector DesiredScale, float DesiredSpeed);

public simulated function OutsideWorldBounds()
{
    Recycle();
}
public final native function Recycle();

public function Reset()
{
    Recycle();
}
public final native function Reuse();

public simulated function ShutDown()
{
    StopTracer();
}
private final native function StopTracer();

public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        bUseAsOccluder = FALSE
        CastShadow = FALSE
        bCastDynamicShadow = FALSE
        bAcceptsLights = FALSE
        bAcceptsDynamicLights = FALSE
        CollideActors = FALSE
        BlockActors = FALSE
        BlockZeroExtent = FALSE
        BlockNonZeroExtent = FALSE
        BlockRigidBody = FALSE
        bDisableAllRigidBody = TRUE
    End Object
    Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        bAutoActivate = FALSE
        bUpdateComponentInTick = TRUE
        ReplacementPrimitive = None
    End Object
    MeshScale = {X = 1.0, Y = 1.0, Z = 1.0}
    MeshScaleTime = 0.0500000007
    Speed = 28000.0
    MaxSpeed = 30000.0
    TrailWaitTime = 3.0
    Mesh = StaticMeshComponent0
    Trail = ParticleSystemComponent0
    Components = (StaticMeshComponent0, ParticleSystemComponent0)
    DrawScale3D = {X = 2.0, Y = 1.0, Z = 1.0}
    bNetTemporary = TRUE
    bNetInitialRotation = TRUE
    bNoEncroachCheck = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}