Class SFXGUI_MainMenu_RTT_RC extends SFXGUIMovieKismet
    native
    config(UI);

var string ReplacementTextureSymbol;

public event function OnStart()
{
    local SFXGUIInteraction oMgr;
    local BioSFHandler_MainMenu oMainMenu;
    
    Super.OnStart();
    oMgr = GetSFXUIController();
    if (oMgr != None)
    {
        oMainMenu = oMgr.CastGetMovie(Class'BioSFHandler_MainMenu', GetPC(), oMgr.MovieTag_MainMenu);
        oMainMenu.MessagingComputer.SetDisplayComputer(Self);
    }
}
public final function AddGalaxyAtWarMessage(SFXGUI_MainMenu_Message_GAW aMessage)
{
    aMessage.MovieClip = AS_AddGalaxyAtWarMessage(aMessage.Title, aMessage.Message, aMessage.Id);
}
public final function AddImageMessage(SFXGUI_MainMenu_Message_Image aMessage)
{
    aMessage.MovieClip = AS_AddImageMessage(aMessage.Title, aMessage.Message, aMessage.Id);
}
public final function GFxValue AS_AddGalaxyAtWarMessage(string strTitle, string strBody, int nMessageId)
{
    return ActionScriptObject("_root.mcDataList.AddGalaxyAtWarMessage");
}
public final function GFxValue AS_AddImageMessage(string strTitle, string strBody, int nMessageId)
{
    return ActionScriptObject("_root.mcDataList.AddImageMessage");
}
public final function AS_DisplayPendingMessage()
{
    ActionScriptVoid("_root.mcDataList.DisplayPendingDataItem");
}
public final function AS_NextMessage()
{
    ActionScriptVoid("_root.mcDataList.NextMessage");
}
public final function AS_PrevMessage()
{
    ActionScriptVoid("_root.mcDataList.PrevMessage");
}
public final function AS_SetConnectButtonState(string sMessage, optional bool bVisible = TRUE)
{
    ActionScriptVoid("_root.mcConnectButton.SetConnectButtonState");
}
public final function AS_SetNextButtonVisible(bool bVisible)
{
    ActionScriptVoid("_root.mcNavigation.SetNextButtonVisible");
}
public final function AS_SetPrevButtonVisible(bool bVisible)
{
    ActionScriptVoid("_root.mcNavigation.SetPrevButtonVisible");
}
public final function AS_SetRepeatingText(string Value)
{
    ActionScriptVoid("_root.mcTickerText.SetRepeatingText");
}
public final function int AS_SynchMessageArrays(array<int> OrderedMessageIds)
{
    return ActionScriptInt("_root.mcDataList.SynchMessageArrays");
}
public final function AS_UpdateImageMessage(string strTitle, string strBody, int nMessageId)
{
    ActionScriptVoid("_root.mcDataList.UpdateMessage");
}
public final function UpdateImageMessage(SFXGUI_MainMenu_Message_Image aMessage)
{
    AS_UpdateImageMessage(aMessage.Title, aMessage.Message, aMessage.Id);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementTextureSymbol = "MainMenu_RTT_RC_ReplacementTexture"
}