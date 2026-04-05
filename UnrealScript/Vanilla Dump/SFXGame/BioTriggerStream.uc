Class BioTriggerStream extends TriggerVolume
    native
    placeable;

struct native BioStreamingState 
{
    var(BioStreamingState) Name StateName;
    var(BioStreamingState) Name InChunkName;
    var(BioStreamingState) array<Name> VisibleChunkNames;
    var(BioStreamingState) array<Name> VisibleSoonChunkNames;
    var(BioStreamingState) array<Name> LoadChunkNames;
};

var(Streaming) array<BioStreamingState> StreamingStates;
var const Name TierName;
var transient int m_StoredStateIndex;
var(Streaming) int m_nPriorityLevel;
var const transient BioTierInfo TierInfo;
var(BioTriggerStream) GFxMovieInfo m_oAreaMapOverride;
var transient int bInPlotStreaming;
var transient bool bErrorsLogged;
var(Streaming) bool m_bIgnoreForStreamingCoverage;
var(Streaming) transient EBioAutoSet Tier;

public native function BackgroundStreamingDone(array<Sequence> Sequences, Pawn PlayerPawn);

public native function DoTouch(Actor Other);

public native function DoUntouch(Actor Other);

public native function ForegroundStreamingDone(array<Sequence> Sequences, Pawn PlayerPawn);

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    DoTouch(Other);
    Super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
}
public event function UnTouch(Actor Other)
{
    DoUntouch(Other);
    Super(Actor).UnTouch(Other);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    m_StoredStateIndex = -1
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bProjTarget = FALSE
    bForceAllowKismetModification = TRUE
    m_bAlwaysCollide = TRUE
}