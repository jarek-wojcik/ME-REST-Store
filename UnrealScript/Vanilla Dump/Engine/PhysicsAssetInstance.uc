Class PhysicsAssetInstance
    native;

var const native Map_Mirror CollisionDisableTable;
var const export array<RB_BodyInstance> Bodies;
var const export array<RB_ConstraintInstance> Constraints;
var const transient Actor Owner;
var const transient int RootBodyIndex;
var const float LinearSpringScale;
var const float LinearDampingScale;
var const float LinearForceLimitScale;
var const float AngularSpringScale;
var const float AngularDampingScale;
var const float AngularForceLimitScale;
var const bool bInitBodies;
var bool bHasFixedBody;

public final native function RB_BodyInstance FindBodyInstance(Name BodyName, PhysicsAsset InAsset);

public final native function RB_ConstraintInstance FindConstraintInstance(Name ConName, PhysicsAsset InAsset);

public final native function ForceAllBodiesBelowUnfixed(const out Name InBoneName, PhysicsAsset InAsset, SkeletalMeshComponent InSkelMesh, bool InbInstanceAlwaysFullAnimWeight);

public final native function float GetTotalMassBelowBone(Name InBoneName, PhysicsAsset InAsset, SkeletalMesh InSkelMesh);

public final native function SetAllBodiesFixed(bool bNewFixed);

public final native function SetAllMotorsAngularDriveParams(float InSpring, float InDamping, float InForceLimit, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies);

public final native function SetAllMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies);

public final native function SetAllMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, SkeletalMeshComponent SkelMeshComp, optional bool bSkipFullAnimWeightBodies);

public final native function SetAngularDriveScale(float InAngularSpringScale, float InAngularDampingScale, float InAngularForceLimitScale);

public final native function SetFullAnimWeightBlockRigidBody(bool bNewBlockRigidBody, SkeletalMeshComponent SkelMesh);

public final native function SetFullAnimWeightBonesFixed(bool bNewFixed, SkeletalMeshComponent SkelMesh);

public final native function SetLinearDriveScale(float InLinearSpringScale, float InLinearDampingScale, float InLinearForceLimitScale);

public final native function SetNamedBodiesBlockRigidBody(bool bNewBlockRigidBody, array<Name> BoneNames, SkeletalMeshComponent SkelMesh);

public final native function SetNamedBodiesFixed(bool bNewFixed, array<Name> BoneNames, SkeletalMeshComponent SkelMesh, optional bool bSetOtherBodiesToComplement, optional bool bSkipFullAnimWeightBodies);

public final native function SetNamedMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<Name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement);

public final native function SetNamedMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<Name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement);

public final native function SetNamedRBBoneSprings(bool bEnable, array<Name> BoneNames, float InBoneLinearSpring, float InBoneAngularSpring, SkeletalMeshComponent SkelMeshComp);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LinearSpringScale = 1.0
    LinearDampingScale = 1.0
    LinearForceLimitScale = 1.0
    AngularSpringScale = 1.0
    AngularDampingScale = 1.0
    AngularForceLimitScale = 1.0
    bInitBodies = TRUE
}