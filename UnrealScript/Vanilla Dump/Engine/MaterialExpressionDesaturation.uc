Class MaterialExpressionDesaturation extends MaterialExpression within Material
    native
    collapsecategories;

var ExpressionInput Input;
var ExpressionInput Percent;
var(MaterialExpressionDesaturation) LinearColor LuminanceFactors;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LuminanceFactors = {R = 0.300000012, G = 0.589999974, B = 0.109999999, A = 0.0}
}