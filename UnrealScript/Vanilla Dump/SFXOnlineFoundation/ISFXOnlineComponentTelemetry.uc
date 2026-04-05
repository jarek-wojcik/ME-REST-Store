Class ISFXOnlineComponentTelemetry extends ISFXOnlineComponent
    native
    abstract;

struct native TelemetryAttribute 
{
    var init string sData;
    var int Key;
    var int nData;
    var float fData;
    var bool bData;
    var ETelemetryAttributeType Type;
};
enum ETelemetryAttributeType
{
    AttributeType_None,
    AttributeType_String,
    AttributeType_Int,
    AttributeType_Float,
    AttributeType_Bool,
    AttributeType_ClassName,
};
enum ETelemetryChannel
{
    Channel_Normal,
    Channel_Anonymous,
};

var delegate<OnAuthenticate> __OnAuthenticate__Delegate;
var delegate<OnDisconnect> __OnDisconnect__Delegate;
var delegate<CanCollect> __CanCollect__Delegate;

public delegate function bool CanCollect();

public native function Flush(ETelemetryChannel Channel);

public delegate function OnAuthenticate();

public delegate function OnDisconnect(int Error, int PreviousState, int NewState, const string SessionId);

public function RegisterConnectionDelegates(delegate<CanCollect> CollectDelegate, delegate<OnAuthenticate> ConnectDelegate, delegate<OnDisconnect> DisconnectDelegate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}