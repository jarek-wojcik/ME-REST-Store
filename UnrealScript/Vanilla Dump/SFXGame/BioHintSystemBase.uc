Class BioHintSystemBase
    native
    config(Game);

struct native SFXNotificationData 
{
    var init biodynamicload string sImageResource;
    var Name nmType;
    var Name nmRemoteEvent;
    var Name nmSound;
    var Name nmIcon;
    var stringref srTitle;
    var stringref srSubTitle;
    var stringref srBody;
    var stringref srAltTitle;
    var stringref srAltBody;
    var stringref srAltSubtitle;
    var float DisplayTime;
    var int Priority;
    var int nFlourishID;
    var bool bCanBeMerged;
    var bool bIsMini;
};
struct native SFXNotification 
{
    var init string sTitle;
    var init string sSubtitle;
    var init string sBody;
    var init biodynamicload string sImageResource;
    var Name nmType;
    var Name nmRemoteEvent;
    var Name nmSound;
    var Name nmStopSound;
    var Name nmIcon;
    var int nID;
    var int nPriority;
    var float CreationTime;
    var float fDisplayTime;
    var Texture oImage;
    var int nFlourishID;
    var int nBarPercent;
    var int Data1;
    var bool bIsMini;
    var EAsyncLoadStatus eLoadStatus;
    
    structdefaultproperties
    {
        nBarPercent = -1
    }
};
enum SFXNotificationPriotity
{
    NOTIFICATIONPRIORITY_UNDEFINED,
    NOTIFICATIONPRIORITY_NORMAL,
    NOTIFICATIONPRIORITY_HIGH,
};
struct native HintDefinition 
{
    var Name HintName;
    var Name ClearEvent;
    var Name ClearContext;
    var stringref DefaultText;
    var stringref PS3Text;
    var stringref PCText;
    var float DisplayDuration;
    var float CooldownTime;
    var float UpdateTime;
    var float TimeRemaining;
    var int MaxDifficulty;
    var Function HintFunction;
    var bool Enabled;
    var bool ImmediatelyRelevant;
    var SFXHintPosition HintPosition;
    
    structdefaultproperties
    {
        DisplayDuration = 10.0
        CooldownTime = 120.0
        UpdateTime = 1.0
        MaxDifficulty = 1
        Enabled = TRUE
        HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
    }
};
struct native HintTrackingData 
{
    var float Times[10];
    var int Num;
    var float LastTime;
    var float FirstTime;
    var int QueueHead;
};
const HistoryLength = 10;

var config array<HintDefinition> m_aHints;
var transient array<SFXNotification> m_aNotifications;
var transient array<int> m_aCurrentlyDisplayedMiniNotificationIDs;
var config array<SFXNotificationData> m_NotificationData;
var transient native Object m_mTrackingData;
var config float m_fMinimumTimeBetweenAnyHints;
var transient float m_fCurrentTime;
var transient int m_nCurrentlyDisplayedHint;
var transient int m_nCurrentlyDisplayedNotificationID;
var Texture2D m_DefaultImage;
var transient float m_fTimeSinceDisplayPossible;
var config float m_fDisplayDelay;
var config bool m_bEnabled;
var bool m_bDisabledForTutorial;
var transient bool m_bNotificationIsPaused;

public final native function AddNotification(const out SFXNotification oNotification);

public final native function AddNotification_AccomplishmentChange(string sTitle, string sSubtitle, string sBody, int currentCount, int totalCount, string sImage);

public final native function AddNotification_AccomplishmentUnlocked(const out Accomplishment Data, const out GrinderAccomplishment Grinder);

public final native function AddNotification_AmmoRecovery(int nAmount);

public event function AddNotification_BonusPower(int PlotStateID);

public final native function AddNotification_CodexChange();

public final native function AddNotification_CreditRecovery(int nAmount);

public final native function AddNotification_Custom(float nDisplayTime, string sTitle, string sSubtitle, string sBody, string sImagePath, Name nRemoteEvent, optional Name nmType, optional Name nmSound, optional int Priority = 0, optional int FlourishID = 0, optional int nBarPercent = -1, optional Name nmIcon = 'None', optional bool bMini = FALSE);

