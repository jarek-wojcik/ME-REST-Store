Class MaterialExpressionDepthBiasedBlend extends MaterialExpression within Material
    native
    collapsecategories;

var ExpressionInput RGB;
var ExpressionInput Alpha;
var ExpressionInput Bias;
var(MaterialExpressionDepthBiasedBlend) float BiasScale;
var(MaterialExpressionDepthBiasedBlend) bool bNormalize;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BiasScale = 1.0
}