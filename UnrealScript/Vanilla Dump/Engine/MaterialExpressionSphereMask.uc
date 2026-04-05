Class MaterialExpressionSphereMask extends MaterialExpression within Material
    native;

var ExpressionInput A;
var ExpressionInput B;
var(MaterialExpressionSphereMask) float AttenuationRadius;
var(MaterialExpressionSphereMask) float HardnessPercent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AttenuationRadius = 256.0
    HardnessPercent = 100.0
}