Class AnimNodeBlendByProperty extends AnimNodeBlendList
    native;

var(AnimNodeBlendByProperty) Name PropertyName;
var transient Name CachedPropertyName;
var transient Property CachedProperty;
var transient Actor CachedOwner;
var(AnimNodeBlendByProperty) float BlendTime;
var(AnimNodeBlendByProperty) float FloatPropMin;
var(AnimNodeBlendByProperty) float FloatPropMax;
var(AnimNodeBlendByProperty) float BlendToChild1Time;
var(AnimNodeBlendByProperty) float BlendToChild2Time;
var(AnimNodeBlendByProperty) bool bUseOwnersBase;
var(AnimNodeBlendByProperty) bool bUseSpecificBlendTimes;
var(Editor) bool bSynchronizeNodesInEditor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendTime = 0.100000001
    FloatPropMax = 1.0
    BlendToChild1Time = 0.100000001
    BlendToChild2Time = 0.100000001
    bSynchronizeNodesInEditor = TRUE
    bForceChildFullWeightWhenBecomingRelevant = FALSE
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Child1', 
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
                 Name = 'Child2', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
}