Class BioSFHandler_PCChoiceGUI extends BioSFHandler_ChoiceGUI
    config(UI);

public function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}
public function ScrollText(float fValue);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}