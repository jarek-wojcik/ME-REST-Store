Class SFXGUI_PCSquadRecord extends SFXGUI_SquadRecord
    config(UI);

public event function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}
public function ProcessRStickAxisInput(float fValue);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}