public final native function AddNotification_ElementZeroRecovery(int nAmount);

public final native function AddNotification_HeavyWeaponAmmoRecovery(int nAmount);

public final native function AddNotification_IridiumRecovery(int nAmount);

public final native function AddNotification_JournalChange();

public final native function AddNotification_MedigelRecovery(int nAmount);

public final native function AddNotification_PalladiumRecovery(int nAmount);

public final native function AddNotification_ParagonChange(int nAmount);

public final native function AddNotification_PlatinumRecovery(int nAmount);

public final native function AddNotification_RenegadeChange(int nAmount);

public final native function AddNotification_ReputationChange(int nAmount);

public event function CacheCurrentState();

public native function Clear();

public function ClearNotifications()
{
    m_nCurrentlyDisplayedNotificationID = 0;
    m_aCurrentlyDisplayedMiniNotificationIDs.Length = 0;
}
public event function CodexUpdate(stringref srTitle, stringref srDescription)
{
    AddNotification_CodexChange();
}
public final native function SFXNotificationData GetNotificationData(Name nmNotificationType);

public native function float GetPreviousTime(out HintTrackingData oData, int nAge);

public native function HintTrackingData GetTrackingData(Name nmEvent, optional Name nmContext);

public native function HintEvent(Name nmEvent, optional Name nmContext);

public final native function bool HintsEnabled();

public final native function bool IsHintsOptionDisabled();

public event function JournalUpdate(stringref srTitle, stringref srDescription)
{
    AddNotification_JournalChange();
}
public function OnNotificationDisplayCompleted(int nNotificationID)
{
    local int N;
    local SFXNotification Notification;
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    
    for (N = 0; N < m_aNotifications.Length; ++N)
    {
        if (m_aNotifications[N].nID == nNotificationID)
        {
            Notification = m_aNotifications[N];
            if (Notification.nmRemoteEvent != 'None')
            {
                oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
                if (oWorldInfo != None)
                {
                    oController = oWorldInfo.GetLocalPlayerController();
                    if (oController != None)
                    {
                        oController.CauseEvent(Notification.nmRemoteEvent);
                    }
                }
            }
            m_aNotifications.Remove(N, 1);
            if (Notification.bIsMini)
            {
                m_aCurrentlyDisplayedMiniNotificationIDs.RemoveItem(nNotificationID);
            }
            else
            {
                m_nCurrentlyDisplayedNotificationID = 0;
            }
            break;
        }
    }
}
protected final native function PopulateNotificationOneParameter(const out SFXNotificationData oNoteData, out SFXNotification oNotification, int nParam1);

public final native function ShowNotification(const out SFXNotification oNotification);

public native function Tick(float TimeDelta);

public native function float TimeSince(float fTime);

