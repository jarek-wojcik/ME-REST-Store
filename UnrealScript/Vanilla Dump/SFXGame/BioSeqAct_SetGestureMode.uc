Class BioSeqAct_SetGestureMode extends SequenceAction
    native;

enum EBioSetGestureModes
{
    GestureMode_On,
    GestureMode_Off,
};

var(BioSeqAct_SetGestureMode) array<string> ActorTags;
var array<Actor> m_aActors;
var(BioSeqAct_SetGestureMode) bool m_bForAmbientActing;
var(BioSeqAct_SetGestureMode) EBioSetGestureModes GestureMode;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawns", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_aActors', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}