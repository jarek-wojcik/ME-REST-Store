Class LevelStreamingVolume extends Volume
    native
    placeable;

enum EStreamingVolumeUsage
{
    SVB_Loading,
    SVB_LoadingAndVisibility,
    SVB_VisibilityBlockingOnLoad,
    SVB_BlockingOnLoad,
    SVB_LoadingNotVisible,
};
struct CheckpointRecord 
{
    var bool bDisabled;
};

var(LevelStreamingVolume) const editconst noimport array<LevelStreaming> StreamingLevels;
var(LevelStreamingVolume) float TestVolumeDistance;
var(LevelStreamingVolume) bool bEditorPreVisOnly;
var(LevelStreamingVolume) bool bDisabled;
var(LevelStreamingVolume) bool bTestDistanceToVolume;
var(LevelStreamingVolume) EStreamingVolumeUsage StreamingUsage;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = FALSE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bDisabled = TRUE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bDisabled = !bDisabled;
    }
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bDisabled = Record.bDisabled;
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bDisabled = bDisabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    StreamingUsage = EStreamingVolumeUsage.SVB_LoadingAndVisibility
    BrushColor = {B = 0, G = 165, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
    bForceAllowKismetModification = TRUE
}