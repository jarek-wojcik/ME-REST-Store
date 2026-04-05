Class ParticleModule
    native
    editinlinenew
    abstract;

enum EParticleSourceSelectionMethod
{
    EPSSM_Random,
    EPSSM_Sequential,
};
enum EModuleType
{
    EPMT_General,
    EPMT_TypeData,
    EPMT_Beam,
    EPMT_Trail,
    EPMT_Spawn,
    EPMT_Required,
    EPMT_Event,
};
struct native transient ParticleCurvePair 
{
    var init string CurveName;
    var init Object CurveObject;
};

var bool bSpawnModule;
var bool bUpdateModule;
var bool bFinalUpdateModule;
var bool bCurvesAsColor;
var(Cascade) bool b3DDrawMode;
var bool bSupported3DDrawMode;
var bool bEnabled;
var bool bEditable;
var bool LODDuplicate;
var bool bSpawnRateModule;
var const byte LODValidity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    bEditable = TRUE
    LODDuplicate = TRUE
}