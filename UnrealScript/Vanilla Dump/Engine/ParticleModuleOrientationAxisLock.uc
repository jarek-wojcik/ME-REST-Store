Class ParticleModuleOrientationAxisLock extends ParticleModuleOrientationBase
    native
    editinlinenew;

enum EParticleAxisLock
{
    EPAL_NONE,
    EPAL_X,
    EPAL_Y,
    EPAL_Z,
    EPAL_NEGATIVE_X,
    EPAL_NEGATIVE_Y,
    EPAL_NEGATIVE_Z,
    EPAL_ROTATE_X,
    EPAL_ROTATE_Y,
    EPAL_ROTATE_Z,
};

var(Orientation) EParticleAxisLock LockAxisFlags;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}