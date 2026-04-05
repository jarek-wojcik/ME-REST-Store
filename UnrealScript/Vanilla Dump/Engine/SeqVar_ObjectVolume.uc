Class SeqVar_ObjectVolume extends SeqVar_Object
    native;

var array<Object> ContainedObjects;
var(SeqVar_ObjectVolume) array<Class<Object>> ExcludeClassList;
var float LastUpdateTime;
var(SeqVar_ObjectVolume) bool bCollidingOnly;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ExcludeClassList = (Class'Trigger', Class'Volume')
    bCollidingOnly = TRUE
}