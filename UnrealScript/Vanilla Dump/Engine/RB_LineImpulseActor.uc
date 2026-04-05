Class RB_LineImpulseActor extends RigidBodyBase
    native
    placeable;

var(RB_LineImpulseActor) float ImpulseStrength;
var(RB_LineImpulseActor) float ImpulseRange;
var editinline export ArrowComponent Arrow;
var(RB_LineImpulseActor) bool bVelChange;
var(RB_LineImpulseActor) bool bStopAtFirstHit;
var(RB_LineImpulseActor) bool bCauseFracture;
var repnotify byte ImpulseCount;

public final native function FireLineImpulse();

public simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        FireLineImpulse();
        ImpulseCount++;
        bForceNetUpdate = TRUE;
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ImpulseCount')
    {
        FireLineImpulse();
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
    ImpulseStrength = 900.0
    ImpulseRange = 200.0
    Components = (None, None)
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    bEdShouldSnap = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}