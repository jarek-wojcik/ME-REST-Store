Class BioAnimNodeLocomotionStop extends AnimNodeBlendList
    native;

enum EBioAnimNodeLocomotionStop
{
    eBioAnimNodeLocomotionStop_LeftFoot,
    eBioAnimNodeLocomotionStop_RightFoot,
};

var(BioAnimNodeLocomotionStop) const float LeftFootNormalizedRange[2];
var(BioAnimNodeLocomotionStop) const float BlendOutTime;
var transient BioAnimCheckBlendOut BlendOut;
var transient BioAnimMovementSync MovementSync;
var transient bool bOverrideRootMotion;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LeftFootNormalizedRange[1] = 0.5
    BlendOutTime = 2.5
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'LeftFoot', 
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
                 Name = 'RightFoot', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeLocomotionStop'
}