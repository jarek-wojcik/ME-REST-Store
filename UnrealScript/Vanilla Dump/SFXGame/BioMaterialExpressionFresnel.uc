Class BioMaterialExpressionFresnel extends MaterialExpression within Material
    native;

var ExpressionInput Normal;
var(BioMaterialExpressionFresnel) float Power;
var(BioMaterialExpressionFresnel) bool Inverted;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Power = 1.0
}