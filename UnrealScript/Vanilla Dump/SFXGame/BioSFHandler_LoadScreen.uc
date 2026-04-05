Class BioSFHandler_LoadScreen extends SFXGUIMovieLegacyAdapter
    deprecated
    config(UI);

public function HandleEvent(byte nCommand, const out array<string> lstArguments);

public function OnPanelAdded()
{
    Super.OnPanelAdded();
}
public function OnPanelRemoved()
{
    Super.OnPanelRemoved();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}