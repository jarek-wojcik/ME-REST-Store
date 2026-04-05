Class BioSeqAct_ScalarMathUnit extends SequenceAction
    native;

enum EScalarMathOps
{
    SMO_Add,
    SMO_Subtract,
    SMO_Multiply,
    SMO_Divide,
    SMO_Exponent,
    SMO_Modulo,
};

var int IntX;
var int IntY;
var int IntZ;
var float FloatX;
var float FloatY;
var float FloatZ;
var(BioSeqAct_ScalarMathUnit) bool XIsFloat;
var(BioSeqAct_ScalarMathUnit) bool YIsFloat;
var(BioSeqAct_ScalarMathUnit) bool ZIsFloat;
var(BioSeqAct_ScalarMathUnit) EScalarMathOps Operation;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "X", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'IntX', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Y", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'IntY', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Z", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'IntZ', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}