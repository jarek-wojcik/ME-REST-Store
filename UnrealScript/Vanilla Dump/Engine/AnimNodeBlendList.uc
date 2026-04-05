Class AnimNodeBlendList extends AnimNodeBlendBase
    native;

var array<float> TargetWeight;
var float BlendTimeToGo;
var int ActiveChildIndex;
var(AnimNodeBlendList) bool bPlayActiveChild;
var(Performance) bool bForceChildFullWeightWhenBecomingRelevant;
var(Performance) bool bSkipBlendWhenNotRendered;

public native function SetActiveChild(int ChildIndex, float BlendTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bForceChildFullWeightWhenBecomingRelevant = TRUE
    bSkipBlendWhenNotRendered = TRUE
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
                }
               )
}