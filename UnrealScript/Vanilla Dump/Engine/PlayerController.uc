Class PlayerController extends Controller
    native
    nativereplication
    config(Game);

enum EProgressMessageType
{
    PMT_Clear,
    PMT_Information,
    PMT_AdminMessage,
    PMT_DownloadProgress,
    PMT_ConnectionFailure,
    PMT_SocketFailure,
};
struct native DebugTextInfo 
{
    var string DebugText;
    var Vector SrcActorOffset;
    var Vector SrcActorDesiredOffset;
    var Actor SrcActor;
    var transient float TimeRemaining;
    var float Duration;
    var Color TextColor;
    var bool bAbsoluteLocation;
};
struct native InputMatchRequest 
{
    var array<InputEntry> Inputs;
    var delegate<InputMatchDelegate> MatchDelegate;
    var Name MatchFuncName;
    var Name FailedFuncName;
    var Name RequestName;
    var Actor MatchActor;
    var transient int MatchIdx;
    var transient float LastMatchTime;
};
struct native InputEntry 
{
    var float Value;
    var float TimeDelta;
    var EInputTypes Type;
    var EInputMatchAction Action;
};
enum EInputMatchAction
{
    IMA_GreaterThan,
    IMA_LessThan,
};
enum EInputTypes
{
    IT_XAxis,
    IT_YAxis,
};
struct native ClientAdjustment 
{
    var Vector NewLoc;
    var Vector NewVel;
    var Vector NewFloor;
    var float TimeStamp;
    var Actor NewBase;
    var EPhysics newPhysics;
    var byte bAckGoodMove;
    var byte bWarning;
};
const MAXCLIENTUPDATEINTERVAL = 0.25;
const CLIENTADJUSTUPDATECOST = 180.0;
const MAXVEHICLEPOSITIONERRORSQUARED = 900.0;
const MAXNEARZEROVELOCITYSQUARED = 9.0;
const MAXPOSITIONERRORSQUARED = 3.0;

var string LastBroadcastString[4];
var const localized string QuickSaveString;
var const localized string NoPauseMessage;
var const localized string ViewingFrom;
var const localized string OwnCamera;
var config string ForceFeedbackManagerClassName;
var transient array<Interaction> Interactions;
var array<UniqueNetId> VoiceMuteList;
var array<UniqueNetId> GameplayVoiceMuteList;
var array<UniqueNetId> VoicePacketFilter;
var array<InputMatchRequest> InputRequests;
var array<Name> PendingMapChangeLevelNames;
var biononship array<DebugTextInfo> DebugTextList;
var editinline export array<AudioComponent> HearSoundActiveComponents;
var editinline export array<AudioComponent> HearSoundPoolComponents;
var array<Actor> HiddenActors;
var delegate<CanUnpause> __CanUnpause__Delegate;
var delegate<InputMatchDelegate> __InputMatchDelegate__Delegate;
var const Class<Camera> CameraClass;
var const Class<PlayerOwnerDataStore> PlayerOwnerDataStoreClass;
var Class<SavedMove> SavedMoveClass;
var Class<CheatManager> CheatClass;
var Class<PlayerInput> InputClass;
var ClientAdjustment PendingAdjustment;
var Rotator TargetViewRotation;
var Rotator BlendedTargetViewRotation;
var Vector LastAckedAccel;
var Vector OldFloor;
var const Vector FailedPathStart;
var OnlineVoiceInterface VoiceInterface;
var Name DelayedJoinSessionName;
var const Player Player;
var(Camera) Camera PlayerCamera;
var PlayerOwnerDataStore CurrentPlayerData;
var float MaxResponseTime;
var float WaitDelay;
var Pawn AcknowledgedPawn;
var const Actor ViewTarget;
var PlayerReplicationInfo RealViewTarget;
var transient InterpTrackInstDirector ControllingDirTrackInst;
var float FOVAngle;
var float DesiredFOV;
var float DefaultFOV;
var const float LODDistanceFactor;
var float TargetEyeHeight;
var HUD myHUD;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var float MaxTimeMargin;
var float LastActiveTime;
var int ClientCap;
var float LastPingUpdate;
var float LastSpeedHackLog;
var int GroundPitch;
var transient CheatManager CheatManager;
var(PlayerController) transient PlayerInput PlayerInput;
var editinline export CylinderComponent CylinderComponent;
var transient ForceFeedbackManager ForceFeedbackManager;
var OnlineSubsystem OnlineSub;
var UIDataStore_OnlinePlayerData OnlinePlayerData;
var config float InteractDistance;
var float LastBroadcastTime;
var CoverReplicator MyCoverReplicator;
var float SpectatorCameraSpeed;
var const duplicatetransient NetConnection PendingSwapConnection;
var float MinRespawnDelay;
var globalconfig int MaxConcurrentHearSounds;
var float LastSpectatorStateSynchTime;
var bool bFrozen;
var bool bPressedJump;
var bool bDoubleJump;
var bool bUpdatePosition;
var bool bUpdating;
var globalconfig bool bNeverSwitchOnPickup;
var bool bCheatFlying;
var bool bCameraPositionLocked;
var globalconfig bool bNoTextToSpeechVoiceMessages;
var globalconfig bool bTextToSpeechTeamMessagesOnly;
var bool bShortConnectTimeOut;
var const bool bPendingDestroy;
var bool bWasSpeedHack;
var const bool bWasSaturated;
var globalconfig bool bAimingHelp;
var bool bClientSimulatingViewTarget;
var bool bHasVoiceHandshakeCompleted;
var bool bCinematicMode;
var bool bCinemaDisableInputMove;
var bool bCinemaDisableInputLook;
var bool bIgnoreNetworkMessages;
var bool bReplicateAllPawns;
var bool bIsUsingStreamingVolumes;
var bool bIsExternalUIOpen;
var bool bIsControllerConnected;
var bool bCheckSoundOcclusion;
var globalconfig bool bLogHearSoundOverflow;
var globalconfig bool bCheckRelevancyThroughPortals;
var(Debug) bool bDebugClientAdjustPosition;
var EDoubleClickDir DoubleClickDir;
var byte bIgnoreMoveInput;
var byte bIgnoreLookInput;
var input byte bRun;
var input byte bDuck;
var const duplicatetransient byte NetPlayerIndex;

public final event reliable client function AddDebugText(string DebugText, optional Actor SrcActor, optional float Duration = -1.0, optional Vector Offset, optional Vector DesiredOffset, optional Color TextColor, optional bool bSkipOverwriteCheck, optional bool bAbsoluteLocation);

public event exec function BugIt(optional string ScreenShotDescription)
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString;
    local string LocString;
    
    ConsoleCommand("bugscreenshot " $ ScreenShotDescription);
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != None)
    {
        ViewLocation = Pawn.location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
    LogOutBugItGoToLogFile(ScreenShotDescription, GoString, LocString);
}
public event exec function BugItAI(optional string ScreenShotDescription)
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString;
    local string LocString;
    
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != None)
    {
        ViewLocation = Pawn.location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
    ConsoleCommand("debugai");
    SetTimer(0.100000001, FALSE, 'DisableDebugAI', );
    LogOutBugItAIGoToLogFile(ScreenShotDescription, GoString, LocString);
}
public event exec function BugItStringCreator(const out Vector ViewLocation, const out Rotator ViewRotation, out string GoString, out string LocString)
{
    GoString = "BugItGo " $ ViewLocation.X $ " " $ ViewLocation.Y $ " " $ ViewLocation.Z $ " " $ ViewRotation.Pitch $ " " $ ViewRotation.Yaw $ " " $ ViewRotation.Roll;
    LocString = "?BugLoc=" $ ViewLocation $ "?BugRot=" $ ViewRotation;
}
public exec function Camera(Name NewMode)
{
    ServerCamera(NewMode);
}
public event function CameraLookAtFinished(SeqAct_CameraLookAt Action);

private final simulated function bool CanCommunicate()
{
    return TRUE;
}
public delegate function bool CanUnpause()
{
    return WorldInfo.Pauser == PlayerReplicationInfo;
}
public exec function CauseEvent(optional Name EventName)
{
    ServerCauseEvent(EventName);
}
public final native function bool CheckSpeedHack(float DeltaTime);

public native function CleanUpAudioComponents();

public event function ClearOnlineDelegates()
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (Role < ENetRole.ROLE_Authority || LP != None)
    {
        if (OnlineSub != None)
        {
            if (OnlineSub.SystemInterface != None)
            {
                OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChanged);
                OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChanged);
            }
            if (OnlineSub.GameInterface != None && LP != None)
            {
                OnlineSub.GameInterface.ClearGameInviteAcceptedDelegate(byte(LP.ControllerId), OnGameInviteAccepted);
            }
        }
    }
}
public event reliable client function ClientCancelPendingMapChange()
{
    WorldInfo.CancelPendingMapChange();
}
public event reliable client function ClientCommitMapChange()
{
    if (IsTimerActive('DelayedPrepareMapChange'))
    {
        SetTimer(0.00999999978, FALSE, 'ClientCommitMapChange', );
    }
    else
    {
        if (Pawn != None)
        {
            SetViewTarget(Pawn);
        }
        else
        {
            SetViewTarget(Self);
        }
        WorldInfo.CommitMapChange();
    }
}
private final event reliable client native function ClientConvolve(string C, int H);

public final event reliable client native function ClientFlushLevelStreaming();

public event reliable client function ClientForceGarbageCollection()
{
    WorldInfo.ForceGarbageCollection();
}
public event unreliable client function ClientHearSound(SoundCue ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded)
{
    local AudioComponent AC;
    
    if (SourceActor == None)
    {
        AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed, TRUE, SourceLocation);
        if (AC == None)
        {
            return;
        }
        AC.bUseOwnerLocation = FALSE;
        AC.location = SourceLocation;
    }
    else if (SourceActor == GetViewTarget() || SourceActor == Self)
    {
        AC = GetPooledAudioComponent(ASound, None, bStopWhenOwnerDestroyed);
        if (AC == None)
        {
            return;
        }
        AC.bAllowSpatialization = FALSE;
    }
    else
    {
        AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed);
        if (AC == None)
        {
            return;
        }
        if (!IsZero(SourceLocation) && SourceLocation != SourceActor.location)
        {
            AC.bUseOwnerLocation = FALSE;
            AC.location = SourceLocation;
        }
    }
    if (bIsOccluded)
    {
        AC.VolumeMultiplier *= 0.5;
    }
    AC.Play();
}
public event reliable client function ClientMessage(coerce string S, optional Name Type, optional float MsgLifeTime);

public event reliable client function ClientMutePlayer(UniqueNetId PlayerNetId)
{
    local LocalPlayer LocPlayer;
    
    if (VoiceInterface != None)
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != None)
        {
            VoiceInterface.MuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
        }
    }
}
public event unreliable client function ClientPlayCameraAnim(CameraAnim AnimToPlay, optional float Scale = 1.0, optional float Rate = 1.0, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional ECameraAnimPlaySpace Space = 0, optional Rotator CustomPlaySpace)
{
    local CameraAnimInst AnimInst;
    
    if (PlayerCamera != None)
    {
        AnimInst = PlayerCamera.PlayCameraAnim(AnimToPlay, Rate, Scale, BlendInTime, BlendOutTime, bLoop, bRandomStartTime);
        if (AnimInst != None && Space != ECameraAnimPlaySpace.CAPS_CameraLocal)
        {
            AnimInst.SetPlaySpace(Space, CustomPlaySpace);
        }
    }
}
public event function ClientPlayForceFeedbackWaveform(ForceFeedbackWaveform FFWaveform)
{
    if (PlayerInput != None && !PlayerInput.bUsingGamepad && !WorldInfo.IsConsoleBuild(1))
    {
        return;
    }
    if (ForceFeedbackManager != None && PlayerReplicationInfo != None && IsForceFeedbackAllowed())
    {
        ForceFeedbackManager.PlayForceFeedbackWaveform(FFWaveform);
    }
}
public event unreliable client function ClientPlaySound(SoundCue ASound)
{
    ClientHearSound(ASound, Self, location, FALSE, FALSE);
}
public event reliable client function ClientPrepareMapChange(Name LevelName, bool bFirst, bool bLast)
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        if (PC != Self)
        {
            return;
        }
        else
        {
            break;
        }
    }
    if (bFirst)
    {
        PendingMapChangeLevelNames.Length = 0;
        ClearTimer('DelayedPrepareMapChange');
    }
    PendingMapChangeLevelNames[PendingMapChangeLevelNames.Length] = LevelName;
    if (bLast)
    {
        DelayedPrepareMapChange();
    }
}
public event reliable client function ClientPrestreamTextures(Actor ForcedActor, float ForceDuration, bool bEnableStreaming, optional int CinematicTextureGroups = 0)
{
    if (ForcedActor != None && IsPrimaryPlayer())
    {
        ForcedActor.PrestreamTextures(ForceDuration, bEnableStreaming, CinematicTextureGroups);
    }
}
public event reliable client function ClientSetBlockOnAsyncLoading()
{
    WorldInfo.bRequestedBlockOnAsyncLoading = TRUE;
}
public event reliable client function ClientSetCameraFade(bool bEnableFading, optional Color FadeColor, optional Vector2D FadeAlpha, optional float FadeTime)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.bEnableFading = bEnableFading;
        if (PlayerCamera.bEnableFading)
        {
            PlayerCamera.FadeColor = FadeColor;
            PlayerCamera.FadeAlpha = FadeAlpha;
            PlayerCamera.FadeTime = FadeTime;
            PlayerCamera.FadeTimeRemaining = FadeTime;
        }
    }
}
public event reliable client function ClientSetForceMipLevelsToBeResident(MaterialInterface Material, float ForceDuration, optional int CinematicTextureGroups)
{
    if (Material != None && IsPrimaryPlayer())
    {
        Material.SetForceMipLevelsToBeResident(FALSE, FALSE, ForceDuration, CinematicTextureGroups);
    }
}
public event reliable client function ClientSetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    if (LocalPlayer(Player) != None)
    {
        LocalPlayer(Player).ViewportClient.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
    }
}
public event reliable client function ClientSetViewTarget(Actor A, optional ViewTargetTransitionParams TransitionParams)
{
    if (!bClientSimulatingViewTarget)
    {
        if (A == None)
        {
            ServerVerifyViewTarget();
        }
        SetViewTarget(A, TransitionParams);
    }
}
public event unreliable client function ClientSpawnCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.AddCameraLensEffect(LensEffectEmitterClass);
    }
}
public event reliable client function ClientStopCameraAnim(CameraAnim AnimToStop)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.StopAllCameraAnimsByType(AnimToStop);
    }
}
public final event reliable client function ClientStopForceFeedbackWaveform(optional ForceFeedbackWaveform FFWaveform)
{
    if (ForceFeedbackManager != None)
    {
        ForceFeedbackManager.StopForceFeedbackWaveform(FFWaveform);
    }
}
public event reliable client native function ClientTravel(string URL, ETravelType TravelType, optional bool bSeamless = FALSE, optional init Guid MapPackageGuid);

public event reliable client function ClientUnmutePlayer(UniqueNetId PlayerNetId)
{
    local LocalPlayer LocPlayer;
    
    if (VoiceInterface != None)
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != None)
        {
            VoiceInterface.UnmuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
        }
    }
}
public reliable client native function ClientUpdateLevelStreamingStatus(Name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad);

public event reliable client function ClientWasKicked();

public event function ConditionalPause(bool bDesiredPauseState)
{
    if (bDesiredPauseState != IsPaused())
    {
        SetPause(bDesiredPauseState);
    }
}
public native function string ConsoleCommand(string Command, optional bool bWriteToLog = TRUE);

public exec function ConsoleKey(Name Key);

public native function CopyToClipboard(string Text);

private final simulated native function SoundCue CreateTTSSoundCue(string StrToSpeak, PlayerReplicationInfo PRI);

public event function Destroyed()
{
    ClientPlayForceFeedbackWaveform(None);
    if (Role < ENetRole.ROLE_Authority || LocalPlayer(Player) != None)
    {
        ClearOnlineDelegates();
    }
    if (Pawn != None)
    {
        CleanupPawn();
    }
    if (myHUD != None)
    {
        myHUD.Destroy();
    }
    if (PlayerCamera != None)
    {
        PlayerCamera.Destroy();
        PlayerCamera = None;
    }
    ForceClearUnpauseDelegates();
    UnregisterPlayerDataStores();
    Super.Destroyed();
}
public event simulated function FellOutOfWorld(Class<DamageType> dmgType);

public final native(524) function int FindStairRotation(float DeltaTime);

public function ForceClearUnpauseDelegates()
{
    if (WorldInfo.Game != None)
    {
        WorldInfo.Game.ForceClearUnpauseDelegates(Self);
    }
}
public final native function ForceSingleNetUpdateFor(Actor Target);

public exec function FOV(float F)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.SetFOV(F);
        return;
    }
    if (F >= 80.0 || WorldInfo.NetMode == ENetMode.NM_Standalone || PlayerReplicationInfo.bOnlySpectator)
    {
        DefaultFOV = FClamp(F, 80.0, 100.0);
        DesiredFOV = DefaultFOV;
    }
}
public event function bool GetAchievementProgression(int AchievementId, out float CurrentValue, out float MaxValue);

public final native function string GetDefaultURL(string Option);

public event function float GetFOVAngle()
{
    return PlayerCamera != None ? PlayerCamera.GetFOVAngle() : FOVAngle;
}
public final simulated function OnlineSubsystem GetOnlineSubsystem()
{
    if (OnlineSub == None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    }
    return OnlineSub;
}
public static native function PlayerController GetPlayerControllerFromNetId(UniqueNetId PlayerNetId);

public final native function string GetPlayerNetworkAddress();

public event simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    local Actor TheViewTarget;
    
    if (PlayerCamera == None)
    {
        if (CameraClass != None)
        {
            PlayerCamera = Spawn(CameraClass, Self);
            if (PlayerCamera != None)
            {
                PlayerCamera.InitializeFor(Self);
            }
        }
    }
    if (PlayerCamera != None)
    {
        PlayerCamera.GetCameraViewPoint(out_Location, out_rotation);
    }
    else
    {
        TheViewTarget = GetViewTarget();
        if (TheViewTarget != None)
        {
            out_Location = TheViewTarget.location;
            out_rotation = TheViewTarget.Rotation;
        }
        else
        {
            Super.GetPlayerViewPoint(out_Location, out_rotation);
        }
    }
}
public native function AudioComponent GetPooledAudioComponent(SoundCue ASound, Actor SourceActor, bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation);

