Class SFXCharacterClass_NativeBase
    native;

var(SFXCharacterClass_NativeBase) array<Class<BioCustomAction>> CustomActionClasses;
var(SFXCharacterClass_NativeBase) array<Class<BioCustomAction>> PowerCustomActionClasses;
var transient Vector CameraHookOffset;
var transient Vector CameraArmOffset;
var transient float CameraHookScale;
var transient float CameraArmScale;

public native function CollectAnimListForCooking(out array<Name> OutResults);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CameraHookScale = 1.0
    CameraArmScale = 1.0
}