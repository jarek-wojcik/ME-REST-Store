Class SFXOnlineHTTPRequest
    native;

enum EHTTPRequest
{
    HTTP_REQUEST_INVALID,
};
struct native HTTPParameter 
{
    var string mName;
    var string mValue;
};

var string mURL;
var string mConnectionString;
var string mResultBody;
var array<byte> mResultBinary;
var string mResultHeader;
var array<HTTPParameter> mParameters;
var array<HTTPParameter> mHeaderParameters;
var int mResultSize;
var int mResultResponseCode;
var bool mPost;
var bool mBinary;
var bool mResultSuccess;
var bool mComplete;
var bool mInProgress;
var EHTTPRequest mRequestType;

public static native function string AddHeaderTerminator(string InputString);

public event function AddParameter(string Key, string Value)
{
    local int oldLength;
    
    oldLength = mParameters.Length;
    mParameters.Length = oldLength + 1;
    mParameters[oldLength].mName = Key;
    mParameters[oldLength].mValue = Value;
}
public event function AddSubURL(string subUrl)
{
    if (Right(mURL, 1) != "/")
    {
        mURL $= "/";
    }
    mURL $= subUrl;
}
public event function ClearParams()
{
    mParameters.Remove(0, mParameters.Length);
    mHeaderParameters.Remove(0, mHeaderParameters.Length);
}
public event function FillDefaultParameters()
{
    AddHeaderParameter("User-Agent", "Mass Effect 3 Game Client");
    AddHeaderParameter("Accept", "header");
    AddHeaderParameter("Connection", "close");
    if (!mBinary)
    {
        AddHeaderParameter("Content-Type", "application/x-www-form-urlencoded; charset=\"utf-8\"");
        AddHeaderParameter("Cache-Control", "no-cache");
    }
}
public event function string GenerateHeaderParametersString()
{
    local string paramsString;
    local HTTPParameter Param;
    
    foreach mHeaderParameters(Param, )
    {
        paramsString $= Param.mName $ ": " $ Param.mValue;
        paramsString = AddHeaderTerminator(paramsString);
    }
    return paramsString;
}
public event function string GenerateParametersString()
{
    local string paramsString;
    local HTTPParameter Param;
    local bool started;
    
    started = FALSE;
    foreach mParameters(Param, )
    {
        if (started)
        {
            paramsString $= "&";
        }
        else
        {
            if (!mPost)
            {
                paramsString = "?";
            }
            started = TRUE;
        }
        paramsString $= Param.mName $ "=" $ URLEncodeString(Param.mValue);
    }
    return paramsString;
}
public event function Reset()
{
    ClearParams();
    mPost = FALSE;
    mBinary = FALSE;
    mConnectionString = "";
    mResultBody = "";
    mResultHeader = "";
    mResultResponseCode = 0;
    mResultSuccess = FALSE;
    mComplete = FALSE;
    mInProgress = FALSE;
}
public event function SetBaseURL(string URL)
{
    mURL = URL;
}
public static native function string URLEncodeString(string InputString);

public function AddHeaderParameter(string Key, string Value)
{
    local int oldLength;
    
    oldLength = mHeaderParameters.Length;
    mHeaderParameters.Length = oldLength + 1;
    mHeaderParameters[oldLength].mName = Key;
    mHeaderParameters[oldLength].mValue = Value;
}
public function SetPost(bool post)
{
    mPost = post;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}