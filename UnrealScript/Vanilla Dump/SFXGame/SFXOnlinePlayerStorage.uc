Class SFXOnlinePlayerStorage extends OnlinePlayerStorage
    native
    config(Engine);

struct native WriteEvent 
{
    var array<delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete>> DelayedWriteDelegates;
    var int LocalUserNum;
    var float LastWriteTimestamp;
    
    structdefaultproperties
    {
        DelayedWriteDelegates = ()
    }
};
enum EStorageField
{
    SGF_Base,
    SGF_Class00,
    SGF_Class01,
    SGF_Class02,
    SGF_Class03,
    SGF_Class04,
    SGF_Class05,
    SGF_Class06,
    SGF_Class07,
    SGF_Character00,
    SGF_Character01,
    SGF_Character02,
    SGF_Character03,
    SGF_Character04,
    SGF_Character05,
    SGF_Character06,
    SGF_Character07,
    SGF_Character08,
    SGF_Character09,
    SGF_Character10,
    SGF_Character11,
    SGF_Character12,
    SGF_Character13,
    SGF_Character14,
    SGF_Character15,
    SGF_Character16,
    SGF_Character17,
    SGF_Character18,
    SGF_Character19,
    SGF_Character20,
    SGF_Character21,
    SGF_Character22,
    SGF_Character23,
    SGF_Character24,
    SGF_Character25,
    SGF_Character26,
    SGF_Character27,
    SGF_Character28,
    SGF_Character29,
    SGF_Character30,
    SGF_Character31,
    SGF_Character32,
    SGF_Character33,
    SGF_Character34,
    SGF_Character35,
    SGF_Character36,
    SGF_Character37,
    SGF_Character38,
    SGF_Character39,
    SGF_Character40,
    SGF_Character41,
    SGF_Character42,
    SGF_Character43,
    SGF_Character44,
    SGF_Character45,
    SGF_Character46,
    SGF_Character47,
    SGF_Character48,
    SGF_Character49,
    SGF_Character50,
    SGF_Character51,
    SGF_Character52,
    SGF_Character53,
    SGF_Character54,
    SGF_Character55,
    SGF_Character56,
    SGF_Character57,
    SGF_Character58,
    SGF_Character59,
    SGF_Character60,
    SGF_Character61,
    SGF_Character62,
    SGF_Character63,
    SGF_Character64,
    SGF_Character65,
    SGF_Character66,
    SGF_Character67,
    SGF_Character68,
    SGF_Character69,
    SGF_Character70,
    SGF_Character71,
    SGF_Character72,
    SGF_Character73,
    SGF_Character74,
    SGF_Character75,
    SGF_Character76,
    SGF_Character77,
    SGF_FaceCodes,
    SGF_NewReinforcements,
    ASF_Completion,
    ASF_Progress,
};

var transient array<WriteEvent> WriteEventData;
var config float fMinDelayBetweenWrite;
var int iMaxBytesPerStorage;

private final native function SetBaseProfileSettings();

public event function SetToDefaults()
{
    Super.SetToDefaults();
    SetBaseProfileSettings();
}
public final function bool Write(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub == None || OnlineSub.PlayerInterface == None)
    {
        return FALSE;
    }
    PlayerInterface = OnlineSub.PlayerInterface;
    PlayerInterface.AddWritePlayerStorageCompleteDelegate(LocalUserNum, WritePlayerStorageCompleteDelegate);
    if (!PlayerInterface.WritePlayerStorage(LocalUserNum, Self))
    {
        PlayerInterface.ClearWritePlayerStorageCompleteDelegate(LocalUserNum, WritePlayerStorageCompleteDelegate);
        return FALSE;
    }
    return TRUE;
}
public final function AcknowledgeWriteComplete(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub == None || OnlineSub.PlayerInterface == None)
    {
    }
    OnlineSub.PlayerInterface.ClearWritePlayerStorageCompleteDelegate(LocalUserNum, WritePlayerStorageCompleteDelegate);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fMinDelayBetweenWrite = 15.0
    iMaxBytesPerStorage = 3000
    ProfileMappings = ({
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'Base', 
                        Id = 0, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class1', 
                        Id = 1, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class2', 
                        Id = 2, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class3', 
                        Id = 3, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class4', 
                        Id = 4, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class5', 
                        Id = 5, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class6', 
                        Id = 6, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class7', 
                        Id = 7, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'class8', 
                        Id = 8, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char0', 
                        Id = 9, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char1', 
                        Id = 10, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char2', 
                        Id = 11, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char3', 
                        Id = 12, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char4', 
                        Id = 13, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char5', 
                        Id = 14, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char6', 
                        Id = 15, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char7', 
                        Id = 16, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char8', 
                        Id = 17, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char9', 
                        Id = 18, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char10', 
                        Id = 19, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char11', 
                        Id = 20, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char12', 
                        Id = 21, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char13', 
                        Id = 22, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char14', 
                        Id = 23, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char15', 
                        Id = 24, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char16', 
                        Id = 25, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char17', 
                        Id = 26, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char18', 
                        Id = 27, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char19', 
                        Id = 28, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char20', 
                        Id = 29, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char21', 
                        Id = 30, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char22', 
                        Id = 31, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char23', 
                        Id = 32, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char24', 
                        Id = 33, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char25', 
                        Id = 34, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char26', 
                        Id = 35, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char27', 
                        Id = 36, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char28', 
                        Id = 37, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char29', 
                        Id = 38, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char30', 
                        Id = 39, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char31', 
                        Id = 40, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char32', 
                        Id = 41, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char33', 
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
                        Name = 'char34', 
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
                        Name = 'char35', 
                        Id = 44, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char36', 
                        Id = 45, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char37', 
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
                        Name = 'char38', 
                        Id = 47, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char39', 
                        Id = 48, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char40', 
                        Id = 49, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char41', 
                        Id = 50, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char42', 
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
                        Name = 'char43', 
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
                        Name = 'char44', 
                        Id = 53, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char45', 
                        Id = 54, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char46', 
                        Id = 55, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char47', 
                        Id = 56, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char48', 
                        Id = 57, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char49', 
                        Id = 58, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char50', 
                        Id = 59, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char51', 
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
                        Name = 'char52', 
                        Id = 61, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char53', 
                        Id = 62, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char54', 
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
                        Name = 'char55', 
                        Id = 64, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char56', 
                        Id = 65, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char57', 
                        Id = 66, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char58', 
                        Id = 67, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char59', 
                        Id = 68, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }, 
                       {
                        ColumnHeaderText = "", 
                        ValueMappings = (), 
                        PredefinedValues = (), 
                        Name = 'char60', 
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
                        Name = 'char61', 
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
                        Name = 'char62', 
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
                        Name = 'char63', 
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
                        Name = 'char64', 
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
                        Name = 'char65', 
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
                        Name = 'char66', 
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
                        Name = 'char67', 
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
                        Name = 'char68', 
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
                        Name = 'char69', 
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
                        Name = 'char70', 
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
                        Name = 'char71', 
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
                        Name = 'char72', 
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
                        Name = 'char73', 
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
                        Name = 'char74', 
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
                        Name = 'char75', 
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
                        Name = 'char76', 
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
                        Name = 'char77', 
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
                        Name = 'FaceCodes', 
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
                        Name = 'NewItem', 
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
                        Name = 'Completion', 
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
                        Name = 'Progress', 
                        Id = 90, 
                        MinVal = 0.0, 
                        MaxVal = 0.0, 
                        RangeIncrement = 0.0, 
                        MappingType = EPropertyValueMappingType.PVMT_RawValue
                       }
                      )
    VersionNumber = 20
}