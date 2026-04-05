Class SFXSaveGame
    native
    transient
    config(Game);

const MaxSaveSize = 1048576;
struct native ME2ImportPowerMapping 
{
    var Name ME2PowerName;
    var Name ME2Evolve1ClassName;
    var Name ME2Evolve2ClassName;
    var Name ME3PowerName;
    var Name ME3PowerClassName;
};
struct native SaveTimeStamp 
{
    var(SaveTimeStamp) int SecondsSinceMidnight;
    var(SaveTimeStamp) int Day;
    var(SaveTimeStamp) int Month;
    var(SaveTimeStamp) int Year;
};
struct native ObjectiveMarkerSaveRecord 
{
    var string MarkerOwnerPath;
    var Vector MarkerOffset;
    var(ObjectiveMarkerSaveRecord) Name BoneToAttachTo;
    var stringref MarkerLabel;
    var EObjectiveMarkerIconType MarkerIconType;
};
struct native PlayerVariableSaveRecord 
{
    var(PlayerVariableSaveRecord) string VariableName;
    var(PlayerVariableSaveRecord) int VariableValue;
};
struct native PlotTableSaveRecord 
{
    struct native PlotCodex 
    {
        struct native PlotCodexPage 
        {
            var(PlotCodexPage) int Page;
            var(PlotCodexPage) bool bNew;
        };
        var(PlotCodex) array<PlotCodexPage> Pages;
    };
    struct native PlotQuest 
    {
        var(PlotQuest) array<int> History;
        var(PlotQuest) int QuestCounter;
        var(PlotQuest) int ActiveGoal;
        var(PlotQuest) bool bQuestUpdated;
    };
    struct native FloatVariablePair 
    {
        var(FloatVariablePair) int Index;
        var(FloatVariablePair) float Value;
    };
    struct native IntVariablePair 
    {
        var(IntVariablePair) int Index;
        var(IntVariablePair) int Value;
    };
    var(PlotTableSaveRecord) array<int> BoolVariables;
    var(PlotTableSaveRecord) array<IntVariablePair> IntVariables;
    var(PlotTableSaveRecord) array<FloatVariablePair> FloatVariables;
    var(PlotTableSaveRecord) array<PlotQuest> QuestProgress;
    var(PlotTableSaveRecord) array<int> QuestIDs;
    var(PlotTableSaveRecord) array<PlotCodex> CodexEntries;
    var(PlotTableSaveRecord) array<int> CodexIDs;
    var(PlotTableSaveRecord) int QuestProgressCounter;
};
struct native HenchmanSaveRecord 
{
    var(HenchmanSaveRecord) array<PowerSaveRecord> Powers;
    var(HenchmanSaveRecord) array<WeaponSaveRecord> Weapons;
    var array<WeaponModSaveRecord> WeaponMods;
    var Name LoadoutWeapons[6];
    var(HenchmanSaveRecord) Name Tag;
    var Name MappedPower;
    var(HenchmanSaveRecord) int CharacterLevel;
    var(HenchmanSaveRecord) int TalentPoints;
    var int Grenades;
};
struct native PlayerSaveRecord 
{
    var(PlayerSaveRecord) AppearanceSaveRecord Appearance;
    var(PlayerSaveRecord) string firstName;
    var(PlayerSaveRecord) array<PowerSaveRecord> Powers;
    var(PlayerSaveRecord) array<WeaponSaveRecord> Weapons;
    var(PlayerSaveRecord) array<GAWAssetSaveInfo> GAWAssets;
    var(PlayerSaveRecord) array<WeaponModSaveRecord> WeaponMods;
    var array<int> LoadoutWeaponGroups;
    var(PlayerSaveRecord) array<HotKeySaveRecord> HotKeys;
    var(PlayerSaveRecord) string faceCode;
    var(PlayerSaveRecord) transient Class<SFXPawn_Player> PlayerClass;
    var Name LoadoutWeapons[6];
    var(PlayerSaveRecord) Guid CharacterGUID;
    var(PlayerSaveRecord) Name PlayerClassName;
    var(PlayerSaveRecord) Name MappedPower1;
    var(PlayerSaveRecord) Name MappedPower2;
    var(PlayerSaveRecord) Name MappedPower3;
    var Name PrimaryWeapon;
    var Name SecondaryWeapon;
    var(PlayerSaveRecord) int srClassFriendlyName;
    var(PlayerSaveRecord) int Level;
    var(PlayerSaveRecord) float CurrentXP;
    var(PlayerSaveRecord) int LastName;
    var(PlayerSaveRecord) int TalentPoints;
    var(PlayerSaveRecord) float CurrentHealth;
    var(PlayerSaveRecord) int Credits;
    var(PlayerSaveRecord) int Medigel;
    var(PlayerSaveRecord) int Grenades;
    var(PlayerSaveRecord) int Eezo;
    var(PlayerSaveRecord) int Iridium;
    var(PlayerSaveRecord) int Palladium;
    var(PlayerSaveRecord) int Platinum;
    var(PlayerSaveRecord) int Probes;
    var(PlayerSaveRecord) float CurrentFuel;
    var(PlayerSaveRecord) bool bIsFemale;
    var(PlayerSaveRecord) bool bCombatPawn;
    var(PlayerSaveRecord) bool bInjuredPawn;
    var(PlayerSaveRecord) bool bUseCasualAppearance;
    var(PlayerSaveRecord) EOriginType Origin;
    var(PlayerSaveRecord) ENotorietyType Notoriety;
};
struct native HotKeySaveRecord 
{
    var(HotKeySaveRecord) Name PawnName;
    var(HotKeySaveRecord) Name PowerName;
};
struct native GAWAssetSaveInfo 
{
    var(GAWAssetSaveInfo) int Id;
    var(GAWAssetSaveInfo) int Strength;
};
struct native PowerSaveRecord 
{
    var(PowerSaveRecord) int EvolvedChoices[6];
    var(PowerSaveRecord) Name PowerName;
    var(PowerSaveRecord) Name PowerClassName;
    var(PowerSaveRecord) float CurrentRank;
    var(PowerSaveRecord) int WheelDisplayIndex;
};
struct native WeaponModSaveRecord 
{
    var(WeaponModSaveRecord) array<Name> WeaponModClassNames;
    var(WeaponModSaveRecord) Name WeaponClassName;
};
struct native WeaponSaveRecord 
{
    var(WeaponSaveRecord) Name WeaponClassName;
    var(WeaponSaveRecord) Name AmmoPowerName;
    var(WeaponSaveRecord) Name AmmoPowerSourceTag;
    var(WeaponSaveRecord) int AmmoUsedCount;
    var(WeaponSaveRecord) int TotalAmmo;
    var(WeaponSaveRecord) bool bLastWeapon;
    var(WeaponSaveRecord) bool bCurrentWeapon;
};
struct native AppearanceSaveRecord 
{
    var(AppearanceSaveRecord) MorphHeadSaveRecord MorphHead;
    var(AppearanceSaveRecord) int CasualID;
    var(AppearanceSaveRecord) int FullBodyID;
    var(AppearanceSaveRecord) int TorsoID;
    var(AppearanceSaveRecord) int ShoulderID;
    var(AppearanceSaveRecord) int ArmID;
    var(AppearanceSaveRecord) int LegID;
    var(AppearanceSaveRecord) int SpecID;
    var(AppearanceSaveRecord) int Tint1ID;
    var(AppearanceSaveRecord) int Tint2ID;
    var(AppearanceSaveRecord) int Tint3ID;
    var(AppearanceSaveRecord) int PatternID;
    var(AppearanceSaveRecord) int PatternColorID;
    var(AppearanceSaveRecord) int HelmetID;
    var(AppearanceSaveRecord) int EmissiveID;
    var(AppearanceSaveRecord) bool bHasMorphHead;
    var(AppearanceSaveRecord) EPlayerAppearanceType CombatAppearance;
};
struct native MorphHeadSaveRecord 
{
    struct native TextureParameterSaveRecord 
    {
        var(TextureParameterSaveRecord) Name Name;
        var(TextureParameterSaveRecord) Name Texture;
    };
    struct native VectorParameterSaveRecord 
    {
        var(VectorParameterSaveRecord) LinearColor Value;
        var(VectorParameterSaveRecord) Name Name;
    };
    struct native ScalarParameterSaveRecord 
    {
        var(ScalarParameterSaveRecord) Name Name;
        var(ScalarParameterSaveRecord) float Value;
    };
    struct native OffsetBoneSaveRecord 
    {
        var(OffsetBoneSaveRecord) Vector Offset;
        var(OffsetBoneSaveRecord) Name Name;
    };
    struct native MorphFeatureSaveRecord 
    {
        var(MorphFeatureSaveRecord) Name Feature;
        var(MorphFeatureSaveRecord) float Offset;
    };
    var(MorphHeadSaveRecord) array<Name> AccessoryMeshes;
    var(MorphHeadSaveRecord) array<MorphFeatureSaveRecord> MorphFeatures;
    var(MorphHeadSaveRecord) array<OffsetBoneSaveRecord> OffsetBones;
    var(MorphHeadSaveRecord) array<Vector> LOD0Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD1Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD2Vertices;
    var(MorphHeadSaveRecord) array<Vector> LOD3Vertices;
    var(MorphHeadSaveRecord) array<ScalarParameterSaveRecord> ScalarParameters;
    var(MorphHeadSaveRecord) array<VectorParameterSaveRecord> VectorParameters;
    var(MorphHeadSaveRecord) array<TextureParameterSaveRecord> TextureParameters;
    var(MorphHeadSaveRecord) Name HairMesh;
};
struct native PlaceableSaveRecord 
{
    var(PlaceableSaveRecord) Guid PlaceableGUID;
    var(PlaceableSaveRecord) byte bIsDestroyed;
    var(PlaceableSaveRecord) byte bIsDeactivated;
};
struct native DoorSaveRecord 
{
    var(DoorSaveRecord) Guid DoorGUID;
    var(DoorSaveRecord) byte CurrentState;
    var(DoorSaveRecord) byte OldState;
};
struct native StreamingStateSaveRecord 
{
    var(StreamingStateSaveRecord) Name Name;
    var(StreamingStateSaveRecord) bool bActive;
};
struct native LevelSaveRecord 
{
    var(LevelSaveRecord) Name LevelName;
    var(LevelSaveRecord) bool bShouldBeLoaded;
    var(LevelSaveRecord) bool bShouldBeVisible;
};
struct native DependentDLCRecord 
{
    var(DependentDLCRecord) init Name Name;
    var(DependentDLCRecord) init Name CanonicalName;
    var(DependentDLCRecord) int ModuleID;
};
struct native GalaxyMapSaveRecord 
{
    struct native SystemSaveRecord 
    {
        var(SystemSaveRecord) int SystemID;
        var(SystemSaveRecord) float fReaperAlertLevel;
        var(SystemSaveRecord) bool bReapersDetected;
    };
    struct native PlanetSaveRecord 
    {
        var(PlanetSaveRecord) array<Vector2D> Probes;
        var(PlanetSaveRecord) int PlanetID;
        var(PlanetSaveRecord) bool bVisited;
        var(PlanetSaveRecord) bool bShowAsScanned;
    };
    var(GalaxyMapSaveRecord) array<PlanetSaveRecord> Planets;
    var(GalaxyMapSaveRecord) array<SystemSaveRecord> Systems;
};
struct native ME1PlotTableRecord 
{
    var(ME1PlotTableRecord) array<int> BoolVariables;
    var(ME1PlotTableRecord) array<int> IntVariables;
    var(ME1PlotTableRecord) array<float> FloatVariables;
};
struct native KismetBoolSaveRecord 
{
    var(KismetBoolSaveRecord) Guid BoolGUID;
    var(KismetBoolSaveRecord) bool bValue;
};
struct native LevelTreasureSaveRecord 
{
    var(LevelTreasureSaveRecord) array<Name> Items;
    var(LevelTreasureSaveRecord) Name LevelName;
    var(LevelTreasureSaveRecord) int nCredits;
    var(LevelTreasureSaveRecord) int nXP;
};
struct native PlayerInfoEx 
{
    var string firstName;
    var string faceCode;
    var Class<SFXPawn_Player> CharacterClass;
    var Guid CharacterGUID;
    var Name BonusTalentClass;
    var BioMorphFace MorphHead;
    var bool bIsFemale;
    var EOriginType Origin;
    var ENotorietyType Notoriety;
};
enum ENotorietyType
{
    NotorietyType_None,
    NotorietyType_Survivor,
    NotorietyType_Warhero,
    NotorietyType_Ruthless,
};
enum EOriginType
{
    OriginType_None,
    OriginType_Spacer,
    OriginType_Colony,
    OriginType_Earthborn,
};
enum EHelmetPart
{
    HelmetPart_Helmet,
    HelmetPart_Visor,
    HelmetPart_Breather,
};
enum EPlayerAppearanceType
{
    PlayerAppearanceType_Parts,
    PlayerAppearanceType_Full,
};
enum EEndGameState
{
    EGS_NotFinished,
    EGS_OutInABlazeOfGlory,
    EGS_LivedToFightAgain,
};

