Class BioSeqAct_DUISetElementVisible extends SequenceAction;

var(BioSeqAct_DUISetElementVisible) float fFadeTime;
var(BioSeqAct_DUISetElementVisible) bool bVisible;
var(BioSeqAct_DUISetElementVisible) BioDUIElements Element;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetElementVisible(Element, bVisible, fFadeTime);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Visible", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bVisible', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "FadeTime", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fFadeTime', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}