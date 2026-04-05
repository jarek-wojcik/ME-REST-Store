Class SFXSeqAct_SetPawnVocState extends SequenceAction;

var(SFXSeqAct_SetPawnVocState) bool bVocState;

public function Activated()
{
    local Object oTargetObject;
    local BioPawn oTargetPawn;
    
    foreach Targets(oTargetObject, )
    {
        oTargetPawn = BioPawn(oTargetObject);
        if (oTargetPawn != None)
        {
            if (bVocState)
            {
                SFXGRI(oTargetPawn.WorldInfo.GRI).VocManager.RemoveFromIgnoreList(oTargetPawn);
            }
            else
            {
                SFXGRI(oTargetPawn.WorldInfo.GRI).VocManager.AddToIgnoreList(oTargetPawn);
            }
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Enable", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bVocState', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}