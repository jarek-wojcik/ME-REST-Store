Class BioRemoteLogger
    native
    transient;

enum sessionStatus
{
    SESSION_INACTIVE,
    SESSION_ACTIVE,
};
enum eventMPEnumID
{
    ENEMY_SPAWNED,
    ENEMY_DIED,
    SHIELDS_DOWN,
    PLAYER_DOWNED,
    REVIVAL_STARTED,
    REVIVAL_CANCELLED,
    PLAYER_REVIVED,
    SHIELD_RESTORED,
    WEAPON_PICKED_UP,
    SWITCH_WEAPON,
    RELOAD,
    AMMO_PICKED_UP,
    HEAVY_MELEE,
    CUSTOM_ACTION_IMPACT,
    CAST_POWER,
    POWER_IMPACT,
    PROJECTILE_CREATED,
    PROJECTILE_EXPLODED,
    ANIMATED_REACTION,
    START_CLIMBING_LADDER,
    FINISH_CLIMBING_LADDER,
    Roll,
    ENTER_COVER,
    EXIT_COVER,
    COVER_SLIP,
    SWAT_TURN,
    Mantle,
    GAME_STARTED,
    WAVE_STARTED,
    WAVE_COMPLETED,
    ALL_WAVES_COMPLETED,
    GAME_OVER,
    ANNEX_STARTED,
    ENTER_ANNEX_ZONE,
    LEAVE_ANNEX_ZONE,
    ANNEX_COMPLETE,
    LAG_REPORTED,
    LOW_FRAMERATE,
    BANDWIDTH_SATURATED,
    CUSTOM_ACTION_STARTED,
    NET_PERF_REPORTED,
    CUSTOM_EVENT_REPORTED,
    LOG_SPAM,
    POWER_SUBSEQUENT_IMPACT,
};
enum eventEnumID
{
    OUT_OF_WORLD,
    OUT_OF_TEXTUREMEMORY,
    OUT_OF_SYSTEMMEMORY,
    COMBAT_START,
    COMBAT_END,
    GAME_START,
    GAME_END,
    GAME_LOADGAME,
    GAME_SAVEGAME,
    GAME_PROFILINGTIME,
    CONVERSATION_MISSINGVO,
    CONVERSATION_MISSINGLIPSYNC,
    CONVERSATION_FAILEDSTAGING,
    CONVERSATION_START,
    CONVERSATION_END,
    CONVERSATION_SKIPPEDLINE,
    CONVERSATION_SELECTRESPONSE,
    CONVERSATION_NODETRANSITION,
    PAWN_DEATH,
    PAWN_LEVELUP,
    PAWN_FAILEDPATHFIND,
    PAWN_TELEPORT,
    PAWN_USEPLACEABLE,
    PAWN_USEPOWER,
    PAWN_USEGRENADE,
    OUT_OF_TRIGGERSTREAM,
    BAD_STREAMING,
    SLOW_STREAMING,
    ERROR_LOADING,
    ERROR_NOAREAMAP,
    GAME_ENTERMAP,
    GAME_EXITMAP,
    PLACEABLE_STATECHANGE,
    PLOTSTATE_CHANGE,
    GAME_STATISTICS,
    SCRIPTING_FAILED,
    SCRIPTING_PASSED,
    USE_COVER,
    TREASURE,
    MISC_DEBUG,
    PURPLE_LEVEL,
    USE_ZOOM,
    PLAYER_DEALTDAMAGE,
    PLAYER_TOOKDAMAGE,
    PLAYER_FIREDWEAPON,
    PLAYER_DREWWEAPON,
    PLAYER_OBTAINEDMEDIGEL,
    PLAYER_OBTAINEDCREDITS,
    PLAYER_STARTEDSTORM,
    PLAYER_ENDEDSTORM,
    AUTOMATION_START,
    AUTOMATION_WARNING,
    AUTOMATION_ERROR,
    AUTOMATION_PRINT,
    AUTOMATION_END,
    AUTOMATION_OPERROR,
    TEXTUREMEMORY_SACRIFICED,
    PAWN_KILL_INFO,
    PLAYER_OBTAINEDEEZO,
    PLAYER_OBTAINEDIRIDIUM,
    PLAYER_OBTAINEDPALLADIUM,
    PLAYER_OBTAINEDAMMO,
    PLAYER_OBTAINEDPLATINUM,
    TEXTUREMEMORY_FACTOR,
    PLAYER_OBTAINEDPROBES,
    BLOCKING_ADDTOWORLD,
    ENDGM1,
    ENDGM2,
    ENDGM3,
    PLAYER_OUTOFAMMO,
    PAWN_AIBARK,
    CONVERSATION_ENTRYNODE,
    CONVERSATION_REPLYNODE,
    CONVERSATION_MISCLOG,
    PLAYER_NOTFUN,
    CONVAMBIENT_IGNOREBODYGESTURESNOTSET,
    STRREF_NOT_FOUND,
    PLAYER_OBTAINEDFUEL,
    VSYNC_ENABLED,
    LEVEL_LOAD_TIME,
    BLAZE_LOGIN_INFO,
    BLAZE_TELEMETRY,
    STRING_LAST_USE,
    PLAYER_OBTAINEDGRENADE,
    UNIT_TEST_RESULT,
    PACKAGE_HAS_LOAD_WARNINGS,
    PACKAGE_HAS_LOAD_ERRORS,
    KISMET_MAP_REFERENCE,
    KISMET_SEQUENCE_COUNT,
    PATHNODE_NETWORK_SIZE,
    PATHNODE_COUNT,
    PATHNODE_ONE_WAY,
    PATHNODE_DESTINATION_ONLY,
    PATHNODE_UNMATCHED,
    PATHNODE_SOURCE_ONLY,
    JUMPNODE_BAD_DISTANCE,
    JUMPNODE_NO_BLOCKVOL,
    BLOCKING_VOLUME_COUNT,
    BLOCKING_VOLUME_COMPLEXCOLLISION,
    TEXTURE_SIZE,
    TEXTURE_NOMIPS,
    PAWN_LOC_ONPLAYERDEATH,
    PLAYER_LOC_ONPAWNDEATH,
    PLAYER_OBTAINEDPICKUP,
    DRAWSCALE_NEARZERO,
    DRAWSCALE_PHYSICS_INVALID,
    PATHNODE_OUTSIDE_STREAMINGTRIGGER,
    PATHNODE_LINKED_EXTERNAL_CHUNKS,
    HENCHMEN_SELECTED,
    MAP_PLAYED_THROUGH_COMPLETELY,
    FAST_RESUME_LOAD_TIME,
    GAWLOG_AWARD_ASSET,
    GAWLOG_MODIFY_ASSET,
    GAWLOG_END_GAME_OPTIONS,
    GAWLOG_ENG_GAME_OPTION_CHOSEN,
    GAWLOG_CONFLICT_ZONE_UPDATED,
    GAWLOG_PLACEHOLDER_2,
    GAWLOG_PLACEHOLDER_3,
    CONVERSATION_PLAYEDFOVO,
    KISMET_DUPLICATE_EVENT_COUNT,
};
const SKYNET_MULTIPLAYERMODE = 0x0100;
const SKYNET_SENDNUCLEUSTELEMETRY = 0x0080;
const SKYNET_SCRUBTEST = 0x0040;
const SKYNET_AUTOFPS = 0x0020;
const SKYNET_TEMP = 0x0010;
const SKYNET_DISPLAYSESSION = 0x0008;
const SKYNET_VERBOSELOGGING = 0x0004;
const SKYNET_SILENTMODE = 0x0002;
const SKYNET_HIGHRESPATHS = 0x0001;
const SkyNetCommonEvent_AREA_DETAILS = 12200;
const SkyNetCommonEvent_CHEATHOOK = 12100;
const SkyNetCommonEvent_SCREENSHOT = 12005;
const SkyNetCommonEvent_WARNING = 12002;
const SkyNetCommonEvent_ASSERT = 12001;
const SkyNetCommonEvent_CRASH = 12001;
const SkyNetCommonEvent_MOVE = 12000;
const SkyNetCommonEvent_AreaEntered = 8;
const SkyNetCommonEvent_AreaExited = 9;

