Class SFXAnimNodeBlendByMoveTransition extends AnimNodeBlendList
    native;

struct native MoveToIdleTransitionBlend 
{
    var(MoveToIdleTransitionBlend) Name ChildName;
    var(MoveToIdleTransitionBlend) float SyncGroupMin;
    var(MoveToIdleTransitionBlend) float SyncGroupMax;
    var(MoveToIdleTransitionBlend) float TransitionDelay;
    var(MoveToIdleTransitionBlend) float TransitionTime;
    var(MoveToIdleTransitionBlend) float AnimStartTime;
    var(MoveToIdleTransitionBlend) float BlendInTime;
    var(MoveToIdleTransitionBlend) float BlendOutTime;
    
    structdefaultproperties
    {
        ChildName = 'WalkToIdle'
        SyncGroupMax = 1.0
        TransitionTime = 0.5
        BlendInTime = 0.100000001
        BlendOutTime = 0.100000001
    }
};

var(SFXAnimNodeBlendByMoveTransition) array<MoveToIdleTransitionBlend> MoveToIdleBlends;
var(SFXAnimNodeBlendByMoveTransition) const Name MoveSyncGroup;
var(SFXAnimNodeBlendByMoveTransition) const float IdleSpeed;
var transient float IdleTimer;
var transient int ActiveMoveToIdleTrans;
var transient bool bIdle;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MoveToIdleBlends = ({
                         ChildName = 'WalkToIdle', 
                         SyncGroupMin = 0.0, 
                         SyncGroupMax = 1.0, 
                         TransitionDelay = 0.0, 
                         TransitionTime = 0.5, 
                         AnimStartTime = 0.0, 
                         BlendInTime = 0.100000001, 
                         BlendOutTime = 0.100000001
                        }
                       )
    MoveSyncGroup = 'CombatMove'
    IdleSpeed = 10.0
    ActiveMoveToIdleTrans = -1
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Source', 
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
                 Name = 'WalkToIdle', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    NodeName = 'SFXAnimNodeBlendByMoveTransition'
}