public event function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    HearSoundActiveComponents.Length = 0;
    HearSoundPoolComponents.Length = 0;
    if (myHUD != None)
    {
        ActorList[ActorList.Length] = myHUD;
        if (myHUD.Scoreboard != None)
        {
            ActorList[ActorList.Length] = myHUD.Scoreboard;
        }
    }
}
public final native function string GetServerNetworkAddress();

public native function Actor GetViewTarget();

public event reliable client function GivePawn(Pawn NewPawn)
{
    if (NewPawn == None)
    {
        return;
    }
    Pawn = NewPawn;
    NewPawn.Controller = Self;
    ClientRestart(Pawn);
}
public event function HandleWalking()
{
    if (Pawn != None)
    {
        Pawn.SetWalking(int(bRun) != 0);
    }
}
public final native function bool HasClientLoadedCurrentWorld();

public simulated function HearSoundFinished(AudioComponent AC)
{
    HearSoundActiveComponents.RemoveItem(AC);
    if (!AC.IsPendingKill())
    {
        AC.ResetToDefaults();
        HearSoundPoolComponents[HearSoundPoolComponents.Length] = AC;
    }
}
public event function InitInputSystem()
{
    local Class<ForceFeedbackManager> FFManagerClass;
    local int i;
    local Sequence GameSeq;
    local array<SequenceObject> AllInterpActions;
    
    if (PlayerInput == None)
    {
        assert(InputClass != None);
        PlayerInput = new (Self) InputClass;
    }
    if (Interactions.Find(PlayerInput) == -1)
    {
        Interactions[Interactions.Length] = PlayerInput;
    }
    if (ForceFeedbackManagerClassName != "")
    {
        FFManagerClass = Class<ForceFeedbackManager>(DynamicLoadObject(ForceFeedbackManagerClassName, Class'Class'));
        if (FFManagerClass != None)
        {
            ForceFeedbackManager = new (Self) FFManagerClass;
        }
    }
    RegisterOnlineDelegates();
    if (Role < ENetRole.ROLE_Authority)
    {
        GameSeq = WorldInfo.GetGameSequence();
        if (GameSeq != None)
        {
            GameSeq.FindSeqObjectsByClass(Class'SeqAct_Interp', TRUE, AllInterpActions);
            for (i = 0; i < AllInterpActions.Length; i++)
            {
                SeqAct_Interp(AllInterpActions[i]).AddPlayerToDirectorTracks(Self);
            }
        }
    }
    SetOnlyUseControllerTiltInput(FALSE);
    SetUseTiltForwardAndBack(TRUE);
    SetControllerTiltActive(FALSE);
}
public delegate function InputMatchDelegate();

public simulated native function bool IsControllerTiltActive();

public final native function bool IsFinalReleaseBuild();

public simulated native function bool IsKeyboardAvailable();

public native function bool IsLocalPlayerController();

public event function bool IsLookInputIgnored()
{
    return int(bIgnoreLookInput) > 0;
}
public simulated native function bool IsMouseAvailable();

public event function bool IsMoveInputIgnored()
{
    return int(bIgnoreMoveInput) > 0;
}
public final native function bool IsPlayerMuted(const out UniqueNetId Sender);

public simulated native function bool IsShowingSubtitles();

public function bool IsSpectating()
{
    return FALSE;
}
public event function KickWarning()
{
    ReceiveLocalizedMessage(Class'GameMessage', 15);
}
public event reliable client function Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization)
{
    local AudioComponent AC;
    
    if (SourceActor != None && IsClosestLocalPlayerToActor(SourceActor))
    {
        if (ASound.FaceFXAnimName != "" && SourceActor.PlayActorFaceFXAnim(ASound.FaceFXAnimSetRef, ASound.FaceFXGroupName, ASound.FaceFXAnimName, ASound))
        {
        }
        else
        {
            AC = SourceActor.CreateAudioComponent(ASound, FALSE, TRUE);
            if (AC != None)
            {
                AC.VolumeMultiplier = VolumeMultiplier;
                AC.PitchMultiplier = PitchMultiplier;
                AC.bAutoDestroy = TRUE;
                AC.SubtitlePriority = 10000.0;
                AC.bSuppressSubtitles = bSuppressSubtitles;
                AC.FadeIn(FadeInTime, 1.0);
                if (bSuppressSpatialization)
                {
                    AC.bAllowSpatialization = FALSE;
                }
            }
        }
    }
}
public event reliable client function Kismet_ClientStopSound(SoundCue ASound, Actor SourceActor, float FadeOutTime)
{
    local AudioComponent AC;
    local AudioComponent CheckAC;
    
    if (SourceActor == None)
    {
        SourceActor = WorldInfo;
    }
    foreach SourceActor.AllOwnedComponents(Class'AudioComponent', CheckAC)
    {
        if (CheckAC.SoundCue == ASound)
        {
            AC = CheckAC;
            break;
        }
    }
    if (AC != None)
    {
        AC.FadeOut(FadeOutTime, 0.0);
    }
}
public final event function LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
    ClientUpdateLevelStreamingStatus(LevelObject.PackageName, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
}
public event function Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
{
    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
    if (float(ViewRotation.Pitch) > ViewPitchMax && float(ViewRotation.Pitch) < float(65535) + ViewPitchMin)
    {
        if (ViewRotation.Pitch < 32768)
        {
            ViewRotation.Pitch = int(ViewPitchMax);
        }
        else
        {
            ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
        }
    }
    return ViewRotation;
}
private final native function LogOutBugItAIGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString);

private final native function LogOutBugItGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString);

public event function NotifyDirectorControl(bool bNowControlling)
{
    if (!bNowControlling && WorldInfo.NetMode == ENetMode.NM_Client && bClientSimulatingViewTarget)
    {
        ServerVerifyViewTarget();
    }
}
public event function bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
    return bUpdating;
}
public event function NotifyLoadedWorld(Name WorldPackageName, bool bFinalDest)
{
    local PlayerStart P;
    local Rotator SpawnRotation;
    
    SetViewTarget(Self);
    foreach WorldInfo.AllNavigationPoints(Class'PlayerStart', P)
    {
        SetLocation(P.location, );
        SpawnRotation.Yaw = P.Rotation.Yaw;
        SetRotation(SpawnRotation);
        break;
    }
}
public function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    local OnlineGameSettings GameInviteSettings;
    
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        GameInviteSettings = InviteResult.GameSettings;
        if (GameInviteSettings != None)
        {
            if (InviteHasEnoughSpace(GameInviteSettings))
            {
                if (CanAllPlayersPlayOnline())
                {
                    if (WorldInfo.NetMode != ENetMode.NM_Standalone)
                    {
                        if (OnlineSub.GameInterface.GetGameSettings('Game').bUsesArbitration)
                        {
                            ClientWriteOnlinePlayerScores(WorldInfo.GRI.GameClass != None ? WorldInfo.GRI.GameClass.default.ArbitratedLeaderboardId : 0);
                        }
                        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
                        OnlineSub.GameInterface.EndOnlineGame('Game');
                    }
                    else
                    {
                        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                        if (!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Game'))
                        {
                            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                        }
                    }
                }
                else
                {
                    NotifyNotAllPlayersCanJoinInvite();
                }
            }
            else
            {
                NotifyNotEnoughSpaceInInvite();
            }
        }
        else
        {
            NotifyInviteFailed();
        }
    }
}
public function OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
    local string StatGuid;
    
    OnlineSub.StatsInterface.ClearRegisterHostStatGuidCompleteDelegateDelegate(OnRegisterHostStatGuidComplete);
    if (bWasSuccessful)
    {
        StatGuid = OnlineSub.StatsInterface.GetClientStatGuid();
        ServerRegisterClientStatGuid(StatGuid);
    }
}
public native function string PasteFromClipboard();

public exec function Pause()
{
    ServerPause();
}
public event function PlayerTick(float DeltaTime)
{
    if (!bShortConnectTimeOut)
    {
        bShortConnectTimeOut = TRUE;
        ServerShortTimeout();
    }
    if (Pawn != AcknowledgedPawn)
    {
        if (Role < ENetRole.ROLE_Authority)
        {
            if (AcknowledgedPawn != None && AcknowledgedPawn.Controller == Self)
            {
                AcknowledgedPawn.Controller = None;
            }
        }
        AcknowledgePossession(Pawn);
    }
    PlayerInput.PlayerInput(DeltaTime);
    if (bUpdatePosition)
    {
        ClientUpdatePosition();
    }
    PlayerMove(DeltaTime);
    AdjustFOV(DeltaTime);
}
public event function PlayRumble(const AnimNotify_Rumble TheAnimNotify)
{
    if (TheAnimNotify.PredefinedWaveForm != None)
    {
        ClientPlayForceFeedbackWaveform(TheAnimNotify.PredefinedWaveForm.default.TheWaveForm);
    }
    else
    {
        ClientPlayForceFeedbackWaveform(TheAnimNotify.WaveForm);
    }
}
public event function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local Actor A;
    local int i;
    local SeqEvent_Touch TouchEvent;
    
    if (!PlayerReplicationInfo.bOnlySpectator)
    {
        if (aPawn.Controller != None)
        {
            aPawn.Controller.UnPossess();
        }
        aPawn.PossessedBy(Self, bVehicleTransition);
        Pawn = aPawn;
        Pawn.SetTickIsDisabled(FALSE);
        ResetTimeMargin();
        UpdateSex();
        Restart(bVehicleTransition);
        foreach Pawn.TouchingActors(Class'Actor', A, )
        {
            for (i = 0; i < A.GeneratedEvents.Length; i++)
            {
                TouchEvent = SeqEvent_Touch(A.GeneratedEvents[i]);
                if (TouchEvent != None && (TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerOnly || TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerAndSquad || TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerOnlyLocal))
                {
                    TouchEvent.CheckTouchActivate(A, Pawn);
                }
            }
        }
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    ResetCameraMode();
    MaxTimeMargin = Class'GameInfo'.default.MaxTimeMargin;
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    if (WorldInfo.NetMode == ENetMode.NM_Client)
    {
        SpawnDefaultHUD();
    }
    else
    {
        AddCheats();
    }
    SetViewTarget(Self);
    LastActiveTime = WorldInfo.TimeSeconds;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
}
public event function PreClientTravel(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
    local UIInteraction UIController;
    local GameUISceneClient GameSceneClient;
    
    UIController = GetUIController();
    if (UIController != None && IsPrimaryPlayer())
    {
        GameSceneClient = UIController.SceneClient;
        if (GameSceneClient != None)
        {
            GameSceneClient.NotifyClientTravel(Self, PendingURL, TravelType, bIsSeamlessTravel);
        }
    }
}
public event function PreRender(Canvas Canvas);

public event function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    if (Pawn != None && Pawn.Acceleration != newAccel)
    {
        Pawn.Acceleration = newAccel;
    }
}
public event simulated function ReceivedPlayer()
{
    local LocalPlayer LP;
    local PlayerController FirstPlayer;
    
    if (PlayerReplicationInfo != None && IsSplitscreenPlayer())
    {
        if (int(NetPlayerIndex) != 0)
        {
            LP = LocalPlayer(Player);
            FirstPlayer = LP.ViewportClient.Outer.GamePlayers[0].Actor;
            FirstPlayer.PlayerReplicationInfo.SetSplitscreenIndex(0);
        }
        PlayerReplicationInfo.SetSplitscreenIndex(NetPlayerIndex);
    }
    RegisterPlayerDataStores();
}
public event reliable client function ReceiveLocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer || WorldInfo.GRI == None)
    {
        return;
    }
    Message.static.ClientReceive(Self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public final event reliable client function RemoveAllDebugStrings()
{
    DebugTextList.Length = 0;
}
public final event reliable client function RemoveDebugText(Actor SrcActor)
{
    local int idx;
    
    idx = DebugTextList.Find('SrcActor', SrcActor);
    if (idx != -1)
    {
        DebugTextList.Remove(idx, 1);
    }
}
public function Reset()
{
    local Vehicle DrivenVehicle;
    
    DrivenVehicle = Vehicle(Pawn);
    if (DrivenVehicle != None)
    {
        DrivenVehicle.DriverLeave(TRUE);
    }
    if (Pawn != None)
    {
        PawnDied(Pawn);
        UnPossess();
    }
    Super.Reset();
    SetViewTarget(Self);
    ResetCameraMode();
    WaitDelay = WorldInfo.TimeSeconds + float(2);
    FixFOV();
    if (PlayerReplicationInfo.bOnlySpectator)
    {
        GotoState('Spectating', , , );
    }
    else
    {
        GotoState('PlayerWaiting', , , );
    }
}
public event function ResetCameraMode()
{
    if (Pawn != None)
    {
        SetCameraMode(Pawn.GetDefaultCameraMode(Self));
    }
    else
    {
        SetCameraMode('FirstPerson');
    }
}
public final event function ResetTimeMargin()
{
    TimeMargin = -0.100000001;
    MaxTimeMargin = Class'GameInfo'.default.MaxTimeMargin;
}
public exec function Say(string Msg)
{
    Msg = Left(Msg, 128);
    if (AllowTextMessage(Msg))
    {
        ServerSay(Msg);
    }
}
public event function SendClientAdjustment()
{
    if (AcknowledgedPawn != Pawn)
    {
        PendingAdjustment.TimeStamp = 0.0;
        return;
    }
    if (int(PendingAdjustment.bAckGoodMove) == 1)
    {
        ClientAckGoodMove(PendingAdjustment.TimeStamp);
    }
    else if (Pawn == None || Pawn.Physics != EPhysics.PHYS_Spider)
    {
        if (PendingAdjustment.NewVel == vect(0.0, 0.0, 0.0))
        {
            if (GetStateName() == 'PlayerWalking' && Pawn != None && Pawn.Physics == EPhysics.PHYS_Walking)
            {
                VeryShortClientAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);
            }
            else
            {
                ShortClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);
            }
        }
        else
        {
            ClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase);
        }
    }
    else
    {
        LongClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase, PendingAdjustment.NewFloor.X, PendingAdjustment.NewFloor.Y, PendingAdjustment.NewFloor.Z);
    }
    PendingAdjustment.TimeStamp = 0.0;
    PendingAdjustment.bAckGoodMove = 0;
}
public event reliable server function ServerMutePlayer(UniqueNetId PlayerNetId)
{
    local PlayerController Other;
    
    if (VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoiceMuteList.AddItem(PlayerNetId);
    }
    if (VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoicePacketFilter.AddItem(PlayerNetId);
    }
    ClientMutePlayer(PlayerNetId);
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != None)
    {
        if (Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            Other.VoicePacketFilter.AddItem(PlayerReplicationInfo.UniqueId);
        }
        Other.ClientMutePlayer(PlayerReplicationInfo.UniqueId);
    }
}
public final event reliable server native function ServerNotifyLoadedWorld(Name WorldPackageName);

private final event reliable server native function ServerProcessConvolve(string C, int H);

public event reliable server function ServerUnmutePlayer(UniqueNetId PlayerNetId)
{
    local PlayerController Other;
    local int RemoveIndex;
    
    RemoveIndex = VoiceMuteList.Find('Uid', PlayerNetId.Uid);
    if (RemoveIndex != -1)
    {
        VoiceMuteList.Remove(RemoveIndex, 1);
    }
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != None)
    {
        if (GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1 && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            ClientUnmutePlayer(PlayerNetId);
        }
        if (Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1 && Other.GameplayVoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
            if (RemoveIndex != -1)
            {
                VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            RemoveIndex = Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid);
            if (RemoveIndex != -1)
            {
                Other.VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            Other.ClientUnmutePlayer(PlayerReplicationInfo.UniqueId);
        }
    }
}
public final event reliable server native function ServerUpdateLevelVisibility(Name PackageName, bool bIsVisible);

public native function SetAllowMatureLanguage(bool bAllowMatureLanguge);

public exec native function SetAudioGroupVolume(Name GroupName, float Volume);

public simulated native function SetControllerTiltActive(bool bActive);

public simulated native function SetControllerTiltDesiredIfAvailable(bool bActive);

public exec function SetName(coerce string S)
{
    local string NewName;
    local LocalPlayer LocPlayer;
    
    if (S != "")
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != None && OnlineSub.GameInterface != None && OnlineSub.PlayerInterface != None)
        {
            if (int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) == 2 && OnlineSub.GameInterface.GetGameSettings('Game') != None)
            {
                S = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
            }
        }
        NewName = S;
        ServerChangeName(NewName);
        UpdateURL("Name", NewName, TRUE);
        SaveConfig();
    }
}
public final native function SetNetSpeed(int NewSpeed);

public simulated native function SetOnlyUseControllerTiltInput(bool bActive);

public exec simulated native function SetShowSubtitles(bool bValue);

public simulated native function SetUseTiltForwardAndBack(bool bActive);

public native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

public event function SoakPause(Pawn P)
{
    SetViewTarget(P);
    SetPause(TRUE);
    myHUD.bShowDebugInfo = TRUE;
}
public event function SpawnPlayerCamera()
{
    if (CameraClass != None && IsLocalPlayerController())
    {
        PlayerCamera = Spawn(CameraClass, Self);
        if (PlayerCamera != None)
        {
            PlayerCamera.InitializeFor(Self);
        }
    }
}
public event reliable client function TeamMessage(PlayerReplicationInfo PRI, coerce string S, Name Type, optional float MsgLifeTime);

public event function UnPossess()
{
    if (Pawn != None)
    {
        SetLocation(Pawn.location, );
        Pawn.RemoteRole = ENetRole.ROLE_SimulatedProxy;
        Pawn.UnPossessed();
        CleanOutSavedMoves();
        if (GetViewTarget() == Pawn)
        {
            SetViewTarget(Self);
        }
    }
    Pawn = None;
}
public final function UpdatePing(float TimeStamp)
{
    if (PlayerReplicationInfo != None)
    {
        PlayerReplicationInfo.UpdatePing(TimeStamp);
        if (WorldInfo.TimeSeconds - LastPingUpdate > float(4))
        {
            LastPingUpdate = WorldInfo.TimeSeconds;
            ServerUpdatePing(int(float(1000) * PlayerReplicationInfo.ExactPing));
        }
    }
}
public final native(546) function UpdateURL(string NewOption, string NewValue, bool bSave1Default);

