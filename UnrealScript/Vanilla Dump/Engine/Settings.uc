Class Settings
    native
    abstract;

struct native SettingsPropertyPropertyMetaData 
{
    var const localized string ColumnHeaderText;
    var const array<IdToStringMapping> ValueMappings;
    var const array<SettingsData> PredefinedValues;
    var const Name Name;
    var const int Id;
    var const float MinVal;
    var const float MaxVal;
    var const float RangeIncrement;
    var const EPropertyValueMappingType MappingType;
};
enum EPropertyValueMappingType
{
    PVMT_RawValue,
    PVMT_PredefinedValues,
    PVMT_Ranged,
    PVMT_IdMapped,
};
struct native IdToStringMapping 
{
    var const localized Name Name;
    var const int Id;
};
struct native LocalizedStringSettingMetaData 
{
    var const localized string ColumnHeaderText;
    var const array<StringIdToStringMapping> ValueMappings;
    var const Name Name;
    var const int Id;
};
struct native StringIdToStringMapping 
{
    var const localized Name Name;
    var const int Id;
    var const bool bIsWildcard;
};
struct native SettingsProperty 
{
    var SettingsData Data;
    var int PropertyId;
    var EOnlineDataAdvertisementType AdvertisementType;
};
struct native SettingsData 
{
    var const transient native Pointer Value2;
    var const int Value1;
    var const ESettingsDataType Type;
};
enum ESettingsDataType
{
    SDT_Empty,
    SDT_Int32,
    SDT_Int64,
    SDT_Double,
    SDT_String,
    SDT_Float,
    SDT_Blob,
    SDT_DateTime,
};
struct native LocalizedStringSetting 
{
    var int Id;
    var int ValueIndex;
    var EOnlineDataAdvertisementType AdvertisementType;
};
enum EOnlineDataAdvertisementType
{
    ODAT_DontAdvertise,
    ODAT_OnlineService,
    ODAT_QoS,
    ODAT_OnlineServiceAndQoS,
};

var array<LocalizedStringSetting> LocalizedSettings;
var array<SettingsProperty> Properties;
var array<LocalizedStringSettingMetaData> LocalizedSettingsMappings;
var array<SettingsPropertyPropertyMetaData> PropertyMappings;
var delegate<NotifySettingValueUpdated> __NotifySettingValueUpdated__Delegate;
var delegate<NotifyPropertyValueUpdated> __NotifyPropertyValueUpdated__Delegate;

public native function AppendContextsToURL(out string URL);

public native function AppendDataBindingsToURL(out string URL);

public native function AppendPropertiesToURL(out string URL);

public native function BuildURL(out string URL);

public static native function EmptySettingsData(out SettingsData Data);

public native function bool GetFloatProperty(int PropertyId, out float Value);

public native function bool GetIntProperty(int PropertyId, out int Value);

public native function string GetPropertyAsString(int PropertyId);

public native function string GetPropertyAsStringByName(Name PropertyName);

public native function string GetPropertyColumnHeader(int PropertyId);

public native function bool GetPropertyId(Name PropertyName, out int PropertyId);

public native function bool GetPropertyMappingType(int PropertyId, out EPropertyValueMappingType OutType);

public native function Name GetPropertyName(int PropertyId);

public native function bool GetPropertyRange(int PropertyId, out float OutMinValue, out float OutMaxValue, out float RangeIncrement, out byte bFormatAsInt);

public native function ESettingsDataType GetPropertyType(int PropertyId);

public native function bool GetPropertyValueId(int PropertyId, out int ValueId);

public native function GetQoSAdvertisedProperties(out array<SettingsProperty> QoSProps);

public native function GetQoSAdvertisedStringSettings(out array<LocalizedStringSetting> QoSSettings);

public native function bool GetRangedPropertyValue(int PropertyId, out float OutValue);

public static native function GetSettingsDataBlob(out SettingsData Data, out array<byte> OutBlob);

public static native function GetSettingsDataDateTime(out SettingsData Data, out int OutInt1, out int OutInt2);

public static native function float GetSettingsDataFloat(out SettingsData Data);

public static native function int GetSettingsDataInt(out SettingsData Data);

public static native function string GetSettingsDataString(out SettingsData Data);

public native function bool GetStringProperty(int PropertyId, out string Value);

public native function string GetStringSettingColumnHeader(int StringSettingId);

public native function bool GetStringSettingId(Name StringSettingName, out int StringSettingId);

public native function Name GetStringSettingName(int StringSettingId);

public native function bool GetStringSettingValue(int StringSettingId, out int ValueIndex);

public native function bool GetStringSettingValueByName(Name StringSettingName, out int ValueIndex);

public native function Name GetStringSettingValueName(int StringSettingId, int ValueIndex);

public native function Name GetStringSettingValueNameByName(Name StringSettingName);

public native function bool GetStringSettingValueNames(int StringSettingId, out array<IdToStringMapping> Values);

public native function bool HasProperty(int PropertyId);

public native function bool HasStringSetting(int SettingId);

public native function bool IncrementStringSettingValue(int StringSettingId, int Direction, bool bShouldWrap);

public native function bool IsWildcardStringSetting(int StringSettingId);

public delegate function NotifyPropertyValueUpdated(Name PropertyName);

public delegate function NotifySettingValueUpdated(Name SettingName);

public native function SetFloatProperty(int PropertyId, float Value);

public native function SetIntProperty(int PropertyId, int Value);

public native function bool SetPropertyFromStringByName(Name PropertyName, const out string NewValue);

public native function bool SetPropertyValueId(int PropertyId, int ValueId);

public native function bool SetRangedPropertyValue(int PropertyId, float NewValue);

public static native function SetSettingsData(out SettingsData Data, out SettingsData Data2Copy);

public static native function SetSettingsDataBlob(out SettingsData Data, out array<byte> InBlob);

public static native function SetSettingsDataDateTime(out SettingsData Data, int InInt1, int InInt2);

public static native function SetSettingsDataFloat(out SettingsData Data, float InFloat);

public static native function SetSettingsDataInt(out SettingsData Data, int InInt);

public static native function SetSettingsDataString(out SettingsData Data, string InString);

public native function SetStringProperty(int PropertyId, string Value);

public native function SetStringSettingValue(int StringSettingId, int ValueIndex, optional bool bShouldAutoAdd);

public native function SetStringSettingValueByName(Name StringSettingName, int ValueIndex, bool bShouldAutoAdd);

public native function bool SetStringSettingValueFromStringByName(Name StringSettingName, const out string NewValue);

public native function UpdateFromURL(const out string URL, GameInfo Game);

public native function UpdateProperties(const out array<SettingsProperty> Props, optional bool bShouldAddIfMissing = TRUE);

public native function UpdateStringSettings(const out array<LocalizedStringSetting> Settings, optional bool bShouldAddIfMissing = TRUE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}