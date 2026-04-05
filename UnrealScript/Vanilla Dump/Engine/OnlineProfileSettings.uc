Class OnlineProfileSettings extends OnlinePlayerStorage
    native;

enum EProfileVoiceThruSpeakersOptions
{
    PVTSO_Off,
    PVTSO_On,
    PVTSO_Both,
};
enum EProfileControllerVibrationToggleOptions
{
    PCVTO_Off,
    PCVTO_IgnoreThis,
    PCVTO_IgnoreThis2,
    PCVTO_On,
};
enum EProfileXInversionOptions
{
    PXIO_Off,
    PXIO_On,
};
enum EProfileYInversionOptions
{
    PYIO_Off,
    PYIO_On,
};
enum EProfileRaceAcceleratorControlOptions
{
    PRACO_Trigger,
    PRACO_Button,
};
enum EProfileRaceBrakeControlOptions
{
    PRBCO_Trigger,
    PRBCO_Button,
};
enum EProfileRaceCameraLocationOptions
{
    PRCLO_Behind,
    PRCLO_Front,
    PRCLO_Inside,
};
enum EProfileRaceTransmissionOptions
{
    PRTO_Auto,
    PRTO_Manual,
};
enum EProfileMovementControlOptions
{
    PMCO_L_Thumbstick,
    PMCO_R_Thumbstick,
};
enum EProfileAutoCenterOptions
{
    PACO_Off,
    PACO_On,
};
enum EProfileAutoAimOptions
{
    PAAO_Off,
    PAAO_On,
};
enum EProfilePreferredColorOptions
{
    PPCO_None,
    PPCO_Black,
    PPCO_White,
    PPCO_Yellow,
    PPCO_Orange,
    PPCO_Pink,
    PPCO_Red,
    PPCO_Purple,
    PPCO_Blue,
    PPCO_Green,
    PPCO_Brown,
    PPCO_Silver,
};
enum EProfileControllerSensitivityOptions
{
    PCSO_Medium,
    PCSO_Low,
    PCSO_High,
};
enum EProfileDifficultyOptions
{
    PDO_Normal,
    PDO_Easy,
    PDO_Hard,
};
enum EProfileSettingID
{
    PSI_Unknown,
    PSI_ControllerVibration,
    PSI_YInversion,
    PSI_GamerCred,
    PSI_GamerRep,
    PSI_VoiceMuted,
    PSI_VoiceThruSpeakers,
    PSI_VoiceVolume,
    PSI_GamerPictureKey,
    PSI_GamerMotto,
    PSI_GamerTitlesPlayed,
    PSI_GamerAchievementsEarned,
    PSI_GameDifficulty,
    PSI_ControllerSensitivity,
    PSI_PreferredColor1,
    PSI_PreferredColor2,
    PSI_AutoAim,
    PSI_AutoCenter,
    PSI_MovementControl,
    PSI_RaceTransmission,
    PSI_RaceCameraLocation,
    PSI_RaceBrakeControl,
    PSI_RaceAcceleratorControl,
    PSI_GameCredEarned,
    PSI_GameAchievementsEarned,
    PSI_EndLiveIds,
    PSI_ProfileVersionNum,
    PSI_ProfileSaveCount,
};

var array<int> ProfileSettingIds;
var array<OnlineProfileSetting> DefaultSettings;
var const array<IdToStringMapping> OwnerMappings;

public native function AppendVersionToReadIds();

public native function AppendVersionToSettings();

public native function bool GetProfileSettingDefaultFloat(int ProfileSettingId, out float DefaultFloat);

public native function bool GetProfileSettingDefaultId(int ProfileSettingId, out int DefaultId, out int ListIndex);

public native function bool GetProfileSettingDefaultInt(int ProfileSettingId, out int DefaultInt);

public native function int GetVersionNumber();

public event function ModifyAvailableProfileSettings();

public native function SetDefaultVersionNumber();

public event native function SetToDefaults();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OwnerMappings = ({Name = 'None', Id = 0}, 
                     {Name = 'Online Service Setting', Id = 1}, 
                     {Name = 'Game Setting', Id = 2}
                    )
    ProfileMappings = ({
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 3}, 
                                         {Name = 'On', Id = 0}
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
                        ValueMappings = ({Name = 'No', Id = 0}, 
                                         {Name = 'Yes', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Mute Voice', 
                        Id = 5, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Off', Id = 0}, 
                                         {Name = 'On', Id = 1}, 
                                         {Name = 'Both', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Voice Via Speakers', 
                        Id = 6, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Voice Volume', 
                        Id = 7, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Normal', Id = 0}, 
                                         {Name = 'Easy', Id = 1}, 
                                         {Name = 'Hard', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Difficulty Level', 
                        Id = 12, 
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
                        Name = 'Controller Sensitivity', 
                        Id = 13, 
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
                                         {Name = 'Red', Id = 6}, 
                                         {Name = 'Purple', Id = 7}, 
                                         {Name = 'Blue', Id = 8}, 
                                         {Name = 'Green', Id = 9}, 
                                         {Name = 'Brown', Id = 10}, 
                                         {Name = 'Silver', Id = 11}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'First Preferred Color', 
                        Id = 14, 
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
                                         {Name = 'Red', Id = 6}, 
                                         {Name = 'Purple', Id = 7}, 
                                         {Name = 'Blue', Id = 8}, 
                                         {Name = 'Green', Id = 9}, 
                                         {Name = 'Brown', Id = 10}, 
                                         {Name = 'Silver', Id = 11}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Second Preferred Color', 
                        Id = 15, 
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
                        Name = 'Auto Aim', 
                        Id = 16, 
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
                        Name = 'Auto Center', 
                        Id = 17, 
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
                        Name = 'Movement Control', 
                        Id = 18, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Auto', Id = 0}, 
                                         {Name = 'Manual', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Transmission Preference', 
                        Id = 19, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Behind', Id = 0}, 
                                         {Name = 'Front', Id = 1}, 
                                         {Name = 'Inside', Id = 2}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Race Camera Preference', 
                        Id = 20, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Trigger', Id = 0}, 
                                         {Name = 'Button', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Brake Preference', 
                        Id = 21, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = ({Name = 'Trigger', Id = 0}, 
                                         {Name = 'Button', Id = 1}
                                        ), 
                        PredefinedValues = (), 
                        Name = 'Accelerator Preference', 
                        Id = 22, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_IdMapped
                       }
                      )
}