Class FluidInfluenceActor extends Actor
    native
    placeable;

var editinline export ArrowComponent FlowDirection;
var editinline export SpriteComponent Sprite;
var(FluidInfluenceActor) const editinline editconst export FluidInfluenceComponent InfluenceComponent;
var repnotify bool bActive;
var repnotify bool bToggled;

public simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        InfluenceComponent.bActive = TRUE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        InfluenceComponent.bActive = FALSE;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        InfluenceComponent.bActive = !InfluenceComponent.bActive;
        InfluenceComponent.bIsToggleTriggered = TRUE;
    }
    bActive = InfluenceComponent.bActive;
    bToggled = InfluenceComponent.bIsToggleTriggered;
    bForceNetUpdate = TRUE;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bActive')
    {
        InfluenceComponent.bActive = bActive;
    }
    else if (VarName == 'bToggled')
    {
        InfluenceComponent.bIsToggleTriggered = bToggled;
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}

replication
{
    if (bNetDirty)
        bActive, bToggled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=FluidInfluenceComponent Name=NewInfluenceComponent
        ReplacementPrimitive = None
    End Object
    InfluenceComponent = NewInfluenceComponent
    Components = (None, None, NewInfluenceComponent)
    NetUpdateFrequency = 0.100000001
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}