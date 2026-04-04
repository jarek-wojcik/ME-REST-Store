Class SFSCharacterJsonParser;

// Extracts the value of a field from a simpleJson string.
// The format is one "key:value" per line with no quotes, braces, or extra whitespace.
// Nested fields use dot-notation (borrowedPower.rank) and array elements use
// bracket-notation (powers[0].powerId).
//
// Matching anchors on a newline immediately before the key so that "id" cannot
// accidentally match the tail of "characterId". A newline is prepended to the
// text before searching so that the very first line is also found.
static function string ExtractJsonField(string JsonText, string Key)
{
    local int Pos;
    local int EndPos;
    local string SearchKey;
    local string Newline;
    local string Text;

    Newline = Chr(10);
    SearchKey = Newline $ Key $ ":";
    Text = Newline $ JsonText;

    Pos = InStr(Text, SearchKey);
    if (Pos == -1)
    {
        return "";
    }
    Pos += Len(SearchKey);

    // Advance to end-of-line, stopping before any newline or carriage return
    EndPos = Pos;
    while (EndPos < Len(Text))
    {
        if (Mid(Text, EndPos, 1) == Newline || Mid(Text, EndPos, 1) == Chr(13))
        {
            break;
        }
        EndPos++;
    }

    return Mid(Text, Pos, EndPos - Pos);
}

// Parses a simpleJson response into the top-level scalar fields of Model.
// Weapon, power, and inventory slots are not populated here.
// Returns TRUE when a non-empty Id was found, FALSE otherwise.
static function bool FromSimpleJson(string JsonText, out SFSCharacterModelStruct Model)
{
    local string Id;
    local string CharacterName;
    local string CharacterId;
    local string AppearanceCharId;
    local string AppearancePawnType;
    local string Active;
    local string TeamId;
    local string SortOrder;
    local int i;

    Id                 = ExtractJsonField(JsonText, "id");
    CharacterName      = ExtractJsonField(JsonText, "name");
    CharacterId        = ExtractJsonField(JsonText, "characterId");
    AppearanceCharId   = ExtractJsonField(JsonText, "appearanceCharId");
    AppearancePawnType = ExtractJsonField(JsonText, "appearancePawnType");
    Active             = ExtractJsonField(JsonText, "active");
    TeamId             = ExtractJsonField(JsonText, "teamId");
    SortOrder          = ExtractJsonField(JsonText, "sortOrder");

    if (Id == "")
    {
        return FALSE;
    }

    Model.Id                 = Id;
    Model.Name               = CharacterName;
    Model.CharacterID        = CharacterId;
    Model.AppearanceCharID   = AppearanceCharId;
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

    // Weapons
    Class'SFSWeaponModel'.static.FromTokens(
        ExtractJsonField(JsonText, "weaponId"),
        ExtractJsonField(JsonText, "weaponMod1Id"),
        ExtractJsonField(JsonText, "weaponMod2Id"),
        Model.Weapon1);
    Model.bHasWeapon2 = Class'SFSWeaponModel'.static.FromTokens(
        ExtractJsonField(JsonText, "weapon2Id"),
        ExtractJsonField(JsonText, "weapon2Mod1Id"),
        ExtractJsonField(JsonText, "weapon2Mod2Id"),
        Model.Weapon2);

    // Inventory
    Class'SFSInventoryModel'.static.FromTokens(
        ExtractJsonField(JsonText, "armorConsumableId"),
        ExtractJsonField(JsonText, "weaponConsumableId"),
        ExtractJsonField(JsonText, "ammoConsumableId"),
        ExtractJsonField(JsonText, "gearConsumableId"),
        Model.Inventory);

    return TRUE;
}

// Fills a single SFSPowerModelStruct from the powers[Index] fields.
// Returns TRUE if a powerId was found for that index.
static function bool ExtractPower(string JsonText, int Index, out SFSPowerModelStruct Power)
{
    local string Prefix;
    local string PowerId;

    Prefix  = "powers[" $ Index $ "]";
    PowerId = ExtractJsonField(JsonText, Prefix $ ".powerId");
    if (PowerId == "")
    {
        return FALSE;
    }

    Power.PowerID = PowerId;
    Power.Rank    = int(ExtractJsonField(JsonText, Prefix $ ".rank"));
    Power.Evo0    = ExtractJsonField(JsonText, Prefix $ ".evolution[0]");
    Power.Evo1    = ExtractJsonField(JsonText, Prefix $ ".evolution[1]");
    Power.Evo2    = ExtractJsonField(JsonText, Prefix $ ".evolution[2]");
    return TRUE;
}

// Fills a single SFSPowerModelStruct from the borrowedPower fields.
// Returns TRUE if a borrowedPower.powerId was found.
static function bool ExtractBorrowedPower(string JsonText, out SFSPowerModelStruct Power)
{
    local string PowerId;

    PowerId = ExtractJsonField(JsonText, "borrowedPower.powerId");
    if (PowerId == "")
    {
        return FALSE;
    }

    Power.PowerID = PowerId;
    Power.Rank    = int(ExtractJsonField(JsonText, "borrowedPower.rank"));
    Power.Evo0    = ExtractJsonField(JsonText, "borrowedPower.evolution[0]");
    Power.Evo1    = ExtractJsonField(JsonText, "borrowedPower.evolution[1]");
    Power.Evo2    = ExtractJsonField(JsonText, "borrowedPower.evolution[2]");
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
