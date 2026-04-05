Class BioPropertyEditorPropertyNode extends BioPropertyEditorBaseNode
    native;

var string m_sValueString;
var string m_sDeliminator;
var native Pointer Base;

public native function string getDisplayText(bool selectable);

public final native function bool MakeNodes(string thisOneOnly);

public final native function SetObject(Object Obj);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sDeliminator = ": "
}