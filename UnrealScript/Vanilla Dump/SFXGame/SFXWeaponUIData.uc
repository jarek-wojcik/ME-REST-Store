Class SFXWeaponUIData
    native;

struct native SFXWeaponModData 
{
    var string ClassPath;
    var array<SFXWeaponModUIStat> Stats;
    var array<stringref> ModLevelTokens;
    var string CookedPackage;
    var array<string> Meshes;
    var Name className;
    var Name SocketName;
    var stringref Name;
    var stringref ShortName;
    var stringref Description;
    var Texture2D Image;
    var Texture2D LargeImage;
    var transient int Level;
    var bool MaterialEmissiveChange;
    var bool MaterialGripColorChange;
    var bool MaterialBodyColorChange;
    var transient bool Unlocked;
    var EWeaponModCategory ModCategory;
};
struct native SFXWeaponModUIStat 
{
    var int Level;
    var float Value;
    var EWeaponStatBars Type;
};
struct native SFXWeaponSelectWeaponData 
{
    var SFXWeaponUICookData CookData;
    var string ClassPath;
    var array<LinearColor> WeaponModGripColors;
    var array<LinearColor> WeaponModBodyColors;
    var array<LinearColor> WeaponModEmissiveValues;
    var LoadoutWeaponInfo LoadoutInfo;
    var SFXWeaponUIStats Stats;
    var Name className;
    var stringref Name;
    var stringref Description;
    var stringref ShortDescription;
    var Texture2D Image;
    var GFxMovieInfo IconResource;
    var int IconIndex;
    var float EncumbranceWeight;
    var transient int Level;
    var transient bool Unlocked;
    var ELoadoutWeapons Type;
};
struct native SFXWeaponUICookData 
{
    var string CookedPackage;
    var string Mesh;
    var string AnimTree;
    var array<string> AnimSets;
};
struct native SFXWeaponUIStats 
{
    var float Accuracy;
    var float Damage;
    var float FireRate;
    var float Magazine;
    var float Weight;
};

var array<SFXWeaponSelectWeaponData> m_aWeapons;
var array<SFXWeaponModData> m_aMods;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}