Class SFSCharacterModel;

struct SFSCharacterModelStruct 
{
    var string Id;
    var string Name;
    var string CharacterID;
    var string AppearanceCharID;
    var string AppearancePawnType;
    var bool bUseHelmet;
    var bool bUseHeadgear;
    var SFSWeaponModelStruct Weapons[5];
    var int WeaponCount;
    var SFSPowerModelStruct Powers[5];
    var int PowerCount;
    var bool bHasBorrowedPower;
    var SFSPowerModelStruct BorrowedPower;
    var SFSInventoryModelStruct Inventory;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}