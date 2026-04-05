Class RB_PulleyJointActor extends RB_ConstraintActor
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=RB_ConstraintDrawComponent Name=MyConDrawComponent
        ReplacementPrimitive = None
    End Template
    Begin Template Class=RB_ConstraintInstance Name=MyConstraintInstance
    End Template
    Begin Object Class=RB_PulleyJointSetup Name=MyPulleyJointSetup
    End Object
    ConstraintSetup = MyPulleyJointSetup
    ConstraintInstance = MyConstraintInstance
    Components = (None, MyConDrawComponent)
}