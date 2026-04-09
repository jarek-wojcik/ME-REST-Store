Class SFSCharacterModel;

struct SFSCharacterModelStruct 
{
    var string Id;
    var string Name;
    var string CharacterID;
    var string AppearanceCharID;
    var string AppearancePawnType;
    var SFSWeaponModelStruct Weapons[5];
    var int WeaponCount;
    var SFSPowerModelStruct Powers[5];
    var int PowerCount;
    var bool bHasBorrowedPower;
    var SFSPowerModelStruct BorrowedPower;
    var SFSInventoryModelStruct Inventory;
    
    structdefaultproperties
    {
        Weapons[0] = {WeaponID = "", Mod1ID = "", Mod2ID = ""}
        Weapons[1] = {WeaponID = "", Mod1ID = "", Mod2ID = ""}
        Weapons[2] = {WeaponID = "", Mod1ID = "", Mod2ID = ""}
        Weapons[3] = {WeaponID = "", Mod1ID = "", Mod2ID = ""}
        Weapons[4] = {WeaponID = "", Mod1ID = "", Mod2ID = ""}
        Powers[0] = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
        Powers[1] = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
        Powers[2] = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
        Powers[3] = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
        Powers[4] = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
        BorrowedPower = {PowerID = "", Rank = 0, Evo0 = "", Evo1 = "", Evo2 = ""}
    }
};

static function bool FromFlat(string FlatResponse, out SFSCharacterModelStruct Model)
{
    local array<string> Tokens;
    local int i;
    local int WeaponBase;
    local int PowerBase;
    
    Class'SFSArrayUtility'.static.SplitStringIntoParts(FlatResponse, "|", Tokens);
    // Minimum: id|name|charId|appearCharId + 15 weapon fields + 5 powers = 24
    if (Tokens.Length < 24)
    {
        return FALSE;
    }
    Model.Id = Tokens[0];
    Model.Name = Tokens[1];
    Model.CharacterID = Tokens[2];
    Model.AppearanceCharID = Tokens[3];
    // Weapon slots: indices 4-18 (5 slots x 3 fields each)
    Model.WeaponCount = 0;
    WeaponBase = 4;
    for (i = 0; i < 5; i++)
    {
        if (Class'SFSWeaponModel'.static.FromTokens(Tokens[WeaponBase + i * 3], Tokens[WeaponBase + i * 3 + 1], Tokens[WeaponBase + i * 3 + 2], Model.Weapons[Model.WeaponCount]))
        {
            Model.WeaponCount++;
        }
    }
    // Power slots: indices 19-23
    Model.PowerCount = 0;
    PowerBase = 19;
    for (i = PowerBase; i <= PowerBase + 4; i++)
    {
        if (i < Tokens.Length && Tokens[i] != "")
        {
            if (Class'SFSPowerModel'.static.FromToken(Tokens[i], Model.Powers[Model.PowerCount]))
            {
                Model.PowerCount++;
            }
        }
    }
    // Borrowed power: index 24
    Model.bHasBorrowedPower = Tokens.Length > 24 && Tokens[24] != "" && Class'SFSPowerModel'.static.FromToken(Tokens[24], Model.BorrowedPower);
    // Consumables: indices 25-28
    if (Tokens.Length > 28)
    {
        Class'SFSInventoryModel'.static.FromTokens(Tokens[25], Tokens[26], Tokens[27], Tokens[28], Model.Inventory);
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}