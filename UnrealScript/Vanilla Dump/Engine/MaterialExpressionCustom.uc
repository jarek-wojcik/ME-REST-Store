Class MaterialExpressionCustom extends MaterialExpression within Material
    native
    collapsecategories;

struct native CustomInput 
{
    var(CustomInput) string InputName;
    var edithide ExpressionInput Input;
};
enum ECustomMaterialOutputType
{
    CMOT_Float1,
    CMOT_Float2,
    CMOT_Float3,
    CMOT_Float4,
};

var(MaterialExpressionCustom) edittextbox string Code;
var(MaterialExpressionCustom) string Description;
var(MaterialExpressionCustom) array<CustomInput> Inputs;
var(MaterialExpressionCustom) ECustomMaterialOutputType OutputType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Description = "Custom"
    Inputs = ({
               InputName = "", 
               Input = {
                        Expression = None, 
                        Mask = 0, 
                        MaskR = 0, 
                        MaskG = 0, 
                        MaskB = 0, 
                        MaskA = 0, 
                        GCC64_Padding = 0
                       }
              }
             )
    OutputType = ECustomMaterialOutputType.CMOT_Float3
}