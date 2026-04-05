Class ParticleModuleMaterialByParameter extends ParticleModuleMaterialBase
    native
    editinlinenew;

var(ParticleModuleMaterialByParameter) array<Name> MaterialParameters;
var(ParticleModuleMaterialByParameter) editfixedsize array<MaterialInterface> DefaultMaterials;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUpdateModule = TRUE
}