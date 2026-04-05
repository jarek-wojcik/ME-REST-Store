Class BioAnimNodeBlendScalarBehavior
    native
    editinlinenew
    abstract;

struct native BioAnimScalarNodeBehaviorDef 
{
    var array<BioAnimScalarNodeChildDef> Children;
    var string Description;
    var float BlendPctPerSecond;
    var float DefaultScalar;
    var bool BlendInstant;
};
struct native BioAnimScalarNodeChildDef 
{
    var BioScalarBlendParams BlendParams;
    var Name Name;
};

var array<BioAnimScalarNodeBehaviorDef> m_aNodeDefinitions;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}