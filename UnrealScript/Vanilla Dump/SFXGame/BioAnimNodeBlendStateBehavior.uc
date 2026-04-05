Class BioAnimNodeBlendStateBehavior
    native
    editinlinenew
    abstract;

struct native BioAnimStateNodeBehaviorDef 
{
    var array<BioAnimStateNodeChildDef> Children;
};
struct native BioAnimStateNodeChildDef 
{
    var BioAnimBlendParams BlendParams;
    var Name Name;
    var float DefaultWeight;
};

var array<BioAnimStateNodeBehaviorDef> m_aNodeDefinitions;
var float m_fQueryPlayTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}