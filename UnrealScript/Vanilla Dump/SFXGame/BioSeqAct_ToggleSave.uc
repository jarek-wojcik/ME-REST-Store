Class BioSeqAct_ToggleSave extends SequenceAction;

var(BioSeqAct_ToggleSave) stringref srReason;
var(BioSeqAct_ToggleSave) bool bEnable;

public function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController PC;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo != None)
    {
        PC = oWorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            PC.bKismetNoSave = !bEnable;
            PC.KismetNoSaveReason = srReason;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Enable", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bEnable', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Reason", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srReason', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}