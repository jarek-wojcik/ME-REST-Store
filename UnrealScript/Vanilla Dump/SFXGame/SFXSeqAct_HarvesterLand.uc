Class SFXSeqAct_HarvesterLand extends SeqAct_Latent
    native;

var(SFXSeqAct_HarvesterLand) Actor AnchorActor;
var(SFXSeqAct_HarvesterLand) Actor EndMarker;
var(SFXSeqAct_HarvesterLand) bool bTakeOff;

public static function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}
public function bool Update(float DeltaTime)
{
    local BioPawn P;
    local SFXAI_Core AI;
    
    P = BioPawn(Targets[0]);
    if (P == None)
    {
        return FALSE;
    }
    if (!bTakeOff)
    {
        if (P.CurrentCustomAction != 0)
        {
            return TRUE;
        }
    }
    else
    {
        AI = SFXAI_Core(P.Controller);
        if (AI != None && AI.CommandList.IsA('SFXAICmd_Harvester_Flying') == FALSE)
        {
            return TRUE;
        }
    }
    LatentActors.Length = 0;
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
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
                      LinkDesc = "Anchor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'AnchorActor', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "End Marker", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'EndMarker', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}