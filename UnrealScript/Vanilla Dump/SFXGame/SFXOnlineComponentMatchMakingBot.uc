Class SFXOnlineComponentMatchMakingBot extends SFXOnlineComponent
    implements(ISFXOnlineComponentMatchMakingBot)
    native
    config(Engine);

enum EBotGameContext
{
    BGC_Unknown,
    BGC_Splash,
    BGC_MainMenu,
    BGC_LobbyCharacter,
    BGC_LobbyMain,
    BGC_InGame,
    BGC_GameOver,
    BGC_Prompt,
};
enum EBotAction
{
    BOT_NoAction,
    BOT_MoveForward,
    BOT_MoveBackward,
    BOT_Disconnect,
};

var const native noexport Pointer VfTable_IISFXOnlineComponentMatchMakingBot;
var float mNextActionDelay;
var config float IdleTimeBetweenActions;
var config float ActionProbability_Disconnect;
var config float ActionProbability_Back;
var config float ActionProbability_Forward;
var bool mActivated;
var config bool SimulateDisconnect;
var config bool FastForwardMode;

private final native function DoAction_Disconnect();

private final native function DoAction_GameOver(byte Action);

private final native function DoAction_InGame(byte Action);

private final native function DoAction_Lobby(byte Action);

private final native function DoAction_MainMenu(byte Action);

private final native function DoAction_Prompt(byte Action);

private final native function DoAction_SelectCharacter(byte Action);

private final native function DoAction_Splash(byte Action);

private final native function DoActionForCurrentGUIContext();

public native function Name GetAPIName();

private final native function EBotGameContext GetCurrentContext();

private final event function LaunchCreateMatch()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    local SFXOnlineGameSettings CustomGameSettings;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateMatchComplete);
            CustomGameSettings = new Class'SFXOnlineGameSettings';
            CustomGameSettings.mCreateNewMatch = TRUE;
            GameInterface.CreateOnlineGame(0, 'Game', CustomGameSettings);
        }
    }
}
private final event function LaunchQuickMatch()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameInterface.AddQuickMatchCompleteDelegate(OnQuickMatchComplete);
            GameInterface.QuickMatch();
        }
    }
}
private final event function EBotGameContext MovieNameToGameContext(Name MovieName)
{
    switch (MovieName)
    {
        case 'Splash':
        case 'SaveIndicatorMessage':
            return EBotGameContext.BGC_Splash;
        case 'MainMenu_RTT':
        case 'MainMenu':
            return EBotGameContext.BGC_MainMenu;
        case 'messageBox':
        case 'NetworkRegistration':
            return EBotGameContext.BGC_Prompt;
        case 'MPSelectKit':
            return EBotGameContext.BGC_LobbyCharacter;
        case 'MPLobby':
        case 'MPNewLobby':
            return EBotGameContext.BGC_LobbyMain;
        case 'MPMatchResults':
            return EBotGameContext.BGC_GameOver;
        default:
    }
    return EBotGameContext.BGC_Unknown;
}
public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public function OnQuickMatchComplete(byte Result)
{
    local string connectString;
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    local bool bWasSuccessful;
    
    bWasSuccessful = int(Result) == 1 || int(Result) == 2;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameInterface.ClearQuickMatchCompleteDelegate(OnQuickMatchComplete);
            if (bWasSuccessful)
            {
                if (GameInterface.GetResolvedConnectString('Game', connectString))
                {
                    connectString = "open " $ connectString;
                }
            }
        }
    }
    Class'Engine'.static.GetCurrentWorldInfo().ConsoleCommand(connectString);
}
public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

private final native function EBotAction PickAction();

public function SetEnabled(bool Enabled)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    
    mActivated = Enabled;
    if (!Enabled)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            GameInterface = OnlineSub.GameInterface;
            if (GameInterface != None)
            {
                GameInterface.ClearQuickMatchCompleteDelegate(OnQuickMatchComplete);
                GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateMatchComplete);
            }
        }
    }
}
public function OnCreateMatchComplete(Name SessionName, bool bWasSuccessful)
{
    local string connectString;
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateMatchComplete);
            if (bWasSuccessful)
            {
                if (GameInterface.GetResolvedConnectString('Game', connectString))
                {
                    connectString = "open " $ connectString;
                }
            }
        }
    }
    Class'Engine'.static.GetCurrentWorldInfo().ConsoleCommand(connectString);
}
public function SetOptions(bool withDisconnections, bool fastForward)
{
    SimulateDisconnect = withDisconnections;
    FastForwardMode = fastForward;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IdleTimeBetweenActions = 10.0
    ActionProbability_Disconnect = 0.00999999978
    ActionProbability_Back = 0.0500000007
    ActionProbability_Forward = 0.100000001
    FastForwardMode = TRUE
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}