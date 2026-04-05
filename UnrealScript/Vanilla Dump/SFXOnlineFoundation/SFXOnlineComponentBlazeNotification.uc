Class SFXOnlineComponentBlazeNotification extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentNotification)
    native
    config(Engine);

enum EDownloadDataStep
{
    DDS_Init,
    DDS_GalaxyAtWarLevel,
    DDS_BinaryLiveIniData,
    DDS_LiveTlkTable,
    DDS_GetLeaderboardList,
    DDS_ReadPlayerStorage,
};

var const native noexport Pointer VfTable_FCallbackEventDevice;
var const native noexport Pointer VfTable_IISFXOnlineComponentNotification;
var transient native array<SFXOnlineMOTDInfo> m_aMOTDInfo;
var transient native string StoreCatalogId;
var transient native array<SFXOnlineEntitlementLookupInfo> m_aEntitlementInfo;
var transient native string m_sDimeConfig;
var native Pointer m_pBlazeUtil;
var transient native int m_PendingLiveBINIVersion;
var transient native int m_LiveBINIVersion;
var transient native int CerberusOfferId;
var config stringref PRCMessageTitle;
var config stringref AllianceNewsItemMessageTitle;
var transient native bool m_LiveBINIUpdated;
var transient native bool m_FetchingLiveBINIData;
var config bool m_DisableLiveBINI;
var config bool bSkipLiveINIUpdateOnLogin;
var EDownloadDataStep m_CurrentDownloadStep;

public native function AdvanceToNextRequest();

private final native function bool CheckMessageAgainstDR(int i);

public native function FetchOfflineEntitlementStoreMappings();

public native function Name GetAPIName();

public native function string GetDimeInfo();

public native function array<SFXOnlineEntitlementLookupInfo> GetEntitlementInfo();

public native function GetGalaxyAtWarRatingsCompleted(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public native function SFXOnlineMOTDInfo GetMOTDInfo(SFXOnlineConnection_MessageType Type);

public event function string GetStoreCatalogId()
{
    return StoreCatalogId;
}
public native function int GetTargetOfferId(SFXOnlinePurchaseSource nSource);

public native function bool IsFetchingLiveBinaryINIData();

public native function bool IsLiveINIOutOfDate();

private final native function LoadDimeCallback();

private final native function LoadDimeInfo();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public native function PostGetLeaderboardList();

public native function ReadPlayerStorageCallback(bool bWasSuccessful);

public native function RequestBinaryLiveINIData(bool bMainMenu);

public native function RequestData();

private final native function RequestDimeInfo();

private final native function RequestEntitlementsInfo();

public event function RequestGalaxyAtWarLevel()
{
    OnlineSubsystem.GetComponentGalaxyAtWar().GetRatings(FALSE, FALSE, GetGalaxyAtWarRatingsCompleted);
}
public native function RequestLiveTlkTable(bool bMainMenu);

public native function RequestServerInfo();

public native function UpdateMOTDGUI();

public function int GetLiveBinaryINIVersion()
{
    return m_LiveBINIVersion;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PRCMessageTitle = $718190
    AllianceNewsItemMessageTitle = $718191
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}