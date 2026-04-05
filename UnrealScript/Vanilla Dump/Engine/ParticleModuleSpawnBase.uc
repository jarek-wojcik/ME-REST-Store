Class ParticleModuleSpawnBase extends ParticleModule
    native
    editinlinenew
    abstract;

var(Spawn) bool bProcessSpawnRate;
var(Burst) bool bProcessBurstList;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bProcessSpawnRate = TRUE
    bProcessBurstList = TRUE
}