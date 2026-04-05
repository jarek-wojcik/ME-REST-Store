Class SFXProfileSettings extends OnlineProfileSettings
    native
    config(Game);

struct native BonusPowerUnlockData 
{
    var string PowerClassName;
    var int BonusPowerID;
    var int PlotConditionalID;
    var int PlotStateID;
    var stringref srTitle;
};
enum EProfileSetting
{
    Setting_Unknown,
    Setting_ControllerVibration,
    Setting_YInversion,
    Setting_GamerCred,
    Setting_GamerRep,
    Setting_VoiceMuted,
    Setting_VoiceThruSpeakers,
    Setting_VoiceVolume,
    Setting_GamerPictureKey,
    Setting_GamerMotto,
    Setting_GamerTitlesPlayed,
    Setting_GamerAchievementsEarned,
    Setting_GameDifficulty,
    Setting_ControllerSensitivity,
    Setting_PreferredColor1,
    Setting_PreferredColor2,
    Setting_AutoAim,
    Setting_AutoCenter,
    Setting_MovementControl,
    Setting_RaceTransmission,
    Setting_RaceCameraLocation,
    Setting_RaceBrakeControl,
    Setting_RaceAcceleratorControl,
    Setting_GameCredEarned,
    Setting_GameAchievementsEarned,
    Setting_EndLiveIds,
    Setting_ProfileVersionNum,
    Setting_ProfileSaveCount,
    Setting_StickConfiguration,
    Setting_TriggerConfiguration,
    Setting_Subtitles,
    Setting_AimAssist,
    Setting_Difficulty,
    Setting_InitialGameDifficulty,
    Setting_AutoLevel,
    Setting_SquadPowers,
    Setting_AutoSave,
    Setting_MusicVolume,
    Setting_FXVolume,
    Setting_DialogVolume,
    Setting_MotionBlur,
    Setting_FilmGrain,
    Setting_SelectedDeviceID,
    Setting_CurrentCareer,
    Setting_DaysSinceRegistration,
    Setting_AutoLogin,
    Setting_LoginInfo,
    Setting_PersonaID,
    Setting_NucleusRefused,
    Setting_NucleusSuccessful,
    Setting_CerberusRefused,
    Setting_Achievement_FieldA,
    Setting_Achievement_FieldB,
    Setting_Achievement_FieldC,
    Setting_TelemetryCollectionEnabled,
    Setting_KeyBindings,
    Setting_DisplayGamma,
    Setting_CurrentSaveGame,
    Setting_HideCinematicHelmet,
    Setting_ActionIconUIHints,
    Setting_NumGameCompletions,
    Setting_ShowHints,
    Setting_MorinthNotSamara,
    Setting_MaxWeaponUpgradeCount,
    Setting_LastFinishedCareer,
    Setting_SwapTriggersShoulders,
    Setting_PS3_RedeemedProductCode,
    Setting_LastSelectedPawn,
    Setting_ShowScoreIndicators,
    Setting_Accomplishment_FieldA,
    Setting_Accomplishment_FieldB,
    Setting_Accomplishment_FieldC,
    Setting_Accomplishment_FieldD,
    Setting_Accomplishment_FieldE,
    Setting_Accomplishment_FieldF,
    Setting_Accomplishment_FieldG,
    Setting_Accomplishment_FieldH,
    Setting_NumSalvageFound,
    Setting_SPLevel,
    Setting_NumKills,
    Setting_NumMeleeKills,
    Setting_NumShieldsOverloaded,
    Setting_NumEnemiesFlying,
    Setting_NumEnemiesOnFire,
    Setting_CachedDisconnectError,
    Setting_CachedDisconnectFromState,
    Setting_CachedDisconnectToState,
    Setting_CachedDisconnectSessionId,
    Setting_Language_VO,
    Setting_Language_Text,
    Setting_Language_Speech,
    Setting_MPAutoLevel,
    Setting_GalaxyAtWarLevel,
    Setting_N7Rating_LocalUser,
    Setting_N7Rating_FriendBlob,
    Setting_AutoReplyMode,
    Setting_BonusPower,
    Setting_NumGuardianHeadKilled,
    Setting_MPCreateNewMatchPrivacySetting,
    Setting_MPCreateNewMatchMapName,
    Setting_MPCreateNewMatchEnemyType,
    Setting_MPCreateNewMatchDifficulty,
    Setting_HenchmenHelmetOption,
    Setting_AudioDynamicRange,
    Setting_NumPowerCombos,
    Setting_SPMaps,
    Setting_SPMapsCount,
    Setting_NumArmorBought,
    Setting_WeaponLevel,
    Setting_SPMapsInsane,
    Setting_SPMapsInsaneCount,
    Setting_PowerLevel,
    Setting_MPQuickMatchMapName,
    Setting_MPQuickMatchEnemyType,
    Setting_MPQuickMatchDifficulty,
    Setting_KinectTutorialPromptViewed,
    Setting_GAW_Readiness,
    Setting_GAW_ZoneIndex0,
    Setting_GAW_ZoneIndex1,
    Setting_GAW_ZoneIndex2,
    Setting_GAW_ZoneIndex3,
    Setting_GAW_ZoneIndex4,
    Setting_GAW_ZoneIndex5,
    Setting_GAW_AssetMultiplayer,
    Setting_GAW_AssetIPhone,
    Setting_GAW_AssetFacebook,
};
enum EOptionOnOff
{
    OOO_On,
    OOO_Off,
};
enum EOptionYesNo
{
    OYN_Yes,
    OYN_No,
};
enum EAudioDynamicRangeOptions
{
    ADR_High,
    ADR_Low,
};
enum EHenchHelmetOptions
{
    HHO_DefaultOff,
    HHO_DefaultOn,
    HHO_ConversationOff,
};
enum EAutoReplyModeOptions
{
    ARMO_All_Decisions,
    ARMO_Major_Decisions,
    ARMO_No_Decisions,
};
enum ETVType
{
    TVT_Default,
    TVT_Soft,
    TVT_Lucent,
    TVT_Vibrant,
};
enum EAutoLevelOptions
{
    ALO_Off,
    ALO_Squad,
    ALO_All,
};
enum EDifficultyOptions
{
    DO_Level1,
    DO_Level2,
    DO_Level3,
    DO_Level4,
    DO_Level5,
    DO_Level6,
};
enum EAimAssistOptions
{
    AAO_Low,
    AAO_Normal,
    AAO_High,
};
enum ETriggerConfigOptions
{
    TCO_Default,
    TCO_SouthPaw,
    TCO_DefaultSwapped,
    TCO_SouthPawSwapped,
};
enum EStickConfigOptions
{
    SCO_Default,
    SCO_SouthPaw,
};
enum EAchievementID
{
    ACHIEVEMENT_00_PROEAR,
    ACHIEVEMENT_01_PROMAR,
    ACHIEVEMENT_02_KROGAR,
    ACHIEVEMENT_03_KRO001,
    ACHIEVEMENT_04_KRO002,
    ACHIEVEMENT_05_KROGRU,
    ACHIEVEMENT_06_GTH001,
    ACHIEVEMENT_07_GTH002,
    ACHIEVEMENT_08_GTHLEG,
    ACHIEVEMENT_09_CAT003,
    ACHIEVEMENT_10_CAT002,
    ACHIEVEMENT_11_CAT004,
    ACHIEVEMENT_12_CERMIR,
    ACHIEVEMENT_13_CITSAM,
    ACHIEVEMENT_14_OMGJCK,
    ACHIEVEMENT_15_CERJCB,
    ACHIEVEMENT_16_END001,
    ACHIEVEMENT_17_END002,
    ACHIEVEMENT_18_STORE,
    ACHIEVEMENT_19_ENDGAMEMAX,
    ACHIEVEMENT_20_FINDSALVAGE,
    ACHIEVEMENT_21_IMPORT,
    ACHIEVEMENT_22_INSANITY,
    ACHIEVEMENT_23_WEAPONMOD,
    ACHIEVEMENT_24_ROMANCE,
    ACHIEVEMENT_25_POWERCOMBO,
    ACHIEVEMENT_26_MAXPOWER,
    ACHIEVEMENT_27_KILLA,
    ACHIEVEMENT_28_KILLB,
    ACHIEVEMENT_29_KILLC,
    ACHIEVEMENT_30_MELEE,
    ACHIEVEMENT_31_ESCAPEREAPER,
    ACHIEVEMENT_32_MAXSECURITY,
    ACHIEVEMENT_33_OVERLOADSHIELDS,
    ACHIEVEMENT_34_ENEMIESFLYING,
    ACHIEVEMENT_35_ENEMIESONFIRE,
    ACHIEVEMENT_36_BRUTECHARGE,
    ACHIEVEMENT_37_GUARDIANMAILSLOT,
    ACHIEVEMENT_38_HIJACKATLAS,
    ACHIEVEMENT_39_HARVESTER,
    ACHIEVEMENT_40_CREATECHAR,
    ACHIEVEMENT_41_PLAYALLMAPS,
    ACHIEVEMENT_42_PREPARED,
    ACHIEVEMENT_43_MISSIONSA,
    ACHIEVEMENT_44_MISSIONSB,
    ACHIEVEMENT_45_WEAPONMAXED,
    ACHIEVEMENT_46_HIGHLEVEL,
    ACHIEVEMENT_47_MAXLEVEL,
    ACHIEVEMENT_48_NEWGAME,
    ACHIEVEMENT_49_ALLMAPSGOLD,
    AVATAR_00_OMNIBLADE,
    ACHIEVEMENT_DLC_1,
    ACHIEVEMENT_DLC_2,
    ACHIEVEMENT_DLC_3,
    ACHIEVEMENT_DLC_4,
    ACHIEVEMENT_DLC_5,
    ACHIEVEMENT_DLC_6,
    ACHIEVEMENT_DLC_7,
    ACHIEVEMENT_DLC_8,
    ACHIEVEMENT_DLC_9,
    ACHIEVEMENT_DLC_10,
    ACHIEVEMENT_DLC_11,
    ACHIEVEMENT_DLC_12,
    ACHIEVEMENT_DLC_13,
    ACHIEVEMENT_DLC_14,
    ACHIEVEMENT_DLC_15,
    ACHIEVEMENT_DLC_16,
    ACHIEVEMENT_DLC_17,
    ACHIEVEMENT_DLC_18,
    ACHIEVEMENT_DLC_19,
    ACHIEVEMENT_DLC_20,
    ACHIEVEMENT_DLC_21,
    ACHIEVEMENT_DLC_22,
    ACHIEVEMENT_DLC_23,
    ACHIEVEMENT_DLC_24,
    ACHIEVEMENT_DLC_25,
    ACHIEVEMENT_PS3_SPECIAL_N7ELITE_NO_USE,
    ACHIEVEMENT_NONE,
};
const BITS_PER_INT = 32;

