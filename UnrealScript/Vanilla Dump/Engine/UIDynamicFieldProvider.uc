Class UIDynamicFieldProvider extends UIDataProvider
    native
    perobjectconfig
    config(UI);

var const native Map_Mirror PersistentCollectionData;
var const transient native Map_Mirror RuntimeCollectionData;
var(UIDynamicFieldProvider) config array<UIProviderScriptFieldValue> PersistentDataFields;
var(UIDynamicFieldProvider) transient array<UIProviderScriptFieldValue> RuntimeDataFields;

public final native function bool AddField(Name FieldName, optional EUIDataProviderFieldType FieldType = 0, optional bool bPersistent, optional out int out_InsertPosition);

public final native function bool ClearCollectionValueArray(Name FieldName, optional bool bPersistent, optional Name CellTag);

public final native function bool ClearFields(optional bool bReinitializeRuntimeFields = TRUE);

public final native function int FindCollectionValueIndex(Name FieldName, const out string ValueToFind, optional bool bPersistent, optional Name CellTag);

public final native function int FindFieldIndex(Name FieldName, optional bool bSearchPersistentFields);

public final native function bool GetCollectionValue(Name FieldName, int ValueIndex, out string out_Value, optional bool bPersistent, optional Name CellTag);

public final native function bool GetCollectionValueArray(Name FieldName, out array<string> out_DataValueArray, optional bool bPersistent, optional Name CellTag);

public final native function bool GetCollectionValueSchema(Name FieldName, out array<Name> out_CellTagArray, optional bool bPersistent);

public final native function bool GetField(Name FieldName, out UIProviderScriptFieldValue out_Field);

public native function InitializeRuntimeFields();

public final native function bool InsertCollectionValue(Name FieldName, const out string NewValue, optional int InsertIndex = -1, optional bool bPersistent, optional bool bAllowDuplicateValues, optional Name CellTag);

public final native function bool RemoveCollectionValue(Name FieldName, const out string ValueToRemove, optional bool bPersistent, optional Name CellTag);

public final native function bool RemoveCollectionValueByIndex(Name FieldName, int ValueIndex, optional bool bPersistent, optional Name CellTag);

public final native function bool RemoveField(Name FieldName);

public final native function bool ReplaceCollectionValue(Name FieldName, const out string CurrentValue, const out string NewValue, optional bool bPersistent, optional Name CellTag);

public final native function bool ReplaceCollectionValueByIndex(Name FieldName, int ValueIndex, const out string NewValue, optional bool bPersistent, optional Name CellTag);

public final native function SavePersistentProviderData();

public final native function bool SetCollectionValueArray(Name FieldName, const out array<string> CollectionValues, optional bool bClearExisting = TRUE, optional int InsertIndex = -1, optional bool bPersistent, optional Name CellTag);

public final native function bool SetField(Name FieldName, const out UIProviderScriptFieldValue FieldValue, optional bool bChangeExistingOnly = TRUE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}