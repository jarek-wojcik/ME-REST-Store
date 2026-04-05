Class SFXSFHandler_PCSave extends SFXSFHandler_Save
    config(UI);

public function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super(SFXGUIMovieLegacyAdapter).OnPanelAdded();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxSaves = 50
    ScreenLayout = GUILayout.GUILayout_PC
}