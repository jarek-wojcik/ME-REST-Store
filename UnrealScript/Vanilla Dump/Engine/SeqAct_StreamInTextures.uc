Class SeqAct_StreamInTextures extends SeqAct_Latent
    native;

var(SeqAct_StreamInTextures) array<Object> LocationActors;
var(SeqAct_StreamInTextures) array<MaterialInterface> ForceMaterials;
var(SeqAct_StreamInTextures) float Seconds;
var const float StopTimestamp;
var(CinematicMipLevels) const TextureGroupContainer CinematicTextureGroups;
var const transient native int SelectedCinematicTextureGroups;
var const bool bStreamingActive;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Seconds = 15.0
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Actor", 
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
                      LinkDesc = "Location", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'LocationActors', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}