public exec function UTrace()
{
    ConsoleCommand("hidelog");
    if (Role != ENetRole.ROLE_Authority)
    {
        ServerUTrace();
    }
    SetUTracing(!IsUTracing());
}
public event unreliable client native function WwiseClientHearSound(WwiseBaseSoundObject Sound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded);

public event unreliable client native function WwiseClientStopSound(WwiseBaseSoundObject Sound, Actor SourceActor);

public function PlayerMove(float DeltaTime);

public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    if (HUD.ShouldDisplayDebug('Camera'))
    {
        if (PlayerCamera != None)
        {
            PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255, 0, 0);
            HUD.Canvas.DrawText("NO CAMERA");
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4.0, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Input'))
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
        HUD.Canvas.DrawText("Input ignoremove " $ bIgnoreMoveInput $ " ignore look " $ bIgnoreLookInput $ " aForward " $ PlayerInput.aForward);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}
public simulated function OnDestroy(SeqAct_Destroy Action)
{
    Action.ScriptLog("Cannot use Destroy action on players");
}
public function AcknowledgePossession(Pawn P)
{
    if (LocalPlayer(Player) != None)
    {
        AcknowledgedPawn = P;
        if (P != None)
        {
            P.SetBaseEyeheight();
            P.EyeHeight = P.BaseEyeHeight;
        }
        ServerAcknowledgePossession(P);
    }
}
public function AddCheats()
{
    if (CheatManager == None && WorldInfo.Game != None && WorldInfo.Game.AllowCheats(Self))
    {
        CheatManager = new (Self) CheatClass;
        CheatManager.InitCheatManager();
    }
}
public function AdjustFOV(float DeltaTime)
{
    if (FOVAngle != DesiredFOV)
    {
        if (FOVAngle > DesiredFOV)
        {
            FOVAngle = FOVAngle - FMax(7.0, 0.899999976 * DeltaTime * (FOVAngle - DesiredFOV));
        }
        else
        {
            FOVAngle = FOVAngle - FMin(-7.0, 0.899999976 * DeltaTime * (FOVAngle - DesiredFOV));
        }
        if (Abs(FOVAngle - DesiredFOV) <= float(10))
        {
            FOVAngle = DesiredFOV;
        }
    }
}
public function float AimHelpDot(bool bInstantHit)
{
    if (FOVAngle < DefaultFOV - float(8))
    {
        return 0.99000001;
    }
    if (bInstantHit)
    {
        return 0.970000029;
    }
    return 0.930000007;
}
public function bool AimingHelp(bool bInstantHit)
{
    return WorldInfo.NetMode == ENetMode.NM_Standalone && bAimingHelp;
}
public function bool AllowTextMessage(string Msg)
{
    local int i;
    
    if (WorldInfo.NetMode == ENetMode.NM_Standalone || PlayerReplicationInfo.bAdmin)
    {
        return TRUE;
    }
    if (WorldInfo.Pauser == None && WorldInfo.TimeSeconds - LastBroadcastTime < float(2))
    {
        return FALSE;
    }
    if (WorldInfo.TimeSeconds - LastBroadcastTime < float(5))
    {
        Msg = Left(Msg, Clamp(Len(Msg) - 4, 8, 64));
        for (i = 0; i < 4; i++)
        {
            if (LastBroadcastString[i] ~= Msg)
            {
                return FALSE;
            }
        }
    }
    for (i = 3; i > 0; i--)
    {
        LastBroadcastString[i] = LastBroadcastString[i - 1];
    }
    LastBroadcastTime = WorldInfo.TimeSeconds;
    return TRUE;
}
private final simulated function bool AllowTTSMessageFrom(PlayerReplicationInfo PRI)
{
    return TRUE;
}
public reliable server function AskForPawn()
{
    if (GamePlayEndedState())
    {
        ClientGotoState(GetStateName(), 'Begin');
    }
    else if (Pawn != None)
    {
        GivePawn(Pawn);
    }
    else
    {
        bFrozen = FALSE;
        ServerRestartPlayer();
    }
}
public exec function BugItGo(coerce float X, coerce float Y, coerce float Z, coerce int Pitch, coerce int Yaw, coerce int Roll)
{
    local Vector TheLocation;
    local Rotator TheRotation;
    
    TheLocation.X = X;
    TheLocation.Y = Y;
    TheLocation.Z = Z;
    TheRotation.Pitch = Pitch;
    TheRotation.Yaw = Yaw;
    TheRotation.Roll = 21;
    BugItWorker(TheLocation, TheRotation);
}
public function BugItGoString(string TheLocation, string TheRotation)
{
    BugItWorker(Vector(TheLocation), Rotator(TheRotation));
}
public function BugItWorker(Vector TheLocation, Rotator TheRotation)
{
    if (CheatManager != None)
    {
        CheatManager.Ghost();
    }
    ViewTarget.SetLocation(TheLocation, );
    Pawn.FaceRotation(TheRotation, 0.0);
    SetRotation(TheRotation);
}
public function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local Vector BuildAccel;
    local byte OldAccelX;
    local byte OldAccelY;
    local byte OldAccelZ;
    
    if (OldMove != None)
    {
        BuildAccel = 0.0500000007 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
        OldAccelX = byte(CompressAccel(int(BuildAccel.X)));
        OldAccelY = byte(CompressAccel(int(BuildAccel.Y)));
        OldAccelZ = byte(CompressAccel(int(BuildAccel.Z)));
        OldServerMove(OldMove.TimeStamp, OldAccelX, OldAccelY, OldAccelZ, OldMove.CompressedFlags());
    }
    if (PendingMove != None)
    {
        DualServerMove(PendingMove.TimeStamp, PendingMove.Acceleration * float(10), PendingMove.CompressedFlags(), ((PendingMove.Rotation.Yaw & 65535) << 16) + (PendingMove.Rotation.Pitch & 65535), NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
    }
    else
    {
        ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
    }
}
public function bool CanAllPlayersPlayOnline()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;
    
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        LocPlayer = LocalPlayer(PC.Player);
        if (LocPlayer != None)
        {
            if (int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) != 2 || int(OnlineSub.PlayerInterface.CanPlayOnline(byte(LocPlayer.ControllerId))) == 0)
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function bool CanRestartPlayer()
{
    return PlayerReplicationInfo != None && !PlayerReplicationInfo.bOnlySpectator && HasClientLoadedCurrentWorld();
}
public function bool CanUnpauseControllerConnected()
{
    return bIsControllerConnected;
}
public function bool CanUnpauseExternalUI()
{
    return !bIsExternalUIOpen || bPendingDelete || bPendingDestroy || bDeleteMe;
}
public function bool CanViewUserCreatedContent()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None && OnlineSub.PlayerInterface != None)
    {
        return int(OnlineSub.PlayerInterface.CanDownloadUserContent(byte(LocPlayer.ControllerId))) == 2;
    }
    return TRUE;
}
public exec function CE(optional Name EventName)
{
    ServerCauseEvent(EventName);
}
public exec function ChangeTeam(optional string TeamName)
{
    local int N;
    
    if (TeamName ~= "blue")
    {
        N = 1;
    }
    else if (TeamName ~= "red" || PlayerReplicationInfo == None || PlayerReplicationInfo.Team == None || PlayerReplicationInfo.Team.TeamIndex > 1)
    {
        N = 0;
    }
    else
    {
        N = 1 - PlayerReplicationInfo.Team.TeamIndex;
    }
    ServerChangeTeam(N);
}
public function CheckJumpOrDuck()
{
    if (bPressedJump && Pawn != None)
    {
        Pawn.DoJump(bUpdating);
    }
}
public function CleanOutSavedMoves()
{
    SavedMoves = None;
    PendingMove = None;
}
public function CleanupPawn()
{
    local Vehicle DrivenVehicle;
    local Pawn Driver;
    
    DrivenVehicle = Vehicle(Pawn);
    if (DrivenVehicle != None)
    {
        Driver = DrivenVehicle.Driver;
        DrivenVehicle.DriverLeave(TRUE);
        if (Driver != None)
        {
            Driver.Health = 0;
            Driver.Died(Self, Class'DmgType_Suicided', Driver.location);
        }
    }
    else if (Pawn != None)
    {
        Pawn.Health = 0;
        Pawn.Died(Self, Class'DmgType_Suicided', Pawn.location);
    }
}
public function CleanupPRI()
{
    WorldInfo.Game.AddInactivePRI(PlayerReplicationInfo, Self);
    PlayerReplicationInfo = None;
}
public function ClearAckedMoves()
{
    local SavedMove CurrentMove;
    
    CurrentMove = SavedMoves;
    while (CurrentMove != None)
    {
        if (CurrentMove.TimeStamp <= CurrentTimeStamp)
        {
            if (CurrentMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurrentMove.Acceleration;
            }
            SavedMoves = CurrentMove.NextMove;
            CurrentMove.NextMove = FreeMoves;
            FreeMoves = CurrentMove;
            FreeMoves.Clear();
            CurrentMove = SavedMoves;
            continue;
        }
        break;
    }
}
public function ClearDoubleClick()
{
    if (PlayerInput != None)
    {
        PlayerInput.DoubleClickTimer = 0.0;
    }
}
public function ClearInviteDelegates()
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
    OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
}
public unreliable client function ClientAckGoodMove(float TimeStamp)
{
    UpdatePing(TimeStamp);
    CurrentTimeStamp = TimeStamp;
    ClearAckedMoves();
}
public unreliable client function ClientAdjustPosition(float TimeStamp, Name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != None)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
}
public reliable client function ClientAdminMessage(string Msg)
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        LP.ViewportClient.ClearProgressMessages();
        LP.ViewportClient.SetProgressTime(6.0);
        LP.ViewportClient.SetProgressMessage(2, Msg);
    }
}
public reliable client function ClientArbitratedMatchEnded()
{
    ConsoleCommand("Disconnect");
}
public reliable client function ClientCapBandwidth(int Cap)
{
    ClientCap = Cap;
    if (Player != None && Player.CurrentNetSpeed > Cap)
    {
        SetNetSpeed(Cap);
    }
}
public final reliable client function ClientClearKismetText(Vector2D MessageOffset)
{
    local int RemoveIdx;
    
    RemoveIdx = myHUD.KismetTextInfo.Find('MessageOffset', MessageOffset);
    myHUD.KismetTextInfo.Remove(RemoveIdx, 1);
}
public reliable client function ClientControlMovieTexture(TextureMovie MovieTexture, EMovieControlType mode)
{
    if (MovieTexture != None)
    {
        switch (mode)
        {
            case EMovieControlType.MCT_Play:
                MovieTexture.Play();
                break;
            case EMovieControlType.MCT_Stop:
                MovieTexture.Stop();
                break;
            case EMovieControlType.MCT_Pause:
                MovieTexture.Pause();
                break;
            default:
                break;
        }
    }
}
public reliable client function ClientDrawCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines)
{
    DrawDebugCoordinateSystem(AxisLoc, AxisRot, Scale, bPersistentLines);
}
public final reliable client function ClientDrawKismetText(KismetDrawTextInfo DrawTextInfo, float DisplayTime)
{
    if (DisplayTime > float(0))
    {
        DrawTextInfo.MessageEndTime = WorldInfo.TimeSeconds + DisplayTime;
    }
    else
    {
        DrawTextInfo.MessageEndTime = -1.0;
    }
    myHUD.KismetTextInfo.AddItem(DrawTextInfo);
}
public reliable client function ClientEndOnlineGame()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineSub != None && OnlineSub.GameInterface != None && IsPrimaryPlayer())
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
        if (GameSettings != None && GameSettings.GameState == EOnlineGameState.OGS_InProgress)
        {
            OnlineSub.GameInterface.EndOnlineGame(PlayerReplicationInfo.SessionName);
        }
    }
}
public reliable client function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded', , , );
}
public reliable client function ClientGotoState(Name NewState, optional Name NewLabel)
{
    if ((NewLabel == 'Begin' || NewLabel == 'None') && !IsInState(NewState, ))
    {
        GotoState(NewState, , , );
    }
    else
    {
        GotoState(NewState, NewLabel, , );
    }
}
public reliable client function ClientIgnoreLookInput(bool bIgnore)
{
    IgnoreLookInput(bIgnore);
}
public reliable client function ClientIgnoreMoveInput(bool bIgnore)
{
    IgnoreMoveInput(bIgnore);
}
public reliable client function ClientInitializeDataStores()
{
    RegisterPlayerDataStores();
}
public reliable client function ClientPlayActorFaceFXAnim(Actor SourceActor, FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    if (SourceActor != None)
    {
        SourceActor.PlayActorFaceFXAnim(AnimSet, GroupName, SeqName, SoundCueToPlay);
    }
}
public unreliable client function ClientPlayCameraShake(CameraShake Shake, optional float Scale = 1.0, optional bool bTryForceFeedback, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.PlayCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
        if (bTryForceFeedback)
        {
            DoForceFeedbackForScreenShake(Shake, Scale);
        }
    }
}
public reliable client function ClientRegisterForArbitration()
{
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        OnlineSub.GameInterface.AddArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
        OnlineSub.GameInterface.RegisterForArbitration('Game');
    }
    else
    {
        ServerRegisteredForArbitration(TRUE);
    }
}
public reliable client function ClientRegisterHostStatGuid(string StatGuid)
{
    if (OnlineSub != None && OnlineSub.StatsInterface != None)
    {
        OnlineSub.StatsInterface.AddRegisterHostStatGuidCompleteDelegate(OnRegisterHostStatGuidComplete);
        if (OnlineSub.StatsInterface.RegisterHostStatGuid(StatGuid) == FALSE)
        {
            OnRegisterHostStatGuidComplete(FALSE);
        }
    }
}
public reliable client function ClientReset()
{
    ResetCameraMode();
    SetViewTarget(Self);
    GotoState(PlayerReplicationInfo.bOnlySpectator ? 'Spectating' : 'PlayerWaiting', , , );
}
public reliable client function ClientRestart(Pawn NewPawn)
{
    ResetPlayerMovementInput();
    CleanOutSavedMoves();
    Pawn = NewPawn;
    if (Pawn != None && Pawn.bTearOff)
    {
        UnPossess();
        Pawn = None;
    }
    AcknowledgePossession(Pawn);
    if (Pawn == None)
    {
        GotoState('WaitingForPawn', , , );
        return;
    }
    Pawn.ClientRestart();
    if (Role < ENetRole.ROLE_Authority)
    {
        SetViewTarget(Pawn);
        ResetCameraMode();
        EnterStartState();
    }
    CleanOutSavedMoves();
}
public reliable client function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
    local string URL;
    
    if (IsPrimaryPlayer())
    {
        if (OnlineSub != None && OnlineSub.GameInterface != None && OnlineSub.PlayerInterface != None)
        {
            if (OnlineSub.GameInterface.GetGameSettings('Party') != None)
            {
                if (IsPartyLeader())
                {
                    URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName() $ "?listen";
                    WorldInfo.ServerTravel(URL, TRUE, TRUE);
                }
                else if (OnlineSub.GameInterface.GetResolvedConnectString('Party', URL))
                {
                    ClientTravel(URL, 0);
                }
            }
            else
            {
                ConsoleCommand("disconnect");
            }
        }
        else
        {
            ConsoleCommand("disconnect");
        }
    }
}
public reliable client function ClientSetCameraMode(Name NewCamMode)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.CameraStyle = NewCamMode;
    }
}
public reliable client function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD)
{
    bCinematicMode = bInCinematicMode;
    if (myHUD != None && bAffectsHUD)
    {
        myHUD.bShowHUD = !bCinematicMode;
    }
    if (bAffectsMovement)
    {
        IgnoreMoveInput(bCinematicMode);
    }
    if (bAffectsTurning)
    {
        IgnoreLookInput(bCinematicMode);
    }
}
public reliable client function ClientSetHostUniqueId(UniqueNetId InHostId);

public reliable client function ClientSetHUD(Class<HUD> newHUDType, Class<Scoreboard> newScoringType)
{
    if (myHUD != None)
    {
        myHUD.Destroy();
    }
    if (newHUDType == None)
    {
        myHUD = None;
    }
    else
    {
        myHUD = Spawn(newHUDType, Self);
        if (myHUD != None)
        {
            myHUD.SpawnScoreBoard(newScoringType);
        }
    }
}
public reliable client function ClientSetOnlineStatus();

public reliable client function ClientStartNetworkedVoice()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None && OnlineSub.VoiceInterface != None)
    {
        OnlineSub.VoiceInterface.StartNetworkedVoice(byte(LocPlayer.ControllerId));
    }
}
public reliable client function ClientStartOnlineGame()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineSub != None && OnlineSub.GameInterface != None && IsPrimaryPlayer())
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
        if (GameSettings != None && (GameSettings.GameState == EOnlineGameState.OGS_Pending || GameSettings.GameState == EOnlineGameState.OGS_Ended))
        {
            OnlineSub.GameInterface.StartOnlineGame(PlayerReplicationInfo.SessionName);
        }
    }
}
public unreliable client function ClientStopCameraShake(CameraShake Shake)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.StopCameraShake(Shake);
    }
}
public reliable client function ClientStopNetworkedVoice()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None && OnlineSub.VoiceInterface != None)
    {
        OnlineSub.VoiceInterface.StopNetworkedVoice(byte(LocPlayer.ControllerId));
    }
}
public reliable client function ClientTravelToSession(Name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    local OnlineGameSearch Search;
    local LocalPlayer LP;
    local OnlineGameSearchResult SessionToJoin;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        Search = new SearchClass;
        if (OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(byte(LP.ControllerId), Search, PlatformSpecificInfo))
        {
            SessionToJoin = Search.Results[0];
            OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinTravelToSessionComplete);
            OnlineSub.GameInterface.JoinOnlineGame(byte(LP.ControllerId), SessionName, SessionToJoin);
        }
    }
}
public function ClientUpdatePosition()
{
    local SavedMove CurrentMove;
    local int realbRun;
    local int realbDuck;
    local bool bRealJump;
    local bool bRealPreciseDestination;
    local bool bRealForceMaxAccel;
    local bool bRealRootMotionFromInterpCurve;
    local ERootMotionMode RealRootMotionMode;
    
    bUpdatePosition = FALSE;
    if (Pawn != None && Pawn.Physics == EPhysics.PHYS_RigidBody)
    {
        return;
    }
    realbRun = int(bRun);
    realbDuck = int(bDuck);
    bRealJump = bPressedJump;
    bUpdating = TRUE;
    bRealPreciseDestination = bPreciseDestination;
    if (Pawn != None)
    {
        bRealForceMaxAccel = Pawn.bForceMaxAccel;
        bRealRootMotionFromInterpCurve = Pawn.bRootMotionFromInterpCurve;
        RealRootMotionMode = Pawn.Mesh.RootMotionMode;
    }
    ClearAckedMoves();
    CurrentMove = SavedMoves;
    while (CurrentMove != None)
    {
        if (PendingMove == CurrentMove && Pawn != None)
        {
            PendingMove.SetInitialPosition(Pawn);
        }
        CurrentMove.PrepMoveFor(Pawn);
        MoveAutonomous(CurrentMove.Delta, CurrentMove.CompressedFlags(), CurrentMove.Acceleration, rot(0, 0, 0));
        CurrentMove.ResetMoveFor(Pawn);
        CurrentMove = CurrentMove.NextMove;
    }
    bUpdating = FALSE;
    bDuck = byte(realbDuck);
    bRun = byte(realbRun);
    bPressedJump = bRealJump;
    bPreciseDestination = bRealPreciseDestination;
    if (Pawn != None)
    {
        Pawn.bForceMaxAccel = bRealForceMaxAccel;
        Pawn.bRootMotionFromInterpCurve = bRealRootMotionFromInterpCurve;
        Pawn.Mesh.RootMotionMode = RealRootMotionMode;
    }
}
public reliable client function ClientVoiceHandshakeComplete()
{
    bHasVoiceHandshakeCompleted = TRUE;
}
public function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, Name MessageType, byte messageId);

