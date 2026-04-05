Class BioMaterialExpressionEffectMatBaseProperty extends MaterialExpression within Material
    native
    collapsecategories;

var MaterialExpression Input;
var(BioMaterialExpressionEffectMatBaseProperty) EMaterialProperty BaseProperty;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BaseProperty = EMaterialProperty.MP_DiffuseColor
}