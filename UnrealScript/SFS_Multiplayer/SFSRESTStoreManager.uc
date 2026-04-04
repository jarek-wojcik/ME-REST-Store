Class SFSRESTStoreManager extends SFSManager within SFXPawn;

var string SFS_REST_URL;
var string STORE_MAPPING;
var string RETRIEVE_MAPPING;
var string DELETE_MAPPING;
var string HEALTH_MAPPING;

public function HandlePostAdd()
{
    SFSRESTStoreHealthCheck();
    crudTest();
}
public function sendRequest(string Operation, delegate<HTTPResult> responseCallback, optional string key, optional string Value)
{
    local SFXOnlineJobHTTPRequest Job;
    local string queryString;
    
    Job = Class'SFXOnlineJobHTTPRequest'.static.CreateHTTPRequestJob();
    Job.mRequest.SetBaseURL(SFS_REST_URL);
    Job.mRequest.AddSubURL(Operation);
    if (key != "")
    {
        Job.mRequest.AddParameter("key", key);
    }
    if (Value != "")
    {
        Job.mRequest.AddParameter("value", Value);
    }
    if (responseCallback != None)
    {
        Job.__OnJobComplete__Delegate = responseCallback;
    }
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
public function SFSRESTStoreHealthCheck()
{
    log(Self.Name, "Begin REST Store Health Check", Outer);
    sendRequest(HEALTH_MAPPING, HTTPResult);
}
public function store(string key, string Value, delegate<HTTPResult> responseCallback)
{
    log(Self.Name, "Storing key: " $ key $ " and value: " $ Value, Outer);
    sendRequest(STORE_MAPPING, responseCallback, key, Value);
}
public function retrieve(string key, delegate<HTTPResult> responseCallback)
{
    log(Self.Name, "Retrieving key: " $ key, Outer);
    sendRequest(RETRIEVE_MAPPING, responseCallback, key);
}
public function delete(string key, delegate<HTTPResult> responseCallback)
{
    log(Self.Name, "Deleting key: " $ key, Outer);
    sendRequest(DELETE_MAPPING, responseCallback, key);
}
public function HTTPResult(SFXOnlineHTTPRequest request)
{
    log(Self.Name, request.mResultBody, Outer);
}
public function crudTest()
{
    store("me3Test", "true", HTTPRetrieveTest);
}
public function HTTPRetrieveTest(SFXOnlineHTTPRequest request)
{
    retrieve("me3Test", HTTPResult);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SFS_REST_URL = "http://localhost:6060/"
    STORE_MAPPING = "store"
    RETRIEVE_MAPPING = "retrieve"
    DELETE_MAPPING = "delete"
    HEALTH_MAPPING = "health"
}