var const native noexport Pointer VfTable_FCallbackEventDevice;
var Double m_LastEventSent;
var const string NoString;
var string m_sRunMessage;
var string m_sCurrentTest;
var string m_sCurrentTestCasePath;
var string m_UserName;
var string m_remoteScreenshotPath;
var string m_remoteSavegamePath;
var string m_sCampaignName;
var string m_serverIP;
var string m_FormattedMapName;
var string m_LevelName;
var string m_TriggerDesignName;
var string m_TriggerDesignStateName;
var string m_TriggerArtInChunkName;
var string m_PlayerWeapon;
var string m_PlayerClass;
var string m_sLogString;
var string m_MPEventEmailAddress;
var string m_MPEventSubjectLine;
var string m_QueuedEventsBuffer;
var Vector m_PlayerLocation;
var Vector m_PlayerLocationLastInfo;
var int m_sessionID;
var int m_sessionStatus;
var int m_gameID;
var int m_runID;
var int m_runStatus;
var int m_nCurrentTestPlanID;
var int m_Interface;
var int m_enabled;
var int m_KeepAlive;
var int m_port;
var int m_LogStringUsage;
var int m_GameMode;
var int m_online;
var float m_LastPacketTime;
var int m_testFlags;
var int m_LogLineCount;
var int m_AnnounceRetryCount;
var int m_CampaignRetryCount;
var int m_MultiplayerStartIndex;
var float m_EventDelay;
var int m_QueuedEventsBufferIndex;
var int m_NumQueuedEvents;
var int m_MaxQueuedEvents;
var int m_MaxQueuedMessageLength;
var bool m_bSendTPMPackets;
var bool m_PlayerInCover;
var bool m_PlayerIsFiring;
var bool m_PlayerIsGhosting;

