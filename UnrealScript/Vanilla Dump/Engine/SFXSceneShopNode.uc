Class SFXSceneShopNode
    native
    abstract;

struct native SFXSSNodePin 
{
    var string sLinkName;
    var array<SFXSSNodePinLink> aLinks;
};
struct native SFXSSNodePinLink 
{
    var SFXSceneShopNode pLinkedNode;
    var int nLinkedIndex;
};

var array<SFXSSNodePin> m_aOutputPins;
var array<SFXSSNodePin> m_aInputPins;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}