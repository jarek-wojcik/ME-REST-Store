Class SFXGameConfig
    config(Game);

struct PurchasableItem 
{
    var string className;
    var int Id;
};
struct TreasureBudget 
{
    var int LevelId;
    var int Credits;
    var int Eezo;
    var int Palladium;
    var int Platinum;
    var int Iridium;
};

var config array<LevelReward> LevelRewards;
var config array<PurchasableItem> MPPlayerVariableMappings;
var config Vector2D AmmoDropChance;
var config int MaxPlayerExperience;
var config float PawnInRagdollDamageMultiplier;
var config float DroppedWeaponLifespan;
var config float EmptyDroppedWeaponLifespan;
var const int CreditsGlobal;
var const int IridiumGlobal;
var const int PlatinumGlobal;
var const int PalladiumGlobal;
var const int EezoGlobal;
var const int IdGlobal;
var const int CreditsLocal;
var const int EezoLocal;
var const int IridiumLocal;
var const int PalladiumLocal;
var const int PlatinumLocal;
var const int IdLocal;
var config bool bShieldsBlockPowers;
var config bool bAimAssistEnabled;
var config bool bUseConsoleControls;
var config bool DropHeavyWeaponOnHolster;
var config bool bCoverProtectedCone;
var bool ScoreEnabled;
var config bool bBudgetEnforced;

