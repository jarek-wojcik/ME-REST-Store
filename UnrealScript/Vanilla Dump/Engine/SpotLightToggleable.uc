Class SpotLightToggleable extends SpotLight
    native
    placeable;

struct CheckpointRecord 
{
    var bool bEnabled;
    
    structdefaultproperties
    {
        bEnabled = FALSE
    }
};

public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bEnabled = Record.bEnabled;
    LightComponent.SetEnabled(bEnabled);
    ForceNetRelevant();
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnabled = bEnabled;
}
public function bool ShouldSaveForCheckpoint()
{
    return RemoteRole != ENetRole.ROLE_None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SpotLightComponent Name=SpotLightComponent0
        LightmassSettings = {IndirectLightingScale = 0.0}
        LightAffectsClassification = ELightAffectsClassification.LAC_STATIC_AFFECTING
    End Template
    LightComponent = SpotLightComponent0
    Components = (None, None, None, None, None, SpotLightComponent0, None)
    bStatic = FALSE
    bHardAttach = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}