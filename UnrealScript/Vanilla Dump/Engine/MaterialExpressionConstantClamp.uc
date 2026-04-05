Class MaterialExpressionConstantClamp extends MaterialExpression within Material
    native;

var ExpressionInput Input;
var(MaterialExpressionConstantClamp) float Min;
var(MaterialExpressionConstantClamp) float Max;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Max = 1.0
}