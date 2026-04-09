Class SFXCustomAction_HenchBeckonRear extends SFXCustomAction_LoopingInteraction
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_InteractionStart = {
                           AnimName = ('CB_BeckonBack_Enter')
                          }
    BS_InteractionLoop = {
                          AnimName = ('CB_BeckonBack')
                         }
    BS_InteractionEnd = {
                         AnimName = ('CB_BeckonBack_Exit')
                        }
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}