Class RB_RadialImpulseActor extends RigidBodyBase
    native
    placeable;

var editinline export DrawSphereComponent RenderComponent;
var(RB_RadialImpulseActor) const editinline editconst export RB_RadialImpulseComponent ImpulseComponent;
var repnotify byte ImpulseCount;

public simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ImpulseComponent.FireImpulse(location);
        ImpulseCount++;
        bForceNetUpdate = TRUE;
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ImpulseCount')
    {
        ImpulseComponent.FireImpulse(location);
    }
}

replication
{
    if (bNetDirty)
        ImpulseCount;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawSphereComponent Name=DrawSphere0
        ReplacementPrimitive = None
    End Object
    Begin Object Class=RB_RadialImpulseComponent Name=ImpulseComponent0
        PreviewSphere = DrawSphere0
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawSphere0
    ImpulseComponent = ImpulseComponent0
    Components = (DrawSphere0, ImpulseComponent0, None)
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    bEdShouldSnap = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}