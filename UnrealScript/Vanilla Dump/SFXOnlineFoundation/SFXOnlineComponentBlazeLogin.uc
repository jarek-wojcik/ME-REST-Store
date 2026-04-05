Class SFXOnlineComponentBlazeLogin extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentLogin)
    native
    config(Engine);

struct native AutoConnectAccount 
{
    var string email;
    var string Password;
};

var const native noexport Pointer VfTable_IISFXOnlineComponentLogin;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var const native noexport Pointer VfTable_Blaze::LoginManager::LoginManagerListener;
var transient array<string> m_asEntitlements;
var transient array<string> m_asGrantedEntitlements;
var config array<AutoConnectAccount> m_AutoConnectAccounts;
var string PendingConnectEmail;
var string PendingConnectPassword;
var string PendingConnectCountryCode;
var string PendingConnectLanguageCode;
var string PendingConnectParentalEmail;
var array<byte> PendingConnectLoginInfo;
var array<byte> PendingConnectPersonaID;
var array<SFXOfferDescriptor> PendingBuyOffers;
var delegate<OnAuthTokenRetrieved> __OnAuthTokenRetrieved__Delegate;
var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
var delegate<OnImportFriendListToBlazeCompleted> __OnImportFriendListToBlazeCompleted__Delegate;
var native Pointer ConnectionMgr;
var native Pointer LoginMgr;
var native Pointer m_pAuthComponent;
var const config int m_SuspendUserPingPeriodMicroSec;
var const config int m_SuspendUserPingIdleCalls;
var const config int m_MinTimeOut;
var int PendingConnectBirthDay;
var int PendingConnectBirthMonth;
var int PendingConnectBirthYear;
var int PendingConnectError;
var int PendingConnectBlazeError;
var bool PendingConnectSilent;
var bool PendingConnectInProgress;
var const config bool AutoLoginFromIni;
var const config bool m_DebugDisableBlazeTimeOut;
var bool PendingConnectNucleusRefused;
var bool PendingConnectCerberusRefused;
var bool PendingConnectNucleusSuccessful;
var bool PendingConnectProfileChanged;
var bool PendingConnectAutoLoginAllowed;
var bool PendingConnectAccountCreation;
var bool PendingConnectEAProducts;
var bool PendingConnectThirdParty;
var bool PendingConnectSubscribeBWNewsLetter;
var SFXOnlineConnectMode PendingConnectMode;

public native function AcceptTOS(bool bAccepted);

public native function AddFriendsCompleteCb(bool bWasSuccessful);

public event function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    local SFXOnlineComponentUnrealPlayer oUnrealPlayer;
    
    oUnrealPlayer = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUnrealPlayer();
    if (oUnrealPlayer != None)
    {
        oUnrealPlayer.AddReadFriendsCompleteDelegate(LocalUserNum, ReadFriendsCompleteDelegate);
    }
}
public native function AutoLogin(string sEmail, string sPassword);

public native function AutoLoginWithAccountIndex(int configAccountIndex);

private final native function bool BuildEntitlementList(bool bFirstCallUponLogin, optional int nPage = 0);

public native function Buy(SFXOnlinePurchaseSource nPurchaseSource);

public native function Cancel();

public native function EFeaturePrivilegeLevel CanCommunicate(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanPlayOnline(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanPurchaseContent(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(optional int nUserIndex = -1);

public native function bool CheckAutoLoginFromIni();

public event function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    local SFXOnlineComponentUnrealPlayer oUnrealPlayer;
    
    oUnrealPlayer = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUnrealPlayer();
    if (oUnrealPlayer != None)
    {
        oUnrealPlayer.ClearReadFriendsCompleteDelegate(LocalUserNum, ReadFriendsCompleteDelegate);
    }
}
private final native function CompleteBuildEntitlementListUponLogin(int nResult);

private final native function CompleteBuildEntitlementListUponRedeption(int nResult);

public native function CompleteLoginProcess();

public native function Connect(SFXOnlineConnectMode connectMode);

private final event function SFXOnlineJobGetAuthToken CreateJobGetAuthToken(delegate<OnAuthTokenRetrieved> funcAuthTokenRetrieved)
{
    return Class'SFXOnlineJobGetAuthToken'.static.CreateGetAuthTokenJob(funcAuthTokenRetrieved);
}
private final event function SFXOnlineJobImportFriendListToBlaze CreateJobImportFriendListToBlaze(bool callPostImportFriendListToBlaze)
{
    return Class'SFXOnlineJobImportFriendListToBlaze'.static.CreateImportFriendListToBlazeJob(callPostImportFriendListToBlaze);
}
public native function CreatePersona(string sPersonaName);

public native function DisablePersona(string sPersonaNonGrata);

public native function Disconnect();

public native function EnterCDKey(string sKey);

public native function int GetActiveUserIndex();

public native function Name GetAPIName();

public native function int GetAuthToken(delegate<OnAuthTokenRetrieved> funcAuthTokenRetrieved);

public native function SFXOnlineConnectMode GetConnectMode();

public native function bool GetDefaultBiowareEmailAllowed();

public native function ELoginStatus GetLoginStatus();

public native function string GetPersonaName();

public native function UniqueNetId GetUserId();

public native function GoBackInUI();

public native function bool HasInternetConnection();

public native function bool ImportFriendListToBlaze(delegate<OnImportFriendListToBlazeCompleted> funcImportFriendListToBlazeCompleted);

public native function bool IsActiveUser(UniqueNetId userId);

public native function bool IsCerberusMember();

public native function bool IsConnected();

public native function bool IsConnectedTo1stPartyOnlineService();

public native function bool IsSignedIn();

public native function On1stPartyServiceLoginResult(bool loggedIn);

public delegate function OnAuthTokenRetrieved(string token);

public native function OnDLCInfoLoaded();

public native function OnDownloadOffersUICompleted();

public delegate function OnImportFriendListToBlazeCompleted(byte errorCode);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnOriginAuthKeyAvailableCallback(bool Success, string authKey);

public native function OnPromptRedeemCodeResult(int nResult);

public delegate function OnReadFriendsComplete(bool bWasSuccessful);

public native function OnRelease();

public native function OpenCerberusUI();

public native function PostImportFriendListToBlaze();

public final native function RequestImportFriendListToBlaze(bool callPostImportFriendListToBlaze);

public native function SelectPersona(string sPersonaName);

public event function bool Show1stPartyServiceLogin()
{
    return Show1stPartyServiceLoginImp();
}
public native function StartCerberusLogin();

public native function SubmitCerberusIntro(int eReturnCode);

public native function SubmitCerberusWelcomeMessage();

public native function SubmitCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, bool bSubmit);

public native function SubmitCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, bool bSubmit);

public native function SubmitEmailPasswordMismatch(string email, string Password, int eReturnCode);

public native function SubmitIntroPage(bool bContinue, bool bSimulated);

public native function SubmitMessageBox(int eReturnCode);

public native function SubmitNucleusLogin(string email, string Password, byte eReturnCode);

public native function SubmitNucleusWelcomeMessage();

public native function SubmitParentEmail(bool bContinue, string ParentEmail);

public native function SubmitRedeemCode(bool bContinue, string i_sCode);

public native function SubmitStore(array<int> aiChosen);

public native function SuspendUserPing(bool suspend);

public native function SwitchActiveUserIndex(int nNewIndex);

public function bool Show1stPartyServiceLoginImp()
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_SuspendUserPingPeriodMicroSec = 90000000
    m_SuspendUserPingIdleCalls = 10
    m_MinTimeOut = 20000000
    PendingConnectAutoLoginAllowed = TRUE
}