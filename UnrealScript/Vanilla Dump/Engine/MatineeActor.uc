Class MatineeActor extends Actor
    native
    nativereplication;

var const SeqAct_Interp InterpAction;
var float PlayRate;
var float Position;
var float ClientSidePositionErrorTolerance;
var bool bIsPlaying;
var bool bReversePlayback;
var bool bPaused;

public event function Update()
{
    bIsPlaying = InterpAction.bIsPlaying;
    bReversePlayback = InterpAction.bReversePlayback;
    bPaused = InterpAction.bPaused;
    PlayRate = InterpAction.PlayRate;
    Position = InterpAction.Position;
    bForceNetUpdate = TRUE;
    if (bIsPlaying)
    {
        SetTimer(1.0, TRUE, 'CheckPriorityRefresh', );
    }
    else
    {
        ClearTimer('CheckPriorityRefresh');
    }
}
public function CheckPriorityRefresh()
{
    local Controller C;
    local int i;
    
    if (InterpAction != None)
    {
        for (i = 0; i < InterpAction.GroupInst.Length; i++)
        {
            if (InterpGroupInstDirector(InterpAction.GroupInst[i]) != None)
            {
                bNetDirty = TRUE;
                bForceNetUpdate = TRUE;
                return;
            }
        }
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            if (C.bIsPlayer && C.Pawn != None && (InterpAction.LatentActors.Find(C.Pawn) != -1 || C.Pawn.Base != None && InterpAction.LatentActors.Find(C.Pawn.Base) != -1))
            {
                bNetDirty = TRUE;
                bForceNetUpdate = TRUE;
                return;
            }
        }
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        InterpAction;
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        PlayRate, Position, bIsPlaying, bReversePlayback, bPaused;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayRate = 1.0
    Position = -1.0
    ClientSidePositionErrorTolerance = 0.100000001
    Components = (None)
    NetUpdateFrequency = 1.0
    NetPriority = 2.70000005
    bAlwaysRelevant = TRUE
    bReplicateMovement = FALSE
    bSkipActorPropertyReplication = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}