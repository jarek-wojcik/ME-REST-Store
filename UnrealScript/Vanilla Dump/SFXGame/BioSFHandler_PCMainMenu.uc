Class BioSFHandler_PCMainMenu extends BioSFHandler_MainMenu
    native
    config(GuiResources);

public function OnYButton();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXGUI_MainMenu_RightComputer Name=MessagingComputer1
    End Template
    MessagingComputer = MessagingComputer1
    ScreenLayout = GUILayout.GUILayout_PC
}