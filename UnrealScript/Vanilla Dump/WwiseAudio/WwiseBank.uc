Class WwiseBank extends WwiseFile
    native;

var const editconst transient native array<Pointer> Children;
var transient native Pointer Bundle;
var(WwiseBank) const editconst WwiseBank Parent;
var(WwiseBank) const editconst bool IsLocalised;
var(WwiseBank) const editconst transient bool IsLoaded;
var(WwiseBank) bool GenerateDefinition;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GenerateDefinition = TRUE
}