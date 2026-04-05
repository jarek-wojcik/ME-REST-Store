Class SFXOnlineComponentBlazeHub extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentAPI)
    native
    config(Engine);

enum SFXOnlineComponentBlazeHubDirtyAllocationContext
{
    SFXONLINE_BLAZEHUB_DIRTY_ALLOC_DEFAULT,
    SFXONLINE_BLAZEHUB_DIRTY_ALLOC_BUGSENTRY,
};
enum SFXOnlineComponentBlazeHubEnvironment
{
    SFXONLINE_BLAZEHUB_ENV_DISABLED,
    SFXONLINE_BLAZEHUB_ENV_DEV,
    SFXONLINE_BLAZEHUB_ENV_TEST,
    SFXONLINE_BLAZEHUB_ENV_CERT,
    SFXONLINE_BLAZEHUB_ENV_PROD,
    SFXONLINE_BLAZEHUB_ENV_LOCAL,
};

var const native noexport Pointer VfTable_IISFXOnlineComponentAPI;
var const config string BlazeServiceName;
var const config string BlazeClientName;
var native Pointer CurrentBlazeHub;
var native Pointer BlazeNetworkAdapter;
var const config int DirtySockTimeOutMs;
var const config int DirtySockSessionTimeOutMs;
var const config int DirtySockConnectionTimeOutMs;
var bool m_bLock;
var const config bool ForceDisableSecureMode;
var const config SFXOnlineComponentBlazeHubEnvironment BlazeEnv;

private final native function bool ConnectDirtySock();

public native function Name GetAPIName();

public native function int GetCurrentTime();

public native function bool Idle();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public native function ResetLocale();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlazeServiceName = "masseffect-3"
    BlazeClientName = "MassEffect3"
    DirtySockTimeOutMs = 120000
    DirtySockSessionTimeOutMs = 120000
    DirtySockConnectionTimeOutMs = 120000
    BlazeEnv = SFXOnlineComponentBlazeHubEnvironment.SFXONLINE_BLAZEHUB_ENV_PROD
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}