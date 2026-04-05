Class SFXUberPostProcessEffect extends UberPostProcessEffect
    native;

var(SFXUberPostProcessEffect) editconst Texture2D FilmGrainTexture;
var(SFXUberPostProcessEffect) editconst MaterialInterface VignetteMaterial;
var(SFXUberPostProcessEffect) editconst MaterialInterface FilmGrainAndVignetteMaterial;
var(SFXUberPostProcessEffect) editconst MaterialInterface FilmGrainMaterial;
var(SFXUberPostProcessEffect) bool EnableFilmicResponse;
var(SFXUberPostProcessEffect) bool EnableVignette;
var(SFXUberPostProcessEffect) bool EnableFilmgrain;
var(SFXUberPostProcessEffect) bool EnableHardwareGamma;
var(SFXUberPostProcessEffect) bool EnableMergedMaterialEffects;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FilmGrainTexture = TextureFlipBook'BioVFX_FB_RenderSyle.FG_Noise_FlipBook'
    VignetteMaterial = Material'BioVFX_FB_RenderSyle.PostUberShaderVignette'
    FilmGrainAndVignetteMaterial = Material'BioVFX_FB_RenderSyle.PostUberShaderVignetteAndFilmGrain'
    FilmGrainMaterial = Material'BioVFX_FB_RenderSyle.Render_Style_Filmgrain01'
    EnableFilmicResponse = TRUE
    EnableVignette = TRUE
    EnableFilmgrain = TRUE
    EnableHardwareGamma = TRUE
    EnableMergedMaterialEffects = TRUE
    bShowInEditor = TRUE
}