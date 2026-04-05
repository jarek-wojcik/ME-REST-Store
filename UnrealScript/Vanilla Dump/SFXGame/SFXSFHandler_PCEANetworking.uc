Class SFXSFHandler_PCEANetworking extends SFXSFHandler_EANetworking
    config(UI);

public event function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}