public reliable client function ClientWriteLeaderboardStats(Class<OnlineStatsWrite> OnlineStatsWriteClass);

public reliable client function ClientWriteOnlinePlayerScores(int LeaderboardId)
{
    local GameReplicationInfo GRI;
    local int Index;
    local array<OnlinePlayerScore> PlayerScores;
    local UniqueNetId ZeroUniqueId;
    local bool bIsTeamGame;
    local int ScoreIndex;
    
    GRI = WorldInfo.GRI;
    if (GRI != None && OnlineSub != None && OnlineSub.StatsInterface != None)
    {
        bIsTeamGame = GRI.GameClass != None ? GRI.GameClass.default.bTeamGame : FALSE;
        for (Index = 0; Index < GRI.PRIArray.Length; Index++)
        {
            if (GRI.PRIArray[Index].UniqueId != ZeroUniqueId)
            {
                ScoreIndex = PlayerScores.Length;
                PlayerScores.Length = ScoreIndex + 1;
                PlayerScores[ScoreIndex].PlayerID = GRI.PRIArray[Index].UniqueId;
                if (bIsTeamGame)
                {
                    PlayerScores[ScoreIndex].TeamID = GRI.PRIArray[Index].Team.TeamIndex;
                    PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Team.Score);
                    continue;
                }
                PlayerScores[ScoreIndex].TeamID = Index;
                PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Score);
            }
        }
        OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerReplicationInfo.SessionName, LeaderboardId, PlayerScores);
    }
}
public function int CompressAccel(int C)
{
    if (C >= 0)
    {
        C = Min(C, 127);
    }
    else
    {
        C = Min(int(Abs(float(C))), 127) + 128;
    }
    return C;
}
public function DebugLogPRIs();

public function DelayedPrepareMapChange()
{
    if (WorldInfo.IsPreparingMapChange())
    {
        SetTimer(0.00999999978, FALSE, 'DelayedPrepareMapChange', );
    }
    else
    {
        WorldInfo.PrepareMapChange(PendingMapChangeLevelNames);
    }
}
public function DisableDebugAI()
{
    ConsoleCommand("debugai");
}
protected simulated function DoForceFeedbackForScreenShake(CameraShake ShakeData, float ShakeScale);

public final simulated function DrawDebugTextList(Canvas Canvas, float RenderDelta)
{
    local Vector cameraLoc;
    local Vector ScreenLoc;
    local Vector Offset;
    local Vector WorldTextLoc;
    local Rotator cameraRot;
    local int idx;
    
    if (DebugTextList.Length > 0)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.Font = Class'Engine'.static.GetSmallFont();
        for (idx = 0; idx < DebugTextList.Length; idx++)
        {
            if (DebugTextList[idx].SrcActor == None)
            {
                DebugTextList.Remove(idx--, 1);
                continue;
            }
            if (DebugTextList[idx].TimeRemaining != -1.0)
            {
                DebugTextList[idx].TimeRemaining -= RenderDelta;
                if (DebugTextList[idx].TimeRemaining <= 0.0)
                {
                    DebugTextList.Remove(idx--, 1);
                    continue;
                }
            }
            if (DebugTextList[idx].bAbsoluteLocation)
            {
                WorldTextLoc = VLerp(DebugTextList[idx].SrcActorOffset, DebugTextList[idx].SrcActorDesiredOffset, 1.0 - DebugTextList[idx].TimeRemaining / DebugTextList[idx].Duration);
            }
            else
            {
                Offset = VLerp(DebugTextList[idx].SrcActorOffset, DebugTextList[idx].SrcActorDesiredOffset, 1.0 - DebugTextList[idx].TimeRemaining / DebugTextList[idx].Duration);
                WorldTextLoc = DebugTextList[idx].SrcActor.location + (Offset >> cameraRot);
            }
            if ((WorldTextLoc - cameraLoc) Dot Vector(cameraRot) > 0.0)
            {
                ScreenLoc = Canvas.Project(WorldTextLoc);
                Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                Canvas.DrawColor = DebugTextList[idx].TextColor;
                Canvas.DrawText(DebugTextList[idx].DebugText);
            }
        }
    }
}
public function DrawHUD(HUD H)
{
    if (Pawn != None)
    {
        Pawn.DrawHUD(H);
    }
    if (PlayerInput != None)
    {
        PlayerInput.DrawHUD(H);
    }
}
public unreliable server function DualServerMove(float TimeStamp0, Vector InAccel0, byte PendingFlags, int View0, float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
    ServerMove(TimeStamp0, InAccel0, vect(1.0, 2.0, 3.0), PendingFlags, ClientRoll, View0);
    ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, View);
}
public exec function DumpOnlineSessionState();

public exec function EnableCheats()
{
    AddCheats();
}
public function EnterStartState()
{
    local Name NewState;
    
    if (Pawn.PhysicsVolume.bWaterVolume)
    {
        if (Pawn.HeadVolume.bWaterVolume)
        {
            Pawn.BreathTime = Pawn.UnderWaterTime;
        }
        NewState = Pawn.WaterMovementState;
    }
    else
    {
        NewState = Pawn.LandMovementState;
    }
    if (GetStateName() == NewState)
    {
        BeginState(NewState);
    }
    else
    {
        GotoState(NewState, , , );
    }
}
public function bool FindVehicleToDrive()
{
    local Vehicle V;
    local Vehicle Best;
    local Vector ViewDir;
    local Vector PawnLoc2D;
    local Vector VLoc2D;
    local float NewDot;
    local float BestDot;
    
    if (Vehicle(Pawn.Base) != None && Vehicle(Pawn.Base).TryToDrive(Pawn))
    {
        return TRUE;
    }
    PawnLoc2D = Pawn.location;
    PawnLoc2D.Z = 0.0;
    ViewDir = Vector(Pawn.Rotation);
    foreach Pawn.OverlappingActors(Class'Vehicle', V, Pawn.VehicleCheckRadius)
    {
        VLoc2D = V.location;
        VLoc2D.Z = 0.0;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        if (Best == None || NewDot > BestDot)
        {
            if (FastTrace(V.location, Pawn.location, , ))
            {
                Best = V;
                BestDot = NewDot;
            }
        }
    }
    return Best != None && Best.TryToDrive(Pawn);
}
public function FixFOV()
{
    FOVAngle = default.DefaultFOV;
    DesiredFOV = default.DefaultFOV;
    DefaultFOV = default.DefaultFOV;
}
public function ForceDeathUpdate()
{
    LastUpdateTime = WorldInfo.TimeSeconds - float(10);
}
public function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded', , , );
    ClientGameEnded(EndGameFocus, bIsWinner);
}
public function GameplayMutePlayer(UniqueNetId PlayerNetId)
{
    if (GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
    {
        GameplayVoiceMuteList.AddItem(PlayerNetId);
    }
    if (VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoicePacketFilter.AddItem(PlayerNetId);
    }
    ClientMutePlayer(PlayerNetId);
}
public function GameplayUnmutePlayer(UniqueNetId PlayerNetId)
{
    local int RemoveIndex;
    local PlayerController Other;
    
    RemoveIndex = GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid);
    if (RemoveIndex != -1)
    {
        GameplayVoiceMuteList.Remove(RemoveIndex, 1);
    }
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != None)
    {
        if (VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1 && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
            if (RemoveIndex != -1)
            {
                VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            ClientUnmutePlayer(PlayerNetId);
        }
    }
}
public function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector FireDir;
    local Vector AimSpot;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector OldAim;
    local Vector AimOffset;
    local Actor BestTarget;
    local Actor HitActor;
    local float bestAim;
    local float bestDist;
    local bool bNoZAdjust;
    local bool bInstantHit;
    local Rotator BaseAimRot;
    local Rotator AimRot;
    
    bInstantHit = W == None || W.bInstantHit;
    BaseAimRot = Pawn != None ? Pawn.GetBaseAimRotation() : Rotation;
    FireDir = Vector(BaseAimRot);
    HitActor = Trace(HitLocation, HitNormal, StartFireLoc + W.GetTraceRange() * FireDir, StartFireLoc, TRUE, , , );
    if (HitActor != None && HitActor.bProjTarget)
    {
        BestTarget = HitActor;
        bNoZAdjust = TRUE;
        OldAim = HitLocation;
        bestDist = VSize(BestTarget.location - Pawn.location);
    }
    else
    {
        bestAim = 0.899999976;
        if (AimingHelp(bInstantHit))
        {
            bestAim = AimHelpDot(bInstantHit);
        }
        else if (bInstantHit)
        {
            bestAim = 1.0;
        }
        BestTarget = PickTarget(Class'Pawn', bestAim, bestDist, FireDir, StartFireLoc, W.WeaponRange);
        if (BestTarget == None)
        {
            return BaseAimRot;
        }
        OldAim = StartFireLoc + FireDir * bestDist;
    }
    ShotTarget = Pawn(BestTarget);
    if (!AimingHelp(bInstantHit))
    {
        return BaseAimRot;
    }
    FireDir = BestTarget.location - StartFireLoc;
    AimSpot = StartFireLoc + bestDist * Normal(FireDir);
    AimOffset = AimSpot - OldAim;
    if (ShotTarget != None)
    {
        if (bNoZAdjust)
        {
            AimSpot.Z = OldAim.Z;
        }
        else if (AimOffset.Z < float(0))
        {
            AimSpot.Z = ShotTarget.location.Z + 0.400000006 * ShotTarget.CylinderComponent.CollisionHeight;
        }
        else
        {
            AimSpot.Z = ShotTarget.location.Z - 0.699999988 * ShotTarget.CylinderComponent.CollisionHeight;
        }
    }
    else
    {
        AimSpot.Z = OldAim.Z;
    }
    if (!bNoZAdjust)
    {
        AimRot = Rotator(AimSpot - StartFireLoc);
        if (FOVAngle < DefaultFOV - float(8))
        {
            AimRot.Yaw = AimRot.Yaw + 200 - Rand(400);
        }
        else
        {
            AimRot.Yaw = AimRot.Yaw + 375 - Rand(750);
        }
        return AimRot;
    }
    return Rotator(AimSpot - StartFireLoc);
}
public final function SavedMove GetFreeMove()
{
    local SavedMove S;
    local SavedMove first;
    local int i;
    
    if (FreeMoves == None)
    {
        S = SavedMoves;
        while (S != None)
        {
            i++;
            if (i > 100)
            {
                first = SavedMoves;
                SavedMoves = SavedMoves.NextMove;
                first.Clear();
                first.NextMove = None;
                while (SavedMoves != None)
                {
                    S = SavedMoves;
                    SavedMoves = SavedMoves.NextMove;
                    S.Clear();
                    S.NextMove = FreeMoves;
                    FreeMoves = S;
                }
                PendingMove = None;
                return first;
            }
            S = S.NextMove;
        }
        return new (Self) SavedMoveClass;
    }
    else
    {
        S = FreeMoves;
        FreeMoves = FreeMoves.NextMove;
        S.NextMove = None;
        return S;
    }
}
public static function string GetPartyGameTypeName();

public static function string GetPartyMapName();

