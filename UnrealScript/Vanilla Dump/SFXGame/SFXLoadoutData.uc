Class SFXLoadoutData
    native;

struct native PowerLevelUp 
{
    var(PowerLevelUp) Class<SFXPower> PowerClass;
    var(PowerLevelUp) Class<SFXPower> EvolvedPowerClass;
    var(PowerLevelUp) float Rank;
};
struct native ShieldLoadout 
{
    var(ShieldLoadout) Class<SFXShield_Base> Shields;
    var(ShieldLoadout) Vector2D ShieldLevelRange;
    var(ShieldLoadout) Vector2D MaxShields;
};

var(Weapons) array<Class<SFXWeapon>> Weapons;
var(Shields) array<ShieldLoadout> ShieldLoadouts;
var(Powers) array<Class<SFXPower>> Powers;
var(Powers) array<PowerLevelUp> PowerLevelUpInfo;
var(Shields) Vector ShieldOffset;
var(Weapons) Vector2D WeaponLevelRange;
var(Shields) float ShieldScale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponLevelRange = {X = 0.0, Y = 9.0}
    ShieldScale = 1.0
}