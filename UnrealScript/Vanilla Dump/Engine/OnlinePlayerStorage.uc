Class OnlinePlayerStorage
    native;

enum EOnlinePlayerStorageAsyncState
{
    OPAS_None,
    OPAS_Read,
    OPAS_Write,
};
struct native OnlineProfileSetting 
{
    var SettingsProperty ProfileSetting;
    var EOnlineProfilePropertyOwner Owner;
};
enum EOnlineProfilePropertyOwner
{
    OPPO_None,
    OPPO_OnlineService,
    OPPO_Game,
};

var array<OnlineProfileSetting> ProfileSettings;
var array<SettingsPropertyPropertyMetaData> ProfileMappings;
var delegate<NotifySettingValueUpdated> __NotifySettingValueUpdated__Delegate;
var const int VersionNumber;
var const EOnlinePlayerStorageAsyncState AsyncState;

public native function AddSettingFloat(int SettingId);

public native function AddSettingInt(int SettingId);

public final native function int FindProfileMappingIndex(int ProfileSettingId);

public final native function int FindProfileMappingIndexByName(Name ProfileSettingName);

public final native function int FindProfileSettingIndex(int ProfileSettingId);

public native function string GetProfileSettingColumnHeader(int ProfileSettingId);

public native function bool GetProfileSettingId(Name ProfileSettingName, out int ProfileSettingId);

public static native function bool GetProfileSettingMappingIds(int ProfileId, out array<int> Ids);

public native function bool GetProfileSettingMappingType(int ProfileId, out EPropertyValueMappingType OutType);

public native function Name GetProfileSettingName(int ProfileSettingId);

public native function bool GetProfileSettingRange(int ProfileId, out float OutMinValue, out float OutMaxValue, out float RangeIncrement, out byte bFormatAsInt);

public native function bool GetProfileSettingValue(int ProfileSettingId, out string Value, optional int ValueMapID = -1);

public native function bool GetProfileSettingValueByName(Name ProfileSettingName, out string Value);

public native function bool GetProfileSettingValueFloat(int ProfileSettingId, out float Value);

public native function bool GetProfileSettingValueId(int ProfileSettingId, out int ValueId, optional out int ListIndex);

public native function bool GetProfileSettingValueInt(int ProfileSettingId, out int Value);

public native function Name GetProfileSettingValueName(int ProfileSettingId);

public native function bool GetProfileSettingValues(int ProfileSettingId, out array<Name> Values);

public native function bool GetRangedProfileSettingValue(int ProfileId, out float OutValue);

public native function bool IsProfileSettingIdMapped(int ProfileSettingId);

public delegate function NotifySettingValueUpdated(Name SettingName);

public native function bool SetProfileSettingValue(int ProfileSettingId, const out string NewValue);

public native function bool SetProfileSettingValueByName(Name ProfileSettingName, const out string NewValue);

public native function bool SetProfileSettingValueFloat(int ProfileSettingId, float Value);

public native function bool SetProfileSettingValueId(int ProfileSettingId, int Value);

public native function bool SetProfileSettingValueInt(int ProfileSettingId, int Value);

public native function bool SetRangedProfileSettingValue(int ProfileId, float NewValue);

public event function SetToDefaults()
{
    ProfileSettings.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VersionNumber = -1
}