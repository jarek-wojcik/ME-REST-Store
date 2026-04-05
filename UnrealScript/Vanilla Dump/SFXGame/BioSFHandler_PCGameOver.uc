Class BioSFHandler_PCGameOver extends BioSFHandler_GameOver
    config(UI);

public function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}