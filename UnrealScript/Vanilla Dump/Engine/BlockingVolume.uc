Class BlockingVolume extends Volume
    native
    placeable;

var(BlockingVolume) array<Name> lstAffectedActors;
var(BlockingVolume) bool bBlockCamera;
var(BlockingVolume) bool bInclusionaryList;
var(BlockingVolume) bool bSafeFall;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(FALSE);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        CollisionComponent.SetBlockRigidBody(!CollisionComponent.BlockRigidBody);
    }
    Super.OnToggle(Action);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_BlockingVolume
        BlockActors = TRUE
        BlockRigidBody = TRUE
        bDisableAllRigidBody = FALSE
    End Template
    bBlockCamera = TRUE
    bInclusionaryList = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bWorldGeometry = TRUE
    bBlockActors = TRUE
    bForceAllowKismetModification = TRUE
}