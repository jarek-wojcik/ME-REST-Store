Class SFXGAWAssetsHandler
    config(UI);

struct WarAssetSummaryWithThreshold 
{
    var stringref Summary;
    var int Threshold;
};
struct GAWZoneGUIData 
{
    var string ZoneName;
    var string ZoneDescription;
    var int CurrentRating;
    var int ZoneDisplayNumber;
    var EGAWZone ZoneID;
};
struct GAWZoneData 
{
    var stringref srZoneName;
    var stringref srZoneDescription;
    var int ZoneDisplayNumber;
    var EGAWZone ZoneID;
};
enum EGAWZone
{
    EGAWZone_InnerCouncil,
    EGAWZone_Terminus,
    EGAWZone_Earth,
    EGAWZone_Council,
    EGAWZone_Attican,
};
struct CutscenePlotState 
{
    var int PlotStateID;
    var int BrainThreshold;
    var int HeartThreshold;
};
struct EndGameOption 
{
    var array<int> PlotStates;
    var EEndGameOption Option;
};
struct EndGameOptionSet 
{
    var array<EEndGameOption> Brain;
    var array<EEndGameOption> Heart;
    var float Threshold;
};
struct GAWIntelRewardInfo 
{
    var Name UniqueName;
    var float Value;
    var EGAWAssetType Type;
    var EGAWAssetSubType SubType;
};
struct GAWAsset 
{
    var string AssetName;
    var string ImagePath;
    var string NotificationImagePath;
    var array<GAWAssetModificationTarget> ModTargets;
    var array<int> UnlockPlotStates;
    var biononship string DebugConditionalDescription;
    var int Id;
    var int GUICategoryID;
    var int StartingStrength;
    var stringref GUIName;
    var stringref GUIDescription;
    var int CurrentStrength;
    var int MaxStrength;
    var int ConflictZoneID;
    var bool bIsExploration;
    var bool bShowNotificationOnAward;
    var EGAWAssetType Type;
    var EGAWAssetSubType SubType;
    var GAWExternalAssetID ExternalAssetEnum;
};
struct GAWGUICategory 
{
    var string ImagePath;
    var int Id;
    var stringref srCategoryName;
    var stringref srCategoryDescription;
};
struct GAWAssetModificationTarget 
{
    var int TargetID;
    var int Value;
};

var config array<GAWGUICategory> GAWGUICategories;
var config array<GAWAsset> AllAssets;
var array<GAWAssetSaveInfo> UnlockedGAWAssets;
var config array<GAWIntelRewardInfo> IntelRewards;
var array<EndGameOptionSet> EndGameOptionSets;
var array<int> ShepardLivesStates;
var array<EndGameOption> EndGameOptions;
var array<CutscenePlotState> CutscenePlotStates;
var array<int> AllEndingPlotStates;
var config array<GAWZoneData> GAWTheatreData;
var array<int> CachedGAWRatings;
var array<int> CachedGAWWarAssets;
var config array<WarAssetSummaryWithThreshold> OverallWarAssetSummaries;
var delegate<RequestGAWDataCallback> __RequestGAWDataCallback__Delegate;
var delegate<UpdatedRankingsCallback> __UpdatedRankingsCallback__Delegate;
var int AchievementThreshold;
var int MinimumStrengthForGUI;
var int MaxStrengthForGUI;
var int SaveAndersonScoreBonus;
var int ShepardLivesThreshold;
var int SaveAndersonPlotBool;
var int FinalGAWRatingID;
var int OverallReadinessRating;
var config int GAWExternalAssetStrengthPerTick_Multiplayer;
var config int GAWExternalAssetStrengthPerTick_IPhone;
var config int GAWExternalAssetStrengthPerTick_Facebook;
var stringref GUIDescription_Formatter;
var stringref GUIDescription_UpdatedTag;
var bool bInitialized;
var bool bEvaluateAchievement;
var bool bBrainUsed;

