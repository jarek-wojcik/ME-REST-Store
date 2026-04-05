Class FogVolumeDensityInfo extends Info
    native
    abstract;

struct CheckpointRecord 
{
    var bool bEnabled;
    
    structdefaultproperties
    {
        bEnabled = FALSE
    }
};

var(FogVolumeDensityInfo) editinline export FogVolumeDensityComponent DensityComponent;
var(FogVolumeDensityInfo) editinline export StaticMeshComponent AutomaticMeshComponent;
var repnotify bool bEnabled;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        DensityComponent.SetEnabled(TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        DensityComponent.SetEnabled(FALSE);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        DensityComponent.SetEnabled(!DensityComponent.bEnabled);
    }
    bEnabled = DensityComponent.bEnabled;
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'bEnabled', bEnabled == default.bEnabled);
}
public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (DensityComponent != None)
    {
        bEnabled = DensityComponent.bEnabled;
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bEnabled')
    {
        DensityComponent.SetEnabled(bEnabled);
    }
    else
    {
        Super(Actor).ReplicatedEvent(VarName);
    }
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bEnabled = Record.bEnabled;
    DensityComponent.SetEnabled(bEnabled);
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'bEnabled', bEnabled == default.bEnabled);
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnabled = bEnabled;
}
public function bool ShouldSaveForCheckpoint()
{
    return RemoteRole != ENetRole.ROLE_None;
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        bEnabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=AutomaticMeshComponent0
        StaticMesh = StaticMesh'EngineMeshes.Cube'
        WireframeColor = {B = 200, G = 100, R = 100, A = 255}
        ReplacementPrimitive = None
        bIgnoreOwnerHidden = TRUE
        bUseAsOccluder = FALSE
        bSelectable = FALSE
        bAcceptsStaticDecals = FALSE
        bAcceptsDynamicDecals = FALSE
        bAcceptsFoliage = FALSE
        CastShadow = FALSE
        bCastDynamicShadow = FALSE
        bAcceptsLights = FALSE
        bAcceptsDynamicLights = FALSE
        BlockRigidBody = FALSE
    End Object
    AutomaticMeshComponent = AutomaticMeshComponent0
    Components = (None, AutomaticMeshComponent0)
    bNoDelete = TRUE
}