var(SFXSaveGame) PlayerSaveRecord PlayerRecord;
var(SFXSaveGame) PlotTableSaveRecord PlotRecord;
var(SFXSaveGame) ME1PlotTableRecord ME1PlotRecord;
var(SFXSaveGame) GalaxyMapSaveRecord GalaxyMapRecord;
var(SFXSaveGame) init array<DependentDLCRecord> DependentDLC;
var config array<ME2ImportPowerMapping> ME2ImportPowerMappings;
var(SFXSaveGame) transient string Filename;
var(SFXSaveGame) transient string DebugName;
var(SFXSaveGame) array<LevelSaveRecord> LevelRecords;
var(SFXSaveGame) array<StreamingStateSaveRecord> StreamingRecords;
var(SFXSaveGame) array<LevelTreasureSaveRecord> TreasureRecords;
var(SFXSaveGame) array<KismetBoolSaveRecord> KismetRecords;
var(SFXSaveGame) array<DoorSaveRecord> DoorRecords;
var(SFXSaveGame) array<PlaceableSaveRecord> PlaceableRecords;
var(SFXSaveGame) array<Guid> PawnRecords;
var(SFXSaveGame) array<Guid> UseModuleRecords;
var(SFXSaveGame) array<HenchmanSaveRecord> HenchmanRecords;
var(SFXSaveGame) array<PlayerVariableSaveRecord> PlayerVariableRecords;
var(SFXSaveGame) array<ObjectiveMarkerSaveRecord> ObjectiveMarkerRecords;
var(SFXSaveGame) SaveTimeStamp TimeStamp;
var(SFXSaveGame) Vector SaveLocation;
var(SFXSaveGame) Rotator SaveRotation;
var(SFXSaveGame) Name BaseLevelName;
var(SFXSaveGame) Name BaseLevelNameDisplayOverrideAsRead;
var(SFXSaveGame) Name BaseLevelNameDisplayOverrideToWriteAndClear;
var(SFXSaveGame) transient int SerializedSize;
var(SFXSaveGame) transient int FileVersion;
var(SFXSaveGame) float SecondsPlayed;
var(SFXSaveGame) int Disc;
var(SFXSaveGame) int EndGameState;
var(SFXSaveGame) stringref SavedObjectiveText;
var(SFXSaveGame) int CurrentLoadingTip;
var(SFXSaveGame) transient bool bIsValid;
var(SFXSaveGame) EDifficultyOptions Difficulty;
var(SFXSaveGame) EAutoReplyModeOptions ConversationMode;

