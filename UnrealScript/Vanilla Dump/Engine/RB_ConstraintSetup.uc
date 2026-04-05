Class RB_ConstraintSetup
    native;

struct native LinearDOFSetup 
{
    var(LinearDOFSetup) float LimitSize;
    var(LinearDOFSetup) byte bLimited;
    
    structdefaultproperties
    {
        bLimited = 1
    }
};

var Vector Pos1;
var Vector PriAxis1;
var Vector SecAxis1;
var Vector Pos2;
var Vector PriAxis2;
var Vector SecAxis2;
var Vector PulleyPivot1;
var Vector PulleyPivot2;
var(RB_ConstraintSetup) const Name JointName;
var(RB_ConstraintSetup) Name ConstraintBone1;
var(RB_ConstraintSetup) Name ConstraintBone2;
var(Linear) LinearDOFSetup LinearXSetup;
var(Linear) LinearDOFSetup LinearYSetup;
var(Linear) LinearDOFSetup LinearZSetup;
var(Linear) float LinearLimitStiffness;
var(Linear) float LinearLimitDamping;
var(Linear) float LinearBreakThreshold;
var(Angular) float Swing1LimitAngle;
var(Angular) float Swing2LimitAngle;
var(Angular) float TwistLimitAngle;
var(Angular) float SwingLimitStiffness;
var(Angular) float SwingLimitDamping;
var(Angular) float TwistLimitStiffness;
var(Angular) float TwistLimitDamping;
var(Angular) float AngularBreakThreshold;
var(Pulley) float PulleyRatio;
var(RB_ConstraintSetup) bool bEnableProjection;
var(Linear) bool bLinearLimitSoft;
var(Linear) bool bLinearBreakable;
var(Angular) bool bSwingLimited;
var(Angular) bool bTwistLimited;
var(Angular) bool bSwingLimitSoft;
var(Angular) bool bTwistLimitSoft;
var(Angular) bool bAngularBreakable;
var(Pulley) bool bIsPulley;
var(Pulley) bool bMaintainMinDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PriAxis1 = {X = 1.0, Y = 0.0, Z = 0.0}
    SecAxis1 = {X = 0.0, Y = 1.0, Z = 0.0}
    PriAxis2 = {X = 1.0, Y = 0.0, Z = 0.0}
    SecAxis2 = {X = 0.0, Y = 1.0, Z = 0.0}
    LinearXSetup = {LimitSize = 0.0, bLimited = 1}
    LinearYSetup = {LimitSize = 0.0, bLimited = 1}
    LinearZSetup = {LimitSize = 0.0, bLimited = 1}
    LinearBreakThreshold = 300.0
    AngularBreakThreshold = 500.0
    PulleyRatio = 1.0
}