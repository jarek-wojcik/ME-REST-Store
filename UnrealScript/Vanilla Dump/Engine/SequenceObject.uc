Class SequenceObject
    native
    abstract;

struct native RemoteEventParameter 
{
    var(RemoteEventParameter) Name ParameterName;
    var(RemoteEventParameter) KismetVarTypes VariableType;
};
enum KismetVarTypes
{
    KVT_Int,
    KVT_Float,
    KVT_Bool,
    KVT_String,
    KVT_Object,
    KVT_Name,
    KVT_Vector,
};

var(SequenceObject) biononship bioexpanded array<string> m_aObjComment;
var const int ObjInstanceVersion;
var const noimport Sequence ParentSequence;
var bool bDeletable;
var(SequenceObject) bool bOutputObjCommentToScreen;

public static event function int GetObjClassVersion()
{
    return 1;
}
public final native function WorldInfo GetWorldInfo();

public event function bool IsPastingIntoLevelSequenceAllowed()
{
    return IsValidLevelSequenceObject();
}
public event function bool IsPastingIntoUISequenceAllowed()
{
    return IsValidUISequenceObject();
}
public event function bool IsValidLevelSequenceObject()
{
    return TRUE;
}
public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return FALSE;
}
public event function ScriptCleanUp();

public final native function ScriptLog(string LogText, optional bool bWarning = TRUE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aObjComment = ("")
    bDeletable = TRUE
}