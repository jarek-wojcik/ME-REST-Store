Class SFXGUIMovieExtension within SFXGUIMovie
    native;

var(SFXGUIMovieExtension) int m_nFSHandlerID;

public event function HandleFSCommand(byte nCommandID, const out array<string> aArgs);

public event function bool HandleInputEvent(BioGuiEvents nEventID, optional float fValue = 1.0)
{
    return FALSE;
}
public event function OnAdded();

public event function OnClosed();

public event function OnRemoved();

public event function Update(float fDeltaT);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}