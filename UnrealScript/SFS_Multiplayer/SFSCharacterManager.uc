Class SFSCharacterManager extends SFSManager within SFXPawn;

var SFSBotManager botManager;
var SFSAppearanceManager appearanceManager;
var int targetSkin;
var bool skinChanged;
var bool changingSkin;
var bool usingHeadgear;
var bool b_ignoreCrouchModAbsent;
var array<int> forbiddenIDs;

public event simulated function HandlePostAdd()
{
    //Once we begin playing we link the SFSBotDirectorManager with botManager so that we have access to All bots and potentially other method therein.
    botManager = Outer.GetModule(Class'SFSBotManager');
    if (botManager == None)
    {
        log(Self.Name, "SFSBotManager is not present on: " $ Outer.Name $ " SFSCharacterManager won't work as a result", Outer);
    }
    else
    {
        log(Self.Name, "Initialized SFSBotManager", Outer);
    }
    appearanceManager = Outer.GetModule(Class'SFSAppearanceManager');
    if (botManager == None)
    {
        log(Self.Name, "SFSAppearanceManager is not present on: " $ Outer.Name $ " SFSCharacterManager won't work as a result", Outer);
    }
    else
    {
        log(Self.Name, "Initialized SFSAppearanceManager", Outer);
    }
}
function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_ChangeSkin:
            log(Self.Name, "ChangingSkin : " $ E.botId, Outer);
            initiateTemplateLoad(E);
            break;
        case SFSEventType.EVT_BotSpawned:
            log(Self.Name, "BotSpawned : " $ E.botId, Outer);
            changeSkin(E.botId, SFXPawn(E.mInstigator));
            break;
        default:
    }
}
public function initiateTemplateLoad(SFSEvent E)
{
    if (isForbidden(E.botId))
    {
        return;
    }
    botManager.SpawnBot(int(E.botId), 1, TRUE);
    changingSkin = TRUE;
    usingHeadgear = E.bValue;
    targetSkin = int(E.botId);
}
public function changeSkin(string Id, SFXPawn SourcePawn)
{
    log(Self.Name, "Changing Skin is " $ changingSkin, Outer);
    if (SourcePawn != None && int(Id) == targetSkin && changingSkin)
    {
        appearanceManager.CopyAppearanceSelf(SourcePawn, Id, usingHeadgear);
        changingSkin = FALSE;
        skinChanged = TRUE;
        usingHeadgear = FALSE;
        botManager.RemoveBot(SourcePawn.Controller.PlayerReplicationInfo.PlayerID);
    }
}
public function bool isForbidden(string Id)
{
    local int intId;
    local int iterator;
    local bool b_crouchMod;
    
    intId = int(Id);
    b_crouchMod = Class'SFSDependencyCheckerUtility'.static.CheckForCrouchModPresence(BioPlayerController(Outer.Controller));
    if (!b_ignoreCrouchModAbsent && !b_crouchMod && intId >= 83 && intId <= 98)
    {
        log(Self.Name, "crouch mod is not present and trying to switch to squadmate look", Outer);
        Class'SFSCore'.static.getConsole().OutputText("crouch mod is not present and trying to switch to squadmate look");
        return TRUE;
    }
    foreach forbiddenIDs(iterator, )
    {
        if (iterator == intId)
        {
            Class'SFSCore'.static.getConsole().OutputText("The provided ID is forbidden for use with the changeSkin command: " $ Id);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    b_ignoreCrouchModAbsent = TRUE
    ListenedEventTypes = (SFSEventType.EVT_ChangeSkin, SFSEventType.EVT_BotSpawned)
    forbiddenIDs = (15, 
                    23, 
                    49, 
                    59, 
                    64, 
                    70, 
                    77, 
                    79, 
                    80, 
                    81, 
                    82, 
                    43, 
                    44, 
                    50, 
                    52
                   )
}