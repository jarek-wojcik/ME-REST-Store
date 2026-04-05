Class SFXSeqAct_GetTreasureImage extends SequenceAction;

var(SFXSeqAct_GetTreasureImage) int nTreasureId;
var Texture2D oImage;

public function Activated()
{
    local string sImageResource;
    local int nID;
    
    nID = SeqVar_Int(VariableLinks[0].LinkedVariables[0]).IntValue;
    sImageResource = Class'SFXPlotTreasure'.static.GetTreasureLargeImageResourcePath(nID);
    oImage = Class'SFXPlotTreasure'.static.FindImage(sImageResource);
    OutputLinks[0].bHasImpulse = TRUE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "TreasureID", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nTreasureId', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Image", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oImage', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}