Class ParticleModuleBeamBase extends ParticleModule
    native
    editinlinenew
    abstract;

enum Beam2SourceTargetTangentMethod
{
    PEB2STTM_Direct,
    PEB2STTM_UserSet,
    PEB2STTM_Distribution,
    PEB2STTM_Emitter,
};
enum Beam2SourceTargetMethod
{
    PEB2STM_Default,
    PEB2STM_UserSet,
    PEB2STM_Emitter,
    PEB2STM_Particle,
    PEB2STM_Actor,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}