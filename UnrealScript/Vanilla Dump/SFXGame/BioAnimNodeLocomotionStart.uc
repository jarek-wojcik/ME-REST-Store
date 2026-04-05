Class BioAnimNodeLocomotionStart extends AnimNodeBlendBase
    native;

enum EBioAnimNodeLocomotionStart
{
    eBioAnimNodeLocomotionStart_ForwardRight,
    eBioAnimNodeLocomotionStart_ForwardLeft,
    eBioAnimNodeLocomotionStart_Right,
    eBioAnimNodeLocomotionStart_Left,
    eBioAnimNodeLocomotionStart_BackwardRight,
    eBioAnimNodeLocomotionStart_BackwardLeft,
};

var(BioAnimNodeLocomotionStart) const float BlendOutRelPos[6];
var(BioAnimNodeLocomotionStart) const float FreeRotationRelPos[6];
var(BioAnimNodeLocomotionStart) const Name SynchGroupName;
var(BioAnimNodeLocomotionStart) const float LeftFootNormalizedRange[2];
var transient BioAnimMovementSync MovementSync;
var transient BioAnimCheckBlendOut BlendOut;
var transient float BlendAngle;
var transient int StateTag;
var transient bool bBlendingOut;
var transient bool bOverrideRMM;
var transient bool bOverrideRMR;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendOutRelPos[0] = 1.0
    BlendOutRelPos[1] = 1.0
    BlendOutRelPos[2] = 1.0
    BlendOutRelPos[3] = 1.0
    BlendOutRelPos[4] = 1.0
    BlendOutRelPos[5] = 1.0
    FreeRotationRelPos[0] = 0.600000024
    FreeRotationRelPos[1] = 0.600000024
    FreeRotationRelPos[2] = 0.600000024
    FreeRotationRelPos[3] = 0.600000024
    FreeRotationRelPos[4] = 0.600000024
    FreeRotationRelPos[5] = 0.600000024
    LeftFootNormalizedRange[1] = 0.600000024
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Forward-Right', 
                 Weight = 1.0, 
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
                 Name = 'Forward-Left', 
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
                 Name = 'Right', 
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
                 Name = 'Left', 
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
                 Name = 'Backward-Right', 
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
                 Name = 'Backward-Left', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeLocomotionStart'
}