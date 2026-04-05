Class SFXCustomAction_HenchStandIdle extends SFXCustomAction_InteractionPointAnim
    config(Game);

public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    local int idx;
    local Class<BioCustomAction> NewClass;
    local Class<BioCustomAction> OldClass;
    
    OldClass = GetCustomActionClass(OldCustomAction);
    NewClass = GetCustomActionClass(NewCustomAction);
    if (NewClass != None && OldClass != None)
    {
        if (NewClass.default.Priority != ECustomActionPriority.CA_Priority_None && int(NewClass.default.Priority) > int(OldClass.default.Priority))
        {
            return TRUE;
        }
        for (idx = 0; idx < OverrideList.Length; idx++)
        {
            if (ClassIsChildOf(NewClass, OverrideList[idx]))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function TriggerEnd()
{
    EndThisCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}