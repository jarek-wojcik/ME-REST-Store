Class SFXTreasureData
    config(Game);

struct ArmorTreasureData 
{
    var string ArmorString;
    var stringref srDisplayName;
    var int ArmorPlotState;
    var int Conditional;
    var EArmorTreasurePiece ArmorPiece;
};
enum EArmorTreasurePiece
{
    ArmorTreasure_None,
    ArmorTreasure_Helmet_Health,
    ArmorTreasure_Helmet_Shield,
    ArmorTreasure_Helmet_ShieldRegen,
    ArmorTreasure_Helmet_PowerDamage,
    ArmorTreasure_Helmet_PowerRecharge,
    ArmorTreasure_Helmet_Movement,
    ArmorTreasure_Helmet_WeaponDamage,
    ArmorTreasure_Helmet_ConstraintDamage,
    ArmorTreasure_Helmet_AmmoCapacity,
    ArmorTreasure_Helmet_MeleeDamage,
    ArmorTreasure_Torso_Health,
    ArmorTreasure_Torso_Shield,
    ArmorTreasure_Torso_ShieldRegen,
    ArmorTreasure_Torso_PowerDamage,
    ArmorTreasure_Torso_PowerRecharge,
    ArmorTreasure_Torso_Movement,
    ArmorTreasure_Torso_WeaponDamage,
    ArmorTreasure_Torso_ConstraintDamage,
    ArmorTreasure_Torso_AmmoCapacity,
    ArmorTreasure_Torso_MeleeDamage,
    ArmorTreasure_Shoulders_Health,
    ArmorTreasure_Shoulders_Shield,
    ArmorTreasure_Shoulders_ShieldRegen,
    ArmorTreasure_Shoulders_PowerDamage,
    ArmorTreasure_Shoulders_PowerRecharge,
    ArmorTreasure_Shoulders_Movement,
    ArmorTreasure_Shoulders_WeaponDamage,
    ArmorTreasure_Shoulders_ConstraintDamage,
    ArmorTreasure_Shoulders_AmmoCapacity,
    ArmorTreasure_Shoulders_MeleeDamage,
    ArmorTreasure_Legs_Health,
    ArmorTreasure_Legs_Shield,
    ArmorTreasure_Legs_ShieldRegen,
    ArmorTreasure_Legs_PowerDamage,
    ArmorTreasure_Legs_PowerRecharge,
    ArmorTreasure_Legs_Movement,
    ArmorTreasure_Legs_WeaponDamage,
    ArmorTreasure_Legs_ConstraintDamage,
    ArmorTreasure_Legs_AmmoCapacity,
    ArmorTreasure_Legs_MeleeDamage,
    ArmorTreasure_Arms_Health,
    ArmorTreasure_Arms_Shield,
    ArmorTreasure_Arms_ShieldRegen,
    ArmorTreasure_Arms_PowerDamage,
    ArmorTreasure_Arms_PowerRecharge,
    ArmorTreasure_Arms_Movement,
    ArmorTreasure_Arms_WeaponDamage,
    ArmorTreasure_Arms_ConstraintDamage,
    ArmorTreasure_Arms_AmmoCapacity,
    ArmorTreasure_Arms_MeleeDamage,
    ArmorTreasure_DLC_01,
    ArmorTreasure_DLC_02,
    ArmorTreasure_DLC_03,
    ArmorTreasure_DLC_04,
    ArmorTreasure_DLC_05,
    ArmorTreasure_DLC_06,
    ArmorTreasure_DLC_07,
    ArmorTreasure_DLC_08,
    ArmorTreasure_DLC_09,
    ArmorTreasure_DLC_10,
    ArmorTreasure_DLC_11,
    ArmorTreasure_DLC_12,
    ArmorTreasure_DLC_13,
    ArmorTreasure_DLC_14,
    ArmorTreasure_DLC_15,
    ArmorTreasure_DLC_16,
    ArmorTreasure_DLC_17,
    ArmorTreasure_DLC_18,
    ArmorTreasure_DLC_19,
    ArmorTreasure_DLC_20,
    ArmorTreasure_DLC_21,
    ArmorTreasure_DLC_22,
    ArmorTreasure_DLC_23,
    ArmorTreasure_DLC_24,
    ArmorTreasure_DLC_25,
    ArmorTreasure_DLC_26,
    ArmorTreasure_DLC_27,
    ArmorTreasure_DLC_28,
    ArmorTreasure_DLC_29,
    ArmorTreasure_DLC_30,
    ArmorTreasure_CollectorsEdition_1,
    ArmorTreasure_CollectorsEdition_2,
    ArmorTreasure_CollectorsEdition_3,
    ArmorTreasure_Helmet_Mnemonic,
    ArmorTreasure_Helmet_Delumcore,
    ArmorTreasure_Helmet_Securitel,
};
struct TD 
{
    var string Level;
    var array<string> TREASURE;
    var array<string> ConditionalGAWAssets;
    var array<string> UndetectableGAWAssets;
    var int PlotId;
    var int Credits;
    var int AllianceCredits;
    var int XP;
    var EME3Level LevelEnum;
};
enum EME3Level
{
    ME3Level_None,
    ME3Level_ProEar,
    ME3Level_ProMar,
    ME3Level_SPRctr,
    ME3Level_CitHub,
    ME3Level_Nor,
    ME3Level_KroGar,
    ME3Level_OmgJck,
    ME3Level_SPCer,
    ME3Level_Kro001,
    ME3Level_KroN7a,
    ME3Level_KroGru,
    ME3Level_KroN7b,
    ME3Level_SPNov,
    ME3Level_Kro002,
    ME3Level_Cat003,
    ME3Level_CitSam,
    ME3Level_CerJcb,
    ME3Level_SPDish,
    ME3Level_SPTowr,
    ME3Level_SPSlum,
    ME3Level_Gth001,
    ME3Level_GthLeg,
    ME3Level_GthN7a,
    ME3Level_Gth002,
    ME3Level_Cat002,
    ME3Level_CerMir,
    ME3Level_Cat004,
    ME3Level_End001,
    ME3Level_End002,
    ME3Level_End003,
    ME3Level_EricCombat,
    ME3Level_Cat001,
    ME3Level_DLC1,
    ME3Level_DLC2,
    ME3Level_DLC3,
    ME3Level_DLC4,
    ME3Level_DLC5,
    ME3Level_DLC6,
    ME3Level_DLC7,
    ME3Level_DLC8,
    ME3Level_DLC9,
    ME3Level_DLC10,
    ME3Level_DLC11,
    ME3Level_DLC12,
    ME3Level_DLC13,
    ME3Level_DLC14,
    ME3Level_DLC15,
    ME3Level_DLC16,
    ME3Level_DLC17,
    ME3Level_DLC18,
    ME3Level_DLC19,
    ME3Level_DLC20,
};

