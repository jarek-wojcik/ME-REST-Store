Class WwiseStream extends WwiseFile
    native;

struct native WwiseFileCacheGuids 
{
    var(WwiseFileCacheGuids) const editconst array<WwisePlatformGuid> Guids;
};
struct native WwisePlatformGuid 
{
    var(WwisePlatformGuid) const editconst Guid Guid;
    var(WwisePlatformGuid) const editconst int Platform;
};

var const Name Filename;
var(WwiseStream) transient WwiseBank Bank;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}