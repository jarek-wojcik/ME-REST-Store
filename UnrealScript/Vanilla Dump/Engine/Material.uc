Class Material extends MaterialInterface
    native
    collapsecategories;

struct Vector2MaterialInput extends MaterialInput 
{
    var bool UseConstant;
    var float ConstantX;
    var float ConstantY;
};
struct VectorMaterialInput extends MaterialInput 
{
    var bool UseConstant;
    var Vector Constant;
};
struct ScalarMaterialInput extends MaterialInput 
{
    var bool UseConstant;
    var float Constant;
};
struct ColorMaterialInput extends MaterialInput 
{
    var bool UseConstant;
    var Color Constant;
};
struct MaterialInput 
{
    var MaterialExpression Expression;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;
    var int GCC64_Padding;
};
enum EXbox360GammaQuality
{
    XGQ_Default,
    XGQ_High,
    XGQ_Low,
};
enum EBIOPhysicalMaterialAutoEnum
{
    PHYM_Empty,
};
enum EMaterialLightingModel
{
    MLM_Phong,
    MLM_NonDirectional,
    MLM_Unlit,
    MLM_SHPRT,
    MLM_Custom,
    MLM_Anisotropic,
};
enum EBlendMode
{
    BLEND_Opaque,
    BLEND_Masked,
    BLEND_Translucent,
    BLEND_Additive,
    BLEND_Modulate,
    BLEND_SoftMasked,
    BLEND_AlphaComposite,
};

