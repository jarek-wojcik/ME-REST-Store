Class MorphNodeWeightBase extends MorphNodeBase
    native
    abstract;

struct native MorphNodeConn 
{
    var array<MorphNodeBase> ChildNodes;
    var Name ConnName;
    var int DrawY;
};

var array<MorphNodeConn> NodeConns;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}