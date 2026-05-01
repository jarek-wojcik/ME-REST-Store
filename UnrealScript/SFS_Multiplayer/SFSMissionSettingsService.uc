Class SFSMissionSettingsService extends SFSManager within SFXPawn;

var string SFS_REST_URL;
var string MISSION_SETTINGS_MAPPING;
var string SIMPLE_JSON_PARAM;
var delegate<OnSettingsRetrieved> PendingCallback;

function OnSettingsRetrieved(SFSMissionSettingsStruct Settings, bool bSuccess)
{
}
public function RetrieveSettings(delegate<OnSettingsRetrieved> Callback)
{
    local SFXOnlineJobHTTPRequest Job;
    
    log(Self.Name, "Retrieving mission settings", Outer);
    PendingCallback = Callback;
    Job = Class'SFXOnlineJobHTTPRequest'.static.CreateHTTPRequestJob();
    Job.mRequest.SetBaseURL(SFS_REST_URL);
    Job.mRequest.AddSubURL(MISSION_SETTINGS_MAPPING);
    Job.mRequest.AddParameter(SIMPLE_JSON_PARAM, "true");
    Job.__OnJobComplete__Delegate = OnHTTPResponse;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
private final function OnHTTPResponse(SFXOnlineHTTPRequest request)
{
    local SFSMissionSettingsStruct Settings;
    local bool bSuccess;
    
    log(Self.Name, "Mission settings response: " $ request.mResultBody, Outer);
    bSuccess = Class'SFSMissionSettingsParser'.static.FromSimpleJson(request.mResultBody, Settings);
    if (!bSuccess)
    {
        log(Self.Name, "Failed to parse mission settings response", Outer);
    }
    PendingCallback(Settings, bSuccess);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SFS_REST_URL = "http://localhost:6060/"
    MISSION_SETTINGS_MAPPING = "missionSettings"
    SIMPLE_JSON_PARAM = "simpleJson"
}