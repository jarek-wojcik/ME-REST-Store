Class SFXSeqAct_LookupHenchmenFromPlotManager extends SequenceAction
    native;

var(SFXSeqAct_LookupHenchmenFromPlotManager) array<int> SelectedIndices;
var(SFXSeqAct_LookupHenchmenFromPlotManager) int NumHenchmen;

public function Activated()
{
    local int PlotStateIdx;
    local int HenchIdx;
    local int TotalSelected;
    local array<byte> boolVars;
    
    HenchIdx = 0;
    TotalSelected = 0;
    SelectedIndices[0] = -1;
    SelectedIndices[1] = -1;
    GetBoolVars(boolVars);
    for (PlotStateIdx = 1; PlotStateIdx < VariableLinks.Length; PlotStateIdx++)
    {
        if (SeqVar_Bool(VariableLinks[PlotStateIdx].LinkedVariables[0]).bValue != 0)
        {
            if (HenchIdx >= SelectedIndices.Length)
            {
                break;
            }
            SelectedIndices[HenchIdx] = PlotStateIdx - 1;
            HenchIdx++;
            TotalSelected++;
        }
    }
    if (TotalSelected > 0)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    else
    {
        OutputLinks[1].bHasImpulse = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failure", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "HenchIDs", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'SelectedIndices', 
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