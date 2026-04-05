Class MaterialExpressionRotator extends MaterialExpression within Material
    native
    collapsecategories;

var ExpressionInput Coordinate;
var ExpressionInput Time;
var(MaterialExpressionRotator) float CenterX;
var(MaterialExpressionRotator) float CenterY;
var(MaterialExpressionRotator) float Speed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CenterX = 0.5
    CenterY = 0.5
    Speed = 0.25
}