Class MaterialExpression within Material
    native
    abstract;

struct ExpressionInput 
{
    var MaterialExpression Expression;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;
    var int GCC64_Padding;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}