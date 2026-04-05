Class BioAnimCheckBlendOut
    native
    transient;

struct native BioAnimCheckBlendOutPath 
{
    var init array<BioAnimCheckBlendOutNode> Nodes;
    var native Pointer Next;
};
struct native BioAnimCheckBlendOutNode 
{
    var AnimNodeBlendList Node;
    var int Index;
};

var transient BioAnimCheckBlendOutPath PathsLL;
var transient AnimNode Parent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}