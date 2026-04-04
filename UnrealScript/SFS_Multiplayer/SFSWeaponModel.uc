Class SFSWeaponModel;

struct SFSWeaponModelStruct 
{
    var string WeaponID;
    var string Mod1ID;
    var string Mod2ID;
};

static function bool FromTokens(string InWeaponID, string InMod1ID, string InMod2ID, out SFSWeaponModelStruct Weapon)
{
    if (InWeaponID == "")
    {
        return FALSE;
    }
    Weapon.WeaponID = InWeaponID;
    Weapon.Mod1ID = InMod1ID;
    Weapon.Mod2ID = InMod2ID;
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}