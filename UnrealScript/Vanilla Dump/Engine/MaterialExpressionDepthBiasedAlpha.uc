Class MaterialExpressionDepthBiasedAlpha extends MaterialExpression within Material
    native
    collapsecategories;

var ExpressionInput Alpha;
var ExpressionInput Bias;
var(MaterialExpressionDepthBiasedAlpha) float BiasScale;
var(MaterialExpressionDepthBiasedAlpha) bool bNormalize;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BiasScale = 1.0
}