Class SFSGenericAsyncLoad within SFSPortalAsyncLoader;

enum EAsyncLoadType
{
    ALT_PlayerMP,
    ALT_Pawn,
    ALT_Henchman,
    ALT_Weapon,
    ALT_Power,
    ALT_WeaponMod,
    ALT_Consumable,
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
var SFXPowerCustomAction LoadedPower;
var Class<SFXWeaponMod> LoadedWeaponMod;
var SFXGameEffect_MatchConsumableBase LoadedConsumable;
var string Mod1ID;
var string Mod2ID;
var SFXWeapon TargetWeapon;

function OnAssetLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    retries = 0
    isLoaded = FALSE
}