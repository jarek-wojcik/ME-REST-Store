Class RB_ConstraintActor extends RigidBodyBase
    native
    placeable
    abstract;

var(RB_ConstraintActor) Actor ConstraintActor1;
var(RB_ConstraintActor) Actor ConstraintActor2;
var(Pulley) Actor PulleyPivotActor1;
var(Pulley) Actor PulleyPivotActor2;
var(RB_ConstraintActor) export noclear RB_ConstraintSetup ConstraintSetup;
var(RB_ConstraintActor) export noclear RB_ConstraintInstance ConstraintInstance;
var(RB_ConstraintActor) const bool bDisableCollision;
var(RB_ConstraintActor) bool bUpdateActor1RefFrame;
var(RB_ConstraintActor) bool bUpdateActor2RefFrame;

public final native function InitConstraint(Actor Actor1, Actor Actor2, optional Name Actor1Bone, optional Name Actor2Bone, optional float BreakThreshold);

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (Physics != EPhysics.PHYS_RigidBody)
        {
            SetPhysics(10);
            InitConstraint(ConstraintActor1, ConstraintActor2, ConstraintSetup.ConstraintBone1, ConstraintSetup.ConstraintBone2);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (Physics != EPhysics.PHYS_None)
        {
            SetPhysics(0);
            TermConstraint();
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (Physics != EPhysics.PHYS_None)
        {
            SetPhysics(0);
            TermConstraint();
        }
        else
        {
            SetPhysics(10);
            InitConstraint(ConstraintActor1, ConstraintActor2, ConstraintSetup.ConstraintBone1, ConstraintSetup.ConstraintBone2);
        }
    }
}
public final native function SetDisableCollision(bool NewDisableCollision);

public final native function TermConstraint();

public simulated function OnDestroy(SeqAct_Destroy Action)
{
    TermConstraint();
}
public simulated function OnToggleConstraintDrive(SeqAct_ToggleConstraintDrive Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (Action.bEnableLinearPositionDrive)
        {
            ConstraintInstance.SetLinearPositionDrive(TRUE, TRUE, TRUE);
        }
        if (Action.bEnableLinearvelocityDrive)
        {
            ConstraintInstance.SetLinearVelocityDrive(TRUE, TRUE, TRUE);
        }
        if (Action.bEnableAngularPositionDrive)
        {
            ConstraintInstance.SetAngularPositionDrive(TRUE, TRUE);
        }
        if (Action.bEnableAngularVelocityDrive)
        {
            ConstraintInstance.SetAngularVelocityDrive(TRUE, TRUE);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ConstraintInstance.SetLinearPositionDrive(FALSE, FALSE, FALSE);
        ConstraintInstance.SetLinearVelocityDrive(FALSE, FALSE, FALSE);
        ConstraintInstance.SetAngularPositionDrive(FALSE, FALSE);
        ConstraintInstance.SetAngularVelocityDrive(FALSE, FALSE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=RB_ConstraintDrawComponent Name=MyConDrawComponent
        ReplacementPrimitive = None
    End Object
    Begin Object Class=RB_ConstraintInstance Name=MyConstraintInstance
    End Object
    ConstraintInstance = MyConstraintInstance
    bUpdateActor1RefFrame = TRUE
    bUpdateActor2RefFrame = TRUE
    Components = (None, MyConDrawComponent)
    DrawScale = 0.5
    bHidden = TRUE
    bNoDelete = TRUE
    bEdShouldSnap = TRUE
    Physics = EPhysics.PHYS_RigidBody
    TickGroup = ETickingGroup.TG_PostAsyncWork
}