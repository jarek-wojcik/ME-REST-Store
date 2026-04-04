Class SFSSpectreIntegrationService extends SFSManager within SFXPawn;

var string SFS_REST_URL;
var string ACTIVE_CHARACTER_MAPPING;
var string FLAT_PARAM;
var delegate<OnCharacterRetrieved> PendingCallback;

function OnCharacterRetrieved(SFSCharacterModelStruct Character, bool bSuccess)
{
}
public function RetrieveActiveCharacter(delegate<OnCharacterRetrieved> Callback)
{
    local SFXOnlineJobHTTPRequest Job;
    
    log(Self.Name, "Retrieving active character", Outer);
    PendingCallback = Callback;
    Job = Class'SFXOnlineJobHTTPRequest'.static.CreateHTTPRequestJob();
    Job.mRequest.SetBaseURL(SFS_REST_URL);
    Job.mRequest.AddSubURL(ACTIVE_CHARACTER_MAPPING);
    Job.mRequest.AddParameter(FLAT_PARAM, "true");
    Job.__OnJobComplete__Delegate = OnHTTPResponse;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
private final function OnHTTPResponse(SFXOnlineHTTPRequest request)
{
    local SFSCharacterModelStruct Model;
    local bool bSuccess;
    
    log(Self.Name, "Active character response: " $ request.mResultBody, Outer);
    bSuccess = Class'SFSCharacterModel'.static.FromFlat(request.mResultBody, Model);
    if (!bSuccess)
    {
        log(Self.Name, "Malformed flat response", Outer);
    }
    PendingCallback(Model, bSuccess);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SFS_REST_URL = "http://localhost:6060/"
    FLAT_PARAM = "flat"
    ACTIVE_CHARACTER_MAPPING = "activeCharacter"
}