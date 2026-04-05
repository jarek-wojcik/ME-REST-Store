Class MaterialExpressionTransform extends MaterialExpression within Material
    native
    collapsecategories;

enum EMaterialVectorCoordTransform
{
    TRANSFORM_World,
    TRANSFORM_View,
    TRANSFORM_Local,
    TRANSFORM_Tangent,
};
enum EMaterialVectorCoordTransformSource
{
    TRANSFORMSOURCE_World,
    TRANSFORMSOURCE_Local,
    TRANSFORMSOURCE_Tangent,
};

var ExpressionInput Input;
var(MaterialExpressionTransform) const EMaterialVectorCoordTransformSource TransformSourceType;
var(MaterialExpressionTransform) const EMaterialVectorCoordTransform TransformType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TransformSourceType = EMaterialVectorCoordTransformSource.TRANSFORMSOURCE_Tangent
}