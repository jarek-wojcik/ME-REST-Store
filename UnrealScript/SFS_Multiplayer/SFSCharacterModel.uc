Class SFSCharacterModel;

struct SFSCharacterModelStruct 
{
    var string Id;
    var string Name;
    var string CharacterID;
    var string AppearanceCharID;
    var string AppearancePawnType;
    var SFSWeaponModelStruct Weapon1;
    var bool bHasWeapon2;
    var SFSWeaponModelStruct Weapon2;
    var SFSPowerModelStruct Powers[5];
    var int PowerCount;
    var bool bHasBorrowedPower;
    var SFSPowerModelStruct BorrowedPower;
    var SFSInventoryModelStruct Inventory;
};

static function bool FromFlat(string FlatResponse, out SFSCharacterModelStruct Model)
{
    local array<string> Tokens;
    local int i;
    
    Class'SFSArrayUtility'.static.SplitStringIntoParts(FlatResponse, "|", Tokens);
    if (Tokens.Length < 10)
    {
        return FALSE;
    }
    Model.Id = Tokens[0];
    Model.Name = Tokens[1];
    Model.CharacterID = Tokens[2];
    Model.AppearanceCharID = Tokens[3];
    Class'SFSWeaponModel'.static.FromTokens(Tokens[4], Tokens[5], Tokens[6], Model.Weapon1);
    Model.bHasWeapon2 = Class'SFSWeaponModel'.static.FromTokens(Tokens[7], Tokens[8], Tokens[9], Model.Weapon2);
    Model.PowerCount = 0;
    for (i = 10; i <= 14; i++)
    {
        if (i < Tokens.Length && Tokens[i] != "")
        {
            if (Class'SFSPowerModel'.static.FromToken(Tokens[i], Model.Powers[Model.PowerCount]))
            {
                Model.PowerCount++;
            }
        }
    }
    Model.bHasBorrowedPower = Tokens.Length > 15 && Tokens[15] != "" && Class'SFSPowerModel'.static.FromToken(Tokens[15], Model.BorrowedPower);
    if (Tokens.Length > 19)
    {
        Class'SFSInventoryModel'.static.FromTokens(Tokens[16], Tokens[17], Tokens[18], Tokens[19], Model.Inventory);
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}