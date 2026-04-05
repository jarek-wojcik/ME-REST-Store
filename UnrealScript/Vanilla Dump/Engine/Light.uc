Class Light extends Actor
    native;

var(Light) const editinline editconst export LightComponent LightComponent;
var repnotify bool bEnabled;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (!bStatic)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            LightComponent.SetEnabled(TRUE);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            LightComponent.SetEnabled(FALSE);
        }
        else if (Action.InputLinks[2].bHasImpulse)
        {
            LightComponent.SetEnabled(!LightComponent.bEnabled);
        }
        bEnabled = LightComponent.bEnabled;
        ForceNetRelevant();
        SetForcedInitialReplicatedProperty(BoolProperty'bEnabled', bEnabled == default.bEnabled);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bEnabled')
    {
        LightComponent.SetEnabled(bEnabled);
    }
    else
    {
        Super.ReplicatedEvent(VarName);
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
    Components = (None)
    bStatic = TRUE
    bHidden = TRUE
    bNoDelete = TRUE
    bRouteBeginPlayEvenIfStatic = FALSE
    bMovable = FALSE
}