public final function float GetRumbleScale()
{
    local float RetVal;
    
    RetVal = 1.0;
    if (ForceFeedbackManager != None)
    {
        RetVal = ForceFeedbackManager.ScaleAllWaveformsBy;
    }
    return RetVal;
}
public simulated function PlayerReplicationInfo GetSplitscreenPlayerByIndex(optional int PlayerIndex = 1)
{
    local PlayerReplicationInfo Result;
    local LocalPlayer LP;
    local LocalPlayer SplitPlayer;
    local NetConnection MasterConnection;
    local NetConnection RemoteConnection;
    local ChildConnection ChildRemoteConnection;
    
    if (Player != None)
    {
        if (IsSplitscreenPlayer())
        {
            LP = LocalPlayer(Player);
            RemoteConnection = NetConnection(Player);
            if (LP != None)
            {
                if (PlayerIndex >= 0 && PlayerIndex < LP.ViewportClient.Outer.GamePlayers.Length)
                {
                    SplitPlayer = LP.ViewportClient.Outer.GamePlayers[PlayerIndex];
                    Result = SplitPlayer.Actor.PlayerReplicationInfo;
                }
            }
            else if (RemoteConnection != None)
            {
                if (WorldInfo.NetMode == ENetMode.NM_Client)
                {
                }
                else
                {
                    ChildRemoteConnection = ChildConnection(RemoteConnection);
                    if (ChildRemoteConnection != None)
                    {
                        MasterConnection = ChildRemoteConnection.Parent;
                        if (PlayerIndex == 0)
                        {
                            Result = MasterConnection.Actor.PlayerReplicationInfo;
                        }
                        else
                        {
                            PlayerIndex--;
                            if (PlayerIndex >= 0 && PlayerIndex < MasterConnection.Children.Length)
                            {
                                ChildRemoteConnection = MasterConnection.Children[PlayerIndex];
                                Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
                            }
                        }
                    }
                    else if (RemoteConnection.Children.Length > 0)
                    {
                        if (PlayerIndex == 0)
                        {
                            Result = PlayerReplicationInfo;
                        }
                        else
                        {
                            PlayerIndex--;
                            if (PlayerIndex >= 0 && PlayerIndex < RemoteConnection.Children.Length)
                            {
                                ChildRemoteConnection = RemoteConnection.Children[PlayerIndex];
                                Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
                            }
                        }
                    }
                }
            }
        }
    }
    return Result;
}
public simulated function int GetSplitscreenPlayerCount()
{
    local LocalPlayer LP;
    local NetConnection RemoteConnection;
    local int Result;
    
    if (IsSplitscreenPlayer())
    {
        if (Player != None)
        {
            LP = LocalPlayer(Player);
            RemoteConnection = NetConnection(Player);
            if (LP != None)
            {
                Result = LP.ViewportClient.Outer.GamePlayers.Length;
            }
            else if (RemoteConnection != None)
            {
                if (ChildConnection(RemoteConnection) != None)
                {
                    RemoteConnection = ChildConnection(RemoteConnection).Parent;
                }
                Result = RemoteConnection.Children.Length + 1;
            }
        }
    }
    return Result;
}
public function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
    local int idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local Trigger checkTrigger;
    local SeqEvent_Used UseSeq;
    
    if (Pawn != None)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        foreach Pawn.CollidingActors(Class'Trigger', checkTrigger, interactDistanceToCheck, , , , )
        {
            for (idx = 0; idx < checkTrigger.GeneratedEvents.Length; idx++)
            {
                UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[idx]);
                if (UseSeq != None && (!bUsuableOnly || checkTrigger.GeneratedEvents[idx].CheckActivate(checkTrigger, Pawn, TRUE)) && Normal(checkTrigger.location - cameraLoc) Dot Vector(cameraRot) >= minDot && (UseSeq.bAimToInteract && IsAimingAt(checkTrigger, 0.980000019) && VSize(Pawn.location - checkTrigger.location) <= UseSeq.InteractDistance || !UseSeq.bAimToInteract && VSize(Pawn.location - checkTrigger.location) <= UseSeq.InteractDistance))
                {
                    out_useList[out_useList.Length] = checkTrigger;
                    idx = checkTrigger.GeneratedEvents.Length;
                }
            }
        }
    }
}
public final function UIInteraction GetUIController()
{
    local LocalPlayer LP;
    local UIInteraction Result;
    
    LP = LocalPlayer(Player);
    if (LP != None && LP.ViewportClient != None)
    {
        Result = LP.ViewportClient.UIController;
    }
    return Result;
}
public function HandlePickup(Inventory Inv)
{
    ReceiveLocalizedMessage(Inv.MessageClass, , , , Inv.Class);
}
public simulated function bool HasSplitscreenPlayer(PlayerReplicationInfo PRI)
{
    local bool bResult;
    local PlayerController OwnerPC;
    
    if (PRI != None)
    {
        if (PRI.IsLocalPlayerPRI())
        {
            bResult = IsSplitscreenPlayer();
        }
        else if (Role == ENetRole.ROLE_Authority)
        {
            OwnerPC = PlayerController(PRI.Owner);
            bResult = OwnerPC.IsSplitscreenPlayer();
        }
        else
        {
            bResult = PRI.SplitscreenIndex != -1;
        }
    }
    return bResult;
}
public function IgnoreLookInput(bool bNewLookInput)
{
    bIgnoreLookInput = byte(Max(int(bIgnoreLookInput) + (bNewLookInput ? 1 : -1), 0));
}
public function IgnoreMoveInput(bool bNewMoveInput)
{
    bIgnoreMoveInput = byte(Max(int(bIgnoreMoveInput) + (bNewMoveInput ? 1 : -1), 0));
}
public function IncrementNumberOfMatchesPlayed()
{
    PlayerReplicationInfo.AutomatedTestingData.NumberOfMatchesPlayed++;
}
public function bool InviteHasEnoughSpace(OnlineGameSettings InviteSettings)
{
    local int NumLocalPlayers;
    local PlayerController PC;
    
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        NumLocalPlayers++;
    }
    return InviteSettings.NumOpenPrivateConnections + InviteSettings.NumOpenPublicConnections >= NumLocalPlayers;
}
public simulated function bool IsClosestLocalPlayerToActor(Actor TheActor)
{
    local PlayerController PC;
    local float MyDist;
    
    if (ViewTarget == None)
    {
        return FALSE;
    }
    MyDist = VSize(ViewTarget.location - TheActor.location);
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        if (PC != Self && PC.ViewTarget != None && VSize(PC.ViewTarget.location - TheActor.location) < MyDist)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public simulated function bool IsForceFeedbackAllowed()
{
    return ForceFeedbackManager != None && ForceFeedbackManager.bAllowsForceFeedback;
}
public simulated function bool IsPartyLeader()
{
    local OnlineGameSettings PartySettings;
    
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        if (PartySettings != None)
        {
            if (PlayerReplicationInfo != None)
            {
                return OnlineSub.AreUniqueNetIdsEqual(PartySettings.OwningPlayerId, PlayerReplicationInfo.UniqueId);
            }
        }
    }
    return WorldInfo.NetMode != ENetMode.NM_Client && IsPrimaryPlayer();
}
public final simulated function bool IsPaused()
{
    return WorldInfo.Pauser != None;
}
public simulated function bool IsPrimaryPlayer()
{
    local int SSIndex;
    
    return !IsSplitscreenPlayer(SSIndex) || SSIndex == 0;
}
public simulated function bool IsSplitscreenPlayer(optional out int out_SplitscreenPlayerIndex)
{
    local bool bResult;
    local LocalPlayer LP;
    local NetConnection RemoteConnection;
    local ChildConnection ChildRemoteConnection;
    
    out_SplitscreenPlayerIndex = int(NetPlayerIndex);
    if (Player != None)
    {
        LP = LocalPlayer(Player);
        RemoteConnection = NetConnection(Player);
        if (LP != None)
        {
            if (LP.Outer.GamePlayers.Length > 1)
            {
                out_SplitscreenPlayerIndex = LP.Outer.GamePlayers.Find(LP);
                bResult = TRUE;
            }
        }
        else if (RemoteConnection != None)
        {
            if (RemoteConnection.Children.Length > 0)
            {
                out_SplitscreenPlayerIndex = 0;
                bResult = TRUE;
            }
            else
            {
                ChildRemoteConnection = ChildConnection(RemoteConnection);
                if (ChildRemoteConnection != None)
                {
                    if (ChildRemoteConnection.Parent != None)
                    {
                        out_SplitscreenPlayerIndex = ChildRemoteConnection.Parent.Children.Find(ChildRemoteConnection) + 1;
                    }
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public exec function ListCE()
{
    ListConsoleEvents();
}
public exec function ListConsoleEvents();

public exec function LocalTravel(string URL)
{
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ClientTravel(URL, 2);
    }
}
public exec function LogLoc()
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString;
    local string LocString;
    
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != None)
    {
        ViewLocation = Pawn.location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
}
public unreliable client function LongClientAdjustPosition(float TimeStamp, Name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    local Vector NewLocation;
    local Vector NewVelocity;
    local Vector NewFloor;
    local Actor MoveActor;
    local SavedMove CurrentMove;
    local Actor TheViewTarget;
    
    UpdatePing(TimeStamp);
    if (Pawn != None)
    {
        if (Pawn.bTearOff)
        {
            Pawn = None;
            if (!GamePlayEndedState() && !IsInState('Dead', ))
            {
                GotoState('Dead', , , );
            }
            return;
        }
        MoveActor = Pawn;
        TheViewTarget = GetViewTarget();
        if (TheViewTarget != Pawn && (TheViewTarget == Self || Pawn(TheViewTarget) != None && Pawn(TheViewTarget).Health <= 0))
        {
            ResetCameraMode();
            SetViewTarget(Pawn);
        }
    }
    else
    {
        MoveActor = Self;
        if (GetStateName() != NewState)
        {
            if (NewState == 'RoundEnded')
            {
                GotoState(NewState, , , );
            }
            else if (IsInState('Dead', ))
            {
                if (NewState != 'PlayerWalking' && NewState != 'PlayerSwimming')
                {
                    GotoState(NewState, , , );
                }
                return;
            }
            else if (NewState == 'Dead')
            {
                GotoState(NewState, , , );
            }
        }
    }
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    CurrentTimeStamp = TimeStamp;
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    NewVelocity.X = NewVelX;
    NewVelocity.Y = NewVelY;
    NewVelocity.Z = NewVelZ;
    CurrentMove = SavedMoves;
    while (CurrentMove != None)
    {
        if (CurrentMove.TimeStamp <= CurrentTimeStamp)
        {
            SavedMoves = CurrentMove.NextMove;
            CurrentMove.NextMove = FreeMoves;
            FreeMoves = CurrentMove;
            if (CurrentMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurrentMove.Acceleration;
                FreeMoves.Clear();
                if ((InterpActor(NewBase) != None || Vehicle(NewBase) != None) && NewBase == CurrentMove.EndBase)
                {
                    if (GetStateName() == NewState && IsInState('PlayerWalking', ) && (MoveActor.Physics == EPhysics.PHYS_Walking || MoveActor.Physics == EPhysics.PHYS_Falling))
                    {
                        if (VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 3.0)
                        {
                            CurrentMove = None;
                            return;
                        }
                        else if (Vehicle(NewBase) != None && VSizeSq(Velocity) < 9.0 && VSizeSq(NewVelocity) < 9.0 && VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 900.0)
                        {
                            CurrentMove = None;
                            return;
                        }
                    }
                }
                else if (VSizeSq(CurrentMove.SavedLocation - NewLocation) < 3.0 && VSizeSq(CurrentMove.SavedVelocity - NewVelocity) < 9.0 && GetStateName() == NewState && IsInState('PlayerWalking', ) && (MoveActor.Physics == EPhysics.PHYS_Walking || MoveActor.Physics == EPhysics.PHYS_Falling))
                {
                    CurrentMove = None;
                    return;
                }
                CurrentMove = None;
            }
            else
            {
                FreeMoves.Clear();
                CurrentMove = SavedMoves;
            }
            continue;
        }
        CurrentMove = None;
    }
    if (MoveActor.bHardAttach)
    {
        if (MoveActor.Base == None)
        {
            if (NewBase != None)
            {
                MoveActor.SetBase(NewBase, , , );
            }
            if (MoveActor.Base == None)
            {
                MoveActor.SetHardAttach(FALSE);
            }
            else
            {
                return;
            }
        }
        else
        {
            return;
        }
    }
    NewFloor.X = NewFloorX;
    NewFloor.Y = NewFloorY;
    NewFloor.Z = NewFloorZ;
    if (Pawn != None && Pawn.Physics != EPhysics.PHYS_Falling && Pawn.Mesh != None && Pawn.Mesh.RootMotionMode != ERootMotionMode.RMM_Ignore && !Pawn.bRootMotionFromInterpCurve)
    {
        return;
    }
    CurrentMove = SavedMoves;
    while (CurrentMove != None)
    {
        if (CurrentMove.bForceRMVelocity)
        {
            return;
        }
        CurrentMove = CurrentMove.NextMove;
    }
    if (InterpActor(NewBase) != None || Vehicle(NewBase) != None)
    {
        NewLocation += NewBase.location;
    }
    MoveActor.bCanTeleport = FALSE;
    if (!MoveActor.SetLocation(NewLocation, ) && Pawn(MoveActor) != None && Pawn(MoveActor).CylinderComponent.CollisionHeight > Pawn(MoveActor).CrouchHeight && !Pawn(MoveActor).bIsCrouched && newPhysics == EPhysics.PHYS_Walking && MoveActor.Physics != EPhysics.PHYS_RigidBody)
    {
        MoveActor.SetPhysics(newPhysics);
        if (!MoveActor.SetLocation(NewLocation + vect(0.0, 0.0, 1.0) * Pawn(MoveActor).MaxStepHeight, ))
        {
            Pawn(MoveActor).ForceCrouch();
            MoveActor.SetLocation(NewLocation, );
        }
        else
        {
            MoveActor.MoveSmooth(vect(0.0, 0.0, -1.0) * Pawn(MoveActor).MaxStepHeight);
        }
    }
    MoveActor.bCanTeleport = TRUE;
    if (MoveActor.Physics != EPhysics.PHYS_RigidBody && newPhysics != EPhysics.PHYS_RigidBody)
    {
        MoveActor.SetPhysics(newPhysics);
    }
    if (MoveActor != Self)
    {
        MoveActor.SetBase(NewBase, NewFloor, , );
    }
    MoveActor.Velocity = NewVelocity;
    UpdateStateFromAdjustment(NewState);
    bUpdatePosition = TRUE;
}
public function MoveAutonomous(float DeltaTime, byte CompressedFlags, Vector newAccel, Rotator DeltaRot)
{
    local EDoubleClickDir DoubleClickMove;
    
    if (Pawn != None && Pawn.bHardAttach)
    {
        return;
    }
    DoubleClickMove = SavedMoveClass.static.SetFlags(CompressedFlags, Self);
    HandleWalking();
    ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
    if (Pawn != None)
    {
        Pawn.AutonomousPhysics(DeltaTime);
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    bDoubleJump = FALSE;
}
public function MoveLog(Name FunctionName, string Message, float TimeStamp, optional Vector NewLoc, optional Vector NewVel)
{
}
public exec function Mutate(string MutateString)
{
    ServerMutate(MutateString);
}
public exec function NextWeapon()
{
    if (WorldInfo.Pauser != None)
    {
        return;
    }
    if (Pawn.Weapon == None)
    {
        SwitchToBestWeapon();
        return;
    }
    if (Pawn.InvManager != None)
    {
        Pawn.InvManager.NextWeapon();
    }
}
public function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon);

public function NotifyInviteFailed()
{
    ClearInviteDelegates();
}
public function NotifyNotAllPlayersCanJoinInvite()
{
}
public function NotifyNotEnoughSpaceInInvite()
{
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    Super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    ClientPlayForceFeedbackWaveform(DamageType.default.DamagedFFWaveform);
}
public unreliable server function OldServerMove(float OldTimeStamp, byte OldAccelX, byte OldAccelY, byte OldAccelZ, byte OldMoveFlags)
{
    local Vector Accel;
    
    if (AcknowledgedPawn != Pawn)
    {
        return;
    }
    if (CurrentTimeStamp < OldTimeStamp - 0.00100000005)
    {
        Accel.X = float(OldAccelX);
        if (Accel.X > float(127))
        {
            Accel.X = -1.0 * (Accel.X - float(128));
        }
        Accel.Y = float(OldAccelY);
        if (Accel.Y > float(127))
        {
            Accel.Y = -1.0 * (Accel.Y - float(128));
        }
        Accel.Z = float(OldAccelZ);
        if (Accel.Z > float(127))
        {
            Accel.Z = -1.0 * (Accel.Z - float(128));
        }
        Accel *= float(20);
        OldTimeStamp = FMin(OldTimeStamp, CurrentTimeStamp + MaxResponseTime);
        MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldMoveFlags, Accel, rot(0, 0, 0));
        CurrentTimeStamp = OldTimeStamp;
    }
}
public function OnArbitrationRegisterComplete(Name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
    ServerRegisteredForArbitration(bWasSuccessful);
}
public function OnCameraShake(SeqAct_CameraShake inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (inAction.bRadialShake)
        {
            if (inAction.LocationActor != None)
            {
                Class'Camera'.static.PlayWorldCameraShake(inAction.Shake, inAction.LocationActor, inAction.LocationActor.location, inAction.RadialShake_InnerRadius, inAction.RadialShake_OuterRadius, inAction.RadialShake_Falloff, inAction.bDoControllerVibration, inAction.bOrientTowardRadialEpicenter);
            }
            else
            {
                return;
            }
        }
        else
        {
            ClientPlayCameraShake(inAction.Shake, inAction.ShakeScale, inAction.bDoControllerVibration, inAction.PlaySpace, inAction.LocationActor == None ? rot(0, 0, 0) : inAction.LocationActor.Rotation);
        }
    }
    else
    {
        ClientStopCameraShake(inAction.Shake);
    }
}
public function OnConsoleCommand(SeqAct_ConsoleCommand inAction)
{
    local string Command;
    
    foreach inAction.Commands(Command, )
    {
        if (!(Left(Command, 4) ~= "set ") && !(Left(Command, 9) ~= "setnopec "))
        {
            ConsoleCommand(Command);
        }
    }
}
public function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != None && LP.ControllerId == ControllerId && WorldInfo.IsConsoleBuild() && (WorldInfo.Game == None || !WorldInfo.Game.IsAutomatedPerfTesting()))
    {
        bIsControllerConnected = bIsConnected;
        SetPause(!bIsConnected, CanUnpauseControllerConnected);
    }
}
public function OnDestroyForInviteComplete(Name SessionName, bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        if (!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), SessionName))
        {
            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
            NotifyInviteFailed();
        }
    }
    else
    {
        NotifyInviteFailed();
    }
}
public function OnDrawText(SeqAct_DrawText inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ClientDrawKismetText(inAction.DrawTextInfo, inAction.DisplayTimeSeconds);
    }
    else
    {
        ClientClearKismetText(inAction.DrawTextInfo.MessageOffset);
    }
}
public function OnEndForInviteComplete(Name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
    OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
}
public function OnExternalUIChanged(bool bIsOpening)
{
    bIsExternalUIOpen = bIsOpening;
    SetPause(bIsOpening, CanUnpauseExternalUI);
}
public simulated function OnFlyThroughHasEnded(SeqAct_FlyThroughHasEnded inAction)
{
    local PlayerController PC;
    
    if (WorldInfo.Game.IsDoingASentinelRun())
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.ConsoleCommand("quit");
        }
    }
}
public function OnForceFeedback(SeqAct_ForceFeedback Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        ClientPlayForceFeedbackWaveform(Action.FFWaveform);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ClientStopForceFeedbackWaveform(Action.FFWaveform);
    }
}
public function OnInviteJoinComplete(Name SessionName, bool bWasSuccessful)
{
    local string URL;
    local string ConnectPassword;
    
    if (bWasSuccessful)
    {
        if (OnlineSub != None && OnlineSub.GameInterface != None)
        {
            if (OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
            {
                if (Class'UIRoot'.static.GetDataStoreStringValue("<Registry:ConnectPassword>", ConnectPassword) && ConnectPassword != "")
                {
                    URL $= "?Password=" $ ConnectPassword;
                }
                URL $= "?bIsFromInvite";
                ClientTravel(URL, 0);
            }
        }
    }
    else
    {
        NotifyInviteFailed();
    }
    ClearInviteDelegates();
    Class'UIRoot'.static.SetDataStoreStringValue("<Registry:ConnectPassword>", "");
}
public function OnJoinTravelToSessionComplete(Name SessionName, bool bWasSuccessful)
{
    local string URL;
    
    if (bWasSuccessful)
    {
        if (OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
        {
            ClientTravel(URL, 0);
        }
    }
}
public simulated function OnSetCameraTarget(SeqAct_SetCameraTarget inAction)
{
    local Actor RealCameraTarget;
    
    RealCameraTarget = inAction.CameraTarget;
    if (RealCameraTarget == None)
    {
        RealCameraTarget = Pawn != None ? Pawn : Self;
    }
    else if (RealCameraTarget.IsA('Controller'))
    {
        RealCameraTarget = Controller(RealCameraTarget).Pawn;
    }
    SetViewTarget(RealCameraTarget, inAction.TransitionParams);
}
public function OnSetSoundMode(SeqAct_SetSoundMode Action)
{
    local AudioDevice Audio;
    
    Audio = Class'Engine'.static.GetAudioDevice();
    if (Audio != None)
    {
        if (Action.InputLinks[0].bHasImpulse && Action.SoundMode != None)
        {
            Audio.SetSoundMode(Action.SoundMode.Name);
        }
        else
        {
            Audio.SetSoundMode('Default');
        }
    }
}
public function OnToggleCinematicMode(SeqAct_ToggleCinematicMode Action)
{
    local bool bNewCinematicMode;
    
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        bNewCinematicMode = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bNewCinematicMode = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bNewCinematicMode = !bCinematicMode;
    }
    SetCinematicMode(bNewCinematicMode, Action.bHidePlayer, Action.bHideHUD, Action.bDisableMovement, Action.bDisableTurning, Action.bDisableInput, Action);
}
public simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
    if (myHUD != None)
    {
        if (inAction.InputLinks[0].bHasImpulse)
        {
            myHUD.bShowHUD = TRUE;
        }
        else if (inAction.InputLinks[1].bHasImpulse)
        {
            myHUD.bShowHUD = FALSE;
        }
        else if (inAction.InputLinks[2].bHasImpulse)
        {
            myHUD.bShowHUD = !myHUD.bShowHUD;
        }
    }
}
public function OnToggleInput(SeqAct_ToggleInput inAction)
{
    local bool bNewValue;
    
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            IgnoreMoveInput(FALSE);
            ClientIgnoreMoveInput(FALSE);
        }
        if (inAction.bToggleTurning)
        {
            IgnoreLookInput(FALSE);
            ClientIgnoreLookInput(FALSE);
        }
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            IgnoreMoveInput(TRUE);
            ClientIgnoreMoveInput(TRUE);
        }
        if (inAction.bToggleTurning)
        {
            IgnoreLookInput(TRUE);
            ClientIgnoreLookInput(TRUE);
        }
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            bNewValue = !IsMoveInputIgnored();
            IgnoreMoveInput(bNewValue);
            ClientIgnoreMoveInput(bNewValue);
        }
        if (inAction.bToggleTurning)
        {
            bNewValue = !IsLookInputIgnored();
            IgnoreLookInput(bNewValue);
            ClientIgnoreLookInput(bNewValue);
        }
    }
}
public exec function PathChild(optional int Cnt)
{
    Pawn.IncrementPathChild(Max(1, Cnt), myHUD.Canvas);
}
public exec function PathClear()
{
    Pawn.ClearPathStep();
}
public exec function PathStep(optional int Cnt)
{
    Pawn.IncrementPathStep(Max(1, Cnt), myHUD.Canvas);
}
public function PauseRumbleForAllPlayers(optional bool bShouldPauseRumble = TRUE)
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        if (PC.ForceFeedbackManager != None)
        {
            PC.ForceFeedbackManager.PauseWaveform(bShouldPauseRumble);
        }
    }
}
public function PawnDied(Pawn P)
{
    if (P != Pawn)
    {
        return;
    }
    if (Pawn != None)
    {
        Pawn.RemoteRole = ENetRole.ROLE_SimulatedProxy;
    }
    Super.PawnDied(P);
}
public function bool PerformedUseAction()
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            SetPause(FALSE);
        }
        return TRUE;
    }
    if (Pawn == None || !Pawn.bCanUse)
    {
        return TRUE;
    }
    if (Role < ENetRole.ROLE_Authority)
    {
        return FALSE;
    }
    if (Vehicle(Pawn) != None)
    {
        return Vehicle(Pawn).DriverLeave(FALSE);
    }
    if (FindVehicleToDrive())
    {
        return TRUE;
    }
    return TriggerInteracted();
}
public function PlayBeepSound();

