Class BioPropertyEditorEditNode extends BioPropertyEditorPropertyNode
    native;

var Property prop;
var float StepSize;
var float floatVal;
var int otherVal;

public native function string getDisplayText(bool selectable);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}