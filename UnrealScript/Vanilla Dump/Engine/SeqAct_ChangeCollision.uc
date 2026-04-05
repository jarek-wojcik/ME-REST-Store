Class SeqAct_ChangeCollision extends SequenceAction
    native;

var(SeqAct_ChangeCollision) const editconst bool bCollideActors;
var(SeqAct_ChangeCollision) const editconst bool bBlockActors;
var(SeqAct_ChangeCollision) const editconst bool bIgnoreEncroachers;
var(SeqAct_ChangeCollision) ECollisionType CollisionType;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}