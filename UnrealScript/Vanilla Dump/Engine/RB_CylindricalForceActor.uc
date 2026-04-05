Class RB_CylindricalForceActor extends RigidBodyBase
    native
    placeable;

var(RB_CylindricalForceActor) editinline export DrawCylinderComponent RenderComponent;
var(RB_CylindricalForceActor) interp float RadialStrength;
var(RB_CylindricalForceActor) interp float RotationalStrength;
var(RB_CylindricalForceActor) interp float LiftStrength;
var(RB_CylindricalForceActor) interp float LiftFalloffHeight;
var(RB_CylindricalForceActor) interp float EscapeVelocity;
var(RB_CylindricalForceActor) interp float ForceRadius;
var(RB_CylindricalForceActor) interp float ForceTopRadius;
var(RB_CylindricalForceActor) interp float ForceHeight;
var(RB_CylindricalForceActor) interp float HeightOffset;
var(RB_CylindricalForceActor) const RBCollisionChannelContainer CollideWithChannels;
var(RB_CylindricalForceActor) bool bForceActive;
var(RB_CylindricalForceActor) bool bForceApplyToCloth;
var(RB_CylindricalForceActor) bool bForceApplyToFluid;
var(RB_CylindricalForceActor) bool bForceApplyToRigidBodies;
var(RB_CylindricalForceActor) bool bForceApplyToProjectiles;

public simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bForceActive = TRUE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bForceActive = FALSE;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bForceActive = !bForceActive;
    }
    SetForcedInitialReplicatedProperty(BoolProperty'bForceActive', bForceActive == default.bForceActive);
}

replication
{
    if (bNetDirty)
        bForceActive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawCylinderComponent Name=DrawCylinder0
        CylinderRadius = 200.0
        CylinderTopRadius = 200.0
        CylinderHeight = 200.0
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawCylinder0
    EscapeVelocity = 10000.0
    ForceRadius = 200.0
    ForceTopRadius = 200.0
    ForceHeight = 200.0
    CollideWithChannels = {
                           Default = TRUE, 
                           Nothing = FALSE, 
                           Pawn = TRUE, 
                           Vehicle = TRUE, 
                           Water = TRUE, 
                           GameplayPhysics = TRUE, 
                           EffectPhysics = TRUE, 
                           Untitled1 = TRUE, 
                           Untitled2 = TRUE, 
                           Untitled3 = TRUE, 
                           Untitled4 = FALSE, 
                           Cloth = TRUE, 
                           FluidDrain = TRUE, 
                           SoftBody = FALSE, 
                           FracturedMeshPart = FALSE, 
                           BlockingVolume = FALSE, 
                           DeadPawn = FALSE
                          }
    bForceApplyToCloth = TRUE
    bForceApplyToFluid = TRUE
    bForceApplyToRigidBodies = TRUE
    Components = (DrawCylinder0, None)
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}