public function PostControllerIdChange()
{
    local LocalPlayer LP;
    local UniqueNetId PlayerID;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        if (WorldInfo.NetMode != ENetMode.NM_Client && OnlineSub != None && OnlineSub.PlayerInterface != None)
        {
            OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LP.ControllerId), PlayerID);
            PlayerReplicationInfo.SetUniqueId(PlayerID);
        }
        RegisterPlayerDataStores();
        RegisterOnlineDelegates();
        ClientSetOnlineStatus();
        if (!WorldInfo.Game.bRequiresPushToTalk)
        {
            ClientStartNetworkedVoice();
        }
    }
}
public function PreControllerIdChange()
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        ClientStopNetworkedVoice();
        ClearOnlineDelegates();
        UnregisterPlayerDataStores();
    }
}
public exec function PrevWeapon()
{
    if (WorldInfo.Pauser != None)
    {
        return;
    }
    if (Pawn.Weapon == None)
    {
        SwitchToBestWeapon();
        return;
    }
    if (Pawn.InvManager != None)
    {
        Pawn.InvManager.PrevWeapon();
    }
}
public function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
    ClientGotoState(GetStateName(), 'Begin');
}
public function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
    }
    if (Pawn != None)
    {
        Pawn.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
    }
    else
    {
        out_ViewRotation += DeltaRot;
        out_ViewRotation = LimitViewRotation(out_ViewRotation, -16384.0, 16383.0);
    }
}
public exec function QuickLoad()
{
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ConsoleCommand("DEFER LOADGAME QUICKSAVE.SAV");
    }
}
public exec function QuickSave()
{
    if (Pawn != None && Pawn.Health > 0 && WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ClientMessage(QuickSaveString);
        ConsoleCommand("DEFER SAVEGAME QUICKSAVE.SAV");
    }
}
protected simulated function RegisterCustomPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local Class<UIDataStore_OnlinePlayerData> PlayerDataStoreClass;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != None)
        {
            CurrentPlayerData = PlayerOwnerDataStore(DataStoreManager.FindDataStore('PlayerOwner', LP));
            if (CurrentPlayerData == None)
            {
                CurrentPlayerData = DataStoreManager.CreateDataStore(PlayerOwnerDataStoreClass);
                if (CurrentPlayerData != None)
                {
                    if (DataStoreManager.RegisterDataStore(CurrentPlayerData, LP))
                    {
                        if (PlayerReplicationInfo != None)
                        {
                            PlayerReplicationInfo.BindPlayerOwnerDataProvider();
                        }
                    }
                }
            }
            OnlinePlayerData = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
            if (OnlinePlayerData == None)
            {
                PlayerDataStoreClass = Class<UIDataStore_OnlinePlayerData>(DataStoreManager.FindDataStoreClass(Class'UIDataStore_OnlinePlayerData'));
                if (PlayerDataStoreClass != None)
                {
                    OnlinePlayerData = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
                    if (OnlinePlayerData != None)
                    {
                        if (!DataStoreManager.RegisterDataStore(OnlinePlayerData, LP))
                        {
                        }
                    }
                }
            }
        }
    }
}
public function RegisterOnlineDelegates()
{
    if (OnlineSub != None)
    {
        VoiceInterface = OnlineSub.VoiceInterface;
        if (OnlineSub.SystemInterface != None && LocalPlayer(Player) != None)
        {
            OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnExternalUIChanged);
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChanged);
        }
        if (OnlineSub.GameInterface != None && LocalPlayer(Player) != None)
        {
            OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(byte(LocalPlayer(Player).ControllerId), OnGameInviteAccepted);
        }
    }
}
public final simulated function RegisterPlayerDataStores()
{
    RegisterCustomPlayerDataStores();
    RegisterStandardPlayerDataStores();
}
protected simulated function RegisterStandardPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local array<Class<UIDataStore>> PlayerDataStoreClasses;
    local Class<UIDataStore> PlayerDataStoreClass;
    local UIDataStore PlayerDataStore;
    local int ClassIndex;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != None)
        {
            DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
            for (ClassIndex = 0; ClassIndex < PlayerDataStoreClasses.Length; ClassIndex++)
            {
                PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
                if (PlayerDataStoreClass != None)
                {
                    PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.Tag, LP);
                    if (PlayerDataStore == None)
                    {
                        PlayerDataStore = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
                        if (PlayerDataStore != None)
                        {
                            if (!DataStoreManager.RegisterDataStore(PlayerDataStore, LP))
                            {
                            }
                        }
                        continue;
                    }
                }
            }
        }
    }
}
public simulated function ReloadProfileSettings()
{
    if (OnlinePlayerData != None && OnlinePlayerData.ProfileProvider != None)
    {
        OnlinePlayerData.ProfileProvider.RefreshStorageData();
    }
}
public function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    local SavedMove NewMove;
    local SavedMove OldMove;
    local SavedMove AlmostLastMove;
    local SavedMove LastMove;
    local byte ClientRoll;
    local float NetMoveDelta;
    
    if (Player == None)
    {
        return;
    }
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    DeltaTime = (Pawn != None ? Pawn.CustomTimeDilation : CustomTimeDilation) * FMin(DeltaTime, MaxResponseTime);
    if (SavedMoves != None)
    {
        LastMove = SavedMoves;
        AlmostLastMove = LastMove;
        OldMove = None;
        while (LastMove.NextMove != None)
        {
            if (OldMove == None && Pawn != None && LastMove.IsImportantMove(LastAckedAccel))
            {
                OldMove = LastMove;
            }
            AlmostLastMove = LastMove;
            LastMove = LastMove.NextMove;
        }
    }
    NewMove = GetFreeMove();
    if (NewMove == None)
    {
        return;
    }
    NewMove.SetMoveFor(Self, DeltaTime, newAccel, DoubleClickMove);
    bDoubleJump = FALSE;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    if (PendingMove != None && PendingMove.CanCombineWith(NewMove, Pawn, MaxResponseTime))
    {
        Pawn.SetLocation(PendingMove.GetStartLocation(), );
        Pawn.Velocity = PendingMove.StartVelocity;
        if (PendingMove.StartBase != Pawn.Base)
        {
            Pawn.SetBase(PendingMove.StartBase, , , );
        }
        Pawn.Floor = PendingMove.StartFloor;
        NewMove.Delta += PendingMove.Delta;
        NewMove.SetInitialPosition(Pawn);
        if (LastMove == PendingMove)
        {
            if (SavedMoves == PendingMove)
            {
                SavedMoves.NextMove = FreeMoves;
                FreeMoves = SavedMoves;
                SavedMoves = None;
            }
            else
            {
                PendingMove.NextMove = FreeMoves;
                FreeMoves = PendingMove;
                if (AlmostLastMove != None)
                {
                    AlmostLastMove.NextMove = None;
                    LastMove = AlmostLastMove;
                }
            }
            FreeMoves.Clear();
        }
        PendingMove = None;
    }
    if (Pawn != None)
    {
        Pawn.AutonomousPhysics(NewMove.Delta);
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    NewMove.PostUpdate(Self);
    if (SavedMoves == None)
    {
        SavedMoves = NewMove;
    }
    else
    {
        LastMove.NextMove = NewMove;
    }
    if (PendingMove == None)
    {
        if (Player.CurrentNetSpeed > 10000 && WorldInfo.GRI != None && WorldInfo.GRI.PRIArray.Length <= 10)
        {
            NetMoveDelta = 0.0109999999;
        }
        else
        {
            NetMoveDelta = FMax(0.0221999995, 2.0 * WorldInfo.MoveRepSize / float(Player.CurrentNetSpeed));
        }
        if ((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation < NetMoveDelta)
        {
            PendingMove = NewMove;
            return;
        }
    }
    ClientUpdateTime = WorldInfo.TimeSeconds;
    ClientRoll = byte(Rotation.Roll >> 8 & 255);
    CallServerMove(NewMove, Pawn == None ? location : Pawn.location, ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535), OldMove);
    PendingMove = None;
}
public function ResetFOV()
{
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
}
public function ResetPlayerMovementInput()
{
    bIgnoreMoveInput = default.bIgnoreMoveInput;
    bIgnoreLookInput = default.bIgnoreLookInput;
}
public function Restart(bool bVehicleTransition)
{
    Super.Restart(bVehicleTransition);
    ServerTimeStamp = 0.0;
    ResetTimeMargin();
    EnterStartState();
    ClientRestart(Pawn);
    SetViewTarget(Pawn);
    ResetCameraMode();
}
public exec function RestartLevel()
{
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ClientTravel("?restart", 2);
    }
}
public exec function SaveActorConfig(coerce Name actorName)
{
    local Actor ChkActor;
    
    foreach AllActors(Class'Actor', ChkActor, )
    {
        if (ChkActor != None && ChkActor.Name == actorName)
        {
            ChkActor.SaveConfig();
        }
    }
}
public exec function SaveClassConfig(coerce string className)
{
    local Class<Object> saveClass;
    
    saveClass = Class<Object>(DynamicLoadObject(className, Class'Class'));
    if (saveClass != None)
    {
        saveClass.static.StaticSaveConfig();
    }
}
public function SeamlessTravelFrom(PlayerController OldPC)
{
    OldPC.PlayerReplicationInfo.Reset();
    OldPC.PlayerReplicationInfo.SeamlessTravelTo(PlayerReplicationInfo);
    OldPC.bIsPlayer = FALSE;
    OldPC.PlayerReplicationInfo.Destroy();
    OldPC.PlayerReplicationInfo = None;
}
public function SeamlessTravelTo(PlayerController NewPC);

public exec function SendToConsole(string Command);

public function Sentinel_PostAcquireTravelTheWorldPoints();

public function Sentinel_PreAcquireTravelTheWorldPoints();

public function Sentinel_SetupForGamebasedTravelTheWorld();

public reliable server function ServerAcknowledgePossession(Pawn P)
{
    if (P != None && P == Pawn && P != AcknowledgedPawn)
    {
        ResetTimeMargin();
    }
    AcknowledgedPawn = P;
}
public reliable server function ServerCamera(Name NewMode)
{
    if (NewMode == '1st')
    {
        NewMode = 'FirstPerson';
    }
    else if (NewMode == '3rd')
    {
        NewMode = 'ThirdPerson';
    }
    SetCameraMode(NewMode);
}
public unreliable server function ServerCauseEvent(Name EventName)
{
    local array<SequenceObject> AllConsoleEvents;
    local SeqEvent_Console ConsoleEvt;
    local Sequence GameSeq;
    local int idx;
    local bool bFoundEvt;
    
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != None && EventName != 'None')
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_Console', TRUE, AllConsoleEvents);
        for (idx = 0; idx < AllConsoleEvents.Length; idx++)
        {
            ConsoleEvt = SeqEvent_Console(AllConsoleEvents[idx]);
            if (ConsoleEvt != None && EventName == ConsoleEvt.ConsoleEventName)
            {
                bFoundEvt = TRUE;
                ConsoleEvt.CheckActivate(Self, Pawn);
            }
        }
    }
    if (!bFoundEvt)
    {
    }
}
public reliable server function ServerChangeName(coerce string S)
{
    if (S != "")
    {
        WorldInfo.Game.ChangeName(Self, S, TRUE);
    }
}
public reliable server function ServerChangeTeam(int N)
{
    local TeamInfo OldTeam;
    
    OldTeam = PlayerReplicationInfo.Team;
    WorldInfo.Game.ChangeTeam(Self, N, TRUE);
    if (WorldInfo.Game.bTeamGame && PlayerReplicationInfo.Team != OldTeam)
    {
        if (Pawn != None)
        {
            Pawn.PlayerChangedTeam();
        }
    }
}
public unreliable server function ServerDrive(float InForward, float InStrafe, float aUp, bool InJump, int View)
{
    local Rotator ViewRotation;
    
    ViewRotation.Pitch = View & 65535;
    ViewRotation.Yaw = View >> 16;
    ViewRotation.Roll = 0;
    SetRotation(ViewRotation);
    ProcessDrive(InForward, InStrafe, aUp, InJump);
}
public function ServerGivePawn()
{
    GivePawn(Pawn);
}
public unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
    local float DeltaTime;
    local float clientErr;
    local Rotator DeltaRot;
    local Rotator Rot;
    local Rotator ViewRot;
    local Vector Accel;
    local Vector LocDiff;
    local int maxPitch;
    local int ViewPitch;
    local int ViewYaw;
    
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (AcknowledgedPawn != Pawn)
    {
        InAccel = vect(0.0, 0.0, 0.0);
        GivePawn(Pawn);
    }
    ViewPitch = View & 65535;
    ViewYaw = View >> 16;
    Accel = InAccel * 0.100000001;
    DeltaTime = FMin(MaxResponseTime, TimeStamp - CurrentTimeStamp);
    if (Pawn == None)
    {
        bWasSpeedHack = FALSE;
        ResetTimeMargin();
    }
    else if (!CheckSpeedHack(DeltaTime))
    {
        if (!bWasSpeedHack)
        {
            if (WorldInfo.TimeSeconds - LastSpeedHackLog > float(20))
            {
                LastSpeedHackLog = WorldInfo.TimeSeconds;
            }
            ClientMessage("Speed Hack Detected!", 'CriticalEvent');
        }
        else
        {
            bWasSpeedHack = TRUE;
        }
        DeltaTime = 0.0;
        Pawn.Velocity = vect(0.0, 0.0, 0.0);
    }
    else
    {
        DeltaTime *= Pawn.CustomTimeDilation;
        bWasSpeedHack = FALSE;
    }
    CurrentTimeStamp = TimeStamp;
    ServerTimeStamp = WorldInfo.TimeSeconds;
    ViewRot.Pitch = ViewPitch;
    ViewRot.Yaw = ViewYaw;
    ViewRot.Roll = 0;
    if (InAccel != vect(0.0, 0.0, 0.0))
    {
        LastActiveTime = WorldInfo.TimeSeconds;
    }
    SetRotation(ViewRot);
    if (AcknowledgedPawn != Pawn)
    {
        return;
    }
    if (Pawn != None)
    {
        Rot.Roll = 256 * int(ClientRoll);
        Rot.Yaw = ViewYaw;
        if (Pawn.Physics == EPhysics.PHYS_Swimming || Pawn.Physics == EPhysics.PHYS_Flying)
        {
            maxPitch = 2;
        }
        else
        {
            maxPitch = 0;
        }
        if (ViewPitch > maxPitch * Pawn.MaxPitchLimit && ViewPitch < 65536 - maxPitch * Pawn.MaxPitchLimit)
        {
            if (ViewPitch < 32768)
            {
                Rot.Pitch = maxPitch * Pawn.MaxPitchLimit;
            }
            else
            {
                Rot.Pitch = 65536 - maxPitch * Pawn.MaxPitchLimit;
            }
        }
        else
        {
            Rot.Pitch = ViewPitch;
        }
        DeltaRot = Rotation - Rot;
        Pawn.FaceRotation(Rot, DeltaTime);
    }
    if (WorldInfo.Pauser == None && DeltaTime > float(0))
    {
        MoveAutonomous(DeltaTime, MoveFlags, Accel, DeltaRot);
    }
    if (ClientLoc == vect(1.0, 2.0, 3.0))
    {
        return;
    }
    else if (WorldInfo.TimeSeconds - LastUpdateTime < 180.0 / float(Player.CurrentNetSpeed))
    {
        return;
    }
    if (Pawn == None)
    {
        LocDiff = location - ClientLoc;
    }
    else if (Pawn.bForceRMVelocity)
    {
        LocDiff = vect(0.0, 0.0, 0.0);
    }
    else if (Pawn.Physics != EPhysics.PHYS_None && WorldInfo.TimeSeconds - LastUpdateTime > 1.0 && IsZero(InAccel))
    {
        LocDiff = vect(1000.0, 1000.0, 1000.0);
    }
    else
    {
        LocDiff = Pawn.location - ClientLoc;
    }
    clientErr = LocDiff Dot LocDiff;
    if (clientErr > 3.0)
    {
        if (Pawn == None)
        {
            PendingAdjustment.newPhysics = Physics;
            PendingAdjustment.NewLoc = location;
            PendingAdjustment.NewVel = Velocity;
        }
        else
        {
            PendingAdjustment.newPhysics = Pawn.Physics;
            PendingAdjustment.NewVel = Pawn.Velocity;
            PendingAdjustment.NewBase = Pawn.Base;
            if (InterpActor(Pawn.Base) != None || Vehicle(Pawn.Base) != None)
            {
                PendingAdjustment.NewLoc = Pawn.location - Pawn.Base.location;
            }
            else
            {
                PendingAdjustment.NewLoc = Pawn.location;
            }
            PendingAdjustment.NewFloor = Pawn.Floor;
        }
        LastUpdateTime = WorldInfo.TimeSeconds;
        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.bAckGoodMove = 0;
    }
    else
    {
        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.bAckGoodMove = 1;
    }
}
public reliable server function ServerMutate(string MutateString)
{
    if (WorldInfo.NetMode == ENetMode.NM_Client)
    {
        return;
    }
    WorldInfo.Game.Mutate(MutateString, Self);
}
public reliable server function ServerPause()
{
    if (!IsPaused())
    {
        SetPause(TRUE);
    }
    else
    {
        SetPause(FALSE);
    }
}
public reliable server function ServerRegisterClientStatGuid(string StatGuid)
{
    if (OnlineSub != None && OnlineSub.StatsInterface != None)
    {
        OnlineSub.StatsInterface.RegisterStatGuid(PlayerReplicationInfo.UniqueId, StatGuid);
    }
}
public reliable server function ServerRegisteredForArbitration(bool bWasSuccessful)
{
    WorldInfo.Game.ProcessClientRegistrationCompletion(Self, bWasSuccessful);
}
public reliable server function ServerRestartGame();

