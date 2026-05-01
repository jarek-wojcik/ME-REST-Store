Class SFSCharacterModel;

struct SFSCharacterModelStruct 
{
    var string Id;
    var string SortOrder;
    var string TeamId;
    var bool bActive;
    var string Name;
    var string PreferredSpecies;
    var string VoiceCharId;
    var string VoiceKitId;
    var string CharacterID;
    var string AppearanceCharID;
    var string AppearancePawnType;
    var bool bUseHelmet;
    var bool bUseHeadgear;
    var string DodgeCharId;
    var string HeavyMeleeCharId;
    var string LightMeleeCharId;
    var int Level;
    var int XP;
    var string ShieldType;
    var int SkillPoints;
    var int SkillLevel_Pistols;
    var int SkillLevel_SMGs;
    var int SkillLevel_AssaultRifles;
    var int SkillLevel_Shotguns;
    var int SkillLevel_SniperRifles;
    var int SkillLevel_MeleeCombat;
    var int SkillLevel_Gadgets;
    var int SkillLevel_Tech;
    var int SkillLevel_Biotics;
    var int SkillLevel_Barrier;
    var int SkillLevel_Shielding;
    var int SkillLevel_SpectreTraining;
    var SFSWeaponModelStruct Weapons[5];
    var int WeaponCount;
    var SFSPowerModelStruct Powers[5];
    var int PowerCount;
    var bool bHasBorrowedPower;
    var SFSPowerModelStruct BorrowedPower;
    var SFSInventoryModelStruct Inventory;
    
    structdefaultproperties
    {
        Powers[0] = {
                     PowerID = "", 
                     Rank = 0, 
                     Evo0 = "", 
                     Evo1 = "", 
                     Evo2 = "", 
                     KitID = ""
                    }
        Powers[1] = {
                     PowerID = "", 
                     Rank = 0, 
                     Evo0 = "", 
                     Evo1 = "", 
                     Evo2 = "", 
                     KitID = ""
                    }
        Powers[2] = {
                     PowerID = "", 
                     Rank = 0, 
                     Evo0 = "", 
                     Evo1 = "", 
                     Evo2 = "", 
                     KitID = ""
                    }
        Powers[3] = {
                     PowerID = "", 
                     Rank = 0, 
                     Evo0 = "", 
                     Evo1 = "", 
                     Evo2 = "", 
                     KitID = ""
                    }
        Powers[4] = {
                     PowerID = "", 
                     Rank = 0, 
                     Evo0 = "", 
                     Evo1 = "", 
                     Evo2 = "", 
                     KitID = ""
                    }
        BorrowedPower = {
                         PowerID = "", 
                         Rank = 0, 
                         Evo0 = "", 
                         Evo1 = "", 
                         Evo2 = "", 
                         KitID = ""
                        }
    }
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}