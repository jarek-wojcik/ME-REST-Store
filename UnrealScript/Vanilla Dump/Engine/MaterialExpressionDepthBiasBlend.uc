Class MaterialExpressionDepthBiasBlend extends MaterialExpressionTextureSample within Material
    native
    collapsecategories;

var ExpressionInput Bias;
var(MaterialExpressionDepthBiasBlend) float BiasScale;
var(MaterialExpressionDepthBiasBlend) bool bNormalize;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BiasScale = 1.0
}