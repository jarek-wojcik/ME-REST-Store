Class SFXModule_MarkerPlayer extends SFXModule_Marker
    native
    editinlinenew;

var bool PlayerIsDown;
var bool PlayerIsDead;

public event simulated function HandlePostAdd()
{
    UpdatePlayerDownState(PlayerIsDown);
    Super.HandlePostAdd();
}
public simulated function UpdatePlayerDownState(bool NewPlayerIsDown)
{
    PlayerIsDown = NewPlayerIsDown;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MarkerType = "Player"
    GUIMarkerClass = Class'SFXGUIValue_MarkerPlayer'
    bActive = TRUE
    bNetVisible = FALSE
}