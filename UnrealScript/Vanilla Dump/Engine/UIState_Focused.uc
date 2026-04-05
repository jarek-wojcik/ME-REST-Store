Class UIState_Focused extends UIState
    native
    editinlinenew
    hidedropdown;

public event function bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    local bool bResult;
    
    bResult = Super.ActivateState(Target, PlayerIndex);
    if (Target != None)
    {
        bResult = Target.HasActiveStateOfClass(Class'UIState_Enabled', PlayerIndex);
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StackPriority = 10
}