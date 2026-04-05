Class Sequence extends SequenceOp
    native;

struct native QueuedActivationInfo 
{
    var array<int> ActivateIndices;
    var SequenceEvent ActivatedEvent;
    var Actor inOriginator;
    var Actor inInstigator;
    var bool bPushTop;
};
struct native ActivateOp 
{
    var SequenceOp ActivatorOp;
    var SequenceOp Op;
    var int InputIdx;
    var float RemainingDelay;
};

var const export array<SequenceObject> SequenceObjects;
var const array<SequenceOp> ActiveSequenceOps;
var const transient array<Sequence> NestedSequences;
var const array<SequenceEvent> UnregisteredEvents;
var const array<ActivateOp> DelayedActivatedOps;
var array<QueuedActivationInfo> QueuedActivations;
var array<SequenceObject> m_aBioNotifyOfStasis;
var array<AnimSet> m_aSFXSharedAnimsets;
var transient array<Sequence> m_aBioPreTickedSequences;
var string m_sBioSequenceName;
var transient array<SequenceEvent> m_aSFXEventsThisFrame;
var const Pointer LogFile;
var int DefaultViewX;
var int DefaultViewY;
var float DefaultViewZoom;
var transient int m_nTotalRecursiveKismetCount;
var transient int m_nTotalRecursiveMemoryUsage;
var transient int m_nTotalRecursiveSequences;
var transient float m_nApproximateKismetLoadTime;
var(Sequence) const editconst bool IsLocalized;
var(Sequence) bool bEnabled;
var transient bool m_bBioForceReUpdate;
var transient bool m_bSFXInUpdateOp;

public final native function FindSeqObjectsByClass(Class<SequenceObject> DesiredClass, bool bRecursive, out array<SequenceObject> OutputObjects);

public final native function FindSeqObjectsByName(string SeqObjName, bool bCheckComment, out array<SequenceObject> OutputObjects, optional bool bRecursive = TRUE);

public function Reset()
{
    local int i;
    local SequenceOp Op;
    
    for (i = 0; i < SequenceObjects.Length; i++)
    {
        Op = SequenceOp(SequenceObjects[i]);
        if (Op != None)
        {
            Op.Reset();
        }
    }
}
public final native function SetEnabled(bool bInEnabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultViewZoom = 1.0
    bEnabled = TRUE
    InputLinks = ()
    OutputLinks = ()
}