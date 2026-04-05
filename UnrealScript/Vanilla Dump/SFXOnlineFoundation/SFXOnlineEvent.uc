Class SFXOnlineEvent
    native;

enum SFXOnlineEventStatus
{
    SFXONLINE_EVENT_STATUS_NONE,
    SFXONLINE_EVENT_STATUS_PENDING,
    SFXONLINE_EVENT_STATUS_COMPLETE,
};
enum SFXOnlineEventStatusFinished
{
    SFXONLINE_EVENT_STATUS_FINISHED_SUCCESS,
    SFXONLINE_EVENT_STATUS_FINISHED_FAILED,
    SFXONLINE_EVENT_STATUS_FINISHED_CANCELED,
    SFXONLINE_EVENT_STATUS_FINISHED_TIMEOUT,
};
enum SFXOnlineEventType
{
    SFXONLINE_EVENT_NONE,
    SFXONLINE_EVENT_TICK,
    SFXONLINE_EVENT_TIMER,
    SFXONLINE_EVENT_MP_GAME_STATUS_CHANGE,
    SFXONLINE_EVENT_PLATFORM_CONTROLLERCHANGE_0,
    SFXONLINE_EVENT_PLATFORM_CONTROLLERCHANGE_1,
    SFXONLINE_EVENT_PLATFORM_CONTROLLERCHANGE_2,
    SFXONLINE_EVENT_PLATFORM_CONTROLLERCHANGE_3,
    SFXONLINE_EVENT_PLATFORM_CONNECT,
    SFXONLINE_EVENT_PLATFORM_DISCONNECT,
    SFXONLINE_EVENT_PLATFORM_LOGINCHANGE_0,
    SFXONLINE_EVENT_PLATFORM_LOGINCHANGE_1,
    SFXONLINE_EVENT_PLATFORM_LOGINCHANGE_2,
    SFXONLINE_EVENT_PLATFORM_LOGINCHANGE_3,
    SFXONLINE_EVENT_PLATFORM_UI_OPEN,
    SFXONLINE_EVENT_PLATFORM_UI_CLOSE,
    SFXONLINE_EVENT_PLATFORM_LOGINCANCEL,
    SFXONLINE_EVENT_PLATFORM_LOGINSUCCESS,
    SFXONLINE_EVENT_PLATFORM_UI_KEYBOARD,
    SFXONLINE_EVENT_LOGIN_SIGNED_IN,
    SFXONLINE_EVENT_UTIL_GET_CONFIG_SECTION,
    SFXONLINE_EVENT_ACHIEVEMENT_GRANT,
    SFXONLINE_EVENT_QUICKMATCH,
    SFXONLINE_EVENT_INVITE,
    SFXONLINE_EVENT_SEEN_PLAYER,
    SFXONLINE_EVENT_NETWORK_WAIT_START,
    SFXONLINE_EVENT_NETWORK_WAIT_FINISHED,
};

var string ErrorString;
var int EventId;
var float TimeOut;
var float StartTime;
var float EndTime;
var int errorCode;
var bool IsUnique;
var bool TimeOutEnabled;
var SFXOnlineEventType EventType;
var SFXOnlineEventStatus CurrentStatus;
var SFXOnlineEventStatusFinished Outcome;
var SFXOnlineErrorContext ErrorContext;

public final native function DisableTimeout();

public native function DumpEventInfo();

public final native function EnableTimeout();

public final native function float GetEndTime();

public final native function int GetErrorCode();

public final native function string GetErrorString();

public final native function int GetEventId();

public static native function string GetEventOutcomeAsString(SFXOnlineEventStatusFinished oEventOutcome);

public static native function string GetEventStatusAsString(SFXOnlineEventStatus eStatusStatus);

public final native function SFXOnlineEventType GetEventType();

public static native function string GetEventTypeAsString(SFXOnlineEventType eEventType);

public static native function SFXOnlineEventType GetEventTypeFromString(string sEventString);

public final native function SFXOnlineEventStatusFinished GetOutcome();

public final native function float GetStartTime();

public final native function SFXOnlineEventStatus GetStatus();

public final native function float GetTimeDifference(optional float CurrentTime = 0.0);

public final native function float GetTimeout();

public final native function bool HasTimedOut();

public final native function bool IsCanceled();

public final native function bool IsComplete();

public final native function bool IsCompleteAndSucceeded();

public final native function bool IsInError();

public final native function bool IsPending();

public final native function bool IsSucceeded();

public final native function bool IsTimeoutEnabled();

public final native function SetEndTime(float CurrentTime);

public final native function SetErrorCode(int nCode);

public final native function SetErrorString(string sMessage);

public final native function SetEventId(int nNewEventId);

public final native function SetEventType(SFXOnlineEventType eNewEventType);

public final native function SetOutcome(SFXOnlineEventStatusFinished eStatusFinished);

public final native function SetStartTime(float CurrentTime);

public final native function SetStatus(SFXOnlineEventStatus eNewStatus);

public final native function SetTimeout(float fEventTimeout);

public native function Update(SFXOnlineEvent oEvent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventId = -1
    TimeOut = -1.0
    errorCode = 1
    IsUnique = TRUE
}