public final function Cleanup()
{
    __RequestGAWDataCallback__Delegate = None;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar().Cleanup();
}
public final function OnGetRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local array<GAWZoneGUIData> ReturnData;
    local int idx;
    local WorldInfo WI;
    local BioPlayerController PC;
    
    ReturnData.Length = GAWTheatreData.Length;
    OverallReadinessRating = 0;
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        PC = BioPlayerController(WI.GetALocalPlayerController());
        if (PC != None && PC.ProfileSettings != None)
        {
            if (errorCode != 0)
            {
                PC.ProfileSettings.LoadGalaxyAtWarRatings(Level, updatedSecurityRatings, updatedWarAssets);
            }
            if (errorCode == 0)
            {
                PC.ProfileSettings.SaveGalaxyAtWarRatings(TRUE, TRUE, TRUE, Level, updatedSecurityRatings, updatedWarAssets);
            }
        }
    }
    bInitialized = TRUE;
    for (idx = 0; idx < GAWTheatreData.Length; ++idx)
    {
        ReturnData[idx].ZoneID = GAWTheatreData[idx].ZoneID;
        ReturnData[idx].ZoneName = string(GAWTheatreData[idx].srZoneName);
        ReturnData[idx].ZoneDescription = string(GAWTheatreData[idx].srZoneDescription);
        ReturnData[idx].ZoneDisplayNumber = GAWTheatreData[idx].ZoneDisplayNumber;
        ReturnData[idx].CurrentRating = 0;
    }
    for (idx = 0; idx < updatedSecurityRatings.Length; ++idx)
    {
        ReturnData[idx].CurrentRating = updatedSecurityRatings[idx];
    }
    OverallReadinessRating = Level;
    CachedGAWRatings = updatedSecurityRatings;
    CachedGAWWarAssets = updatedWarAssets;
    __RequestGAWDataCallback__Delegate(ReturnData, OverallReadinessRating, errorCode);
}
public final function string GetGAWAssetDebugConditionDescription(string AssetName)
{
    local int idx;
    
    idx = AllAssets.Find('AssetName', AssetName);
    if (idx == -1)
    {
        return "";
    }
    return AllAssets[idx].DebugConditionalDescription;
}
public final function AdjustEndingsForSavingAnderson()
{
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    local int FinalScore;
    local int idx;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    VarTable = WI.GetGlobalVariables();
    if (VarTable == None)
    {
        return;
    }
    if (VarTable.GetBool(SaveAndersonPlotBool) == TRUE)
    {
        return;
    }
    VarTable.SetBool(SaveAndersonPlotBool, TRUE);
    FinalScore = VarTable.GetInt(FinalGAWRatingID);
    FinalScore += SaveAndersonScoreBonus;
    if (FinalScore >= ShepardLivesThreshold)
    {
        for (idx = 0; idx < ShepardLivesStates.Length; idx++)
        {
            VarTable.SetBool(ShepardLivesStates[idx], TRUE);
        }
    }
}
public final function ApplyIntelReward(Name UniqueName)
{
    local int idx;
    local int AssetCount;
    local float PercentIncrease;
    local EGAWAssetType Type;
    local EGAWAssetSubType SubType;
    
    idx = IntelRewards.Find('UniqueName', UniqueName);
    if (idx < 0)
    {
        return;
    }
    PercentIncrease = IntelRewards[idx].Value;
    Type = IntelRewards[idx].Type;
    SubType = IntelRewards[idx].SubType;
    AssetCount = AllAssets.Length;
    for (idx = 0; idx < AssetCount; idx++)
    {
        if (int(AllAssets[idx].Type) == int(Type) && (SubType == EGAWAssetSubType.GAWAssetSubType_None || int(AllAssets[idx].SubType) == int(SubType)))
        {
            BuffGAWAsset(AllAssets[idx].Id, PercentIncrease);
        }
    }
}
public final function bool BuffGAWAsset(int Id, float PercentIncrease)
{
    local int idx;
    
    if (Id < 0)
    {
        return FALSE;
    }
    idx = UnlockedGAWAssets.Find('Id', Id);
    if (idx < 0)
    {
        return FALSE;
    }
    UnlockedGAWAssets[idx].Strength *= 1.0 + PercentIncrease;
    return TRUE;
}
public final function bool DoesCategoryHaveNewAssets(int categoryId)
{
    local int idx;
    local array<int> CategoryAssetIDs;
    
    for (idx = 0; idx < AllAssets.Length; idx++)
    {
        if (IsAssetUnlockedForGUICategory(idx, categoryId))
        {
            CategoryAssetIDs.AddItem(AllAssets[idx].Id);
        }
    }
    for (idx = 0; idx < CategoryAssetIDs.Length; idx++)
    {
        if (IsAssetNew(CategoryAssetIDs[idx]) == TRUE)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final function FlagAllUnlockedAssetsAsDisplayedInGUI()
{
    local int idx;
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    for (idx = 0; idx < AllAssets.Length; idx++)
    {
        if (IsGAWAssetUnlocked(AllAssets[idx].Id) == TRUE)
        {
            Engine.SetPlayerVariable(GetPVSeenInGUI(AllAssets[idx].Id), 1);
        }
    }
}
public final function bool GAWAssetCreditRewardAvailable(int Id)
{
    local SFXEngine MyEngine;
    local int idx;
    
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return FALSE;
    }
    idx = AllAssets.Find('Id', Id);
    if (idx < 0)
    {
        return FALSE;
    }
    if (AllAssets[idx].Type != EGAWAssetType.GAWAssetType_Artifact && AllAssets[idx].Type != EGAWAssetType.GAWAssetType_Salvage)
    {
        return FALSE;
    }
    if (IsGAWAssetUnlocked(Id) == FALSE)
    {
        return FALSE;
    }
    if (MyEngine.GetPlayerVariable(Name('GAWAssetCreditReward_' $ Id $ '_Used')) < 1)
    {
        return TRUE;
    }
}
public final function bool GAWAssetCreditRewardAvailableByName(string AssetName)
{
    local int idx;
    
    idx = GetGAWAssetIndex(AssetName);
    if (idx < 0)
    {
        return FALSE;
    }
    return GAWAssetCreditRewardAvailable(AllAssets[idx].Id);
}
public final function string GetCategoryImagePath(int Id)
{
    local int idx;
    
    idx = GAWGUICategories.Find('Id', Id);
    if (idx == -1)
    {
        return "";
    }
    return GAWGUICategories[idx].ImagePath;
}
public final function int GetExplorationAssetCount()
{
    local BioWorldInfo MyWorldInfo;
    local SFXGame MyGame;
    local int AssetCount;
    local int AllAssetsCount;
    local int idx;
    
    AssetCount = 0;
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return -1;
    }
    MyGame = SFXGame(MyWorldInfo.Game);
    if (MyGame == None)
    {
        return -1;
    }
    AllAssetsCount = AllAssets.Length;
    for (idx = 0; idx < AllAssetsCount; idx++)
    {
        if (AllAssets[idx].bIsExploration != TRUE)
        {
            continue;
        }
        if (IsGAWAssetUnlocked(AllAssets[idx].Id) == FALSE)
        {
            continue;
        }
        AssetCount++;
    }
    return AssetCount;
}
public final function GetExternalAssetInfo(GAWExternalAssetID ExternalAssetIndex, int NumberOfTicks, optional out int FinalScore, optional out string GUIDescription, optional out string GUITitle)
{
    local int AssetIdx;
    local int MultiplierStrength;
    
    switch (ExternalAssetIndex)
    {
        case GAWExternalAssetID.GAWExternalAssetID_Multiplayer:
            AssetIdx = AllAssets.Find('AssetName', "GAWAsset_N7SpecialOps");
            if (AssetIdx == -1)
            {
                return;
            }
            MultiplierStrength = GAWExternalAssetStrengthPerTick_Multiplayer;
            break;
        case GAWExternalAssetID.GAWExternalAssetID_FaceBook:
            AssetIdx = AllAssets.Find('AssetName', "GAWAsset_GeneralSherman");
            if (AssetIdx == -1)
            {
                return;
            }
            MultiplierStrength = GAWExternalAssetStrengthPerTick_Facebook;
            break;
        case GAWExternalAssetID.GAWExternalAssetID_Iphone:
            AssetIdx = AllAssets.Find('AssetName', "GAWAsset_CerberusEscapees");
            if (AssetIdx == -1)
            {
                return;
            }
            MultiplierStrength = GAWExternalAssetStrengthPerTick_IPhone;
            break;
        default:
            return;
    }
    GetGAWAssetGUIInfo(AllAssets[AssetIdx].Id, GUITitle, TRUE, GUIDescription);
    FinalScore = NumberOfTicks * MultiplierStrength;
}
public final function int GetFinalScore(int SecurityLevel, optional bool EndingGame = FALSE)
{
    local int MilitaryScore;
    local int ExternalScore;
    local int FinalScore;
    local float GAWRatingMultiplier;
    
    MilitaryScore = GetTotalStrengthByType(0);
    ExternalScore = GetTotalStrengthByType(6);
    FinalScore = GetTotalScore();
    GAWRatingMultiplier = float(SecurityLevel) / 100.0;
    FinalScore = int(float(FinalScore) * GAWRatingMultiplier);
    if (EndingGame)
    {
        Class'SFXTelemetryHooks'.static.SendEndGameOptions(FinalScore, MilitaryScore, ExternalScore, SecurityLevel);
    }
    return FinalScore;
}
public final function bool GetGAWAssetGUIInfo(int Id, out string GUIName, optional bool bGetDescription = FALSE, optional out string GUIDescription)
{
    local int idx;
    
    idx = AllAssets.Find('Id', Id);
    if (idx == -1)
    {
        return FALSE;
    }
    GUIName = string(AllAssets[idx].GUIName);
    if (bGetDescription)
    {
        GUIDescription = GetGUIDescription(Id, AllAssets[idx].Type, AllAssets[idx].GUIDescription);
    }
    return TRUE;
}
public final function bool GetGAWAssetGUIInfoByName(string AssetName, out string GUIName, optional bool bGetDescription = FALSE, optional out string GUIDescription)
{
    local int idx;
    
    idx = AllAssets.Find('AssetName', AssetName);
    if (idx == -1)
    {
        return FALSE;
    }
    GUIName = string(AllAssets[idx].GUIName);
    if (bGetDescription)
    {
        GUIDescription = GetGUIDescription(AllAssets[idx].Id, AllAssets[idx].Type, AllAssets[idx].GUIDescription);
    }
    return TRUE;
}
public final function int GetGAWAssetIndex(string AssetName)
{
    local int Index;
    local string FullName;
    
    Index = AllAssets.Find('AssetName', AssetName);
    if (Index < 0)
    {
        FullName = "GAWAsset_" $ AssetName;
        Index = AllAssets.Find('AssetName', FullName);
    }
    return Index;
}
public final function GetGAWAssetsByType(EGAWAssetType Type, out array<GAWAsset> UnlockedAssets)
{
    local BioWorldInfo MyWorldInfo;
    local SFXGame MyGame;
    local int idx;
    local int AllAssetsCount;
    
    UnlockedAssets.Length = 0;
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return;
    }
    MyGame = SFXGame(MyWorldInfo.Game);
    if (MyGame == None)
    {
        return;
    }
    AllAssetsCount = AllAssets.Length;
    for (idx = 0; idx < AllAssetsCount; idx++)
    {
        if (int(AllAssets[idx].Type) != int(Type))
        {
            continue;
        }
        if (!IsGAWAssetUnlocked(AllAssets[idx].Id))
        {
            continue;
        }
        UnlockedAssets.AddItem(AllAssets[idx]);
    }
}
public static final function SFXGAWAssetsHandler GetGAWHandler()
{
    local WorldInfo WorldInfo;
    local SFXLocalPlayer LP;
    
    WorldInfo = Class'WorldInfo'.static.GetWorldInfo();
    if (WorldInfo == None)
    {
        return None;
    }
    LP = SFXLocalPlayer(WorldInfo.GetALocalPlayerController().Player);
    if (LP == None)
    {
        return None;
    }
    return LP.GAWHandler;
}
public final function string GetGUIDescription(int Id, EGAWAssetType Type, stringref GUIDescription)
{
    local string FinalString;
    local int idx;
    local int Idx2;
    local int ModifierIdxCount;
    local int ModTargetCount;
    local array<int> ModifierIdxs;
    
    FinalString = "";
    switch (Type)
    {
        case EGAWAssetType.GAWAssetType_Military:
            FinalString = string(GUIDescription);
            for (idx = 0; idx < AllAssets.Length; idx++)
            {
                if (AllAssets[idx].Type == EGAWAssetType.GAWAssetType_Modifier && IsGAWAssetUnlocked(AllAssets[idx].Id) == TRUE)
                {
                    ModifierIdxs.AddItem(idx);
                }
            }
            ModifierIdxCount = ModifierIdxs.Length;
            for (idx = 0; idx < ModifierIdxCount; idx++)
            {
                ModTargetCount = AllAssets[ModifierIdxs[idx]].ModTargets.Length;
                for (Idx2 = 0; Idx2 < ModTargetCount; Idx2++)
                {
                    if (AllAssets[ModifierIdxs[idx]].ModTargets[Idx2].TargetID == Id)
                    {
                        ClearCustomTokens();
                        SetCustomToken(0, FinalString);
                        SetCustomToken(2, string(GUIDescription_UpdatedTag));
                        SetCustomToken(4, string(AllAssets[ModifierIdxs[idx]].GUIDescription));
                        FinalString = Class'SFXGame'.static.GetSimpleString(GUIDescription_Formatter, TRUE);
                    }
                }
            }
            ClearCustomTokens();
            break;
        default:
            FinalString = string(GUIDescription);
    }
    return FinalString;
}
public final function string GetImagePath(int Id)
{
    local int idx;
    
    idx = AllAssets.Find('Id', Id);
    if (idx == -1)
    {
        return "";
    }
    return AllAssets[idx].ImagePath;
}
public final function int GetOverallReadiness()
{
    return OverallReadinessRating;
}
public final function int GetOverallReadinessRating()
{
    local WorldInfo WI;
    local BioPlayerController PC;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        return OverallReadinessRating;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None || PC.ProfileSettings == None)
    {
        return OverallReadinessRating;
    }
    if (!bInitialized)
    {
        PC.ProfileSettings.LoadGalaxyAtWarRatings(OverallReadinessRating);
    }
    return OverallReadinessRating;
}
public final function Name GetPVSeenInGUI(int Id)
{
    return Name("GAWAsset_" $ Id $ "_SeenInGUI");
}
public final function GetRatingsCompleted(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int FinalScore;
    local int idx;
    local int Idx2;
    local int SelectedIdx;
    local int OptionIdx;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    local array<EEndGameOption> Options;
    local BioRemoteLogger GLogger;
    local EEndGameOption Option;
    local string OptionString;
    local BioPlayerController PC;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    VarTable = WI.GetGlobalVariables();
    if (VarTable == None)
    {
        return;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    if (errorCode != 0 && PC.ProfileSettings != None)
    {
        PC.ProfileSettings.LoadGalaxyAtWarRatings(Level, updatedSecurityRatings, updatedWarAssets);
    }
    if (errorCode == 0 && PC.ProfileSettings != None)
    {
        PC.ProfileSettings.SaveGalaxyAtWarRatings(TRUE, TRUE, TRUE, Level, updatedSecurityRatings, updatedWarAssets);
    }
    bInitialized = TRUE;
    for (idx = 0; idx < AllEndingPlotStates.Length; idx++)
    {
        VarTable.SetBool(AllEndingPlotStates[idx], FALSE);
    }
    for (idx = 0; idx < CutscenePlotStates.Length; idx++)
    {
        VarTable.SetBool(CutscenePlotStates[idx].PlotStateID, FALSE);
    }
    FinalScore = GetFinalScore(Level, TRUE);
    VarTable.SetInt(FinalGAWRatingID, FinalScore);
    for (idx = 0; idx < EndGameOptionSets.Length; idx++)
    {
        if (float(FinalScore) >= EndGameOptionSets[idx].Threshold)
        {
            SelectedIdx = idx;
            continue;
        }
        break;
    }
    if (bEvaluateAchievement)
    {
        bEvaluateAchievement = FALSE;
        if (FinalScore >= AchievementThreshold)
        {
            PC.UnlockAccomplishment('ENDGAMEMAX');
        }
    }
    if (bBrainUsed)
    {
        for (idx = 0; idx < EndGameOptionSets[SelectedIdx].Brain.Length; idx++)
        {
            OptionIdx = EndGameOptions.Find('Option', EndGameOptionSets[SelectedIdx].Brain[idx]);
            if (OptionIdx == -1)
            {
                continue;
            }
            for (Idx2 = 0; Idx2 < EndGameOptions[OptionIdx].PlotStates.Length; Idx2++)
            {
                VarTable.SetBool(EndGameOptions[OptionIdx].PlotStates[Idx2], TRUE);
            }
            Options.AddItem(EndGameOptionSets[SelectedIdx].Brain[idx]);
        }
        for (idx = 0; idx < CutscenePlotStates.Length; idx++)
        {
            if (FinalScore >= CutscenePlotStates[idx].BrainThreshold)
            {
                VarTable.SetBool(CutscenePlotStates[idx].PlotStateID, TRUE);
            }
        }
    }
    else
    {
        for (idx = 0; idx < EndGameOptionSets[SelectedIdx].Heart.Length; idx++)
        {
            OptionIdx = EndGameOptions.Find('Option', EndGameOptionSets[SelectedIdx].Heart[idx]);
            if (OptionIdx == -1)
            {
                continue;
            }
            for (Idx2 = 0; Idx2 < EndGameOptions[OptionIdx].PlotStates.Length; Idx2++)
            {
                VarTable.SetBool(EndGameOptions[OptionIdx].PlotStates[Idx2], TRUE);
            }
            Options.AddItem(EndGameOptionSets[SelectedIdx].Heart[idx]);
        }
        for (idx = 0; idx < CutscenePlotStates.Length; idx++)
        {
            if (FinalScore >= CutscenePlotStates[idx].HeartThreshold)
            {
                VarTable.SetBool(CutscenePlotStates[idx].PlotStateID, TRUE);
            }
        }
    }
    NotifyCheatManagerEndGameOptions(Options);
    foreach Options(Option, )
    {
        OptionString = OptionString $ Option $ ", ";
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendPlayerEvent(113, "Final Score = " $ FinalScore $ ", Options = " $ OptionString, "", "", "", FinalScore, 0, 0, 0);
    }
}
public final function int GetTotalScore()
{
    local int MilitaryScore;
    local int ExternalScore;
    
    MilitaryScore = GetTotalStrengthByType(0);
    ExternalScore = GetTotalStrengthByType(6);
    return MilitaryScore + ExternalScore;
}
public final function int GetTotalStrengthByType(EGAWAssetType Type, optional out int AssetCount)
{
    local BioWorldInfo MyWorldInfo;
    local SFXGame MyGame;
    local int TotalStrength;
    local int idx;
    local int AllAssetsCount;
    local int AssetCurrentStrength;
    
    AssetCount = 0;
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return -1;
    }
    MyGame = SFXGame(MyWorldInfo.Game);
    if (MyGame == None)
    {
        return -1;
    }
    AllAssetsCount = AllAssets.Length;
    for (idx = 0; idx < AllAssetsCount; idx++)
    {
        if (int(AllAssets[idx].Type) != int(Type))
        {
            continue;
        }
        if (IsGAWAssetUnlocked(AllAssets[idx].Id, AssetCurrentStrength) == FALSE)
        {
            continue;
        }
        TotalStrength += AssetCurrentStrength;
        AssetCount++;
    }
    return TotalStrength;
}
public final function string GetWarAssetsSummaryText()
{
    local int TotalScore;
    local int EffectiveScore;
    local int idx;
    local string FinalString;
    
    TotalScore = GetTotalScore();
    EffectiveScore = GetFinalScore(OverallReadinessRating);
    for (idx = 0; idx < OverallWarAssetSummaries.Length; idx++)
    {
        if (OverallWarAssetSummaries[idx].Threshold > EffectiveScore)
        {
            continue;
        }
        ClearCustomTokens();
        SetCustomToken(0, string(TotalScore));
        SetCustomToken(1, string(OverallReadinessRating));
        SetCustomToken(2, string(EffectiveScore));
        FinalString = Class'SFXGame'.static.GetSimpleString(OverallWarAssetSummaries[idx].Summary, TRUE);
        ClearCustomTokens();
        break;
    }
    return FinalString;
}
public final function bool GiveGAWCreditsForAsset(int Id)
{
    local SFXPawn_Player PlayerPawn;
    local WorldInfo WorldInfo;
    local BioPlayerController PC;
    local SFXInventoryManager InvManager;
    local int idx;
    local SFXEngine MyEngine;
    local BioHintSystem HintSystem;
    
    if (GAWAssetCreditRewardAvailable(Id) == FALSE)
    {
        return FALSE;
    }
    WorldInfo = Class'WorldInfo'.static.GetWorldInfo();
    if (WorldInfo == None)
    {
        return FALSE;
    }
    PC = BioPlayerController(WorldInfo.GetALocalPlayerController());
    if (PC == None)
    {
        return FALSE;
    }
    PlayerPawn = SFXPawn_Player(PC.Pawn);
    if (PlayerPawn == None)
    {
        return FALSE;
    }
    InvManager = SFXInventoryManager(PlayerPawn.InvManager);
    if (InvManager == None)
    {
        return FALSE;
    }
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return FALSE;
    }
    HintSystem = BioHintSystem(PC.HintSystem);
    if (HintSystem == None)
    {
        return FALSE;
    }
    idx = AllAssets.Find('Id', Id);
    if (idx < 0)
    {
        return FALSE;
    }
    InvManager.AdjustResource(0, AllAssets[idx].StartingStrength, TRUE, TRUE);
    MyEngine.SetPlayerVariable(Name('GAWAssetCreditReward_' $ Id $ '_Used'), 1);
    if (AllAssets[idx].Type == EGAWAssetType.GAWAssetType_Artifact)
    {
        HintSystem.AddNotification_GalaxyAtWarArtifactCredits();
    }
    return TRUE;
}
public final function bool GiveGAWCreditsForAssetByName(string AssetName)
{
    local int idx;
    
    idx = GetGAWAssetIndex(AssetName);
    if (idx < 0)
    {
        return FALSE;
    }
    return GiveGAWCreditsForAsset(AllAssets[idx].Id);
}
public final function IncreaseRatingsCompleted(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int idx;
    local WorldInfo WI;
    local BioPlayerController PC;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        PC = BioPlayerController(WI.GetALocalPlayerController());
        if (PC != None && PC.ProfileSettings != None)
        {
            if (errorCode != 0)
            {
                PC.ProfileSettings.LoadGalaxyAtWarRatings(Level, updatedSecurityRatings, updatedWarAssets);
            }
            if (errorCode == 0)
            {
                PC.ProfileSettings.SaveGalaxyAtWarRatings(TRUE, TRUE, TRUE, Level, updatedSecurityRatings, updatedWarAssets);
            }
        }
    }
    bInitialized = TRUE;
    CachedGAWRatings = updatedSecurityRatings;
    for (idx = 0; idx < CachedGAWRatings.Length; idx++)
    {
    }
    OverallReadinessRating = Level;
    if (Class'SFXGAWAssetsHandler'.static.GetGAWHandler().__UpdatedRankingsCallback__Delegate != None)
    {
        Class'SFXGAWAssetsHandler'.static.GetGAWHandler().__UpdatedRankingsCallback__Delegate(errorCode);
    }
}
public final function bool IncrementMultiplayerAsset()
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    local array<MapEntry> ServerGAWAssets;
    local array<MapEntry> EmptyMapArray;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return FALSE;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        return FALSE;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        return FALSE;
    }
    ServerGAWAssets.Length = 1;
    ServerGAWAssets[0].EntryId = 0;
    ServerGAWAssets[0].IncreaseValue = 1;
    EmptyMapArray.Length = 0;
    OnlineGAW.IncreaseRatings(0, EmptyMapArray, ServerGAWAssets, MultiplayerAssetIncreaseComplete);
    Class'SFXTelemetryHooks'.static.SendIncrementMPAsset(0, 1);
}
public final function bool IsAssetNew(int AssetID)
{
    local int idx;
    local SFXEngine Engine;
    
    idx = AllAssets.Find('Id', AssetID);
    if (idx == -1)
    {
        return FALSE;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return FALSE;
    }
    if (Engine.GetPlayerVariable(GetPVSeenInGUI(AllAssets[idx].Id)) != 0)
    {
        return FALSE;
    }
    return TRUE;
}
public final function bool IsAssetUnlockedForGUICategory(int nAssetIndex, int nCategoryID, optional out int nCurrentStrength)
{
    return nAssetIndex >= 0 && nAssetIndex < AllAssets.Length && (AllAssets[nAssetIndex].Type == EGAWAssetType.GAWAssetType_Military || AllAssets[nAssetIndex].Type == EGAWAssetType.GAWAssetType_External) && AllAssets[nAssetIndex].GUICategoryID == nCategoryID && IsGAWAssetUnlocked(AllAssets[nAssetIndex].Id, nCurrentStrength, CachedGAWWarAssets) == TRUE && nCurrentStrength > 0;
}
public final function bool IsGAWAssetUnlocked(int Id, optional out int CurrentStrength, optional array<int> WarAssets)
{
    local int Index;
    local int NumberOfTicks;
    local BioGlobalVariableTable VarTable;
    local BioWorldInfo WI;
    
    Index = AllAssets.Find('Id', Id);
    if (Index == -1)
    {
        return FALSE;
    }
    if (AllAssets[Index].Type == EGAWAssetType.GAWAssetType_External)
    {
        if (WarAssets.Length > int(AllAssets[Index].ExternalAssetEnum))
        {
            NumberOfTicks = WarAssets[int(AllAssets[Index].ExternalAssetEnum)];
        }
        else if (CachedGAWWarAssets.Length > int(AllAssets[Index].ExternalAssetEnum))
        {
            NumberOfTicks = CachedGAWWarAssets[int(AllAssets[Index].ExternalAssetEnum)];
        }
        else
        {
            NumberOfTicks = 0;
        }
        if (AllAssets[Index].ExternalAssetEnum == GAWExternalAssetID.GAWExternalAssetID_Multiplayer && NumberOfTicks > 0)
        {
            WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
            if (WI != None)
            {
                VarTable = WI.GetGlobalVariables();
                if (VarTable != None)
                {
                    VarTable.SetBool(AllAssets[Index].UnlockPlotStates[0], TRUE);
                }
            }
        }
        GetExternalAssetInfo(AllAssets[Index].ExternalAssetEnum, NumberOfTicks, CurrentStrength);
        return TRUE;
    }
    CurrentStrength = 0;
    Index = UnlockedGAWAssets.Find('Id', Id);
    if (Index < 0)
    {
        return FALSE;
    }
    CurrentStrength = UnlockedGAWAssets[Index].Strength;
    return TRUE;
}
public final function bool IsGAWAssetUnlockedByName(string AssetName, optional out int CurrentStrength)
{
    local int idx;
    
    CurrentStrength = 0;
    idx = AllAssets.Find('AssetName', AssetName);
    if (idx == -1)
    {
        return FALSE;
    }
    idx = UnlockedGAWAssets.Find('Id', AllAssets[idx].Id);
    if (idx == -1)
    {
        return FALSE;
    }
    CurrentStrength = UnlockedGAWAssets[idx].Strength;
    return TRUE;
}
public final function MarkAssetAsNew(int AssetID)
{
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    Engine.SetPlayerVariable(GetPVSeenInGUI(AssetID), 0);
}
public final function MarkAssetAsRead(int AssetID)
{
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    Engine.SetPlayerVariable(GetPVSeenInGUI(AssetID), 1);
}
public function MultiplayerAssetIncreaseComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int idx;
    local int MultiplayerAssetStrength;
    local WorldInfo WI;
    local BioPlayerController PC;
    
    idx = AllAssets.Find('AssetName', "GAWAsset_N7SpecialOps");
    if (idx == -1)
    {
        return;
    }
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        PC = BioPlayerController(WI.GetALocalPlayerController());
        if (PC != None && PC.ProfileSettings != None)
        {
            if (errorCode != 0)
            {
                PC.ProfileSettings.LoadGalaxyAtWarRatings(Level, updatedSecurityRatings, updatedWarAssets);
            }
            if (errorCode == 0)
            {
                PC.ProfileSettings.SaveGalaxyAtWarRatings(TRUE, TRUE, TRUE, Level, updatedSecurityRatings, updatedWarAssets);
            }
        }
    }
    bInitialized = TRUE;
    GetExternalAssetInfo(0, updatedWarAssets[0], MultiplayerAssetStrength);
    UpdateGAWAsset(AllAssets[idx].Id, MultiplayerAssetStrength, FALSE);
}
public final function NotifyCheatManagerEndGameOptions(optional array<EEndGameOption> Options);

