Class SFXGameViewportClient extends GFxGameViewportClient within Engine
    transient;

public function DisplayProgressMessage(Canvas Canvas);

public function DrawTransitionMessage(Canvas Canvas, string Message);

public function NotifyConnectionError(optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
    local WorldInfo WI;
    local SFXPlayerController oController;
    local SFXEngine oEngine;
    local SFXOnlineSubsystem oOnlineSubsystem;
    local bool connectionErrorHandled;
    local bool isInMPGame;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine.eNetworkErrorStatus != ESFXNetworkErrorStatus.ErrorStatus_NoError)
    {
        return;
    }
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None && oOnlineSubsystem.GetComponentGame() != None)
    {
        isInMPGame = oOnlineSubsystem.GetComponentGameFlow().GM_IsInMultiplayerGame();
        if (oOnlineSubsystem.GetComponentGame().OnConnectionError())
        {
            connectionErrorHandled = TRUE;
        }
    }
    if (!connectionErrorHandled)
    {
        if (isInMPGame)
        {
            WI = Class'Engine'.static.GetCurrentWorldInfo();
            oController = WI == None ? None : SFXPlayerController(BioWorldInfo(WI).GetLocalPlayerController());
            if (oController != None)
            {
                oController.OnGameConnectionLost();
                oEngine.eNetworkErrorStatus = ESFXNetworkErrorStatus.ErrorStatus_DisplayingPrompt;
            }
            else
            {
                oEngine.eNetworkErrorStatus = ESFXNetworkErrorStatus.ErrorStatus_DisplayPromptAfterTravel;
                if (WI != None)
                {
                    Super(GameViewportClient).NotifyConnectionError(Message, Title);
                }
                else
                {
                    ConsoleCommand("start ?failed");
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GFxUIControllerClass = Class'SFXGUIInteraction'
}