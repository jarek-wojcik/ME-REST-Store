Class SequenceOp extends SequenceObject
    native
    abstract;

struct native SeqEventLink 
{
    var array<SequenceEvent> LinkedEvents;
    var string LinkDesc;
    var Class<SequenceEvent> ExpectedType;
    
    structdefaultproperties
    {
        ExpectedType = Class'SequenceEvent'
    }
};
struct native SeqVarLink 
{
    var array<SequenceVariable> LinkedVariables;
    var string LinkDesc;
    var Class<SequenceVariable> ExpectedType;
    var Name LinkVar;
    var Name PropertyName;
    var int MinVars;
    var int MaxVars;
    var const transient Property CachedProperty;
    var bool bWriteable;
    var bool bModifiesLinkedObject;
    var bool bAllowAnyType;
    
    structdefaultproperties
    {
        ExpectedType = Class'SequenceVariable'
        MinVars = 1
        MaxVars = 255
    }
};
struct native SeqOpOutputLink 
{
    var array<SeqOpOutputInputLink> Links;
    var string LinkDesc;
    var Name LinkAction;
    var SequenceOp LinkedOp;
    var bool bHasImpulse;
    var bool bDisabled;
};
struct native SeqOpOutputInputLink 
{
    var SequenceOp LinkedOp;
    var int InputLinkIdx;
};
struct native SeqOpInputLink 
{
    var string LinkDesc;
    var Name LinkAction;
    var int QueuedActivations;
    var SequenceOp LinkedOp;
    var bool bHasImpulse;
    var bool bDisabled;
};

var array<SeqOpInputLink> InputLinks;
var array<SeqOpOutputLink> OutputLinks;
var array<SeqVarLink> VariableLinks;
var array<SeqEventLink> EventLinks;
var transient noimport int PlayerIndex;
var transient int ActivateCount;
var const transient duplicatetransient int SearchTag;
var bool bActive;
var const bool bLatentExecution;
var const bool bManualHandleOutputs;
var bool bAutoActivateOutputLinks;
var transient bool bSFXNeedsSpecialEventTick;
var transient noimport byte GamepadID;

public event function Activated();

public final native function bool ActivateNamedOutputLink(string LinkDesc);

public final native function bool ActivateOutputLink(int OutputIdx);

public event function Deactivated();

public final native function ForceActivateInput(int InputIdx);

public final native function GetBoolVars(out array<byte> boolVars, optional string inDesc);

public final native function GetFloatVars(out array<float> floatVars, optional string inDesc);

public final native function GetInterpDataVars(out array<InterpData> outIData, optional string inDesc);

public final native function GetIntVars(out array<int> intVars, optional string inDesc);

public final native function GetLinkedObjects(out array<SequenceObject> out_Objects, optional Class<SequenceObject> ObjectType, optional bool bRecurse);

public final native function GetNameVars(out array<Name> nameVars, optional string inDesc);

public final native function GetObjectVars(out array<Object> objVars, optional string inDesc);

public final native function GetStringRefVars(out array<stringref> aStringRef, optional string sDescription);

public final native function GetStringVars(out array<string> strVars, optional string inDesc);

public final native function bool HasLinkedOps(optional bool bConsiderInputLinks);

public final iterator native function LinkedVariables(Class<SequenceVariable> VarClass, out SequenceVariable OutVariable, optional string inDesc);

public final native function PopulateLinkedVariableValues();

public event function PreVersionUpdated(int OldVersion, int NewVersion);

public final native function PublishLinkedVariableValues();

public function Reset();

public native function SetBoolVars(string sLink, bool bValue);

public native function SetFloatVars(string sLink, float fValue);

public native function SetIntVars(string sLink, int nValue);

public native function SetNameVars(string sLink, Name sValue);

public native function SetObjectVars(string sLink, Object oValue);

public native function SetStringRefVars(string sLink, stringref srValue);

public native function SetStringVars(string sLink, string sValue);

public event function VersionUpdated(int OldVersion, int NewVersion);

public function Controller GetController(Actor TheActor)
{
    local Pawn P;
    local Controller C;
    
    C = Controller(TheActor);
    if (C != None)
    {
        return C;
    }
    else
    {
        P = Pawn(TheActor);
        return P != None ? P.Controller : None;
    }
}
public function Pawn GetPawn(Actor TheActor)
{
    local Pawn P;
    local Controller C;
    
    P = Pawn(TheActor);
    if (P != None)
    {
        return P;
    }
    else
    {
        C = Controller(TheActor);
        return C != None ? C.Pawn : None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "In", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    PlayerIndex = -1
    bAutoActivateOutputLinks = TRUE
    GamepadID = 255
}