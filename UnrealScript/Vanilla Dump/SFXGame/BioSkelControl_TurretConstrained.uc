Class BioSkelControl_TurretConstrained extends SkelControlSingleBone
    native;

struct native TurretConstraintData 
{
    var(TurretConstraintData) int PitchConstraint;
    var(TurretConstraintData) int YawConstraint;
    var(TurretConstraintData) int RollConstraint;
};

var(Constraint) TurretConstraintData MaxAngle;
var(Constraint) TurretConstraintData MinAngle;
var(Turret) Rotator DesiredBoneRotation;
var(Turret) float LagDegreesPerSecond;
var(Turret) float m_fLagScale;
var(Constraint) bool bConstrainPitch;
var(Constraint) bool bConstrainYaw;
var(Constraint) bool bConstrainRoll;
var(Constraint) bool bInvertPitch;
var(Constraint) bool bInvertYaw;
var(Constraint) bool bInvertRoll;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LagDegreesPerSecond = 360.0
    m_fLagScale = 1.0
    bApplyRotation = TRUE
    BoneRotationSpace = EBoneControlSpace.BCS_ActorSpace
}