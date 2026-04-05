Class SeqEvent_LOS extends SequenceEvent;

var(SeqEvent_LOS) float ScreenCenterDistance;
var(SeqEvent_LOS) float TriggerDistance;
var(SeqEvent_LOS) bool bCheckForObstructions;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (OutputLinks[0].LinkDesc == "Out")
    {
        OutputLinks[0].LinkDesc = "Look";
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenCenterDistance = 50.0
    TriggerDistance = 2048.0
    bCheckForObstructions = TRUE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Look", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stop Look", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}