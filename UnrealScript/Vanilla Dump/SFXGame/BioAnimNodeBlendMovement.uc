Class BioAnimNodeBlendMovement extends AnimNodeBlendList
    native;

enum EBioAnimNodeBlendMovement
{
    eBioAnimNodeBlendMovement_Idle,
    eBioAnimNodeBlendMovement_Walk,
    eBioAnimNodeBlendMovement_Run,
};

var(BioAnimNodeBlendMovement) const Name WalkSynchGroupName;
var(BioAnimNodeBlendMovement) const Name RunSynchGroupName;
var(BioAnimNodeBlendMovement) const float IdleSpeed;
var(BioAnimNodeBlendMovement) const float MinWalkSpeed;
var(BioAnimNodeBlendMovement) const float MidWalkSpeed;
var(BioAnimNodeBlendMovement) const float MaxWalkSpeed;
var(BioAnimNodeBlendMovement) const float MinRunSpeed;
var(BioAnimNodeBlendMovement) const float MidRunSpeed;
var(BioAnimNodeBlendMovement) const float MaxRunSpeed;
var(BioAnimNodeBlendMovement) const float IdleTimeout;
var(BioAnimNodeBlendMovement) const float BlendTimeIdle2Walk;
var(BioAnimNodeBlendMovement) const float BlendTimeIdle2Run;
var(BioAnimNodeBlendMovement) const float BlendTimeWalk2Idle;
var(BioAnimNodeBlendMovement) const float BlendTimeWalk2Run;
var(BioAnimNodeBlendMovement) const float BlendTimeRun2Idle;
var(BioAnimNodeBlendMovement) const float BlendTimeRun2Walk;
var transient float IdleTimer;
var transient float CurrentSpeed;
var transient float CurrentAcceleration;
var transient float CurrentWalkRate;
var transient float CurrentRunRate;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IdleSpeed = 5.0
    MinWalkSpeed = 30.0
    MidWalkSpeed = 130.0
    MaxWalkSpeed = 180.0
    MinRunSpeed = 150.0
    MidRunSpeed = 250.0
    MaxRunSpeed = 350.0
    IdleTimeout = 0.25
    BlendTimeIdle2Walk = 0.5
    BlendTimeIdle2Run = 0.5
    BlendTimeWalk2Idle = 0.5
    BlendTimeWalk2Run = 0.5
    BlendTimeRun2Idle = 0.5
    BlendTimeRun2Walk = 0.5
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
                 Name = 'Walk', 
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
                 Name = 'Run', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeBlendMovement'
}