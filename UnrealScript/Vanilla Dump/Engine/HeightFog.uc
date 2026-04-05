Class HeightFog extends Info
    placeable;

var(HeightFog) const editinline editconst export HeightFogComponent Component;
var repnotify bool bEnabled;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        Component.SetEnabled(TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        Component.SetEnabled(FALSE);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        Component.SetEnabled(!Component.bEnabled);
    }
    bEnabled = Component.bEnabled;
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'bEnabled', bEnabled == default.bEnabled);
}
public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    bEnabled = Component.bEnabled;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bEnabled')
    {
        Component.SetEnabled(bEnabled);
    }
    else
    {
        Super(Actor).ReplicatedEvent(VarName);
    }
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        bEnabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=HeightFogComponent Name=HeightFogComponent0
    End Object
    Component = HeightFogComponent0
    Components = (None, HeightFogComponent0)
    bNoDelete = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}