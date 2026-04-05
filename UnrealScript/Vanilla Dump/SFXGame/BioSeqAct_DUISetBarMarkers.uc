Class BioSeqAct_DUISetBarMarkers extends SequenceAction;

var(BioSeqAct_DUISetBarMarkers) int nMarker1;
var(BioSeqAct_DUISetBarMarkers) int nMarker2;
var(BioSeqAct_DUISetBarMarkers) bool bModalBar;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    BioHUD(PC.myHUD).DUI_SetBarMarkerPoints(bModalBar, nMarker1, nMarker2);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nMarker1 = -1
    nMarker2 = -1
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
                      LinkDesc = "Marker1", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nMarker1', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Marker2", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nMarker2', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}