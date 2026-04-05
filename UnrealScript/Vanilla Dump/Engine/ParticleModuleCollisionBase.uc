Class ParticleModuleCollisionBase extends ParticleModule
    native
    editinlinenew
    abstract;

enum EParticleCollisionComplete
{
    EPCC_Kill,
    EPCC_Freeze,
    EPCC_HaltCollisions,
    EPCC_FreezeTranslation,
    EPCC_FreezeRotation,
    EPCC_FreezeMovement,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}