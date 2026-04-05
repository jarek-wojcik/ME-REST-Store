Class WwiseFile
    native
    abstract;

struct native WwisePlatformData 
{
    var const native Pointer Data;
    var const native int Platform;
};
struct native WwiseSHA1Digest 
{
    var byte Digest[20];
};

var const native Pointer Data;
var(WwiseFile) const editconst int Id;
var(WwiseFile) const editconst transient bool IsRegistered;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}