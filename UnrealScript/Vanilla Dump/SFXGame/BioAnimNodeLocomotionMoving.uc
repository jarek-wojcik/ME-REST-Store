Class BioAnimNodeLocomotionMoving extends AnimNodeBlendBase
    native;

enum EBioAnimNodeLocomotionMoving
{
    eBioAnimNodeLocomotionMoving_Fwd,
    eBioAnimNodeLocomotionMoving_LeanLeft,
    eBioAnimNodeLocomotionMoving_LeanRight,
    eBioAnimNodeLocomotionMoving_Ascend,
    eBioAnimNodeLocomotionMoving_Descend,
};

var(BioAnimNodeLocomotionMoving) const Name SynchGroupName;
var(BioAnimNodeLocomotionMoving) const float BlendSpeed;
var(BioAnimNodeLocomotionMoving) const float BlendSpeedLeanIn;
var(BioAnimNodeLocomotionMoving) const float BlendSpeedLeanOut;
var(BioAnimNodeLocomotionMoving) const float AngleLeanLeft;
var(BioAnimNodeLocomotionMoving) const float AngleLeanRight;
var(BioAnimNodeLocomotionMoving) const float AngleAscend;
var(BioAnimNodeLocomotionMoving) const float AngleDescend;
var(BioAnimNodeLocomotionMoving) const float MinSpeed;
var(BioAnimNodeLocomotionMoving) const float MidSpeed;
var(BioAnimNodeLocomotionMoving) const float MaxSpeed;
var transient BioAnimMovementSync MovementSync;
var transient float Lean;
var transient float Incline;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendSpeed = 10.0
    BlendSpeedLeanIn = 10.0
    BlendSpeedLeanOut = 50.0
    AngleLeanLeft = 45.0
    AngleLeanRight = 45.0
    AngleAscend = 30.0
    AngleDescend = 30.0
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Fwd', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'LeanLeft', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'LeanRight', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Ascend', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Descend', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeLocomotionMoving'
}