Class ParticleModuleColorByParameter extends ParticleModuleColorBase
    native
    editinlinenew;

var(Color) Name ColorParam;
var(Color) Color DefaultColor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultColor = {B = 255, G = 255, R = 255, A = 255}
    bSpawnModule = TRUE
}