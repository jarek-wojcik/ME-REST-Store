Class SFXOnlineComponentOrigin extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native
    config(Engine);

enum EPCPresenceStates
{
    PC_PRESENCE_OFFLINE,
    PC_PRESENCE_ONLINE,
    PC_PRESENCE_INGAME,
    PC_PRESENCE_BUSY,
    PC_PRESENCE_IDLE,
    PC_PRESENCE_JOINABLE,
};
struct native PCFriend 
{
    var QWord FriendID;
    var QWord PersonaId;
    var string FriendName;
    var string AvatarID;
    var string Title;
    var string TitleId;
    var string Group;
    var int PresenceState;
    var int FriendState;
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var native QWord mUserId;
var native string mPresenceString;
var native string mGamePresenceString;
var native string mSessionPresenceString;
var native string mDisplayName;
var native array<PCFriend> mFriendsListCache;
var native array<PCFriend> mBlockListCache;
var native array<SFXOnlineEntitlementLookupInfo> mEntitlementCache;
var native string mOriginVersion;
var native string mInviteInfo;
var native array<delegate<OnOriginClosedDelegate>> mOriginClosedDelegates;
var native array<delegate<OnOriginAuthKey>> mOriginAuthKeyDelegates;
var native array<delegate<OnWalletBalanceAvailable>> mWalletBalanceDelegates;
var config string mContentId;
var config string mMultiplayerId;
var config string mCurrencyId;
var config string mOfferGroup;
var config string mAccessEntitlement;
var delegate<OnOriginClosedDelegate> __OnOriginClosedDelegate__Delegate;
var delegate<OnOriginAuthKey> __OnOriginAuthKey__Delegate;
var delegate<OnWalletBalanceAvailable> __OnWalletBalanceAvailable__Delegate;
var config stringref mTitleStringRef;
var config float mTimeBetweenOnlineChecks;
var config int mCheckoutTimeout;
var config int mFriendQueryTimeout;
var config int mEntitlementQueryTimeout;
var native float mTimeSinceLastOnlineCheck;
var config bool mDisableOrigin;
var native bool mServiceStarted;
var native bool mIsLoggedIn;
var native bool mIsOriginDisabled;
var native bool mIsEntitlementCacheAvailable;
var native bool mIsPendingConnection;
var native bool mIsOverlayUp;
var native bool mIsOverlayEnabled;
var native bool mOldClient;
var native bool mFriendsListUpToDate;
var native bool mIsOnline;
var native bool mPendingInviteJoin;
var native EPCPresenceStates mPresenceState;

public event function AddOriginAuthKeyDelegate(delegate<OnOriginAuthKey> authKeyDelegate)
{
    if (mOriginAuthKeyDelegates.Find(authKeyDelegate) == -1)
    {
        mOriginAuthKeyDelegates.AddItem(authKeyDelegate);
    }
}
public event function AddOriginClosedDelegate(delegate<OnOriginClosedDelegate> originClosedDelegate)
{
    if (mOriginClosedDelegates.Find(originClosedDelegate) == -1)
    {
        mOriginClosedDelegates.AddItem(originClosedDelegate);
    }
}
public event function AddWalletBalanceAvailableDelegate(delegate<OnWalletBalanceAvailable> walletBalanceDelegate)
{
    if (mWalletBalanceDelegates.Find(walletBalanceDelegate) == -1)
    {
        mWalletBalanceDelegates.AddItem(walletBalanceDelegate);
    }
}
public native function bool CheckEntitlementCache();

public native function bool CheckOnline();

public native function bool Checkout(string offerId);

public native function bool CheckSignedIn();

public event function ClearOriginAuthKeyDelegate(delegate<OnOriginAuthKey> authKeyDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = mOriginAuthKeyDelegates.Find(authKeyDelegate);
    if (RemoveIndex != -1)
    {
        mOriginAuthKeyDelegates.Remove(RemoveIndex, 1);
    }
}
public event function ClearOriginClosedDelegate(delegate<OnOriginClosedDelegate> originClosedDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = mOriginClosedDelegates.Find(originClosedDelegate);
    if (RemoveIndex != -1)
    {
        mOriginClosedDelegates.Remove(RemoveIndex, 1);
    }
}
public native function bool ClearSessionPresence();

public event function ClearWalletBalanceAvailableDelegate(delegate<OnWalletBalanceAvailable> walletBalanceDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = mWalletBalanceDelegates.Find(walletBalanceDelegate);
    if (RemoveIndex != -1)
    {
        mWalletBalanceDelegates.Remove(RemoveIndex, 1);
    }
}
public native function Name GetAPIName();

public final native function bool IsMuted(const out string personaName);

public native function JoinPendingGameInvite();

public native function OnBlazeSignedIn(SFXOnlineEvent oEvent);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnOriginAuthKey(bool Success, string authKey);

public native function OnOriginClosed();

public delegate function OnOriginClosedDelegate();

public native function OnOriginGoesOffline();

public native function OnRelease();

public native function OnTick(SFXOnlineEvent oEvent);

public delegate function OnWalletBalanceAvailable(bool Success, int walletBalance);

public native function ProcessIGODisplayEvent(bool isOpening);

public native function bool QueryIgoEnabled();

public native function bool QueryOnline();

public native function bool RegisterCallbacks();

public native function RequestAuthToken();

public native function RequestBlockList();

public native function RequestEntitlementCache();

public native function bool RequestFriendsList();

public native function RequestProfileInfo();

public native function RequestWalletBalance();

public native function bool SetPresenceState(EPCPresenceStates presence);

public native function bool SetRichPresence(string presence, string gamePresence);

public native function bool SetSessionPresence(string SessionId);

public native function bool ShowCheckoutOverlay(string offerId);

public native function bool ShowFriendsOverlay();

public native function bool ShowInviteOverlay();

public native function bool ShowStoreOverlay(string categoryId);

public native function bool StartService();

public native function bool StopService();

public event function TriggerOriginAuthKeyDelegates(bool Success, string authKey)
{
    local delegate<OnOriginAuthKey> onAuthKeyDelegate;
    
    foreach mOriginAuthKeyDelegates(onAuthKeyDelegate, )
    {
        onAuthKeyDelegate(Success, authKey);
    }
}
public event function TriggerOriginClosedDelegates()
{
    local delegate<OnOriginClosedDelegate> onClosedDelegate;
    
    foreach mOriginClosedDelegates(onClosedDelegate, )
    {
        onClosedDelegate();
    }
}
public event function TriggerWalletBalanceAvailableDelegates(bool Success, int balance)
{
    local delegate<OnWalletBalanceAvailable> onBalanceDelegate;
    
    foreach mWalletBalanceDelegates(onBalanceDelegate, )
    {
        onBalanceDelegate(Success, balance);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    mContentId = "71073"
    mMultiplayerId = "71073"
    mCurrencyId = "_BW"
    mOfferGroup = "ME3PCOffers"
    mAccessEntitlement = "ONLINE_ACCESS"
    mTitleStringRef = $701817
    mTimeBetweenOnlineChecks = 2.0
    mCheckoutTimeout = 10000
    mFriendQueryTimeout = 10000
    mEntitlementQueryTimeout = 10000
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}, 
                            {EventCallback = 'OnBlazeSignedIn', EventType = SFXOnlineEventType.SFXONLINE_EVENT_LOGIN_SIGNED_IN}
                           )
}