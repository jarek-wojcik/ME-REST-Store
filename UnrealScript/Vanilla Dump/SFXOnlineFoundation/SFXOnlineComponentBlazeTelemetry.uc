Class SFXOnlineComponentBlazeTelemetry extends SFXOnlineComponent
    implements(ISFXOnlineComponentTelemetry)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponentTelemetry;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var delegate<CanCollect> __CanCollect__Delegate;
var delegate<OnAuthenticate> __OnAuthenticate__Delegate;
var delegate<OnDisconnect> __OnDisconnect__Delegate;
var int bConnectedToChannel[2];

public delegate function bool CanCollect();

public native function Flush(ETelemetryChannel Channel);

public native function Name GetAPIName();

public delegate function OnAuthenticate();

public delegate function OnDisconnect(int Error, int PreviousState, int NewState, const string SessionId);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public final function RegisterConnectionDelegates(delegate<CanCollect> CollectDelegate, delegate<OnAuthenticate> AuthenticateDelegate, delegate<OnDisconnect> DisconnectDelegate)
{
    __CanCollect__Delegate = CollectDelegate;
    __OnAuthenticate__Delegate = AuthenticateDelegate;
    __OnDisconnect__Delegate = DisconnectDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}