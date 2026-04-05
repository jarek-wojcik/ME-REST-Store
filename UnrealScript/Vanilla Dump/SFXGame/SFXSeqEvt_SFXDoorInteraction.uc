Class SFXSeqEvt_SFXDoorInteraction extends SequenceEvent;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public function TriggerInteraction(ESFXDoorState CurrentState, Actor EventInstigator)
{
    local array<int> ActivateIndices;
    local SeqVar_Object ObjVar;
    
    if (CurrentState == ESFXDoorState.EDS_Closed || CurrentState == ESFXDoorState.EDS_Open)
    {
        ActivateIndices[ActivateIndices.Length] = 4;
    }
    else if (CurrentState == ESFXDoorState.EDS_Hackable)
    {
        ActivateIndices[ActivateIndices.Length] = 2;
    }
    else if (CurrentState == ESFXDoorState.EDS_PlotLocked)
    {
        ActivateIndices[ActivateIndices.Length] = 3;
    }
    else if (CurrentState == ESFXDoorState.EDS_Delayed)
    {
        ActivateIndices[ActivateIndices.Length] = 5;
    }
    if (ActivateIndices.Length == 0)
    {
        ScriptLog("Not activating" @ Self @ "for event because there are no matching outputs");
    }
    else if (CheckActivate(Originator, EventInstigator, FALSE, ActivateIndices))
    {
        foreach LinkedVariables(Class'SeqVar_Object', ObjVar, "Instigator")
        {
            ObjVar.SetObjectValue(EventInstigator);
        }
    }
}
public function TriggerStateChange(ESFXDoorState NewState, ESFXDoorState PrevState, Actor EventInstigator)
{
    local array<int> ActivateIndices;
    local SeqVar_Object ObjVar;
    
    if (NewState == ESFXDoorState.EDS_Closed || PrevState == ESFXDoorState.EDS_Open)
    {
        ActivateIndices[ActivateIndices.Length] = 0;
    }
    else if (NewState == ESFXDoorState.EDS_Open)
    {
        ActivateIndices[ActivateIndices.Length] = 1;
    }
    if (ActivateIndices.Length == 0)
    {
        ScriptLog("Not activating" @ Self @ "for event because there are no matching outputs");
    }
    else if (CheckActivate(Originator, EventInstigator, FALSE, ActivateIndices))
    {
        foreach LinkedVariables(Class'SeqVar_Object', ObjVar, "Instigator")
        {
            ObjVar.SetObjectValue(EventInstigator);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Closed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Opened", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "UsedWhenHackable", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "UsedWhenPlotLocked", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "UsedWhenUnlocked", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "UsedWhenDelayed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}