private final native function bool EventEnabled(int nEventID);

public final exec native function bool GetFlag(int nFlag);

public final native function int GetGameID();

public final native function int GetGameMode();

public static final native function BioRemoteLogger GetLogger();

public event function string GetRemoteSavegamePath()
{
    return m_remoteSavegamePath;
}
public final native function int GetRunID();

public final native function int GetSessionBuild();

public final native function int GetSessionID();

public final native function int GetSessionStatus();

public final native function int GetTPMLoggingEnabled();

public final native function SendAreaEnteredEvent();

public final native function SendAssertEvent(int nLineNumber, string sAssertFileName, string sAssertMessage);

public final exec native function SendBugReport(float fX, float fY, float fZ, float fOrientation, int nWeaponType, int nWeaponMod, int nArmourType, int nArmourMod, string sPartyMember1, string sPartyMember2, bool bIsPercievingEnemy, string sBugDescription, string sEmailAddress);

public final exec native function SendCustomEvent(string sPacketHandler, int nLogEventID, float fX, float fY, float fZ, string sAreaName, string sNameObject, string sNameTarget, int nIntVal1, int nIntVal2, string sString1, string sString2, int nObjectType, bool bIsPartyMember);

public final exec native function SendCustomEventFloat(string sPacketHandler, int nLogEventID, float fX, float fY, float fZ, string sAreaName, string sNameObject, string sNameTarget, float fData0, float fData1, string sString1, string sString2, int nObjectType, bool bIsPartyMember);

public final exec native function SendDebugEmail(string sEmailDestination, string sEmailSubject, int nExceptionType, optional string sEmailBody);

public final exec native function SendEvent(int nLogEventID, float fX, float fY, float fZ, string sAreaName, string sNameObject, string sNameTarget, int nIntVal1, int nIntVal2, string sString1, string sString2, int nObjectType, int bIsPartyMember);

public final exec native function SendEventFloat(int nLogEventID, float fX, float fY, float fZ, string sAreaName, string sNameObject, string sNameTarget, float fData0, float fData1, string sString1, string sString2, int nObjectType, int bIsPartyMember);

public final native function SendFastResumeLoaded(string LevelName, float fTime, bool bRunningOffMedia);

public final native function SendFPSTest();

public final native function SendHardwareInfoMessage();

public final native function SendInvalidPlaythrough(string sCheat);

public final native function SendLevelLoaded(string LevelName, string LevelFrom, float fTime, bool bRunningOffMedia);