var config array<TD> LevelTreasure;
var config array<ArmorTreasureData> ArmorTreasure;

public function Name CurrentLevel()
{
    return Name(Class'Engine'.static.GetCurrentWorldInfo().GetMapName());
}
public function GetArmorTreasure(out array<ArmorTreasureData> OutArmorTreasure)
{
    local int idx;
    
    for (idx = 0; idx < ArmorTreasure.Length; idx++)
    {
        OutArmorTreasure.AddItem(ArmorTreasure[idx]);
    }
}
public function bool GetLevelData(out TD tData, optional string Level = "")
{
    local TD T;
    
    Level = Level == "" ? Class'Engine'.static.GetCurrentWorldInfo().GetMapName() : Level;
    foreach default.LevelTreasure(T, )
    {
        if (Locs(T.Level) == Locs(Level))
        {
            tData = T;
            return TRUE;
        }
    }
    return FALSE;
}
public function bool HasConditionalGAWAsset(string TREASURE, optional string Level)
{
    local TD tData;
    local bool bFoundLevel;
    local string S;
    
    Level = Level == "" ? Class'Engine'.static.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundLevel = GetLevelData(tData, Level);
    Level = bFoundLevel ? Level : "BioP_" $ Level;
    bFoundLevel = bFoundLevel || GetLevelData(tData, Level);
    if (!bFoundLevel)
    {
        return FALSE;
    }
    foreach tData.ConditionalGAWAssets(S, )
    {
        if (Locs(S) == Locs(TREASURE))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool HasTreasure(string TREASURE, optional string Level)
{
    local TD tData;
    local bool bFoundLevel;
    local string S;
    
    Level = Level == "" ? Class'Engine'.static.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundLevel = GetLevelData(tData, Level);
    Level = bFoundLevel ? Level : "BioP_" $ Level;
    bFoundLevel = bFoundLevel || GetLevelData(tData, Level);
    if (!bFoundLevel)
    {
        return FALSE;
    }
    foreach tData.TREASURE(S, )
    {
        if (Locs(S) == Locs(TREASURE))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool IsArmorUnlocked(EArmorTreasurePiece Armor)
{
    local int idx;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    
    idx = ArmorTreasure.Find('ArmorPiece', Armor);
    if (idx == -1)
    {
        return FALSE;
    }
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return FALSE;
    }
    VarTable = WI.GetGlobalVariables();
    if (VarTable == None)
    {
        return FALSE;
    }
    if (ArmorTreasure[idx].ArmorPlotState != 0 && VarTable.GetBool(ArmorTreasure[idx].ArmorPlotState) == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool IsTreasureUnlocked(string TREASURE, optional string Level)
{
    local TD tData;
    local bool bFoundLevel;
    local string S;
    
    Level = Level == "" ? Class'Engine'.static.GetCurrentWorldInfo().GetMapName() : Level;
    bFoundLevel = GetLevelData(tData, Level);
    Level = bFoundLevel ? Level : "BioP_" $ Level;
    bFoundLevel = bFoundLevel || GetLevelData(tData, Level);
    if (!bFoundLevel)
    {
        return FALSE;
    }
    foreach LevelTreasure(tData, )
    {
        foreach tData.TREASURE(S, )
        {
            if (Locs(S) == Locs(TREASURE))
            {
                return TRUE;
            }
        }
        if (Locs(tData.Level) == Locs(Level) || Locs(tData.Level) == Locs("biop_" $ Level))
        {
            return FALSE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LevelTreasure = ({
                      Level = "BioP_ProEar", 
                      TREASURE = ("SFXGameContent.SFXWeapon_AssaultRifle_Avenger", "SFXGameContent.SFXWeapon_Pistol_Predator"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10166, 
                      Credits = 0, 
                      AllianceCredits = 10000, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_ProEar
                     }, 
                     {
                      Level = "BioP_ProMar", 
                      TREASURE = ("ArmorTreasure_Arms_MeleeDamage", 
                                  "ArmorTreasure_Torso_ShieldRegen", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_SMGAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SMGStability", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Vindicator", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Mantis", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Katana", 
                                  "SFXGameContent.SFXWeapon_SMG_Shuriken"
                                 ), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10167, 
                      Credits = 0, 
                      AllianceCredits = 25000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_ProMar
                     }, 
                     {
                      Level = "BioP_SPRctr", 
                      TREASURE = ("ArmorTreasure_Torso_PowerRecharge", "GAWAsset_AdvancedStarshipFuel"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10305, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPRctr
                     }, 
                     {
                      Level = "BioP_CitHub", 
                      TREASURE = (), 
                      ConditionalGAWAssets = ("GAWAsset_KillXen", 
                                              "GAWAsset_KeepXenAlive", 
                                              "GAWAsset_SpectreTeam", 
                                              "GAWAsset_Kasumi", 
                                              "GAWAsset_Zaeed", 
                                              "GAWAsset_VolusBombingFleet", 
                                              "GAWAsset_DarkEnergyDissertation", 
                                              "GAWAsset_DarkEnergyDissertationUpgrade", 
                                              "GAWAsset_HanarAndDrellForces", 
                                              "GAWAsset_DianaAllers", 
                                              "GAWAsset_CerberusAttack", 
                                              "GAWAsset_TurianMedigel", 
                                              "GAWAsset_AsariCommandos", 
                                              "GAWAsset_BatarianFleet", 
                                              "GAWAsset_SabotagedAllianceShips", 
                                              "GAWAsset_CommanderKahairalBalak", 
                                              "GAWAsset_SupportedCitadelRefugees", 
                                              "GAWAsset_CivilianMedicalVolunteers", 
                                              "GAWAsset_ReassuredArguingCouple", 
                                              "GAWAsset_AsariPatientSuicide", 
                                              "GAWAsset_ImproveCivilianMorale", 
                                              "GAWAsset_LoweredCrime", 
                                              "GAWAsset_FewerRefugees", 
                                              "GAWAsset_SmugglerContacts", 
                                              "GAWAsset_MedicalSuppliesReleased", 
                                              "GAWAsset_IncreasedSurveillance", 
                                              "GAWAsset_CivilianMilitia", 
                                              "GAWAsset_IncreasedCrimeRate", 
                                              "GAWAsset_GrissomStudentHousing", 
                                              "GAWAsset_ImprovedTargetingVIs", 
                                              "GAWAsset_EnforceEveryLaw", 
                                              "GAWAsset_CrackDownOnTerror", 
                                              "GAWAsset_CivilianDonations", 
                                              "GAWAsset_UpgradedThanix", 
                                              "GAWAsset_AllianceEngineeringCorp", 
                                              "GAWAsset_103rdMarineDivision", 
                                              "GAWAsset_AdmiralMikhailovich", 
                                              "GAWAsset_Alliance1stFleet", 
                                              "GAWAsset_Alliance3rdFleet", 
                                              "GAWAsset_TerminusFleet", 
                                              "GAWAsset_DrChakwas", 
                                              "GAWAsset_Alliance5thFleet", 
                                              "GAWAsset_UpgradedHeavyShipArmor", 
                                              "GAWAsset_UpgradedShield", 
                                              "GAWAsset_MineralResources", 
                                              "GAWAsset_PrejekPaddlefish", 
                                              "GAWAsset_KhalisahBintSinanAlJilani", 
                                              "GAWAsset_NeverPunchedReporter", 
                                              "GAWAsset_Normandy", 
                                              "GAWAsset_MineralResources2", 
                                              "GAWAsset_MineralResources3", 
                                              "GAWAsset_AllianceEngineeringCorp", 
                                              "GAWAsset_AdmiralMikhailovich", 
                                              "GAWAsset_Alliance1stFleet", 
                                              "GAWAsset_Alliance3rdFleet", 
                                              "GAWAsset_BloodPackFlotilla", 
                                              "GAWAsset_BlueSunsFlotilla", 
                                              "GAWAsset_EclipseFlotilla", 
                                              "GAWAsset_SavedTheCouncilInME1", 
                                              "GAWAsset_ArrivalNotCompleted", 
                                              "GAWAsset_UrdnotBetrayal", 
                                              "GAWAsset_AllianceFleetLosses", 
                                              "GAWAsset_Ashley", 
                                              "GAWAsset_Kaiden"
                                             ), 
                      UndetectableGAWAssets = ("GAWAsset_CuredTurianGeneral", 
                                               "GAWAsset_ReaperCodeFragment", 
                                               "GAWAsset_GethJammingFrequencies", 
                                               "GAWAsset_CerberusTurretSchematics", 
                                               "GAWAsset_ImprovedAsariAmps", 
                                               "GAWAsset_ImprovedHanarMedicalTech", 
                                               "GAWAsset_CerberusCiphers", 
                                               "GAWAsset_SalarianColonySupport", 
                                               "GAWAsset_ChemicalBurnTreatments", 
                                               "GAWAsset_KroganPowerGrids", 
                                               "GAWAsset_Bannerofthe1stRegimentBonus", 
                                               "GAWAsset_PillarsOfStrengthBonus", 
                                               "GAWAsset_BookOfPlenixBonus", 
                                               "GAWAsset_ImprovedHuntressTraining", 
                                               "GAWAsset_ProtheanDataDrivesBonus", 
                                               "GAWAsset_KaklisaurSkull", 
                                               "GAWAsset_ObeliskOfKarzaBonus", 
                                               "GAWAsset_ProtheanSphereBonus", 
                                               "GAWAsset_CodeOfTheAncientsBonus", 
                                               "GAWAsset_RingsOfAluneBonus", 
                                               "GAWAsset_HesperiaPeriodStatueBonus"
                                              ), 
                      PlotId = 10170, 
                      Credits = 50000, 
                      AllianceCredits = 0, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_CitHub
                     }, 
                     {
                      Level = "BioP_Nor", 
                      TREASURE = (), 
                      ConditionalGAWAssets = ("GAWAsset_CerberusExPatriots", 
                                              "GAWAsset_OptimizedEezoCapacitors", 
                                              "GAWAsset_RogueFighterSquadron", 
                                              "GAWAsset_ProKroganInterview", 
                                              "GAWAsset_ProKroganInterviewNeedTurians", 
                                              "GAWAsset_ProSecurityInterview", 
                                              "GAWAsset_AntiCerberusInterview", 
                                              "GAWAsset_GethInterviewCooperation", 
                                              "GAWAsset_GethInterviewGethKickAss", 
                                              "GAWAsset_QuarianInterviewReadiness", 
                                              "GAWAsset_QuarianInterviewMilitary", 
                                              "GAWAsset_MassiveExplosion", 
                                              "GAWAsset_SupportRaanAgainstHanJorel", 
                                              "GAWAsset_SupportHanJorelAgainstRaan", 
                                              "GAWAsset_MassiveExplosionA", 
                                              "GAWAsset_FeronIntel", 
                                              "GAWAsset_BreederQueenBetrayal", 
                                              "GAWAsset_ShialaAndZhusHopeColonists"
                                             ), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10169, 
                      Credits = 0, 
                      AllianceCredits = 0, 
                      XP = 1500, 
                      LevelEnum = EME3Level.ME3Level_Nor
                     }, 
                     {
                      Level = "BioP_KroGar", 
                      TREASURE = ("ArmorTreasure_Legs_WeaponDamage", 
                                  "ArmorTreasure_Shoulders_ConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleForce", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_PistolMagSize", 
                                  "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Scimitar", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Viper"
                                 ), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10213, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_KroGar
                     }, 
                     {
                      Level = "BioP_OmgJck", 
                      TREASURE = ("ArmorTreasure_Helmet_Mnemonic", 
                                  "ArmorTreasure_Torso_PowerDamage", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleStability", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_SMGMagSize", 
                                  "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Mattock", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Eviscerator", 
                                  "GAWAsset_KhaleeSanders"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_BioticSupport", "GAWAsset_BioticCompany", "GAWAsset_Jack", "GAWAsset_TechStudentsRescued", "GAWAsset_SandersArcherUpgrade"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10200, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_OmgJck
                     }, 
                     {
                      Level = "BioP_SPCer", 
                      TREASURE = ("SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", "GAWAsset_CerberusResearch"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10302, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPCer
                     }, 
                     {
                      Level = "BioP_Kro001", 
                      TREASURE = ("ArmorTreasure_Helmet_Shield", 
                                  "ArmorTreasure_Legs_AmmoCapacity", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                                  "SFXGameContent.SFXWeaponMod_PistolDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolAccuracy", 
                                  "SFXGameContent.SFXWeapon_Pistol_Scorpion", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Raptor"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_MajorKirrahe", "GAWAsset_SalarianSTG1"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10178, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Kro001
                     }, 
                     {
                      Level = "BioP_KroN7a", 
                      TREASURE = ("ArmorTreasure_Torso_WeaponDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SMGStability", 
                                  "SFXGameContent.SFXWeaponMod_SMGMagSize", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Cobra", 
                                  "SFXGameContent.SFXWeapon_SMG_Tempest"
                                 ), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10180, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 1500, 
                      LevelEnum = EME3Level.ME3Level_KroN7a
                     }, 
                     {
                      Level = "BioP_KroGru", 
                      TREASURE = ("ArmorTreasure_Shoulders_MeleeDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_SMGDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Claymore", 
                                  "GAWAsset_AralahkCompany"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_Grunt", "GAWAsset_RachniiWorkers", "GAWAsset_GruntAlive", "GAWAsset_GruntLoyal", "GAWAsset_SaveQueen"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10182, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_KroGru
                     }, 
                     {
                      Level = "BioP_KroN7b", 
                      TREASURE = ("ArmorTreasure_Arms_PowerRecharge", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", 
                                  "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_PistolStability", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Incisor", 
                                  "GAWAsset_TurianBlackwatch1"
                                 ), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10181, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 1500, 
                      LevelEnum = EME3Level.ME3Level_KroN7b
                     }, 
                     {
                      Level = "BioP_SPNov", 
                      TREASURE = ("SFXGameContent.SFXWeaponMod_PistolMagSize", "GAWAsset_AdvancedFighterSquadron"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10304, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPNov
                     }, 
                     {
                      Level = "BioP_Kro002", 
                      TREASURE = ("ArmorTreasure_Helmet_MeleeDamage", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SMGAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_PistolStability", 
                                  "SFXGameContent.SFXWeaponMod_PistolMagSize", 
                                  "SFXGameContent.SFXWeapon_Pistol_Phalanx", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Graal", 
                                  "GAWAsset_KroganClans", 
                                  "GAWAsset_ClanUrdnot", 
                                  "GAWAsset_Turian7thFleet", 
                                  "GAWAsset_TurianEngineeringCorp", 
                                  "GAWAsset_Turian43rdMarineDivision"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_ClanTurmoil", "GAWAsset_KroganMercenaries", "GAWAsset_Salarian1stFleet", "GAWAsset_Wreav", "GAWAsset_Wrex", "GAWAsset_MordinSolus"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10179, 
                      Credits = 25000, 
                      AllianceCredits = 25000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Kro002
                     }, 
                     {
                      Level = "BioP_Cat003", 
                      TREASURE = ("ArmorTreasure_Helmet_Securitel", 
                                  "ArmorTreasure_Helmet_WeaponDamage", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleForce", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Revenant", 
                                  "SFXGameContent.SFXWeapon_SMG_Hornet", 
                                  "SFXGameContent.SFXWeapon_Pistol_Talon", 
                                  "GAWAsset_AsariScienceTeam", 
                                  "GAWAsset_Asari2ndFleet", 
                                  "GAWAsset_Asari6thFleet", 
                                  "GAWAsset_Turian6thFleet", 
                                  "GAWAsset_CitadelDefenseForce"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_DestinyAscension", "GAWAsset_Salarian3rdFleet", "GAWAsset_STGTaskForce", "GAWAsset_KirraheSavesSalarianCaptain"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10184, 
                      Credits = 25000, 
                      AllianceCredits = 25000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Cat003
                     }, 
                     {
                      Level = "BioP_CitSam", 
                      TREASURE = ("ArmorTreasure_Shoulders_PowerDamage", "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", "SFXGameContent.SFXWeaponMod_AssaultRifleStability", "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", "SFXGameContent.SFXWeaponMod_PistolStability", "SFXGameContent.SFXWeapon_Shotgun_Disciple", "GAWAsset_AsariCommandoTeam4"), 
                      ConditionalGAWAssets = ("GAWAsset_Samara", "GAWAsset_MatriarchGallaesElectronicSignature"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10195, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_CitSam
                     }, 
                     {
                      Level = "BioP_CerJcb", 
                      TREASURE = ("ArmorTreasure_Legs_Shield", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunDamage", 
                                  "SFXGameContent.SFXWeaponMod_SMGDamage", 
                                  "SFXGameContent.SFXWeapon_Pistol_Carnifex", 
                                  "GAWAsset_CerberusScienceTeam", 
                                  "GAWAsset_DrBrynnCole"
                                 ), 
                      ConditionalGAWAssets = ("GAWAsset_DrGavinArcher", "GAWAsset_Jacob"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10189, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_CerJcb
                     }, 
                     {
                      Level = "BioP_SPDish", 
                      TREASURE = ("ArmorTreasure_Legs_MeleeDamage", "GAWAsset_CommnicationsArray"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10303, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPDish
                     }, 
                     {
                      Level = "BioP_SPTowr", 
                      TREASURE = ("ArmorTreasure_Arms_ConstraintDamage", "GAWAsset_Krogan1stDivision"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10307, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPTowr
                     }, 
                     {
                      Level = "BioP_SPSlum", 
                      TREASURE = ("ArmorTreasure_Helmet_ShieldRegen", "GAWAsset_Arcturus1stDivision"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10306, 
                      Credits = 10000, 
                      AllianceCredits = 10000, 
                      XP = 750, 
                      LevelEnum = EME3Level.ME3Level_SPSlum
                     }, 
                     {
                      Level = "BioP_Gth001", 
                      TREASURE = ("ArmorTreasure_Helmet_PowerRecharge", "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", "SFXGameContent.SFXWeaponMod_SMGAccuracy", "SFXGameContent.SFXWeapon_Pistol_Thor", "SFXGameContent.SFXWeapon_AssaultRifle_Geth"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10172, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Gth001
                     }, 
                     {
                      Level = "BioP_GthLeg", 
                      TREASURE = (), 
                      ConditionalGAWAssets = ("GAWAsset_GethPrimeC13Unit", "GAWAsset_LegionIntel2", "GAWAsset_LegionIntel1"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10176, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_GthLeg
                     }, 
                     {
                      Level = "BioP_GthN7a", 
                      TREASURE = ("ArmorTreasure_Torso_AmmoCapacity", "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", "SFXGameContent.SFXWeaponMod_SMGMagSize", "SFXGameContent.SFXWeapon_SniperRifle_Javelin"), 
                      ConditionalGAWAssets = ("GAWAsset_AdmiralZaelKoris"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10174, 
                      Credits = 12500, 
                      AllianceCredits = 12500, 
                      XP = 1500, 
                      LevelEnum = EME3Level.ME3Level_GthN7a
                     }, 
                     {
                      Level = "BioP_Gth002", 
                      TREASURE = ("ArmorTreasure_Arms_Shield", "SFXGameContent.SFXWeaponMod_AssaultRifleStability", "SFXGameContent.SFXWeaponMod_AssaultRifleForce", "SFXGameContent.SFXWeaponMod_SMGDamage", "SFXGameContent.SFXWeaponMod_SMGStability", "SFXGameContent.SFXWeapon_Shotgun_Geth"), 
                      ConditionalGAWAssets = ("GAWAsset_DestroyTheGeth", 
                                              "GAWAsset_GethArmyCorp", 
                                              "GAWAsset_GethFleet", 
                                              "GAWAsset_QuarianCivilianFleet", 
                                              "GAWAsset_AdmiralDies", 
                                              "GAWAsset_GethFighters", 
                                              "GAWAsset_QuarianHeavyFleet", 
                                              "GAWAsset_QuarianPatrolFleet", 
                                              "GAWAsset_AdmiralDaroXen", 
                                              "GAWAsset_AdvancedAIRelays", 
                                              "GAWAsset_GethHereticsSaved", 
                                              "GAWAsset_GethHereticsDestroyed"
                                             ), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10173, 
                      Credits = 25000, 
                      AllianceCredits = 25000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Gth002
                     }, 
                     {
                      Level = "BioP_Cat002", 
                      TREASURE = ("ArmorTreasure_Helmet_PowerDamage", "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", "SFXGameContent.SFXWeaponMod_ShotgunDamage", "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", "SFXGameContent.SFXWeapon_SniperRifle_Widow"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10183, 
                      Credits = 15000, 
                      AllianceCredits = 15000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Cat002
                     }, 
                     {
                      Level = "BioP_CerMir", 
                      TREASURE = ("ArmorTreasure_Shoulders_PowerRecharge", "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", "SFXGameContent.SFXWeaponMod_PistolAccuracy", "SFXGameContent.SFXWeapon_SMG_Locust", "SFXGameContent.SFXWeapon_AssaultRifle_Saber", "GAWAsset_Alliance6thFleet"), 
                      ConditionalGAWAssets = ("GAWAsset_Miranda"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10188, 
                      Credits = 15000, 
                      AllianceCredits = 15000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_CerMir
                     }, 
                     {
                      Level = "BioP_Cat004", 
                      TREASURE = ("ArmorTreasure_Helmet_Delumcore", "ArmorTreasure_Legs_PowerDamage", "SFXGameContent.SFXWeapon_AssaultRifle_Falcon"), 
                      ConditionalGAWAssets = ("GAWAsset_ReaperBrain", "GAWAsset_ReaperHeart"), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10185, 
                      Credits = 25000, 
                      AllianceCredits = 55000, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_Cat004
                     }, 
                     {
                      Level = "BioP_End001", 
                      TREASURE = (), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10202, 
                      Credits = 0, 
                      AllianceCredits = 0, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_End001
                     }, 
                     {
                      Level = "BioP_End002", 
                      TREASURE = (), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10203, 
                      Credits = 0, 
                      AllianceCredits = 0, 
                      XP = 2000, 
                      LevelEnum = EME3Level.ME3Level_End002
                     }, 
                     {
                      Level = "BioP_End003", 
                      TREASURE = (), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 10204, 
                      Credits = 0, 
                      AllianceCredits = 0, 
                      XP = 3000, 
                      LevelEnum = EME3Level.ME3Level_End003
                     }, 
                     {
                      Level = "BioP_Bjorn_Store", 
                      TREASURE = ("ArmorTreasure_Helmet_PowerDamage", "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", "SFXGameContent.SFXWeapon_AssaultRifle_Revenant"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 0, 
                      Credits = 10000, 
                      AllianceCredits = 5000, 
                      XP = 10000, 
                      LevelEnum = EME3Level.ME3Level_None
                     }, 
                     {
                      Level = "BioP_Bjorn_GAW", 
                      TREASURE = ("GAWAsset_MassiveSpaceGun", "GAWAsset_Krogan1stDivision"), 
                      ConditionalGAWAssets = (), 
                      UndetectableGAWAssets = (), 
                      PlotId = 0, 
                      Credits = 10000, 
                      AllianceCredits = 5000, 
                      XP = 10000, 
                      LevelEnum = EME3Level.ME3Level_None
                     }
                    )
    ArmorTreasure = ({ArmorString = "ArmorTreasure_Helmet_Shield", srDisplayName = $349690, ArmorPlotState = 19007, Conditional = 1805, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_Shield}, 
                     {ArmorString = "ArmorTreasure_Helmet_ShieldRegen", srDisplayName = $362041, ArmorPlotState = 18999, Conditional = 1801, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_ShieldRegen}, 
                     {ArmorString = "ArmorTreasure_Helmet_PowerDamage", srDisplayName = $349694, ArmorPlotState = 19008, Conditional = 1806, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_PowerDamage}, 
                     {ArmorString = "ArmorTreasure_Helmet_PowerRecharge", srDisplayName = $362043, ArmorPlotState = 19000, Conditional = 1802, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_PowerRecharge}, 
                     {ArmorString = "ArmorTreasure_Helmet_WeaponDamage", srDisplayName = $349697, ArmorPlotState = 19006, Conditional = 1804, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_WeaponDamage}, 
                     {ArmorString = "ArmorTreasure_Helmet_ConstraintDamage", srDisplayName = $601645, ArmorPlotState = 18988, Conditional = 1799, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_ConstraintDamage}, 
                     {ArmorString = "ArmorTreasure_Helmet_AmmoCapacity", srDisplayName = $363545, ArmorPlotState = 19005, Conditional = 1803, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_AmmoCapacity}, 
                     {ArmorString = "ArmorTreasure_Helmet_MeleeDamage", srDisplayName = $335474, ArmorPlotState = 18995, Conditional = 1800, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_MeleeDamage}, 
                     {ArmorString = "ArmorTreasure_Helmet_Mnemonic", srDisplayName = $718141, ArmorPlotState = 22339, Conditional = 2343, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_Mnemonic}, 
                     {ArmorString = "ArmorTreasure_Helmet_Delumcore", srDisplayName = $718142, ArmorPlotState = 22340, Conditional = 2344, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_Delumcore}, 
                     {ArmorString = "ArmorTreasure_Helmet_Securitel", srDisplayName = $718143, ArmorPlotState = 22341, Conditional = 2345, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Helmet_Securitel}, 
                     {ArmorString = "ArmorTreasure_Torso_ShieldRegen", srDisplayName = $710916, ArmorPlotState = 19455, Conditional = 1774, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_ShieldRegen}, 
                     {ArmorString = "ArmorTreasure_Torso_PowerDamage", srDisplayName = $710917, ArmorPlotState = 19459, Conditional = 1779, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_PowerDamage}, 
                     {ArmorString = "ArmorTreasure_Torso_PowerRecharge", srDisplayName = $710918, ArmorPlotState = 19467, Conditional = 1783, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_PowerRecharge}, 
                     {ArmorString = "ArmorTreasure_Torso_WeaponDamage", srDisplayName = $710919, ArmorPlotState = 21399, Conditional = 1787, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_WeaponDamage}, 
                     {ArmorString = "ArmorTreasure_Torso_AmmoCapacity", srDisplayName = $710920, ArmorPlotState = 20914, Conditional = 1791, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_AmmoCapacity}, 
                     {ArmorString = "ArmorTreasure_Torso_MeleeDamage", srDisplayName = $710921, ArmorPlotState = 20918, Conditional = 1795, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Torso_MeleeDamage}, 
                     {ArmorString = "ArmorTreasure_Shoulders_Shield", srDisplayName = $710923, ArmorPlotState = 19456, Conditional = 1775, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_Shield}, 
                     {ArmorString = "ArmorTreasure_Shoulders_PowerDamage", srDisplayName = $710924, ArmorPlotState = 19460, Conditional = 1780, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_PowerDamage}, 
                     {ArmorString = "ArmorTreasure_Shoulders_PowerRecharge", srDisplayName = $710925, ArmorPlotState = 19468, Conditional = 1784, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_PowerRecharge}, 
                     {ArmorString = "ArmorTreasure_Shoulders_WeaponDamage", srDisplayName = $710926, ArmorPlotState = 21400, Conditional = 1788, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_WeaponDamage}, 
                     {ArmorString = "ArmorTreasure_Shoulders_ConstraintDamage", srDisplayName = $710927, ArmorPlotState = 20915, Conditional = 1792, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_ConstraintDamage}, 
                     {ArmorString = "ArmorTreasure_Shoulders_MeleeDamage", srDisplayName = $710928, ArmorPlotState = 20919, Conditional = 1796, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Shoulders_MeleeDamage}, 
                     {ArmorString = "ArmorTreasure_Arms_Shield", srDisplayName = $710930, ArmorPlotState = 19457, Conditional = 1776, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_Shield}, 
                     {ArmorString = "ArmorTreasure_Arms_PowerDamage", srDisplayName = $710931, ArmorPlotState = 19461, Conditional = 1781, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_PowerDamage}, 
                     {ArmorString = "ArmorTreasure_Arms_PowerRecharge", srDisplayName = $710932, ArmorPlotState = 19469, Conditional = 1785, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_PowerRecharge}, 
                     {ArmorString = "ArmorTreasure_Arms_WeaponDamage", srDisplayName = $710933, ArmorPlotState = 21401, Conditional = 1789, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_WeaponDamage}, 
                     {ArmorString = "ArmorTreasure_Arms_ConstraintDamage", srDisplayName = $710934, ArmorPlotState = 20916, Conditional = 1793, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_ConstraintDamage}, 
                     {ArmorString = "ArmorTreasure_Arms_MeleeDamage", srDisplayName = $710935, ArmorPlotState = 20920, Conditional = 1797, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Arms_MeleeDamage}, 
                     {ArmorString = "ArmorTreasure_Legs_Shield", srDisplayName = $710937, ArmorPlotState = 19458, Conditional = 1777, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_Shield}, 
                     {ArmorString = "ArmorTreasure_Legs_PowerDamage", srDisplayName = $710938, ArmorPlotState = 19462, Conditional = 1782, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_PowerDamage}, 
                     {ArmorString = "ArmorTreasure_Legs_Movement", srDisplayName = $710939, ArmorPlotState = 19470, Conditional = 1786, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_Movement}, 
                     {ArmorString = "ArmorTreasure_Legs_WeaponDamage", srDisplayName = $710940, ArmorPlotState = 21402, Conditional = 1790, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_WeaponDamage}, 
                     {ArmorString = "ArmorTreasure_Legs_AmmoCapacity", srDisplayName = $710941, ArmorPlotState = 20917, Conditional = 1794, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_AmmoCapacity}, 
                     {ArmorString = "ArmorTreasure_Legs_MeleeDamage", srDisplayName = $710942, ArmorPlotState = 20921, Conditional = 1798, ArmorPiece = EArmorTreasurePiece.ArmorTreasure_Legs_MeleeDamage}
                    )
}