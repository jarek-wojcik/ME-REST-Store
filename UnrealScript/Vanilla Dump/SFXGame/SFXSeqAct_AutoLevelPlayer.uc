Class SFXSeqAct_AutoLevelPlayer extends SequenceAction
    config(Game);

struct MissionScore 
{
    var Name MissionName;
    var float Value;
};

var config array<MissionScore> MissionScores;
var config int FullGameExperience;
var float SideContentXP;

public function Activated()
{
    local SFXPawn_Player Pawn;
    local BioPlayerController Player;
    
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = TRUE;
    return;
    Player = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (Player != None)
    {
        if (Player.IsFinalReleaseBuild())
        {
            return;
        }
        Pawn = SFXPawn_Player(Player.Pawn);
        if (Pawn != None)
        {
            if (Pawn.CharacterLevel > 1)
            {
                OutputLinks[0].bHasImpulse = FALSE;
                OutputLinks[1].bHasImpulse = TRUE;
                return;
            }
            if (!SFXGRI(Class'Engine'.static.GetCurrentWorldInfo().GRI).bIsMultiplayerCharacter)
            {
                AutoLevelUpPlot();
            }
            OutputLinks[0].bHasImpulse = TRUE;
            OutputLinks[1].bHasImpulse = FALSE;
        }
    }
}
public static function AutoLevelUpPlot()
{
    local BioWorldInfo World;
    local SFXGame Game;
    local BioPlayerController PC;
    local SFXPawn_Player Player;
    local BioPawn SquadMember;
    local int nIndex;
    local int idx;
    local BioGlobalVariableTable VarTable;
    local TD LevelTreasure;
    local SFXInventoryManager Inventory;
    local string Item;
    local string CurrentMap;
    local SFXEngine Eng;
    local bool bTreasureAlreadyAwarded;
    local Class<SFXWeapon> WeaponClass;
    local SFXWeapon Weapon;
    local SFXGAWAssetsHandler GAWHandler;
    local Class<SFXWeaponMod> WeaponModClass;
    local Class<SFXWeapon_AssaultRifle_Base> AssaultRifleClass;
    local Class<SFXWeapon_SniperRifle_Base> SniperRifleClass;
    local Class<SFXWeapon_Shotgun_Base> ShotgunClass;
    local Class<SFXWeapon_Pistol_Base> PistolClass;
    local Class<SFXWeapon_SMG_Base> SMGClass;
    
    World = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    Game = SFXGame(World.Game);
    PC = World.GetLocalPlayerController();
    Player = SFXPawn_Player(PC.Pawn);
    VarTable = World.GetGlobalVariables();
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    Inventory = SFXInventoryManager(PC.Pawn.InvManager);
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (World == None || Game == None || PC == None || Player == None || VarTable == None || Inventory == None || Eng == None || GAWHandler == None)
    {
        return;
    }
    CurrentMap = World.GetMapName();
    foreach Game.TREASURE.LevelTreasure(LevelTreasure, )
    {
        if (LevelTreasure.PlotId != 0 && VarTable.GetInt(LevelTreasure.PlotId) != 0 && LevelTreasure.Level != CurrentMap)
        {
            bTreasureAlreadyAwarded = FALSE;
            for (idx = 0; idx < Eng.SavedTreasure.Length; idx++)
            {
                if (Eng.SavedTreasure[idx].LevelName == Name(LevelTreasure.Level))
                {
                    bTreasureAlreadyAwarded = bTreasureAlreadyAwarded || float(Eng.SavedTreasure[idx].nXP) > 0.0;
                }
            }
            if (bTreasureAlreadyAwarded)
            {
                continue;
            }
            Game.AwardXP(LevelTreasure.XP, LevelTreasure.Level);
            Game.AwardXP(int(default.SideContentXP * float(LevelTreasure.XP)));
            Game.AwardCredits(LevelTreasure.Credits, LevelTreasure.Level);
            foreach LevelTreasure.TREASURE(Item, )
            {
                if (Split(Item, "SFXWeaponMod") != Item)
                {
                    Game.AwardItem(Name(Item), LevelTreasure.Level);
                    WeaponModClass = Class'SFXWeaponMod'.static.LoadModClass(Item);
                    if (WeaponModClass != None)
                    {
                        WeaponModClass.static.Upgrade(Player, TRUE);
                    }
                }
                else if (Split(Item, "SFXWeapon") != Item)
                {
                    Game.AwardItem(Name(Item), LevelTreasure.Level);
                    WeaponClass = Class'SFXWeapon'.static.FindWeaponClass(Item);
                    if (WeaponClass != None)
                    {
                        Class'SFXWeapon'.static.Upgrade(Player, WeaponClass, TRUE);
                        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_AssaultRifle_Base'))
                        {
                            AssaultRifleClass = Class<SFXWeapon_AssaultRifle_Base>(WeaponClass);
                        }
                        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_SniperRifle_Base'))
                        {
                            SniperRifleClass = Class<SFXWeapon_SniperRifle_Base>(WeaponClass);
                        }
                        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_Shotgun_Base'))
                        {
                            ShotgunClass = Class<SFXWeapon_Shotgun_Base>(WeaponClass);
                        }
                        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_Pistol_Base'))
                        {
                            PistolClass = Class<SFXWeapon_Pistol_Base>(WeaponClass);
                        }
                        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_SMG_Base'))
                        {
                            SMGClass = Class<SFXWeapon_SMG_Base>(WeaponClass);
                        }
                    }
                }
                else if (Left(Item, 9) == "GAWAsset_")
                {
                    GAWHandler.UnlockGAWAssetByAssetName(Item);
                }
            }
        }
    }
    if (AssaultRifleClass != None && Class'SFXPlayerSquadLoadoutData'.static.IsWeaponClassInThePlayersDefaultWeaponGroups(AssaultRifleClass) == TRUE)
    {
        Weapon = Game.Spawn(AssaultRifleClass);
        if (Weapon != None)
        {
            Player.GiveWeaponToPlayer(Weapon);
        }
    }
    if (SniperRifleClass != None && Class'SFXPlayerSquadLoadoutData'.static.IsWeaponClassInThePlayersDefaultWeaponGroups(SniperRifleClass) == TRUE)
    {
        Weapon = Game.Spawn(SniperRifleClass);
        if (Weapon != None)
        {
            Player.GiveWeaponToPlayer(Weapon);
        }
    }
    if (ShotgunClass != None && Class'SFXPlayerSquadLoadoutData'.static.IsWeaponClassInThePlayersDefaultWeaponGroups(ShotgunClass) == TRUE)
    {
        Weapon = Game.Spawn(ShotgunClass);
        if (Weapon != None)
        {
            Player.GiveWeaponToPlayer(Weapon);
        }
    }
    if (PistolClass != None && Class'SFXPlayerSquadLoadoutData'.static.IsWeaponClassInThePlayersDefaultWeaponGroups(PistolClass) == TRUE)
    {
        Weapon = Game.Spawn(PistolClass);
        if (Weapon != None)
        {
            Player.GiveWeaponToPlayer(Weapon);
        }
    }
    if (SMGClass != None && Class'SFXPlayerSquadLoadoutData'.static.IsWeaponClassInThePlayersDefaultWeaponGroups(SMGClass) == TRUE)
    {
        Weapon = Game.Spawn(SMGClass);
        if (Weapon != None)
        {
            Player.GiveWeaponToPlayer(Weapon);
        }
    }
    Player.UpdatePlayerLoadoutInfo();
    foreach Player.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        Weapon.ApplyDefaultWeaponMods(FALSE);
    }
    for (nIndex = 0; nIndex < Player.Squad.Members.Length; nIndex++)
    {
        SquadMember = BioPawn(Player.Squad.Members[nIndex]);
        if (SquadMember != None)
        {
            Class'BioLevelUpSystem'.static.AutoLevelUpPowers(SquadMember);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MissionScores = ({MissionName = 'Biop_ProEar', Value = 1.0}, 
                     {MissionName = 'Biop_ProMar', Value = 1.0}, 
                     {MissionName = 'BioP_ProCit', Value = 1.0}, 
                     {MissionName = 'Biop_KroGar', Value = 1.0}, 
                     {MissionName = 'Biop_Gth001', Value = 1.0}, 
                     {MissionName = 'Biop_Gth002', Value = 1.0}, 
                     {MissionName = 'Biop_GthN7a', Value = 1.0}, 
                     {MissionName = 'biop_gthn7b', Value = 1.0}, 
                     {MissionName = 'Biop_GthLeg', Value = 1.0}, 
                     {MissionName = 'BioP_Cat001', Value = 1.0}, 
                     {MissionName = 'Biop_Kro001', Value = 1.0}, 
                     {MissionName = 'Biop_Kro002', Value = 1.0}, 
                     {MissionName = 'Biop_KroN7a', Value = 1.0}, 
                     {MissionName = 'Biop_KroN7b', Value = 1.0}, 
                     {MissionName = 'Biop_KroGru', Value = 1.0}, 
                     {MissionName = 'Biop_Cat002', Value = 1.0}, 
                     {MissionName = 'BioP_CitHub', Value = 0.5}, 
                     {MissionName = 'Biop_Cat003', Value = 1.0}, 
                     {MissionName = 'Biop_CerMir', Value = 1.0}, 
                     {MissionName = 'Biop_CerJcb', Value = 1.0}, 
                     {MissionName = 'Biop_CitSam', Value = 1.0}, 
                     {MissionName = 'biop_omgzae', Value = 1.0}, 
                     {MissionName = 'Biop_OmgJck', Value = 1.0}, 
                     {MissionName = 'Biop_End001', Value = 1.0}, 
                     {MissionName = 'Biop_End002', Value = 1.0}, 
                     {MissionName = 'BioP_End003', Value = 1.0}
                    )
    FullGameExperience = 69000
    SideContentXP = 0.333333343
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    bManualHandleOutputs = TRUE
}