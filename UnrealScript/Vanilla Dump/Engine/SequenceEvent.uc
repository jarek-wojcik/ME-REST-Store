Class SequenceEvent extends SequenceOp
    native
    abstract;

enum EWhoTriggers
{
    WT_PlayerOnly,
    WT_PlayerOnlyLocal,
    WT_PlayerAndSquad,
    WT_Everyone,
    WT_TagList,
};

var transient array<SequenceEvent> DuplicateEvts;
var(SequenceEvent) array<Name> lstTags;
var Actor Originator;
var Actor Instigator;
var float ActivationTime;
var int TriggerCount;
var(SequenceEvent) int MaxTriggerCount;
var(SequenceEvent) float ReTriggerDelay;
var int MaxWidth;
var(SequenceEvent) bool bEnabled;
var(SequenceEvent) bool bTagListInclusionary;
var transient bool bRegistered;
var(SequenceEvent) const bool bClientSideOnly;
var(SequenceEvent) byte Priority;
var(WhoTriggers) EWhoTriggers WhoTriggers;

public final native function bool CheckActivate(Actor inOriginator, Actor inInstigator, optional bool bTest, optional const out array<int> ActivateIndices, optional bool bPushTop, optional bool bSFXForceThisFrame);

public native function bool PassesWhoTriggers(Actor inInstigator);

public event function RegisterEvent();

public function Reset()
{
    ActivationTime = 0.0;
    TriggerCount = 0;
    Instigator = None;
}
public event function Toggled();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    bTagListInclusionary = TRUE
    WhoTriggers = EWhoTriggers.WT_PlayerAndSquad
    InputLinks = ()
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bAutoActivateOutputLinks = FALSE
}