public function TreasureBudget GetGlobalBudget()
{
    local TreasureBudget stTreasureBudget;
    local BioGlobalVariableTable oGV;
    
    oGV = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    stTreasureBudget.LevelId = oGV.GetInt(IdGlobal);
    stTreasureBudget.Credits = oGV.GetInt(CreditsGlobal);
    stTreasureBudget.Eezo = oGV.GetInt(EezoGlobal);
    stTreasureBudget.Iridium = oGV.GetInt(IridiumGlobal);
    stTreasureBudget.Palladium = oGV.GetInt(PalladiumGlobal);
    stTreasureBudget.Platinum = oGV.GetInt(PlatinumGlobal);
    return stTreasureBudget;
}
public function TreasureBudget GetLevelBudget()
{
    local TreasureBudget stTreasureBudget;
    local BioGlobalVariableTable oGV;
    
    oGV = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    stTreasureBudget.LevelId = oGV.GetInt(IdLocal);
    stTreasureBudget.Credits = oGV.GetInt(CreditsLocal);
    stTreasureBudget.Eezo = oGV.GetInt(EezoLocal);
    stTreasureBudget.Iridium = oGV.GetInt(IridiumLocal);
    stTreasureBudget.Palladium = oGV.GetInt(PalladiumLocal);
    stTreasureBudget.Platinum = oGV.GetInt(PlatinumLocal);
    return stTreasureBudget;
}
public static final function int GetMaxPurchasableItemID()
{
    local int idx;
    local int MaxID;
    
    MaxID = 0;
    for (idx = 0; idx < default.MPPlayerVariableMappings.Length; ++idx)
    {
        if (default.MPPlayerVariableMappings[idx].Id > MaxID)
        {
            MaxID = default.MPPlayerVariableMappings[idx].Id;
        }
    }
    return MaxID;
}
public static final function string GetPurchasableItemClassName(int Id)
{
    local int idx;
    
    idx = default.MPPlayerVariableMappings.Find('Id', Id);
    if (idx < 0)
    {
        return "";
    }
    return default.MPPlayerVariableMappings[idx].className;
}
public static final function int GetPurchasableItemID(string className)
{
    local int idx;
    
    idx = default.MPPlayerVariableMappings.Find('className', className);
    if (idx < 0)
    {
        return -1;
    }
    return default.MPPlayerVariableMappings[idx].Id;
}
public function int RecordTreasure(EInventoryResourceTypes eType, int Award, optional int LevelId = -1)
{
    local SResourceBudget Budget;
    local SFXPlotTreasure oTreasure;
    local BioGlobalVariableTable oGV;
    local TreasureBudget stLevelBudget;
    local TreasureBudget stGlobalBudget;
    
    oTreasure = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).m_oTreasure;
    if (LevelId == -1)
    {
        Budget = oTreasure.Budget();
        LevelId = Budget.nID;
    }
    else
    {
        Budget = oTreasure.BudgetFromId(LevelId);
    }
    if (Budget.nID == 0)
    {
        return Award;
    }
    oGV = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    stLevelBudget = GetLevelBudget();
    stGlobalBudget = GetGlobalBudget();
    if (Budget.nID != stLevelBudget.LevelId)
    {
        stGlobalBudget.LevelId = Budget.nID;
        stGlobalBudget.Credits += stLevelBudget.Credits;
        stGlobalBudget.Eezo += stLevelBudget.Eezo;
        stGlobalBudget.Iridium += stLevelBudget.Iridium;
        stGlobalBudget.Palladium += stLevelBudget.Palladium;
        stGlobalBudget.Platinum += stLevelBudget.Platinum;
        stLevelBudget.LevelId = Budget.nID;
        stLevelBudget.Credits = 0;
        stLevelBudget.Eezo = 0;
        stLevelBudget.Iridium = 0;
        stLevelBudget.Palladium = 0;
        stLevelBudget.Platinum = 0;
    }
    if (Award <= 0)
    {
        oGV.SetInt(CreditsGlobal, stGlobalBudget.Credits);
        oGV.SetInt(EezoGlobal, stGlobalBudget.Eezo);
        oGV.SetInt(PalladiumGlobal, stGlobalBudget.Palladium);
        oGV.SetInt(PlatinumGlobal, stGlobalBudget.Platinum);
        oGV.SetInt(IridiumGlobal, stGlobalBudget.Iridium);
        oGV.SetInt(IdGlobal, stGlobalBudget.LevelId);
        oGV.SetInt(CreditsLocal, stLevelBudget.Credits);
        oGV.SetInt(EezoLocal, stLevelBudget.Eezo);
        oGV.SetInt(PalladiumLocal, stLevelBudget.Palladium);
        oGV.SetInt(PlatinumLocal, stLevelBudget.Platinum);
        oGV.SetInt(IridiumLocal, stLevelBudget.Iridium);
        oGV.SetInt(IdLocal, stLevelBudget.LevelId);
        return Award;
    }
    if (eType == EInventoryResourceTypes.INV_RESOURCE_CREDITS)
    {
        if (bBudgetEnforced && stLevelBudget.Credits + Award > Budget.nCredits)
        {
            Award = Budget.nCredits - stLevelBudget.Credits;
        }
        Award = Award <= 0 ? 1 : Award;
        stLevelBudget.Credits += Award;
    }
    else if (eType == EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO)
    {
        if (bBudgetEnforced && stLevelBudget.Eezo + Award > Budget.nEezo)
        {
            Award = Budget.nEezo - stLevelBudget.Eezo;
        }
        Award = Award <= 0 ? 1 : Award;
        stLevelBudget.Eezo += Award;
    }
    else if (eType == EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM)
    {
        if (bBudgetEnforced && stLevelBudget.Iridium + Award > Budget.nIridium)
        {
            Award = Budget.nIridium - stLevelBudget.Iridium;
        }
        Award = Award <= 0 ? 1 : Award;
        stLevelBudget.Iridium += Award;
    }
    else if (eType == EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM)
    {
        if (bBudgetEnforced && stLevelBudget.Palladium + Award > Budget.nPalladium)
        {
            Award = Budget.nPalladium - stLevelBudget.Palladium;
        }
        Award = Award <= 0 ? 1 : Award;
        stLevelBudget.Palladium += Award;
    }
    else if (eType == EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM)
    {
        if (bBudgetEnforced && stLevelBudget.Platinum + Award > Budget.nPlatinum)
        {
            Award = Budget.nPlatinum - stLevelBudget.Platinum;
        }
        Award = Award <= 0 ? 1 : Award;
        stLevelBudget.Platinum += Award;
    }
    oGV.SetInt(CreditsGlobal, stGlobalBudget.Credits);
    oGV.SetInt(EezoGlobal, stGlobalBudget.Eezo);
    oGV.SetInt(PalladiumGlobal, stGlobalBudget.Palladium);
    oGV.SetInt(PlatinumGlobal, stGlobalBudget.Platinum);
    oGV.SetInt(IridiumGlobal, stGlobalBudget.Iridium);
    oGV.SetInt(IdGlobal, stGlobalBudget.LevelId);
    oGV.SetInt(CreditsLocal, stLevelBudget.Credits);
    oGV.SetInt(EezoLocal, stLevelBudget.Eezo);
    oGV.SetInt(PalladiumLocal, stLevelBudget.Palladium);
    oGV.SetInt(PlatinumLocal, stLevelBudget.Platinum);
    oGV.SetInt(IridiumLocal, stLevelBudget.Iridium);
    oGV.SetInt(IdLocal, stLevelBudget.LevelId);
    GetLevelBudget();
    GetGlobalBudget();
    return Award;
}
public static final function bool VerifyPurchasableItems()
{
    local int idx;
    local int nIndex;
    local bool bDuplicatesFound;
    
    bDuplicatesFound = FALSE;
    for (idx = 0; idx < default.MPPlayerVariableMappings.Length; ++idx)
    {
        nIndex = default.MPPlayerVariableMappings.Find('className', default.MPPlayerVariableMappings[idx].className);
        if (nIndex >= 0 && nIndex != idx)
        {
            bDuplicatesFound = TRUE;
        }
        nIndex = default.MPPlayerVariableMappings.Find('Id', default.MPPlayerVariableMappings[idx].Id);
        if (nIndex >= 0 && nIndex != idx)
        {
            bDuplicatesFound = TRUE;
        }
    }
    return !bDuplicatesFound;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LevelRewards = ({Level = 1, ExperienceRequired = 0, TalentReward = 3, HenchmanTalentReward = 1}, 
                    {Level = 2, ExperienceRequired = 1000, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 3, ExperienceRequired = 2000, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 4, ExperienceRequired = 3000, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 5, ExperienceRequired = 4000, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 6, ExperienceRequired = 5000, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 7, ExperienceRequired = 6100, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 8, ExperienceRequired = 7200, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 9, ExperienceRequired = 8300, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 10, ExperienceRequired = 9400, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 11, ExperienceRequired = 10625, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 12, ExperienceRequired = 11850, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 13, ExperienceRequired = 13075, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 14, ExperienceRequired = 14300, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 15, ExperienceRequired = 15525, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 16, ExperienceRequired = 16875, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 17, ExperienceRequired = 18225, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 18, ExperienceRequired = 19575, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 19, ExperienceRequired = 20925, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 20, ExperienceRequired = 22275, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 21, ExperienceRequired = 23775, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 22, ExperienceRequired = 25275, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 23, ExperienceRequired = 26775, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 24, ExperienceRequired = 28725, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 25, ExperienceRequired = 29775, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 26, ExperienceRequired = 31425, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 27, ExperienceRequired = 33075, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 28, ExperienceRequired = 34725, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 29, ExperienceRequired = 36375, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 30, ExperienceRequired = 38025, TalentReward = 2, HenchmanTalentReward = 1}, 
                    {Level = 31, ExperienceRequired = 39850, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 32, ExperienceRequired = 41675, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 33, ExperienceRequired = 43500, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 34, ExperienceRequired = 45325, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 35, ExperienceRequired = 47150, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 36, ExperienceRequired = 49175, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 37, ExperienceRequired = 51200, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 38, ExperienceRequired = 53225, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 39, ExperienceRequired = 55250, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 40, ExperienceRequired = 57275, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 41, ExperienceRequired = 59525, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 42, ExperienceRequired = 61775, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 43, ExperienceRequired = 64025, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 44, ExperienceRequired = 66275, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 45, ExperienceRequired = 68525, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 46, ExperienceRequired = 71000, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 47, ExperienceRequired = 73475, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 48, ExperienceRequired = 75950, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 49, ExperienceRequired = 78425, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 50, ExperienceRequired = 80900, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 51, ExperienceRequired = 83600, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 52, ExperienceRequired = 86300, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 53, ExperienceRequired = 89000, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 54, ExperienceRequired = 91700, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 55, ExperienceRequired = 94400, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 56, ExperienceRequired = 99800, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 57, ExperienceRequired = 105200, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 58, ExperienceRequired = 110600, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 59, ExperienceRequired = 116000, TalentReward = 4, HenchmanTalentReward = 2}, 
                    {Level = 60, ExperienceRequired = 121400, TalentReward = 4, HenchmanTalentReward = 2}
                   )
    MPPlayerVariableMappings = ({className = "SFXGameMPContent.SFXPowerCustomActionMP_AdrenalineRush", Id = 139}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_AIHacking", Id = 140}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Barrier", Id = 142}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_BioticCharge", Id = 143}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_BioticGrenade", Id = 144}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Carnage", Id = 145}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Cloak", Id = 146}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_CombatDrone", Id = 147}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_ConcussiveShot", Id = 148}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_CryoBlast", Id = 150}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Decoy", Id = 151}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Discharge", Id = 152}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_EnergyDrain", Id = 156}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Fortification", Id = 158}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_FragGrenade", Id = 159}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_GethShieldBoost", Id = 160}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Incinerate", Id = 162}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_InfernoGrenade", Id = 163}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_LiftGrenade", Id = 166}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Marksman", Id = 168}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Overload", Id = 170}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_ProximityMine", Id = 172}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Pull", Id = 173}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Reave", Id = 174}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_SentryTurret", Id = 176}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Shockwave", Id = 177}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Singularity", Id = 179}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Slam", Id = 180}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Stasis", Id = 181}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_StickyGrenade", Id = 182}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor", Id = 183}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Throw", Id = 184}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Warp", Id = 185}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_AsariMeleePassive", Id = 188}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_AsariPassive", Id = 189}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_DrellMeleePassive", Id = 196}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_DrellPassive", Id = 197}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianMeleePassive", Id = 198}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianPassive", Id = 199}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Adept", Id = 200}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Engineer", Id = 201}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator", Id = 202}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Sentinel", Id = 203}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Soldier", Id = 204}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Vanguard", Id = 205}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_HumanPassive", Id = 206}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_KroganMeleePassive", Id = 207}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_KroganPassive", Id = 208}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_SalarianMeleePassive", Id = 209}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_SalarianPassive", Id = 210}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_TurianMeleePassive", Id = 212}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_TurianPassive", Id = 213}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Turian", Id = 265}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Krogan", Id = 266}, 
                                {className = "MatchConsumable_ActiveXPBonusMultiplierIndex_1", Id = 132}, 
                                {className = "MatchConsumable_ActiveXPBonusMultiplierIndex_2", Id = 133}, 
                                {className = "MatchConsumable_ActiveXPBonusMultiplierIndex_3", Id = 134}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus_0", Id = 126}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus_1", Id = 127}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus_2", Id = 128}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus_0", Id = 129}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus_1", Id = 130}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus_2", Id = 131}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle_0", Id = 111}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle_1", Id = 112}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle_2", Id = 113}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle_0", Id = 114}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle_1", Id = 115}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle_2", Id = 116}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun_0", Id = 117}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun_1", Id = 118}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun_2", Id = 119}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol_0", Id = 120}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol_1", Id = 121}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol_2", Id = 122}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG_0", Id = 123}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG_1", Id = 124}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG_2", Id = 125}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary_0", Id = 90}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary_1", Id = 91}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary_2", Id = 92}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor_0", Id = 93}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor_1", Id = 94}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor_2", Id = 95}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing_0", Id = 96}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing_1", Id = 97}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing_2", Id = 98}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp_0", Id = 99}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp_1", Id = 100}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp_2", Id = 101}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo_0", Id = 102}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo_1", Id = 103}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo_2", Id = 104}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_0", Id = 105}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_1", Id = 106}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_2", Id = 107}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_3", Id = 108}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_4", Id = 109}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus_5", Id = 110}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_0", Id = 259}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_1", Id = 260}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_2", Id = 261}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_3", Id = 262}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_4", Id = 263}, 
                                {className = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage_5", Id = 264}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Ammo", Id = 86}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Revive", Id = 87}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Rocket", Id = 88}, 
                                {className = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Shield", Id = 89}, 
                                {className = "MPCapacity_Ammo", Id = 242}, 
                                {className = "MPCapacity_Revive", Id = 243}, 
                                {className = "MPCapacity_Rocket", Id = 244}, 
                                {className = "MPCapacity_Shield", Id = 245}, 
                                {className = "MPRespec", Id = 246}, 
                                {className = "SFXGameChoiceGUIData_StoreData_MPAssaultRifles_InventoryLocked", Id = 56}, 
                                {className = "SFXGameChoiceGUIData_StoreData_MPPistols_InventoryLocked", Id = 57}, 
                                {className = "SFXGameChoiceGUIData_StoreData_MPShotguns_InventoryLocked", Id = 58}, 
                                {className = "SFXGameChoiceGUIData_StoreData_MPSMGs_InventoryLocked", Id = 59}, 
                                {className = "SFXGameChoiceGUIData_StoreData_MPSniperRifles_InventoryLocked", Id = 60}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Avenger", Id = 0}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Collector", Id = 1}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Geth", Id = 2}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Mattock", Id = 3}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Cobra", Id = 4}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Falcon", Id = 5}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Revenant", Id = 6}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Vindicator", Id = 7}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Saber", Id = 135}, 
                                {className = "SFXGameContent.SFXWeapon_AssaultRifle_Reckoning", Id = 241}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Incisor", Id = 8}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Mantis", Id = 9}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Raptor", Id = 10}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Javelin", Id = 11}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Viper", Id = 12}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_Widow", Id = 13}, 
                                {className = "SFXGameContent.SFXWeapon_SniperRifle_BlackWidow", Id = 136}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Claymore", Id = 14}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Eviscerator", Id = 15}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Striker", Id = 137}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Geth", Id = 16}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Katana", Id = 17}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Graal", Id = 18}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Disciple", Id = 19}, 
                                {className = "SFXGameContent.SFXWeapon_Shotgun_Scimitar", Id = 20}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Carnifex", Id = 21}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Ivory", Id = 138}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Talon", Id = 22}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Thor", Id = 23}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Phalanx", Id = 24}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Predator", Id = 25}, 
                                {className = "SFXGameContent.SFXWeapon_Pistol_Scorpion", Id = 26}, 
                                {className = "SFXGameContent.SFXWeapon_SMG_Locust", Id = 27}, 
                                {className = "SFXGameContent.SFXWeapon_SMG_Hornet", Id = 28}, 
                                {className = "SFXGameContent.SFXWeapon_SMG_Shuriken", Id = 29}, 
                                {className = "SFXGameContent.SFXWeapon_SMG_Tempest", Id = 30}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", Id = 31}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", Id = 32}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleStability", Id = 33}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", Id = 34}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleForce", Id = 35}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleDamage", Id = 36}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", Id = 37}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", Id = 38}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", Id = 39}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", Id = 40}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunDamage", Id = 41}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", Id = 42}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunStability", Id = 43}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", Id = 44}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", Id = 45}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolDamage", Id = 46}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolAccuracy", Id = 47}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolStability", Id = 48}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolMagSize", Id = 49}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", Id = 50}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGDamage", Id = 51}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGAccuracy", Id = 52}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGStability", Id = 53}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGMagSize", Id = 54}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", Id = 55}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleDamage_Display", Id = 61}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy_Display", Id = 62}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleStability_Display", Id = 63}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize_Display", Id = 64}, 
                                {className = "SFXGameContent.SFXWeaponMod_AssaultRifleForce_Display", Id = 65}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleDamage_Display", Id = 66}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy_Display", Id = 67}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleStability_Display", Id = 68}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation_Display", Id = 69}, 
                                {className = "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage_Display", Id = 70}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunDamage_Display", Id = 71}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage_Display", Id = 72}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunStability_Display", Id = 73}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunAccuracy_Display", Id = 74}, 
                                {className = "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed_Display", Id = 75}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolDamage_Display", Id = 76}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolAccuracy_Display", Id = 77}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolStability_Display", Id = 78}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolMagSize_Display", Id = 79}, 
                                {className = "SFXGameContent.SFXWeaponMod_PistolReloadSpeed_Display", Id = 80}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGDamage_Display", Id = 81}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGAccuracy_Display", Id = 82}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGStability_Display", Id = 83}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGMagSize_Display", Id = 84}, 
                                {className = "SFXGameContent.SFXWeaponMod_SMGConstraintDamage_Display", Id = 85}, 
                                {className = "AdeptAsari", Id = 217}, 
                                {className = "AdeptDrell", Id = 218}, 
                                {className = "EngineerQuarian", Id = 219}, 
                                {className = "EngineerSalarian", Id = 220}, 
                                {className = "InfiltratorSalarian", Id = 221}, 
                                {className = "InfiltratorQuarian", Id = 222}, 
                                {className = "SentinelTurian", Id = 223}, 
                                {className = "SentinelKrogan", Id = 224}, 
                                {className = "SoldierKrogan", Id = 225}, 
                                {className = "SoldierTurian", Id = 226}, 
                                {className = "VanguardDrell", Id = 227}, 
                                {className = "VanguardAsari", Id = 228}, 
                                {className = "AdeptHumanFemale", Id = 247}, 
                                {className = "AdeptHumanMale", Id = 248}, 
                                {className = "EngineerHumanFemale", Id = 249}, 
                                {className = "EngineerHumanMale", Id = 250}, 
                                {className = "InfiltratorHumanFemale", Id = 251}, 
                                {className = "InfiltratorHumanMale", Id = 252}, 
                                {className = "SentinelHumanFemale", Id = 253}, 
                                {className = "SentinelHumanMale", Id = 254}, 
                                {className = "SoldierHumanFemale", Id = 255}, 
                                {className = "SoldierHumanMale", Id = 256}, 
                                {className = "VanguardHumanFemale", Id = 257}, 
                                {className = "VanguardHumanMale", Id = 258}, 
                                {className = "SoldierHumanMaleBF3", Id = 268}, 
                                {className = "LastPromoIDShown", Id = 270}, 
                                {className = "starter", Id = 232}, 
                                {className = "bf3", Id = 269}, 
                                {className = "recru_asa", Id = 272}, 
                                {className = "recru_kro", Id = 273}, 
                                {className = "recru_qua", Id = 274}, 
                                {className = "recru_sal", Id = 275}, 
                                {className = "recru_tur", Id = 276}, 
                                {className = "recru_dre", Id = 277}, 
                                {className = "NewlyAffordableStoreItems", Id = 271}
                               )
    MaxPlayerExperience = 121400
    DroppedWeaponLifespan = 300.0
    EmptyDroppedWeaponLifespan = 12.0
    CreditsGlobal = 595
    IridiumGlobal = 596
    PlatinumGlobal = 597
    PalladiumGlobal = 598
    EezoGlobal = 599
    IdGlobal = 600
    CreditsLocal = 601
    EezoLocal = 605
    IridiumLocal = 602
    PalladiumLocal = 604
    PlatinumLocal = 603
    IdLocal = 608
    bShieldsBlockPowers = TRUE
    bCoverProtectedCone = TRUE
    bBudgetEnforced = TRUE
}