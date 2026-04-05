Class SFXDefine;

enum EBioAutoSet
{
    Unset,
};
enum EBioPlotAutoSet
{
    Plot_Unset,
};
enum EBioRegionAutoSet
{
    Region_Unset,
};
struct PowerUnlockRequirement 
{
    var Class<Object> RequiredPowerClass;
    var Class<Object> PowerClass;
    var float Rank;
    var int RequiredLevel;
    var stringref CustomUnlockText;
};
enum WeaponAnimType
{
    WeaponAnimType_Pistol,
    WeaponAnimType_Shotgun,
    WeaponAnimType_Rifle,
    WeaponAnimType_Sniper,
    WeaponAnimType_GrenadeLauncher,
    WeaponAnimType_MissileLauncher,
    WeaponAnimType_NukeLauncher,
    WeaponAnimType_ParticleBeam,
    WeaponAnimType_RepulsorBeam,
    WeaponAnimType_AutoShotgun,
    WeaponAnimType_AutoSniper,
    WeaponAnimType_AutoPistol,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}