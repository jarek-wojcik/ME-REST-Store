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
    local int i;
    
    Id = ExtractJsonField(JsonText, "id");
    if (Id == "")
    {
        return FALSE;
    }
    Model.Id = Id;
    Model.SortOrder = ExtractJsonField(JsonText, "sortOrder");
    Model.TeamId = ExtractJsonField(JsonText, "teamId");
    Model.bActive = ExtractJsonField(JsonText, "active") == "true";
    Model.Name = ExtractJsonField(JsonText, "name");
    Model.PreferredSpecies = ExtractJsonField(JsonText, "preferredSpecies");
    Model.VoiceCharId = ExtractJsonField(JsonText, "voiceCharId");
    Model.CharacterID = ExtractJsonField(JsonText, "characterId");
    Model.AppearanceCharID = ExtractJsonField(JsonText, "appearanceCharId");
    Model.AppearancePawnType = ExtractJsonField(JsonText, "appearancePawnType");
    Model.bUseHelmet = ExtractJsonField(JsonText, "appearanceHelmet") == "true";
    Model.bUseHeadgear = ExtractJsonField(JsonText, "appearanceHeadgear") == "true";
    Model.DodgeCharId = ExtractJsonField(JsonText, "dodgeCharId");
    Model.HeavyMeleeCharId = ExtractJsonField(JsonText, "heavyMeleeCharId");
    Model.LightMeleeCharId = ExtractJsonField(JsonText, "lightMeleeCharId");
    Model.Level = int(ExtractJsonField(JsonText, "level"));
    Model.XP = int(ExtractJsonField(JsonText, "xp"));
    Model.ShieldType = ExtractJsonField(JsonText, "shieldType");
    Model.SkillPoints = int(ExtractJsonField(JsonText, "skillPoints"));
    Model.SkillLevel_Pistols = int(ExtractJsonField(JsonText, "skillLevels.Pistols"));
    Model.SkillLevel_SMGs = int(ExtractJsonField(JsonText, "skillLevels.SMGs"));
    Model.SkillLevel_AssaultRifles = int(ExtractJsonField(JsonText, "skillLevels.AssaultRifles"));
    Model.SkillLevel_Shotguns = int(ExtractJsonField(JsonText, "skillLevels.Shotguns"));
    Model.SkillLevel_SniperRifles = int(ExtractJsonField(JsonText, "skillLevels.SniperRifles"));
    Model.SkillLevel_MeleeCombat = int(ExtractJsonField(JsonText, "skillLevels.MeleeCombat"));
    Model.SkillLevel_Gadgets = int(ExtractJsonField(JsonText, "skillLevels.Gadgets"));
    Model.SkillLevel_Tech = int(ExtractJsonField(JsonText, "skillLevels.Tech"));
    Model.SkillLevel_Biotics = int(ExtractJsonField(JsonText, "skillLevels.Biotics"));
    Model.SkillLevel_Barrier = int(ExtractJsonField(JsonText, "skillLevels.Barrier"));
    Model.SkillLevel_Shielding = int(ExtractJsonField(JsonText, "skillLevels.Shielding"));
    Model.SkillLevel_SpectreTraining = int(ExtractJsonField(JsonText, "skillLevels.SpectreTraining"));
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
    Power.KitID = ExtractJsonField(JsonText, Prefix $ ".kitId");
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
    Power.KitID = ExtractJsonField(JsonText, "borrowedPower.kitId");
    return TRUE;
}
static function bool ExtractWeapon(string JsonText, int Index, out SFSWeaponModelStruct Weapon)
{
    local string Prefix;
    local string WeaponID;
    local string Mod1ID;
    local string Mod2ID;
    local string FireMode;
    
    Prefix = "weapons[" $ Index $ "]";
    WeaponID = ExtractJsonField(JsonText, Prefix $ ".weaponId");
    if (WeaponID == "")
    {
        return FALSE;
    }
    Mod1ID = ExtractJsonField(JsonText, Prefix $ ".mod1Id");
    Mod2ID = ExtractJsonField(JsonText, Prefix $ ".mod2Id");
    FireMode = ExtractJsonField(JsonText, Prefix $ ".fireMode");
    return Class'SFSWeaponModel'.static.FromTokens(WeaponID, Mod1ID, Mod2ID, FireMode, Weapon);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}