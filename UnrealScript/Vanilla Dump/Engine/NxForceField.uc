Class NxForceField extends Actor
    native
    abstract;

var const transient native array<Pointer> ConvexMeshes;
var const transient native array<Pointer> ExclusionShapes;
var const transient native array<Pointer> ExclusionShapePoses;
var const transient native Pointer ForceField;
var const transient native Pointer U2NRotation;
var(NxForceField) int ExcludeChannel;
var(NxForceField) const RBCollisionChannelContainer CollideWithChannels;
var const native int SceneIndex;
var(NxForceField) bool bForceActive;
var(NxForceField) const ERBCollisionChannel RBChannel;

public native function DoInitRBPhys();

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
    SetForcedInitialReplicatedProperty(BoolProperty'RB_RadialForceActor.bForceActive', bForceActive == default.bForceActive);
}

replication
{
    if (bNetDirty)
        bForceActive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
                           SoftBody = TRUE, 
                           FracturedMeshPart = FALSE, 
                           BlockingVolume = FALSE, 
                           DeadPawn = FALSE
                          }
    bForceActive = TRUE
    RBChannel = ERBCollisionChannel.RBCC_Nothing
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}