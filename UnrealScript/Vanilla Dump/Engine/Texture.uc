Class Texture extends Surface
    native
    abstract;

enum TextureMipGenSettings
{
    TMGS_FromTextureGroup,
    TMGS_SimpleAverage,
    TMGS_Sharpen0,
    TMGS_Sharpen1,
    TMGS_Sharpen2,
    TMGS_Sharpen3,
    TMGS_Sharpen4,
    TMGS_Sharpen5,
    TMGS_Sharpen6,
    TMGS_Sharpen7,
    TMGS_Sharpen8,
    TMGS_Sharpen9,
    TMGS_Sharpen10,
};
struct native FadeMipMapChannelsContainer 
{
    var(FadeMipMapChannelsContainer) bool FadeRedChannel;
    var(FadeMipMapChannelsContainer) bool FadeGreenChannel;
    var(FadeMipMapChannelsContainer) bool FadeBlueChannel;
    var(FadeMipMapChannelsContainer) bool FadeAlphaChannel;
};
struct native TextureGroupContainer 
{
    var(TextureGroupContainer) const bool TEXTUREGROUP_World;
    var(TextureGroupContainer) const bool TEXTUREGROUP_WorldNormalMap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_WorldSpecular;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Character;
    var(TextureGroupContainer) const bool TEXTUREGROUP_CharacterNormalMap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_CharacterSpecular;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Weapon;
    var(TextureGroupContainer) const bool TEXTUREGROUP_WeaponNormalMap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_WeaponSpecular;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Vehicle;
    var(TextureGroupContainer) const bool TEXTUREGROUP_VehicleNormalMap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_VehicleSpecular;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Cinematic;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Effects;
    var(TextureGroupContainer) const bool TEXTUREGROUP_EffectsNotFiltered;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Skybox;
    var(TextureGroupContainer) const bool TEXTUREGROUP_UI;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Lightmap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_RenderTarget;
    var(TextureGroupContainer) const bool TEXTUREGROUP_MobileFlattened;
    var(TextureGroupContainer) const bool TEXTUREGROUP_ProcBuilding_Face;
    var(TextureGroupContainer) const bool TEXTUREGROUP_ProcBuilding_LightMap;
    var(TextureGroupContainer) const bool TEXTUREGROUP_Shadowmap;
};
enum TextureGroup
{
    TEXTUREGROUP_World,
    TEXTUREGROUP_WorldNormalMap,
    TEXTUREGROUP_Lightmap,
    TEXTUREGROUP_Shadowmap,
    TEXTUREGROUP_RenderTarget,
    TEXTUREGROUP_Character_Diff,
    TEXTUREGROUP_Character_Norm,
    TEXTUREGROUP_Character_Spec,
    TEXTUREGROUP_Environment_512,
    TEXTUREGROUP_Environment_256,
    TEXTUREGROUP_Environment_128,
    TEXTUREGROUP_Environment_64,
    TEXTUREGROUP_VFX_512,
    TEXTUREGROUP_VFX_256,
    TEXTUREGROUP_VFX_128,
    TEXTUREGROUP_VFX_64,
    TEXTUREGROUP_UI,
    TEXTUREGROUP_AmbientLightMap,
    TEXTUREGROUP_Environment_1024,
    TEXTUREGROUP_VFX_1024,
    TEXTUREGROUP_APL_128,
    TEXTUREGROUP_APL_256,
    TEXTUREGROUP_APL_512,
    TEXTUREGROUP_APL_1024,
    TEXTUREGROUP_Character_1024,
    TEXTUREGROUP_Promotional,
    TEXTUREGROUP_ColorLookupTable,
};
enum TextureAddress
{
    TA_Wrap,
    TA_Clamp,
    TA_Mirror,
};
enum TextureFilter
{
    TF_Nearest,
    TF_Linear,
};
enum EPixelFormat
{
    PF_Unknown,
    PF_A32B32G32R32F,
    PF_A8R8G8B8,
    PF_G8,
    PF_G16,
    PF_DXT1,
    PF_DXT3,
    PF_DXT5,
    PF_UYVY,
    PF_FloatRGB,
    PF_FloatRGBA,
    PF_DepthStencil,
    PF_ShadowDepth,
    PF_FilteredShadowDepth,
    PF_R32F,
    PF_G16R16,
    PF_G16R16F,
    PF_G16R16F_FILTER,
    PF_G32R32F,
    PF_A2B10G10R10,
    PF_A16B16G16R16,
    PF_D24,
    PF_R16F,
    PF_R16F_FILTER,
    PF_BC5,
    PF_V8U8,
    PF_A1,
    PF_NormalMap_LQ,
    PF_NormalMap_HQ,
};
enum TextureCompressionSettings
{
    TC_Default,
    TC_Normalmap,
    TC_Displacementmap,
    TC_NormalmapAlpha,
    TC_Grayscale,
    TC_HighDynamicRange,
    TC_OneBitAlpha,
    TC_NormalmapUncompressed,
    TC_NormalmapBC5,
    TC_OneBitMonochrome,
    TC_NormalmapHQ,
};

var const native Pointer Resource;
var(Texture) float UnpackMin[4];
var(Texture) float UnpackMax[4];
var(Texture) int LODBias;
var transient int CachedCombinedLODBias;
var(Texture) int NumCinematicMipLevels;
var(Texture) float AdjustBrightness;
var(Texture) float AdjustBrightnessCurve;
var(Texture) float AdjustVibrance;
var(Texture) float AdjustSaturation;
var(Texture) float AdjustRGBCurve;
var(Texture) float AdjustHue;
var const int InternalFormatLODBias;
var(Texture) int OneBitAlphaThreshold;
var(Texture) FadeMipMapChannelsContainer FadeMipMapChannels;
var(Texture) bool SRGB;
var bool RGBE;
var bool bIsSourceArtUncompressed;
var(Texture) bool CompressionNoAlpha;
var(Texture) bool CompressionNone;
var(Texture) bool CompressionNoMipmaps;
var(Texture) bool CompressionFullDynamicRange;
var(Texture) bool DeferCompression;
var(Texture) bool NeverStream;
var(Texture) bool bDitherMipMapAlpha;
var(Texture) bool bPreserveBorderR;
var(Texture) bool bPreserveBorderG;
var(Texture) bool bPreserveBorderB;
var(Texture) bool bPreserveBorderA;
var const bool bNoTiling;
var const transient bool bAsyncResourceReleaseHasBeenStarted;
var const transient bool bUseCinematicMipLevels;
var(Texture) bool AS16;
var(Texture) TextureCompressionSettings CompressionSettings;
var(Texture) TextureFilter Filter;
var(Texture) TextureGroup LODGroup;
var(Texture) TextureMipGenSettings MipGenSettings;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    UnpackMax[0] = 1.0
    UnpackMax[1] = 1.0
    UnpackMax[2] = 1.0
    UnpackMax[3] = 1.0
    AdjustBrightness = 1.0
    AdjustBrightnessCurve = 1.0
    AdjustSaturation = 1.0
    AdjustRGBCurve = 1.0
    OneBitAlphaThreshold = 10
    SRGB = TRUE
    Filter = TextureFilter.TF_Linear
}