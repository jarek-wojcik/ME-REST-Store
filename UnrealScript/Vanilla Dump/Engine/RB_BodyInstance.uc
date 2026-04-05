Class RB_BodyInstance
    native;

var const editinline transient export PrimitiveComponent OwnerComponent;
var const native Pointer BodyData;
var const native Pointer BoneSpring;
var const native Pointer BoneSpringKinActor;
var Vector Velocity;
var Vector PreviousVelocity;
var const sortbarrier int BodyIndex;
var const native int SceneIndex;
var(BoneSpring) const float BoneLinearSpring;
var(BoneSpring) const float BoneLinearDamping;
var(BoneSpring) const float BoneAngularSpring;
var(BoneSpring) const float BoneAngularDamping;
var(BoneSpring) float OverextensionThreshold;
var(RB_BodyInstance) float CustomGravityFactor;
var transient float LastEffectPlayedTime;
var(BoneSpring) bool bEnableBoneSpringLinear;
var(BoneSpring) bool bEnableBoneSpringAngular;
var(BoneSpring) bool bDisableOnOverextension;
var(BoneSpring) bool bNotifyOwnerOnOverextension;
var(BoneSpring) bool bTeleportOnOverextension;
var(BoneSpring) bool bUseKinActorForBoneSpring;
var(BoneSpring) bool bMakeSpringToBaseCollisionComponent;
var(Physics) const bool bOnlyCollideWithPawns;
var(Physics) const bool bEnableCollisionResponse;
var(Physics) const bool bPushBody;
var(Physics) const sortbarrier PhysicalMaterial PhysMaterialOverride;
var(Physics) float ContactReportForceThreshold;
var(Physics) float InstanceMassScale;
var(Physics) float InstanceDampingScale;
var transient bool bForceUnfixed;
var transient bool bInstanceAlwaysFullAnimWeight;

public final native function EnableBoneSpring(bool bInEnableLinear, bool bInEnableAngular, const out Matrix InBoneTarget);

public final native function EnableCollisionResponse(bool bEnableResponse);

public final native function float GetBodyMass();

public final native function PhysicsAssetInstance GetPhysicsAssetInstance();

public final native function Vector GetUnrealWorldAngularVelocity();

public final native function Matrix GetUnrealWorldTM();

public final native function Vector GetUnrealWorldVelocity();

public final native function Vector GetUnrealWorldVelocityAtPoint(Vector Point);

public final native function bool IsFixed();

public final native function bool IsValidBodyInstance();

public final native function SetBlockRigidBody(bool bNewBlockRigidBody);

public final native function SetBoneSpringParams(float InLinearSpring, float InLinearDamping, float InAngularSpring, float InAngularDamping);

public final native function SetBoneSpringTarget(const out Matrix InBoneTarget, bool bTeleport);

public final native function SetContactReportForceThreshold(float Threshold);

public final native function SetFixed(bool bNewFixed);

public final native function SetPhysMaterialOverride(PhysicalMaterial NewPhysMaterial);

public final native function UpdateDampingProperties();

public final native function UpdateMassProperties(RB_BodySetup Setup);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BoneLinearSpring = 10.0
    BoneLinearDamping = 0.100000001
    BoneAngularSpring = 1.0
    BoneAngularDamping = 0.100000001
    CustomGravityFactor = 1.0
    bEnableCollisionResponse = TRUE
    ContactReportForceThreshold = -1.0
    InstanceMassScale = 1.0
    InstanceDampingScale = 1.0
}