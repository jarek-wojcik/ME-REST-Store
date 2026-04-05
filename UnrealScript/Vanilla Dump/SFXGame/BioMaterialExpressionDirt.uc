Class BioMaterialExpressionDirt extends MaterialExpression within Material
    native;

var ExpressionInput Input;
var(BioMaterialExpressionDirt) Name GrimeScaleParamName;
var(BioMaterialExpressionDirt) Name GrimeTexParamName;
var(BioMaterialExpressionDirt) Texture2D GrimeTex;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GrimeScaleParamName = 'Scalar__Grime'
    GrimeTexParamName = 'Tex__Grime'
}