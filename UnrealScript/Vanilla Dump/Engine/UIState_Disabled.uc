Class UIState_Disabled extends UIState
    native
    editinlinenew;

public event function bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    local int i;
    local int EnabledIndex;
    local bool bResult;
    
    bResult = Super.ActivateState(Target, PlayerIndex);
    if (Target != None && bResult)
    {
        if (Target.HasActiveStateOfClass(Class'UIState_Enabled', PlayerIndex, EnabledIndex))
        {
            for (i = Target.StateStack.Length - 1; i > EnabledIndex; i--)
            {
                if (!Target.DeactivateState(Target.StateStack[i], PlayerIndex))
                {
                    break;
                }
            }
        }
        bResult = TRUE;
    }
    return bResult;
}
public event function bool IsStateAllowed(UIScreenObject Target, UIState NewState, int PlayerIndex)
{
    if (Super.IsStateAllowed(Target, NewState, PlayerIndex))
    {
        return NewState.Class == Class'UIState_Enabled';
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StackPriority = 5
}