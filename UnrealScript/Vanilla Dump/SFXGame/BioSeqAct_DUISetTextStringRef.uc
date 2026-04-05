Class BioSeqAct_DUISetTextStringRef extends SequenceAction;

var(BioSeqAct_DUISetTextStringRef) stringref srText;
var(BioSeqAct_DUISetTextStringRef) BioDUIElements Element;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetTextStringRef(Element, srText);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "StringRef", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srText', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}