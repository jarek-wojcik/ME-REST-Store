Class SeqAct_Interp extends SeqAct_Latent
    native;

struct native CameraCutInfo 
{
    var Vector location;
    var float TimeStamp;
    var SFXSceneShopNode SFXOwningScene;
};
struct native export SavedTransform 
{
    var Vector location;
    var Rotator Rotation;
};

var(SeqAct_Interp) array<CoverLink> LinkedCover;
var transient array<Actor> TexturePrimedActors;
var array<InterpGroupInst> GroupInst;
var transient array<CameraCutInfo> CameraCuts;
var const Class<MatineeActor> ReplicatedActorClass;
var(SeqAct_Interp) float PlayRate;
var float Position;
var(SeqAct_Interp) float ForceStartPosition;
var export InterpData InterpData;
var const MatineeActor ReplicatedActor;
var(SeqAct_Interp) int PreferredSplitScreenNum;
var float TerminationTime;
var transient SFXSceneShopDataInstInterface m_pSFXSceneDataInst;
var transient bool bSFXBuildingPreloadCameraCuts;
var bool bIsPlaying;
var bool bPaused;
var transient bool bIsBeingEdited;
var(SeqAct_Interp) bool bResetPositionOnFinish;
var(SeqAct_Interp) bool bFreeAnimsetsOnFinish;
var(SeqAct_Interp) bool bLooping;
var(SeqAct_Interp) bool bRewindOnPlay;
var(SeqAct_Interp) bool bNoResetOnRewind;
var(SeqAct_Interp) bool bRewindIfAlreadyPlaying;
var bool bReversePlayback;
var(SeqAct_Interp) bool bInterpForPathBuilding;
var(SeqAct_Interp) bool bForceStartPos;
var(SeqAct_Interp) bool bClientSideOnly;
var(SeqAct_Interp) bool bSkipUpdateIfNotVisible;
var(SeqAct_Interp) bool bIsSkippable;
var(SeqAct_Interp) bool bBlockForPriming;
var transient bool bShouldShowGore;
var transient bool m_bBioSkipToEnd;
var transient bool m_bBioRequestSkipToEnd;
var transient bool m_bBioHACK_StopPinFired;
var transient bool m_bSFXStartedUnderCinematicMode;
var transient bool m_bSFXIsCurrentlyActivating;

public final native function AddPlayerToDirectorTracks(PlayerController PC);

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 5;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (InputLinks[5].LinkDesc == "Prime Textures")
    {
        InputLinks[5].LinkDesc = "Prime";
        InputLinks[6].LinkDesc = "Unprime";
    }
}
public function Reset()
{
    SetPosition(0.0, FALSE);
    if (bActive)
    {
        InputLinks[2].bHasImpulse = TRUE;
    }
}
public final native function SetPosition(float NewPosition, optional bool bJump = FALSE);

public final native function Stop();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplicatedActorClass = Class'MatineeActor'
    PlayRate = 1.0
    InputLinks = ({
                   LinkDesc = "Play", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Reverse", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Pause", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Change Dir", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Prime", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unprime", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Completed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Reversed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Cancelled", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stopped", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Data", 
                      ExpectedType = Class'InterpData', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Anchor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}