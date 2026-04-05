Class UIDataProvider extends UIRoot
    native
    abstract
    transient;

enum EProviderAccessType
{
    ACCESS_ReadOnly,
    ACCESS_PerField,
    ACCESS_WriteAll,
};
struct native transient UIDataProviderField 
{
    var init array<UIDataProvider> FieldProviders;
    var init Name FieldTag;
    var init EUIDataProviderFieldType FieldType;
};

var transient array<delegate<OnDataProviderPropertyChange>> ProviderChangedNotifies;
var transient delegate<OnDataProviderPropertyChange> __OnDataProviderPropertyChange__Delegate;
var EProviderAccessType WriteAccessType;

public event function bool AllowPublishingToField(string FieldName, optional int ArrayIndex = -1);

public event function string GenerateFillerData(string DataTag);

public event function string GenerateScriptMarkupString(Name DataTag);

public event function bool GetFieldValue(string FieldName, out UIProviderScriptFieldValue FieldValue, optional int ArrayIndex = -1);

public final native function bool GetProviderFieldType(coerce string DataTag, out EUIDataProviderFieldType out_ProviderFieldType);

public event function GetSupportedScriptFields(out array<UIDataProviderField> out_Fields);

public event function bool IsCollectionDataType(EUIDataProviderFieldType FieldType)
{
    return FieldType == EUIDataProviderFieldType.DATATYPE_Collection || FieldType == EUIDataProviderFieldType.DATATYPE_ProviderCollection;
}
public event function bool IsProviderDisabled();

public event function NotifyPropertyChanged(optional Name PropTag)
{
    local int Index;
    local delegate<OnDataProviderPropertyChange> Subscriber;
    local array<delegate<OnDataProviderPropertyChange>> SubscriberArrayCopy;
    
    SubscriberArrayCopy.Length = ProviderChangedNotifies.Length;
    for (Index = 0; Index < SubscriberArrayCopy.Length; Index++)
    {
        SubscriberArrayCopy[Index] = ProviderChangedNotifies[Index];
    }
    for (Index = 0; Index < SubscriberArrayCopy.Length; Index++)
    {
        Subscriber = SubscriberArrayCopy[Index];
        Subscriber(Self, PropTag);
    }
}
public delegate function OnDataProviderPropertyChange(UIDataProvider SourceProvider, optional Name PropTag);

public native function int ParseArrayDelimiter(out string DataTag);

public event function bool SetFieldValue(string FieldName, const out UIProviderScriptFieldValue FieldValue, optional int ArrayIndex = -1);

public final function bool AddPropertyNotificationChangeRequest(delegate<OnDataProviderPropertyChange> InDelegate, optional bool bAllowDuplicates)
{
    local int NewIndex;
    local bool bResult;
    
    NewIndex = ProviderChangedNotifies.Find(InDelegate);
    if (bAllowDuplicates || NewIndex == -1)
    {
        NewIndex = ProviderChangedNotifies.Length;
        ProviderChangedNotifies[NewIndex] = InDelegate;
        bResult = TRUE;
    }
    return bResult;
}
public final function int ParseTagArrayDelimiter(out Name FieldName)
{
    local string FieldNameString;
    local int Result;
    
    FieldNameString = string(FieldName);
    Result = ParseArrayDelimiter(FieldNameString);
    FieldName = Name(FieldNameString);
    return Result;
}
public final function bool RemovePropertyNotificationChangeRequest(delegate<OnDataProviderPropertyChange> InDelegate)
{
    local int Index;
    local bool bResult;
    
    Index = ProviderChangedNotifies.Find(InDelegate);
    while (Index != -1)
    {
        ProviderChangedNotifies.Remove(Index, 1);
        bResult = TRUE;
        Index = ProviderChangedNotifies.Find(InDelegate);
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}