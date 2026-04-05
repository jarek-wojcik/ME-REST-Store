Class ISFXOnlineComponentUserInterface extends ISFXOnlineComponent
    native
    abstract;

public event function ClearNotifications(optional array<SFXOnlineConnection_MessageType> MessageTypesToClear);

public event function CloseEANetworking();

public event function HasCerberusDLC(bool bVal);

public event function bool IsInMainMenu();

public event function MessageBoxCallback(bool bAPressed, int Context);

public event function OnDisplayNotification(SFXOnlineMOTDInfo Info);

public event function SetState(SFXOnlineUIState eState);

public native function ShowAccountDemographics(array<string> m_CountryCodeList, array<string> m_CountryDisplayList);

public native function ShowCerberusIntro();

public native function ShowCerberusWelcomeMessage();

public native function ShowCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bRegisterProduct, bool bBioWareProducts, bool bUnderage);

public native function ShowCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, array<string> m_CountryCodeList, array<string> m_CountryDisplayList);

public native function ShowEmailPasswordMismatch(string email, string Password);

public native function ShowIntroPage();

public native function ShowMessageBox(string sTitle, string sMessage, optional string sButton1Text, optional string sButton2Text, optional string sButton3Text);

public native function ShowNucleusLogin(string email, string Password, int eScreenState);

public native function ShowNucleusWelcomeMessage();

public native function ShowParentEmail();

public native function bool ShowQueuedMessageBox(string sMessage, stringref srButton1Text);

public native function ShowRedeemCode();

public event function ShowRedeemCodeConfirmation();

public event function ShowStore(array<SFXOfferDescriptor> aOffers);

public native function ShowTermsOfService(string i_sTermsOfService, string i_sPrivacyPolicy, optional bool bTOSChanged = FALSE);

public event function UpdateGalaxyAtWarLevel(float newLevel);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}