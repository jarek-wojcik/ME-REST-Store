Class ISFXOnlineComponentCommerce extends ISFXOnlineComponent
    native
    abstract;

struct native unkstructflag BWConsumableInfo 
{
    var init BWConsumableId Id;
    var init int nCopies;
};
struct native unkstructflag BWConsumableId 
{
    var init int nID;
};
struct native unkstructflag BWEntitlementInfo 
{
    var init array<BWEntitlementToken> sTokens;
    var init BWEntitlementId Id;
};
struct native unkstructflag BWEntitlementToken 
{
    var init string sKey;
    var init string sName;
    var init string sValue;
};
struct native unkstructflag BWEntitlementId 
{
    var init int nID;
};
struct native unkstructflag BWOfferInfo 
{
    var init string sTitle;
    var init string sShortDescription;
    var init string sLongDescription;
    var init string sPrice;
    var init BWOfferId Id;
    var init int nPrice;
};
struct native unkstructflag BWOfferId 
{
    var init int nID;
};
enum CodeRedemptionResult
{
    REDEMPTION_SUCCESS,
    REDEMPTION_CANCELED,
    REDEMPTION_INVALID,
    REDEMPTION_ERROR,
};

var delegate<OnConsumeResult> __OnConsumeResult__Delegate;
var delegate<OnGrantEntitlementResult> __OnGrantEntitlementResult__Delegate;
var delegate<OnProcessAutoGrantsComplete> __OnProcessAutoGrantsComplete__Delegate;
var delegate<OnPromptRedeemCodeResult> __OnPromptRedeemCodeResult__Delegate;
var delegate<OnPurchaseOfferIdResult> __OnPurchaseOfferIdResult__Delegate;
var delegate<OnFetchOfferDetailsComplete> __OnFetchOfferDetailsComplete__Delegate;
var delegate<OnDimeConfigLoaded> __OnDimeConfigLoaded__Delegate;
var delegate<OnRefreshDigitalRightsResult> __OnRefreshDigitalRightsResult__Delegate;

public native function bool ConsumeId(BWConsumableId Id, optional int nCopies = 1, optional delegate<OnConsumeResult> dCallback);

public native function string DecryptOfflineEntitlementInfo();

public native function Display1stPartyStore();

public native function DumpTestData();

public native function FetchOfferDetails(array<BWOfferId> aOffers, delegate<OnFetchOfferDetailsComplete> dCallback);

public event function bool GetConsumableInfo(BWConsumableId Id, out BWConsumableInfo oConsumable);

public event function bool GetConsumablesList(out array<BWConsumableInfo> aConsumables);

public event function bool GetEntitlementInfo(BWEntitlementId Id, out BWEntitlementInfo oEntitlement);

public event function bool GetEntitlementsList(out array<BWEntitlementInfo> aEntitlements);

public event function GetOffersList(out array<BWOfferInfo> aOffers, optional array<BWOfferId> aOfferFilter);

public native function bool GrantEntitlementId(BWEntitlementId Id, optional delegate<OnGrantEntitlementResult> dCallback, optional bool bUseNucleusCheck = FALSE);

public native function LoadDimeConfig(string sConfig, delegate<OnDimeConfigLoaded> dCallback);

public native function NucleusEntitlementsRefreshOffline();

public native function OnCodeRedeemed(CodeRedemptionResult nResult);

public delegate function OnConsumeResult(BWConsumableId Id, int nCopies, int nResult);

public delegate function OnDimeConfigLoaded();

public delegate function OnFetchOfferDetailsComplete();

public delegate function OnGrantEntitlementResult(BWEntitlementId Id, int nResult);

public delegate function OnProcessAutoGrantsComplete();

public delegate function OnPromptRedeemCodeResult(int nResult);

public delegate function OnPurchaseOfferIdResult(int nResult);

public delegate function OnRefreshDigitalRightsResult(int nResult);

public native function ProcessAutoGrants(delegate<OnProcessAutoGrantsComplete> dCallback);

public native function PromptRedeemCode(delegate<OnPromptRedeemCodeResult> dCallback);

public native function PurchaseOfferId(BWOfferId Id, delegate<OnPurchaseOfferIdResult> dCallback);

public native function RefreshDigitalRights(delegate<OnRefreshDigitalRightsResult> dCallback);

public native function bool StoreOfflineEntitlementInfo(string a_sEncryptedContent);

public native function SubmitRedeemCode(bool bContinue, const string strCode);

public function string GetWalletBalance();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}