public delegate function RequestGAWDataCallback(array<GAWZoneGUIData> ZoneData, int Level, int errorCode);

public final function RequestGAWRatings(delegate<RequestGAWDataCallback> Callback, optional bool bCached = TRUE)
{
    OverallReadinessRating = 0;
    __RequestGAWDataCallback__Delegate = Callback;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar().GetRatings(TRUE, bCached, OnGetRatingsComplete);
}
public final function ResetAllGAWAssets()
{
    local GAWAssetSaveInfo Asset;
    
    foreach UnlockedGAWAssets(Asset, )
    {
        ResetGAWAsset(Asset.Id);
    }
}
public final function bool ResetGAWAsset(int Id)
{
    local int Index;
    
    Index = AllAssets.Find('Id', Id);
    if (Index < 0)
    {
        return FALSE;
    }
    return UpdateGAWAsset(Id, AllAssets[Index].StartingStrength);
}
public final function bool ResetGAWAssetByName(string AssetName)
{
    local int idx;
    
    idx = GetGAWAssetIndex(AssetName);
    if (idx < 0)
    {
        return FALSE;
    }
    return UpdateGAWAsset(AllAssets[idx].Id, AllAssets[idx].StartingStrength);
}
public final function SetEndGameOptions(bool bBrain, optional bool bAchievement = FALSE)
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        NotifyCheatManagerEndGameOptions();
        return;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        NotifyCheatManagerEndGameOptions();
        return;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        NotifyCheatManagerEndGameOptions();
        return;
    }
    bBrainUsed = bBrain;
    bEvaluateAchievement = bAchievement;
    OnlineGAW.GetRatings(FALSE, FALSE, GetRatingsCompleted);
}
public final function UnlockAllGAWAssets()
{
    local GAWAsset Asset;
    
    foreach AllAssets(Asset, )
    {
        if (IsGAWAssetUnlocked(Asset.Id))
        {
            continue;
        }
        UnlockGAWAsset(Asset.Id);
    }
}
public final function bool UnlockExplorationGAWAsset(optional out stringref srAssetName)
{
    local int idx;
    
    for (idx = 0; idx < AllAssets.Length; idx++)
    {
        if (AllAssets[idx].bIsExploration && IsGAWAssetUnlocked(AllAssets[idx].Id) == FALSE)
        {
            UnlockGAWAsset(AllAssets[idx].Id);
            srAssetName = AllAssets[idx].GUIName;
            return TRUE;
        }
    }
    return FALSE;
}
public final function bool UnlockGAWAsset(int Id)
{
    local int AssetIdx;
    local int IntelIdx;
    local int idx;
    local int Idx2;
    local BioWorldInfo MyWorldInfo;
    local SFXGame MyGame;
    local SFXEngine MyEngine;
    local float CalculatedStartingStrength;
    local GAWAssetSaveInfo NewGAWAsset;
    local BioGlobalVariableTable VarTable;
    local BioRemoteLogger GLogger;
    local BioPlayerController PC;
    local BioHintSystem HintSystem;
    
    MyWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (MyWorldInfo == None)
    {
        return FALSE;
    }
    MyGame = SFXGame(MyWorldInfo.Game);
    if (MyGame == None)
    {
        return FALSE;
    }
    MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (MyEngine == None)
    {
        return FALSE;
    }
    VarTable = MyWorldInfo.GetGlobalVariables();
    if (VarTable == None)
    {
        return FALSE;
    }
    PC = BioPlayerController(MyWorldInfo.GetALocalPlayerController());
    if (PC == None)
    {
        return FALSE;
    }
    HintSystem = BioHintSystem(PC.HintSystem);
    if (HintSystem == None)
    {
        return FALSE;
    }
    AssetIdx = AllAssets.Find('Id', Id);
    if (AssetIdx < 0)
    {
        return FALSE;
    }
    if (IsGAWAssetUnlocked(AllAssets[AssetIdx].Id))
    {
        return FALSE;
    }
    CalculatedStartingStrength = float(AllAssets[AssetIdx].StartingStrength);
    for (IntelIdx = 0; IntelIdx < IntelRewards.Length; IntelIdx++)
    {
        if (MyEngine.GetPlayerVariable(IntelRewards[IntelIdx].UniqueName) < 1)
        {
            continue;
        }
        if (int(IntelRewards[IntelIdx].Type) != int(AllAssets[AssetIdx].Type) || int(IntelRewards[IntelIdx].SubType) != int(AllAssets[AssetIdx].SubType))
        {
            continue;
        }
        CalculatedStartingStrength *= IntelRewards[IntelIdx].Value + float(1);
    }
    for (idx = 0; idx < AllAssets.Length; idx++)
    {
        if (AllAssets[idx].Type == EGAWAssetType.GAWAssetType_Modifier && IsGAWAssetUnlocked(AllAssets[idx].Id) == TRUE)
        {
            for (Idx2 = 0; Idx2 < AllAssets[idx].ModTargets.Length; Idx2++)
            {
                if (AllAssets[idx].ModTargets[Idx2].TargetID == Id)
                {
                    CalculatedStartingStrength += float(AllAssets[idx].ModTargets[Idx2].Value);
                }
            }
        }
    }
    NewGAWAsset.Id = AllAssets[AssetIdx].Id;
    NewGAWAsset.Strength = int(CalculatedStartingStrength);
    UnlockedGAWAssets.AddItem(NewGAWAsset);
    if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Salvage)
    {
        GiveGAWCreditsForAsset(AllAssets[AssetIdx].Id);
    }
    foreach AllAssets[AssetIdx].UnlockPlotStates(idx, )
    {
        VarTable.SetBool(idx, TRUE);
    }
    if (AllAssets[AssetIdx].bIsExploration == TRUE)
    {
        PC.UpdateAccomplishmentProgression('SALVAGECOUNT');
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Modifier)
    {
        for (idx = 0; idx < AllAssets[AssetIdx].ModTargets.Length; idx++)
        {
            if (GLogger != None)
            {
                GLogger.SendPlayerEvent(112, "Modded Asset ID=" $ AllAssets[AssetIdx].ModTargets[idx].TargetID $ ", Mod Value=" $ AllAssets[AssetIdx].ModTargets[idx].Value, "", "", "", AllAssets[AssetIdx].ModTargets[idx].TargetID, AllAssets[AssetIdx].ModTargets[idx].Value, 0, 0);
            }
            UpdateGAWAsset(AllAssets[AssetIdx].ModTargets[idx].TargetID, AllAssets[AssetIdx].ModTargets[idx].Value, TRUE);
            MarkAssetAsNew(AllAssets[AssetIdx].ModTargets[idx].TargetID);
        }
    }
    if (GLogger != None)
    {
        GLogger.SendPlayerEvent(111, "", string(AllAssets[AssetIdx].Type), string(AllAssets[AssetIdx].SubType), AllAssets[AssetIdx].AssetName $ ", ID=" $ AllAssets[AssetIdx].Id $ "Current Strength =" $ AllAssets[AssetIdx].CurrentStrength, AllAssets[AssetIdx].Id, AllAssets[AssetIdx].CurrentStrength, 0, 0);
    }
    Class'SFXTelemetryHooks'.static.SendUnlockGAWAsset(AllAssets[AssetIdx].Id, AllAssets[AssetIdx].Type, AllAssets[AssetIdx].SubType, AllAssets[AssetIdx].CurrentStrength);
    if (AllAssets[AssetIdx].bShowNotificationOnAward == TRUE)
    {
        if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Salvage)
        {
            HintSystem.AddNotification_GalaxyAtWarSalvage();
        }
        else if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Modifier)
        {
            if (AllAssets[AssetIdx].GUIName != 0)
            {
                HintSystem.AddNotification_GalaxyAtWarAsset(AllAssets[AssetIdx].GUIName);
            }
            for (idx = 0; idx < AllAssets[AssetIdx].ModTargets.Length; idx++)
            {
                Idx2 = AllAssets.Find('Id', AllAssets[AssetIdx].ModTargets[idx].TargetID);
                if (Idx2 != -1)
                {
                    HintSystem.AddNotification_GalaxyAtWarModifier(AllAssets[Idx2].GUIName);
                }
            }
        }
        else if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Artifact)
        {
            HintSystem.AddNotification_GalaxyAtWarArtifact(AllAssets[AssetIdx].GUIName);
        }
        else if (AllAssets[AssetIdx].Type == EGAWAssetType.GAWAssetType_Intel)
        {
            HintSystem.AddNotification_GalaxyAtWarIntel(AllAssets[AssetIdx].GUIName);
        }
        else
        {
            HintSystem.AddNotification_GalaxyAtWarAsset(AllAssets[AssetIdx].GUIName);
        }
    }
    return TRUE;
}
public final function bool UnlockGAWAssetByAssetName(string AssetName)
{
    local int Index;
    local string FullName;
    
    Index = AllAssets.Find('AssetName', AssetName);
    if (Index < 0)
    {
        FullName = "GAWAsset_" $ AssetName;
        Index = AllAssets.Find('AssetName', FullName);
        if (Index < 0)
        {
            return FALSE;
        }
    }
    return UnlockGAWAsset(AllAssets[Index].Id);
}
public final function bool UnlockNextGAWAsset(EGAWAssetType AssetType)
{
    local int idx;
    
    for (idx = 0; idx < AllAssets.Length; idx++)
    {
        if (int(AllAssets[idx].Type) == int(AssetType) && IsGAWAssetUnlocked(AllAssets[idx].Id) == FALSE)
        {
            UnlockGAWAsset(AllAssets[idx].Id);
            return TRUE;
        }
    }
    return FALSE;
}
public delegate function UpdatedRankingsCallback(int errorCode);