public unreliable server function ServerSay(string Msg)
{
    local PlayerController PC;
    
    if (PlayerReplicationInfo.bAdmin && Left(Msg, 1) == "#")
    {
        Msg = Right(Msg, Len(Msg) - 1);
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.ClientAdminMessage(Msg);
        }
        return;
    }
    WorldInfo.Game.Broadcast(Self, Msg, 'Say');
}
public reliable server function ServerSetNetSpeed(int NewSpeed)
{
    if (WorldInfo.Game != None && WorldInfo.NetMode == ENetMode.NM_ListenServer)
    {
        NewSpeed = Min(NewSpeed, WorldInfo.Game.AdjustedNetSpeed);
    }
    SetNetSpeed(NewSpeed);
}
public unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
{
    if (WorldInfo.TimeSeconds != LastSpectatorStateSynchTime)
    {
        ClientGotoState(GetStateName());
        LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
    }
}
public reliable server function ServerShortTimeout()
{
    local Actor A;
    
    if (!bShortConnectTimeOut)
    {
        bShortConnectTimeOut = TRUE;
        ResetTimeMargin();
        if (WorldInfo.Pauser != None)
        {
            foreach AllActors(Class'Actor', A, )
            {
                if (!A.bOnlyRelevantToOwner)
                {
                    A.bForceNetUpdate = TRUE;
                }
            }
        }
        else if (WorldInfo.Game.NumPlayers < 8)
        {
            foreach AllActors(Class'Actor', A, )
            {
                if (A.NetUpdateFrequency < float(1) && !A.bOnlyRelevantToOwner)
                {
                    A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + 0.200000003 * FRand()));
                }
            }
        }
        else
        {
            foreach AllActors(Class'Actor', A, )
            {
                if (A.NetUpdateFrequency < float(1) && !A.bOnlyRelevantToOwner)
                {
                    A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + 0.5 * FRand()));
                }
            }
        }
    }
}
public reliable server function ServerSpeech(Name Type, int Index, string Callsign);

public reliable server function ServerSuicide()
{
    if (Pawn != None && (WorldInfo.TimeSeconds - Pawn.LastStartTime > float(10) || WorldInfo.NetMode == ENetMode.NM_Standalone))
    {
        Pawn.Suicide();
    }
}
public unreliable server function ServerTeamSay(string Msg)
{
    LastActiveTime = WorldInfo.TimeSeconds;
    if (!WorldInfo.GRI.GameClass.default.bTeamGame)
    {
        Say(Msg);
        return;
    }
    WorldInfo.Game.BroadcastTeam(Self, Msg, 'TeamSay');
}
public reliable server function ServerThrowWeapon()
{
    if (Pawn.CanThrowWeapon())
    {
        Pawn.ThrowActiveWeapon();
    }
}
public unreliable server function ServerUpdatePing(int NewPing)
{
    PlayerReplicationInfo.Ping = byte(Min(int(0.25 * float(NewPing)), 250));
}
public unreliable server function ServerUse()
{
    PerformedUseAction();
}
public reliable server function ServerUTrace()
{
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && (PlayerReplicationInfo == None || !PlayerReplicationInfo.bAdmin))
    {
        return;
    }
    UTrace();
}
public reliable server function ServerVerifyViewTarget()
{
    local Actor TheViewTarget;
    
    TheViewTarget = GetViewTarget();
    if (TheViewTarget == Self)
    {
        return;
    }
    ClientSetViewTarget(TheViewTarget);
}
public unreliable server function ServerViewNextPlayer()
{
    if (IsSpectating())
    {
        ViewAPlayer(1);
    }
}
public unreliable server function ServerViewPrevPlayer()
{
    if (IsSpectating())
    {
        ViewAPlayer(-1);
    }
}
public unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParams)
{
    if (IsSpectating())
    {
        ResetCameraMode();
        SetViewTarget(Self, TransitionParams);
        ClientSetViewTarget(Self, TransitionParams);
        ClientMessage(OwnCamera, 'Event');
    }
}
public function SetCameraMode(Name NewCamMode)
{
    if (PlayerCamera != None)
    {
        PlayerCamera.CameraStyle = NewCamMode;
        if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
        {
            ClientSetCameraMode(NewCamMode);
        }
    }
}
public function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, optional SeqAct_ToggleCinematicMode SFXAction)
{
    local bool bAdjustMoveInput;
    local bool bAdjustLookInput;
    
    bCinematicMode = bInCinematicMode;
    if (bCinematicMode)
    {
        if (Pawn != None && bHidePlayer)
        {
            Pawn.SetHidden(TRUE);
        }
    }
    else if (Pawn != None)
    {
        Pawn.SetHidden(FALSE);
    }
    bAdjustMoveInput = bAffectsMovement && bCinematicMode != bCinemaDisableInputMove;
    bAdjustLookInput = bAffectsTurning && bCinematicMode != bCinemaDisableInputLook;
    if (bAdjustMoveInput)
    {
        IgnoreMoveInput(bCinematicMode);
        bCinemaDisableInputMove = bCinematicMode;
    }
    if (bAdjustLookInput)
    {
        IgnoreLookInput(bCinematicMode);
        bCinemaDisableInputLook = bCinematicMode;
    }
    ClientSetCinematicMode(bCinematicMode, bAdjustMoveInput, bAdjustLookInput, bAffectsHUD);
}
public function SetFOV(float NewFOV)
{
    DesiredFOV = NewFOV;
    FOVAngle = NewFOV;
}
public function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local bool bResult;
    
    if (WorldInfo.NetMode != ENetMode.NM_Client)
    {
        if (bPause)
        {
            bFire = 0;
            bResult = WorldInfo.Game.SetPause(Self, CanUnpauseDelegate);
            if (bResult)
            {
                PauseRumbleForAllPlayers();
            }
        }
        else
        {
            WorldInfo.Game.ClearPause();
            if (WorldInfo.Pauser == None)
            {
                PauseRumbleForAllPlayers(FALSE);
            }
        }
    }
    return bResult;
}
public simulated function SetPlayerDataProvider(PlayerDataProvider DataProvider)
{
    if (CurrentPlayerData == None)
    {
        RegisterPlayerDataStores();
    }
    if (CurrentPlayerData != None)
    {
        if (DataProvider != None)
        {
            CurrentPlayerData.SetPlayerDataProvider(DataProvider);
        }
    }
}
public final function SetRumbleScale(float ScaleBy)
{
    if (ForceFeedbackManager != None)
    {
        ForceFeedbackManager.ScaleAllWaveformsBy = ScaleBy;
    }
}
public final function SetViewTargetWithBlend(Actor NewViewTarget, optional float BlendTime = 0.349999994, optional EViewTargetBlendFunction BlendFunc = 1, optional float BlendExp = 2.0)
{
    local ViewTargetTransitionParams TransitionParams;
    
    TransitionParams.BlendTime = BlendTime;
    TransitionParams.BlendFunction = BlendFunc;
    TransitionParams.BlendExp = BlendExp;
    SetViewTarget(NewViewTarget, TransitionParams);
}
public unreliable client function ShortClientAdjustPosition(float TimeStamp, Name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != None)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0, 0.0, 0.0, NewBase, Floor.X, Floor.Y, Floor.Z);
}
public exec function ShowGameState()
{
    if (WorldInfo.Game != None)
    {
        WorldInfo.Game.DumpStateStack();
    }
}
public exec function ShowMenu();

public exec function ShowPlayerState()
{
    DumpStateStack();
}
public function CoverReplicator SpawnCoverReplicator()
{
    if (MyCoverReplicator == None && Role == ENetRole.ROLE_Authority && LocalPlayer(Player) == None)
    {
        MyCoverReplicator = Spawn(Class'CoverReplicator', Self);
        MyCoverReplicator.ReplicateInitialCoverInfo();
    }
    return MyCoverReplicator;
}
public function SpawnDefaultHUD()
{
    if (LocalPlayer(Player) == None)
    {
        return;
    }
    myHUD = Spawn(Class'HUD', Self);
}
public simulated function SpeakTTS(coerce string S, optional PlayerReplicationInfo PRI)
{
    local SoundCue Cue;
    local AudioComponent AC;
    
    Cue = CreateTTSSoundCue(S, PRI);
    if (Cue != None)
    {
        AC = CreateAudioComponent(Cue, FALSE, TRUE, , , TRUE);
        AC.bAllowSpatialization = FALSE;
        AC.bAutoDestroy = TRUE;
        AC.Play();
    }
}
public exec function Speech(Name Type, int Index, string Callsign)
{
    ServerSpeech(Type, Index, Callsign);
}
public exec function StartAltFire(optional byte FireModeNum)
{
    StartFire(1);
}
public exec function StartFire(optional byte FireModeNum)
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        SetPause(FALSE);
        return;
    }
    if (Pawn != None && !bCinematicMode)
    {
        Pawn.StartFire(FireModeNum);
    }
}
public exec function StopAltFire(optional byte FireModeNum)
{
    StopFire(1);
}
public exec function StopFire(optional byte FireModeNum)
{
    if (Pawn != None)
    {
        Pawn.StopFire(FireModeNum);
    }
}
public exec function Suicide()
{
    ServerSuicide();
}
public exec function SwitchLevel(string URL)
{
    if (WorldInfo.NetMode == ENetMode.NM_Standalone || WorldInfo.NetMode == ENetMode.NM_ListenServer)
    {
        WorldInfo.ServerTravel(URL);
    }
}
public exec function SwitchTeam()
{
    if (PlayerReplicationInfo.Team == None || PlayerReplicationInfo.Team.TeamIndex == 1)
    {
        ServerChangeTeam(0);
    }
    else
    {
        ServerChangeTeam(1);
    }
}
public exec function Talk()
{
    local Console PlayerConsole;
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != None && CanCommunicate() && LP.ViewportClient.ViewportConsole != None)
    {
        PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
        PlayerConsole.StartTyping("Say ");
    }
}
public exec function TeamSay(string Msg)
{
    Msg = Left(Msg, 128);
    if (AllowTextMessage(Msg))
    {
        ServerTeamSay(Msg);
    }
}
public exec function TeamTalk()
{
    local Console PlayerConsole;
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != None && CanCommunicate() && LP.ViewportClient.ViewportConsole != None)
    {
        PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
        PlayerConsole.StartTyping("TeamSay ");
    }
}
public exec function ThrowWeapon()
{
    if (Pawn == None || Pawn.Weapon == None)
    {
        return;
    }
    ServerThrowWeapon();
}
public function bool TriggerInteracted()
{
    local Actor A;
    local int idx;
    local float Weight;
    local bool bInserted;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local array<Trigger> useList;
    local array<Actor> sortedList;
    local array<float> weightList;
    
    if (Pawn != None)
    {
        GetTriggerUseList(InteractDistance, 60.0, 0.0, TRUE, useList);
        if (useList.Length > 0)
        {
            GetPlayerViewPoint(cameraLoc, cameraRot);
            while (useList.Length > 0)
            {
                A = useList[useList.Length - 1];
                useList.Length = useList.Length - 1;
                Weight = Normal(A.location - cameraLoc) Dot Vector(cameraRot);
                Weight += 1.0 - VSize(A.location - Pawn.location) / InteractDistance;
                bInserted = FALSE;
                for (idx = 0; idx < sortedList.Length && !bInserted; idx++)
                {
                    if (weightList[idx] < Weight)
                    {
                        sortedList.Insert(idx, 1);
                        weightList.Insert(idx, 1);
                        sortedList[idx] = A;
                        weightList[idx] = Weight;
                        bInserted = TRUE;
                    }
                }
                if (!bInserted)
                {
                    idx = sortedList.Length;
                    sortedList[idx] = A;
                    weightList[idx] = Weight;
                }
            }
            for (idx = 0; idx < sortedList.Length; idx++)
            {
                if (sortedList[idx].UsedBy(Pawn))
                {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_OnlinePlayerData OnlinePlayerDataStore;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != None)
        {
            if (CurrentPlayerData != None)
            {
                if (!DataStoreManager.UnregisterDataStore(CurrentPlayerData))
                {
                }
                CurrentPlayerData = None;
            }
            OnlinePlayerData = None;
            OnlinePlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
            if (OnlinePlayerDataStore != None)
            {
                if (!DataStoreManager.UnregisterDataStore(OnlinePlayerDataStore))
                {
                }
            }
            UnregisterStandardPlayerDataStores();
        }
    }
}
public simulated function UnregisterStandardPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local array<Class<UIDataStore>> PlayerDataStoreClasses;
    local Class<UIDataStore> PlayerDataStoreClass;
    local UIDataStore PlayerDataStore;
    local int ClassIndex;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != None)
        {
            DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
            for (ClassIndex = 0; ClassIndex < PlayerDataStoreClasses.Length; ClassIndex++)
            {
                PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
                if (PlayerDataStoreClass != None)
                {
                    PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.Tag, LP);
                    if (PlayerDataStore != None)
                    {
                        if (!DataStoreManager.UnregisterDataStore(PlayerDataStore))
                        {
                        }
                    }
                }
            }
        }
    }
}
public function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot;
    local Rotator NewRotation;
    local Rotator ViewRotation;
    
    ViewRotation = Rotation;
    if (Pawn != None)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;
    if (Pawn != None)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
}
public function UpdateStateFromAdjustment(Name NewState)
{
    if (GetStateName() != NewState)
    {
        GotoState(NewState, , , );
    }
}
public exec function Use()
{
    if (Role < ENetRole.ROLE_Authority)
    {
        PerformedUseAction();
    }
    ServerUse();
}
public function bool UsingFirstPersonCamera()
{
    return (PlayerCamera == None || PlayerCamera.CameraStyle == 'FirstPerson') && LocalPlayer(Player) != None;
}
public unreliable client function VeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != None)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, 'PlayerWalking', 1, NewLocX, NewLocY, NewLocZ, 0.0, 0.0, 0.0, NewBase, Floor.X, Floor.Y, Floor.Z);
}
public function ViewAPlayer(int Dir)
{
    local int i;
    local int CurrentIndex;
    local int NewIndex;
    local PlayerReplicationInfo PRI;
    local bool bSuccess;
    
    CurrentIndex = -1;
    if (RealViewTarget != None)
    {
        for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
        {
            if (RealViewTarget == WorldInfo.GRI.PRIArray[i])
            {
                CurrentIndex = i;
                break;
            }
        }
    }
    NewIndex = CurrentIndex + Dir;
    while (NewIndex >= 0 && NewIndex < WorldInfo.GRI.PRIArray.Length)
    {
        PRI = WorldInfo.GRI.PRIArray[NewIndex];
        if (PRI != None && Controller(PRI.Owner) != None && Controller(PRI.Owner).Pawn != None && WorldInfo.Game.CanSpectate(Self, PRI))
        {
            bSuccess = TRUE;
            break;
        }
        NewIndex = NewIndex + Dir;
    }
    if (!bSuccess)
    {
        CurrentIndex = NewIndex < 0 ? WorldInfo.GRI.PRIArray.Length : -1;
        NewIndex = CurrentIndex + Dir;
        while (NewIndex >= 0 && NewIndex < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = WorldInfo.GRI.PRIArray[NewIndex];
            if (PRI != None && Controller(PRI.Owner) != None && Controller(PRI.Owner).Pawn != None && WorldInfo.Game.CanSpectate(Self, PRI))
            {
                bSuccess = TRUE;
                break;
            }
            NewIndex = NewIndex + Dir;
        }
    }
    if (bSuccess)
    {
        SetViewTarget(PRI);
    }
}
public function ViewShake(float DeltaTime);


