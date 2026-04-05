Class RB_ConstraintActorSpawnable extends RB_ConstraintActor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=RB_ConstraintDrawComponent Name=MyConDrawComponent
        ReplacementPrimitive = None
    End Template
    Begin Template Class=RB_ConstraintInstance Name=MyConstraintInstance
    End Template
    Begin Object Class=RB_ConstraintSetup Name=MyConstraintSetup
    End Object
    ConstraintSetup = MyConstraintSetup
    ConstraintInstance = MyConstraintInstance
    Components = (None, MyConDrawComponent)
    bNoDelete = FALSE
}