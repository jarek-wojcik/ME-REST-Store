Class ParticleModuleUberRainDrops extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories;

var(Size) Vector StartSizeMin;
var(Size) Vector StartSizeMax;
var(Velocity) Vector StartVelocityMin;
var(Velocity) Vector StartVelocityMax;
var(Color) Vector ColorOverLife;
var(location) Vector PC_StartLocation;
var(location) Vector StartLocationMin;
var(location) Vector StartLocationMax;
var(Lifetime) float LifetimeMin;
var(Lifetime) float LifetimeMax;
var(Velocity) float StartVelocityRadialMin;
var(Velocity) float StartVelocityRadialMax;
var(Color) float AlphaOverLife;
var(location) float PC_VelocityScale;
var(location) float PC_StartRadius;
var(location) float PC_StartHeight;
var(location) bool bIsUsingCylinder;
var(location) bool bPositive_X;
var(location) bool bPositive_Y;
var(location) bool bPositive_Z;
var(location) bool bNegative_X;
var(location) bool bNegative_Y;
var(location) bool bNegative_Z;
var(location) bool bSurfaceOnly;
var(location) bool bVelocity;
var(location) bool bRadialVelocity;
var(location) CylinderHeightAxis PC_HeightAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StartSizeMin = {X = 1.0, Y = 1.0, Z = 1.0}
    StartSizeMax = {X = 1.0, Y = 1.0, Z = 1.0}
    StartVelocityMin = {X = 1.0, Y = 1.0, Z = 1.0}
    StartVelocityMax = {X = 1.0, Y = 1.0, Z = 1.0}
    ColorOverLife = {X = 255.899994, Y = 255.899994, Z = 255.899994}
    LifetimeMin = 1.0
    LifetimeMax = 1.0
    AlphaOverLife = 255.899994
    PC_VelocityScale = 1.0
    PC_StartRadius = 50.0
    PC_StartHeight = 50.0
    bPositive_X = TRUE
    bPositive_Y = TRUE
    bPositive_Z = TRUE
    bNegative_X = TRUE
    bNegative_Y = TRUE
    bNegative_Z = TRUE
    bRadialVelocity = TRUE
    PC_HeightAxis = CylinderHeightAxis.PMLPC_HEIGHTAXIS_Z
    bSpawnModule = TRUE
    bUpdateModule = TRUE
    bSupported3DDrawMode = TRUE
}