state Dead 
{
    ignores SeePlayer, HearNoise
    ;
    public event function EndState(Name NextStateName)
    {
        CleanOutSavedMoves();
        Velocity = vect(0.0, 0.0, 0.0);
        Acceleration = vect(0.0, 0.0, 0.0);
        if (!PlayerReplicationInfo.bOutOfLives)
        {
            ResetCameraMode();
        }
        bPressedJump = FALSE;
        if (myHUD != None)
        {
            myHUD.SetShowScores(FALSE);
        }
    }
    public event function BeginState(Name PreviousStateName)
    {
        if (Pawn != None && Pawn.Controller == Self)
        {
            Pawn.Controller = None;
        }
        Pawn = None;
        FOVAngle = DesiredFOV;
        Enemy = None;
        bFrozen = TRUE;
        bPressedJump = FALSE;
        FindGoodView();
        SetTimer(MinRespawnDelay, FALSE, , );
        CleanOutSavedMoves();
    }
    public event function Timer()
    {
        if (!bFrozen)
        {
            return;
        }
        bFrozen = FALSE;
        bPressedJump = FALSE;
    }
    public function FindGoodView()
    {
        local Vector cameraLoc;
        local Rotator cameraRot;
        local Rotator ViewRotation;
        local int tries;
        local int besttry;
        local float bestDist;
        local float newdist;
        local int startYaw;
        local Actor TheViewTarget;
        
        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestDist = 0.0;
        startYaw = ViewRotation.Yaw;
        TheViewTarget = GetViewTarget();
        for (tries = 0; tries < 16; tries++)
        {
            cameraLoc = TheViewTarget.location;
            SetRotation(ViewRotation);
            GetPlayerViewPoint(cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - TheViewTarget.location);
            if (newdist > bestDist)
            {
                bestDist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
        }
        ViewRotation.Yaw = startYaw + besttry * 4096;
        SetRotation(ViewRotation);
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Rotator DeltaRot;
        local Rotator ViewRotation;
        
        if (!bFrozen)
        {
            if (bPressedJump)
            {
                StartFire(0);
                bPressedJump = FALSE;
            }
            GetAxes(Rotation, X, Y, Z);
            ViewRotation = Rotation;
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
            ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
            SetRotation(ViewRotation);
            if (Role < ENetRole.ROLE_Authority)
            {
                ReplicateMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
            }
        }
        else if (!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
        {
            bFrozen = FALSE;
        }
        ViewShake(DeltaTime);
    }
    public unreliable server function ServerMove(float TimeStamp, Vector Accel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
    {
        Global.ServerMove(TimeStamp, Accel, ClientLoc, 0, ClientRoll, View);
    }
    public exec function Jump()
    {
        StartFire(0);
    }
    public exec function Use()
    {
        StartFire(0);
    }
    public exec function StartFire(optional byte FireModeNum)
    {
        if (bFrozen)
        {
            if (!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
            {
                bFrozen = FALSE;
            }
            return;
        }
        ServerRestartPlayer();
    }
    public reliable server function ServerRestartPlayer()
    {
        if (!WorldInfo.Game.PlayerCanRestart(Self))
        {
            return;
        }
        Super.ServerRestartPlayer();
    }
    public function bool IsDead()
    {
        return TRUE;
    }
    public exec function ThrowWeapon();
    
    public exec function PrevWeapon();
    
    public exec function NextWeapon();
    
    public function KilledBy(Pawn EventInstigator);
    
    
Begin:
    if (LocalPlayer(Player) != None)
    {
        if (myHUD != None)
        {
            myHUD.PlayerOwnerDied();
        }
    }
    stop;
};
state RoundEnded 
{
    ignores HitWall, Falling, SeePlayer, HearNoise, NotifyBump, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange
    ;
    public event function EndState(Name NextStateName)
    {
        if (myHUD != None)
        {
            myHUD.SetShowScores(FALSE);
        }
    }
    public event function BeginState(Name PreviousStateName)
    {
        local Pawn P;
        
        FOVAngle = DesiredFOV;
        bFire = 0;
        if (Pawn != None)
        {
            Pawn.TurnOff();
            Pawn.bSpecialHUD = FALSE;
            StopFiring();
        }
        if (myHUD != None)
        {
            myHUD.SetShowScores(TRUE);
        }
        bFrozen = TRUE;
        FindGoodView();
        SetTimer(5.0, FALSE, , );
        foreach DynamicActors(Class'Pawn', P, )
        {
            P.TurnOff();
        }
    }
    public unreliable client function LongClientAdjustPosition(float TimeStamp, Name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ);
    
    public event function Timer()
    {
        bFrozen = FALSE;
    }
    public function FindGoodView()
    {
        local Rotator GoodRotation;
        
        GoodRotation = Rotation;
        GetViewTarget().FindGoodEndView(Self, GoodRotation);
        SetRotation(GoodRotation);
    }
    public unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
    {
        Global.ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Rotator DeltaRot;
        local Rotator ViewRotation;
        
        GetAxes(Rotation, X, Y, Z);
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        if (Role < ENetRole.ROLE_Authority)
        {
            ReplicateMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
        }
        bPressedJump = FALSE;
    }
    public exec function StartFire(optional byte FireModeNum)
    {
        if (Role < ENetRole.ROLE_Authority)
        {
            return;
        }
        if (!bFrozen)
        {
            ServerRestartGame();
        }
        else if (!IsTimerActive())
        {
            SetTimer(1.5, FALSE, , );
        }
    }
    public reliable server function ServerRestartGame()
    {
        if (WorldInfo.Game.PlayerCanRestartGame(Self))
        {
            WorldInfo.Game.ResetLevel();
        }
    }
    public event function Possess(Pawn aPawn, bool bVehicleTransition)
    {
        Global.Possess(aPawn, bVehicleTransition);
        if (Pawn != None)
        {
            Pawn.TurnOff();
        }
    }
    public exec function Use();
    
    public exec function ThrowWeapon();
    
    public function bool IsSpectating()
    {
        return TRUE;
    }
    public reliable server function ServerRestartPlayer();
    
    public exec function Suicide();
    
    public function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
    
    public function KilledBy(Pawn EventInstigator);
    
    
Begin:
    stop;
};
state WaitingForPawn extends BaseSpectating 
{
    ignores SeePlayer, HearNoise
    ;
    public event function EndState(Name NextStateName)
    {
        ResetCameraMode();
        SetTimer(0.0, FALSE, , );
    }
    public event function BeginState(Name PreviousStateName)
    {
        SetTimer(0.200000003, TRUE, , );
        AskForPawn();
    }
    public event function Timer()
    {
        AskForPawn();
    }
    public function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
    }
    public event function PlayerTick(float DeltaTime)
    {
        Global.PlayerTick(DeltaTime);
        if (Pawn != None)
        {
            Pawn.Controller = Self;
            Pawn.BecomeViewTarget(Self);
            ClientRestart(Pawn);
        }
        else if (!IsTimerActive() || GetTimerCount() > 1.0)
        {
            SetTimer(0.200000003, TRUE, , );
            AskForPawn();
        }
    }
    public unreliable client function LongClientAdjustPosition(float TimeStamp, Name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
        if (NewState == 'RoundEnded')
        {
            GotoState(NewState, , , );
        }
    }
    public reliable client function ClientGotoState(Name NewState, optional Name NewLabel)
    {
        if (NewState == 'RoundEnded')
        {
            Global.ClientGotoState(NewState, NewLabel);
        }
    }
    public exec function StartFire(optional byte FireModeNum)
    {
        AskForPawn();
    }
    public function KilledBy(Pawn EventInstigator);
    
    
    stop;
};
auto state PlayerWaiting extends BaseSpectating 
{
    ignores PhysicsVolumeChange, SeePlayer, HearNoise, NotifyBump
    ;
    public event simulated function BeginState(Name PreviousStateName)
    {
        if (PlayerReplicationInfo != None)
        {
            PlayerReplicationInfo.SetWaitingPlayer(TRUE);
        }
        bCollideWorld = TRUE;
    }
    public event function EndState(Name NextStateName)
    {
        if (PlayerReplicationInfo != None)
        {
            PlayerReplicationInfo.SetWaitingPlayer(FALSE);
        }
        bCollideWorld = FALSE;
    }
    public exec function StartFire(optional byte FireModeNum)
    {
        ServerRestartPlayer();
    }
    public reliable server function ServerRestartPlayer()
    {
        if (WorldInfo.TimeSeconds < WaitDelay)
        {
            return;
        }
        if (WorldInfo.NetMode == ENetMode.NM_Client)
        {
            return;
        }
        if (WorldInfo.Game.bWaitingToStartMatch)
        {
            PlayerReplicationInfo.bReadyToPlay = TRUE;
        }
        else
        {
            WorldInfo.Game.RestartPlayer(Self);
        }
    }
    public reliable server function ServerChangeTeam(int N)
    {
        WorldInfo.Game.ChangeTeam(Self, N, TRUE);
    }
    public reliable server function ServerSuicide();
    
    public exec function Suicide();
    
    public exec function Jump();
    
    public exec function SwitchToBestWeapon(optional bool bForceNewWeapon);
    
    public exec function PrevWeapon();
    
    public exec function NextWeapon();
    
    public function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
    
    
    stop;
};
state Spectating extends BaseSpectating 
{
    ignores NotifyPhysicsVolumeChange, NotifyHeadVolumeChange
    ;
    public event function EndState(Name NextStateName)
    {
        if (PlayerReplicationInfo != None)
        {
            if (PlayerReplicationInfo.bOnlySpectator)
            {
            }
            PlayerReplicationInfo.bIsSpectator = FALSE;
        }
        bCollideWorld = FALSE;
    }
    public event function BeginState(Name PreviousStateName)
    {
        if (Pawn != None)
        {
            SetLocation(Pawn.location, );
            UnPossess();
        }
        bCollideWorld = TRUE;
    }
    public exec function StartAltFire(optional byte FireModeNum)
    {
        ResetCameraMode();
        ServerViewSelf();
    }
    public exec function StartFire(optional byte FireModeNum)
    {
        ServerViewNextPlayer();
    }
    public exec function ThrowWeapon();
    
    public exec function Suicide();
    
    public reliable client function ClientRestart(Pawn NewPawn);
    
    public exec function RestartLevel();
    
    
    stop;
};
state BaseSpectating 
{
    public event function EndState(Name NextStateName)
    {
        bCollideWorld = FALSE;
    }
    public event function BeginState(Name PreviousStateName)
    {
        bCollideWorld = TRUE;
    }
    public function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        ServerSetSpectatorLocation(location);
    }
    public unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
    {
        SetLocation(NewLoc, );
        if (WorldInfo.TimeSeconds - LastSpectatorStateSynchTime > 2.0)
        {
            ClientGotoState(GetStateName());
            LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
        }
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        
        GetAxes(Rotation, X, Y, Z);
        Acceleration = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
        UpdateRotation(DeltaTime);
        if (Role < ENetRole.ROLE_Authority)
        {
            ReplicateMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        }
    }
    public function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local float VelSize;
        
        Acceleration = Normal(newAccel) * SpectatorCameraSpeed;
        VelSize = VSize(Velocity);
        if (VelSize > float(0))
        {
            Velocity = Velocity - (Velocity - Normal(Acceleration) * VelSize) * FMin(DeltaTime * float(8), 1.0);
        }
        Velocity = Velocity + Acceleration * DeltaTime;
        if (VSize(Velocity) > SpectatorCameraSpeed)
        {
            Velocity = Normal(Velocity) * SpectatorCameraSpeed;
        }
        LimitSpectatorVelocity();
        if (VSize(Velocity) > float(0))
        {
            MoveSmooth(float((1 + int(bRun))) * Velocity * DeltaTime);
            if (LimitSpectatorVelocity())
            {
                MoveSmooth(Velocity.Z * vect(0.0, 0.0, 1.0) * DeltaTime);
            }
        }
    }
    public function bool LimitSpectatorVelocity()
    {
        if (location.Z > WorldInfo.StallZ)
        {
            Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.StallZ - location.Z - 2.0);
            return TRUE;
        }
        else if (location.Z < WorldInfo.KillZ)
        {
            Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.KillZ - location.Z + 2.0);
            return TRUE;
        }
        return FALSE;
    }
    public function bool IsSpectating()
    {
        return TRUE;
    }
    
    stop;
};
state PlayerFlying 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public event function BeginState(Name PreviousStateName)
    {
        Pawn.SetPhysics(4);
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        
        GetAxes(Rotation, X, Y, Z);
        Pawn.Acceleration = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
        if (bCheatFlying && Pawn.Acceleration == vect(0.0, 0.0, 0.0))
        {
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        UpdateRotation(DeltaTime);
        if (Role < ENetRole.ROLE_Authority)
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
    }
    
    stop;
};
state PlayerSwimming 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public event function BeginState(Name PreviousStateName)
    {
        ClearTimer();
        if (Pawn.Physics != EPhysics.PHYS_RigidBody)
        {
            Pawn.SetPhysics(3);
        }
    }
    public event function Timer()
    {
        if (!Pawn.PhysicsVolume.bWaterVolume && Role == ENetRole.ROLE_Authority)
        {
            GotoState(Pawn.LandMovementState, , , );
        }
        ClearTimer();
    }
    public function PlayerMove(float DeltaTime)
    {
        local Rotator OldRotation;
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Vector newAccel;
        
        if (Pawn == None)
        {
            GotoState('Dead', , , );
        }
        else
        {
            GetAxes(Rotation, X, Y, Z);
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
            newAccel = Pawn.AccelRate * Normal(newAccel);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            if (Role < ENetRole.ROLE_Authority)
            {
                ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
            }
            bPressedJump = FALSE;
        }
    }
    public function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        Pawn.Acceleration = newAccel;
    }
    public event function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local Actor HitActor;
        local Vector HitLocation;
        local Vector HitNormal;
        local Vector Checkpoint;
        local Vector X;
        local Vector Y;
        local Vector Z;
        
        if (!Pawn.bCollideActors)
        {
            GotoState(Pawn.LandMovementState, , , );
        }
        if (Pawn.Physics != EPhysics.PHYS_RigidBody)
        {
            if (!NewVolume.bWaterVolume)
            {
                Pawn.SetPhysics(2);
                if (Pawn.Velocity.Z > float(0))
                {
                    GetAxes(Rotation, X, Y, Z);
                    Pawn.bUpAndOut = X Dot Pawn.Acceleration > float(0) && (Pawn.Acceleration.Z > float(0) || Rotation.Pitch > 2048);
                    if (Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal))
                    {
                        Pawn.Velocity.Z = Pawn.OutofWaterZ;
                        GotoState(Pawn.LandMovementState, , , );
                    }
                    else if (Pawn.Velocity.Z > float(160) || !Pawn.TouchingWaterVolume())
                    {
                        GotoState(Pawn.LandMovementState, , , );
                    }
                    else
                    {
                        Checkpoint = Pawn.location;
                        Checkpoint.Z -= Pawn.CylinderComponent.CollisionHeight + 6.0;
                        HitActor = Trace(HitLocation, HitNormal, Checkpoint, Pawn.location, FALSE, , , );
                        if (HitActor != None)
                        {
                            GotoState(Pawn.LandMovementState, , , );
                        }
                        else
                        {
                            SetTimer(0.699999988, FALSE, , );
                        }
                    }
                }
            }
            else
            {
                ClearTimer();
                Pawn.SetPhysics(3);
            }
        }
        else if (!NewVolume.bWaterVolume)
        {
            GotoState(Pawn.LandMovementState, , , );
        }
    }
    public event function bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        if (Pawn.PhysicsVolume.bWaterVolume)
        {
            Pawn.SetPhysics(3);
        }
        else
        {
            GotoState(Pawn.LandMovementState, , , );
        }
        return bUpdating;
    }
    
Begin:
    stop;
};
state PlayerDriving 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public event function EndState(Name NextStateName)
    {
        CleanOutSavedMoves();
    }
    public event function BeginState(Name PreviousStateName)
    {
        CleanOutSavedMoves();
    }
    public unreliable server function ServerUse()
    {
        local Vehicle CurrentVehicle;
        
        CurrentVehicle = Vehicle(Pawn);
        CurrentVehicle.DriverLeave(FALSE);
    }
    public function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
        if (Role < ENetRole.ROLE_Authority)
        {
            ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }
        bPressedJump = FALSE;
    }
    public function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;
        
        CurrentVehicle = Vehicle(Pawn);
        if (CurrentVehicle != None)
        {
            bPressedJump = InJump;
            CurrentVehicle.SetInputs(InForward, -InStrafe, InUp);
            CheckJumpOrDuck();
        }
    }
    public function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot);
    
    
    stop;
};
state PlayerClimbing 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public event function EndState(Name NextStateName)
    {
        if (Pawn != None)
        {
            Pawn.SetRemoteViewPitch(0);
            Pawn.ShouldCrouch(FALSE);
        }
    }
    public event function BeginState(Name PreviousStateName)
    {
        Pawn.ShouldCrouch(FALSE);
        bPressedJump = FALSE;
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Vector newAccel;
        local Rotator OldRotation;
        local Rotator ViewRotation;
        
        GetAxes(Rotation, X, Y, Z);
        if (Pawn.OnLadder != None)
        {
            newAccel = PlayerInput.aForward * Pawn.OnLadder.ClimbDir;
            if (Pawn.OnLadder.bAllowLadderStrafing)
            {
                newAccel += PlayerInput.aStrafe * Y;
            }
        }
        else
        {
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
        }
        newAccel = Pawn.AccelRate * Normal(newAccel);
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        if (Role < ENetRole.ROLE_Authority)
        {
            ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        bPressedJump = FALSE;
    }
    public function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == None)
        {
            return;
        }
        if (Role == ENetRole.ROLE_Authority)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        if (bPressedJump)
        {
            Pawn.DoJump(bUpdating);
            if (Pawn.Physics == EPhysics.PHYS_Falling)
            {
                GotoState(Pawn.LandMovementState, , , );
            }
        }
    }
    public event function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState, , , );
        }
        else
        {
            GotoState(Pawn.LandMovementState, , , );
        }
    }
    
    stop;
};
state PlayerWalking 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public event function EndState(Name NextStateName)
    {
        GroundPitch = 0;
        if (Pawn != None)
        {
            Pawn.SetRemoteViewPitch(0);
            if (int(bDuck) == 0)
            {
                Pawn.ShouldCrouch(FALSE);
            }
        }
    }
    public event function BeginState(Name PreviousStateName)
    {
        DoubleClickDir = EDoubleClickDir.DCLICK_None;
        bPressedJump = FALSE;
        GroundPitch = 0;
        if (Pawn != None)
        {
            Pawn.ShouldCrouch(FALSE);
            if (Pawn.Physics != EPhysics.PHYS_Falling && Pawn.Physics != EPhysics.PHYS_RigidBody && Pawn.Physics != EPhysics.PHYS_Interpolating)
            {
                Pawn.SetPhysics(1);
            }
        }
    }
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Vector newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;
        
        if (Pawn == None)
        {
            GotoState('Dead', , , );
        }
        else
        {
            GetAxes(Pawn.Rotation, X, Y, Z);
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
            newAccel.Z = 0.0;
            newAccel = Pawn.AccelRate * Normal(newAccel);
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = FALSE;
            if (bPressedJump && Pawn.CannotJumpNow())
            {
                bSaveJump = TRUE;
                bPressedJump = FALSE;
            }
            else
            {
                bSaveJump = FALSE;
            }
            if (Role < ENetRole.ROLE_Authority)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
    }
    public function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == None)
        {
            return;
        }
        if (Role == ENetRole.ROLE_Authority)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        CheckJumpOrDuck();
    }
    public event function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume.bWaterVolume && Pawn.bCollideWorld)
        {
            GotoState(Pawn.WaterMovementState, , , );
        }
    }
    
Begin:
    stop;
};

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetOwner && Role == ENetRole.ROLE_Authority && ViewTarget != Pawn && Pawn(ViewTarget) != None)
        TargetViewRotation, TargetEyeHeight;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Object
    QuickSaveString = "Quick Saving"
    NoPauseMessage = "Game is not pauseable"
    ViewingFrom = "Now viewing from"
    OwnCamera = "Now viewing from own camera"
    ForceFeedbackManagerClassName = "WinDrv.XnaForceFeedbackManager"
    CameraClass = Class'Camera'
    PlayerOwnerDataStoreClass = Class'PlayerOwnerDataStore'
    SavedMoveClass = Class'SavedMove'
    CheatClass = Class'CheatManager'
    InputClass = Class'PlayerInput'
    MaxResponseTime = 0.125
    FOVAngle = 85.0
    DesiredFOV = 85.0
    DefaultFOV = 85.0
    LODDistanceFactor = 1.0
    LastSpeedHackLog = -100.0
    CylinderComponent = CollisionCylinder
    InteractDistance = 512.0
    SpectatorCameraSpeed = 600.0
    MinRespawnDelay = 1.0
    MaxConcurrentHearSounds = 32
    bIsUsingStreamingVolumes = TRUE
    bCheckRelevancyThroughPortals = TRUE
    bIsPlayer = TRUE
    bCanDoSpecial = TRUE
    Components = (None, CollisionCylinder)
    NetPriority = 3.0
    CollisionComponent = CollisionCylinder
}