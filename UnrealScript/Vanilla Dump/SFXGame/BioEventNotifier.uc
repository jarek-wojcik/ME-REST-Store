Class BioEventNotifier
    native
    config(UI);

enum BioQuestEventTypes
{
    QET_New,
    QET_Updated,
    QET_Completed,
};
struct native BioTalentNotice 
{
    var string sName;
    var int nIcon;
    var BioPawn oCharacter;
};
struct native BioDisplayNotice 
{
    var string strTitle;
    var int nEventType;
    var int nTimeToLive;
    var int nIconIndex;
    var int nContext;
    var stringref srTitle;
    var int nQuantity;
    var int nQuantMin;
    var int nQuantMax;
};
enum BioNoticeContexts
{
    NOTICE_CONTEXT_JOURNAL,
    NOTICE_CONTEXT_CODEX,
    NOTICE_CONTEXT_INVENTORY,
    NOTICE_CONTEXT_PARTYLEVEL,
    NOTICE_CONTEXT_XP,
    NOTICE_CONTEXT_MEDIGEL,
    NOTICE_CONTEXT_SALVAGE,
    NOTICE_CONTEXT_CREDITS,
    NOTICE_CONTEXT_GRENADES,
    NOTICE_CONTEXT_PARAGON,
    NOTICE_CONTEXT_RENEGADE,
    NOTICE_CONTEXT_AREAMAP,
    NOTICE_CONTEXT_ABILITY,
};
enum BioNoticeIcons
{
    NOTICE_ICON_UNASSIGNED_0,
    NOTICE_ICON_QUEST_UPDATE,
    NOTICE_ICON_LEVELUP,
    NOTICE_ICON_DEFICIENCY,
    NOTICE_ICON_XP,
    NOTICE_ICON_PARAGON,
    NOTICE_ICON_RENEGADE,
    NOTICE_ICON_OMNITOOL,
    NOTICE_ICON_BIOAMP,
    NOTICE_ICON_XMOD,
    NOTICE_ICON_CODEX_ADDED,
    NOTICE_ICON_COIN,
    NOTICE_ICON_MEDIGEL,
    NOTICE_ICON_SALVAGE,
    NOTICE_ICON_PISTOL,
    NOTICE_ICON_SHOTGUN,
    NOTICE_ICON_ASSAULT_RIFLE,
    NOTICE_ICON_SNIPER_RIFLE,
    NOTICE_ICON_ARMOR,
    NOTICE_ICON_GRENADE,
    NOTICE_ICON_QUEST_ADDED,
    NOTICE_ICON_AREAMAPNODE,
};
enum BioNoticeDisplayTypes
{
    NOTICE_TYPE_DELTA,
    NOTICE_TYPE_TEXT,
    NOTICE_TYPE_QUANTITY,
    NOTICE_TYPE_QUANTITY_TEXT,
};

var transient array<BioDisplayNotice> m_lstNotices;
var transient array<BioTalentNotice> m_lstTalentNotices;
var config string sWwiseMusicVolumeRTPCName;
var config string sWwiseParaReneRTPCName;
var transient BioPawn TalentNoticeInputCharacter;
var transient BioSFHandler_MessageBox m_oTalentNotifyBoxHandler;
var config stringref srTalentOk;
var config stringref srTalentSkipRemainder;
var config stringref srLevelUp;
var config stringref srQuestAdded;
var config stringref srQuestUpdated;
var config stringref srQuestCompleted;
var config stringref srCodexEntry;
var config stringref srParagonReceived;
var config stringref srRenegadeReceived;
var config stringref srMedigel;
var config stringref srSalvage;
var config stringref srMap;
var config stringref srAbility;
var config int nParagonPlotVar;
var config int nRenegadePlotVar;
var config int nWwiseMusicVolumeRTPCPlotVar;
var config float fPassivePopupDisplayTime;
var transient bool m_bNoticesNotarized;
var transient bool m_bEnabled;
var transient bool m_bTalentNoticeReady;
var transient bool m_bHUDAcknowledgedTalentNotify;
var config bool bDissableTallentNotifications;

public final native function AddNotice(int nType, int nContext, int nTimeToLive, int nIconIndex, stringref srTitle, string strTitle, optional int nQuantity = 0, optional int nQuantMin = 0, optional int nQuantMax = 0);

public final native function AddTalentNotifyString(int nTalentIcon, string sTalentName, BioPawn pPawn);

public final native function AddTalentNotifyStringRef(int nTalentIcon, stringref srTalentName, BioPawn pPawn);

public native function HasListChanged();

public native function NotarizeNotices();

public final native function OnTalentNoticeInput(bool bAPressed, int nContext);

public final native function bool PendingTalentNotify(BioPawn oCharacter);

public final native function RemoveTalentNotify(BioPawn oCharacter);

public native function RetrieveNotices(out array<BioDisplayNotice> lstNotices);

public final native function ShowTalentNotify(BioPawn oCharacter);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    sWwiseMusicVolumeRTPCName = "Music_Current_Plot_State"
    sWwiseParaReneRTPCName = "Player_Para_Rene_State"
    srTalentOk = $152938
    srTalentSkipRemainder = $168919
    srLevelUp = $143387
    srQuestAdded = $143385
    srQuestUpdated = $143386
    srQuestCompleted = $152941
    srCodexEntry = $143384
    srParagonReceived = $156472
    srRenegadeReceived = $156473
    srMedigel = $171472
    srSalvage = $171473
    srMap = $166288
    srAbility = $167873
    nParagonPlotVar = 2
    nRenegadePlotVar = 3
    nWwiseMusicVolumeRTPCPlotVar = 9
    fPassivePopupDisplayTime = 3.0
    m_bEnabled = TRUE
    m_bHUDAcknowledgedTalentNotify = TRUE
    bDissableTallentNotifications = TRUE
}