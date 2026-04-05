Class MaterialExpressionTextureCoordinate extends MaterialExpression within Material
    native
    collapsecategories;

var(MaterialExpressionTextureCoordinate) int CoordinateIndex;
var(MaterialExpressionTextureCoordinate) float UTiling;
var(MaterialExpressionTextureCoordinate) float VTiling;
var(MaterialExpressionTextureCoordinate) bool UnMirrorU;
var(MaterialExpressionTextureCoordinate) bool UnMirrorV;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    UTiling = 1.0
    VTiling = 1.0
}