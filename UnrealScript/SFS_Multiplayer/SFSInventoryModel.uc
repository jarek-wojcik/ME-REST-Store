Class SFSInventoryModel;

struct SFSInventoryModelStruct 
{
    var string ArmorConsumableID;
    var string WeaponConsumableID;
    var string AmmoConsumableID;
    var string GearConsumableID;
};

static function bool FromTokens(string InArmor, string InWeapon, string InAmmo, string InGear, out SFSInventoryModelStruct Inventory)
{
    Inventory.ArmorConsumableID = InArmor;
    Inventory.WeaponConsumableID = InWeapon;
    Inventory.AmmoConsumableID = InAmmo;
    Inventory.GearConsumableID = InGear;
    return InArmor != "" || InWeapon != "" || InAmmo != "" || InGear != "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}