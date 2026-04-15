Class SFSWeaponModel;

struct SFSWeaponModelStruct 
{
    var string WeaponID;
    var string Mod1ID;
    var string Mod2ID;
    var string FireMode;
    var bool bRemoveScope;
};

static function bool FromTokens(string InWeaponID, string InMod1ID, string InMod2ID, string FireMode, bool bInRemoveScope, out SFSWeaponModelStruct Weapon)
{
    if (InWeaponID == "")
    {
        return FALSE;
    }
    Weapon.WeaponID = InWeaponID;
    Weapon.Mod1ID = InMod1ID;
    Weapon.Mod2ID = InMod2ID;
    Weapon.FireMode = FireMode;
    Weapon.bRemoveScope = bInRemoveScope;
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}