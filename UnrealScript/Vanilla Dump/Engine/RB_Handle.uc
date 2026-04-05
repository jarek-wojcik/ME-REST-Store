Class RB_Handle extends ActorComponent
    native
    collapsecategories;

var const transient native Pointer HandleData;
var const transient native Pointer KinActorData;
var(RB_Handle) Vector LinearStiffnessScale3D;
var(RB_Handle) Vector LinearDampingScale3D;
var Vector Destination;
var Vector StepSize;
var Vector location;
var Name GrabbedBoneName;
var editinline export PrimitiveComponent GrabbedComponent;
var const transient native int SceneIndex;
var(RB_Handle) float LinearDamping;
var(RB_Handle) float LinearStiffness;
var(RB_Handle) float AngularDamping;
var(RB_Handle) float AngularStiffness;
var const transient native bool bInHardware;
var const transient native bool bRotationConstrained;
var bool bInterpolating;

public native function Quat GetOrientation();

public native function GrabComponent(PrimitiveComponent Component, Name InBoneName, Vector GrabLocation, bool bConstrainRotation);

public native function ReleaseComponent();

public native function SetLocation(Vector NewLocation);

public native function SetOrientation(const out Quat NewOrientation);

public native function SetSmoothLocation(Vector NewLocation, float MoveTime);

public native function UpdateSmoothLocation(const out Vector NewLocation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LinearStiffnessScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    LinearDampingScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    LinearDamping = 100.0
    LinearStiffness = 1300.0
    AngularDamping = 200.0
    AngularStiffness = 1000.0
    TickGroup = ETickingGroup.TG_PreAsyncWork
}