public native function bool HasME1PlotData();

public final event function LoadHenchman(SFXPawn_Henchman Hench)
{
    local SFXEngine Engine;
    local int idx;
    local SFXInventoryManager InvMan;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    idx = Engine.HenchmanRecords.Find('Tag', Hench.Tag);
    if (idx >= 0)
    {
        Hench.TalentPoints = Engine.HenchmanRecords[idx].TalentPoints;
        Hench.CharacterLevel = Engine.HenchmanRecords[idx].CharacterLevel;
        Hench.CreateWeapons(Hench.Loadout);
        Hench.m_nmMappedPower = Engine.HenchmanRecords[idx].MappedPower;
        InvMan = SFXInventoryManager(Hench.InvManager);
        if (InvMan != None)
        {
            InvMan.Grenades = Engine.HenchmanRecords[idx].Grenades;
        }
    }
}
public final event function LoadPlayer(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXPawn_Player Player;
    local SFXInventoryManager InvMan;
    local SFXEngine Engine;
    local BioPlayerInput Input;
    local bool bPlayerLoadedDueToLoadGame;
    local int idx;
    local SFXModule_Damage DmgMod;
    local array<TelemetryAttribute> Attributes;
    
    bPlayerLoadedDueToLoadGame = FALSE;
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Engine = SFXEngine(Outer);
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            Engine = SFXEngine(Outer);
            if (Engine != None && Engine.bPlayerLoadPosition)
            {
                bPlayerLoadedDueToLoadGame = TRUE;
                Player.bCollideWorld = FALSE;
                Player.SetLocation(SaveLocation + vect(0.0, 0.0, 2.0), );
                Player.bCollideWorld = TRUE;
                Player.SetRotation(SaveRotation);
                Player.Controller.SetRotation(SaveRotation);
                Engine.bPlayerLoadPosition = FALSE;
            }
            Player.CharacterLevel = PlayerRecord.Level;
            Player.TotalXP = PlayerRecord.CurrentXP;
            Player.firstName = PlayerRecord.firstName;
            Player.Origin = PlayerRecord.Origin;
            Player.Notoriety = PlayerRecord.Notoriety;
            Player.TalentPoints = PlayerRecord.TalentPoints;
            Player.faceCode = PlayerRecord.faceCode;
            Player.CharacterGUID = PlayerRecord.CharacterGUID;
            for (idx = 0; idx < 6; idx++)
            {
                Engine.PlayerLoadoutWeapons[idx] = PlayerRecord.LoadoutWeapons[idx];
            }
            Engine.PlayerLoadoutGroups.Length = 0;
            for (idx = 0; idx < PlayerRecord.LoadoutWeaponGroups.Length; idx++)
            {
                Engine.PlayerLoadoutGroups.AddItem(byte(PlayerRecord.LoadoutWeaponGroups[idx]));
            }
            Engine.PlayerWeaponMods.Length = 0;
            for (idx = 0; idx < PlayerRecord.WeaponMods.Length; idx++)
            {
                Engine.PlayerWeaponMods.AddItem(PlayerRecord.WeaponMods[idx]);
            }
            if (PlayerController(Player.Controller) != None)
            {
                Input = BioPlayerInput(PlayerController(Player.Controller).PlayerInput);
                if (Input != None)
                {
                    Input.m_nmMappedPower = PlayerRecord.MappedPower1;
                    Input.m_nmMappedPower2 = PlayerRecord.MappedPower2;
                    Input.m_nmMappedPower3 = PlayerRecord.MappedPower3;
                }
            }
            LoadAppearance(Player, PlayerRecord.Appearance);
            if (BioPlayerController(Player.Controller) != None)
            {
                LoadHotKeys(BioPlayerController(Player.Controller), PlayerRecord.HotKeys);
            }
            DmgMod = Player.GetModule(Class'SFXModule_Damage');
            if (DmgMod != None && PlayerRecord.CurrentHealth > float(0))
            {
                DmgMod.SetPlayerHealthFromSave(PlayerRecord.CurrentHealth);
            }
            InvMan = SFXInventoryManager(Player.InvManager);
            if (InvMan != None)
            {
                InvMan.Credits = PlayerRecord.Credits;
                InvMan.Medigel = PlayerRecord.Medigel;
                InvMan.Eezo = PlayerRecord.Eezo;
                InvMan.Iridium = PlayerRecord.Iridium;
                InvMan.Palladium = PlayerRecord.Palladium;
                InvMan.Platinum = PlayerRecord.Platinum;
                InvMan.Probes = PlayerRecord.Probes;
                InvMan.CurrentFuel = PlayerRecord.CurrentFuel;
                InvMan.Grenades = PlayerRecord.Grenades;
            }
            LoadGAWAssets(Player, PlayerRecord.GAWAssets);
            if (bPlayerLoadedDueToLoadGame)
            {
                Class'SFXTelemetry'.static.AddAttributeToArray(Attributes, 2, "cdur", , int(SecondsPlayed));
                Class'SFXTelemetry'.static.AddAttributeToArray(Attributes, 2, "diff", , int(Difficulty));
                Class'SFXTelemetry'.static.SendArray('TelemetryHook_LoadGame', Attributes);
            }
            Player.PrimaryWeapon = PlayerRecord.PrimaryWeapon;
            Player.SecondaryWeapon = PlayerRecord.SecondaryWeapon;
        }
    }
}
public final event function LoadPlayerWeapons(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXPawn_Player Player;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            LoadWeapons(Player, PlayerRecord.Weapons);
            LoadWeaponMods(Player, PlayerRecord.WeaponMods);
        }
    }
}
public final event function SaveHenchmen(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXPawn_Player Player;
    local SFXEngine Engine;
    local BioBaseSquad Squad;
    local int idx;
    local int HenchIdx;
    local SFXPawn_Henchman Hench;
    local HenchmanSaveRecord SaveInfo;
    local array<PowerSaveRecord> Powers;
    local array<WeaponSaveRecord> Weapons;
    local SFXInventoryManager InvMan;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            HenchmanRecords = Engine.HenchmanRecords;
            Squad = Player.Squad;
            if (Squad != None)
            {
                for (idx = 0; idx < Squad.Members.Length; idx++)
                {
                    Hench = SFXPawn_Henchman(Squad.Members[idx]);
                    if (Hench != None)
                    {
                        HenchIdx = HenchmanRecords.Find('Tag', Hench.Tag);
                        if (HenchIdx != -1)
                        {
                            Powers = HenchmanRecords[HenchIdx].Powers;
                            SavePowers(Hench, Powers);
                            HenchmanRecords[HenchIdx].Powers = Powers;
                            Weapons.Length = 0;
                            SaveWeapons(Hench, Weapons);
                            HenchmanRecords[HenchIdx].Weapons = Weapons;
                            HenchmanRecords[HenchIdx].TalentPoints = Hench.TalentPoints;
                            HenchmanRecords[HenchIdx].CharacterLevel = Hench.CharacterLevel;
                            HenchmanRecords[HenchIdx].MappedPower = Hench.m_nmMappedPower;
                            InvMan = SFXInventoryManager(Hench.InvManager);
                            if (InvMan != None)
                            {
                                HenchmanRecords[HenchIdx].Grenades = InvMan.Grenades;
                            }
                            continue;
                        }
                        SaveInfo.Tag = Hench.Tag;
                        SavePowers(Hench, SaveInfo.Powers);
                        SaveWeapons(Hench, SaveInfo.Weapons);
                        SaveInfo.TalentPoints = Hench.TalentPoints;
                        SaveInfo.CharacterLevel = Hench.CharacterLevel;
                        Class'SFXPawn_Henchman'.static.GetDefaultLoadout(Hench.Tag, SaveInfo.LoadoutWeapons);
                        SaveInfo.MappedPower = Hench.m_nmMappedPower;
                        InvMan = SFXInventoryManager(Hench.InvManager);
                        if (InvMan != None)
                        {
                            SaveInfo.Grenades = InvMan.Grenades;
                        }
                        HenchmanRecords.AddItem(SaveInfo);
                    }
                }
            }
            Engine.HenchmanRecords = HenchmanRecords;
        }
    }
}
public final event function SavePlayer(int PlayerID)
{
    local WorldInfo WorldInfo;
    local SFXGame Game;
    local SFXEngine Engine;
    local SFXPawn_Player Player;
    local SFXInventoryManager InvMan;
    local BioPlayerInput Input;
    local int idx;
    local Class<SFXPawn_Player> PlayerClass;
    local SFXModule_Damage DmgMod;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        Engine = SFXEngine(Outer);
        Game = SFXGame(WorldInfo.Game);
        Player = Game != None ? Game.GetPlayer(PlayerID) : None;
        if (Player != None)
        {
            SaveLocation = Player.location;
            if (Player.bIsCrouched)
            {
                SaveLocation.Z += Class'SFXPawn_Player'.default.CylinderComponent.CollisionHeight - Player.CylinderComponent.CollisionHeight;
            }
            SaveRotation = Player.Rotation;
            PlayerRecord.bIsFemale = Player.bIsFemale;
            PlayerRecord.bCombatPawn = Player.bCombatPawn;
            PlayerRecord.bInjuredPawn = Player.bInjuredPawn;
            PlayerClass = Player.Class;
            PlayerRecord.bUseCasualAppearance = Player.bUseCasualAppearance;
            PlayerRecord.PlayerClassName = Name(PathName(PlayerClass));
            PlayerRecord.PlayerClass = PlayerClass;
            PlayerRecord.srClassFriendlyName = Player.PlayerClass.srClassName;
            PlayerRecord.Level = Player.CharacterLevel;
            PlayerRecord.CurrentXP = Player.TotalXP;
            PlayerRecord.firstName = Player.firstName;
            PlayerRecord.LastName = int(Class'SFXPawn_Player'.static.GetLastNameStringRef());
            PlayerRecord.Origin = Player.Origin;
            PlayerRecord.Notoriety = Player.Notoriety;
            PlayerRecord.TalentPoints = Player.TalentPoints;
            PlayerRecord.faceCode = Player.faceCode;
            PlayerRecord.CharacterGUID = Player.CharacterGUID;
            for (idx = 0; idx < 6; idx++)
            {
                PlayerRecord.LoadoutWeapons[idx] = Engine.PlayerLoadoutWeapons[idx];
            }
            PlayerRecord.LoadoutWeaponGroups.Length = 0;
            for (idx = 0; idx < Engine.PlayerLoadoutGroups.Length; idx++)
            {
                PlayerRecord.LoadoutWeaponGroups.AddItem(int(Engine.PlayerLoadoutGroups[idx]));
            }
            PlayerRecord.WeaponMods.Length = 0;
            for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
            {
                PlayerRecord.WeaponMods.AddItem(Engine.PlayerWeaponMods[idx]);
            }
            if (PlayerController(Player.Controller) != None)
            {
                Input = BioPlayerInput(PlayerController(Player.Controller).PlayerInput);
                if (Input != None)
                {
                    PlayerRecord.MappedPower1 = Input.m_nmMappedPower;
                    PlayerRecord.MappedPower2 = Input.m_nmMappedPower2;
                    PlayerRecord.MappedPower3 = Input.m_nmMappedPower3;
                }
            }
            SaveAppearance(Player, PlayerRecord.Appearance);
            SavePowers(Player, PlayerRecord.Powers);
            SaveWeapons(Player, PlayerRecord.Weapons);
            SaveGAWAssets(Player, PlayerRecord.GAWAssets);
            if (BioPlayerController(Player.Controller) != None)
            {
                SaveHotKeys(BioPlayerController(Player.Controller), PlayerRecord.HotKeys);
            }
            SaveTreasure();
            DmgMod = Player.GetModule(Class'SFXModule_Damage');
            if (DmgMod != None)
            {
                PlayerRecord.CurrentHealth = DmgMod.GetCurrentHealth();
            }
            InvMan = SFXInventoryManager(Player.InvManager);
            if (InvMan != None)
            {
                PlayerRecord.Credits = InvMan.Credits;
                PlayerRecord.Medigel = InvMan.Medigel;
                PlayerRecord.Eezo = InvMan.Eezo;
                PlayerRecord.Iridium = InvMan.Iridium;
                PlayerRecord.Palladium = InvMan.Palladium;
                PlayerRecord.Platinum = InvMan.Platinum;
                PlayerRecord.Probes = InvMan.Probes;
                PlayerRecord.CurrentFuel = InvMan.CurrentFuel;
                PlayerRecord.Grenades = InvMan.Grenades;
            }
            PlayerRecord.PrimaryWeapon = Player.PrimaryWeapon;
            PlayerRecord.SecondaryWeapon = Player.SecondaryWeapon;
        }
    }
}
public final event function SaveTreasure()
{
    local SFXEngine oEngine;
    local int idx;
    
    oEngine = SFXEngine(Outer);
    if (oEngine == None)
    {
        return;
    }
    TreasureRecords.Length = 0;
    for (idx = 0; idx < oEngine.SavedTreasure.Length; idx++)
    {
        TreasureRecords.AddItem(oEngine.SavedTreasure[idx]);
    }
}
public final function EnsureHenchmanRecordExists(SFXPawn_Henchman Hench)
{
    local int HenchIdx;
    local HenchmanSaveRecord SaveInfo;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer);
    if (Engine == None)
    {
        return;
    }
    HenchIdx = Engine.HenchmanRecords.Find('Tag', Hench.Tag);
    if (HenchIdx == -1)
    {
        SaveInfo.Tag = Hench.Tag;
        SavePowers(Hench, SaveInfo.Powers);
        SaveInfo.TalentPoints = Hench.TalentPoints;
        SaveInfo.CharacterLevel = Hench.CharacterLevel;
        Class'SFXPawn_Henchman'.static.GetDefaultLoadout(Hench.Tag, SaveInfo.LoadoutWeapons);
        SaveInfo.MappedPower = Hench.m_nmMappedPower;
        Engine.HenchmanRecords.AddItem(SaveInfo);
    }
}
public final function bool GetPlayerRecord(out PlayerSaveRecord Record)
{
    Record = PlayerRecord;
    return TRUE;
}
public final function GetSpawnData(out int IsFemale, out Class<SFXPawn_Player> CharacterClass, out string firstName, out EOriginType Origin, out ENotorietyType Notoriety, out int CombatPawn, out int InjuredPawn, out int CasualAppearance)
{
    IsFemale = int(PlayerRecord.bIsFemale);
    CharacterClass = PlayerRecord.PlayerClass;
    firstName = PlayerRecord.firstName;
    Origin = PlayerRecord.Origin;
    Notoriety = PlayerRecord.Notoriety;
    CombatPawn = PlayerRecord.bCombatPawn ? 1 : 0;
    InjuredPawn = PlayerRecord.bInjuredPawn ? 1 : 0;
    CasualAppearance = PlayerRecord.bUseCasualAppearance ? 1 : 0;
}
public final function int LoadAmmo(SFXPawn_Player Player, SFXWeapon Weapon, WeaponSaveRecord Record)
{
    if (Record.AmmoUsedCount <= Weapon.GetMagazineSize())
    {
        Weapon.AmmoUsedCount = Record.AmmoUsedCount;
    }
    else
    {
        Weapon.AmmoUsedCount = Weapon.GetMagazineSize();
    }
    Weapon.CurrentSpareAmmo = Record.TotalAmmo;
    if (Record.bLastWeapon)
    {
        Player.WeaponOnDeck = Weapon;
    }
    Weapon.AmmoPowerName = Record.AmmoPowerName;
    Weapon.AmmoPowerSourceTag = Record.AmmoPowerSourceTag;
    if (Record.bCurrentWeapon)
    {
        SFXInventoryManager(Player.InvManager).CurrentWeaponSelection = Weapon.Class;
        return 1;
    }
    return 0;
}
public final function LoadAppearance(SFXPawn_Player Player, out AppearanceSaveRecord Record)
{
    Player.CombatAppearance = Record.CombatAppearance;
    Player.CasualID = Record.CasualID;
    Player.FullBodyID = Record.FullBodyID;
    Player.TorsoID = Record.TorsoID;
    Player.ShoulderID = Record.ShoulderID;
    Player.ArmID = Record.ArmID;
    Player.LegID = Record.LegID;
    Player.SpecID = Record.SpecID;
    Player.Tint1ID = Record.Tint1ID;
    Player.Tint2ID = Record.Tint2ID;
    Player.PatternID = Record.PatternID;
    Player.PatternColorID = Record.PatternColorID;
    Player.HelmetID = Record.HelmetID;
    Player.EmissiveID = Record.EmissiveID;
    if (Record.bHasMorphHead)
    {
        LoadMorphHead(Player);
    }
}
public final function LoadGAWAssets(SFXPawn Pawn, out array<GAWAssetSaveInfo> records)
{
    local GAWAssetSaveInfo GAWAsset;
    local BioWorldInfo MyWorldInfo;
    local SFXGAWAssetsHandler GAWHandler;
    
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return;
    }
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UnlockedGAWAssets.Length = 0;
    foreach records(GAWAsset, )
    {
        GAWHandler.UnlockedGAWAssets.AddItem(GAWAsset);
    }
}
public final function LoadHotKeys(BioPlayerController PC, out array<HotKeySaveRecord> records)
{
    local int idx;
    
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        for (idx = 0; idx < 8 && idx < records.Length; idx++)
        {
            PC.m_aHotKeyDefines[idx].nmPawn = records[idx].PawnName;
            PC.m_aHotKeyDefines[idx].nmPower = records[idx].PowerName;
        }
    }
}
public final function LoadMorphHead(SFXPawn_Player InPlayer)
{
    if (PlayerRecord.Appearance.bHasMorphHead)
    {
        InPlayer.EnqueueMorphHeadForLoad(PlayerRecord.Appearance.MorphHead);
    }
}
public final function LoadPawnPowers(BioPawn Pawn)
{
    local SFXPawn_Player Player;
    local SFXPawn_Henchman Henchman;
    local int idx;
    local array<PowerSaveRecord> PowerRecords;
    local SFXEngine Engine;
    
    Player = SFXPawn_Player(Pawn);
    if (Player != None)
    {
        LoadPowers(Player, PlayerRecord.Powers);
    }
    else
    {
        Henchman = SFXPawn_Henchman(Pawn);
        if (Henchman != None)
        {
            Engine = SFXEngine(Outer);
            if (Engine == None)
            {
                return;
            }
            idx = Engine.HenchmanRecords.Find('Tag', Henchman.Tag);
            if (idx >= 0)
            {
                PowerRecords = HenchmanRecords[idx].Powers;
                LoadPowers(Henchman, PowerRecords);
            }
        }
    }
}
public final function LoadPowers(SFXPawn Pawn, out array<PowerSaveRecord> records)
{
    local array<PowerSaveInfo> Powers;
    local int idx;
    local int Idx2;
    local SFXPowerManager PowerMan;
    local SFXEngine Engine;
    local SFXProfileSettings Profile;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        Powers.Length = records.Length;
        for (idx = 0; idx < records.Length; idx++)
        {
            Powers[idx].PowerName = records[idx].PowerName;
            Powers[idx].CurrentRank = records[idx].CurrentRank;
            for (Idx2 = 0; Idx2 < 6; Idx2++)
            {
                Powers[idx].EvolvedChoices[Idx2] = records[idx].EvolvedChoices[Idx2];
            }
            Powers[idx].PowerClassName = records[idx].PowerClassName;
            Powers[idx].WheelDisplayIndex = records[idx].WheelDisplayIndex;
        }
        PowerMan.LoadPowers(Powers);
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    Profile = Engine.GetProfileSettings();
    if (Profile == None)
    {
        return;
    }
    Profile.UpdateBonusPowerPlotStates();
}
public final function LoadWeaponMods(SFXPawn_Player Player, out array<WeaponModSaveRecord> records)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local int idx;
    local SFXModule_WeaponModManager Manager;
    local Class<SFXWeaponMod> ModClass;
    local Name ModClassName;
    local int ModLevel;
    
    InvManager = SFXInventoryManager(Player.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            idx = records.Find('WeaponClassName', Name(PathName(Weapon.Class)));
            if (idx != -1)
            {
                Manager = Weapon.GetModule(Class'SFXModule_WeaponModManager');
                if (Manager != None)
                {
                    Manager.RemoveAllMods();
                    foreach records[idx].WeaponModClassNames(ModClassName, )
                    {
                        ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(ModClassName));
                        if (ModClass != None && ModClass.static.IsUnlocked(ModLevel))
                        {
                            Manager.AddMod(ModClass, ModLevel);
                        }
                    }
                }
            }
        }
    }
}
public final function LoadWeapons(SFXPawn_Player Player, out array<WeaponSaveRecord> records)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local int idx;
    local int CurrentWeaponNumber;
    
    CurrentWeaponNumber = 0;
    InvManager = SFXInventoryManager(Player.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            idx = records.Find('WeaponClassName', Weapon.Class.Name);
            if (idx != -1)
            {
                CurrentWeaponNumber += LoadAmmo(Player, Weapon, records[idx]);
            }
        }
    }
    if (CurrentWeaponNumber == 0)
    {
        LoadWeaponsNotInInventory(Player, Weapon, records);
    }
}
public final function LoadWeaponsNotInInventory(SFXPawn_Player Player, SFXWeapon Weapon, out array<WeaponSaveRecord> records)
{
    local SFXEngine Engine;
    local WeaponSaveRecord Record;
    local Class<SFXWeapon> WeaponClass;
    
    foreach records(Record, )
    {
        if (Record.bCurrentWeapon == TRUE)
        {
            Engine = Class'SFXEngine'.static.GetSFXEngine();
            if (Engine != None)
            {
                WeaponClass = Class<SFXWeapon>(Engine.GetSeekFreeObject("SFXGameContent." $ Record.WeaponClassName, Class'Class'));
                if (WeaponClass != None)
                {
                    Weapon = Player.Spawn(WeaponClass);
                    Player.GiveWeaponToPlayer(Weapon);
                    LoadAmmo(Player, Weapon, Record);
                }
            }
        }
    }
}
public final function SaveAppearance(SFXPawn_Player Player, out AppearanceSaveRecord Record)
{
    Record.CombatAppearance = Player.CombatAppearance;
    Record.CasualID = Player.CasualID;
    Record.FullBodyID = Player.FullBodyID;
    Record.TorsoID = Player.TorsoID;
    Record.ShoulderID = Player.ShoulderID;
    Record.ArmID = Player.ArmID;
    Record.LegID = Player.LegID;
    Record.SpecID = Player.SpecID;
    Record.Tint1ID = Player.Tint1ID;
    Record.Tint2ID = Player.Tint2ID;
    Record.Tint3ID = 0;
    Record.PatternID = Player.PatternID;
    Record.PatternColorID = Player.PatternColorID;
    Record.HelmetID = Player.HelmetID;
    Record.EmissiveID = Player.EmissiveID;
    Record.bHasMorphHead = FALSE;
    if (SaveMorphHead(Player.MorphHead, Record.MorphHead))
    {
        Record.bHasMorphHead = TRUE;
    }
}
public final function SaveGAWAssets(SFXPawn_Player Pawn, out array<GAWAssetSaveInfo> records)
{
    local GAWAssetSaveInfo GAWAsset;
    local BioWorldInfo MyWorldInfo;
    local SFXGAWAssetsHandler GAWHandler;
    
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return;
    }
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    records.Length = 0;
    foreach GAWHandler.UnlockedGAWAssets(GAWAsset, )
    {
        records.AddItem(GAWAsset);
    }
}
public final function SaveHotKeys(BioPlayerController PC, out array<HotKeySaveRecord> records)
{
    local int idx;
    
    if (!Class'WorldInfo'.static.IsConsoleBuild())
    {
        records.Length = 8;
        for (idx = 0; idx < 8; idx++)
        {
            records[idx].PawnName = PC.m_aHotKeyDefines[idx].nmPawn;
            records[idx].PowerName = PC.m_aHotKeyDefines[idx].nmPower;
        }
    }
}
public final function bool SaveMorphHead(BioMorphFace Morph, out MorphHeadSaveRecord Record)
{
    local int idx;
    local BioMaterialOverride MatOverride;
    
    if (Morph != None)
    {
        Record.HairMesh = Name(PathName(Morph.m_oHairMesh));
        Record.AccessoryMeshes.Length = Morph.m_oOtherMeshes.Length;
        for (idx = 0; idx < Morph.m_oOtherMeshes.Length; idx++)
        {
            Record.AccessoryMeshes[idx] = Name(PathName(Morph.m_oOtherMeshes[idx]));
        }
        Record.MorphFeatures.Length = Morph.m_aMorphFeatures.Length;
        for (idx = 0; idx < Morph.m_aMorphFeatures.Length; idx++)
        {
            Record.MorphFeatures[idx].Feature = Morph.m_aMorphFeatures[idx].sFeatureName;
            Record.MorphFeatures[idx].Offset = Morph.m_aMorphFeatures[idx].Offset;
        }
        Record.OffsetBones.Length = Morph.m_aFinalSkeleton.Length;
        for (idx = 0; idx < Morph.m_aFinalSkeleton.Length; idx++)
        {
            Record.OffsetBones[idx].Name = Morph.m_aFinalSkeleton[idx].nName;
            Record.OffsetBones[idx].Offset = Morph.m_aFinalSkeleton[idx].vPos;
        }
        Record.LOD0Vertices.Length = Morph.GetNumVerts(0);
        for (idx = 0; idx < Morph.GetNumVerts(0); idx++)
        {
            Record.LOD0Vertices[idx] = Morph.GetPosition(0, idx);
        }
        MatOverride = Morph.m_oMaterialOverrides;
        if (MatOverride != None)
        {
            Record.ScalarParameters.Length = MatOverride.m_aScalarOverrides.Length;
            for (idx = 0; idx < MatOverride.m_aScalarOverrides.Length; idx++)
            {
                Record.ScalarParameters[idx].Name = MatOverride.m_aScalarOverrides[idx].nName;
                Record.ScalarParameters[idx].Value = MatOverride.m_aScalarOverrides[idx].sValue;
            }
            Record.VectorParameters.Length = MatOverride.m_aColorOverrides.Length;
            for (idx = 0; idx < MatOverride.m_aColorOverrides.Length; idx++)
            {
                Record.VectorParameters[idx].Name = MatOverride.m_aColorOverrides[idx].nName;
                Record.VectorParameters[idx].Value = MatOverride.m_aColorOverrides[idx].cValue;
            }
            Record.TextureParameters.Length = MatOverride.m_aTextureOverrides.Length;
            for (idx = 0; idx < MatOverride.m_aTextureOverrides.Length; idx++)
            {
                Record.TextureParameters[idx].Name = MatOverride.m_aTextureOverrides[idx].nName;
                Record.TextureParameters[idx].Texture = Name(PathName(MatOverride.m_aTextureOverrides[idx].m_pTexture));
            }
        }
        return TRUE;
    }
    return FALSE;
}
public final function SavePowers(SFXPawn Pawn, out array<PowerSaveRecord> records)
{
    local array<PowerSaveInfo> Powers;
    local int idx;
    local int Idx2;
    local SFXPowerManager PowerMan;
    local SFXEngine Engine;
    local SFXProfileSettings Profile;
    
    PowerMan = Pawn.PowerManager;
    if (PowerMan != None)
    {
        PowerMan.SavePowers(Powers);
        records.Length = Powers.Length;
        for (idx = 0; idx < Powers.Length; idx++)
        {
            records[idx].PowerName = Powers[idx].PowerName;
            records[idx].CurrentRank = Powers[idx].CurrentRank;
            for (Idx2 = 0; Idx2 < 6; Idx2++)
            {
                records[idx].EvolvedChoices[Idx2] = Powers[idx].EvolvedChoices[Idx2];
            }
            records[idx].PowerClassName = Powers[idx].PowerClassName;
            records[idx].WheelDisplayIndex = Powers[idx].WheelDisplayIndex;
        }
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    Profile = Engine.GetProfileSettings();
    if (Profile == None)
    {
        return;
    }
    Profile.UpdateBonusPowerProfileSettings();
}
public final function SaveWeapons(SFXPawn Pawn, out array<WeaponSaveRecord> records)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local WeaponSaveRecord SaveInfo;
    
    InvManager = SFXInventoryManager(Pawn.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            SaveInfo.WeaponClassName = Weapon.Class.Name;
            SaveInfo.AmmoUsedCount = Weapon.AmmoUsedCount;
            SaveInfo.TotalAmmo = Weapon.GetCurrentSpareAmmo();
            SaveInfo.bLastWeapon = FALSE;
            if (Pawn.WeaponOnDeck == Weapon)
            {
                SaveInfo.bLastWeapon = TRUE;
            }
            SaveInfo.bCurrentWeapon = FALSE;
            if (InvManager.CurrentWeaponSelection == Weapon.Class)
            {
                SaveInfo.bCurrentWeapon = TRUE;
            }
            SaveInfo.AmmoPowerName = Weapon.AmmoPowerName;
            SaveInfo.AmmoPowerSourceTag = Weapon.AmmoPowerSourceTag;
            records.AddItem(SaveInfo);
        }
    }
}
public final function UpdatePlayerSaveRecord(PlayerInfoEx PlayerInfo)
{
    PlayerRecord.bIsFemale = PlayerInfo.bIsFemale;
    PlayerRecord.PlayerClass = PlayerInfo.CharacterClass;
    PlayerRecord.CharacterGUID = PlayerInfo.CharacterGUID;
    PlayerRecord.faceCode = PlayerInfo.faceCode;
    PlayerRecord.firstName = PlayerInfo.firstName;
    PlayerRecord.Notoriety = PlayerInfo.Notoriety;
    PlayerRecord.Origin = PlayerInfo.Origin;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ME2ImportPowerMappings = ({ME2PowerName = 'AdeptPassive', ME2Evolve1ClassName = 'SFXPower_AdeptPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_AdeptPassive_Evolved2', ME3PowerName = 'AdeptPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_AdeptPassive'}, 
                              {ME2PowerName = 'AdrenalineRush', ME2Evolve1ClassName = 'SFXPower_AdrenalineRush_Evolved1', ME2Evolve2ClassName = 'SFXPower_AdrenalineRush_Evolved2', ME3PowerName = 'AdrenalineRush', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_AdrenalineRush'}, 
                              {ME2PowerName = 'AIHacking', ME2Evolve1ClassName = 'SFXPower_AIHacking_Heavy', ME2Evolve2ClassName = 'SFXPower_AIHacking_Radius', ME3PowerName = 'AIHacking', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_AIHacking'}, 
                              {ME2PowerName = 'Charge', ME2Evolve1ClassName = 'SFXPower_BioticCharge_Slam', ME2Evolve2ClassName = 'SFXPower_BioticCharge_Radius', ME3PowerName = 'BioticCharge', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_BioticCharge'}, 
                              {ME2PowerName = 'Cloak', ME2Evolve1ClassName = 'SFXPower_Cloak_Enhanced', ME2Evolve2ClassName = 'SFXPower_Cloak_Damage', ME3PowerName = 'Cloak', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Cloak'}, 
                              {ME2PowerName = 'CombatDrone', ME2Evolve1ClassName = 'SFXPower_CombatDrone_Rocket', ME2Evolve2ClassName = 'SFXPower_CombatDrone_Tech', ME3PowerName = 'CombatDrone', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_CombatDrone'}, 
                              {ME2PowerName = 'ConcussiveShot', ME2Evolve1ClassName = 'SFXPower_ConcussiveShot_Heavy', ME2Evolve2ClassName = 'SFXPower_ConcussiveShot_Radius', ME3PowerName = 'ConcussiveShot', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_ConcussiveShot'}, 
                              {ME2PowerName = 'CryoAmmo', ME2Evolve1ClassName = 'SFXPower_CryoAmmo_Evolved1', ME2Evolve2ClassName = 'SFXPower_CryoAmmo_Evolved2', ME3PowerName = 'CryoAmmo', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_CryoAmmo'}, 
                              {ME2PowerName = 'CryoFreeze', ME2Evolve1ClassName = 'SFXPower_CryoFreeze_Evolved1', ME2Evolve2ClassName = 'SFXPower_CryoFreeze_Evolved2', ME3PowerName = 'CryoBlast', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_CryoBlast'}, 
                              {ME2PowerName = 'DisruptorAmmo', ME2Evolve1ClassName = 'SFXPower_DisruptorAmmo_Heavy', ME2Evolve2ClassName = 'SFXPower_DisruptorAmmo_Squad', ME3PowerName = 'DisruptorAmmo', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_DisruptorAmmo'}, 
                              {ME2PowerName = 'EngineerPassive', ME2Evolve1ClassName = 'SFXPower_EngineerPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_EngineerPassive_Evolved2', ME3PowerName = 'EngineerPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_EngineerPassive'}, 
                              {ME2PowerName = 'IncendiaryAmmo', ME2Evolve1ClassName = 'SFXPower_IncendiaryAmmo_Radius', ME2Evolve2ClassName = 'SFXPower_IncendiaryAmmo_Squad', ME3PowerName = 'IncendiaryAmmo', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_IncendiaryAmmo'}, 
                              {ME2PowerName = 'Incinerate', ME2Evolve1ClassName = 'SFXPower_Incinerate_Heavy', ME2Evolve2ClassName = 'SFXPower_Incinerate_Radius', ME3PowerName = 'Incinerate', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Incinerate'}, 
                              {ME2PowerName = 'InfiltratorPassive', ME2Evolve1ClassName = 'SFXPower_InfiltratorPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_InfiltratorPassive_Evolved2', ME3PowerName = 'InfiltratorPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_InfiltratorPassive'}, 
                              {ME2PowerName = 'Overload', ME2Evolve1ClassName = 'SFXPower_Overload_Heavy', ME2Evolve2ClassName = 'SFXPower_Overload_Radius', ME3PowerName = 'Overload', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Overload'}, 
                              {ME2PowerName = 'PullProjectile', ME2Evolve1ClassName = 'SFXPower_PullProjectile_Heavy', ME2Evolve2ClassName = 'SFXPower_PullProjectile_Radius', ME3PowerName = 'Pull', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Pull'}, 
                              {ME2PowerName = 'SentinelPassive', ME2Evolve1ClassName = 'SFXPower_SentinelPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_SentinelPassive_Evolved2', ME3PowerName = 'SentinelPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_SentinelPassive'}, 
                              {ME2PowerName = 'Shockwave', ME2Evolve1ClassName = 'SFXPower_Shockwave_Evolved1', ME2Evolve2ClassName = 'SFXPower_Shockwave_Evolved2', ME3PowerName = 'Shockwave', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Shockwave'}, 
                              {ME2PowerName = 'Singularity', ME2Evolve1ClassName = 'SFXPower_Singularity_Heavy', ME2Evolve2ClassName = 'SFXPower_Singularity_Radius', ME3PowerName = 'Singularity', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Singularity'}, 
                              {ME2PowerName = 'SoldierPassive', ME2Evolve1ClassName = 'SFXPower_SoldierPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_SoldierPassive_Evolved2', ME3PowerName = 'SoldierPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_SoldierPassive'}, 
                              {ME2PowerName = 'PowerArmor', ME2Evolve1ClassName = 'SFXPower_PowerArmor_Evolved1', ME2Evolve2ClassName = 'SFXPower_PowerArmor_Evolved2', ME3PowerName = 'TechArmor', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_TechArmor'}, 
                              {ME2PowerName = 'ThrowProjectile', ME2Evolve1ClassName = 'SFXPower_ThrowProjectile_Heavy', ME2Evolve2ClassName = 'SFXPower_ThrowProjectile_Radius', ME3PowerName = 'Throw', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Throw'}, 
                              {ME2PowerName = 'VanguardPassive', ME2Evolve1ClassName = 'SFXPower_VanguardPassive_Evolved1', ME2Evolve2ClassName = 'SFXPower_VanguardPassive_Evolved2', ME3PowerName = 'VanguardPassive', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_VanguardPassive'}, 
                              {ME2PowerName = 'WarpProjectile', ME2Evolve1ClassName = 'SFXPower_WarpProjectile_Heavy', ME2Evolve2ClassName = 'SFXPower_WarpProjectile_Radius', ME3PowerName = 'Warp', ME3PowerClassName = 'SFXGameContent.SFXPowerCustomAction_Warp'}
                             )
    Difficulty = EDifficultyOptions.DO_Level3
}