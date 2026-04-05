Class SFXCharacterClass extends SFXCharacterClass_NativeBase
    editinlinenew
    config(Game);

var ScaledFloat WeaponEncumbranceModifiers[6];
var(SFXCharacterClass) string className;
var(SFXCharacterClass) config array<Name> MappedPowers;
var array<PowerUnlockRequirement> PowerUnlockRequirements;
var array<Class<SFXPowerCustomActionBase>> SquadScreenPowerOrder;
var array<PowerStartingRank> StartingPowerRanks;
var array<PowerAutoLevelUp> AutoLevelUpInfo;
var(SFXCharacterClass) SFXLoadoutData Loadout;
var(SFXCharacterClass) float BioticStrength;
var(SFXCharacterClass) float TechStrength;
var(SFXCharacterClass) float CombatStrength;
var(SFXCharacterClass) int srClassName;
var(SFXCharacterClass) int srClassDesc;
var(SFXCharacterClass) int srClassPrimaryDesc;
var(SFXCharacterClass) int srClassSecondaryDesc;
var(SFXCharacterClass) Color BloodColor;
var const int RichPresenceContextStringIndex;
var config float StartingEncumbranceCapacity;
var config float EncumbranceMinCooldown;
var config float EncumbranceMaxCooldown;
var int MaxWeapons;
var(SFXCharacterClass) ECharacterClass ClassType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponEncumbranceModifiers[0] = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[1] = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[2] = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[3] = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[4] = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponEncumbranceModifiers[5] = {
                                     Bonuses = (), 
                                     X = 0.0, 
                                     Y = 0.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    StartingEncumbranceCapacity = 0.75
    EncumbranceMinCooldown = -2.0
    EncumbranceMaxCooldown = 2.0
    MaxWeapons = 2
}