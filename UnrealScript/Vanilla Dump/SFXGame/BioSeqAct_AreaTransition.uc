Class BioSeqAct_AreaTransition extends SequenceAction;

var(BioSeqAct_AreaTransition) string Arguments;
var(BioSeqAct_AreaTransition) Name AreaName;
var(BioSeqAct_AreaTransition) Name StartPoint;

public event function Activated()
{
    BioWorldInfo(GetWorldInfo()).MoveToArea(AreaName, StartPoint, Arguments);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}