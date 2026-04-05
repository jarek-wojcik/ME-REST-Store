Class SeqCond_SwitchObject extends SeqCond_SwitchBase
    native
    placeable;

struct native SwitchObjectCase 
{
    var(SwitchObjectCase) Object ObjectValue;
    var(SwitchObjectCase) bool bFallThru;
    var(SwitchObjectCase) bool bDefaultValue;
};

var(SeqCond_SwitchObject) array<SwitchObjectCase> SupportedValues;
var(SeqCond_SwitchObject) Class<Object> MetaClass;

public event function InsertValueEntry(int InsertIndex)
{
    InsertIndex = Clamp(InsertIndex, 0, SupportedValues.Length);
    SupportedValues.Insert(InsertIndex, 1);
}
public event function bool IsFallThruEnabled(int ValueIndex)
{
    return ValueIndex >= 0 && ValueIndex < SupportedValues.Length && SupportedValues[ValueIndex].bFallThru;
}
public event function RemoveValueEntry(int RemoveIndex)
{
    if (RemoveIndex >= 0 && RemoveIndex < SupportedValues.Length)
    {
        SupportedValues.Remove(RemoveIndex, 1);
    }
}
public event function VerifyDefaultCaseValue()
{
    local int i;
    
    Super.VerifyDefaultCaseValue();
    SupportedValues.Length = OutputLinks.Length;
    for (i = 0; i < SupportedValues.Length - 1; i++)
    {
        SupportedValues[i].bDefaultValue = FALSE;
    }
    SupportedValues[SupportedValues.Length - 1].ObjectValue = None;
    SupportedValues[SupportedValues.Length - 1].bFallThru = FALSE;
    SupportedValues[SupportedValues.Length - 1].bDefaultValue = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SupportedValues = ({ObjectValue = None, bFallThru = FALSE, bDefaultValue = TRUE}
                      )
    MetaClass = Class'Object'
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Object", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}