var array<MaterialExpression> Expressions;
var const native duplicatetransient Pointer MaterialResources[2];
var const native duplicatetransient Pointer DefaultMaterialInstances[2];
var Class<PhysicalMaterial> PhysicalMaterial;
var VectorMaterialInput Normal;
var VectorMaterialInput AnisotropicDirection;
var VectorMaterialInput WorldPositionOffset;
var Vector2MaterialInput Distortion;
var ColorMaterialInput DiffuseColor;
var ScalarMaterialInput DiffusePower;
var ColorMaterialInput SpecularColor;
var ScalarMaterialInput SpecularPower;
var ColorMaterialInput EmissiveColor;
var ScalarMaterialInput Opacity;
var ScalarMaterialInput OpacityMask;
var ColorMaterialInput CustomLighting;
var ColorMaterialInput CustomSkylightDiffuse;
var ScalarMaterialInput TwoSidedLightingMask;
var ColorMaterialInput TwoSidedLightingColor;
var(Material) PhysicalMaterial PhysMaterial;
var(PhysicalMaterialMask) Texture2D PhysMaterialMask;
var(PhysicalMaterialMask) int PhysMaterialMaskUVChannel;
var(PhysicalMaterialMask) PhysicalMaterial BlackPhysicalMaterial;
var(PhysicalMaterialMask) PhysicalMaterial WhitePhysicalMaterial;
var(Material) float OpacityMaskClipValue;
var(Usage) const int nNumWounds;
var duplicatetransient Material FallbackMaterial;
var(Material) float MaterialDepthBias;
var(Material) float MaterialDownsampleThreshold;
var(Material) bool TwoSided;
var(Material) bool TwoSidedSeparatePass;
var(Translucency) bool bDisableDepthTest;
var(Translucency) bool bAllowFog;
var(Translucency) bool bAllowTranslucencyDoF;
var(Translucency) bool bUseOneLayerDistortion;
var(Translucency) bool bUseLitTranslucencyDepthPass;
var(Translucency) bool bUseLitTranslucencyPostRenderDepthPass;
var(Translucency) bool bCastLitTranslucencyShadowAsMasked;
var(Translucency) bool bHairPass;
var(Translucency) bool bUseSurfaceTranslucencyDepthPass;
var(MutuallyExclusiveUsage) const bool bUsedAsLightFunction;
var(MutuallyExclusiveUsage) const bool bUsedWithFogVolumes;
var const duplicatetransient bool bUsedAsSpecialEngineMaterial;
var(Usage) const bool bUsedWithSkeletalMesh;
var(Usage) const bool bUsedWithFracturedMeshes;
var const bool bUsedWithParticleSystem;
var(Usage) const bool bUsedWithParticleSprites;
var(Usage) const bool bUsedWithBeamTrails;
var(Usage) const bool bUsedWithParticleSubUV;
var(Usage) const bool bUsedWithFoliage;
var(Usage) const bool bUsedWithSpeedTree;
var(Usage) const bool bUsedWithStaticLighting;
var(Usage) const bool bUsedWithLensFlare;
var(Usage) const bool bUsedWithGammaCorrection;
var(Usage) const bool bUsedWithInstancedMeshParticles;
var(Usage) const bool bUsedWithFluidSurfaces;
var(MutuallyExclusiveUsage) const bool bUsedWithDecals;
var(Usage) const bool bUsedWithMaterialEffect;
var(Usage) const bool bUsedWithMorphTargets;
var(Usage) const bool bUsedWithRadialBlur;
var(Usage) const bool bUsedWithInstancedMeshes;
var(Usage) const bool bUsedWithSplineMeshes;
var(Usage) const bool bUsedWithAPEXMeshes;
var(Usage) const bool bUsedWithLightEnvironments;
var(Usage) const bool bUsedWithVectorLightMaps;
var(Usage) const bool bUsedWithSimpleLightMaps;
var(Usage) const bool bUsedWithScreenDoorFade;
var(Material) bool Wireframe;
var(Material) bool bPerPixelCameraVector;
var bool bIsFallbackMaterial;
var(Material) bool bForceFullPrecision;
var bool bUsesDistortion;
var bool bIsMasked;
var transient duplicatetransient bool bIsPreviewMaterial;
var const transient bool EditorRecompileAlways;
var const bool AllowsEffectsMaterials;
var(Material) EBlendMode BlendMode;
var(Material) EMaterialLightingModel LightingModel;
var(Material) EXbox360GammaQuality Xbox360GammaQuality;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DiffuseColor = {
                    UseConstant = FALSE, 
                    Constant = {B = 128, G = 128, R = 128, A = 0}, 
                    Expression = None, 
                    Mask = 0, 
                    MaskR = 0, 
                    MaskG = 0, 
                    MaskB = 0, 
                    MaskA = 0, 
                    GCC64_Padding = 0
                   }
    DiffusePower = {
                    UseConstant = FALSE, 
                    Constant = 1.0, 
                    Expression = None, 
                    Mask = 0, 
                    MaskR = 0, 
                    MaskG = 0, 
                    MaskB = 0, 
                    MaskA = 0, 
                    GCC64_Padding = 0
                   }
    SpecularColor = {
                     UseConstant = FALSE, 
                     Constant = {B = 128, G = 128, R = 128, A = 0}, 
                     Expression = None, 
                     Mask = 0, 
                     MaskR = 0, 
                     MaskG = 0, 
                     MaskB = 0, 
                     MaskA = 0, 
                     GCC64_Padding = 0
                    }
    SpecularPower = {
                     UseConstant = FALSE, 
                     Constant = 15.0, 
                     Expression = None, 
                     Mask = 0, 
                     MaskR = 0, 
                     MaskG = 0, 
                     MaskB = 0, 
                     MaskA = 0, 
                     GCC64_Padding = 0
                    }
    Opacity = {
               UseConstant = FALSE, 
               Constant = 1.0, 
               Expression = None, 
               Mask = 0, 
               MaskR = 0, 
               MaskG = 0, 
               MaskB = 0, 
               MaskA = 0, 
               GCC64_Padding = 0
              }
    OpacityMask = {
                   UseConstant = FALSE, 
                   Constant = 1.0, 
                   Expression = None, 
                   Mask = 0, 
                   MaskR = 0, 
                   MaskG = 0, 
                   MaskB = 0, 
                   MaskA = 0, 
                   GCC64_Padding = 0
                  }
    TwoSidedLightingColor = {
                             UseConstant = FALSE, 
                             Constant = {B = 255, G = 255, R = 255, A = 0}, 
                             Expression = None, 
                             Mask = 0, 
                             MaskR = 0, 
                             MaskG = 0, 
                             MaskB = 0, 
                             MaskA = 0, 
                             GCC64_Padding = 0
                            }
    OpacityMaskClipValue = 0.333299994
    bAllowFog = TRUE
    EditorRecompileAlways = TRUE
}