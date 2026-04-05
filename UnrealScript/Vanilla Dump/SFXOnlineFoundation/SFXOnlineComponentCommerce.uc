Class SFXOnlineComponentCommerce extends SFXOnlineComponent
    implements(ISFXOnlineComponentCommerce)
    native
    config(Game);

var const native noexport Pointer VfTable_IISFXOnlineComponentCommerce;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var const native noexport Pointer VfTable_DIME::DimeStrategy;
var array<SFXOnlineEntitlementLookupInfo> aServerEntitlementGrantIds;
var array<int> aServerEntitlementRevokeIds;
var array<SFXOnlineEntitlementLookupInfo> aNamEntitlements;
var array<BWEntitlementInfo> aCachedEntitlements;
var array<BWEntitlementInfo> aCachedDIMEEntitlements;
var array<BWOfferInfo> aCachedOffers;
var array<BWConsumableInfo> aCachedConsumables;
var string sWalletBalance;
var array<BWOfferId> aFetchDetailsIDList;
var const config array<SFXOnlineEntitlementLookupInfo> aDLCEntitlementInfo;
var delegate<OnRefreshDigitalRightsResult> __OnRefreshDigitalRightsResult__Delegate;
var delegate<OnConsumeResult> __OnConsumeResult__Delegate;
var delegate<OnGrantEntitlementResult> __OnGrantEntitlementResult__Delegate;
var delegate<OnProcessAutoGrantsComplete> __OnProcessAutoGrantsComplete__Delegate;
var delegate<OnPromptRedeemCodeResult> __OnPromptRedeemCodeResult__Delegate;
var delegate<OnPurchaseOfferIdResult> __OnPurchaseOfferIdResult__Delegate;
var delegate<OnFetchOfferDetailsComplete> __OnFetchOfferDetailsComplete__Delegate;
var delegate<OnDimeConfigLoaded> __OnDimeConfigLoaded__Delegate;
var int CurrentDimeState;
var bool bAwaitingDimeForRefresh;

public native function CompleteProcessAutoGrant();

public native function bool ConsumeId(BWConsumableId Id, optional int nCopies = 1, optional delegate<OnConsumeResult> dCallback);

public native function string DecryptOfflineEntitlementInfo();

public native function Display1stPartyStore();

public native function DumpTestData();

public native function FetchOfferDetails(array<BWOfferId> aOffers, delegate<OnFetchOfferDetailsComplete> dCallback);

public native function Name GetAPIName();

public event function bool GetConsumableInfo(BWConsumableId Id, out BWConsumableInfo oConsumable)
{
    local int idx;
    
    for (idx = 0; idx < aCachedConsumables.Length; ++idx)
    {
        if (aCachedConsumables[idx].Id == Id)
        {
            oConsumable = aCachedConsumables[idx];
            return TRUE;
        }
    }
    return FALSE;
}
public event function bool GetConsumablesList(out array<BWConsumableInfo> aConsumables)
{
    aConsumables.Length = 0;
    aConsumables = aCachedConsumables;
    if (aConsumables.Length == 0)
    {
        return FALSE;
    }
    return TRUE;
}
public event function bool GetEntitlementInfo(BWEntitlementId Id, out BWEntitlementInfo oEntitlement)
{
    local int idx;
    
    for (idx = 0; idx < aCachedEntitlements.Length; ++idx)
    {
        if (aCachedEntitlements[idx].Id == Id)
        {
            oEntitlement = aCachedEntitlements[idx];
            return TRUE;
        }
    }
    return FALSE;
}
public event function bool GetEntitlementsList(out array<BWEntitlementInfo> aEntitlements)
{
    aEntitlements.Length = 0;
    aEntitlements = aCachedEntitlements;
    if (aEntitlements.Length == 0)
    {
        return FALSE;
    }
    return TRUE;
}
public event function GetOffersList(out array<BWOfferInfo> aOffers, optional array<BWOfferId> aOfferFilter)
{
    local int idx;
    local int Jdx;
    local bool bFound;
    
    aOffers.Length = 0;
    aOffers = aCachedOffers;
    if (aOfferFilter.Length == 0)
    {
        return;
    }
    for (idx = aOffers.Length; idx > 0; --idx)
    {
        bFound = FALSE;
        for (Jdx = 0; Jdx < aOfferFilter.Length && !bFound; Jdx++)
        {
            bFound = aOffers[idx].Id.nID == aOfferFilter[Jdx].nID;
        }
        if (!bFound)
        {
            aOffers.Remove(idx, 1);
        }
    }
}
public native function bool GrantEntitlementId(BWEntitlementId Id, optional delegate<OnGrantEntitlementResult> dCallback, optional bool bUseNucleusCheck = FALSE);

public native function LoadDimeConfig(string sConfig, delegate<OnDimeConfigLoaded> dCallback);

public native function NucleusEntitlementsRefreshOffline();

public native function OnCodeRedeemed(CodeRedemptionResult nResult);

public delegate function OnConsumeResult(BWConsumableId Id, int nCopies, int nResult);

public delegate function OnDimeConfigLoaded();

public delegate function OnFetchOfferDetailsComplete();

public delegate function OnGrantEntitlementResult(BWEntitlementId Id, int nResult);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnProcessAutoGrantsComplete();

public delegate function OnPromptRedeemCodeResult(int nResult);

public delegate function OnPurchaseOfferIdResult(int nResult);

public delegate function OnRefreshDigitalRightsResult(int nResult);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public native function ProcessAutoGrants(delegate<OnProcessAutoGrantsComplete> dCallback);

public native function ProcessNextAutoGrant(BWEntitlementId Id, int nResult);

public native function PromptRedeemCode(delegate<OnPromptRedeemCodeResult> dCallback);

public native function PurchaseOfferId(BWOfferId Id, delegate<OnPurchaseOfferIdResult> dCallback);

public native function RefreshDigitalRights(delegate<OnRefreshDigitalRightsResult> dCallback);

public native function bool StoreOfflineEntitlementInfo(string a_sEncryptedContent);

public native function SubmitRedeemCode(bool bContinue, const string strCode);

public function string GetWalletBalance()
{
    return sWalletBalance;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}