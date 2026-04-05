Class AnimNodeSynch extends AnimNodeBlendBase
    native;

struct native SynchGroup 
{
    var array<AnimNodeSequence> SeqNodes;
    var(SynchGroup) Name GroupName;
    var transient AnimNodeSequence MasterNode;
    var(SynchGroup) float RateScale;
    var(SynchGroup) bool bFireSlaveNotifies;
    
    structdefaultproperties
    {
        RateScale = 1.0
    }
};

var(AnimNodeSynch) array<SynchGroup> Groups;

public final native function AddNodeToGroup(AnimNodeSequence SeqNode, Name GroupName);

public final native function ForceRelativePosition(Name GroupName, float RelativePosition);

public final native function AnimNodeSequence GetMasterNodeOfGroup(Name GroupName);

public final native function float GetRelativePosition(Name GroupName);

public final native function RemoveNodeFromGroup(AnimNodeSequence SeqNode, Name GroupName);

public final native function SetGroupRateScale(Name GroupName, float NewRateScale);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Input', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}