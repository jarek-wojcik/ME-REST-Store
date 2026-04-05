Class BioAnimNodeCover2ChangeDirection extends AnimNodeBlendList
    native;

enum EBioAnimNodeCover2ChangeDirection
{
    eBioAnimNodeCover2ChangeDirection_Idle,
    eBioAnimNodeCover2ChangeDirection_TransitionToMirror,
    eBioAnimNodeCover2ChangeDirection_TransitionToDefault,
};

var(BioAnimNodeCover2ChangeDirection) float IdleToTransitionBlendDuration;
var(BioAnimNodeCover2ChangeDirection) float TransitionToIdleBlendDuration;
var transient bool bBlocking;
var transient ECoverDirection CurrentCoverDirection;
var transient ECoverDirection PendingCoverDirection;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IdleToTransitionBlendDuration = 0.200000003
    TransitionToIdleBlendDuration = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Idle', 
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
                 Name = 'TransitionToMirror', 
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
                 Name = 'TransitionToDefault', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeCover2ChangeDirection'
}