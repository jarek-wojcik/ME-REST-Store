Class UIResourceCombinationProvider extends UIDataProvider
    implements(UIListElementProvider, UIListElementCellProvider)
    native
    perobjectconfig
    abstract
    transient;

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var transient UIResourceDataProvider StaticDataProvider;
var transient UIDataProvider_OnlineProfileSettings ProfileProvider;

public event function bool GetCellFieldType(Name FieldName, Name CellTag, out EUIDataProviderFieldType FieldType)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public event function bool GetCellFieldValue(Name FieldName, Name CellTag, int ListIndex, out UIProviderFieldValue out_FieldValue, optional int ArrayIndex = -1)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public event function bool GetElementCellSchemaProvider(Name FieldName, out UIListElementCellProvider out_SchemaProvider)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public event function GetElementCellTags(Name FieldName, out array<Name> CellFieldTags, optional out array<string> ColumnHeaderDisplayText)
{
}
public event function bool GetElementCellValueProvider(Name FieldName, int ListIndex, out UIListElementCellProvider out_ValueProvider)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public event function int GetElementCount(Name FieldName)
{
    local int Result;
    
    Result = 0;
    return Result;
}
public event function array<Name> GetElementProviderTags()
{
    local array<Name> Tags;
    
    Tags.Length = 0;
    return Tags;
}
public event function bool GetListElements(Name FieldName, out array<int> out_Elements)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public event function InitializeProvider(bool bIsEditor, UIResourceDataProvider InStaticResourceProvider, UIDataProvider_OnlineProfileSettings InProfileProvider)
{
    StaticDataProvider = InStaticResourceProvider;
    ProfileProvider = InProfileProvider;
}
public event function bool IsElementEnabled(Name FieldName, int CollectionIndex)
{
    local bool bResult;
    
    bResult = FALSE;
    return bResult;
}
public function ClearProviderReferences()
{
    StaticDataProvider = None;
    ProfileProvider = None;
}
public function bool ReplaceProviderCollection(out array<UIDataProviderField> out_Fields, Name TargetFieldTag, const out array<UIDataProvider> ReplacementProviders)
{
    local int FieldIndex;
    local bool bResult;
    
    for (FieldIndex = 0; FieldIndex < out_Fields.Length; FieldIndex++)
    {
        if (out_Fields[FieldIndex].FieldTag == TargetFieldTag)
        {
            if (out_Fields[FieldIndex].FieldType == EUIDataProviderFieldType.DATATYPE_ProviderCollection)
            {
                out_Fields[FieldIndex].FieldProviders = ReplacementProviders;
                bResult = TRUE;
            }
            break;
        }
    }
    return bResult;
}
public function bool ReplaceProviderValue(out array<UIDataProviderField> out_Fields, Name TargetFieldTag, UIDataProvider ReplacementProvider)
{
    local int FieldIndex;
    local bool bResult;
    
    for (FieldIndex = 0; FieldIndex < out_Fields.Length; FieldIndex++)
    {
        if (out_Fields[FieldIndex].FieldTag == TargetFieldTag)
        {
            if (out_Fields[FieldIndex].FieldType == EUIDataProviderFieldType.DATATYPE_Provider)
            {
                out_Fields[FieldIndex].FieldProviders[0] = ReplacementProvider;
                bResult = TRUE;
            }
            break;
        }
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}