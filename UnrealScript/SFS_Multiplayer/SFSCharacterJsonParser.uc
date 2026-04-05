Class SFSCharacterJsonParser;

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
    // Advance to end-of-line, stopping before any newline or carriage return
    for (EndPos = Pos; EndPos < Len(Text); EndPos++)
    {
        if (Mid(Text, EndPos, 1) == Newline || Mid(Text, EndPos, 1) == Chr(13))
        {
            break;
        }
    }
    return Mid(Text, Pos, EndPos - Pos);
}
static function bool FromSimpleJson(string JsonText, out SFSCharacterModelStruct Model)
{
    local string Id;
    local string CharacterName;
    local string CharacterID;
    local string AppearanceCharID;
    local string AppearancePawnType;
    local string Active;
    local string TeamId;
    local string SortOrder;
    local int i;
    
    Id = ExtractJsonField(JsonText, "id");
    CharacterName = ExtractJsonField(JsonText, "name");
    CharacterID = ExtractJsonField(JsonText, "characterId");
    AppearanceCharID = ExtractJsonField(JsonText, "appearanceCharId");
    AppearancePawnType = ExtractJsonField(JsonText, "appearancePawnType");
    Active = ExtractJsonField(JsonText, "active");
    TeamId = ExtractJsonField(JsonText, "teamId");
    SortOrder = ExtractJsonField(JsonText, "sortOrder");
    if (Id == "")
    {
        return FALSE;
    }
    Model.Id = Id;
    Model.Name = CharacterName;
    Model.CharacterID = CharacterID;
    Model.AppearanceCharID = AppearanceCharID;
    Model.AppearancePawnType = AppearancePawnType;
    // Powers
    Model.PowerCount = 0;
    for (i = 0; i < 5; i++)
    {
        if (ExtractPower(JsonText, i, Model.Powers[Model.PowerCount]))
        {
            Model.PowerCount++;
        }
    }
    // Borrowed power
    Model.bHasBorrowedPower = ExtractBorrowedPower(JsonText, Model.BorrowedPower);
    // Weapons: up to 5 slots using weapons[N].weaponId keys
    Model.WeaponCount = 0;
    for (i = 0; i < 5; i++)
    {
        if (ExtractWeapon(JsonText, i, Model.Weapons[Model.WeaponCount]))
        {
            Model.WeaponCount++;
        }
    }
    // Inventory
    Class'SFSInventoryModel'.static.FromTokens(ExtractJsonField(JsonText, "armorConsumableId"), ExtractJsonField(JsonText, "weaponConsumableId"), ExtractJsonField(JsonText, "ammoConsumableId"), ExtractJsonField(JsonText, "gearConsumableId"), Model.Inventory);
    return TRUE;
}
static function bool ExtractPower(string JsonText, int Index, out SFSPowerModelStruct Power)
{
    local string Prefix;
    local string PowerID;
    
    Prefix = "powers[" $ Index $ "]";
    PowerID = ExtractJsonField(JsonText, Prefix $ ".powerId");
    if (PowerID == "")
    {
        return FALSE;
    }
    Power.PowerID = PowerID;
    Power.Rank = int(ExtractJsonField(JsonText, Prefix $ ".rank"));
    Power.Evo0 = ExtractJsonField(JsonText, Prefix $ ".evolution[0]");
    Power.Evo1 = ExtractJsonField(JsonText, Prefix $ ".evolution[1]");
    Power.Evo2 = ExtractJsonField(JsonText, Prefix $ ".evolution[2]");
    return TRUE;
}
static function bool ExtractBorrowedPower(string JsonText, out SFSPowerModelStruct Power)
{
    local string PowerID;
    
    PowerID = ExtractJsonField(JsonText, "borrowedPower.powerId");
    if (PowerID == "")
    {
        return FALSE;
    }
    Power.PowerID = PowerID;
    Power.Rank = int(ExtractJsonField(JsonText, "borrowedPower.rank"));
    Power.Evo0 = ExtractJsonField(JsonText, "borrowedPower.evolution[0]");
    Power.Evo1 = ExtractJsonField(JsonText, "borrowedPower.evolution[1]");
    Power.Evo2 = ExtractJsonField(JsonText, "borrowedPower.evolution[2]");
    return TRUE;
}
static function bool ExtractWeapon(string JsonText, int Index, out SFSWeaponModelStruct Weapon)
{
    local string Prefix;
    local string WeaponID;
    
    Prefix = "weapons[" $ Index $ "]";
    WeaponID = ExtractJsonField(JsonText, Prefix $ ".weaponId");
    if (WeaponID == "")
    {
        return FALSE;
    }
    return Class'SFSWeaponModel'.static.FromTokens(WeaponID, ExtractJsonField(JsonText, Prefix $ ".mod1Id"), ExtractJsonField(JsonText, Prefix $ ".mod2Id"), Weapon);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}