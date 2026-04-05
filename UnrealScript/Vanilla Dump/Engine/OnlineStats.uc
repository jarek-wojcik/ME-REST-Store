Class OnlineStats
    native
    abstract;

var const array<StringIdToStringMapping> ViewIdMappings;

public native function bool GetViewId(Name ViewName, out int ViewId);

public native function Name GetViewName(int ViewId);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}