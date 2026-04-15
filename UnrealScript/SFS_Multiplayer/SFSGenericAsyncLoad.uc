Class SFSGenericAsyncLoad within SFSPortalAsyncLoader;

enum EAsyncLoadType
{
    ALT_PlayerMP,
    ALT_Pawn,
    ALT_Henchman,
    ALT_Weapon,
    ALT_WeaponMod,
    ALT_Consumable,
    ALT_PowerClass,
};

var delegate<OnAssetLoaded> onAssetLoadedCallback;
var string AssetToLoad;
var EAsyncLoadType LoadType;
var EAsyncLoadStatus LoadStatus;
var int retries;
var bool isLoaded;
var SFXPawn_PlayerMP LoadedPlayerMP;
var SFXPawn LoadedPawn;
var SFXPawn_Henchman LoadedHenchman;
var Class<SFXWeapon> LoadedWeapon;
var Class<SFXPowerCustomActionBase> LoadedPowerClass;
var Class<SFXWeaponMod> LoadedWeaponMod;
var Class<SFXGameEffect_MatchConsumableBase> LoadedConsumable;
var string WeaponFireMode;
var string Mod1ID;
var string Mod2ID;
var SFXWeapon targetWeapon;
var SFSPowerModelStruct PowerModel;
var int SlotIndex;
var bool bIsBorrowedPower;
var bool bUsesHelmet;
var bool bUsesHeadgear;
var bool bRemoveScope;

function OnAssetLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    retries = 0
    isLoaded = FALSE
}