public final function bool UpdateGAWAsset(int Id, int NewStrength, optional bool bAddToTotal = FALSE)
{
    local int idx;
    
    if (Id < 0)
    {
        return FALSE;
    }
    idx = UnlockedGAWAssets.Find('Id', Id);
    if (idx < 0)
    {
        return FALSE;
    }
    if (!bAddToTotal)
    {
        UnlockedGAWAssets[idx].Strength = NewStrength;
    }
    else
    {
        UnlockedGAWAssets[idx].Strength += NewStrength;
    }
    return TRUE;
}
public final function bool UpdateGAWAssetByName(string AssetName, int NewStrength)
{
    local int idx;
    
    idx = GetGAWAssetIndex(AssetName);
    if (idx < 0)
    {
        return FALSE;
    }
    return UpdateGAWAsset(AllAssets[idx].Id, NewStrength);
}
public static final function UpdateSecurityRating(int ZoneID, float Increase, optional float GlobalIncrease = 0.0, optional delegate<UpdatedRankingsCallback> Callback = None)
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    local array<MapEntry> ZoneIncreases;
    local array<MapEntry> AssetIncreases;
    local BioRemoteLogger GLogger;
    local int i;
    
    AssetIncreases.Length = 0;
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        return;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        return;
    }
    ZoneIncreases.Length = 5;
    for (i = 0; i < ZoneIncreases.Length; i++)
    {
        ZoneIncreases[i].EntryId = i;
        if (i == ZoneID)
        {
            ZoneIncreases[i].IncreaseValue = int(Increase);
            continue;
        }
        ZoneIncreases[i].IncreaseValue = int(GlobalIncrease);
    }
    Class'SFXGAWAssetsHandler'.static.GetGAWHandler().__UpdatedRankingsCallback__Delegate = Callback;
    OnlineGAW.IncreaseRatings(0, ZoneIncreases, AssetIncreases, IncreaseRatingsCompleted);
    Class'SFXTelemetryHooks'.static.SendUpdateSecurityRatings(ZoneID, Increase, GlobalIncrease);
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendPlayerEvent(115, "Zone " $ ZoneID $ " increased by " $ Increase, "", "", "", ZoneID, int(Increase), 0, 0);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GAWGUICategories = ({ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", Id = 0, srCategoryName = $722300, srCategoryDescription = $724676}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", Id = 1, srCategoryName = $722301, srCategoryDescription = $724677}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_Asari_512x256", Id = 2, srCategoryName = $260710, srCategoryDescription = $724678}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", Id = 3, srCategoryName = $709788, srCategoryDescription = $724679}, 
                        {ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", Id = 4, srCategoryName = $722299, srCategoryDescription = $724680}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", Id = 5, srCategoryName = $145689, srCategoryDescription = $724681}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", Id = 6, srCategoryName = $341195, srCategoryDescription = $724682}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_SalariansArmor_512x256", Id = 7, srCategoryName = $263420, srCategoryDescription = $724683}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", Id = 8, srCategoryName = $313694, srCategoryDescription = $724684}, 
                        {ImagePath = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", Id = 9, srCategoryName = $262479, srCategoryDescription = $724685}
                       )
    AllAssets = ({
                  AssetName = "GAWAsset_AllianceEngineeringCorp", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansNoArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 0, 
                  GUICategoryID = 1, 
                  StartingStrength = 130, 
                  GUIName = $715401, 
                  GUIDescription = $715515, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_103rdMarineDivision", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 1, 
                  GUICategoryID = 1, 
                  StartingStrength = 100, 
                  GUIName = $715402, 
                  GUIDescription = $715516, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdmiralMikhailovich", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Mikhailovich_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 2, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $715403, 
                  GUIDescription = $715517, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Alliance1stFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 3, 
                  GUICategoryID = 1, 
                  StartingStrength = 90, 
                  GUIName = $715404, 
                  GUIDescription = $715518, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Alliance3rdFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 4, 
                  GUICategoryID = 1, 
                  StartingStrength = 90, 
                  GUIName = $715405, 
                  GUIDescription = $715519, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TerminusFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Aria Plot Started", 
                  Id = 6, 
                  GUICategoryID = 0, 
                  StartingStrength = 50, 
                  GUIName = $715407, 
                  GUIDescription = $715521, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BloodPackFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = ({TargetID = 6, Value = 50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Aria Blood Pack Plot", 
                  Id = 7, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715522, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BlueSunsFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = ({TargetID = 6, Value = 50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Aria Blue Suns Plot", 
                  Id = 8, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715523, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_EclipseFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = ({TargetID = 6, Value = 50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Aria Eclipse Sub Plot", 
                  Id = 9, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715524, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BannerOfThe1stRegiment", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21455), 
                  DebugConditionalDescription = "None", 
                  Id = 10, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $717657, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TurianFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 11, 
                  GUICategoryID = 8, 
                  StartingStrength = 40, 
                  GUIName = $715408, 
                  GUIDescription = $715525, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Turian6thFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 12, 
                  GUICategoryID = 8, 
                  StartingStrength = 135, 
                  GUIName = $715409, 
                  GUIDescription = $715526, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FusionReactor", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 13, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DataCache", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 14, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FuelStorageDepot", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 15, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceFrigateAgrincourt", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Frigate_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Frigate_256x128", 
                  ModTargets = ({TargetID = 3, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Modifies", 
                  Id = 16, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $717977, 
                  GUIDescription = $720111, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceSpecOpsTeamEcho", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HumansArmor_256x128", 
                  ModTargets = ({TargetID = 1, Value = 20}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 17, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $718000, 
                  GUIDescription = $715527, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdvancedStarshipFuel", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 18, 
                  GUICategoryID = 3, 
                  StartingStrength = 75, 
                  GUIName = $715410, 
                  GUIDescription = $715528, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_PillarsOfStrength", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21458), 
                  DebugConditionalDescription = "None", 
                  Id = 20, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $718001, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProcessingVIs", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 21, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BattleFootage", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21531), 
                  DebugConditionalDescription = "None", 
                  Id = 22, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715412, 
                  GUIDescription = $715530, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MajorKirrahe", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Kirrahe_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Kirrahe Alive", 
                  Id = 24, 
                  GUICategoryID = 7, 
                  StartingStrength = 20, 
                  GUIName = $715413, 
                  GUIDescription = $715531, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SalarianSTG1", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_SalariansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Kirrahe Alive", 
                  Id = 25, 
                  GUICategoryID = 7, 
                  StartingStrength = 35, 
                  GUIName = $715414, 
                  GUIDescription = $715532, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KhaleeSanders", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_KhaleeSanders_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "", 
                  Id = 28, 
                  GUICategoryID = 1, 
                  StartingStrength = 15, 
                  GUIName = $715416, 
                  GUIDescription = $715534, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BioticCompany", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumanBiotics_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose attack in Jack", 
                  Id = 29, 
                  GUICategoryID = 1, 
                  StartingStrength = 75, 
                  GUIName = $715417, 
                  GUIDescription = $715535, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Jack", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Jack_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Jack Alive", 
                  Id = 30, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $715418, 
                  GUIDescription = $715536, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusResearch", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 31, 
                  GUICategoryID = 4, 
                  StartingStrength = 50, 
                  GUIName = $715419, 
                  GUIDescription = $715537, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ElementZeroCore", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 32, 
                  GUICategoryID = 3, 
                  StartingStrength = 200, 
                  GUIName = $715411, 
                  GUIDescription = $715529, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_CerbFighters_256x128", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 33, 
                  GUICategoryID = 4, 
                  StartingStrength = 100, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanObelisk", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21461), 
                  DebugConditionalDescription = "None", 
                  Id = 34, 
                  GUICategoryID = 0, 
                  StartingStrength = 20000, 
                  GUIName = $718031, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_WeaponsCache", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 35, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SecurityVI", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 36, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceCruiserLondon", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceCruiser_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AllianceCruiser_256x128", 
                  ModTargets = ({TargetID = 4, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 37, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $718034, 
                  GUIDescription = $720112, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdvancedFighterSquadron", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_CerbFighters_256x128", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 38, 
                  GUICategoryID = 4, 
                  StartingStrength = 75, 
                  GUIName = $715420, 
                  GUIDescription = $715538, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Salarian1stFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Side with Salarians", 
                  Id = 41, 
                  GUICategoryID = 7, 
                  StartingStrength = 150, 
                  GUIName = $715421, 
                  GUIDescription = $715539, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Turian43rdMarineDivision", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 42, 
                  GUICategoryID = 8, 
                  StartingStrength = 90, 
                  GUIName = $715422, 
                  GUIDescription = $715540, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Turian7thFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 43, 
                  GUICategoryID = 8, 
                  StartingStrength = 90, 
                  GUIName = $715423, 
                  GUIDescription = $715541, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TurianBlackwatch1", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 44, 
                  GUICategoryID = 8, 
                  StartingStrength = 75, 
                  GUIName = $715424, 
                  GUIDescription = $715542, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TurianEngineeringCorp", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 45, 
                  GUICategoryID = 8, 
                  StartingStrength = 110, 
                  GUIName = $715425, 
                  GUIDescription = $715543, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Wreav", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Wreav_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Wrex Dead", 
                  Id = 46, 
                  GUICategoryID = 5, 
                  StartingStrength = 25, 
                  GUIName = $715426, 
                  GUIDescription = $715544, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Wrex", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Wrex_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Wrex Alive", 
                  Id = 47, 
                  GUICategoryID = 5, 
                  StartingStrength = 30, 
                  GUIName = $715427, 
                  GUIDescription = $715545, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Grunt", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Grunt_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Grunt Alive, Loyal if queen saved", 
                  Id = 48, 
                  GUICategoryID = 5, 
                  StartingStrength = 25, 
                  GUIName = $715428, 
                  GUIDescription = $715546, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AralahkCompany", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "", 
                  Id = 49, 
                  GUICategoryID = 5, 
                  StartingStrength = 25, 
                  GUIName = $715429, 
                  GUIDescription = $715547, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_RachniiWorkers", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Rachni_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Queen Saved", 
                  Id = 52, 
                  GUICategoryID = 0, 
                  StartingStrength = 100, 
                  GUIName = $715430, 
                  GUIDescription = $715548, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_WeaponCache", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 53, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_JavelinMissileLaunchers", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 54, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715431, 
                  GUIDescription = $715549, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_IntelligenceArchives", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21541), 
                  DebugConditionalDescription = "None", 
                  Id = 55, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715432, 
                  GUIDescription = $715550, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FabricationUnits", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 56, 
                  GUICategoryID = 3, 
                  StartingStrength = 45, 
                  GUIName = $715433, 
                  GUIDescription = $715551, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BookOfPlenix", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21464), 
                  DebugConditionalDescription = "None", 
                  Id = 57, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $718046, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_VolusDreadnaughtKwunu", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_DreadVolus_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_DreadVolus_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 58, 
                  GUICategoryID = 0, 
                  StartingStrength = 50, 
                  GUIName = $715434, 
                  GUIDescription = $715552, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_VolusEngineeringTeam", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Voluses_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Voluses_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 59, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715435, 
                  GUIDescription = $715553, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Arcturus1stDivision", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 63, 
                  GUICategoryID = 1, 
                  StartingStrength = 60, 
                  GUIName = $715436, 
                  GUIDescription = $715554, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BattleofArcturusIntel", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21533), 
                  DebugConditionalDescription = "None", 
                  Id = 64, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715437, 
                  GUIDescription = $715555, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_InterfermetricArray", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 65, 
                  GUICategoryID = 3, 
                  StartingStrength = 45, 
                  GUIName = $715438, 
                  GUIDescription = $715556, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ExoGeniScientists", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumanScientists_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HumanScientists_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 66, 
                  GUICategoryID = 3, 
                  StartingStrength = 40, 
                  GUIName = $715439, 
                  GUIDescription = $715557, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceSpecOpsTeamDelta", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HumansArmor_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 68, 
                  GUICategoryID = 1, 
                  StartingStrength = 35, 
                  GUIName = $715440, 
                  GUIDescription = $715558, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceCruiserShanghai", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceCruiser_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AllianceCruiser_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 69, 
                  GUICategoryID = 1, 
                  StartingStrength = 40, 
                  GUIName = $715441, 
                  GUIDescription = $715559, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DestroyedMiniReaper", 
                  ImagePath = "gui_codex_images.Codex.CDX_Reapers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Reapers_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (21537), 
                  DebugConditionalDescription = "None", 
                  Id = 70, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715442, 
                  GUIDescription = $715560, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_NavalEngineeringFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceFlotilla_256x128", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 71, 
                  GUICategoryID = 1, 
                  StartingStrength = 75, 
                  GUIName = $715443, 
                  GUIDescription = $715561, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanDataFiles", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 72, 
                  GUICategoryID = 3, 
                  StartingStrength = 75, 
                  GUIName = $715444, 
                  GUIDescription = $715562, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ShadowBrokerShipTech", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_ShadowShip_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_ShadowShip_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 73, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715445, 
                  GUIDescription = $715563, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_LifeSupportPods", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_LifePods_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_LifePods_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 74, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TerminusFreighters", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceFlotilla_256x128", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 75, 
                  GUICategoryID = 3, 
                  StartingStrength = 30, 
                  GUIName = $715446, 
                  GUIDescription = $715564, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ShadowBrokerSupportTeam", 
                  ImagePath = "gui_codex_images.Codex.CDX_Liara_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Liara_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 76, 
                  GUICategoryID = 0, 
                  StartingStrength = 40, 
                  GUIName = $715447, 
                  GUIDescription = $715565, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariScienceTeam", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariNoArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 77, 
                  GUICategoryID = 2, 
                  StartingStrength = 90, 
                  GUIName = $715448, 
                  GUIDescription = $715566, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Asari2ndFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 78, 
                  GUICategoryID = 2, 
                  StartingStrength = 90, 
                  GUIName = $715449, 
                  GUIDescription = $715567, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Asari6thFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 79, 
                  GUICategoryID = 2, 
                  StartingStrength = 90, 
                  GUIName = $715450, 
                  GUIDescription = $715568, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DestinyAscension", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_DestinyA_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Council Alive", 
                  Id = 80, 
                  GUICategoryID = 2, 
                  StartingStrength = 70, 
                  GUIName = $715451, 
                  GUIDescription = $715569, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdmiralDaroXen", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Xen_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Quarians Alive", 
                  Id = 82, 
                  GUICategoryID = 9, 
                  StartingStrength = 25, 
                  GUIName = $715452, 
                  GUIDescription = $715570, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Krogan1stDivision", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 83, 
                  GUICategoryID = 5, 
                  StartingStrength = 50, 
                  GUIName = $715453, 
                  GUIDescription = $715571, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusScienceTeam", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 84, 
                  GUICategoryID = 4, 
                  StartingStrength = 25, 
                  GUIName = $715454, 
                  GUIDescription = $715572, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DrBrynnCole", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_DrCole_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 85, 
                  GUICategoryID = 4, 
                  StartingStrength = 25, 
                  GUIName = $715455, 
                  GUIDescription = $715573, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DrGavinArcher", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_DrArcher_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "David Archer at Overlord", 
                  Id = 86, 
                  GUICategoryID = 4, 
                  StartingStrength = 25, 
                  GUIName = $715456, 
                  GUIDescription = $715574, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Jacob", 
                  ImagePath = "gui_codex_images.Codex.CDX_Jacob2_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Jacob Alive", 
                  Id = 87, 
                  GUICategoryID = 4, 
                  StartingStrength = 25, 
                  GUIName = $715457, 
                  GUIDescription = $715575, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_EngineParts", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 88, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_LibraryOfAsha", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21467), 
                  DebugConditionalDescription = "None", 
                  Id = 89, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $717583, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCommandoTeam4", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 91, 
                  GUICategoryID = 2, 
                  StartingStrength = 20, 
                  GUIName = $715458, 
                  GUIDescription = $715576, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Samara", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Samara_512", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Samara Alive", 
                  Id = 92, 
                  GUICategoryID = 2, 
                  StartingStrength = 25, 
                  GUIName = $715459, 
                  GUIDescription = $715577, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_IntactReaperGun", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21539), 
                  DebugConditionalDescription = "None", 
                  Id = 93, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715460, 
                  GUIDescription = $715578, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_EezoConverter", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 94, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715461, 
                  GUIDescription = $715579, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanDataDrives", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21470), 
                  DebugConditionalDescription = "None", 
                  Id = 95, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719727, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FuelPods", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 96, 
                  GUICategoryID = 3, 
                  StartingStrength = 30, 
                  GUIName = $715462, 
                  GUIDescription = $715580, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdvancedPowerRelays", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 97, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715463, 
                  GUIDescription = $715581, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FossilizedKaklisaur", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21473), 
                  DebugConditionalDescription = "None", 
                  Id = 98, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719825, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_HaptiveOpticsArray", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 99, 
                  GUICategoryID = 3, 
                  StartingStrength = 50, 
                  GUIName = $715464, 
                  GUIDescription = $715582, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TurianSpecOpsTeam", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_TuriansArmor_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 100, 
                  GUICategoryID = 8, 
                  StartingStrength = 40, 
                  GUIName = $715465, 
                  GUIDescription = $715583, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdmiralZaelKoris", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Koris_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Quarians Alive, Him Alive", 
                  Id = 101, 
                  GUICategoryID = 9, 
                  StartingStrength = 25, 
                  GUIName = $715466, 
                  GUIDescription = $715584, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethArmyCorp", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Geth_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Geth Alive", 
                  Id = 102, 
                  GUICategoryID = 6, 
                  StartingStrength = 300, 
                  GUIName = $715467, 
                  GUIDescription = $715585, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Geth Alive", 
                  Id = 103, 
                  GUICategoryID = 6, 
                  StartingStrength = 300, 
                  GUIName = $715468, 
                  GUIDescription = $715586, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethPrimeC13Unit", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GethPrime_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Geth Alive", 
                  Id = 104, 
                  GUICategoryID = 6, 
                  StartingStrength = 60, 
                  GUIName = $715469, 
                  GUIDescription = $715587, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_QuarianCivilianFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Quarians Alive", 
                  Id = 105, 
                  GUICategoryID = 9, 
                  StartingStrength = 200, 
                  GUIName = $715470, 
                  GUIDescription = $715588, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_QuarianHeavyFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Quarians Alive", 
                  Id = 106, 
                  GUICategoryID = 9, 
                  StartingStrength = 200, 
                  GUIName = $715471, 
                  GUIDescription = $715589, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_QuarianPatrolFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Quarians Alive", 
                  Id = 107, 
                  GUICategoryID = 9, 
                  StartingStrength = 200, 
                  GUIName = $715472, 
                  GUIDescription = $715590, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceFrigateHongKong", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Frigate_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Frigate_256x128", 
                  ModTargets = ({TargetID = 173, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 108, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $617487, 
                  GUIDescription = $720113, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanSphere", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21479), 
                  DebugConditionalDescription = "None", 
                  Id = 109, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719842, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceFrigateLeipzig", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Frigate_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Frigate_256x128", 
                  ModTargets = ({TargetID = 3, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 110, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $617576, 
                  GUIDescription = $720114, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ObeliskOfKarza", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21476), 
                  DebugConditionalDescription = "None", 
                  Id = 111, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719840, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ElcorFlotilla", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (22572), 
                  DebugConditionalDescription = "None", 
                  Id = 112, 
                  GUICategoryID = 0, 
                  StartingStrength = 40, 
                  GUIName = $715473, 
                  GUIDescription = $715591, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CodeOfTheAncients", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21482), 
                  DebugConditionalDescription = "None", 
                  Id = 113, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719844, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CommnicationsArray", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceFlotilla_256x128", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 114, 
                  GUICategoryID = 1, 
                  StartingStrength = 50, 
                  GUIName = $715474, 
                  GUIDescription = $715592, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariScientist", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariNoArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Asari_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 115, 
                  GUICategoryID = 2, 
                  StartingStrength = 25, 
                  GUIName = $715475, 
                  GUIDescription = $715593, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCommandoUnit1", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariArmor_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 116, 
                  GUICategoryID = 2, 
                  StartingStrength = 30, 
                  GUIName = $715476, 
                  GUIDescription = $715594, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCommandoUnit2", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariArmor_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 117, 
                  GUICategoryID = 2, 
                  StartingStrength = 30, 
                  GUIName = $715477, 
                  GUIDescription = $715595, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_EezoTanker", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 118, 
                  GUICategoryID = 0, 
                  StartingStrength = 10000, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Salvage, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_RingsOfAlune", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21485), 
                  DebugConditionalDescription = "None", 
                  Id = 119, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719910, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCruiser1", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariCruiser_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariCruiser_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 120, 
                  GUICategoryID = 2, 
                  StartingStrength = 30, 
                  GUIName = $715478, 
                  GUIDescription = $715596, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariResearchShips", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AllianceFlotilla_256x128", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 121, 
                  GUICategoryID = 2, 
                  StartingStrength = 35, 
                  GUIName = $715479, 
                  GUIDescription = $715597, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCruiser2", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariCruiser_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariCruiser_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 122, 
                  GUICategoryID = 2, 
                  StartingStrength = 30, 
                  GUIName = $715480, 
                  GUIDescription = $715598, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariEngineeringTeam", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariNoArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariNoArmor_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 123, 
                  GUICategoryID = 2, 
                  StartingStrength = 30, 
                  GUIName = $715481, 
                  GUIDescription = $715599, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_HesperiaPeriodStatue", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21488), 
                  DebugConditionalDescription = "None", 
                  Id = 124, 
                  GUICategoryID = 0, 
                  StartingStrength = 15000, 
                  GUIName = $719916, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Artifact, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BioticResearchData", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21535), 
                  DebugConditionalDescription = "None", 
                  Id = 125, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715482, 
                  GUIDescription = $715600, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceMarineRecon", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HumansArmor_256x128", 
                  ModTargets = ({TargetID = 1, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 126, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $719918, 
                  GUIDescription = $715601, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceFrigateTrafalger", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Frigate_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Frigate_256x128", 
                  ModTargets = ({TargetID = 4, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 127, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $719919, 
                  GUIDescription = $720115, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = TRUE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Alliance6thFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Critical Path", 
                  Id = 128, 
                  GUICategoryID = 1, 
                  StartingStrength = 90, 
                  GUIName = $715483, 
                  GUIDescription = $715602, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ReaperBrain", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_ReaperBaby_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "ME2 Base Kept", 
                  Id = 129, 
                  GUICategoryID = 3, 
                  StartingStrength = 110, 
                  GUIName = $715484, 
                  GUIDescription = $715603, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ReaperHeart", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_ReaperBaby_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "ME2 Base Destroyed", 
                  Id = 130, 
                  GUICategoryID = 3, 
                  StartingStrength = 100, 
                  GUIName = $715485, 
                  GUIDescription = $715604, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DrChakwas", 
                  ImagePath = "gui_codex_images.Codex.CDX_Chakwas_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Chakwas off Normandy", 
                  Id = 131, 
                  GUICategoryID = 1, 
                  StartingStrength = 10, 
                  GUIName = $715486, 
                  GUIDescription = $715605, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_OptimizedEezoCapacitors", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Adams Lives", 
                  Id = 132, 
                  GUICategoryID = 3, 
                  StartingStrength = 15, 
                  GUIName = $715487, 
                  GUIDescription = $715606, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusExPatriots", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Cerberus_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Chambers Alive", 
                  Id = 133, 
                  GUICategoryID = 4, 
                  StartingStrength = 10, 
                  GUIName = $715488, 
                  GUIDescription = $715607, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_RogueFighterSquadron", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Fighter_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Fighter_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Cortez Quest", 
                  Id = 134, 
                  GUICategoryID = 1, 
                  StartingStrength = 20, 
                  GUIName = $715489, 
                  GUIDescription = $715608, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_N7SpecialOps", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_N7_512", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (22739), 
                  DebugConditionalDescription = "Play MP", 
                  Id = 135, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $715490, 
                  GUIDescription = $715609, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_External, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusEscapees", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Play Iron Monkey", 
                  Id = 136, 
                  GUICategoryID = 4, 
                  StartingStrength = 0, 
                  GUIName = $720766, 
                  GUIDescription = $720767, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_External, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Iphone
                 }, 
                 {
                  AssetName = "GAWAsset_GeneralSherman", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GenSherman_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "", 
                  Id = 137, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $724891, 
                  GUIDescription = $724892, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_External, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_FaceBook
                 }, 
                 {
                  AssetName = "GAWAsset_BioticSupport", 
                  ImagePath = "", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 1, Value = 50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose support in Jack", 
                  Id = 138, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715610, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SavedTheCouncilInME1", 
                  ImagePath = "gui_codex_images.Codex.CDX_Council_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 2, Value = -25}, 
                                {TargetID = 3, Value = -25}, 
                                {TargetID = 4, Value = -25}, 
                                {TargetID = 173, Value = -25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Saved the Council in ME1", 
                  Id = 139, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715629, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ArrivalNotCompleted", 
                  ImagePath = "gui_codex_images.Codex.CDX_Reapers_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 1, Value = -50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Arrival Was not Completed", 
                  Id = 140, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720124, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KroganClans", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 141, 
                  GUICategoryID = 5, 
                  StartingStrength = 300, 
                  GUIName = $715491, 
                  GUIDescription = $715611, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ClanTurmoil", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 141, Value = -50}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Eve Dies", 
                  Id = 142, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715612, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MassiveExplosion", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Krogan_256x128", 
                  ModTargets = ({TargetID = 141, Value = -250}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Turian Bomb Goes off", 
                  Id = 143, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $678158, 
                  GUIDescription = $715613, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ClanUrdnot", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 144, 
                  GUICategoryID = 5, 
                  StartingStrength = 300, 
                  GUIName = $715492, 
                  GUIDescription = $715614, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_UrdnotBetrayal", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 47, Value = -30}, 
                                {TargetID = 144, Value = -300}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Disable Cure w/ Wrex", 
                  Id = 145, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715630, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MordinSolus", 
                  ImagePath = "gui_codex_images.Codex.CDX_Mordin_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Mordin Lives through Geno2", 
                  Id = 146, 
                  GUICategoryID = 7, 
                  StartingStrength = 25, 
                  GUIName = $715493, 
                  GUIDescription = $715615, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ShadowBrokerWetSquad", 
                  ImagePath = "gui_codex_images.Codex.CDX_Liara_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Liara_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (22571), 
                  DebugConditionalDescription = "Do Barla Von's quest (goal is on Rothla)", 
                  Id = 147, 
                  GUICategoryID = 0, 
                  StartingStrength = 25, 
                  GUIName = $715494, 
                  GUIDescription = $715616, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GruntAlive", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Grunt_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 49, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Grunt is alive", 
                  Id = 148, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715617, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GruntLoyal", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Grunt_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 49, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Grunt is Loyal", 
                  Id = 149, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715618, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SaveQueen", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Rachni_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 49, Value = -25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Saved the Queen", 
                  Id = 150, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715619, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KirraheSavesSalarianCaptain", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Kirrahe_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 24, Value = -20}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Kirrahe saves the salarian councilor", 
                  Id = 151, 
                  GUICategoryID = 7, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_STGTaskForce", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_SalariansArmor_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "New Salarian Councilor Saved", 
                  Id = 152, 
                  GUICategoryID = 7, 
                  StartingStrength = 70, 
                  GUIName = $715495, 
                  GUIDescription = $715620, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdmiralDies", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 105, Value = -75}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "You don’t rescue downed Admiral", 
                  Id = 154, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715622, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethFighters", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 105, Value = -25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Do not do Legion", 
                  Id = 155, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715623, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SupportRaanAgainstHanJorel", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Raan_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Raan_256x128", 
                  ModTargets = ({TargetID = 106, Value = -10}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Suppored Raan against Han Jorel", 
                  Id = 156, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715624, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SupportHanJorelAgainstRaan", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Gerrel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Gerrel_256x128", 
                  ModTargets = ({TargetID = 106, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Suppored Han against Ran", 
                  Id = 157, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715625, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KillXen", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Xen_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Xen_256x128", 
                  ModTargets = ({TargetID = 82, Value = -25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Killed Xen", 
                  Id = 158, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715626, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdvancedAIRelays", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Support Xen against Tali", 
                  Id = 159, 
                  GUICategoryID = 3, 
                  StartingStrength = 45, 
                  GUIName = $715496, 
                  GUIDescription = $715627, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BreederQueenBetrayal", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Rachni_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Rachni_256x128", 
                  ModTargets = ({TargetID = 0, Value = -100}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose to save the breeder queen", 
                  Id = 163, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $678053, 
                  GUIDescription = $715628, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MassiveExplosionA", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Krogan_256x128", 
                  ModTargets = ({TargetID = 144, Value = -250}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Turian Bomb Goes off w/ Wreav", 
                  Id = 167, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $378158, 
                  GUIDescription = $715613, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Salarian3rdFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Salarian Councilor Saved", 
                  Id = 171, 
                  GUICategoryID = 7, 
                  StartingStrength = 125, 
                  GUIName = $715497, 
                  GUIDescription = $715631, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Miranda", 
                  ImagePath = "gui_codex_images.Codex.CDX_Miranda2_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Miranda Lives", 
                  Id = 172, 
                  GUICategoryID = 4, 
                  StartingStrength = 25, 
                  GUIName = $715498, 
                  GUIDescription = $715632, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Alliance5thFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 173, 
                  GUICategoryID = 1, 
                  StartingStrength = 90, 
                  GUIName = $715406, 
                  GUIDescription = $715520, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KroganMercenaries", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Wrex with a real cure", 
                  Id = 174, 
                  GUICategoryID = 5, 
                  StartingStrength = 75, 
                  GUIName = $715499, 
                  GUIDescription = $715633, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KeepXenAlive", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Xen_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Xen_256x128", 
                  ModTargets = ({TargetID = 82, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose to Keep Xen Alive", 
                  Id = 175, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715634, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_LegionIntel1", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21543), 
                  DebugConditionalDescription = "View some recordings in Legion", 
                  Id = 176, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715500, 
                  GUIDescription = $715635, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_LegionIntel2", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21545), 
                  DebugConditionalDescription = "View all recordings in Legion", 
                  Id = 177, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715501, 
                  GUIDescription = $715636, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AdvancedBioticAmps", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (22421), 
                  DebugConditionalDescription = "Do Prototype quest", 
                  Id = 178, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715502, 
                  GUIDescription = $715637, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SpectreTeam", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Spectre_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Spectre_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Saved Spectre's Life", 
                  Id = 179, 
                  GUICategoryID = 0, 
                  StartingStrength = 40, 
                  GUIName = $715503, 
                  GUIDescription = $715638, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Kasumi", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Kasumi_512", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Kasumi_512", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "kasumi alive did her RPG plot and loyal", 
                  Id = 180, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $715504, 
                  GUIDescription = $715639, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Zaeed", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Zaeed_512", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Zaeed_512", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Zaeed Alive,Loyal did RPG plot", 
                  Id = 181, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $715505, 
                  GUIDescription = $715640, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_VolusBombingFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Side with ambassador or persuade", 
                  Id = 182, 
                  GUICategoryID = 0, 
                  StartingStrength = 75, 
                  GUIName = $715506, 
                  GUIDescription = $715641, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DarkEnergyDissertation", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Conrad alive and talked to", 
                  Id = 183, 
                  GUICategoryID = 3, 
                  StartingStrength = 1, 
                  GUIName = $715507, 
                  GUIDescription = $715642, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DarkEnergyDissertationUpgrade", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 183, Value = 4}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Shepard gives extra info from ME1", 
                  Id = 184, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715643, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_HanarAndDrellForces", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Save the Hanar Homeworld", 
                  Id = 185, 
                  GUICategoryID = 0, 
                  StartingStrength = 50, 
                  GUIName = $715508, 
                  GUIDescription = $715644, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DianaAllers", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "When she is collected from the citadel", 
                  Id = 186, 
                  GUICategoryID = 1, 
                  StartingStrength = 5, 
                  GUIName = $715509, 
                  GUIDescription = $715645, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Normandy", 
                  ImagePath = "gui_codex_images.Codex.CDX_Normandy02_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "None", 
                  Id = 187, 
                  GUICategoryID = 1, 
                  StartingStrength = 50, 
                  GUIName = $715510, 
                  GUIDescription = $715646, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_UpgradedThanix", 
                  ImagePath = "gui_codex_images.Codex.CDX_Normandy02_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 187, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Upgraded cannon ME2", 
                  Id = 188, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715647, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusAttack", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Cerberus_256x128", 
                  ModTargets = ({TargetID = 12, Value = -10}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Side with Ambassador or ignore plot", 
                  Id = 190, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715649, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TurianMedigel", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 43, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Finish Citadel Medigel Plot", 
                  Id = 191, 
                  GUICategoryID = 8, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715650, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariCommandos", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariArmor_256x128", 
                  ModTargets = ({TargetID = 78, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Tell Liara to talk to her father", 
                  Id = 192, 
                  GUICategoryID = 2, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715651, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BatarianFleet", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Convince Fleet", 
                  Id = 193, 
                  GUICategoryID = 0, 
                  StartingStrength = 100, 
                  GUIName = $715511, 
                  GUIDescription = $715652, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SabotagedAllianceShips", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HFleet_256x128", 
                  ModTargets = ({TargetID = 4, Value = -10}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Balak survived Bring down the sky", 
                  Id = 194, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715653, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CommanderKahairalBalak", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Balak_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Balak_256x128", 
                  ModTargets = ({TargetID = 193, Value = 15}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Convince Balak to work with you", 
                  Id = 195, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715654, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_UpgradedHeavyShipArmor", 
                  ImagePath = "gui_codex_images.Codex.CDX_Normandy02_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 187, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Upgraded armor ME2", 
                  Id = 199, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715657, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_UpgradedShield", 
                  ImagePath = "gui_codex_images.Codex.CDX_Normandy02_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 187, Value = 25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Upgraded shield ME2", 
                  Id = 200, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715658, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_TechStudentsRescued", 
                  ImagePath = "", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 28, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Help optional students in jack", 
                  Id = 201, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715659, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SandersArcherUpgrade", 
                  ImagePath = "", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 28, Value = 10}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Played Overlord and saved David", 
                  Id = 202, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $715660, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MineralResources", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Mineral2_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "import ME2 save with low level resources", 
                  Id = 203, 
                  GUICategoryID = 1, 
                  StartingStrength = 10, 
                  GUIName = $715512, 
                  GUIDescription = $715661, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MineralResources2", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Mineral2_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "import ME2 save with mid level resources", 
                  Id = 264, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $715512, 
                  GUIDescription = $715661, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MineralResources3", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Mineral2_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "import ME2 save with high level resources", 
                  Id = 265, 
                  GUICategoryID = 1, 
                  StartingStrength = 100, 
                  GUIName = $715512, 
                  GUIDescription = $715661, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_PrejekPaddlefish", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21549), 
                  DebugConditionalDescription = "Paddlefish survive to new game plus", 
                  Id = 204, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $715513, 
                  GUIDescription = $715662, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MatriarchGallaesElectronicSignature", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (21547), 
                  DebugConditionalDescription = "Pickup the intel in Samaras mission", 
                  Id = 205, 
                  GUICategoryID = 2, 
                  StartingStrength = 0, 
                  GUIName = $715514, 
                  GUIDescription = $715663, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ShialaAndZhusHopeColonists", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Shiala_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Shiala_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "", 
                  Id = 206, 
                  GUICategoryID = 1, 
                  StartingStrength = 30, 
                  GUIName = $720076, 
                  GUIDescription = $720081, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CitadelDefenseForce", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "", 
                  Id = 207, 
                  GUICategoryID = 0, 
                  StartingStrength = 10, 
                  GUIName = $720078, 
                  GUIDescription = $720083, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Ashley", 
                  ImagePath = "gui_codex_images.Codex.CDX_Ashley_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Ashley Alive, not in your crew", 
                  Id = 208, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $720079, 
                  GUIDescription = $720084, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Kaiden", 
                  ImagePath = "gui_codex_images.Codex.CDX_Kaidan_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Kaiden Alive, not in your crew", 
                  Id = 209, 
                  GUICategoryID = 1, 
                  StartingStrength = 25, 
                  GUIName = $720080, 
                  GUIDescription = $720085, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Ground, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KhalisahBintSinanAlJilani", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Khalisa_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Paragon interrupt when meeting her, ME3", 
                  Id = 215, 
                  GUICategoryID = 1, 
                  StartingStrength = 5, 
                  GUIName = $720077, 
                  GUIDescription = $720082, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Military, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_Fleet, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_NeverPunchedReporter", 
                  ImagePath = "", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 215, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Never Punched her in ME1 ME2 or ME3", 
                  Id = 266, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720088, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FeronIntel", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = (), 
                  UnlockPlotStates = (22419), 
                  DebugConditionalDescription = "Finish Shadow Broker DLC", 
                  Id = 214, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $720297, 
                  GUIDescription = $720298, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Intel, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethHereticsSaved", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 105, Value = -50}, 
                                {TargetID = 106, Value = -50}, 
                                {TargetID = 107, Value = -50}, 
                                {TargetID = 103, Value = 150}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Saved the Geth in ME2 ", 
                  Id = 210, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720109, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethHereticsDestroyed", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 105, Value = 50}, 
                                {TargetID = 106, Value = 50}, 
                                {TargetID = 107, Value = 50}, 
                                {TargetID = 103, Value = -150}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Destroyed the Geth in ME2", 
                  Id = 216, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720110, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProKroganInterview", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 141, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Krogan interviewed Positively", 
                  Id = 217, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720116, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProKroganInterviewNeedTurians", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 43, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Krogans need the Turians", 
                  Id = 218, 
                  GUICategoryID = 8, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720117, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProSecurityInterview", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 173, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Security Stressed in interview", 
                  Id = 219, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720118, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AntiCerberusInterview", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 1, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Stressed anti cerberus sentiment", 
                  Id = 220, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720119, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethInterviewCooperation", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 103, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Stressed Human Geth Cooperation", 
                  Id = 221, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720120, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethInterviewGethKickAss", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 102, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Stressed Geth are amazing", 
                  Id = 222, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720121, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_QuarianInterviewReadiness", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 105, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Stressed Quarian Readiness", 
                  Id = 223, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720122, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_QuarianInterviewMilitary", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Allers_256x128", 
                  ModTargets = ({TargetID = 106, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Stressed Quarian Military", 
                  Id = 224, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720123, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SupportedCitadelRefugees", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = -2}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Supported Citadel Refugees", 
                  Id = 225, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720125, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CivilianMedicalVolunteers", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Told Volunteers to report to Medical", 
                  Id = 226, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720126, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ReassuredArguingCouple", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 0}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Reassured an arguing couple", 
                  Id = 227, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720127, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AsariPatientSuicide", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = -4}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Asari Patient Suicide", 
                  Id = 228, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720128, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ImproveCivilianMorale", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Restore Active Duty pay to spouses", 
                  Id = 229, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720129, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_AllianceFleetLosses", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HFleet_256x128", 
                  ModTargets = ({TargetID = 4, Value = -4}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Transfer the engy", 
                  Id = 230, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720130, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_LoweredCrime", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Removed a con artist from the citadel", 
                  Id = 231, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720131, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_FewerRefugees", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Got refugees to leave the citadel", 
                  Id = 232, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720132, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SmugglerContacts", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 173, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Helped smugglers", 
                  Id = 233, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720133, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_MedicalSuppliesReleased", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Medical Supplies Released", 
                  Id = 234, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720134, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_IncreasedSurveillance", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Gave Csec permission  to spy", 
                  Id = 235, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720135, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CivilianMilitia", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 7}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Csec can create a militia", 
                  Id = 236, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720136, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_IncreasedCrimeRate", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = -4}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Csec is ignoring weapon sales", 
                  Id = 237, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720137, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GrissomStudentHousing", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Housing given to grissom students", 
                  Id = 238, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720138, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ImprovedTargetingVIs", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_HFleet_256x128", 
                  ModTargets = ({TargetID = 173, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Imporved Targeting Vis", 
                  Id = 239, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720139, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_EnforceEveryLaw", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = -2}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Enforce Every Law", 
                  Id = 240, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720140, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CrackDownOnTerror", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Crack down on terror", 
                  Id = 241, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720141, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CivilianDonations", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 207, Value = 5}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Reassure that money critical to war", 
                  Id = 242, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720142, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CuredTurianGeneral", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = ({TargetID = 12, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Cured Turian General", 
                  Id = 243, 
                  GUICategoryID = 8, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720143, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ReaperCodeFragment", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 78, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Give Reaper Fragment to Asari Command", 
                  Id = 244, 
                  GUICategoryID = 2, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720089, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_GethJammingFrequencies", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_GFleet_256x128", 
                  ModTargets = ({TargetID = 207, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Have Geth upgrade jamming frequencies", 
                  Id = 245, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720090, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusTurretSchematics", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Cerberus_256x128", 
                  ModTargets = ({TargetID = 207, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Give Csec turret schematics ", 
                  Id = 246, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720091, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ImprovedAsariAmps", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AsariArmor_256x128", 
                  ModTargets = ({TargetID = 207, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Get Asari Commandos amp schematics", 
                  Id = 247, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720092, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ImprovedHanarMedicalTech", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 185, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Hanar get medigel", 
                  Id = 248, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720093, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CerberusCiphers", 
                  ImagePath = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Cerberus_256x128", 
                  ModTargets = ({TargetID = 173, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Get Cerberus Encryption Codes", 
                  Id = 249, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720094, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_SalarianColonySupport", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                  ModTargets = ({TargetID = 171, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Save Salarian Egg Clutches", 
                  Id = 250, 
                  GUICategoryID = 7, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720095, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ChemicalBurnTreatments", 
                  ImagePath = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                  ModTargets = ({TargetID = 3, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "improved treatment for chem burns", 
                  Id = 251, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720096, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KroganPowerGrids", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Krogan_256x128", 
                  ModTargets = ({TargetID = 173, Value = 8}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Krogan Power Grids", 
                  Id = 252, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720097, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_Bannerofthe1stRegimentBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 43, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Banner of the 1st Regiment Turned In", 
                  Id = 253, 
                  GUICategoryID = 8, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720098, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_PillarsOfStrengthBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 193, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Pillars of Strength Turned In", 
                  Id = 254, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720099, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BookOfPlenixBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 207, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Book of Plenix Turned In", 
                  Id = 255, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720100, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ImprovedHuntressTraining", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 79, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Library of Asha Turned In", 
                  Id = 256, 
                  GUICategoryID = 2, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720101, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanDataDrivesBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 0, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Prothean Data Drives Turned In", 
                  Id = 257, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720102, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_KaklisaurSkull", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 141, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Fossilized Kaklisaur Turned In", 
                  Id = 258, 
                  GUICategoryID = 5, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720103, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ObeliskOfKarzaBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 0, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "The Obelisk of Karza Turned In", 
                  Id = 259, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720104, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_ProtheanSphereBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 0, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Prothean Sphere turned in", 
                  Id = 260, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720105, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_CodeOfTheAncientsBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 207, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Code of the Ancients Turned In", 
                  Id = 261, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720106, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_RingsOfAluneBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 207, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Rings of Alune turned In", 
                  Id = 262, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720107, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_HesperiaPeriodStatueBonus", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = ({TargetID = 0, Value = 40}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Hesperia Era Statue Turned In", 
                  Id = 263, 
                  GUICategoryID = 1, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $720108, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_BlackMarketArtifacts", 
                  ImagePath = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                  NotificationImagePath = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                  ModTargets = (), 
                  UnlockPlotStates = (22573), 
                  DebugConditionalDescription = "None", 
                  Id = 267, 
                  GUICategoryID = 0, 
                  StartingStrength = 0, 
                  GUIName = $723497, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = TRUE, 
                  Type = EGAWAssetType.GAWAssetType_Quest, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DestroyTheGeth", 
                  ImagePath = "", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 104, Value = -60}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose to Destroy the Geth", 
                  Id = 268, 
                  GUICategoryID = 6, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }, 
                 {
                  AssetName = "GAWAsset_DestroyTheQuarians", 
                  ImagePath = "", 
                  NotificationImagePath = "", 
                  ModTargets = ({TargetID = 101, Value = -25}
                               ), 
                  UnlockPlotStates = (0), 
                  DebugConditionalDescription = "Choose to Destroy the Quarians", 
                  Id = 269, 
                  GUICategoryID = 9, 
                  StartingStrength = 0, 
                  GUIName = $0, 
                  GUIDescription = $0, 
                  CurrentStrength = 0, 
                  MaxStrength = 0, 
                  ConflictZoneID = 0, 
                  bIsExploration = FALSE, 
                  bShowNotificationOnAward = FALSE, 
                  Type = EGAWAssetType.GAWAssetType_Modifier, 
                  SubType = EGAWAssetSubType.GAWAssetSubType_None, 
                  ExternalAssetEnum = GAWExternalAssetID.GAWExternalAssetID_Multiplayer
                 }
                )
    EndGameOptionSets = ({
                          Brain = (EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthDestroyed), 
                          Threshold = 0.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthDestroyed, EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthDestroyed, EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Threshold = 1750.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthDestroyed, EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthDevastated, EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Threshold = 1900.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthDestroyed, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthDevastated, EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave), 
                          Threshold = 2050.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthDevastated, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthDevastated, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave), 
                          Threshold = 2350.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthOk, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthOk, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave), 
                          Threshold = 2650.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthOk, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave, EEndGameOption.EGO_HarmonyOfManAndMachine), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthOk, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave, EEndGameOption.EGO_HarmonyOfManAndMachine), 
                          Threshold = 2800.0
                         }, 
                         {
                          Brain = (EEndGameOption.EGO_ReapersDestroyedEarthOkShepardAlive, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave, EEndGameOption.EGO_HarmonyOfManAndMachine), 
                          Heart = (EEndGameOption.EGO_ReapersDestroyedEarthOkShepardAlive, EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave, EEndGameOption.EGO_HarmonyOfManAndMachine), 
                          Threshold = 5000.0
                         }
                        )
    ShepardLivesStates = (20972, 22775)
    EndGameOptions = ({
                       PlotStates = (20965, 20967, 22773), 
                       Option = EEndGameOption.EGO_ReapersDestroyedEarthDestroyed
                      }, 
                      {
                       PlotStates = (20965, 20968, 22772), 
                       Option = EEndGameOption.EGO_ReapersDestroyedEarthDevastated
                      }, 
                      {
                       PlotStates = (20965, 20969, 22774), 
                       Option = EEndGameOption.EGO_ReapersDestroyedEarthOk
                      }, 
                      {
                       PlotStates = (20965, 20969, 20972, 22775), 
                       Option = EEndGameOption.EGO_ReapersDestroyedEarthOkShepardAlive
                      }, 
                      {
                       PlotStates = (20966, 20967, 20970, 22776), 
                       Option = EEndGameOption.EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave
                      }, 
                      {
                       PlotStates = (20966, 20969, 20970, 22777), 
                       Option = EEndGameOption.EGO_BecomeAReaperAndEarthOkAndReapersLeave
                      }, 
                      {
                       PlotStates = (20971, 22778), 
                       Option = EEndGameOption.EGO_HarmonyOfManAndMachine
                      }, 
                      {
                       PlotStates = (), 
                       Option = EEndGameOption.EGO_None
                      }
                     )
    CutscenePlotStates = ({PlotStateID = 20956, BrainThreshold = 2200, HeartThreshold = 2200}, 
                          {PlotStateID = 20957, BrainThreshold = 2500, HeartThreshold = 2500}, 
                          {PlotStateID = 20960, BrainThreshold = 2050, HeartThreshold = 2050}
                         )
    AllEndingPlotStates = (20965, 
                           20966, 
                           20970, 
                           20967, 
                           20968, 
                           20969, 
                           20971, 
                           20972, 
                           22772, 
                           22773, 
                           22774, 
                           22775, 
                           22776, 
                           22777, 
                           22778
                          )
    GAWTheatreData = ({srZoneName = $710686, srZoneDescription = $710691, ZoneDisplayNumber = 4, ZoneID = EGAWZone.EGAWZone_InnerCouncil}, 
                      {srZoneName = $710689, srZoneDescription = $710694, ZoneDisplayNumber = 1, ZoneID = EGAWZone.EGAWZone_Terminus}, 
                      {srZoneName = $710685, srZoneDescription = $710690, ZoneDisplayNumber = 3, ZoneID = EGAWZone.EGAWZone_Earth}, 
                      {srZoneName = $710687, srZoneDescription = $710692, ZoneDisplayNumber = 5, ZoneID = EGAWZone.EGAWZone_Council}, 
                      {srZoneName = $710688, srZoneDescription = $710693, ZoneDisplayNumber = 2, ZoneID = EGAWZone.EGAWZone_Attican}
                     )
    OverallWarAssetSummaries = ({Summary = $724801, Threshold = 3000}, 
                                {Summary = $724800, Threshold = 2050}, 
                                {Summary = $724799, Threshold = 1750}, 
                                {Summary = $724798, Threshold = 0}
                               )
    AchievementThreshold = 3750
    MinimumStrengthForGUI = 967
    MaxStrengthForGUI = 2800
    SaveAndersonScoreBonus = 1000
    ShepardLivesThreshold = 5000
    SaveAndersonPlotBool = 22738
    FinalGAWRatingID = 10430
    OverallReadinessRating = 50
    GAWExternalAssetStrengthPerTick_Multiplayer = 75
    GAWExternalAssetStrengthPerTick_IPhone = 40
    GAWExternalAssetStrengthPerTick_Facebook = 30
    GUIDescription_Formatter = $347490
    GUIDescription_UpdatedTag = $722349
}