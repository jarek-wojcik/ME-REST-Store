Class SFXSFHandler_PS3MainMenu extends BioSFHandler_MainMenu
    config(UI);

public function OnSignInComplete_ShowMarketPlace(bool bSignedIn)
{
    if (bSignedIn)
    {
        ShowMarketPlace(FALSE);
    }
}
public function ShowMarketPlace(bool bCheckForSignIn)
{
    local SFXOnlineSubsystem OnlineSub;
    local SFXOnlineComponentPlatformPS3 oOnlinePlatformPS3;
    local SFXOnlineComponentBlazeLogin oLogin;
    
    OnlineSub = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        oLogin = OnlineSub.GetComponentLogin();
        if (oLogin != None)
        {
            if (bCheckForSignIn && !oLogin.IsConnectedTo1stPartyOnlineService())
            {
                oOnlinePlatformPS3 = OnlineSub.GetComponentPlatform();
                if (oOnlinePlatformPS3 != None)
                {
                    oOnlinePlatformPS3.ShowLoginUIEx(OnSignInComplete_ShowMarketPlace);
                }
            }
            else
            {
                oLogin.Buy(3);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXGUI_MainMenu_RightComputer Name=MessagingComputer1
    End Template
    MessagingComputer = MessagingComputer1
    ScreenLayout = GUILayout.GUILayout_PS3
}