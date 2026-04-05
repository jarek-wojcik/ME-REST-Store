Class SFXOnlineComponentGalaxyAtWar extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentGalaxyAtWar)
    native
    config(Engine);

const SERVER_RATING_SCALE = 100;

var const native noexport Pointer VfTable_IISFXOnlineComponentGalaxyAtWar;
var string PersonaId;
var string BaseUrl;
var string SessionKey;
var array<int> m_CachedSecurityRatings;
var array<int> m_CachedWarAssets;
var delegate<AuthenticateCompleted> __AuthenticateCompleted__Delegate;
var delegate<OnGetRatingsComplete> __OnGetRatingsComplete__Delegate;
var delegate<OnIncreaseRatingsComplete> __OnIncreaseRatingsComplete__Delegate;
var delegate<OnSendMessageComplete> __OnSendMessageComplete__Delegate;
var delegate<OnGetMessagesComplete> __OnGetMessagesComplete__Delegate;
var delegate<OnTouchMessagesComplete> __OnTouchMessagesComplete__Delegate;
var config stringref LevelChangeStrRef;
var int m_CachedLevel;
var bool m_CachedRatingsValid;
var bool m_CachedWarAssetsValid;

public delegate function AuthenticateCompleted(int errorCode);

public native function Cleanup();

public event function SFXOnlineJobGaWHTTPGetMessages CreateJobGaWGetMessages(int msgType, delegate<OnGetMessagesComplete> funcOnRequestComplete)
{
    return Class'SFXOnlineJobGaWHTTPGetMessages'.static.CreateGaWGetMessagesJob(msgType, funcOnRequestComplete);
}
public event function SFXOnlineJobGaWHTTPGetRatings CreateJobGaWGetRatings(bool getWarAssets, delegate<OnGetRatingsComplete> funcOnRequestComplete)
{
    return Class'SFXOnlineJobGaWHTTPGetRatings'.static.CreateGaWGetRatingsJob(getWarAssets, funcOnRequestComplete);
}
public event function SFXOnlineJobGaWHTTPIncreaseRatings CreateJobGaWIncreaseRatings(int defaultRatingIncrease, array<MapEntry> securityRatingIncrease, array<MapEntry> warAssetIncrease, delegate<OnIncreaseRatingsComplete> funcOnRequestComplete)
{
    return Class'SFXOnlineJobGaWHTTPIncreaseRatings'.static.CreateGaWIncreaseRatingsJob(defaultRatingIncrease, securityRatingIncrease, warAssetIncrease, funcOnRequestComplete);
}
public event function SFXOnlineJobGaWHTTPSendMessage CreateJobGaWSendMessage(int msgType, string sendMsgParam1, string sendMsgParam2, string sendMsgParam3, delegate<OnSendMessageComplete> funcOnRequestComplete)
{
    return Class'SFXOnlineJobGaWHTTPSendMessage'.static.CreateGaWSendMessageJob(msgType, sendMsgParam1, sendMsgParam2, sendMsgParam3, funcOnRequestComplete);
}
public event function SFXOnlineJobGaWHTTPTouchMessages CreateJobGaWTouchMessages(int msgType, delegate<OnTouchMessagesComplete> funcOnRequestComplete)
{
    return Class'SFXOnlineJobGaWHTTPTouchMessages'.static.CreateGaWTouchMessagesJob(msgType, funcOnRequestComplete);
}
public native function Name GetAPIName();

