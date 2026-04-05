Class PathConstraint
    native;

var const int CacheIdx;
var PathConstraint NextConstraint;

public event function string GetDumpString()
{
    return string(Self);
}
public event function Recycle()
{
    NextConstraint = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = -1
}