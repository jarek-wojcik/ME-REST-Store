Class SFXSeqAct_MoveOnSplineNativeBase extends SeqAct_Latent
    native;

var bool m_bSFXCreatedBeforeStuntActorLocationChange;

public native function MoveActor(Actor Actor, Vector NewLocation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}