public final native function SendMapEvent(int nLogEventID, Vector pos, string sString1, string sString2, string sString3, string sString4, int nInt1, int nInt2, int nInt3, int nInt4);

public final exec native function SendMPEvent(eventMPEnumID eLogEvent, float fX, float fY, float fZ, string sNameObject, string sNameTarget, int nIntVal1, int nIntVal2);

public final exec native function SendMPEventEmail(int nEventID, string sEventName, string sEventInfo);

public final exec native function SendMPEventFloat(eventMPEnumID eLogEvent, float fX, float fY, float fZ, string sNameObject, string sNameTarget, float fData);

public final native function SendNewCampaignMessage();

public final native function SendPlayerEvent(int nLogEventID, string sString1, string sString2, string sString3, string sString4, int nInt1, int nInt2, int nInt3, int nInt4);

public final native function SendPlayerEventFloat(int nLogEventID, string sString1, string sString2, string sString3, string sString4, float fData0, float fData1, int nInt3, int nInt4);

public final native function SendPurpleLevel(string sObjRefName, string sObjLeakedName);

public final native function SendQAEvent(int nMessageEventId, string sType, string sLogMsg, string sCurrentMessage);

public final exec native function SendStatistic(string sStatisticName, string sOperationType, float fData);

public final native function SendStringLastUsed(int nStringID);

public final native function SendStrRefNotFound(int nStrRef);

public final native function SendTextureMemorySacrificed(int nOldTextureMemoryLimit);

public final native function SendTPMEvent(string sMessage);

public event function SendTPMMessage(string sMessage)
{
    if (m_bSendTPMPackets)
    {
        SendTPMEvent("TP" $ sMessage);
    }
}
public final exec native function SendUnitTestInfo(int testType, string className, string methodName, int successType);

public final exec native function SetFlag(int nFlag, bool bVal);

public final native function SetGameID(int NewGameID);

public final native function SetTPMLoggingEnabled(bool enable);

public final native function string ShortName(Object o);

public final exec native function SkynetScreenshot(string sScreenshotName);

public event function TAdd(string sTestName, string sTestCaseString)
{
    m_sCurrentTest = sTestName;
    if (m_nCurrentTestPlanID == 0)
    {
    }
    else
    {
        m_sCurrentTestCasePath = sTestCaseString;
        SendTPMMessage("SetTestCaseResult~" $ m_sCurrentTestCasePath $ "~FAIL");
        return;
    }
}
public final exec native function ToggleFlag(int nFlag);

public event function TPMCheckinTestPlan()
{
    if (m_nCurrentTestPlanID == 0)
    {
    }
    else
    {
        SendTPMMessage("Submit~" $ m_nCurrentTestPlanID);
    }
}
public event function TPMCheckoutTestPlan(int nTestPlanID)
{
    if (nTestPlanID == 0)
    {
    }
    else
    {
        m_nCurrentTestPlanID = nTestPlanID;
        SendTPMMessage("CheckOutTestPlan~" $ m_nCurrentTestPlanID);
        SendTPMMessage("SetBuildLabel~" $ GetSessionBuild());
    }
}
public event function TRun(int nResult)
{
    if (m_sCurrentTest == "")
    {
    }
    else if (m_sCurrentTestCasePath == "")
    {
    }
    else if (m_nCurrentTestPlanID == 0)
    {
    }
    else if (nResult == 1)
    {
        SendTPMMessage("SetTestCaseResult~" $ m_sCurrentTestCasePath $ "~PASS");
    }
    else
    {
        SendTPMMessage("SetTestCaseResult~" $ m_sCurrentTestCasePath $ "~FAIL");
    }
}
public static function SendVocalizationEvent(Name SpeakerTag, Name Sound)
{
    GetLogger().SendPlayerEvent(70, "" $ SpeakerTag, " ", "" $ Sound, " ", 0, 0, 0, 0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_MPEventEmailAddress = "ME3MPSkyNetEventNotification@bioware.com"
    m_MPEventSubjectLine = "ME3 Multiplayer SkyNet Event Notification"
    m_MultiplayerStartIndex = 60000
}