Class MaterialInterface extends Surface
    native
    abstract;

struct native LightmassMaterialInterfaceSettings 
{
    var(Material) float EmissiveBoost;
    var(Material) float DiffuseBoost;
    var float SpecularBoost;
    var(Material) float ExportResolutionScale;
    var(Material) float DistanceFieldPenumbraScale;
    var bool bOverrideEmissiveBoost;
    var bool bOverrideDiffuseBoost;
    var bool bOverrideSpecularBoost;
    var bool bOverrideExportResolutionScale;
    var bool bOverrideDistanceFieldPenumbraScale;
    
    structdefaultproperties
    {
        EmissiveBoost = 1.0
        DiffuseBoost = 1.0
        SpecularBoost = 1.0
        ExportResolutionScale = 1.0
        DistanceFieldPenumbraScale = 1.0
    }
};
enum EMaterialProperty
{
    MP_EmissiveColor,
    MP_Opacity,
    MP_OpacityMask,
    MP_Distortion,
    MP_TwoSidedLightingMask,
    MP_DiffuseColor,
    MP_DiffusePower,
    MP_SpecularColor,
    MP_SpecularPower,
    MP_Normal,
    MP_CustomLighting,
    MP_CustomLightingDiffuse,
    MP_AnisotropicDirection,
    MP_WorldPositionOffset,
    MP_TMissionMask,
    MP_TMissionColor,
    MP_CustomSkylightDiffuse,
};
enum EMaterialUsage
{
    MATUSAGE_SkeletalMesh,
    MATUSAGE_FracturedMeshes,
    MATUSAGE_ParticleSprites,
    MATUSAGE_BeamTrails,
    MATUSAGE_ParticleSubUV,
    MATUSAGE_Foliage,
    MATUSAGE_SpeedTree,
    MATUSAGE_StaticLighting,
    MATUSAGE_GammaCorrection,
    MATUSAGE_LensFlare,
    MATUSAGE_InstancedMeshParticles,
    MATUSAGE_FluidSurface,
    MATUSAGE_Decals,
    MATUSAGE_MaterialEffect,
    MATUSAGE_MorphTargets,
    MATUSAGE_FogVolumes,
    MATUSAGE_RadialBlur,
    MATUSAGE_InstancedMeshes,
    MATUSAGE_SplineMesh,
    MATUSAGE_ScreenDoorFade,
    MATUSAGE_APEXMesh,
    MATUSAGE_LightEnvironments,
    MATUSAGE_VectorLightMaps,
    MATUSAGE_SimpleLightMaps,
};

var(Lightmass) LightmassMaterialInterfaceSettings LightmassSettings;
var const Guid m_Guid;
var const Guid LightingGuid;
var const transient native RenderCommandFence_Mirror ParentRefFence;
var(Mobile) Texture FlattenedTexture;

public final native function bool GetEffectsMaterialFractionValue(out float Value);

public final native function bool GetEffectsMaterialNameValue(out Name EffectName);

public final native function bool GetFontParameterValue(Name ParameterName, out Font OutFontValue, out int OutFontPage);

public final native function Material GetMaterial();

public final native function PhysicalMaterial GetPhysicalMaterial();

public final native function bool GetScalarCurveParameterValue(Name ParameterName, out InterpCurveFloat OutValue);

public final native function bool GetScalarParameterValue(Name ParameterName, out float OutValue);

public final native function bool GetTextureParameterValue(Name ParameterName, out Texture OutValue);

public final native function bool GetVectorCurveParameterValue(Name ParameterName, out InterpCurveVector OutValue);

public final native function bool GetVectorParameterValue(Name ParameterName, out LinearColor OutValue);

public native function SetForceMipLevelsToBeResident(bool OverrideForceMiplevelsToBeResident, bool bForceMiplevelsToBeResidentValue, float ForceDuration, optional int CinematicTextureGroups = 0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightmassSettings = {
                         EmissiveBoost = 1.0, 
                         DiffuseBoost = 1.0, 
                         SpecularBoost = 1.0, 
                         ExportResolutionScale = 1.0, 
                         DistanceFieldPenumbraScale = 1.0, 
                         bOverrideEmissiveBoost = FALSE, 
                         bOverrideDiffuseBoost = FALSE, 
                         bOverrideSpecularBoost = FALSE, 
                         bOverrideExportResolutionScale = FALSE, 
                         bOverrideDistanceFieldPenumbraScale = FALSE
                        }
}