public function SetNotificationPaused(bool bVal)
{
    m_bNotificationIsPaused = bVal;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aHints = ({
                 HintName = 'TakeCoverHint', 
                 ClearEvent = 'EnterCover', 
                 ClearContext = 'None', 
                 DefaultText = $278983, 
                 PS3Text = $0, 
                 PCText = $278983, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ResurrectHint', 
                 ClearEvent = 'PowerCast', 
                 ClearContext = 'SFXPowerCustomAction_Unity', 
                 DefaultText = $278987, 
                 PS3Text = $0, 
                 PCText = $341337, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 20.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'MeleeHint', 
                 ClearEvent = 'Melee', 
                 ClearContext = 'None', 
                 DefaultText = $278986, 
                 PS3Text = $0, 
                 PCText = $341338, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'SyncMeleeHint', 
                 ClearEvent = 'BrokeMelee', 
                 ClearContext = 'None', 
                 DefaultText = $604098, 
                 PS3Text = $0, 
                 PCText = $604097, 
                 DisplayDuration = 4.0, 
                 CooldownTime = 10.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = TRUE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'ZoomHint', 
                 ClearEvent = 'Zoom', 
                 ClearContext = 'None', 
                 DefaultText = $278984, 
                 PS3Text = $0, 
                 PCText = $341341, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ManualReloadHint', 
                 ClearEvent = 'RELOAD', 
                 ClearContext = 'None', 
                 DefaultText = $278988, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'PCMappedPowerHint', 
                 ClearEvent = 'CastMappedPower', 
                 ClearContext = 'None', 
                 DefaultText = $0, 
                 PS3Text = $0, 
                 PCText = $341342, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'LeftMappedPowerHint', 
                 ClearEvent = 'CastMappedPower', 
                 ClearContext = 'None', 
                 DefaultText = $338717, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'RightMappedPowerHint', 
                 ClearEvent = 'CastMappedPower', 
                 ClearContext = 'None', 
                 DefaultText = $338718, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ClassMappedPowerHint', 
                 ClearEvent = 'CastMappedPower', 
                 ClearContext = 'None', 
                 DefaultText = $278985, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'BypassGameHint', 
                 ClearEvent = 'ClearMinigameHint', 
                 ClearContext = 'None', 
                 DefaultText = $345714, 
                 PS3Text = $0, 
                 PCText = $345714, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'HackGameHint', 
                 ClearEvent = 'ClearMinigameHint', 
                 ClearContext = 'None', 
                 DefaultText = $345715, 
                 PS3Text = $0, 
                 PCText = $345715, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'LevelUpHint', 
                 ClearEvent = 'None', 
                 ClearContext = 'None', 
                 DefaultText = $338677, 
                 PS3Text = $0, 
                 PCText = $341347, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'CooldownHint', 
                 ClearEvent = 'CastPower', 
                 ClearContext = 'None', 
                 DefaultText = $338673, 
                 PS3Text = $0, 
                 PCText = $338673, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'PlanetScanHint', 
                 ClearEvent = 'StartScanning', 
                 ClearContext = 'None', 
                 DefaultText = $345718, 
                 PS3Text = $0, 
                 PCText = $349413, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'LaunchProbeHint', 
                 ClearEvent = 'LaunchProbe', 
                 ClearContext = 'None', 
                 DefaultText = $345719, 
                 PS3Text = $0, 
                 PCText = $349414, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'FindLandingSite', 
                 ClearEvent = 'PlanetRevealAnomaly', 
                 ClearContext = 'None', 
                 DefaultText = $345721, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'UseAmmoPowerHint', 
                 ClearEvent = 'PowerCast', 
                 ClearContext = 'None', 
                 DefaultText = $349605, 
                 PS3Text = $0, 
                 PCText = $349607, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'GrenadeHint', 
                 ClearEvent = 'UsedGrenade', 
                 ClearContext = 'None', 
                 DefaultText = $720732, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ExitTurretHint', 
                 ClearEvent = 'ExitTurret', 
                 ClearContext = 'None', 
                 DefaultText = $720734, 
                 PS3Text = $0, 
                 PCText = $720736, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ChargedWeaponHint', 
                 ClearEvent = 'StartWeaponCharge', 
                 ClearContext = 'None', 
                 DefaultText = $720733, 
                 PS3Text = $0, 
                 PCText = $720735, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'MedigelHint', 
                 ClearEvent = 'PowerCast', 
                 ClearContext = 'SFXPowerCustomAction_Unity', 
                 DefaultText = $723513, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ExitAtlasHint', 
                 ClearEvent = 'ExitAtlas', 
                 ClearContext = 'None', 
                 DefaultText = $723516, 
                 PS3Text = $0, 
                 PCText = $723517, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'MapHint', 
                 ClearEvent = 'None', 
                 ClearContext = 'None', 
                 DefaultText = $727418, 
                 PS3Text = $0, 
                 PCText = $727419, 
                 DisplayDuration = 4.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'MapCharacterHint', 
                 ClearEvent = 'None', 
                 ClearContext = 'None', 
                 DefaultText = $727417, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 4.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'TutorialSingularitySelectHint', 
                 ClearEvent = 'ClearTutorialHint', 
                 ClearContext = 'None', 
                 DefaultText = $338634, 
                 PS3Text = $0, 
                 PCText = $338636, 
                 DisplayDuration = 0.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }, 
                {
                 HintName = 'TutorialSingularityHighlightHint', 
                 ClearEvent = 'ClearTutorialHint', 
                 ClearContext = 'None', 
                 DefaultText = $338639, 
                 PS3Text = $0, 
                 PCText = $338642, 
                 DisplayDuration = 0.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }, 
                {
                 HintName = 'TutorialWeaponWheelHint', 
                 ClearEvent = 'ClearTutorialHint', 
                 ClearContext = 'None', 
                 DefaultText = $338686, 
                 PS3Text = $0, 
                 PCText = $338687, 
                 DisplayDuration = 0.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }, 
                {
                 HintName = 'TutorialWeaponEquipHint', 
                 ClearEvent = 'ClearTutorialHint', 
                 ClearContext = 'None', 
                 DefaultText = $338688, 
                 PS3Text = $0, 
                 PCText = $338689, 
                 DisplayDuration = 0.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = FALSE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }, 
                {
                 HintName = 'UseReviveHint', 
                 ClearEvent = 'EndDying', 
                 ClearContext = 'None', 
                 DefaultText = $705037, 
                 PS3Text = $0, 
                 PCText = $705561, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 10.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'UseAmmoHint', 
                 ClearEvent = 'None', 
                 ClearContext = 'None', 
                 DefaultText = $705038, 
                 PS3Text = $0, 
                 PCText = $705562, 
                 DisplayDuration = 5.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'UseObjectiveHint', 
                 ClearEvent = 'ObjectiveStarted', 
                 ClearContext = 'None', 
                 DefaultText = $705039, 
                 PS3Text = $0, 
                 PCText = $705044, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 1, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'ReviveOtherHint', 
                 ClearEvent = 'StartRevive', 
                 ClearContext = 'None', 
                 DefaultText = $705040, 
                 PS3Text = $0, 
                 PCText = $705045, 
                 DisplayDuration = 5.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 1, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'SwapWeapons', 
                 ClearEvent = 'None', 
                 ClearContext = 'None', 
                 DefaultText = $705041, 
                 PS3Text = $0, 
                 PCText = $705046, 
                 DisplayDuration = 5.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 1, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'ObjectiveHint', 
                 ClearEvent = 'ObjectiveStarted', 
                 ClearContext = 'None', 
                 DefaultText = $705043, 
                 PS3Text = $0, 
                 PCText = $705043, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Bottom
                }, 
                {
                 HintName = 'DyingHint', 
                 ClearEvent = 'EndDying', 
                 ClearContext = 'None', 
                 DefaultText = $705042, 
                 PS3Text = $0, 
                 PCText = $705047, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 30.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 3, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Middle
                }, 
                {
                 HintName = 'Objective30sHint', 
                 ClearEvent = 'ObjectiveStarted', 
                 ClearContext = 'None', 
                 DefaultText = $723515, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 10.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 1, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }, 
                {
                 HintName = 'ReviveSystemHint', 
                 ClearEvent = 'StartRevive', 
                 ClearContext = 'None', 
                 DefaultText = $723514, 
                 PS3Text = $0, 
                 PCText = $0, 
                 DisplayDuration = 5.0, 
                 CooldownTime = 120.0, 
                 UpdateTime = 1.0, 
                 TimeRemaining = 0.0, 
                 MaxDifficulty = 1, 
                 HintFunction = None, 
                 Enabled = TRUE, 
                 ImmediatelyRelevant = FALSE, 
                 HintPosition = SFXHintPosition.SFXHINTPOS_Top
                }
               )
    m_NotificationData = ({
                           sImageResource = "GUI_Icons.Notifications.NT_Jourdex_256x128", 
                           nmType = 'JournalChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Info', 
                           srTitle = $325623, 
                           srSubTitle = $325623, 
                           srBody = $325624, 
                           srAltTitle = $0, 
                           srAltBody = $325624, 
                           srAltSubtitle = $0, 
                           DisplayTime = 5.0, 
                           Priority = 100, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.NT_Jourdex_256x128", 
                           nmType = 'CodexChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Info', 
                           srTitle = $325625, 
                           srSubTitle = $325625, 
                           srBody = $325626, 
                           srAltTitle = $0, 
                           srAltBody = $325626, 
                           srAltSubtitle = $0, 
                           DisplayTime = 5.0, 
                           Priority = 80, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'AccomplishmentChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Medal', 
                           srTitle = $337484, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.5, 
                           Priority = 110, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.NT_LevelUp_256x128", 
                           nmType = 'LevelUp', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'LevelUp', 
                           nmIcon = 'LevelUp', 
                           srTitle = $335589, 
                           srSubTitle = $335590, 
                           srBody = $339898, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.5, 
                           Priority = 120, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'TechRecovered', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUTech', 
                           nmIcon = 'Info', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'WeaponRecovered', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUWeapon', 
                           nmIcon = 'Weapon', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'ResearchRecovered', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUResearch', 
                           nmIcon = 'Info', 
                           srTitle = $348810, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 3.0, 
                           Priority = 24, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'TechUnlocked', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUUpgrade', 
                           nmIcon = 'Info', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 3.0, 
                           Priority = 24, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'MediGelFull', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUFullError', 
                           nmIcon = 'Medigel', 
                           srTitle = $341941, 
                           srSubTitle = $341942, 
                           srBody = $339913, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'HeavyAmmoFull', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUFullError', 
                           nmIcon = 'heavyAmmo', 
                           srTitle = $341982, 
                           srSubTitle = $341983, 
                           srBody = $339906, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 27, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'AccomplishmentUnlocked', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Medal', 
                           srTitle = $337484, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.5, 
                           Priority = 120, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.NT_Store_256x1286", 
                           nmType = 'StoreItemPurchased', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $568536, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'MPMedalUnlocked', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Medal', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.5, 
                           Priority = 110, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.NT_Credits_256x128", 
                           nmType = 'AllianceCredits', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'MPBonusCreditsEarned', 
                           nmIcon = 'None', 
                           srTitle = $694486, 
                           srSubTitle = $694488, 
                           srBody = $694489, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.NT_Armor_256x128", 
                           nmType = 'ArmorTreasure', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUGeneric', 
                           nmIcon = 'None', 
                           srTitle = $700062, 
                           srSubTitle = $0, 
                           srBody = $700063, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'WeaponModRecovered', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUGeneric', 
                           nmIcon = 'Weapon', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 23, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'TreasureError', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUFullError', 
                           nmIcon = 'Weapon', 
                           srTitle = $0, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 6.0, 
                           Priority = 500, 
                           nFlourishID = 1, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'SupplyDrop', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUGeneric', 
                           nmIcon = 'salvage', 
                           srTitle = $664015, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.5, 
                           Priority = 110, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_WarAssets_256x128", 
                           nmType = 'GAWAsset', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'MPMatchResultsEventGAWGlobal', 
                           nmIcon = 'None', 
                           srTitle = $709388, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_WarAssets_256x128", 
                           nmType = 'GAWModifier', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $723562, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                           nmType = 'GAWArtifact', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $652430, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_Intel_256x128", 
                           nmType = 'GAWIntel', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $650543, 
                           srSubTitle = $0, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_Salvage_256x128", 
                           nmType = 'GAWSalvage', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $282809, 
                           srSubTitle = $325627, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                           nmType = 'GAWArtifactCredits', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'None', 
                           srTitle = $652430, 
                           srSubTitle = $325627, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "GUI_Icons.Notifications.GM_BonusPower_256x128", 
                           nmType = 'BonusPower', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUGeneric', 
                           nmIcon = 'None', 
                           srTitle = $338032, 
                           srSubTitle = $724086, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $170915, 
                           DisplayTime = 4.0, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = FALSE, 
                           bIsMini = FALSE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'CreditRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Credits', 
                           srTitle = $325627, 
                           srSubTitle = $325628, 
                           srBody = $339915, 
                           srAltTitle = $339723, 
                           srAltBody = $0, 
                           srAltSubtitle = $325927, 
                           DisplayTime = 1.5, 
                           Priority = 10, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'MedigelRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUMediGel', 
                           nmIcon = 'Medigel', 
                           srTitle = $325629, 
                           srSubTitle = $325630, 
                           srBody = $339913, 
                           srAltTitle = $339620, 
                           srAltBody = $0, 
                           srAltSubtitle = $325928, 
                           DisplayTime = 1.5, 
                           Priority = 25, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'ParagonChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Paragon', 
                           srTitle = $325631, 
                           srSubTitle = $325632, 
                           srBody = $339912, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 50, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'RenegadeChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Renegade', 
                           srTitle = $325633, 
                           srSubTitle = $325634, 
                           srBody = $339911, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 51, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'ReputationChange', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'Reputation', 
                           srTitle = $0, 
                           srSubTitle = $724394, 
                           srBody = $0, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 51, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'IridiumRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'mineral2', 
                           srTitle = $325637, 
                           srSubTitle = $325638, 
                           srBody = $339910, 
                           srAltTitle = $339690, 
                           srAltBody = $0, 
                           srAltSubtitle = $325930, 
                           DisplayTime = 1.5, 
                           Priority = 30, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'PalladiumRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'mineral3', 
                           srTitle = $325639, 
                           srSubTitle = $325640, 
                           srBody = $339909, 
                           srAltTitle = $339695, 
                           srAltBody = $0, 
                           srAltSubtitle = $325931, 
                           DisplayTime = 1.5, 
                           Priority = 31, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'PlatinumRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'mineral4', 
                           srTitle = $325641, 
                           srSubTitle = $325642, 
                           srBody = $339908, 
                           srAltTitle = $339715, 
                           srAltBody = $0, 
                           srAltSubtitle = $325932, 
                           DisplayTime = 1.5, 
                           Priority = 32, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'ElementZeroRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'mineral1', 
                           srTitle = $325643, 
                           srSubTitle = $325644, 
                           srBody = $339907, 
                           srAltTitle = $339717, 
                           srAltBody = $0, 
                           srAltSubtitle = $325933, 
                           DisplayTime = 1.5, 
                           Priority = 35, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'HeavyWeaponAmmoRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUAmmoHeavy', 
                           nmIcon = 'heavyAmmo', 
                           srTitle = $325645, 
                           srSubTitle = $325646, 
                           srBody = $339906, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 27, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'AmmoRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'PUGeneric', 
                           nmIcon = 'Ammo', 
                           srTitle = $325647, 
                           srSubTitle = $325647, 
                           srBody = $325648, 
                           srAltTitle = $0, 
                           srAltBody = $325935, 
                           srAltSubtitle = $0, 
                           DisplayTime = 2.0, 
                           Priority = 27, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'XpReceived', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'XP', 
                           srTitle = $335587, 
                           srSubTitle = $335588, 
                           srBody = $339899, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $0, 
                           DisplayTime = 1.5, 
                           Priority = 105, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }, 
                          {
                           sImageResource = "", 
                           nmType = 'SalvageRecovery', 
                           nmRemoteEvent = 'None', 
                           nmSound = 'None', 
                           nmIcon = 'salvage', 
                           srTitle = $340286, 
                           srSubTitle = $325628, 
                           srBody = $340288, 
                           srAltTitle = $0, 
                           srAltBody = $0, 
                           srAltSubtitle = $325927, 
                           DisplayTime = 1.5, 
                           Priority = 11, 
                           nFlourishID = 0, 
                           bCanBeMerged = TRUE, 
                           bIsMini = TRUE
                          }
                         )
    m_fMinimumTimeBetweenAnyHints = 10.0
    m_nCurrentlyDisplayedHint = -1
    m_DefaultImage = Texture2D'GUI_GlobalIcons.Notifications.GenericInfoIcon_256'
    m_fDisplayDelay = 2.0
    m_bEnabled = TRUE
}