Class RB_RadialForceActor extends RigidBodyBase
    native
    placeable;

enum ERadialForceType
{
    RFT_Force,
    RFT_Impulse,
};

var editinline export DrawSphereComponent RenderComponent;
var(RB_RadialForceActor) interp float ForceStrength;
var(RB_RadialForceActor) interp float ForceRadius;
var(RB_RadialForceActor) interp float SwirlStrength;
var(RB_RadialForceActor) interp float SpinTorque;
var(RB_RadialForceActor) const RBCollisionChannelContainer CollideWithChannels;
var(RB_RadialForceActor) bool bForceActive;
var(RB_RadialForceActor) bool bForceApplyToCloth;
var(RB_RadialForceActor) bool bForceApplyToFluid;
var(RB_RadialForceActor) bool bForceApplyToRigidBodies;
var(RB_RadialForceActor) bool bForceApplyToProjectiles;
var(RB_RadialForceActor) editinline export ERadialImpulseFalloff ForceFalloff;
var(RB_RadialForceActor) ERadialForceType RadialForceMode;

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
    Begin Object Class=DrawSphereComponent Name=DrawSphere0
        SphereColor = {B = 255, G = 70, R = 64, A = 255}
        SphereRadius = 200.0
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawSphere0
    ForceStrength = 10.0
    ForceRadius = 200.0
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
                           Untitled4 = TRUE, 
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
    Components = (DrawSphere0, None)
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}