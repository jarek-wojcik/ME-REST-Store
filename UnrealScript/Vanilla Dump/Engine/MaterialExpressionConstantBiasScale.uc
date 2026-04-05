Class MaterialExpressionConstantBiasScale extends MaterialExpression within Material
    native;

var ExpressionInput Input;
var(MaterialExpressionConstantBiasScale) float Bias;
var(MaterialExpressionConstantBiasScale) float Scale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bias = 1.0
    Scale = 0.5
}