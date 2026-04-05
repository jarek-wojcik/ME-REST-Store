Class BioSeqAct_DUISetBarFillPercent extends SequenceAction;

var(BioSeqAct_DUISetBarFillPercent) int nPercent;
var(BioSeqAct_DUISetBarFillPercent) bool bModalBar;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetBarFillPercent(bModalBar, nPercent);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Modal", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bModalBar', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Percent", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nPercent', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}