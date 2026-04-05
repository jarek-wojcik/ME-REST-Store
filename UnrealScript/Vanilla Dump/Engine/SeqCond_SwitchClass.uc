Class SeqCond_SwitchClass extends SeqCond_SwitchBase
    native
    placeable;

struct native SwitchClassInfo 
{
    var(SwitchClassInfo) Name className;
    var(SwitchClassInfo) byte bFallThru;
};

var(SeqCond_SwitchClass) array<SwitchClassInfo> ClassArray;

public event function InsertValueEntry(int InsertIndex)
{
    InsertIndex = Clamp(InsertIndex, 0, ClassArray.Length);
    ClassArray.Insert(InsertIndex, 1);
}
public event function bool IsFallThruEnabled(int ValueIndex)
{
    return ValueIndex >= 0 && ValueIndex < ClassArray.Length && int(ClassArray[ValueIndex].bFallThru) != 0;
}
public event function RemoveValueEntry(int RemoveIndex)
{
    if (RemoveIndex >= 0 && RemoveIndex < ClassArray.Length)
    {
        ClassArray.Remove(RemoveIndex, 1);
    }
}
public event function VerifyDefaultCaseValue()
{
    Super.VerifyDefaultCaseValue();
    ClassArray.Length = OutputLinks.Length;
    ClassArray[ClassArray.Length - 1].className = 'Default';
    ClassArray[ClassArray.Length - 1].bFallThru = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ClassArray = ({className = 'Default', bFallThru = 0}
                 )
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