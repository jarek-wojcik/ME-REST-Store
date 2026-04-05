Class SFXGUI_PCStore extends SFXGUI_Store
    config(UI);

public function OnStart()
{
    Super.OnStart();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXWeaponUIDataManager Name=oDataManager
    End Template
    WeaponDataManager = oDataManager
    ScreenLayout = GUILayout.GUILayout_PC
}