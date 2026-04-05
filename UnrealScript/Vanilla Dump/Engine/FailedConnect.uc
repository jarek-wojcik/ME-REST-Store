Class FailedConnect extends LocalMessage
    abstract;

var const localized string FailMessage[4];

public static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.FailMessage[Clamp(Switch, 0, 3)];
}
public static function int GetFailSwitch(string FailString)
{
    if (FailString ~= "NEEDPW")
    {
        return 0;
    }
    if (FailString ~= "WRONGPW")
    {
        return 1;
    }
    if (FailString ~= "GAMESTARTED")
    {
        return 2;
    }
    return 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FailMessage[0] = "FAILED TO JOIN GAME.  NEED PASSWORD."
    FailMessage[1] = "FAILED TO JOIN GAME.  WRONG PASSWORD."
    FailMessage[2] = "FAILED TO JOIN GAME.  GAME HAS STARTED."
    FailMessage[3] = "FAILED TO JOIN GAME."
    DrawColor = {B = 128, G = 0, R = 255, A = 255}
    FontSize = 1
    bIsUnique = TRUE
}