var config array<BonusPowerUnlockData> BonusPowerUnlockDataArray;
var int MinReadinessRating;

public event function bool AreHintsEnabled()
{
    local int Value;
    
    GetProfileSettingValueId(61, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public event function EAudioDynamicRangeOptions GetAudioDynamicRangeOption()
{
    local int Value;
    
    GetProfileSettingValueId(103, Value);
    return byte(Value);
}
public event function int GetAutoReplyMode()
{
    local int Value;
    
    GetProfileSettingValueId(95, Value);
    return Value;
}
public event function int GetDialogVolume()
{
    local int Value;
    
    GetProfileSettingValueInt(39, Value);
    return Value;
}
public event function EDifficultyOptions GetDifficultyConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(32, Value);
    return byte(Value);
}
public final native function GetFriendN7RatingBlob(out string userBlob);

public event function int GetFXVolume()
{
    local int Value;
    
    GetProfileSettingValueInt(38, Value);
    return Value;
}
public final native function string GetLanguageSpeech();

public final native function string GetLanguageText();

public final native function string GetLanguageVO();

public event function int GetMusicVolume()
{
    local int Value;
    
    GetProfileSettingValueInt(37, Value);
    return Value;
}
public final native function int GetN7RatingLocalUser();

public event function ETriggerConfigOptions GetTriggerConfigOption()
{
    local ETriggerConfigOptions RetVal;
    local int Value;
    
    GetProfileSettingValueId(29, Value);
    if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        switch (Value)
        {
            case 1:
                RetVal = ETriggerConfigOptions.TCO_SouthPawSwapped;
                break;
            case 2:
                RetVal = ETriggerConfigOptions.TCO_Default;
                break;
            case 3:
                RetVal = ETriggerConfigOptions.TCO_SouthPaw;
                break;
            case 0:
            default:
                RetVal = ETriggerConfigOptions.TCO_DefaultSwapped;
                break;
        }
    }
    else
    {
        switch (Value)
        {
            case 1:
                RetVal = ETriggerConfigOptions.TCO_SouthPaw;
                break;
            case 2:
                RetVal = ETriggerConfigOptions.TCO_DefaultSwapped;
                break;
            case 3:
                RetVal = ETriggerConfigOptions.TCO_SouthPawSwapped;
                break;
            case 0:
            default:
                RetVal = ETriggerConfigOptions.TCO_Default;
                break;
        }
    }
    return RetVal;
}
public event function bool IsPlotStateIDABonusPowerPlotStateID(int PlotStateID)
{
    local int idx;
    
    for (idx = 0; idx < BonusPowerUnlockDataArray.Length; idx++)
    {
        if (BonusPowerUnlockDataArray[idx].PlotStateID == PlotStateID)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public event function SetAutoReplyMode(int mode)
{
    SetProfileSettingValueId(95, int(byte(mode)));
}
public final native function SetFriendN7RatingBlob(string userBlob);

public final native function SetLanguageSpeech(string Language);

public final native function SetLanguageText(string Language);

public final native function SetLanguageVO(string Language);

public final native function SetN7RatingLocalUser(int n7Rating);

public final native function SetToDefaultsEx(const out array<EProfileSetting> lstProfileSettingsToReset);

public event function SetTriggerConfigOption(ETriggerConfigOptions eOption)
{
    if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        switch (eOption)
        {
            case ETriggerConfigOptions.TCO_SouthPaw:
                eOption = ETriggerConfigOptions.TCO_SouthPawSwapped;
                break;
            case ETriggerConfigOptions.TCO_DefaultSwapped:
                eOption = ETriggerConfigOptions.TCO_Default;
                break;
            case ETriggerConfigOptions.TCO_SouthPawSwapped:
                eOption = ETriggerConfigOptions.TCO_SouthPaw;
                break;
            case ETriggerConfigOptions.TCO_Default:
            default:
                eOption = ETriggerConfigOptions.TCO_DefaultSwapped;
                break;
        }
    }
    SetProfileSettingValueId(29, int(eOption));
}
private final function int GetAccomplishmentSettingField(int AccomplishmentIndex)
{
    local int ProfileId;
    
    ProfileId = 69 + AccomplishmentIndex / 32;
    if (ProfileId > 76)
    {
    }
    return ProfileId;
}
public final function bool GetActionIconHintOption()
{
    local int Value;
    
    GetProfileSettingValueId(59, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function EAimAssistOptions GetAimAssistValue()
{
    local int Value;
    
    GetProfileSettingValueId(31, Value);
    return byte(Value);
}
public function EAutoLevelOptions GetAutoLevelConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(34, Value);
    return byte(Value);
}
public function bool GetAutoLoginConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(45, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool GetAutoSaveConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(36, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function GetBonusPowerArray(out array<BonusPowerUnlockData> OutBonusPowers)
{
    local int idx;
    
    for (idx = 0; idx < BonusPowerUnlockDataArray.Length; idx++)
    {
        OutBonusPowers.AddItem(BonusPowerUnlockDataArray[idx]);
    }
}
public function bool GetChoseMorinthNotSamara()
{
    local int Value;
    
    if (GetProfileSettingValueId(62, Value))
    {
        if (Value == 1)
        {
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}
public function EProfileControllerSensitivityOptions GetControllerSensitivityValue()
{
    local EProfileControllerSensitivityOptions RetVal;
    local int Value;
    
    GetProfileSettingValueId(13, Value);
    switch (Value)
    {
        case 1:
            RetVal = EProfileControllerSensitivityOptions.PCSO_Low;
            break;
        case 2:
            RetVal = EProfileControllerSensitivityOptions.PCSO_High;
            break;
        case 0:
        default:
            RetVal = EProfileControllerSensitivityOptions.PCSO_Medium;
            break;
    }
    return RetVal;
}
public function bool GetControllerVibrationOption()
{
    local bool RetVal;
    local int Value;
    
    GetProfileSettingValueId(1, Value);
    switch (Value)
    {
        case 0:
            RetVal = FALSE;
            break;
        case 3:
        default:
            RetVal = TRUE;
            break;
    }
    return RetVal;
}
public function string GetCurrentCareerName()
{
    local string Value;
    
    if (GetProfileSettingValue(43, Value))
    {
        return Value;
    }
    return "";
}
public function int GetCurrentDeviceID()
{
    local int Value;
    
    if (GetProfileSettingValueInt(42, Value))
    {
        return Value;
    }
    return -1;
}
public function float GetDisplayGamma()
{
    local float Value;
    
    GetProfileSettingValueFloat(56, Value);
    return Value;
}
public function bool GetFilmgrainConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(41, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function string GetFinishedGameCareerName()
{
    local string Value;
    
    if (GetProfileSettingValue(64, Value))
    {
        return Value;
    }
    return "";
}
public function bool GetHasSeenKinectTutorialPrompt()
{
    local int Value;
    
    if (GetProfileSettingValueInt(115, Value))
    {
        return Value == 0 ? FALSE : TRUE;
    }
    return FALSE;
}
public function EHenchHelmetOptions GetHenchmenHelmetOption()
{
    local int Value;
    
    GetProfileSettingValueId(102, Value);
    return byte(Value);
}
public function bool GetHideCinematicHelmet()
{
    local int Value;
    
    GetProfileSettingValueId(58, Value);
    if (Value == 0)
    {
        return TRUE;
    }
    return FALSE;
}
public function int GetHighestWeaponLevel()
{
    local int Value;
    
    if (GetProfileSettingValueInt(108, Value))
    {
        return Value;
    }
    return -1;
}
public function bool GetInvertYOption()
{
    local bool RetVal;
    local int Value;
    
    GetProfileSettingValueId(2, Value);
    switch (Value)
    {
        case 0:
            RetVal = FALSE;
            break;
        case 1:
        default:
            RetVal = TRUE;
            break;
    }
    return RetVal;
}
public function string GetLastSelectedCharacter()
{
    local string Value;
    
    GetProfileSettingValue(67, Value);
    return Value;
}
public function bool GetMotionBlurConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(40, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function EOptionOnOff GetMPAutoLevelConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(91, Value);
    return byte(Value);
}
public function int GetNumArmorBought()
{
    local int Value;
    
    if (GetProfileSettingValueInt(107, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumEnemiesFlying()
{
    local int Value;
    
    if (GetProfileSettingValueInt(82, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumEnemiesOnFire()
{
    local int Value;
    
    if (GetProfileSettingValueInt(83, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumGameCompletions()
{
    local int Value;
    
    if (GetProfileSettingValueInt(60, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumGuardianHeadKilled()
{
    local int Value;
    
    if (GetProfileSettingValueInt(97, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumKills()
{
    local int Value;
    
    if (GetProfileSettingValueInt(79, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumMeleeKills()
{
    local int Value;
    
    if (GetProfileSettingValueInt(80, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumPowerCombos()
{
    local int Value;
    
    if (GetProfileSettingValueInt(104, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumSalvageFound()
{
    local int Value;
    
    if (GetProfileSettingValueInt(77, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumShieldsOverloaded()
{
    local int Value;
    
    if (GetProfileSettingValueInt(81, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumSPMapsComplete()
{
    local int Value;
    
    if (GetProfileSettingValueInt(106, Value))
    {
        return Value;
    }
    return -1;
}
public function int GetNumSPMapsInsane()
{
    local int Value;
    
    if (GetProfileSettingValueInt(109, Value))
    {
        return Value;
    }
    return -1;
}
public function bool GetShowScoreIndicators()
{
    local int Value;
    
    GetProfileSettingValueId(68, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function int GetSPLevel()
{
    local int Value;
    
    if (GetProfileSettingValueInt(78, Value))
    {
        return Value;
    }
    return -1;
}
public function bool GetSquadPowerConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(35, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function EStickConfigOptions GetStickConfigOption()
{
    local EStickConfigOptions RetVal;
    local int Value;
    
    GetProfileSettingValueId(28, Value);
    switch (Value)
    {
        case 1:
            RetVal = EStickConfigOptions.SCO_SouthPaw;
            break;
        case 0:
        default:
            RetVal = EStickConfigOptions.SCO_Default;
            break;
    }
    return RetVal;
}
public function bool GetSubtitleConfigOption()
{
    local int Value;
    
    GetProfileSettingValueId(30, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool GetSwappedCrossCircle()
{
    return Class'BioPlayerInput'.static.IsEnterMenuButtonAssignmentSwapped();
}
public function bool GetSwappedTriggersShoulders()
{
    local int Value;
    
    GetProfileSettingValueId(65, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public final function bool HasCompletedAccomplishment(int AccomplishmentIndex)
{
    local int ProfileId;
    local int CompletionMask;
    
    ProfileId = GetAccomplishmentSettingField(AccomplishmentIndex);
    if (GetProfileSettingValueInt(ProfileId, CompletionMask))
    {
        return (CompletionMask & 1 << AccomplishmentIndex %  32) != 0;
    }
    return FALSE;
}
public final function bool IsBonusPowerUnlocked(int BonusPowerID)
{
    local int UnlockedPowers;
    
    GetProfileSettingValueInt(96, UnlockedPowers);
    if ((UnlockedPowers & BonusPowerID) == BonusPowerID)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function bool IsTelemetryCollectionEnabled()
{
    local int Value;
    
    GetProfileSettingValueId(54, Value);
    if (Value == 1)
    {
        return FALSE;
    }
    return TRUE;
}
public final function LoadGalaxyAtWarRatings(optional out int OverallReadiness, optional out array<int> ZoneRatings, optional out array<int> WarAssets)
{
    local int StoredValue;
    
    GetProfileSettingValueInt(116, OverallReadiness);
    GetProfileSettingValueInt(117, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(118, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(119, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(120, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(121, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(122, StoredValue);
    ZoneRatings.AddItem(StoredValue);
    GetProfileSettingValueInt(123, StoredValue);
    WarAssets.AddItem(StoredValue);
    GetProfileSettingValueInt(124, StoredValue);
    WarAssets.AddItem(StoredValue);
    GetProfileSettingValueInt(125, StoredValue);
    WarAssets.AddItem(StoredValue);
    OverallReadiness = Max(OverallReadiness, MinReadinessRating);
    ZoneRatings[0] = Max(ZoneRatings[0], MinReadinessRating);
    ZoneRatings[1] = Max(ZoneRatings[1], MinReadinessRating);
    ZoneRatings[2] = Max(ZoneRatings[2], MinReadinessRating);
    ZoneRatings[3] = Max(ZoneRatings[3], MinReadinessRating);
    ZoneRatings[4] = Max(ZoneRatings[4], MinReadinessRating);
    ZoneRatings[5] = Max(ZoneRatings[5], MinReadinessRating);
}
public final function SaveGalaxyAtWarRatings(bool bUpdateOverall, bool bUpdateZones, bool bUpdateWarAssets, optional int OverallReadiness, optional array<int> ZoneRatings, optional array<int> WarAssets)
{
    if (bUpdateOverall)
    {
        SetProfileSettingValueInt(116, Max(OverallReadiness, MinReadinessRating));
    }
    if (bUpdateZones)
    {
        if (ZoneRatings.Length > 5)
        {
            SetProfileSettingValueInt(122, Max(ZoneRatings[5], MinReadinessRating));
        }
        if (ZoneRatings.Length > 4)
        {
            SetProfileSettingValueInt(121, Max(ZoneRatings[4], MinReadinessRating));
        }
        if (ZoneRatings.Length > 3)
        {
            SetProfileSettingValueInt(120, Max(ZoneRatings[3], MinReadinessRating));
        }
        if (ZoneRatings.Length > 2)
        {
            SetProfileSettingValueInt(119, Max(ZoneRatings[2], MinReadinessRating));
        }
        if (ZoneRatings.Length > 1)
        {
            SetProfileSettingValueInt(118, Max(ZoneRatings[1], MinReadinessRating));
        }
        if (ZoneRatings.Length > 0)
        {
            SetProfileSettingValueInt(117, Max(ZoneRatings[0], MinReadinessRating));
        }
    }
    if (bUpdateWarAssets)
    {
        if (WarAssets.Length > 0)
        {
            SetProfileSettingValueInt(123, WarAssets[0]);
        }
        if (WarAssets.Length > 1)
        {
            SetProfileSettingValueInt(124, WarAssets[1]);
        }
        if (WarAssets.Length > 2)
        {
            SetProfileSettingValueInt(125, WarAssets[2]);
        }
    }
}
public final function bool SetAccomplishmentCompleted(int AccomplishmentIndex, BioPlayerController PC, optional bool bSaveProfile = TRUE)
{
    local int ProfileId;
    local int CompletionMask;
    
    if (HasCompletedAccomplishment(AccomplishmentIndex) == FALSE)
    {
        ProfileId = GetAccomplishmentSettingField(AccomplishmentIndex);
        GetProfileSettingValueInt(ProfileId, CompletionMask);
        SetProfileSettingValueInt(ProfileId, CompletionMask | 1 << AccomplishmentIndex %  32);
        if (bSaveProfile)
        {
            PC.SaveProfile(TRUE, FALSE);
        }
        return TRUE;
    }
    return FALSE;
}
public final function bool SetAccomplishmentUncompleted(int AccomplishmentIndex, BioPlayerController PC, optional bool bSaveProfile = TRUE)
{
    local int ProfileId;
    local int CompletionMask;
    
    if (HasCompletedAccomplishment(AccomplishmentIndex) == TRUE)
    {
        ProfileId = GetAccomplishmentSettingField(AccomplishmentIndex);
        GetProfileSettingValueInt(ProfileId, CompletionMask);
        SetProfileSettingValueInt(ProfileId, CompletionMask & ~(1 << AccomplishmentIndex %  32));
        if (bSaveProfile)
        {
            PC.SaveProfile(TRUE, FALSE);
        }
        return TRUE;
    }
    return FALSE;
}
public function SetAutoSaveConfigOption(bool bAutoSave)
{
    local int Value;
    
    Value = bAutoSave ? 0 : 1;
    SetProfileSettingValueId(36, Value);
}
public function SetChoseMorinthNotSamara(bool ChoseMorinth)
{
    local int Value;
    
    if (ChoseMorinth)
    {
        Value = 0;
    }
    else
    {
        Value = 1;
    }
    SetProfileSettingValueId(62, Value);
}
public function SetCurrentCareerName(string CareerName)
{
    local string CurValue;
    
    GetProfileSettingValue(43, CurValue);
    if (CurValue != CareerName)
    {
        SetProfileSettingValue(43, CareerName);
    }
}
public function SetCurrentDeviceID(int DeviceID, BioPlayerController PC)
{
    local int CurValue;
    
    GetProfileSettingValueInt(42, CurValue);
    if (CurValue != DeviceID)
    {
        SetProfileSettingValueInt(42, DeviceID);
        PC.SaveProfile();
    }
}
public function SetDifficultyConfigOption(int Value)
{
    if (Value > -1 && Value < 6)
    {
        SetProfileSettingValueId(32, int(byte(Value)));
    }
}
public function SetHasSeenKinectTutorialPrompt(bool bHasSeen)
{
    SetProfileSettingValueInt(115, bHasSeen ? 1 : 0);
}
public function SetHenchmenHelmetOption(EHenchHelmetOptions InValue)
{
    SetProfileSettingValueId(102, int(InValue));
}
public function SetHideCinematicHelmet(bool bHideCinematicHelmet)
{
    local int Value;
    
    if (bHideCinematicHelmet)
    {
        Value = 0;
    }
    else
    {
        Value = 1;
    }
    SetProfileSettingValueId(58, Value);
}
public function SetLastSelectedCharacter(string NewValue)
{
    SetProfileSettingValue(67, NewValue);
}
public function SetShowHints(bool bEnabled)
{
    local int Value;
    
    if (bEnabled)
    {
        Value = 0;
    }
    else
    {
        Value = 1;
    }
    SetProfileSettingValueId(61, Value);
}
public function SetShowScoreIndicators(bool bShowIndicators)
{
    local int Value;
    
    if (bShowIndicators)
    {
        Value = 0;
    }
    else
    {
        Value = 1;
    }
    SetProfileSettingValueId(68, Value);
}
public function SetTelemetryCollection(bool bEnabled)
{
    local int Value;
    
    if (bEnabled)
    {
        Value = 0;
    }
    else
    {
        Value = 1;
    }
    SetProfileSettingValueId(54, Value);
}
public final function UnlockBonusPower(int BonusPowerID)
{
    local int UnlockedPowers;
    
    GetProfileSettingValueInt(96, UnlockedPowers);
    UnlockedPowers = UnlockedPowers | BonusPowerID;
    SetProfileSettingValueInt(96, UnlockedPowers);
}
public final function UpdateBonusPowerPlotStates()
{
    local int idx;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    
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
    for (idx = 0; idx < BonusPowerUnlockDataArray.Length; idx++)
    {
        if (IsBonusPowerUnlocked(BonusPowerUnlockDataArray[idx].BonusPowerID) == TRUE)
        {
            VarTable.SetBool(BonusPowerUnlockDataArray[idx].PlotStateID, TRUE, FALSE, TRUE);
            continue;
        }
        VarTable.SetBool(BonusPowerUnlockDataArray[idx].PlotStateID, FALSE, FALSE, TRUE);
    }
}
public final function UpdateBonusPowerProfileSettings()
{
    local int idx;
    local BioWorldInfo WI;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    for (idx = 0; idx < BonusPowerUnlockDataArray.Length; idx++)
    {
        if (WI.CheckConditional(BonusPowerUnlockDataArray[idx].PlotConditionalID) == TRUE)
        {
            UnlockBonusPower(BonusPowerUnlockDataArray[idx].BonusPowerID);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BonusPowerUnlockDataArray = ({PowerClassName = "SFXGameContent.SFXPowerCustomAction_Carnage", BonusPowerID = 1, PlotConditionalID = 1282, PlotStateID = 22113, srTitle = $668831}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Marksman", BonusPowerID = 2, PlotConditionalID = 1278, PlotStateID = 22109, srTitle = $572088}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_ProximityMine", BonusPowerID = 4, PlotConditionalID = 1274, PlotStateID = 22105, srTitle = $572665}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Decoy", BonusPowerID = 8, PlotConditionalID = 1272, PlotStateID = 22103, srTitle = $674631}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_ProtectorDrone", BonusPowerID = 16, PlotConditionalID = 1270, PlotStateID = 22101, srTitle = $663224}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_EnergyDrain", BonusPowerID = 32, PlotConditionalID = 1269, PlotStateID = 22100, srTitle = $205894}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_InfernoGrenade", BonusPowerID = 64, PlotConditionalID = 1277, PlotStateID = 22108, srTitle = $349055}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Reave", BonusPowerID = 128, PlotConditionalID = 1276, PlotStateID = 22107, srTitle = $314878}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Stasis", BonusPowerID = 256, PlotConditionalID = 1280, PlotStateID = 22111, srTitle = $127059}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_WarpAmmo", BonusPowerID = 512, PlotConditionalID = 1279, PlotStateID = 22110, srTitle = $501005}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Barrier", BonusPowerID = 1024, PlotConditionalID = 1275, PlotStateID = 22106, srTitle = $93973}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_GethShieldBoost", BonusPowerID = 2048, PlotConditionalID = 1271, PlotStateID = 22102, srTitle = $314066}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Fortification", BonusPowerID = 4096, PlotConditionalID = 1281, PlotStateID = 22112, srTitle = $314036}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_ArmorPiercingAmmo", BonusPowerID = 8192, PlotConditionalID = 1273, PlotStateID = 22104, srTitle = $93965}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_Slam", BonusPowerID = 16384, PlotConditionalID = 1283, PlotStateID = 22114, srTitle = $542178}, 
                                 {PowerClassName = "SFXGameContent.SFXPowerCustomAction_DarkChannel", BonusPowerID = 32768, PlotConditionalID = 1284, PlotStateID = 22115, srTitle = $716448}
                                )
    MinReadinessRating = 50
    ProfileSettingIds = (1, 
                         2, 
                         13, 
                         28, 
                         29, 
                         30, 
                         31, 
                         32, 
                         34, 
                         35, 
                         36, 
                         37, 
                         38, 
                         39, 
                         56, 
                         40, 
                         41, 
                         42, 
                         43, 
                         44, 
                         45, 
                         46, 
                         47, 
                         48, 
                         49, 
                         50, 
                         51, 
                         52, 
                         53, 
                         54, 
                         55, 
                         62, 
                         63, 
                         60, 
                         64, 
                         65, 
                         57, 
                         66, 
                         67, 
                         68, 
                         58, 
                         59, 
                         69, 
                         70, 
                         71, 
                         72, 
                         73, 
                         74, 
                         75, 
                         76, 
                         77, 
                         78, 
                         79, 
                         80, 
                         81, 
                         82, 
                         83, 
                         84, 
                         85, 
                         86, 
                         87, 
                         88, 
                         89, 
                         90, 
                         91, 
                         92, 
                         93, 
                         94, 
                         95, 
                         96, 
                         97, 
                         98, 
                         99, 
                         100, 
                         101, 
                         102, 
                         103, 
                         104, 
                         105, 
                         106, 
                         107, 
                         108, 
                         109, 
                         110, 
                         111, 
                         112, 
                         113, 
                         114, 
                         61, 
                         115, 
                         116, 
                         117, 
                         118, 
                         119, 
                         120, 
                         121, 
                         122, 
                         123, 
                         124, 
                         125
                        )
    DefaultSettings = ({
                        ProfileSetting = {
                                          Data = {Value1 = 3, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 1, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_OnlineService
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 2, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_OnlineService
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 13, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_OnlineService
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 28, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 29, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 30, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 31, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 2, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 32, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 34, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 35, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 36, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 100, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 37, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 100, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 38, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 100, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 39, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1074580685, Type = ESettingsDataType.SDT_Float}, 
                                          PropertyId = 56, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 40, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 41, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = -1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 42, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 43, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = -1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 44, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 45, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Blob}, 
                                          PropertyId = 46, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Blob}, 
                                          PropertyId = 47, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 48, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 49, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 50, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 51, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 52, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 53, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 54, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Blob}, 
                                          PropertyId = 55, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 62, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 63, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 60, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 64, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 65, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 57, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 66, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 67, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 68, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 58, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 59, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 69, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 70, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 71, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 72, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 73, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 74, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 75, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 76, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 77, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 78, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 79, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 80, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 81, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 82, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 83, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 84, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 85, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 86, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Blob}, 
                                          PropertyId = 87, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 88, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 89, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_String}, 
                                          PropertyId = 90, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 91, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 92, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 93, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Blob}, 
                                          PropertyId = 94, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 95, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 96, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 97, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 98, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 99, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 100, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 101, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 102, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 103, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 104, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 105, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 106, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 107, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 108, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 109, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 110, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 111, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = -1, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 112, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 4, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 113, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 3, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 114, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 61, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 115, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 116, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 117, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 118, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 119, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 120, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 121, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 122, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 123, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 124, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }, 
                       {
                        ProfileSetting = {
                                          Data = {Value1 = 0, Type = ESettingsDataType.SDT_Int32}, 
                                          PropertyId = 125, 
                                          AdvertisementType = EOnlineDataAdvertisementType.ODAT_DontAdvertise
                                         }, 
                        Owner = EOnlineProfilePropertyOwner.OPPO_Game
                       }
                      )
    ProfileMappings = ({
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 3}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Controller Vibration', 
                        Id = 1, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Invert Y', 
                        Id = 2, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'No', Id = 1}, 
                                         {Name = 'Yes', Id = 0}, 
                                         {Name = 'None', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Controller Sensitivity', 
                        Id = 13, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 1}, 
                                         {Name = 'Both', Id = 0}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Stick Configuration', 
                        Id = 28, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}, 
                                         {Name = 'None', Id = 2}, 
                                         {Name = 'None', Id = 3}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Trigger Configuration', 
                        Id = 29, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Normal', Id = 0}, 
                                         {Name = 'Easy', Id = 1}, 
                                         {Name = 'Hard', Id = 0}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Subtitles', 
                        Id = 30, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Medium', Id = 0}, 
                                         {Name = 'Low', Id = 1}, 
                                         {Name = 'High', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Aim Assist', 
                        Id = 31, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'Black', Id = 1}, 
                                         {Name = 'White', Id = 2}, 
                                         {Name = 'Yellow', Id = 3}, 
                                         {Name = 'Orange', Id = 4}, 
                                         {Name = 'Pink', Id = 5}, 
                                         {Name = 'Red', Id = 0}, 
                                         {Name = 'Purple', Id = 0}, 
                                         {Name = 'Blue', Id = 0}, 
                                         {Name = 'Green', Id = 0}, 
                                         {Name = 'Brown', Id = 0}, 
                                         {Name = 'Silver', Id = 0}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Difficulty', 
                        Id = 32, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'Black', Id = 1}, 
                                         {Name = 'White', Id = 2}, 
                                         {Name = 'Yellow', Id = 0}, 
                                         {Name = 'Orange', Id = 0}, 
                                         {Name = 'Pink', Id = 0}, 
                                         {Name = 'Red', Id = 0}, 
                                         {Name = 'Purple', Id = 0}, 
                                         {Name = 'Blue', Id = 0}, 
                                         {Name = 'Green', Id = 0}, 
                                         {Name = 'Brown', Id = 0}, 
                                         {Name = 'Silver', Id = 0}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Auto Levelup', 
                        Id = 34, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Squad Uses Powers', 
                        Id = 35, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Auto Save', 
                        Id = 36, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Left Thumbstick', Id = 0}, 
                                         {Name = 'Right Thumbstick', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Music Volume', 
                        Id = 37, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Auto', Id = 0}, 
                                         {Name = 'Manual', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'FX Volume,', 
                        Id = 38, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Behind', Id = 0}, 
                                         {Name = 'Front', Id = 1}, 
                                         {Name = 'Inside', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Dialog Volume', 
                        Id = 39, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Trigger', Id = 0}, 
                                         {Name = 'Button', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Display Gamma', 
                        Id = 56, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Trigger', Id = 0}, 
                                         {Name = 'Button', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Motion Blur', 
                        Id = 40, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Film Grain', 
                        Id = 41, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'SelectedDeviceID', 
                        Id = 42, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Current Career', 
                        Id = 43, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Calendar Unlocks', 
                        Id = 44, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Auto Login', 
                        Id = 45, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Login Info', 
                        Id = 46, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Persona Info', 
                        Id = 47, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Nucleus Refused', 
                        Id = 48, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Nucleus Successful', 
                        Id = 49, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Cerberus Refused', 
                        Id = 50, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Achievement Bitfield A', 
                        Id = 51, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Achievement Bitfield B', 
                        Id = 52, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Achievement Bitfield C', 
                        Id = 53, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Telemetry', 
                        Id = 54, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Key Bindings', 
                        Id = 55, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Plot: Chose Morinth not Samara', 
                        Id = 62, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Weapon Upgrades', 
                        Id = 63, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number Times Completed Game', 
                        Id = 60, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Finished Game Career', 
                        Id = 64, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Swap trigger buttons with shoulder buttons', 
                        Id = 65, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Current Save Game', 
                        Id = 57, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'PS3 code redeemed', 
                        Id = 66, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Last Selected Pawn', 
                        Id = 67, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Show Score Indicators', 
                        Id = 68, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Use Helmets in Conversations', 
                        Id = 58, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Show Action UI Hints', 
                        Id = 59, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield A', 
                        Id = 69, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield B', 
                        Id = 70, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield C', 
                        Id = 71, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield D', 
                        Id = 72, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield E', 
                        Id = 73, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield F', 
                        Id = 74, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield G', 
                        Id = 75, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Accomplishment Bitfield H', 
                        Id = 76, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Salvage Found From Scanning', 
                        Id = 77, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Shepard\'s Level', 
                        Id = 78, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Total Kills', 
                        Id = 79, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Melee Kills', 
                        Id = 80, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Shields Hit with Overload', 
                        Id = 81, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Enemies Ragdolled by Powers', 
                        Id = 82, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Enemies Set on Fire', 
                        Id = 83, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached BLAZE disconnect error', 
                        Id = 84, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached BLAZE disconnect From State', 
                        Id = 85, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached BLAZE disconnect To State', 
                        Id = 86, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached BLAZE disconnect Telemetry Session Id', 
                        Id = 87, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Voice Over Language', 
                        Id = 88, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Text Language', 
                        Id = 89, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Speech Language', 
                        Id = 90, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'MP Auto Levelup', 
                        Id = 91, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Galaxy at war readiness', 
                        Id = 92, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'N7 Rating', 
                        Id = 93, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'N7 Friend Ratings Blob', 
                        Id = 94, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}, 
                                         {Name = 'None', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Narrative Auto Reply Mode', 
                        Id = 95, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Bonus Power Bitmask', 
                        Id = 96, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Guardian Headshot Kills Through the Shield', 
                        Id = 97, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default create new match privacy setting', 
                        Id = 98, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default create new match map', 
                        Id = 99, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default create new match enemy', 
                        Id = 100, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default create new match difficulty', 
                        Id = 101, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Henchmen Helmet Options', 
                        Id = 102, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Audio Dynamic Range', 
                        Id = 103, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Biotic Combos or Tech Bursts', 
                        Id = 104, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Which N7 Missions Completed', 
                        Id = 105, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of N7 Missions Completed', 
                        Id = 106, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Non-Customizable Suits of Armor Purchased', 
                        Id = 107, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Level of Highest Weapon', 
                        Id = 108, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Which Maps (not just N7) Completed at Insanity', 
                        Id = 109, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Number of Maps (not just N7) Completed at Insanity', 
                        Id = 110, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Level of Highest Power', 
                        Id = 111, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default quick match map', 
                        Id = 112, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default quick match enemy', 
                        Id = 113, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Default quick match difficulty', 
                        Id = 114, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'None', Id = 0}, 
                                         {Name = 'None', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Hints', 
                        Id = 61, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Has the user seen the Kinect tutorial message', 
                        Id = 115, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Value of Readiness Rating for Galaxy At War', 
                        Id = 116, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 1 Readiness Rating', 
                        Id = 117, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 2 Readiness Rating', 
                        Id = 118, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 3 Readiness Rating', 
                        Id = 119, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 4 Readiness Rating', 
                        Id = 120, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 5 Readiness Rating', 
                        Id = 121, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached Zone 6 Readiness Rating', 
                        Id = 122, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached ticks for the GAW Multiplayer Asset', 
                        Id = 123, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached ticks for the GAW IPhone Asset', 
                        Id = 124, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Cached ticks for the GAW Facebook Asset', 
                        Id = 125, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }
                      )
    VersionNumber = 45
}