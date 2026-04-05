Class BioAnimMovementSync
    native
    transient;

struct native BioAnimMovementSyncNode 
{
    var AnimNode Node;
    var AnimNode NodeWeight;
};

var transient array<BioAnimMovementSyncNode> MovementNodes;
var transient bool bInitialized;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}