Class ISFXOnlineComponentGalaxyAtWar extends ISFXOnlineComponent
    native
    abstract;

enum EGawParamType
{
    GawMsgParamType_Bool,
    GawMsgParamType_Int,
    GawMsgParamType_Float,
};
enum EGaWMsgType
{
    GaWMsgType_Zero,
    GaWMsgType_PlotEvent,
};
struct native MessageEntry 
{
    var string SourceName;
    var string param1;
    var string param2;
    var string param3;
    var int messageId;
};
struct native AttributeMapEntry 
{
    var string Value;
    var int EntryId;
};
struct native MapEntry 
{
    var int EntryId;
    var int IncreaseValue;
};

var delegate<OnGetRatingsComplete> __OnGetRatingsComplete__Delegate;
var delegate<OnIncreaseRatingsComplete> __OnIncreaseRatingsComplete__Delegate;
var delegate<OnSendMessageComplete> __OnSendMessageComplete__Delegate;
var delegate<OnGetMessagesComplete> __OnGetMessagesComplete__Delegate;
var delegate<OnTouchMessagesComplete> __OnTouchMessagesComplete__Delegate;
var delegate<AuthenticateCompleted> __AuthenticateCompleted__Delegate;

public delegate function AuthenticateCompleted(int errorCode);

public native function Cleanup();

public native function GetAuthenticationHTTPRequest(string token, int tokenType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetGetMessagesHTTPRequest(int msgType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetIncreaseRatingsHTTPRequest(int defaultRatingIncrease, array<MapEntry> securityRatingsIncrease, array<MapEntry> warAssetsIncrease, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetMessages(int msgType, delegate<OnGetMessagesComplete> funcOnRequestComplete);

public native function GetRatings(bool getWarAssets, bool bCached, delegate<OnGetRatingsComplete> funcOnRequestComplete);

public native function GetRatingsHTTPRequest(bool getAssets, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetSendMessageHTTPRequest(int msgType, string param1, string param2, string param3, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function GetTouchMessagesHTTPRequest(int msgType, out SFXOnlineHTTPRequest pSFXOnlineHTTPRequest);

public native function IncreaseRatings(int defaultRatingIncrease, array<MapEntry> securityRatingIncrease, array<MapEntry> warAssetIncrease, delegate<OnIncreaseRatingsComplete> funcOnRequestComplete);

public event function InvalidateSession();

public event function bool IsSessionValid();

public delegate function OnGetMessagesComplete(array<MessageEntry> Messages, int errorCode);

public delegate function OnGetRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public delegate function OnIncreaseRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public delegate function OnSendMessageComplete(int messageId, array<int> messageIds, int errorCode);

public delegate function OnTouchMessagesComplete(int Count, int errorCode);

public event function int ParseAuthenticationResult(SFXOnlineHTTPRequest request);

public event function ParseGetMessagesResult(SFXOnlineHTTPRequest request, out array<MessageEntry> messageEntries, out int errorCode);

public event function ParseHTTPRatingsAssetsLevel(SFXOnlineHTTPRequest request, out array<int> updatedSecurityRatings, out array<int> updatedWarAssets, out int Level, out int errorCode);

public event function ParseSendMessageResult(SFXOnlineHTTPRequest request, out int messageId, out array<int> messageIds, out int errorCode);

public event function ParseTouchMessagesResult(SFXOnlineHTTPRequest request, out int numMsgs, out int errorCode);

public native function SendMessage(int msgType, string sendMsgParam1, EGawParamType ParamType, string sendMsgParam3, delegate<OnSendMessageComplete> OnSendMessageComplete);

public event function SetBaseURL(string BaseUrl);

public native function TouchMessages(int msgType, delegate<OnTouchMessagesComplete> funcOnRequestComplete);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}