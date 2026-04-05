Class UIDataStore_StringAliasMap extends UIDataStore_StringBase
    native
    transient
    config(Game);

struct native UIMenuInputMap 
{
    var string MappedText;
    var Name FieldName;
    var Name Set;
};

var const transient native Map_Mirror MenuInputSets;
var config array<UIMenuInputMap> MenuInputMapArray;
var const transient int PlayerIndex;

public final native function int FindMappingWithFieldName(optional string FieldName = "", optional string SetName = "");

public final native function LocalPlayer GetPlayerOwner();

public native function int GetStringWithFieldName(string FieldName, out string MappedString);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayerIndex = -1
    Tag = 'StringAliasMap'
}