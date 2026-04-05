Class SFSBotDirectorManager extends SFSManager within SFXPawn;

var string Description;
var SFSBotManager botManager;
var float eventQueuePolling;
var array<SFSEvent> eventQueue;

public event simulated function HandlePostAdd()
{
    //Once we begin playing we link the SFSBotDirectorManager with botManager so that we have access to All bots and potentially other method therein.
    botManager = Outer.GetModule(Class'SFSBotManager');
    if (botManager == None)
    {
        log(Self.Name, "botManager is not present on: " $ Outer.Name $ " bot director won't work as a result", Outer);
    }
    else
    {
        log(Self.Name, "Initialized ", Outer);
    }
}
function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_PlayerDown:
            log(Self.Name, "Player is down : " $ E.mInstigator, Outer);
            HandlePlayerDown(E, TRUE);
            break;
        case SFSEventType.EVT_PlayerDied:
            log(Self.Name, "Player is dead : " $ E.mInstigator, Outer);
            HandlePlayerDown(E, TRUE);
            break;
        default:
            break;
    }
}
function HandlePlayerDown(SFSEvent Event, bool NewEvent)
{
    local SFXPawn Bot;
    local SFXAI_Bot botAI;
    local int BotIndex;
    local GameAICommand command;
    
    log(Self.Name, "HandlePlayerDown: " $ Event.mInstigator, Outer);
    BotIndex = Class'SFSArrayUtility'.static.GetRandomExistingIndex(botManager.AllBots.Length);
    if (NewEvent)
    {
        eventQueue.AddItem(Event);
    }
    if (BotIndex > -1)
    {
        botAI = SFXAI_Bot(botManager.AllBots[BotIndex].Controller);
        if (botAI != None)
        {
            command = new (botAI) Class'SFXAICmd_Bot_RevivePlayer';
            SFXAICmd_Bot_RevivePlayer(command).downedTarget = Event.mInstigator;
            botAI.PushCommand(command);
            if (!Outer.IsTimerActive('CleanReviveEvents', Self))
            {
                Outer.SetTimer(eventQueuePolling, TRUE, 'CleanReviveEvents', Self);
            }
            return;
        }
    }
}
function CleanReviveEvents()
{
    local SFSEvent Event;
    local SFXPawn_Player DownedPlayer;
    
    log(Self.Name, "Polling Revive Events: " $ eventQueue.Length, Outer);
    if (eventQueue.Length < 1)
    {
        Outer.ClearTimer('CleanReviveEvents', Self);
    }
    else
    {
        foreach eventQueue(Event, )
        {
            if (Event.eType == SFSEventType.EVT_PlayerDown || Event.eType == SFSEventType.EVT_PlayerDied)
            {
                DownedPlayer = SFXPawn_Player(Event.mInstigator);
                if (DownedPlayer != None && (DownedPlayer.bIsDowned || DownedPlayer.bIsDead))
                {
                    HandlePlayerDown(Event, FALSE);
                }
                else
                {
                    eventQueue.RemoveItem(Event);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_PlayerDown, SFSEventType.EVT_PlayerDied)
    Description = "Unlinke the SFSBotManager which is responsible for bot management (add, list, remove) commands, this class is responsible for directing the bot behaviour based on different events."
    eventQueuePolling = 0.5
}