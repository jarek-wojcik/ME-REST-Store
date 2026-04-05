Class SFXSeqAct_BeginIllusiveManConflict extends SeqAct_Latent;

var(SFXSeqAct_BeginIllusiveManConflict) export array<float> Difficulty;
var(SFXSeqAct_BeginIllusiveManConflict) ScreenShakeStruct Shake;
var(SFXSeqAct_BeginIllusiveManConflict) Vector AndersonOffset;
var(SFXSeqAct_BeginIllusiveManConflict) Vector IllusiveManOffset;
var(SFXSeqAct_BeginIllusiveManConflict) Name AndersonBoneName;
var(SFXSeqAct_BeginIllusiveManConflict) Name IllusiveManBoneName;
var Actor Anderson;
var Actor IllusiveMan;
var(SFXSeqAct_BeginIllusiveManConflict) float PushSpeed;
var(SFXSeqAct_BeginIllusiveManConflict) float PushInputLockoutTime;
var(SFXSeqAct_BeginIllusiveManConflict) float PushMiniGameStartingPercent;
var(SFXSeqAct_BeginIllusiveManConflict) float PushMiniGameVictoryPercent;
var(SFXSeqAct_BeginIllusiveManConflict) float MinStrength;
var(SFXSeqAct_BeginIllusiveManConflict) float MaxStrength;
var(SFXSeqAct_BeginIllusiveManConflict) float Threshold;
var(SFXSeqAct_BeginIllusiveManConflict) float BaseDamageAmount;
var(SFXSeqAct_BeginIllusiveManConflict) float CameraShakeMinDot;
var(SFXSeqAct_BeginIllusiveManConflict) int StartingDifficulty;
var(SFXSeqAct_BeginIllusiveManConflict) bool bLastSideWasAnderson;
var(SFXSeqAct_BeginIllusiveManConflict) bool bRunning;

public event function bool Update(float DeltaTime)
{
    local BioPlayerController PC;
    local Vector ToIM;
    local Vector ToAndy;
    local bool bNewSideIsAnderson;
    
    if (!bRunning)
    {
        return FALSE;
    }
    PC = BioPlayerController(Targets[0]);
    if (InputLinks[1].bHasImpulse)
    {
        bRunning = FALSE;
        AbortFor(PC);
        OutputLinks[0].bHasImpulse = TRUE;
        PC.GameModeManager2.DisableMode(18);
    }
    else if (InputLinks[2].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(PC.GameModeManager2.GameModes[18]).IncreaseDifficulty();
    }
    else if (InputLinks[3].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(PC.GameModeManager2.GameModes[18]).DecreaseDifficulty();
    }
    else if (InputLinks[4].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(PC.GameModeManager2.GameModes[18]).StartPush();
    }
    ToAndy = Normal(AndersonTargetLocation() - PC.PlayerCamera.CameraCache.POV.location);
    ToIM = Normal(IllusiveManTargetLocation() - PC.PlayerCamera.CameraCache.POV.location);
    if (ToAndy Dot Vector(PC.Rotation) > ToIM Dot Vector(PC.Rotation))
    {
        bNewSideIsAnderson = TRUE;
    }
    if (bNewSideIsAnderson && !bLastSideWasAnderson)
    {
        OutputLinks[4].bHasImpulse = TRUE;
    }
    else if (!bNewSideIsAnderson && bLastSideWasAnderson)
    {
        OutputLinks[3].bHasImpulse = TRUE;
    }
    bLastSideWasAnderson = bNewSideIsAnderson;
    return TRUE;
}
public function Vector AndersonTargetLocation()
{
    return Pawn(Anderson).Mesh.GetBoneLocation(AndersonBoneName) + AndersonOffset;
}
public function Vector IllusiveManTargetLocation()
{
    return Pawn(IllusiveMan).Mesh.GetBoneLocation(IllusiveManBoneName) + IllusiveManOffset;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Difficulty = (0.560000002, 0.810000002, 0.930000007, 1.0)
    Shake = {
             RotAmplitude = {X = 65.0, Y = 65.0, Z = 65.0}, 
             RotFrequency = {X = 100.0, Y = 100.0, Z = 100.0}, 
             RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
             LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
             LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             ShakeName = 'IllusiveManMindControl', 
             TimeToGo = 0.0, 
             TimeDuration = 0.100000001, 
             RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             FOVAmplitude = 2.0, 
             FOVFrequency = 5.0, 
             FOVSinOffset = 0.0, 
             TargetingDampening = 0.0, 
             bOverrideTargetingDampening = FALSE, 
             FOVParam = EShakeParam.ESP_OffsetRandom
            }
    AndersonBoneName = 'Chest'
    IllusiveManBoneName = 'Chest'
    PushSpeed = 0.100000001
    PushMiniGameStartingPercent = 0.449999988
    PushMiniGameVictoryPercent = 0.5
    MinStrength = -0.5
    MaxStrength = 0.5
    Threshold = 0.100000001
    BaseDamageAmount = 10.0
    CameraShakeMinDot = 0.949999988
    StartingDifficulty = 3
    InputLinks = ({
                   LinkDesc = "Activate", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Deactivate", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "IncreaseDifficulty", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "DecreaseDifficulty", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "StartPush", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Aborted", 
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
                    LinkDesc = "CloserToIllusiveMan", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "CloserToAnderson", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Anderson", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Anderson', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "IllusiveMan", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'IllusiveMan', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bAutoActivateOutputLinks = FALSE
}