Class ISFXOnlineComponentLogin extends ISFXOnlineComponent
    native
    abstract;

struct native SFXOnlineAccountCountryListItem 
{
    var init string ISOCode;
    var init string Description;
};
enum SFXOnlineConnectMode
{
    SFXONLINE_CM_NONE,
    SFXONLINE_CM_IMPLICIT,
    SFXONLINE_CM_EXPLICIT,
    SFXONLINE_CM_SILENT,
    SFXONLINE_CM_FORCEDAUTOMATIC,
};

var delegate<OnImportFriendListToBlazeCompleted> __OnImportFriendListToBlazeCompleted__Delegate;
var delegate<OnAuthTokenRetrieved> __OnAuthTokenRetrieved__Delegate;

public native function AcceptTOS(bool bAccepted);

public native function AutoLogin(string sEmail, string sPassword);

public native function AutoLoginWithAccountIndex(int configAccountIndex);

public native function Cancel();

public native function EFeaturePrivilegeLevel CanCommunicate(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanPlayOnline(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanPurchaseContent(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(optional int nUserIndex = -1);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(optional int nUserIndex = -1);

public native function bool CheckAutoLoginFromIni();

public native function Connect(SFXOnlineConnectMode connectMode);

public native function CreatePersona(string sPersonaName);

public native function DisablePersona(string sPersonaNonGrata);

public native function Disconnect();

public native function EnterCDKey(string sKey);

public native function int GetActiveUserIndex();

public native function int GetAuthToken(delegate<OnAuthTokenRetrieved> funcAuthTokenRetrieved);

public native function SFXOnlineConnectMode GetConnectMode();

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

public delegate function OnAuthTokenRetrieved(string token);

public native function OnDLCInfoLoaded();

public native function OnDownloadOffersUICompleted();

public delegate function OnImportFriendListToBlazeCompleted(byte errorCode);

public native function OpenCerberusUI();

public native function PostImportFriendListToBlaze();

public final native function RequestImportFriendListToBlaze(bool callPostImportFriendListToBlaze);

public native function SelectPersona(string sPersonaName);

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


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}