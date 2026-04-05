Class BioSeqAct_DUISetBarFillDirection extends SequenceAction;

var(BioSeqAct_DUISetBarFillDirection) bool bModalBar;
var(BioSeqAct_DUISetBarFillDirection) bool bLeftToRight;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetBarFillDirection(bModalBar, bLeftToRight);
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
                      LinkDesc = "LeftToRight", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bLeftToRight', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}