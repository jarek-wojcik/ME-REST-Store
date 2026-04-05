Class NavMeshPathConstraint
    native;

var NavMeshPathConstraint NextConstraint;
var int NumNodesProcessed;
var int NumThrownOutNodes;
var float AddedDirectCost;
var float AddedHeuristicCost;

public event function string GetDumpString()
{
    return string(Self);
}
public event function Recycle()
{
    NextConstraint = None;
    NumThrownOutNodes = 0;
    AddedDirectCost = 0.0;
    AddedHeuristicCost = 0.0;
    NumNodesProcessed = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}