public native function GetAuthenticationHTTPRequest(string token, int tokenType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function int GetFirstBlazeAttrId();

public native function GetGetMessagesHTTPRequest(int msgType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetIncreaseRatingsHTTPRequest(int defaultRatingIncrease, array<MapEntry> securityRatingsIncrease, array<MapEntry> warAssetsIncrease, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetMessages(int msgType, delegate<OnGetMessagesComplete> funcOnRequestComplete);

public native function GetRatings(bool getWarAssets, bool bCached, delegate<OnGetRatingsComplete> funcOnRequestComplete);

public native function GetRatingsHTTPRequest(bool getAssets, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetSendMessageHTTPRequest(int msgType, string param1, string param2, string param3, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetTouchMessagesHTTPRequest(int msgType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function IncreaseRatings(int defaultRatingIncrease, array<MapEntry> securityRatingIncrease, array<MapEntry> warAssetIncrease, delegate<OnIncreaseRatingsComplete> funcOnRequestComplete);

public event function InvalidateSession()
{
    SessionKey = "";
}
public event function bool IsSessionValid()
{
    return SessionKey != "";
}
public delegate function OnGetMessagesComplete(array<MessageEntry> Messages, int errorCode);

public delegate function OnGetRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public delegate function OnIncreaseRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public delegate function OnSendMessageComplete(int messageId, array<int> messageIds, int errorCode);

public delegate function OnTouchMessagesComplete(int Count, int errorCode);

public event function int ParseAuthenticationResult(SFXOnlineHTTPRequest request)
{
    local SFXOnlineComponentXMLParser parser;
    local string stringResult;
    local string errorName;
    local bool bErrorCode;
    local bool bErrorName;
    local int errorCode;
    
    if (!request.mResultSuccess)
    {
        return -1;
    }
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing(request.mResultBody);
    errorCode = 0;
    bErrorCode = parser.GetXMLInteger("error.errorCode", errorCode);
    bErrorName = parser.GetXMLString("error.errorName", errorName);
    if (bErrorCode || bErrorName)
    {
    }
    else
    {
        if (parser.GetXMLString("fulllogin.sessioninfo.sessionkey", stringResult, 0))
        {
            SessionKey = stringResult;
        }
        if (parser.GetXMLString("fulllogin.sessioninfo.blazeuserid", stringResult, 0))
        {
            PersonaId = stringResult;
        }
    }
    return errorCode;
}
public event function ParseGetMessagesResult(SFXOnlineHTTPRequest request, out array<MessageEntry> messageEntries, out int errorCode)
{
    local SFXOnlineComponentXMLParser parser;
    local int skipcount;
    local string errorName;
    local bool bErrorCode;
    local bool bErrorName;
    local MessageEntry messageEntryIter;
    
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing(request.mResultBody);
    errorCode = 0;
    bErrorCode = parser.GetXMLInteger("error.errorCode", errorCode);
    bErrorName = parser.GetXMLString("error.errorName", errorName);
    if (bErrorCode || bErrorName)
    {
        return;
    }
    for (skipcount = 0; parser.GetXMLInteger("getmessages.messages.servermessage.messageid", messageEntryIter.messageId, skipcount); ++skipcount)
    {
        parser.GetXMLString("getmessages.messages.servermessage.sourcename", messageEntryIter.SourceName, skipcount);
        parser.GetXMLString("getmessages.messages.servermessage.payload.attrmap.entry key=\"" $ GetFirstBlazeAttrId() $ "\"", messageEntryIter.param1, skipcount);
        parser.GetXMLString("getmessages.messages.servermessage.payload.attrmap.entry key=\"" $ GetFirstBlazeAttrId() + 1 $ "\"", messageEntryIter.param2, skipcount);
        parser.GetXMLString("getmessages.messages.servermessage.payload.attrmap.entry key=\"" $ GetFirstBlazeAttrId() + 2 $ "\"", messageEntryIter.param3, skipcount);
        messageEntries.AddItem(messageEntryIter);
    }
    if (messageEntries.Length > 0)
    {
        messageEntries.Remove(messageEntries.Length - 1, 1);
    }
}
public event function ParseHTTPRatingsAssetsLevel(SFXOnlineHTTPRequest request, out array<int> updatedSecurityRatings, out array<int> updatedWarAssets, out int Level, out int errorCode)
{
    local SFXOnlineComponentXMLParser parser;
    local int IntResult;
    local int skipcount;
    local int idx;
    local string errorName;
    local bool bErrorCode;
    local bool bErrorName;
    
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing(request.mResultBody);
    errorCode = 0;
    bErrorCode = parser.GetXMLInteger("error.errorCode", errorCode);
    bErrorName = parser.GetXMLString("error.errorName", errorName);
    if (bErrorCode || bErrorName)
    {
        return;
    }
    for (skipcount = 0; parser.GetXMLInteger("galaxyatwargetratings.ratings.ratings", IntResult, skipcount); ++skipcount)
    {
        updatedSecurityRatings.AddItem(IntResult);
    }
    if (updatedSecurityRatings.Length == 0)
    {
    }
    else
    {
        updatedSecurityRatings.Remove(updatedSecurityRatings.Length - 1, 1);
    }
    for (idx = 0; idx < updatedSecurityRatings.Length; ++idx)
    {
        updatedSecurityRatings[idx] /= float(100);
    }
    m_CachedSecurityRatings = updatedSecurityRatings;
    m_CachedRatingsValid = TRUE;
    if (updatedWarAssets.Length > 0)
    {
        m_CachedWarAssets = updatedWarAssets;
        m_CachedWarAssetsValid = TRUE;
    }
    for (skipcount = 0; parser.GetXMLInteger("galaxyatwargetratings.assets.assets", IntResult, skipcount); ++skipcount)
    {
        updatedWarAssets.AddItem(IntResult);
    }
    if (updatedWarAssets.Length == 0)
    {
    }
    else
    {
        updatedWarAssets.Remove(updatedWarAssets.Length - 1, 1);
    }
    if (parser.GetXMLInteger("galaxyatwargetratings.level", Level, 0))
    {
    }
    Level /= float(100);
    m_CachedLevel = Level;
}
public event function ParseSendMessageResult(SFXOnlineHTTPRequest request, out int messageId, out array<int> messageIds, out int errorCode)
{
    local SFXOnlineComponentXMLParser parser;
    local int messageIdIter;
    local int skipcount;
    local string errorName;
    local bool bErrorCode;
    local bool bErrorName;
    
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing(request.mResultBody);
    errorCode = 0;
    bErrorCode = parser.GetXMLInteger("error.errorCode", errorCode);
    bErrorName = parser.GetXMLString("error.errorName", errorName);
    if (bErrorCode || bErrorName)
    {
        return;
    }
    parser.GetXMLInteger("galaxyatwargetratings.assets.assets", messageId);
    for (skipcount = 0; parser.GetXMLInteger("sendmessage.messageids.messageids", messageIdIter, skipcount); ++skipcount)
    {
        messageIds.AddItem(messageIdIter);
    }
    if (messageIds.Length > 0)
    {
        messageIds.Remove(messageIds.Length - 1, 1);
    }
}
public event function ParseTouchMessagesResult(SFXOnlineHTTPRequest request, out int numMsgs, out int errorCode)
{
    local SFXOnlineComponentXMLParser parser;
    local string errorName;
    local bool bErrorCode;
    local bool bErrorName;
    
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing(request.mResultBody);
    errorCode = 0;
    bErrorCode = parser.GetXMLInteger("error.errorCode", errorCode);
    bErrorName = parser.GetXMLString("error.errorName", errorName);
    if (bErrorCode || bErrorName)
    {
        return;
    }
    parser.GetXMLInteger("touchmessages.count", numMsgs);
}
public native function SendMessage(int msgType, string sendMsgParam1, EGawParamType ParamType, string sendMsgParam3, delegate<OnSendMessageComplete> OnSendMessageComplete);

public event function SetBaseURL(string sURL)
{
    BaseUrl = sURL;
}
public native function TouchMessages(int msgType, delegate<OnTouchMessagesComplete> funcOnRequestComplete);

public function TestGetMessagesCallback(array<MessageEntry> Messages, int errorCode)
{
    local MessageEntry MessageEntry;
    
    if (errorCode > 0)
    {
    }
    foreach Messages(MessageEntry, )
    {
    }
}
public function TestGetRatingsCallback(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int tempInt;
    
    if (errorCode > 0)
    {
    }
    foreach updatedSecurityRatings(tempInt, )
    {
    }
    foreach updatedWarAssets(tempInt, )
    {
    }
}
public function TestSendMessageCallback(int messageId, array<int> messageIds, int errorCode)
{
    local int tempInt;
    
    if (errorCode > 0)
    {
    }
    foreach messageIds(tempInt, )
    {
    }
}
public function TestTouchMessagesCallback(int Count, int errorCode)
{
    if (errorCode > 0)
    {
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LevelChangeStrRef = $682933
}