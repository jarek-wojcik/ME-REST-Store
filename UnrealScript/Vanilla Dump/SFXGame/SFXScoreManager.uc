Class SFXScoreManager
    config(Game);

struct MedalDefinition 
{
    var string Icon;
    var stringref MedalName;
    var int Threshold;
    var int Score;
    var int ReplacesIdx;
    var MPMedalType Type;
};
struct PlayerMedalRecord 
{
    var array<int> TrackingCounts;
    var SFXPawn_Player Player;
};
enum MPMedalType
{
    MPMedalType_Invalid,
    MPMedalType_Kill,
    MPMedalType_MeleeKill,
    MPMedalType_OverCoverKill,
    MPMedalType_Headshot,
    MPMedalType_AssaultRifle,
    MPMedalType_SniperRifle,
    MPMedalType_Shotgun,
    MPMedalType_Pistol,
    MPMedalType_SMG,
    MPMedalType_HeavyWeapon,
    MPMedalType_Biotics,
    MPMedalType_Tech,
    MPMedalType_Revive,
    MPMedalType_Assist,
    MPMedalType_Survival,
    MPMedalType_ChallengeLevel,
    MPMedalType_Extraction,
    MPMedalType_Killstreak,
    MPMedalType_RandomMap,
    MPMedalType_RandomFaction,
};
struct CreditBudget 
{
    var SFXPawn_Player Player;
    var int CreditsRewarded;
};
struct DifficultyScoreMultiplier 
{
    var float Multiplier;
    var EDifficultyOptions Difficulty;
};
enum ScoreTagType
{
    ScoreTagType_Kill,
    ScoreTagType_Assist,
    ScoreTagType_Objective,
    ScoreTagType_Medal,
};
enum ScoreType
{
    SCORETYPE_DAMAGE,
    SCORETYPE_POWER,
    SCORETYPE_OBJECTIVE,
    SCORETYPE_MEDAL,
};

var config array<DifficultyScoreMultiplier> DifficultyScoreMultipliers;
var array<CreditBudget> CreditBudgets;
var transient array<PlayerMedalRecord> PlayerMedalRecords;
var transient array<int> SquadMedalRecords;
var config array<MedalDefinition> PlayerMedalDefinitions;
var config array<MedalDefinition> SquadMedalDefinitions;
var transient array<int> ExtractedPlayerIDs;
var transient float KillTimeStamps[5];
var config float ScoreMultiplier;
var protectedwrite transient BioWorldInfo BioWorldInfo;
var protectedwrite transient float EnemyScoreBudget;
var protectedwrite transient float TotalEnemyScoreRewarded;
var protectedwrite transient float ObjectiveCreditBudget;
var protectedwrite transient float ObjectiveScoreBudget;
var protectedwrite transient float ObjectiveScoreRewarded;
var config stringref srKillScoreTag;
var config stringref srAssistScoreTag;
var config stringref srObjectiveScoreTag;
var config float ScorePerExtractedPlayer;
var config float RandomFactionScoreBonus;
var config float RandomMapScoreBonus;
var config float KillstreakMedalWindow;
var config stringref srCreditsEarned;
var config stringref srBonusCreditsEarned;
var transient int LastCreditsEarned;
var transient int LastBonusCreditsEarned;
var transient bool bPlayerDownedInWave;

