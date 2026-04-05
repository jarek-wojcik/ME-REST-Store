Class PrefabInstance extends Actor
    native;

var const array<byte> PI_Bytes;
var const array<Object> PI_CompleteObjects;
var const array<Object> PI_ReferencedObjects;
var const array<string> PI_SavedNames;
var const native Object ArchetypeToInstanceMap;
var const native Object PI_ObjectMap;
var const Prefab TemplatePrefab;
var const int TemplateVersion;
var const PrefabSequence SequenceInstance;
var const int PI_PackageVersion;
var const int PI_LicenseePackageVersion;

public final native function DestroyPrefab();

public final native function InstancePrefab(Prefab InPrefab);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PI_PackageVersion = -1
    PI_LicenseePackageVersion = -1
    Components = (None)
    bStatic = TRUE
}