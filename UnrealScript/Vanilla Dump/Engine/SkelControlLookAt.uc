Class SkelControlLookAt extends SkelControlBase
    native;

var(LookAt) Vector TargetLocation;
var Vector DesiredTargetLocation;
var const transient Vector LimitLookDir;
var const transient Vector BaseLookDir;
var const transient Vector BaseBonePos;
var(LookAt) Name TargetSpaceBoneName;
var(Limit) Name AllowRotationOtherBoneName;
var(LookAt) float TargetLocationInterpSpeed;
var(Limit) float MaxAngle;
var(Limit) float OuterMaxAngle;
var(Limit) float DeadZoneAngle;
var const transient float LookAtAlpha;
var const transient float LookAtAlphaTarget;
var const transient float LookAtAlphaBlendTimeToGo;
var const transient float LastCalcTime;
var(LookAt) bool bInvertLookAtAxis;
var(LookAt) bool bDefineUpAxis;
var(LookAt) bool bInvertUpAxis;
var(Limit) bool bEnableLimit;
var(Limit) bool bLimitBasedOnRefPose;
var(Limit) bool bDisableBeyondLimit;
var(Limit) bool bNotifyBeyondLimit;
var(Limit) bool bShowLimit;
var(Limit) bool bAllowRotationX;
var(Limit) bool bAllowRotationY;
var(Limit) bool bAllowRotationZ;
var(LookAt) EBoneControlSpace TargetLocationSpace;
var(LookAt) EAxis LookAtAxis;
var(LookAt) EAxis UpAxis;
var(Limit) EBoneControlSpace AllowRotationSpace;

public final native function bool CanLookAtPoint(Vector PointLoc, optional bool bDrawDebugInfo, optional bool bDebugUsePersistentLines, optional bool bDebugFlushLinesFirst);

public final native function InterpolateTargetLocation(float DeltaTime);

public final native function SetLookAtAlpha(float DesiredAlpha, float DesiredBlendTime);

public final native function SetTargetLocation(Vector NewTargetLocation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TargetLocationInterpSpeed = 10.0
    OuterMaxAngle = 90.0
    LookAtAlpha = 1.0
    LookAtAlphaTarget = 1.0
    bLimitBasedOnRefPose = TRUE
    bShowLimit = TRUE
    bAllowRotationX = TRUE
    bAllowRotationY = TRUE
    bAllowRotationZ = TRUE
    LookAtAxis = EAxis.AXIS_X
    UpAxis = EAxis.AXIS_Z
    AllowRotationSpace = EBoneControlSpace.BCS_BoneSpace
    bIgnoreWhenNotRendered = TRUE
}