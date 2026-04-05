Class ShadowMap2D
    native
    noexport;

var const ShadowMapTexture2D Texture;
var const Vector2D CoordinateScale;
var const Vector2D CoordinateBias;
var const Guid LightGuid;
var const bool bIsShadowFactorTexture;
var editinline transient export InstancedStaticMeshComponent Component;
var transient int InstanceIndex;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bIsShadowFactorTexture = TRUE
}