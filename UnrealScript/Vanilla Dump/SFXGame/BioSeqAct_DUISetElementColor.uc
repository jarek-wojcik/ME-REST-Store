Class BioSeqAct_DUISetElementColor extends SequenceAction;

var(BioSeqAct_DUISetElementColor) Color oColor;
var(BioSeqAct_DUISetElementColor) BioDUIElements Element;

public function Activated()
{
    local BioPlayerController PC;
    local array<int> intVars;
    local bool bColorLinked;
    local Color stColor;
    
    GetIntVars(intVars, "R");
    if (intVars.Length > 0)
    {
        stColor.R = byte(Min(intVars[0], 255));
        bColorLinked = TRUE;
        intVars.Length = 0;
    }
    GetIntVars(intVars, "G");
    if (intVars.Length > 0)
    {
        stColor.G = byte(Min(intVars[0], 255));
        bColorLinked = TRUE;
        intVars.Length = 0;
    }
    GetIntVars(intVars, "B");
    if (intVars.Length > 0)
    {
        stColor.B = byte(Min(intVars[0], 255));
        bColorLinked = TRUE;
        intVars.Length = 0;
    }
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetElementColor(Element, bColorLinked ? stColor : oColor);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "R", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "G", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "B", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}