Class SeqAct_ModifyProperty extends SequenceAction
    native;

struct native PropertyInfo 
{
    var(PropertyInfo) string PropertyValue;
    var(PropertyInfo) Name PropertyName;
    var(PropertyInfo) bool bModifyProperty;
};

var(SeqAct_ModifyProperty) array<PropertyInfo> Properties;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}