public final function DisplayScoreTag(SFXPawn_Player Player, float Amount, ScoreTagType Type)
{
    local stringref TagString;
    local SFXPRI PRI;
    
    if (Player == None || Amount <= float(0))
    {
        return;
    }
    PRI = SFXPRI(Player.PlayerReplicationInfo);
    if (PRI == None)
    {
        return;
    }
    switch (Type)
    {
        case ScoreTagType.ScoreTagType_Kill:
            TagString = srKillScoreTag;
            break;
        case ScoreTagType.ScoreTagType_Assist:
            TagString = srAssistScoreTag;
            break;
        default:
            TagString = srObjectiveScoreTag;
    }
    PRI.TriggerNewScoreTag(int(Amount), string(TagString));
}
public final function bool Init()
{
    BioWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    return TRUE;
}
public final function float AddCredits(SFXPawn_Player PlayerPawn, float Amount)
{
    local SFXPRI PRI;
    local bool bPlayerFound;
    local CreditBudget Record;
    local int idx;
    
    if (PlayerPawn == None)
    {
        return 0.0;
    }
    PRI = SFXPRI(PlayerPawn.PlayerReplicationInfo);
    if (PRI == None)
    {
        return 0.0;
    }
    Amount *= GetScoreMultiplier();
    bPlayerFound = FALSE;
    for (idx = 0; idx < CreditBudgets.Length; ++idx)
    {
        if (PlayerPawn == CreditBudgets[idx].Player)
        {
            bPlayerFound = TRUE;
            break;
        }
    }
    if (!bPlayerFound)
    {
        Record.Player = PlayerPawn;
        idx = CreditBudgets.Length;
        CreditBudgets[idx] = Record;
    }
    if (Amount > ObjectiveCreditBudget - float(CreditBudgets[idx].CreditsRewarded))
    {
        return 0.0;
    }
    CreditBudgets[idx].CreditsRewarded += int(Amount);
    PRI.AddCredits(Amount);
    return Amount;
}
public final function float AddScore(SFXPawn_Player PlayerPawn, float Amount, ScoreType Type)
{
    local SFXPRI PRI;
    local int idx;
    local SFXGRI GRI;
    local float fRandomBonus;
    
    if (PlayerPawn == None)
    {
        return 0.0;
    }
    PRI = SFXPRI(PlayerPawn.PlayerReplicationInfo);
    if (PRI == None)
    {
        return 0.0;
    }
    GRI = SFXGRI(BioWorldInfo.GRI);
    if (GRI == None)
    {
        return 0.0;
    }
    Amount *= GetScoreMultiplier();
    if (GRI.RandomFactionChosen())
    {
        fRandomBonus += RandomFactionScoreBonus;
    }
    if (GRI.RandomMapChosen())
    {
        fRandomBonus += RandomMapScoreBonus;
    }
    if (fRandomBonus > float(0))
    {
        Amount *= 1.0 + fRandomBonus;
    }
    idx = DifficultyScoreMultipliers.Find('Difficulty', GRI.DifficultyHandler.CurrentDifficulty);
    if (idx != -1)
    {
        Amount *= DifficultyScoreMultipliers[idx].Multiplier;
    }
    if (Type == ScoreType.SCORETYPE_DAMAGE || Type == ScoreType.SCORETYPE_POWER)
    {
        if (Amount > EnemyScoreBudget - TotalEnemyScoreRewarded)
        {
            return 0.0;
        }
        TotalEnemyScoreRewarded += Amount;
    }
    else if (Type == ScoreType.SCORETYPE_OBJECTIVE)
    {
        if (Amount > ObjectiveScoreBudget - ObjectiveScoreRewarded)
        {
            return 0.0;
        }
        ObjectiveScoreRewarded += Amount;
    }
    PRI.AddPoints(Amount);
    return Amount;
}
public final function ClearSquadMedalStanding(MPMedalType MedalType)
{
    local int MedalDef;
    
    for (MedalDef = 0; MedalDef < SquadMedalDefinitions.Length; MedalDef++)
    {
        if (int(SquadMedalDefinitions[MedalDef].Type) == int(MedalType))
        {
            SquadMedalRecords[MedalDef] = 0;
        }
    }
}
public final function float GetScoreMultiplier()
{
    return ScoreMultiplier;
}
public final function IncrementMedalStanding(SFXPawn_Player PlayerPawn, MPMedalType MedalType, optional int Inc = 1)
{
    local int MedalDef;
    local int PlayerRec;
    local int RemoveMedal;
    local int ScoreBonus;
    local SFXPRI PRI;
    local PlayerReplicationInfo PlayerReplication;
    local SFXGRI GRI;
    local Pawn OtherPlayerPawn;
    
    PRI = SFXPRI(PlayerPawn.PlayerReplicationInfo);
    if (PRI == None)
    {
        return;
    }
    GRI = SFXGRI(BioWorldInfo.GRI);
    if (GRI.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    PlayerRec = PlayerMedalRecords.Find('Player', PlayerPawn);
    if (PlayerRec == -1 && PlayerPawn != None)
    {
        PlayerRec = PlayerMedalRecords.Length;
        PlayerMedalRecords.Add(1);
        PlayerMedalRecords[PlayerRec].Player = PlayerPawn;
        PlayerMedalRecords[PlayerRec].TrackingCounts.Length = PlayerMedalDefinitions.Length;
    }
    if (SquadMedalRecords.Length == 0)
    {
        SquadMedalRecords.Length = SquadMedalDefinitions.Length;
    }
    for (MedalDef = 0; MedalDef < PlayerMedalDefinitions.Length; MedalDef++)
    {
        if (int(PlayerMedalDefinitions[MedalDef].Type) == int(MedalType))
        {
            if (PlayerRec >= 0 && PlayerMedalRecords[PlayerRec].TrackingCounts[MedalDef] != PlayerMedalDefinitions[MedalDef].Threshold)
            {
                if (++PlayerMedalRecords[PlayerRec].TrackingCounts[MedalDef] == PlayerMedalDefinitions[MedalDef].Threshold)
                {
                    ScoreBonus = PlayerMedalDefinitions[MedalDef].Score;
                    if (PlayerMedalDefinitions[MedalDef].ReplacesIdx != 0)
                    {
                        RemoveMedal = MedalDef + PlayerMedalDefinitions[MedalDef].ReplacesIdx;
                        ScoreBonus -= PlayerMedalDefinitions[RemoveMedal].Score;
                        PRI.AddPlayerMedal(MedalDef, RemoveMedal);
                    }
                    else
                    {
                        PRI.AddPlayerMedal(MedalDef);
                    }
                    AddScore(PlayerPawn, float(ScoreBonus), 3);
                }
            }
        }
    }
    for (MedalDef = 0; MedalDef < SquadMedalDefinitions.Length; MedalDef++)
    {
        if (int(SquadMedalDefinitions[MedalDef].Type) == int(MedalType))
        {
            SquadMedalRecords[MedalDef] += Inc;
            if (SquadMedalRecords[MedalDef] == SquadMedalDefinitions[MedalDef].Threshold && GRI.HasSquadMedal(MedalDef) == FALSE)
            {
                ScoreBonus = SquadMedalDefinitions[MedalDef].Score;
                if (SquadMedalDefinitions[MedalDef].ReplacesIdx != 0)
                {
                    RemoveMedal = MedalDef + SquadMedalDefinitions[MedalDef].ReplacesIdx;
                    ScoreBonus -= SquadMedalDefinitions[RemoveMedal].Score;
                    GRI.AddSquadMedal(MedalDef, RemoveMedal);
                }
                else
                {
                    GRI.AddSquadMedal(MedalDef);
                }
                foreach GRI.PRIArray(PlayerReplication, )
                {
                    OtherPlayerPawn = SFXPRI(PlayerReplication).GetAPawn();
                    AddScore(SFXPawn_Player(OtherPlayerPawn), float(ScoreBonus / BioWorldInfo.Game.NumPlayers), 3);
                }
            }
        }
    }
}
public final function NewWaveStarted()
{
    local SFXGRI GRI;
    local int idx;
    local float fRandomBonus;
    
    BioWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    GRI = SFXGRI(BioWorldInfo.GRI);
    TotalEnemyScoreRewarded = 0.0;
    CreditBudgets.Length = 0;
    ObjectiveScoreRewarded = 0.0;
    if (GRI.WaveCoordinator != None)
    {
        EnemyScoreBudget = GRI.WaveCoordinator.GetEnemyScoreBudget();
        ObjectiveCreditBudget = GRI.WaveCoordinator.GetObjectiveCreditBudget();
        ObjectiveScoreBudget = GRI.WaveCoordinator.GetObjectiveScoreBudget();
    }
    EnemyScoreBudget *= GetScoreMultiplier();
    ObjectiveCreditBudget *= GetScoreMultiplier();
    ObjectiveScoreBudget *= GetScoreMultiplier();
    if (GRI.RandomFactionChosen())
    {
        fRandomBonus += RandomFactionScoreBonus;
    }
    if (GRI.RandomMapChosen())
    {
        fRandomBonus += RandomMapScoreBonus;
    }
    if (fRandomBonus > float(0))
    {
        EnemyScoreBudget *= 1.0 + fRandomBonus;
        ObjectiveScoreBudget *= 1.0 + fRandomBonus;
    }
    idx = DifficultyScoreMultipliers.Find('Difficulty', SFXGRI(BioWorldInfo.GRI).DifficultyHandler.CurrentDifficulty);
    if (idx != -1)
    {
        EnemyScoreBudget *= DifficultyScoreMultipliers[idx].Multiplier;
        ObjectiveScoreBudget *= DifficultyScoreMultipliers[idx].Multiplier;
    }
}
public final function PlayerDown()
{
    bPlayerDownedInWave = TRUE;
}
public final function PlayersExtracted(array<SFXPawn_Player> ExtractedPlayers)
{
    local SFXPawn_Player Player;
    
    foreach ExtractedPlayers(Player, )
    {
        if (Player.PlayerReplicationInfo != None)
        {
            ExtractedPlayerIDs.AddItem(Player.PlayerReplicationInfo.PlayerID);
        }
    }
    if (ExtractedPlayers.Length > 0)
    {
        if (ExtractedPlayers.Length == BioWorldInfo.Game.NumPlayers)
        {
            IncrementMedalStanding(ExtractedPlayers[0], 17, 4);
        }
        else
        {
            IncrementMedalStanding(ExtractedPlayers[0], 17, ExtractedPlayers.Length);
        }
    }
}
public final function ProcessKill(Pawn Killed, float Damage, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser, bool HeadShot)
{
    local SFXPawn_Player PlayerPawn;
    local Class<SFXWeapon> WeaponClass;
    local EBioCapMode PowerDamageDiscipline;
    local bool KillerIsPet;
    
    if (BioWorldInfo.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    PlayerPawn = SFXPawn_Player(instigatedBy.Pawn);
    if (PlayerPawn == None)
    {
        PlayerPawn = SFXPawn_Player(instigatedBy.Instigator);
        KillerIsPet = TRUE;
    }
    if (PlayerPawn == None)
    {
        return;
    }
    if (SFXPawn(Killed).bIsPet)
    {
        return;
    }
    IncrementMedalStanding(PlayerPawn, 1);
    if (SFXProjectile(DamageCauser) != None)
    {
        DamageCauser = DamageCauser.Owner;
    }
    if (KillerIsPet)
    {
        IncrementMedalStanding(PlayerPawn, 12);
    }
    else if (SFXWeapon(DamageCauser) != None)
    {
        WeaponClass = SFXWeapon(DamageCauser).Class;
        if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_AssaultRifle_Base'))
        {
            IncrementMedalStanding(PlayerPawn, 5);
        }
        else if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_SniperRifle_Base'))
        {
            IncrementMedalStanding(PlayerPawn, 6);
        }
        else if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_Shotgun_Base'))
        {
            IncrementMedalStanding(PlayerPawn, 7);
        }
        else if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_Pistol_Base'))
        {
            IncrementMedalStanding(PlayerPawn, 8);
        }
        else if (ClassIsChildOf(WeaponClass, Class'SFXWeapon_SMG_Base'))
        {
            IncrementMedalStanding(PlayerPawn, 9);
        }
        else if (ClassIsChildOf(WeaponClass, Class'SFXHeavyWeapon'))
        {
            IncrementMedalStanding(PlayerPawn, 10);
        }
        if (HeadShot)
        {
            IncrementMedalStanding(PlayerPawn, 4);
        }
    }
    else if (DamageType.default.bIsMelee)
    {
        if (ClassIsChildOf(DamageType, Class'SFXDamageType_CoverMelee'))
        {
            IncrementMedalStanding(PlayerPawn, 3);
        }
        IncrementMedalStanding(PlayerPawn, 2);
    }
    else if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power'))
    {
        PowerDamageDiscipline = Class<SFXDamageType_Power>(DamageType).default.Discipline;
        if (PowerDamageDiscipline == EBioCapMode.BIO_CAPMODE_BIOTICS)
        {
            IncrementMedalStanding(PlayerPawn, 11);
        }
        else if (PowerDamageDiscipline == EBioCapMode.BIO_CAPMODE_TECH)
        {
            IncrementMedalStanding(PlayerPawn, 12);
        }
    }
    else if (DamageType.Name == 'SFXDamageType_GraalDamageOverTime')
    {
        IncrementMedalStanding(PlayerPawn, 7);
    }
    UpdateKillStreakTracking(PlayerPawn);
}
public function ShowBonusCreditsEarnedMessage()
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(BioWorldInfo.GetLocalPlayerController());
    if (PC != None)
    {
        Class'SFXGUIInteraction'.static.GetInstance().PlayGuiSound('MPBonusCreditsEarned');
        ClearCustomTokens();
        SetCustomToken(0, string(LastBonusCreditsEarned));
        PC.DisplayTextPopup(string(srBonusCreditsEarned));
        ClearCustomTokens();
    }
}
public function ShowCreditsEarnedMessage()
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(BioWorldInfo.GetLocalPlayerController());
    if (PC != None)
    {
        Class'SFXGUIInteraction'.static.GetInstance().PlayGuiSound('MPCreditsEarned');
        ClearCustomTokens();
        SetCustomToken(0, string(LastCreditsEarned));
        PC.DisplayTextPopup(string(srCreditsEarned));
        ClearCustomTokens();
    }
}
public function UpdateKillStreakTracking(SFXPawn_Player PlayerPawn)
{
    local int i;
    
    for (i = 5 - 1; i > 0; i--)
    {
        KillTimeStamps[i] = KillTimeStamps[i - 1];
    }
    KillTimeStamps[0] = BioWorldInfo.GameTimeSeconds;
    if (KillTimeStamps[0] - KillTimeStamps[5 - 1] <= KillstreakMedalWindow)
    {
        IncrementMedalStanding(PlayerPawn, 18);
        for (i = 0; i < 5; i++)
        {
            KillTimeStamps[i] = 0.0;
        }
    }
}
public final function WaveCompleted()
{
    if (BioWorldInfo.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (!bPlayerDownedInWave)
    {
        IncrementMedalStanding(SFXPawn_Player(BioWorldInfo.GetALocalPlayerController().Pawn), 15);
    }
    else
    {
        ClearSquadMedalStanding(15);
    }
    bPlayerDownedInWave = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DifficultyScoreMultipliers = ({Multiplier = 1.0, Difficulty = EDifficultyOptions.DO_Level1}, 
                                  {Multiplier = 1.20000005, Difficulty = EDifficultyOptions.DO_Level2}, 
                                  {Multiplier = 1.39999998, Difficulty = EDifficultyOptions.DO_Level3}
                                 )
    PlayerMedalDefinitions = ({
                               Icon = "", 
                               MedalName = $0, 
                               Threshold = 0, 
                               Score = 0, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Invalid
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-action_bronze_256x256", 
                               MedalName = $685191, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Kill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-action_silver_256x256", 
                               MedalName = $685191, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Kill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-action_gold_256x256", 
                               MedalName = $685191, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Kill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.close-quarters-combat_bronze_256x256", 
                               MedalName = $685195, 
                               Threshold = 5, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_MeleeKill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.close-quarters-combat_silver_256x256", 
                               MedalName = $685195, 
                               Threshold = 10, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_MeleeKill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.close-quarters-combat_gold_256x256", 
                               MedalName = $685195, 
                               Threshold = 15, 
                               Score = 1500, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_MeleeKill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.headshot_bronze_256x256", 
                               MedalName = $685187, 
                               Threshold = 5, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Headshot
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.headshot_silver_256x256", 
                               MedalName = $685187, 
                               Threshold = 10, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Headshot
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.headshot_gold_256x256", 
                               MedalName = $685187, 
                               Threshold = 20, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Headshot
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assault-rifle_marksman_256x256", 
                               MedalName = $685199, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_AssaultRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assault-rifle_sharpshooter_256x256", 
                               MedalName = $685199, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_AssaultRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assault-rifle_expert_256x256", 
                               MedalName = $685199, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_AssaultRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.sniper-rifle_marksman_256x256", 
                               MedalName = $685211, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_SniperRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.sniper-rifle_sharpshooter_256x256", 
                               MedalName = $685211, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_SniperRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.sniper-rifle_expert_256x256", 
                               MedalName = $685211, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_SniperRifle
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.shotgun_marksman_256x256", 
                               MedalName = $685203, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Shotgun
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.shotgun_sharpshooter_256x256", 
                               MedalName = $685203, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Shotgun
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.shotgun_expert_256x256", 
                               MedalName = $685203, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Shotgun
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.pistol_marksman_256x256", 
                               MedalName = $685207, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Pistol
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.pistol_sharpshooter_256x256", 
                               MedalName = $685207, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Pistol
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.pistol_expert_256x256", 
                               MedalName = $685207, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Pistol
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.smg_marksman_256x256", 
                               MedalName = $685215, 
                               Threshold = 25, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_SMG
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.smg_sharpshooter_256x256", 
                               MedalName = $685215, 
                               Threshold = 50, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_SMG
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.smg_expert_256x256", 
                               MedalName = $685215, 
                               Threshold = 75, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_SMG
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.biotics-mastery_bronze_256x256", 
                               MedalName = $685219, 
                               Threshold = 10, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Biotics
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.biotics-mastery_silver_256x256", 
                               MedalName = $685219, 
                               Threshold = 25, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Biotics
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.biotics-mastery_gold_256x256", 
                               MedalName = $685219, 
                               Threshold = 50, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Biotics
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.tech-mastery_bronze_256x256", 
                               MedalName = $685223, 
                               Threshold = 10, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Tech
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.tech-mastery_silver_256x256", 
                               MedalName = $685223, 
                               Threshold = 25, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Tech
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.tech-mastery_gold_256x256", 
                               MedalName = $685223, 
                               Threshold = 50, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Tech
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-medic_bronze_256x256", 
                               MedalName = $685548, 
                               Threshold = 5, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Revive
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-medic_silver_256x256", 
                               MedalName = $685548, 
                               Threshold = 10, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Revive
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.combat-medic_gold_256x256", 
                               MedalName = $685548, 
                               Threshold = 15, 
                               Score = 2000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Revive
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assist_bronze_256x256", 
                               MedalName = $704421, 
                               Threshold = 10, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_Assist
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assist_silver_256x256", 
                               MedalName = $704421, 
                               Threshold = 25, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Assist
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.assist_gold_256x256", 
                               MedalName = $704421, 
                               Threshold = 50, 
                               Score = 1500, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_Assist
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.cover-grab_bronze_256x256", 
                               MedalName = $704424, 
                               Threshold = 1, 
                               Score = 500, 
                               ReplacesIdx = 0, 
                               Type = MPMedalType.MPMedalType_OverCoverKill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.cover-grab_silver_256x256", 
                               MedalName = $704425, 
                               Threshold = 3, 
                               Score = 1000, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_OverCoverKill
                              }, 
                              {
                               Icon = "GUI_MPImages.Medals.cover-grab_gold_256x256", 
                               MedalName = $704425, 
                               Threshold = 5, 
                               Score = 1500, 
                               ReplacesIdx = -1, 
                               Type = MPMedalType.MPMedalType_OverCoverKill
                              }
                             )
    SquadMedalDefinitions = ({
                              Icon = "", 
                              MedalName = $0, 
                              Threshold = 0, 
                              Score = 0, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Invalid
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.survival_bronze_256x256", 
                              MedalName = $685349, 
                              Threshold = 3, 
                              Score = 2500, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Survival
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.survival_silver_256x256", 
                              MedalName = $685349, 
                              Threshold = 5, 
                              Score = 5000, 
                              ReplacesIdx = -1, 
                              Type = MPMedalType.MPMedalType_Survival
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.survival_gold_256x256", 
                              MedalName = $685349, 
                              Threshold = 10, 
                              Score = 15000, 
                              ReplacesIdx = -1, 
                              Type = MPMedalType.MPMedalType_Survival
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.challenge_bronze_256x256", 
                              MedalName = $685350, 
                              Threshold = 1, 
                              Score = 2500, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_ChallengeLevel
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.challenge_silver_256x256", 
                              MedalName = $685351, 
                              Threshold = 2, 
                              Score = 5000, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_ChallengeLevel
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.challenge_gold_256x256", 
                              MedalName = $685352, 
                              Threshold = 3, 
                              Score = 10000, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_ChallengeLevel
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.extraction_bronze_256x256", 
                              MedalName = $685360, 
                              Threshold = 1, 
                              Score = 2500, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Extraction
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.extraction_silver_256x256", 
                              MedalName = $685361, 
                              Threshold = 2, 
                              Score = 5000, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Extraction
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.extraction_gold_256x256", 
                              MedalName = $685362, 
                              Threshold = 4, 
                              Score = 15000, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Extraction
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.killstreak_1_256x256", 
                              MedalName = $685344, 
                              Threshold = 1, 
                              Score = 2500, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_Killstreak
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.killstreak_2_256x256", 
                              MedalName = $705013, 
                              Threshold = 2, 
                              Score = 5000, 
                              ReplacesIdx = -1, 
                              Type = MPMedalType.MPMedalType_Killstreak
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.killstreak_3_256x256", 
                              MedalName = $705013, 
                              Threshold = 3, 
                              Score = 10000, 
                              ReplacesIdx = -1, 
                              Type = MPMedalType.MPMedalType_Killstreak
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.random-map_256x256", 
                              MedalName = $685356, 
                              Threshold = 1, 
                              Score = 2500, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_RandomMap
                             }, 
                             {
                              Icon = "GUI_MPImages.Medals.random-faction_256x256", 
                              MedalName = $685358, 
                              Threshold = 1, 
                              Score = 5000, 
                              ReplacesIdx = 0, 
                              Type = MPMedalType.MPMedalType_RandomFaction
                             }
                            )
    ScoreMultiplier = 1.0
    srKillScoreTag = $642226
    srAssistScoreTag = $642227
    srObjectiveScoreTag = $642228
    ScorePerExtractedPlayer = 2500.0
    RandomFactionScoreBonus = 0.150000006
    RandomMapScoreBonus = 0.100000001
    KillstreakMedalWindow = 1.0
    srCreditsEarned = $694488
    srBonusCreditsEarned = $722302
}