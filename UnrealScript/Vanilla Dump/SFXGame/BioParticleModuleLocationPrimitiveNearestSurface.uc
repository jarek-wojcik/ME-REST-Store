Class BioParticleModuleLocationPrimitiveNearestSurface extends ParticleModuleLocationPrimitiveBase
    native
    editinlinenew
    collapsecategories;

enum EBioParticleCollisionComplete
{
    EBPCC_DoNothing,
    EBPCC_Kill,
    EBPCC_Freeze,
    EBPCC_FreezeTranslation,
    EBPCC_FreezeRotation,
    EBPCC_FreezeMovement,
};
enum ELocationNearestSurface
{
    eLocationNearestSurface_Stay,
    eLocationNearestSurface_StayAtRadius,
    eLocationNearestSurface_Kill,
};

var array<Vector> m_aSearchDirections;
var(BioLocation) export noclear float fRadius;
var(BioLocation) export noclear bool bInitialLocationOnly;
var(BioLocation) export noclear bool bMovingLocationOnly;
var(BioLocation) export noclear bool bDirectionRelativeToEmitter;
var(BioLocation) export noclear bool bTestActors;
var(BioLocation) export noclear ELocationNearestSurface eIfNoCollision;
var(BioLocation) export noclear EBioParticleCollisionComplete eOnCollision;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatConstant Name=DistributionVelocityScale
    End Template
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionStartLocation
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionStartLocationRw
    End Template
    fRadius = 100.0
    bInitialLocationOnly = TRUE
    bDirectionRelativeToEmitter = TRUE
    StartLocationRw = {Distribution = DistributionStartLocationRw}
    VelocityScale = {Distribution = DistributionVelocityScale}
    Positive_X = FALSE
    Positive_Y = FALSE
    Positive_Z = FALSE
    Negative_X = FALSE
    Negative_Y = FALSE
    Negative_Z = FALSE
    SurfaceOnly = TRUE
    m_Seed = DistributionSeed
    bUpdateModule = TRUE
}