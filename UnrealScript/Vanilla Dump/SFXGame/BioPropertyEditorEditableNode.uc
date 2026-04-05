Class BioPropertyEditorEditableNode extends BioPropertyEditorPropertyNode
    native;

var Property prop;
var int integerVal;
var float floatVal;
var Property m_arrayProperty;
var float StepSize;
var bool boolVal;
var bool alreadyEdited;
var byte byteVal;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StepSize = 1.0
}