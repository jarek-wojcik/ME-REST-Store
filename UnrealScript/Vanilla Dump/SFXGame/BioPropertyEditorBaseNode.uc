Class BioPropertyEditorBaseNode
    native;

var string m_sNodeDisplayName;
var array<BioPropertyEditorBaseNode> m_aChildren;
var array<BioPropertyEditorBaseNode> m_aTraversedStack;
var string m_sParentGenName;
var int m_nCurrentlySelectedChild;
var int m_nScrollBoxFirstIndex;
var int m_nScrollBoxSize;
var BioInGamePropertyEditor m_oTop;
var BioPropertyEditorBaseNode m_oParent;
var Color m_colour;
var int m_nGeneration;

public final native function Color getColour();

public native function string getDisplayText(bool selectable);

public final native function BioPropertyEditorBaseNode GetSelectablesParent();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nScrollBoxSize = 25
    m_colour = {B = 128, G = 128, R = 128, A = 255}
}