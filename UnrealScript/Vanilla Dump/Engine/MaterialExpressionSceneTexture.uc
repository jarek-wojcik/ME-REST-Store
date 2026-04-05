Class MaterialExpressionSceneTexture extends MaterialExpression within Material
    native
    collapsecategories;

enum ESceneTextureType
{
    SceneTex_Lighting,
};

var ExpressionInput Coordinates;
var(MaterialExpressionSceneTexture) bool ScreenAlign;
var(MaterialExpressionSceneTexture) ESceneTextureType SceneTextureType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}