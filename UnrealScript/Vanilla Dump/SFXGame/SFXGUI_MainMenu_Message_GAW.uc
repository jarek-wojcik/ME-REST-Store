Class SFXGUI_MainMenu_Message_GAW extends SFXGUI_MainMenu_Message
    transient
    config(UI);

struct RatingThresholdMessage 
{
    var int nStart;
    var int nEnd;
    var stringref srMessage;
};

var array<GAWZoneGUIData> GAWRatings;
var config array<RatingThresholdMessage> OverallRatingMessages;
var config string GAWGlobalReadinessColor;
var delegate<GAWZoneSort> __GAWZoneSort__Delegate;
var SFXGAWAssetsHandler GAWAssetHandler;
var int GAWOverallReadinessRating;
var config stringref GAWMessageTitle;
var config stringref GAWOverallRating;
var config stringref GAWZoneStatusFormat;
var config stringref GAWFormattedReadinessPercent;

public function Cleanup()
{
    Super.Cleanup();
    if (GAWAssetHandler != None)
    {
        GAWAssetHandler.Cleanup();
        GAWAssetHandler = None;
    }
    GAWRatings.Length = 0;
}
public event function OnLoad()
{
    GAWAssetHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    GAWAssetHandler.RequestGAWRatings(OnGAWRequestFinished, FALSE);
}
public event function OnLoadComplete()
{
    local GAWZoneGUIData aRating;
    local string strGAWMessageTotal;
    local string srtGAWGlobalReadiness;
    local array<SFXTokenMapping> TokenList;
    local RatingThresholdMessage RatingMessage;
    local int nIndex;
    local int nArraySize;
    
    nArraySize = GAWRatings.Length;
    for (nIndex = 0; nIndex < nArraySize; nIndex++)
    {
        aRating = GAWRatings[nIndex];
        AS_SetZoneReadiness(int(aRating.ZoneID), aRating.CurrentRating);
        AS_SetZoneDisplayNumber(int(aRating.ZoneID), aRating.ZoneDisplayNumber);
    }
    Class'Object'.static.ClearCustomTokens();
    TokenList.Length = 0;
    TokenList.Add(1);
    TokenList[0].TokenId = 0;
    TokenList[0].Data = string(GAWOverallReadinessRating);
    srtGAWGlobalReadiness = Class'SFXGUIMovie'.static.GetTokenizedUIString(GAWFormattedReadinessPercent, TokenList);
    srtGAWGlobalReadiness = "<font color='" $ GAWGlobalReadinessColor $ "'>" $ srtGAWGlobalReadiness $ "</font>";
    Class'Object'.static.ClearCustomTokens();
    TokenList.Length = 0;
    TokenList.Add(2);
    TokenList[0].TokenId = 1;
    TokenList[0].Data = srtGAWGlobalReadiness;
    strGAWMessageTotal = Class'SFXGUIMovie'.static.GetTokenizedUIString(GAWOverallRating, TokenList) $ "\n";
    GAWRatings.Sort(GAWZoneSort);
    Class'Object'.static.ClearCustomTokens();
    TokenList.Length = 0;
    TokenList.Add(3);
    TokenList[0].TokenId = 0;
    TokenList[0].Data = "";
    TokenList[1].TokenId = 1;
    TokenList[1].Data = "";
    TokenList[2].TokenId = 2;
    TokenList[2].Data = "";
    for (nIndex = 0; nIndex < nArraySize; nIndex++)
    {
        aRating = GAWRatings[nIndex];
        TokenList[0].Data = string(aRating.ZoneDisplayNumber);
        TokenList[1].Data = aRating.ZoneName;
        TokenList[2].Data = string(aRating.CurrentRating);
        strGAWMessageTotal $= Class'SFXGUIMovie'.static.GetTokenizedUIString(GAWZoneStatusFormat, TokenList) $ "\n";
        Class'Object'.static.ClearCustomTokens();
    }
    strGAWMessageTotal $= "\n";
    foreach OverallRatingMessages(RatingMessage, )
    {
        if (GAWOverallReadinessRating >= RatingMessage.nStart && GAWOverallReadinessRating <= RatingMessage.nEnd)
        {
            strGAWMessageTotal = strGAWMessageTotal $ Class'SFXGUIMovie'.static.GetUIString(RatingMessage.srMessage);
            break;
        }
    }
    AS_SetGAWSummary(strGAWMessageTotal);
    Super.OnLoadComplete();
}
public final function AS_SetGAWSummary(string strGAWSummaryText)
{
    MovieClip.ActionScriptVoid("SetMessageText");
}
public final function AS_SetZoneDisplayNumber(int nZoneId, int nZoneDisplayNumber)
{
    MovieClip.ActionScriptVoid("SetZoneDisplayNumber");
}
public final function AS_SetZoneReadiness(int nZoneId, int nReadiness)
{
    MovieClip.ActionScriptVoid("SetZoneReadiness");
}
public static function SFXGUI_MainMenu_Message CreateMessage(int nMessageId)
{
    local SFXGUI_MainMenu_Message_GAW NewMessage;
    
    NewMessage = new Class'SFXGUI_MainMenu_Message_GAW';
    NewMessage.Id = nMessageId;
    NewMessage.Title = Class'SFXGUIMovie'.static.GetUIString(Class'SFXGUI_MainMenu_Message_GAW'.default.GAWMessageTitle);
    NewMessage.MessageType = SFXOnlineConnection_MessageType.SFXONLINE_MT_GAW_SUMMARY;
    return NewMessage;
}
public delegate function int GAWZoneSort(GAWZoneGUIData A, GAWZoneGUIData B)
{
    return A.ZoneDisplayNumber <= B.ZoneDisplayNumber ? 0 : -1;
}
public function OnGAWRequestFinished(array<GAWZoneGUIData> ZoneData, int OverallReadinessRating, int errorCode)
{
    if (errorCode == 0)
    {
        Status = MMM_Status.MMM_DataLoadSuccess;
        GAWRatings = ZoneData;
        GAWOverallReadinessRating = OverallReadinessRating;
    }
    else
    {
        Self.Status = MMM_Status.MMM_DataLoadFailed;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OverallRatingMessages = ({nStart = 0, nEnd = 24, srMessage = $724251}, 
                             {nStart = 25, nEnd = 49, srMessage = $724252}, 
                             {nStart = 50, nEnd = 74, srMessage = $724253}, 
                             {nStart = 75, nEnd = 1000000, srMessage = $724254}
                            )
    GAWGlobalReadinessColor = "#FFFFFF"
    GAWMessageTitle = $611521
    GAWOverallRating = $718188
    GAWZoneStatusFormat = $718076
    GAWFormattedReadinessPercent = $710700
}