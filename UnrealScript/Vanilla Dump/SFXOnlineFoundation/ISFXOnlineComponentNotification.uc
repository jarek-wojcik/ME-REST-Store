Class ISFXOnlineComponentNotification extends ISFXOnlineComponent
    native
    abstract;

struct native SFXOnlineMOTDInfo 
{
    var string Message;
    var string Title;
    var string Image;
    var int TrackingID;
    var int Priority;
    var int BWEntId;
    var int offerId;
    var SFXOnlineConnection_MessageType Type;
};
struct native unkstructflag SFXOnlineEntitlementLookupInfo 
{
    var init BWEntitlementInfo BWEntitlement;
    var init string sGroupName;
    var init string sEntitlementName;
    var init string sProductId;
};
enum SFXOnlineEntitlementLookupInfoType
{
    SFX_OELIT_NAM_ENTITLEMENT,
    SFX_OELIT_NAM_GROUP,
    SFX_OELIT_SERVER_ENTITLEMENT,
    SFX_OELIT_SERVER_REVOKE,
};
struct native SFXOnlineDLCInfo 
{
    var string Name;
    var string Description;
    var string entitlementGroup;
    var string entitlementName;
    var string grantEntitlementGroup;
    var string grantEntitlementName;
    var string Image;
    var string offerKey;
    var SFXOnline_OfferID externalId;
    var int internalId;
    var int Price;
    var bool isEntitled;
};
enum SFXOnlineNotificationOfferPurchaseStatus
{
    SFXONLINE_NOTIFICATION_PURHASE_UNKNOWN,
    SFXONLINE_NOTIFICATION_PURHASE_COMPLETED,
    SFXONLINE_NOTIFICATION_PURHASE_NONE,
};
enum SFXOnlineNotificationPriority
{
    SFXONLINE_NOTIFICATION_PRIORITY_CERBERUS_CONTENT,
    SFXONLINE_NOTIFICATION_PRIORITY_NEW_UNLOCK,
    SFXONLINE_NOTIFICATION_PRIORITY_SOON_DLC,
    SFXONLINE_NOTIFICATION_PRIORITY_MOTD,
    SFXONLINE_NOTIFICATION_PRIORITY_UPCOMING_UNLOCK,
    SFXONLINE_NOTIFICATION_PRIORITY_UPCOMING_DLC,
};

public native function FetchOfflineEntitlementStoreMappings();

public native function string GetDimeInfo();

public native function array<SFXOnlineEntitlementLookupInfo> GetEntitlementInfo();

public native function SFXOnlineMOTDInfo GetMOTDInfo(SFXOnlineConnection_MessageType Type);

public event function string GetStoreCatalogId();

public native function int GetTargetOfferId(SFXOnlinePurchaseSource nSource);

public native function bool IsFetchingLiveBinaryINIData();

public native function bool IsLiveINIOutOfDate();

public native function PostGetLeaderboardList();

public native function ReadPlayerStorageCallback(bool bWasSuccessful);

public native function RequestBinaryLiveINIData(bool bMainMenu);

public native function RequestData();

public native function RequestLiveTlkTable(bool bMainMenu);

public native function RequestServerInfo();

public native function UpdateMOTDGUI();

public function int GetLiveBinaryINIVersion();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}