Class SceneCaptureActor extends Actor
    native
    abstract;

var(SceneCaptureActor) const editinline export SceneCaptureComponent SceneCapture;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    local bool bEnable;
    
    if (SceneCapture == None)
    {
        return;
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnable = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnable = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnable = !SceneCapture.bEnabled;
    }
    SceneCapture.SetEnabled(bEnable);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None)
    bNoDelete = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}