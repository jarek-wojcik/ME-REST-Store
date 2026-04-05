Class ParticleLightEnvironmentComponent extends DynamicLightEnvironmentComponent
    native;

var const transient int ReferenceCount;
var bool bAllowDLESharing;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReferenceCount = 1
    InvisibleUpdateTime = 10.0
    MinTimeBetweenFullUpdates = 3.0
    bForceCompositeAllLights = TRUE
    bDynamic = FALSE
}