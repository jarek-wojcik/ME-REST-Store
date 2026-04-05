Class SceneDataStore extends UIDataStore
    implements(UIListElementProvider, UIListElementCellProvider)
    native;

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const transient UIScene OwnerScene;
var UIDynamicFieldProvider SceneDataProvider;

public final function bool AddField(Name FieldName, optional EUIDataProviderFieldType FieldType = 0, optional bool bPersistent, optional out int out_InsertPosition)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.AddField(FieldName, FieldType, bPersistent, out_InsertPosition);
    }
    return FALSE;
}
public final function bool ClearCollectionValueArray(Name FieldName, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.ClearCollectionValueArray(FieldName, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool ClearFields(optional bool bReinitializeRuntimeFields = TRUE)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.ClearFields(bReinitializeRuntimeFields);
    }
    return FALSE;
}
public final function int FindCollectionValueIndex(Name FieldName, const out string ValueToFind, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.FindCollectionValueIndex(FieldName, ValueToFind, bPersistent, CellTag);
    }
    return -1;
}
public final function int FindFieldIndex(Name FieldName, optional bool bSearchPersistentFields)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.FindFieldIndex(FieldName, bSearchPersistentFields);
    }
    return -1;
}
public final function bool GetCollectionValue(Name FieldName, int ValueIndex, out string out_Value, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.GetCollectionValue(FieldName, ValueIndex, out_Value, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool GetCollectionValueArray(Name FieldName, out array<string> out_DataValueArray, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.GetCollectionValueArray(FieldName, out_DataValueArray, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool InsertCollectionValue(Name FieldName, const out string NewValue, optional int InsertIndex = -1, optional bool bPersistent, optional bool bAllowDuplicateValues, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.InsertCollectionValue(FieldName, NewValue, InsertIndex, bPersistent, bAllowDuplicateValues, CellTag);
    }
    return FALSE;
}
public event function Registered(LocalPlayer PlayerOwner)
{
    Super.Registered(PlayerOwner);
    SceneDataProvider.__OnDataProviderPropertyChange__Delegate = SceneDataFieldChanged;
}
public final function bool RemoveCollectionValue(Name FieldName, const out string ValueToRemove, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.RemoveCollectionValue(FieldName, ValueToRemove, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool RemoveCollectionValueByIndex(Name FieldName, int ValueIndex, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.RemoveCollectionValueByIndex(FieldName, ValueIndex, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool RemoveField(Name FieldName)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.RemoveField(FieldName);
    }
    return FALSE;
}
public final function bool ReplaceCollectionValue(Name FieldName, const out string CurrentValue, const out string NewValue, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.ReplaceCollectionValue(FieldName, CurrentValue, NewValue, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool ReplaceCollectionValueByIndex(Name FieldName, int ValueIndex, const out string NewValue, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.ReplaceCollectionValueByIndex(FieldName, ValueIndex, NewValue, bPersistent, CellTag);
    }
    return FALSE;
}
public final function bool SetCollectionValueArray(Name FieldName, const out array<string> CollectionValues, optional bool bClearExisting = TRUE, optional int InsertIndex = -1, optional bool bPersistent, optional Name CellTag)
{
    if (SceneDataProvider != None)
    {
        return SceneDataProvider.SetCollectionValueArray(FieldName, CollectionValues, bClearExisting, InsertIndex, bPersistent, CellTag);
    }
    return FALSE;
}
public function SceneDataFieldChanged(UIDataProvider SourceProvider, optional Name PropTag)
{
    RefreshSubscribers(PropTag, TRUE, SourceProvider);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'SCENE_DATASTORE_TAG'
}