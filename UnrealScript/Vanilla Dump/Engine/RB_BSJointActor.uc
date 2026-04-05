Class RB_BSJointActor extends RB_ConstraintActor
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=RB_BSJointSetup Name=MyBSJointSetup
    End Object
    Begin Template Class=RB_ConstraintDrawComponent Name=MyConDrawComponent
        ReplacementPrimitive = None
    End Template
    Begin Template Class=RB_ConstraintInstance Name=MyConstraintInstance
    End Template
    ConstraintSetup = MyBSJointSetup
    ConstraintInstance = MyConstraintInstance
    Components = (None, MyConDrawComponent)
}