Class SeqCond_SwitchBase extends SequenceCondition
    native
    placeable
    abstract;

public event function InsertValueEntry(int InsertIndex);

public event function bool IsFallThruEnabled(int ValueIndex)
{
    return FALSE;
}
public event function RemoveValueEntry(int RemoveIndex);

public event function VerifyDefaultCaseValue();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Default", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}