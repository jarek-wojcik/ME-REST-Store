Class MaterialExpressionAntialiasedTextureMask extends MaterialExpressionTextureSampleParameter2D within Material
    native
    collapsecategories;

enum ETextureColorChannel
{
    TCC_Red,
    TCC_Green,
    TCC_Blue,
    TCC_Alpha,
};

var(MaterialExpressionAntialiasedTextureMask) float Threshold;
var(MaterialExpressionAntialiasedTextureMask) ETextureColorChannel Channel;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Threshold = 0.5
    Channel = ETextureColorChannel.TCC_Alpha
}