Class LocalMessage
    abstract;

var float Lifetime;
var Color DrawColor;
var float PosY;
var int FontSize;
var bool bIsSpecial;
var bool bIsUnique;
var bool bIsPartiallyUnique;
var bool bIsConsoleMessage;
var bool bBeep;
var bool bCountInstances;

public static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (Class<Actor>(OptionalObject) != None)
    {
        return Class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
    }
    return "";
}
public static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string MessageString;
    
    MessageString = GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    if (MessageString != "")
    {
        if (P.myHUD != None)
        {
            P.myHUD.LocalizedMessage(default.Class, RelatedPRI_1, MessageString, Switch, GetPos(Switch, P.myHUD), GetLifeTime(Switch), GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), GetColor(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), OptionalObject);
        }
        if (IsConsoleMessage(Switch) && LocalPlayer(P.Player) != None && LocalPlayer(P.Player).ViewportClient != None)
        {
            LocalPlayer(P.Player).ViewportClient.ViewportConsole.OutputText(MessageString);
        }
    }
}
public static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.DrawColor;
}
public static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    return default.DrawColor;
}
public static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    return default.FontSize;
}
public static function float GetLifeTime(int Switch)
{
    return default.Lifetime;
}
public static function float GetPos(int Switch, HUD myHUD)
{
    return default.PosY;
}
public static function bool IsConsoleMessage(int Switch)
{
    return default.bIsConsoleMessage;
}
public static function bool IsKeyObjectiveMessage(int Switch)
{
    return FALSE;
}
public static function bool PartiallyDuplicates(int Switch1, int Switch2, Object OptionalObject1, Object OptionalObject2)
{
    return Switch1 == Switch2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Lifetime = 3.0
    DrawColor = {B = 255, G = 255, R = 255, A = 255}
    PosY = 0.829999983
    bIsSpecial = TRUE
    bIsConsoleMessage = TRUE
}