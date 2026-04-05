Class BioMaterialExpressionKeyedFlipbook extends MaterialExpression within Material
    native;

var ExpressionInput Coord;
var ExpressionInput Time;
var(BioMaterialExpressionKeyedFlipbook) int FlipTexRows;
var(BioMaterialExpressionKeyedFlipbook) int FlipTexCols;
var(BioMaterialExpressionKeyedFlipbook) Texture2D FlipTex;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FlipTexRows = 1
    FlipTexCols = 1
}