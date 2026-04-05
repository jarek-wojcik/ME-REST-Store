Class BioSFHandler_PCAchievement extends BioSFHandler_Achievement
    config(UI);

public function OnPanelAdded()
{
    SetMouseShown(TRUE);
    Super.OnPanelAdded();
}
public function bool IsAccomplishmentValid(out Accomplishment Data)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}