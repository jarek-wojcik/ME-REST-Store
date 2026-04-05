Class SeqVar_ObjectList extends SeqVar_Object
    native;

var(SeqVar_ObjectList) array<Object> ObjList;

public function Object GetObjectValue()
{
    return ObjList.Length > 0 ? ObjList[0] : None;
}
public function SetObjectValue(Object NewValue)
{
    ObjList[0] = NewValue;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}