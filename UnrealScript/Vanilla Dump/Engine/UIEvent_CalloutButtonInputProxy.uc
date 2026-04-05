Class UIEvent_CalloutButtonInputProxy extends UIEvent
    native
    placeable;

var const UICalloutButtonPanel ButtonPanel;

public final native function bool ChangeButtonAlias(Name CurrentAliasName, Name NewAliasName);

public final native function int FindButtonAliasIndex(Name ButtonAliasName);

public static event function int GetObjClassVersion()
{
    return Super.GetObjClassVersion() + 1;
}
public event function bool IsPastingIntoUISequenceAllowed()
{
    return TRUE;
}
public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return FALSE;
}
public final native function bool RegisterButtonAlias(Name ButtonAliasName);

public final native function bool UnregisterButtonAlias(Name ButtonAliasName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ()
    bDeletable = FALSE
}