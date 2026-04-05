Class OnlineEventsInterfaceMcp extends MCPBase
    implements(OnlineEventsInterface)
    native
    config(Engine);

struct native EventUploadConfig 
{
    var const string UploadUrl;
    var const float TimeOut;
    var const bool bUseCompression;
    var const EEventUploadType UploadType;
};
enum EEventUploadType
{
    EUT_GenericStats,
    EUT_ProfileData,
    EUT_HardwareData,
    EUT_MatchmakingData,
};

var const native array<Pointer> HttpPostObjects;
var const config array<EventUploadConfig> EventUploadConfigs;
var config array<EEventUploadType> DisabledUploadTypes;
var const config bool bBinaryStats;

public native function bool UploadGameplayEventsData(OnlineGameplayEvents Events);

public native function bool UploadProfileData(UniqueNetId UniqueId, string PlayerNick, OnlineProfileSettings ProfileSettings);

public function bool UploadHardwareData(UniqueNetId UniqueId, string PlayerNick);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}