Class RB_ConstraintInstance
    native;

var const transient Actor Owner;
var(Angular) const Quat AngularPositionTarget;
var const native Pointer ConstraintData;
var(Linear) const Vector LinearPositionTarget;
var(Linear) const Vector LinearVelocityTarget;
var(Angular) const Vector AngularVelocityTarget;
var const editinline transient export sortbarrier PrimitiveComponent OwnerComponent;
var const int ConstraintIndex;
var const native int SceneIndex;
var(Linear) const float LinearDriveSpring;
var(Linear) const float LinearDriveDamping;
var(Linear) const float LinearDriveForceLimit;
var(Angular) const float AngularDriveSpring;
var(Angular) const float AngularDriveDamping;
var(Angular) const float AngularDriveForceLimit;
var const native bool bInHardware;
var(Linear) const bool bLinearXPositionDrive;
var(Linear) const bool bLinearXVelocityDrive;
var(Linear) const bool bLinearYPositionDrive;
var(Linear) const bool bLinearYVelocityDrive;
var(Linear) const bool bLinearZPositionDrive;
var(Linear) const bool bLinearZVelocityDrive;
var(Angular) const bool bSwingPositionDrive;
var(Angular) const bool bSwingVelocityDrive;
var(Angular) const bool bTwistPositionDrive;
var(Angular) const bool bTwistVelocityDrive;
var(Angular) const bool bAngularSlerpDrive;
var bool bTerminated;
var const native sortbarrier Pointer DummyKinActor;

public final native function Vector GetConstraintLocation();

public final native function PhysicsAssetInstance GetPhysicsAssetInstance();

public final native function InitConstraint(PrimitiveComponent PrimComp1, PrimitiveComponent PrimComp2, RB_ConstraintSetup Setup, float Scale, Actor InOwner, PrimitiveComponent InPrimComp, bool bMakeKinForBody1);

public final native function MoveKinActorTransform(out Matrix NewTM);

public final native function SetAngularDOFLimitScale(float InSwing1LimitScale, float InSwing2LimitScale, float InTwistLimitScale, RB_ConstraintSetup InSetup);

public final native function SetAngularDriveParams(float InSpring, float InDamping, float InForceLimit);

public final native function SetAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive);

public final native function SetAngularPositionTarget(const out Quat InPosTarget);

public final native function SetAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive);

public final native function SetAngularVelocityTarget(Vector InVelTarget);

public final native function SetLinearDriveParams(float InSpring, float InDamping, float InForceLimit);

public final native function SetLinearLimitSize(float NewLimitSize);

public final native function SetLinearPositionDrive(bool bEnableXDrive, bool bEnableYDrive, bool bEnableZDrive);

public final native function SetLinearPositionTarget(Vector InPosTarget);

public final native function SetLinearVelocityDrive(bool bEnableXDrive, bool bEnableYDrive, bool bEnableZDrive);

public final native function SetLinearVelocityTarget(Vector InVelTarget);

public final native function TermConstraint();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AngularPositionTarget = {X = 0.0, Y = 0.0, Z = 0.0, W = 1.0}
    LinearDriveSpring = 50.0
    LinearDriveDamping = 1.0
    AngularDriveSpring = 50.0
    AngularDriveDamping = 1.0
}