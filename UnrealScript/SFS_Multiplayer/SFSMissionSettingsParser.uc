Class SFSMissionSettingsParser;

static function string ExtractJsonField(string JsonText, string key)
{
    local int Pos;
    local int EndPos;
    local string SearchKey;
    local string Newline;
    local string Text;
    
    Newline = Chr(10);
    SearchKey = Newline $ key $ ":";
    Text = Newline $ JsonText;
    Pos = InStr(Text, SearchKey, , , );
    if (Pos == -1)
    {
        return "";
    }
    Pos += Len(SearchKey);
    for (EndPos = Pos; EndPos < Len(Text); EndPos++)
    {
        if (Mid(Text, EndPos, 1) == Newline || Mid(Text, EndPos, 1) == Chr(13))
        {
            break;
        }
    }
    return Mid(Text, Pos, EndPos - Pos);
}
static function bool ExtractBool(string JsonText, string key)
{
    return ExtractJsonField(JsonText, key) == "true";
}
static function int ExtractInt(string JsonText, string key)
{
    return int(ExtractJsonField(JsonText, key));
}
static function string ExtractString(string JsonText, string key)
{
    return ExtractJsonField(JsonText, key);
}
static function bool FromSimpleJson(string JsonText, out SFSMissionSettingsStruct Settings)
{
    local int i;
    local string ArchEntry;
    
    Settings.bDisableObjectiveWaves = ExtractBool(JsonText, "disableObjectiveWaves");
    Settings.StartWave = ExtractInt(JsonText, "startWave");
    Settings.MaxEnemies = ExtractInt(JsonText, "maxEnemies");
    Settings.MaxEnemiesPerSpawnPoint = ExtractInt(JsonText, "maxEnemiesPerSpawnPoint");
    Settings.BlockedEnemyArchetypes.Length = 0;
    for (i = 0; i < 30; i++)
    {
        ArchEntry = ExtractString(JsonText, "blockedEnemies[" $ i $ "]");
        if (ArchEntry == "")
        {
            break;
        }
        Settings.BlockedEnemyArchetypes.AddItem(ArchEntry);
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}