Class MaterialExpressionBumpOffset extends MaterialExpression within Material
    native
    collapsecategories;

var ExpressionInput Coordinate;
var ExpressionInput Height;
var(MaterialExpressionBumpOffset) float HeightRatio;
var(MaterialExpressionBumpOffset) float ReferencePlane;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HeightRatio = 0.0500000007
    ReferencePlane = 0.5
}