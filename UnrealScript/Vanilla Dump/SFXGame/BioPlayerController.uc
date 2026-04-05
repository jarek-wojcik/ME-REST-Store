Class BioPlayerController extends PlayerController
    native
    config(Game);

struct native BioPPSettingsCallbackData 
{
    var Pointer fpCallback;
    var Pointer pData;
};
struct native SFXHotKeyDefinition 
{
    var Name nmPawn;
    var Name nmPower;
};
const SFX_HOTKEY_SLOT_COUNT = 8;
struct native PlayerOrder 
{
    var Vector vTarget;
    var Vector vOriginalCameraLocation;
    var Rotator rOriginalCameraRotation;
    var Name nmPower;
    var Actor oTarget;
    var SFXWeapon_NativeBase oSwitchWeapon;
};
struct native PostProcessInfo 
{
    var float Shadows;
    var float MidTones;
    var float HighLights;
    var float Desaturation;
    var ETVType Preset;
};
struct native BioDamageIndicatorData 
{
    var float fCooldownTime;
};
struct native BioRadarData 
{
    var Vector vPosition;
    var int nIndex;
    var float fPassTime;
    var int nSize;
    var int nRelativeZ;
    var bool bPlayerLockedOn;
    var EBioRadarType eRadarType;
};
enum ECoverVisualizations
{
    CV_None,
    CV_Mantle,
};
enum ETutorialHooks
{
    TUT_Storm,
    TUT_Cover,
    TUT_Mantle,
    TUT_MeleeHeavy,
    TUT_MeleeLight,
    TUT_AmmoPickup,
    TUT_Reload,
    TUT_WeaponSwapWheel,
    TUT_WeaponSwapButton,
    TUT_CastPowerWheel,
    TUT_CastPowerButton,
    TUT_AssignedPower,
    TUT_MeleeFromCover,
    TUT_CoverSlip,
    TUT_SWATRoll,
    TUT_TurnCoverCorner,
    TUT_SquadCommand,
    TUT_ClimbUp,
    TUT_ObjectiveCheck,
};
const DefaultInVehicleReason = 343734;
const DefaultNoValidStorageReason = 343733;
const DefaultNotLoggedInReason = 297457;
const DefaultInCombatReason = 168057;
const DefaultNoSaveReason = 168056;
struct native LocalEnemy 
{
    var Pawn Enemy;
    var bool bVisible;
    var bool bSeen;
    var bool bHasLOS;
};
struct native CoverAcquisitionParams 
{
    var config float MinCameraDotCover;
    var config float MinSlotDotPlayer;
    var config float MinPlayerDotCoverOffset;
    var config float MaxDist;
    var config float MaxCoverHeightFactor;
};
enum ECommandInputMethod
{
    CIM_Default,
    CIM_Kinect,
};
struct native SavedMoveReplicationInfo 
{
    var Vector ForcedLocation;
    var PlayerController PC;
    var SFXSavedMove ReplicatedMoves;
    var bool bForceNewLocation;
};

var native Map_Mirror m_RadarDataMap;
var native Map_Mirror m_DamageIndicatorDataMap;
var transient string MPSeamlessTravelDelayURL;
var array<SFXOutlineGlowActorBase> OutlineGlowActors;
var array<LocalEnemy> EnemyList;
var(BioPlayerController) string StormRTPCName;
var config array<int> TutorialIDs;
var transient array<BioPawn> m_AccomplishmentTargets;
var transient array<int> m_anRecoveredRadarIndexes;
var transient array<int> m_anDestroyedPawnIndexesToRecover;
var transient array<Actor> m_aoPotentialRadarObjects;
var transient array<BioRadarMapBoundaries> m_aoMapBoundaryObjects;
var transient array<Pawn> m_aoDamageCausers;
var transient array<PostProcessInfo> PostProcessPresets;
var transient array<BioPPSettingsCallbackData> m_aPPCallbacks;
var delegate<OnResumeGameComplete> __OnResumeGameComplete__Delegate;
var delegate<PauseOnExternalUIState> __PauseOnExternalUIState__Delegate;
var SFXHotKeyDefinition m_aHotKeyDefines[8];
var(Cover) ScreenShakeStruct CoverShake;
var transient PlayerOrder m_currentOrder;
var transient BoxSphereBounds AimbackBounds;
var(Cover) config CoverAcquisitionParams CoverAcquireParams;
var(Cover) config CoverAcquisitionParams DirectionalCoverAcquireParams;
var(Cover) Guid CoverVisualizationClientEffectGuid;
var(Movement) Guid JumpClientEffectGuid;
var(Movement) Guid LadderUpClientEffectGuid;
var(Movement) Guid LadderDownClientEffectGuid;
var transient Vector PushOffCoverDir;
var Vector m_vLocationRadarArrowPointsTo;
var transient Vector m_vNavAssistPoint;
var transient Vector LastReceivedLocation;
var transient Vector LastReceivedAcceleration;
var transient Rotator LastReceivedRotation;
var transient Vector DesiredLocation;
var transient Vector LastExtrapolatedLocation;
var transient Vector RemoteCameraLocation;
var transient Rotator RemoteCameraRotation;
var(BioPlayerController) Vector2D FlinchIntervalRange;
var(BioPlayerController) Vector2D NoShieldFlinchIntervalRange;
var SFXProfileSettings ProfileSettings;
var config float MPSeamlessTravelDelay;
var transient float MPSeamlessTravelDelayTriggerTime;
var transient BioCameraZoom ZoomData;
var const float MoveStickIdleThreshold;
var const float MoveStickWalkThreshold;
var const float MoveStickRunThreshold;
var const float MoveWalkModifierBlendTime;
var(Cover) config float DeadZoneThreshold;
var(Cover) config float PlayerCoverTransitionTime;
var transient float CoverTransitionCountHold;
var(Cover) config float CoverBreakTimeThreshold;
var transient float CoverBreakTimer;
var(Cover) config float MaxCoverEnterDist;
var(Cover) float CoverCameraTransitionTime;
var(Cover) config float CoverSnapScale;
var(Cover) config float CoverUpdateDelay;
var(Cover) config float StormCoverUpdateDelay;
var(Cover) float CoverSlipCamAlign;
var const float PushOffCoverDuration;
var transient float PushOffTimeToGo;
var transient float LastFlinchTime;
var(Cover) transient float FlinchInterval;
var(Cover) transient float NoShieldFlinchInterval;
var(Cover) RvrClientEffectInterface CoverVisualizationClientEffect;
var(Cover) RvrClientEffectInterface CE_Grab;
var(Cover) RvrClientEffectInterface CE_Mantle;
var(Cover) RvrClientEffectInterface CE_SwatLeft;
var(Cover) RvrClientEffectInterface CE_SwatRight;
var(Cover) RvrClientEffectInterface CE_HighSwatLeft;
var(Cover) RvrClientEffectInterface CE_HighSwatRight;
var(Cover) RvrClientEffectInterface CE_SlipRight;
var(Cover) RvrClientEffectInterface CE_SlipLeft;
var(Cover) RvrClientEffectInterface CE_HighSlipRight;
var(Cover) RvrClientEffectInterface CE_HighSlipLeft;
var(Movement) RvrClientEffectInterface CE_Jump;
var(Movement) RvrClientEffectInterface CE_LadderUp;
var(Movement) RvrClientEffectInterface CE_LadderDown;
var(Movement) config float LadderFaceDot;
var(Movement) config float LadderAimDot;
var config float m_fClimbMantleFaceAngleThreshold;
var config float m_fClimbMantleDistanceThreshold;
var float RemappedJoyRight;
var float RemappedJoyUp;
var(BioPlayerController) config float RotationSensitivityLow;
var(BioPlayerController) config float RotationSensitivityMedium;
var(BioPlayerController) config float RotationSensitivityHigh;
var transient int OldIgnoreMoveCount;
var transient int NextEnemyToCheckLOS;
var config float SawEnemyTypeShoutCooldownTime;
var transient float CurrentStormStamina;
var config transient float StormCooldownTime;
var transient int StormDisabledCounter;
var(BioPlayerController) WwiseEvent StormStartWwiseEvent_M;
var(BioPlayerController) WwiseEvent StormPeakWwiseEvent_M;
var(BioPlayerController) WwiseEvent StormStartWwiseEvent_F;
var(BioPlayerController) WwiseEvent StormPeakWwiseEvent_F;
var(BioPlayerController) WwiseEvent StormEndWwiseEvent;
var(BioPlayerController) stringref KismetNoSaveReason;
var(BioPlayerController) config stringref StorageDeviceRemovedText;
var(BioPlayerController) config stringref DLCRemovedText;
var(BioPlayerController) stringref RestartGame;
var(BioPlayerController) stringref ProfileChangedText;
var(BioPlayerController) stringref ProfileChangedUnrecoverableText;
var(BioPlayerController) config stringref ControllerRemoved;
var config transient float m_fLeaveConvPitch;
var config float m_fMoveToDropDistance;
var config float m_fMaxZDifference;
var config float m_fRelativeZUpLimit;
var config float m_fRelativeZDownLimit;
var float m_fLastRadarPassTime;
var float m_fLastRadarRange;
var float m_fRadarRange;
var float m_fRadarFOV;
var float m_fLastRadarFOV;
var transient BioRadarMapBoundaries m_oRadarMapBoundary;
var transient int m_nMaxRadarIndex;
var config int m_nNavAssistMaxNodeLimit;
var transient float m_fBumpCheckTimer;
var(BioPlayerController) float m_fDamageIndicatorDisplayTime;
var config stringref m_srVehicleExitFailureMsg;
var config stringref m_srVehicleExitAButtonMsg;
var transient SFXGameModeManager GameModeManager2;
var config transient float m_fAttackOrderFarAngle;
var config transient float m_fAttackOrderCloseAngle;
var config transient float m_fAttackOrderCloseDistance;
var editinline transient export RvrComponentPCNetClientEffects m_oRvrNetClientEffectsInterface;
var transient int InvalidServerMovesReceived;
var config int NUM_SERVERMOVE_BEFORE_RESET;
var config int MOVEREP_DELAY_FRAME;
var transient int NumberOfFrameSinceLastMoveRep;
var transient int RemotePlayerPendingCustomAction;
var transient int RemotePlayerPendingPowerCustomAction;
var config float RemotePlayersRotationInterpolationSpeed;
var config float BIO_RESET_MAX_POSITION_ERROR_SQUARED;
var config float BIO_WARNING_MAX_POSITION_ERROR_SQUARED;
var config int MAX_CONSECUTIVE_POSITION_ERROR;
var config float ClientTimeoutForPendingCustomActionReset;
var config float AutonomousProxyLocationInterpSpeed;
var(BioPlayerController) float EdgeCoverSlotSnapRange;
var transient int NumClientPositionError;
var config stringref srOK;
var config stringref srNuiDisconnectError;
var(BioPlayerController) export BioHintSystemBase HintSystem;
var export BioPlayerSelection m_oPlayerSelection;
var bool bUsePackedMoves;
var bool m_bDisableSquadCommandExit;
var(Cover) config bool bDebugCover;
var transient bool bBreakFromCover;
var transient bool bPreferLeanOverPopup;
var(Cover) bool bNoCoverFromStorm;
var(Movement) bool bCancelStorm;
var(Cover) bool bNoLeaveCover;
var transient bool bReticleHidden;
var(Cover) bool bLockPosition;
var(Cover) config bool CoverRespectsRotation;
var(Cover) bool bCoverGUIShowing;
var(Movement) bool bJumpGUIShowing;
var(Movement) bool bLadderGUIShowing;
var(Cover) bool bShowActionIcons;
var config bool m_bCanMantleOutsideOfCover;
var transient bool HasSeenFirstEnemy;
var transient bool bTiredStorming;
var transient bool bStormCoolingDown;
var(BioPlayerController) bool bProfileSettingsUpdated;
var(BioPlayerController) bool bKismetNoSave;
var transient bool m_bIsStoppedForConv;
var config transient bool m_bEnableCineModeWarning;
var transient bool m_bDEBUGFlyUpPressed;
var transient bool m_bDEBUGFlyDownPressed;
var bool m_bRadarArrow;
var transient bool m_bRadarIsJammed;
var transient bool m_bPermanentWalk;
var transient bool m_bToggledWalk;
var transient bool bSkipPhysicsForOneFrame;
var transient bool bMultiplayerCommandMode;
var transient bool bExtrapolationActive;
var transient bool bExtrapolationWasActive;
var transient bool bReceivedNewLocation;
var config bool bEnableMultiplayerMotionBlur;
var transient bool RemoteAimAssistActive;
var transient bool bClientStorming;
var input transient byte bWantsToStorm;
var transient ECoverVisualizations CurrentVisualization;
var input byte bBoost;
var input byte bJump;
var input byte bAlternateCamera;
var input byte bMine;
var ESFXHUDActionIcon m_eCurrentActionIcon;

public event function ApplyTacticalOrders()
{
    local BioPawn PlayerPawn;
    local BioPlayerInput Input;
    
    PlayerPawn = BioPawn(Pawn);
    if (PlayerPawn == None)
    {
        return;
    }
    if (PlayerPawn.IsInAnimatedTransition())
    {
        SetTimer(0.25, FALSE, 'ApplyTacticalOrders', );
        return;
    }
    else if (IsTimerActive('ApplyTacticalOrders'))
    {
        ClearTimer('ApplyTacticalOrders');
    }
    if (!PlayerPawn.bCombatPawn)
    {
        return;
    }
    if (!IsPlayerPerformingBlockingAction())
    {
        if (m_currentOrder.nmPower != 'None')
        {
            Input = BioPlayerInput(PlayerInput);
            if (Input != None)
            {
                Input.ActivatePower(m_currentOrder.nmPower, m_currentOrder.oTarget, m_currentOrder.vTarget, m_currentOrder.vOriginalCameraLocation, m_currentOrder.rOriginalCameraRotation);
            }
        }
        else if (m_currentOrder.oSwitchWeapon != None)
        {
            SwitchWeapon(m_currentOrder.oSwitchWeapon);
        }
        ClearPlayerOrder();
    }
}
public final native function BioMoveAutonomous(float DeltaTime, Rotator DeltaRot, SavedMove Move);

public unreliable server native function BioServerMove(SavedMoveReplicationInfo RepMoves, Vector ClientLocation);

public function CameraShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local ScreenShakeStruct Shake;
    
    Shake.TimeDuration = Duration;
    Shake.FOVAmplitude = newFOVAmplitude;
    Shake.FOVFrequency = newFOVFrequency;
    Shake.RotAmplitude = newRotAmplitude;
    Shake.RotFrequency = newRotFrequency;
    Shake.LocAmplitude = newLocAmplitude;
    Shake.LocFrequency = newLocFrequency;
    SFXPlayerCamera(PlayerCamera).AddScreenShake(Shake);
}
public event function CancelLastOrderedPower(Pawn oOrderedPawn, Name nmPower)
{
    local SFXAI_Henchman oController;
    
    if (oOrderedPawn != None)
    {
        oController = SFXAI_Henchman(oOrderedPawn.Controller);
        if (oController != None)
        {
            oController.CancelOrder(1, nmPower);
        }
        else if (oOrderedPawn == Pawn)
        {
            ClearPlayerOrder();
        }
    }
}
public final native function bool CanPerformClimb(const out CovPosInfo CoverInfo);

public final native function bool CanPerformEnterCover();

public final native function bool CanPerformMantle(const out CovPosInfo CoverInfo);

public native function bool CanRunQueuedOrder();

public event function bool CanSave(out string Reason)
{
    local OnlinePlayerInterface PlayerInterface;
    local byte PlayerID;
    local SFXGRI GRI;
    local SFXEngine Engine;
    local BioPawn BP;
    local bool bSaveBlockingSpawnerActive;
    local array<SequenceObject> SeqObjs;
    local SequenceObject Sequence;
    local SFXSeqAct_AIFactory2 EnemySpawner;
    
    Engine = SFXEngine(Player.Outer);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerID = byte(LocalPlayer(Player).ControllerId);
                if (int(PlayerInterface.GetLoginStatus(PlayerID)) == 0)
                {
                    Reason = Class'SFXGame'.static.GetSimpleString($297457);
                    return FALSE;
                }
            }
            if (Engine != None && !Engine.IsCurrentDeviceValid())
            {
                Reason = Class'SFXGame'.static.GetSimpleString($343733);
                return FALSE;
            }
        }
    }
    GRI = SFXGRI(WorldInfo.GRI);
    BP = BioPawn(Pawn);
    bSaveBlockingSpawnerActive = FALSE;
    WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SFXSeqAct_AIFactory2', TRUE, SeqObjs);
    foreach SeqObjs(Sequence, )
    {
        EnemySpawner = SFXSeqAct_AIFactory2(Sequence);
        if (EnemySpawner != None && EnemySpawner.bActive && EnemySpawner.bPreventSave)
        {
            bSaveBlockingSpawnerActive = TRUE;
            break;
        }
    }
    if (bKismetNoSave)
    {
        Reason = Class'SFXGame'.static.GetSimpleString(KismetNoSaveReason);
        return FALSE;
    }
    else if (GRI != None && GRI.InCombat())
    {
        Reason = Class'SFXGame'.static.GetSimpleString($168057);
        return FALSE;
    }
    else if (bSaveBlockingSpawnerActive)
    {
        Reason = Class'SFXGame'.static.GetSimpleString($168057);
        return FALSE;
    }
    else if (SVehicle(Pawn) != None)
    {
        Reason = Class'SFXGame'.static.GetSimpleString($343734);
        return FALSE;
    }
    else if (SFXPawn_Player(Pawn) == None)
    {
        Reason = Class'SFXGame'.static.GetSimpleString($168056);
        return FALSE;
    }
    else if (GameModeManager2.AllowsSaving() == FALSE)
    {
        Reason = Class'SFXGame'.static.GetSimpleString($168056);
        return FALSE;
    }
    else if (BP != None && BP.IsDead())
    {
        Reason = "Cannot save while dead";
        return FALSE;
    }
    else if (BP != None && BP.IsPerformingBlockingAction())
    {
        Reason = Class'SFXGame'.static.GetSimpleString($168056);
        return FALSE;
    }
    return TRUE;
}
public native function bool CanStorm();

public event function bool CanUse(Actor Selection)
{
    local SFXSimpleUseModule UseModule;
    local array<SequenceEvent> UsedEvents;
    local SequenceEvent UsedEvent;
    local SeqEvent_Used CheckEvent;
    local BioPawn BP;
    local BioCustomAction CA;
    
    if (Selection == None)
    {
        return FALSE;
    }
    if (VSize(Pawn.location - Selection.location) > InteractDistance)
    {
        return FALSE;
    }
    BP = BioPawn(Pawn);
    if (BP != None && BP.GetCurrentCustomAction(CA))
    {
        if (CA.bDisableUse)
        {
            return FALSE;
        }
    }
    if (IsCombatTargetable(Selection) == FALSE)
    {
        if (Pawn(Selection) != None && BioAiController(Pawn(Selection).Controller) != None)
        {
            if (Pawn(Selection).FindEventsOfClass(Class'BioSeqEvt_OnPlayerActivate'))
            {
                return TRUE;
            }
        }
    }
    UseModule = Selection.GetModule(Class'SFXSimpleUseModule');
    if (UseModule != None)
    {
        if (!UseModule.IsDefaultActionPossible())
        {
            return FALSE;
        }
        if (PlayerController(Pawn.Controller) != None && BioPawn(PlayerController(Pawn.Controller).GetViewTarget()) != None && SFXAI_Core(BioPawn(PlayerController(Pawn.Controller).GetViewTarget()).Controller) != None && SFXAI_Core(BioPawn(PlayerController(Pawn.Controller).GetViewTarget()).Controller).bIsAutoBot == TRUE)
        {
            return TRUE;
        }
        if (VSize(Pawn.location - Selection.location) > UseModule.fUseRange)
        {
            return FALSE;
        }
        return TRUE;
    }
    if (Selection.FindEventsOfClass(Class'SeqEvent_Used', UsedEvents))
    {
        foreach UsedEvents(UsedEvent, )
        {
            CheckEvent = SeqEvent_Used(UsedEvent);
            if (CheckEvent != None && VSize(Pawn.location - Selection.location) <= CheckEvent.InteractDistance)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public event function CheckThatGameCanContinue()
{
    local SFXEngine Engine;
    local SFXOnlineComponentUnrealPlayer PlayerInt;
    local BioMessageBoxOptionalParams stParams;
    local SFXGRI GRI;
    local bool bMultiplayer;
    local bool bSplashScreen;
    local bool bMainMenu;
    local bool bSaveDeviceRemoved;
    local LocalPlayer LocPlayer;
    local UniqueNetId NewPlayerID;
    local stringref NewErrorString;
    local SFXGUIInteraction oGuiInteraction;
    local SFXOnlineSubsystem SFXOnlineSub;
    local string URLString;
    local string OptionsString;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None && OnlineSub.PlayerInterface != None)
    {
        PlayerInt = SFXOnlineComponentUnrealPlayer(OnlineSub.PlayerInterface);
        if (PlayerInt != None)
        {
            PlayerInt.GetOfflinePlayerId(byte(LocPlayer.ControllerId), NewPlayerID);
        }
    }
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        if (Engine.bHasProfileCantContinueError && Engine.bDisableProfileReconnection)
        {
            return;
        }
        oGuiInteraction = Class'SFXGUIInteraction'.static.GetInstance();
        bMainMenu = oGuiInteraction.GetMovie(Self, oGuiInteraction.MovieTag_MainMenu) != None;
        bSplashScreen = oGuiInteraction.IsInSplashScreen();
        if (bSplashScreen || Engine.bMPTransitionToEntryMenu)
        {
            NewErrorString = $0;
        }
        else
        {
            GRI = SFXGRI(WorldInfo.GRI);
            bMultiplayer = GRI != None && GRI.bIsMultiplayerCharacter == TRUE;
            bSaveDeviceRemoved = Len(Engine.GetCurrentSaveDescriptor().Career) > 0 && !Engine.FindCurrentSaveDevice();
            if (NewPlayerID != Engine.m_oInitialPlayerID)
            {
                SFXOnlineSub = SFXOnlineSubsystem(OnlineSub);
                if (SFXOnlineSub != None && SFXOnlineSub.GetComponentGameFlow().GM_IsInMultiplayerFlow())
                {
                    Engine.bDisableProfileReconnection = TRUE;
                }
                else if (WorldInfo.TimeSeconds < 1.0)
                {
                    URLString = WorldInfo.GetLocalURL();
                    OptionsString = Mid(URLString, InStr(URLString, "?", , , ), );
                    if (Class'GameInfo'.static.HasOption(OptionsString, "failed"))
                    {
                        Engine.bDisableProfileReconnection = TRUE;
                    }
                }
                NewErrorString = Engine.bDisableProfileReconnection ? ProfileChangedUnrecoverableText : ProfileChangedText;
            }
            else if (!bMultiplayer && !bMainMenu && bSaveDeviceRemoved)
            {
                NewErrorString = StorageDeviceRemovedText;
            }
            else if (DownloadableContentWasRemoved())
            {
                NewErrorString = DLCRemovedText;
            }
        }
        if (NewErrorString != 0 && Engine.srCantContinueErrorMessage == 0)
        {
            Engine.srCantContinueErrorMessage = NewErrorString;
            Engine.bHasProfileCantContinueError = NewErrorString == ProfileChangedText || NewErrorString == ProfileChangedUnrecoverableText;
            Engine.LastCantContinueTime = Engine.GetCurrentTime();
            stParams.srAText = RestartGame;
            stParams.srBText = $0;
            stParams.bModal = TRUE;
            stParams.bForcePlayersOnly = TRUE;
            stParams.bNoFade = TRUE;
            oGuiInteraction.QueueNamedMessageBox('GameCantContinue', 0, Engine.srCantContinueErrorMessage, stParams, Engine.Callback_PlayerLoggedOut, 0, Self, TRUE);
        }
        else if (Engine.srCantContinueErrorMessage != NewErrorString)
        {
            Engine.srCantContinueErrorMessage = $0;
            Engine.bHasProfileCantContinueError = FALSE;
            Engine.FlushIOHandles();
            oGuiInteraction.RemoveNamedMessageBox('GameCantContinue', Self);
            if (NewErrorString != 0)
            {
                CheckThatGameCanContinue();
            }
            else
            {
                Engine.bCanWriteSaveToStorage = TRUE;
                Engine.ResumeSaveGameCommandExecution();
            }
        }
    }
}
public simulated native function ClearDamageIndicators(Level Level);

public function ClearOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local LocalPlayer LocPlayer;
    
    Super.ClearOnlineDelegates();
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.ClearLoginChangeDelegate(NotifyLoginChange);
            PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), NotifyProfileReadComplete);
        }
    }
}
public native function ClearPlayerOrder();

public native function ClearServerMoveExtrapolation();

public final event reliable client function ClientLoadSeekFreeObjectAsync(int ObjectNetID)
{
    local EAsyncLoadStatus Status;
    
    Class'SFXEngine'.static.LoadSeekFreeObjectAsyncByNetID(ObjectNetID, Class'Object', Status);
}
public event reliable client function ClientPlaySimpleDialogLine(stringref DialogLineSr, Actor DialogPlayerOwner);

public final event reliable client function ClientReleaseSeekFreeObject(int ObjectNetID)
{
    Class'SFXEngine'.static.ReleaseSeekFreeObjectByNetID(ObjectNetID);
}
public event reliable client native function ClientTravel(string URL, ETravelType TravelType, optional bool bSeamless, optional init Guid MapPackageGuid);

public event unreliable client function ClientVocalizationEvent(SFXVocalizationEvent VocEvent)
{
    SFXGRI(WorldInfo.GRI).VocManager.QueueReplicatedVocalization(VocEvent);
}
public final native function float ComputeClientLocationError(Vector CurrentLocation, Vector NewLocation);

public final native function ComputeMovementStickAngle(out float Mag, out float AngleStick, out Rotator RotWorld);

public final native function bool CoverReachable(Pawn PlayerPawn, out CovPosInfo out_CovPosInfo);

public function Destroyed()
{
    Class'SFXGUIInteraction'.static.GetInstance().RemoveMoviesForPlayer(Self);
    Super.Destroyed();
}
public native function DetermineLeanDirection(BioPawn BioPawn, out CoverSlot CurrentSlot, out ECoverAction out_PawnCA, out ECoverDirection out_PawnCD);

public native function DisableDOF();

public final native function DisplayNuiSpeech_CombatFeedback(bool Successful, string TargetPawn, stringref Rule);

public final event function DisplayNuiSpeech_Disconnection()
{
    local SFXGUIInteraction GUIInteraction;
    local BioMessageBoxOptionalParams Params;
    
    GUIInteraction = GetSFXUIController();
    if (GUIInteraction != None)
    {
        Params.srAText = srOK;
        GUIInteraction.QueueNamedMessageBox('NuiDisconnect', 1, srNuiDisconnectError, Params, None);
    }
}
public final native function DisplayNuiSpeech_ExploreFeedback(bool Successful);

public final native function DisplayNuiSpeech_GenericFeedback(bool Successful, stringref Rule);

public event function DoQuickSave()
{
    QuickSave();
}
public native function bool DownloadableContentWasRemoved();

public native function DrawCircle(Vector vLocation, Vector vNormal, float fRadius, Color CircleColor);

public native function DrawSelectionReticle(Vector vLocation);

public native function EnableFilmgrain(bool bEnable);

public native function EnableMotionBlur(bool bEnable);

public final native function FillCoverPosInfo(CoverLink Link, int SlotIdx, Vector SourceLoc, Vector Direction, float MaxDistance, out CovPosInfo out_CovPosInfo);

public final native function bool FindJumpDownPoint(out SFXJumpDownReachSpec out_JumpDownSpec);

public final native function bool FindJumpPoint(out SFXJumpReachSpec out_JumpSpec);

public final native function bool FindLadderNode(out SFXLadderReachSpec out_LadderSpec, optional float MinDistance = 75.0);

public final native function bool FindPlayerCover(out CovPosInfo out_CovPosInfo, Vector Direction, float MaxDistance, float MinCameraDotCover, float MinSlotDotPlayer, float MinPlayerDotCoverOffset, float MaxHeightFactor);

public final native function DOFEffect FindUberDOFEffect();

public event function GenerateTutorialEvent(ETutorialHooks eTutHook)
{
    local SFXGame oGame;
    local BioGlobalVariableTable oGV;
    local int nPrevValue;
    local int nExportID;
    
    oGame = SFXGame(Class'Engine'.static.GetCurrentWorldInfo().Game);
    if (oGame != None && oGame.bGenerateTutorialEvents)
    {
        if (int(eTutHook) < TutorialIDs.Length)
        {
            nExportID = TutorialIDs[int(eTutHook)];
        }
        else
        {
            nExportID = -1;
        }
        if (nExportID != -1)
        {
            oGV = BioWorldInfo(WorldInfo).GetGlobalVariables();
            nPrevValue = oGV.GetInt(nExportID);
            oGV.SetInt(nExportID, nPrevValue + 1);
        }
    }
}
public final native function Pawn GetAimAssistTarget(float MaxDistance, const out Vector CamLoc, const out Rotator CamRot, out Vector TargetLoc, out float Margin);

public final native function SFXNav_GoalPoint GetBestGoalPoint();

public final native function BioPawn GetBioPawn();

public native function bool GetCameraRelativeRotation(out Vector vDirection);

public event function bool GetHenchmanAttackOrderPower(Pawn oHenchman, Actor oTarget, out Name nmPowerName)
{
    local SFXPawn_Henchman oPawn;
    local SFXAI_Henchman oController;
    local SFXPowerCustomActionBase oPower;
    local int nRequiresAttackTicket;
    local Vector AttackOrigin;
    
    oPawn = SFXPawn_Henchman(oHenchman);
    if (oPawn == None || oPawn.PowerManager == None)
    {
        return FALSE;
    }
    if (oPawn.GetAttackOrderPower(oPower))
    {
        if (oPower != None && oPower.IsTargetInRange(oTarget))
        {
            if (oPower.CurrentCooldownTime == 0.0)
            {
                nmPowerName = oPower.PowerName;
                return TRUE;
            }
        }
    }
    oController = SFXAI_Henchman(oPawn.Controller);
    if (oController == None)
    {
        return FALSE;
    }
    return oController.ChooseAttackPowerHelper(oTarget, TRUE, nmPowerName, nRequiresAttackTicket, AttackOrigin);
}
public final native function SFXSFHandler_HUD GetHUDMovie();

public function bool GetInputDisabled()
{
    local BioPlayerInput oInput;
    
    oInput = BioPlayerInput(PlayerInput);
    if (oInput != None)
    {
        return oInput.GetInputDisabled();
    }
    else
    {
        return TRUE;
    }
}
public function ELoginStatus GetLoginStatus()
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (OnlineSub != None && OnlineSub.PlayerInterface != None && LP != None)
    {
        return OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId));
    }
    else
    {
        return 0;
    }
}
public native function int GetPlayerControllerId();

public event simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    local Actor TheViewTarget;
    
    if (PlayerCamera == None && IsLocalPlayerController())
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
            if (Pawn(TheViewTarget) != None)
            {
                out_Location = Pawn(TheViewTarget).GetPawnViewLocation();
            }
            else
            {
                out_Location = TheViewTarget.location;
            }
            out_rotation = TheViewTarget.Rotation;
        }
        else
        {
            out_Location = location;
            out_rotation = Rotation;
        }
    }
}
public final native function float GetRadarFOV();

public final native function float GetRadarRange();

public native function SFXGUIInteraction GetSFXUIController();

public final native function bool GetValidOrderLocation(Vector TestLocation, out Vector OrderLocation);

public final native function Pawn GetZoomSnapTarget(float MinDistance, float MaxDistance, out Vector AimLocation);

public event function bool GetZoomSnapWeaponInfo(Weapon Weapon, int idx, out EAimNodes AimNode, out float OuterSnapAngle, out float InnerSnapAngle, out float OffsetMag)
{
    local SFXWeapon ChkWeapon;
    
    ChkWeapon = SFXWeapon(Weapon);
    if (ChkWeapon != None && idx < ChkWeapon.ZoomSnapList.Length)
    {
        AimNode = ChkWeapon.ZoomSnapList[idx].AimNode;
        OuterSnapAngle = ChkWeapon.ZoomSnapList[idx].OuterSnapAngle;
        InnerSnapAngle = ChkWeapon.ZoomSnapList[idx].InnerSnapAngle;
        OffsetMag = ChkWeapon.ZoomSnapList[idx].SnapOffsetMag;
        return TRUE;
    }
    return FALSE;
}
public event function HandleWalking()
{
    if (Pawn != None && (m_bPermanentWalk || m_bToggledWalk))
    {
        Pawn.SetWalking(TRUE);
    }
    else
    {
        Super.HandleWalking();
    }
}
public event function HenchmanOrderAttackTarget(Pawn oHenchman, Actor oTargetActor, optional ECommandInputMethod eInputMethod = 0)
{
    GenerateTutorialEvent(16);
    GiveHenchmanOrder(oHenchman, 3, oTargetActor, vect(0.0, 0.0, 0.0), , , , eInputMethod);
}
public event function HenchmanOrderFollow(Pawn oHenchman, optional ECommandInputMethod eInputMethod = 0)
{
    GiveHenchmanOrder(oHenchman, 4, None, vect(0.0, 0.0, 0.0), , , , eInputMethod);
}
public event function HenchmanOrderHoldPosition(Pawn oHenchman, Vector vLocation, optional ECommandInputMethod eInputMethod = 0)
{
    GenerateTutorialEvent(16);
    GiveHenchmanOrder(oHenchman, 5, None, vLocation, , , , eInputMethod);
}
public event function HenchmanOrderUsePower(Pawn oHenchman, Actor oTargetActor, Vector vTargetLocation, Name nmPower, int nQueue, optional ECommandInputMethod eInputMethod = 0)
{
    GiveHenchmanOrder(oHenchman, 1, oTargetActor, vTargetLocation, nmPower, None, nQueue, eInputMethod);
}
public native function InitializeGammaCorrectionSettings();

public native function bool IsCombatTargetable(Actor A);

public native function bool IsExploreTargetable(Actor A);

public function bool IsLookInputIgnored()
{
    if (Pawn != None && Pawn.InFreeCam())
    {
        return FALSE;
    }
    return Super.IsLookInputIgnored();
}
public final event function bool IsPlayerPerformingBlockingAction()
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(Pawn);
    if (oPawn != None)
    {
        return oPawn.IsPerformingBlockingAction();
    }
    return FALSE;
}
public final function bool IsReloading()
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        return BioPawn.IsReloading(TRUE);
    }
    return FALSE;
}
public event function bool IsTestFrameworkSetupComplete()
{
    local SFXPawn_Player PlayerPawn;
    
    if (Pawn == None)
    {
        return FALSE;
    }
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn == None)
    {
        return TRUE;
    }
    return PlayerPawn.IsTestFrameworkSetupComplete();
}
public event function bool IsUseCasualAppearance()
{
    local SFXPawn_Player PlayerPawn;
    
    if (Pawn == None)
    {
        return FALSE;
    }
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn == None)
    {
        return FALSE;
    }
    return PlayerPawn.bUseCasualAppearance;
}
public final function bool IsUsingPower()
{
    return FALSE;
}
public final native function bool IsZoomed();

public final event function LeaveCover()
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None && (BioPawn.IsInCover() || BioPawn.CoverAction == ECoverAction.CA_Aimback))
    {
        BioPawn.LeaveCover();
        GotoState('PlayerWalking', , , );
    }
}
public final native function int LerpMovementStickAngle(int RotDesired, int RotBase, float RotationSpeed, float DeltaSeconds);

public native function LoadPCInputConfiguration();

public event function LockAccomplishment(Name AccomplishmentName);

public event function OnActionStateChanged();

public delegate function OnResumeGameComplete(bool bWasSuccessful);

public event function OnStormStart()
{
    if (BioPawn(Pawn).bAllowSuperStormSpeed)
    {
        BioPawn(Pawn).StormSpeedScale = BioPawn(Pawn).StormStartSpeed;
    }
    BioPawn(Pawn).SetShouldCrouch(FALSE);
    if (IsLocalPlayerController())
    {
        SetTimer(StormCoverUpdateDelay, TRUE, 'CheckStormToCover', );
        SetRotation(PlayerCamera.CameraCache.POV.Rotation + Rotator(BioPlayerInput(PlayerInput).MoveStick));
    }
}
public event function OnStormStop()
{
    bStormCoolingDown = TRUE;
    SetTimer(StormCooldownTime, FALSE, 'ResetStormCooldown', );
    bCancelStorm = TRUE;
    ClearTimer('CheckStormToCover');
}
public delegate function PauseOnExternalUIState()
{
    if (bIsExternalUIOpen)
    {
        SetPause(bIsExternalUIOpen, CanUnpauseExternalUI);
    }
}
public event function PlayerTick(float DeltaTime)
{
    local BioPawn BP;
    
    Super.PlayerTick(DeltaTime);
    BP = BioPawn(Pawn);
    if (BP != None)
    {
        if (BP.CurrentCustomAction == 132)
        {
            if (BP.CurrentPowerCustomAction != 0 && BP.PowerCustomActions[BP.CurrentPowerCustomAction] != None)
            {
                BP.PowerCustomActions[BP.CurrentPowerCustomAction].TickInput(BioPlayerInput(PlayerInput), DeltaTime);
            }
        }
        else if (BP.CurrentCustomAction != 0 && BP.CustomActions[BP.CurrentCustomAction] != None)
        {
            BP.CustomActions[BP.CurrentCustomAction].TickInput(BioPlayerInput(PlayerInput), DeltaTime);
        }
        if (BP.bAllowSuperStormSpeed == TRUE && BP.bStorming)
        {
            BP.StormSpeedScale = FClamp(BP.StormSpeedScale + DeltaTime / BP.StormSpeedScaleTime, 0.0, 1.0);
        }
        else
        {
            BP.StormSpeedScale = 1.0;
        }
        TickCoverVisualization();
        if (BP.IsLocallyControlled())
        {
            TickJumpDown();
        }
    }
}
public function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local BioTriggerStream V;
    local BioBaseSquad PlayerSquad;
    local BioWorldInfo oBioWorldInfo;
    
    Super.Possess(aPawn, bVehicleTransition);
    foreach AllActors(Class'BioTriggerStream', V, )
    {
        if (V.Encompasses(aPawn))
        {
            V.Touch(aPawn, None, aPawn.RelativeLocation, aPawn.RelativeLocation);
        }
    }
    if (aPawn != None)
    {
        if (SFXPawn_Player(aPawn) != None)
        {
            PlayerSquad = SFXGame(WorldInfo.Game).PlayerSquad;
            oBioWorldInfo = BioWorldInfo(WorldInfo);
            if (oBioWorldInfo != None)
            {
                if (oBioWorldInfo.m_playerSquad == None)
                {
                    oBioWorldInfo.m_playerSquad = PlayerSquad;
                }
            }
            PlayerSquad.AddMember(aPawn);
            UpdateSquadPlayerPawn(BioPlayerSquad(PlayerSquad), BioPawn(aPawn));
        }
    }
}
public event simulated function PostBeginPlay()
{
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = GetModule(Class'SFXModule_AimAssist');
    Super.PostBeginPlay();
    InitializeGammaCorrectionSettings();
    GameModeManager2 = new (Self) Class'SFXGameModeManager';
    GameModeManager2.Initialize();
    if (!Class'SFXGameConfig'.default.bAimAssistEnabled)
    {
        RemoveSFXModule(AimAssist);
    }
}
public event function PreClientTravel(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
    if (!Class'WorldInfo'.static.IsMenuLevel())
    {
        SaveProfile();
    }
    Super.PreClientTravel(PendingURL, TravelType, bIsSeamlessTravel);
}
public native function QueueDamageIndicator(Pawn oPawn);

public final native function bool QuickCommandAttackTarget(optional int nSquadIndex = -1, optional ECommandInputMethod eInputMethod = 0, optional Actor pDesiredTarget);

public final native function bool QuickCommandCoverPlayer(int nSquadIndex, optional ECommandInputMethod eInputMethod = 0);

public final native function bool QuickCommandFollowPlayer(optional int nSquadIndex = -1, optional ECommandInputMethod eInputMethod = 0);

public final native function bool QuickCommandMoveTo(int nSquadIndex, optional ECommandInputMethod eInputMethod = 0, optional Vector vDesiredTargetLocation);

public native function RecoverCameraPostCinematic();

public native function RefreshRadarData();

public function Reset()
{
    Super.Reset();
    m_bPermanentWalk = FALSE;
}
public final native function ResetGoalPriorities(SFXNav_GoalPoint oGoal);

public event function ResetPlayerController()
{
    local Vector NewLocation;
    
    if (Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (Pawn != None)
    {
        NewLocation = Pawn.location;
    }
    else
    {
        NewLocation = location;
    }
    Internal_ResetPlayerController(NewLocation);
    ClientResetPlayerController(NewLocation.X, NewLocation.Y, NewLocation.Z);
}
public event function RestoreHenchmenPowers()
{
    local SFXPawn_Player PlayerPawn;
    local int SquadIdx;
    local SFXPawn_Henchman Hench;
    local SFXEngine Engine;
    local SFXPowerCustomActionBase oPowerBase;
    
    PlayerPawn = SFXPawn_Player(Pawn);
    Engine = SFXEngine(Player.Outer);
    if (PlayerPawn != None)
    {
        if (PlayerPawn.Squad != None)
        {
            for (SquadIdx = 0; SquadIdx < PlayerPawn.Squad.Members.Length; ++SquadIdx)
            {
                Hench = SFXPawn_Henchman(PlayerPawn.Squad.Members[SquadIdx]);
                if (Hench != None)
                {
                    Hench.PowerManager.SetSharedCooldown(0.0);
                    foreach Hench.PowerManager.Powers(oPowerBase, )
                    {
                        oPowerBase.CurrentCooldownTime = 0.0;
                        oPowerBase.TotalCooldownTime = 0.0;
                    }
                    Hench.SetPowerStartingRanks();
                    if (Engine != None && Engine.CurrentSaveGame != None)
                    {
                        Engine.CurrentSaveGame.LoadPawnPowers(Hench);
                    }
                }
            }
        }
    }
}
public event function RestoreMotionBlur()
{
    EnableMotionBlur(ProfileSettings.GetMotionBlurConfigOption());
}
public event function RestorePlayerAndSquad(bool bHolsterWeapon, bool bDisableAI, bool bResetHenchmenAI, bool bTeleport)
{
    local SFXPawn_Player PlayerPawn;
    local BioPawn SquadPawn;
    local int SquadIdx;
    local SFXAI_Henchman Henchman;
    
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn != None)
    {
        PlayerPawn.RecoverFromBleedout(FALSE);
        if (PlayerPawn.Squad != None)
        {
            for (SquadIdx = 0; SquadIdx < PlayerPawn.Squad.Members.Length; ++SquadIdx)
            {
                SquadPawn = BioPawn(PlayerPawn.Squad.Members[SquadIdx]);
                if (SquadPawn != None)
                {
                    if (bTeleport)
                    {
                        SquadPawn.SetActive(TRUE);
                    }
                    SquadPawn.EnsurePawnIsUpright(bResetHenchmenAI, bTeleport);
                    if (bDisableAI)
                    {
                        Henchman = SFXAI_Henchman(SquadPawn.Controller);
                        if (Henchman != None)
                        {
                            Henchman.EnableAI(FALSE, 2);
                        }
                    }
                }
            }
        }
    }
}
public final function SaveGame(int SaveIndex, optional delegate<SFXEngine.SFXSaveCommandCallback> Callback)
{
    local SFXSaveDescriptor SaveDescriptor;
    
    SaveDescriptor.Index = SaveIndex;
    SaveGameEx(SaveDescriptor, Callback);
}
public native function SavePCInputConfiguration(SFXProfileSettings Profile);

public event function SaveProfile(optional bool checkForDelay = TRUE, optional bool bUpdateProfileSettingsCache = TRUE)
{
    local LocalPlayer LP;
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;
    local SFXOnlineSubsystem SFXOnlineSub;
    
    LP = LocalPlayer(Player);
    if (LP != None)
    {
        if (OnlineSub != None)
        {
            PlayerInt = OnlineSub.PlayerInterface;
            if (PlayerInt != None)
            {
                ControllerId = LP.ControllerId;
                if (ControllerId != -1 && Class'UIInteraction'.static.IsLoggedIn(ControllerId))
                {
                    SFXOnlineSub = SFXOnlineSubsystem(OnlineSub);
                    if (!checkForDelay || SFXOnlineSub != None && SFXOnlineSub.GetComponentGame().PerformCallRestrictedFunction())
                    {
                        if (PlayerInt.WriteProfileSettings(byte(ControllerId), ProfileSettings) == FALSE)
                        {
                        }
                    }
                }
            }
        }
    }
    if (bUpdateProfileSettingsCache)
    {
        UpdateLocalProfileSettingsCache();
    }
    SetRichPresence();
}
public event function SawFirstEnemy()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        InternalSawFirstEnemy();
    }
    else
    {
        ServerSawFirstEnemy();
    }
}
public event function SawNewEnemy(const out LocalEnemy CurEnemy)
{
    local BioPawn EnemyPawn;
    
    EnemyPawn = BioPawn(CurEnemy.Enemy);
    if (EnemyPawn != None)
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            InternalSawNewEnemy(EnemyPawn);
        }
        else
        {
            ServerSawNewEnemy(EnemyPawn);
        }
    }
}
public native function float ScoreZoomSnapTarget(Pawn TestPawn, float MaxDistance, const out Vector CamLoc, const out Rotator CamRot, out Vector AimLocation);

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
    else if (int(PendingAdjustment.bWarning) == 1)
    {
        SFXWarnAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z);
    }
    else if (PendingAdjustment.NewVel == vect(0.0, 0.0, 0.0))
    {
        SFXShortClientAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z);
    }
    else
    {
        SFXClientAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z);
    }
    PendingAdjustment.TimeStamp = 0.0;
    PendingAdjustment.bAckGoodMove = 0;
}
public native function ServerExecuteMove(SavedMove Move);

public final native function ServerExecuteMove_AimBack(SavedMove Move);

public final native function ServerExecuteMove_Cover(SavedMove Move);

public final native function ServerExecuteMove_RootMotion(SavedMove Move);

public final native function ServerUpdateClientCorrection(Vector ClientLocation, optional bool bForceCorrection);

public event function SetAccomplishmentProgression(Name AccomplishmentProgressName, int Progress, optional bool IsOnlyIncreasing = TRUE, optional BioPawn oTarget)
{
    local int UniqueId;
    
    if (oTarget == None || m_AccomplishmentTargets.Find(oTarget) < 0)
    {
        UniqueId = SFXEngine(Class'Engine'.static.GetEngine()).GetSFXUniqueIDFromStr(string(AccomplishmentProgressName));
        if (UniqueId != 0)
        {
            ClientSetAccomplishmentProgression(UniqueId, Progress, IsOnlyIncreasing);
        }
        if (oTarget != None)
        {
            m_AccomplishmentTargets.AddItem(oTarget);
        }
    }
}
public function SetInputDisabled(bool bVal)
{
    local BioPlayerInput oInput;
    
    oInput = BioPlayerInput(PlayerInput);
    if (oInput != None)
    {
        oInput.SetInputDisabled(bVal);
    }
}
public native function SetPostProcessValues(ETVType Preset);

public event function SetRichPresence()
{
    local array<LocalizedStringSetting> aContexts;
    local LocalizedStringSetting Context;
    local array<SettingsProperty> aProperties;
    local SettingsProperty Property;
    local LocalPlayer LocPlayer;
    local int nPresenceMode;
    local SFXGUIInteraction oGuiInteraction;
    
    if (OnlineSub != None && OnlineSub.PlayerInterface != None)
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != None)
        {
            oGuiInteraction = Class'SFXGUIInteraction'.static.GetInstance();
            if (oGuiInteraction.GetMovie(Self, oGuiInteraction.MovieTag_MainMenu) != None || SFXPawn_PlayerParty(Pawn) == None)
            {
                nPresenceMode = 1;
            }
            else
            {
                nPresenceMode = 0;
                Context.Id = 1;
                Context.ValueIndex = GetRichPresenceClassContextID();
                Context.AdvertisementType = EOnlineDataAdvertisementType.ODAT_OnlineService;
                aContexts.AddItem(Context);
                Context.Id = 2;
                if (ProfileSettings != None)
                {
                    Context.ValueIndex = int(ProfileSettings.GetDifficultyConfigOption());
                }
                else
                {
                    Context.ValueIndex = 2;
                }
                aContexts.AddItem(Context);
                Property.PropertyId = 268435458;
                Class'Settings'.static.SetSettingsDataInt(Property.Data, SFXPawn_PlayerParty(Pawn).CharacterLevel);
                Property.AdvertisementType = EOnlineDataAdvertisementType.ODAT_OnlineService;
                aProperties.AddItem(Property);
            }
            OnlineSub.PlayerInterface.SetOnlineStatus(byte(LocPlayer.ControllerId), nPresenceMode, aContexts, aProperties);
        }
    }
    SetRichPresenceForIdlePlayers();
}
public event function SetZoomed(bool bZoomState)
{
    local SFXWeapon Weapon;
    local SFXModule_AimAssist AimAssist;
    
    Weapon = SFXWeapon(Pawn.Weapon);
    if (Weapon != None)
    {
        Weapon.SetZoomed(bZoomState);
    }
    if (bZoomState)
    {
        AimAssist = GetModule(Class'SFXModule_AimAssist');
        if (AimAssist != None)
        {
            AimAssist.ZoomSnap();
        }
    }
    BioPawn(Pawn).bIsSniping = bZoomState;
}
public event reliable client function ShippingClientMessage(coerce string S, optional Name Type, optional float MsgLifeTime)
{
    if (myHUD != None)
    {
        myHUD.Message(PlayerReplicationInfo, S, Type, MsgLifeTime);
    }
}
public final native function bool ShouldLockOnTarget(Actor pTarget);

public event function SpawnPlayerCamera()
{
    Super.SpawnPlayerCamera();
    if (LocalPlayer(Player) != None)
    {
        BioWorldInfo(WorldInfo).SetRenderStateOfPlayerToDefault(0);
    }
}
public event function SquadDrawWeapons()
{
    local int nIndex;
    local BioPawn SquadMember;
    local BioPawn MyBioPawn;
    
    if (Vehicle(Pawn) != None)
    {
        MyBioPawn = BioPawn(Vehicle(Pawn).Driver);
    }
    else
    {
        MyBioPawn = BioPawn(Pawn);
    }
    if (MyBioPawn == None || MyBioPawn.Squad == None)
    {
        return;
    }
    for (nIndex = 0; nIndex < MyBioPawn.Squad.Members.Length; nIndex++)
    {
        SquadMember = BioPawn(MyBioPawn.Squad.Members[nIndex]);
        if (SquadMember != None && MyBioPawn.bCombatPawn)
        {
            SFXInventoryManager(SquadMember.InvManager).SetWeaponBySelected();
            continue;
        }
        if (SquadMember != None)
        {
            if (SquadMember == MyBioPawn)
            {
                SFXInventoryManager(SquadMember.InvManager).SetCurrentWeapon(None);
            }
        }
    }
}
public final native function SquadOrderEquipWeapon(byte nWeapon, Pawn pPawn);

public final native function bool SquadOrderUsePower(Name nmPower, Pawn pPawn, optional int nQueue = 0, optional bool bShowIndicator = TRUE, optional Actor pDesiredSelectionTarget, optional ECommandInputMethod eInputMethod = 0, optional Actor pDesiredTarget, optional Vector vDesiredTargetLocation);

public function bool StartCustomAction(int NewAction, optional BioPawn Sync, optional bool bForced, optional int NewPowerAction)
{
    local BioPawn PawnAsBioPawn;
    local BioCustomAction oAction;
    local bool bCanStartCustomAction;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None)
    {
        return FALSE;
    }
    if (PawnAsBioPawn.VerifyCAHasBeenInstanced(NewAction, NewPowerAction))
    {
        if (NewAction == 132)
        {
            oAction = PawnAsBioPawn.PowerCustomActions[NewPowerAction];
        }
        else
        {
            oAction = PawnAsBioPawn.CustomActions[NewAction];
        }
    }
    if (oAction == None)
    {
        return FALSE;
    }
    if (Role == ENetRole.ROLE_AutonomousProxy && RemotePlayerPendingCustomAction != 0)
    {
        return FALSE;
    }
    if (Role == ENetRole.ROLE_Authority || Role == ENetRole.ROLE_AutonomousProxy && oAction.bClientPredictCustomAction)
    {
        bCanStartCustomAction = PawnAsBioPawn.StartCustomAction(NewAction, Sync, bForced, NewPowerAction);
    }
    else
    {
        bCanStartCustomAction = PawnAsBioPawn.CanDoCustomAction(NewAction, Sync, bForced, NewPowerAction);
    }
    if (bCanStartCustomAction == TRUE && Role == ENetRole.ROLE_AutonomousProxy)
    {
        oAction.ServerStartCustomAction(NewAction, Sync, NewPowerAction);
        if (!oAction.bClientPredictCustomAction)
        {
            RemotePlayerPendingCustomAction = NewAction;
            RemotePlayerPendingPowerCustomAction = 0;
            SetTimer(ClientTimeoutForPendingCustomActionReset, FALSE, 'RemotePlayerResetPendingCustomActionInfo', );
        }
    }
    return bCanStartCustomAction;
}
public event function SwitchWeapon(SFXWeapon_NativeBase oWpn)
{
    local SFXInventoryManager oInventory;
    local BioPawn PlayerPawn;
    local SFXHeavyWeapon HWeapon;
    
    PlayerPawn = BioPawn(Pawn);
    if (PlayerPawn != None)
    {
        oInventory = SFXInventoryManager(PlayerPawn.InvManager);
        if (oInventory != None)
        {
            oInventory.SetWeaponIfAvailable(SFXWeapon(oWpn));
        }
        HWeapon = SFXHeavyWeapon(Pawn.Weapon);
        if (HWeapon != None)
        {
            HWeapon.PutDownWeapon();
        }
        if (PlayerPawn.IsInCoverLeaning())
        {
            PlayerPawn.CoverAction = PlayerPawn.GetDefaultCoverAction();
        }
    }
}
public event function TriggerCoverPlayerFailedVocalization(BioPawn Henchman)
{
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(2, Henchman, , , , TRUE);
}
public event function UnlockAccomplishment(Name AccomplishmentName)
{
    local int UniqueId;
    
    UniqueId = SFXEngine(Class'Engine'.static.GetEngine()).GetSFXUniqueIDFromStr(string(AccomplishmentName));
    if (UniqueId != 0)
    {
        ClientUnlockAccomplishment(UniqueId);
    }
}
public event function UnlockAchievement(int AchivementID)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None)
    {
        return;
    }
}
public event function UpdateAccomplishmentProgression(Name AccomplishmentProgressName, optional BioPawn oTarget)
{
    local int UniqueId;
    
    if (oTarget == None || m_AccomplishmentTargets.Find(oTarget) < 0)
    {
        UniqueId = SFXEngine(Class'Engine'.static.GetEngine()).GetSFXUniqueIDFromStr(string(AccomplishmentProgressName));
        if (UniqueId != 0)
        {
            ClientUpdateAccomplishmentProgression(UniqueId);
        }
        if (oTarget != None)
        {
            m_AccomplishmentTargets.AddItem(oTarget);
        }
    }
}
public native function UpdateBinkAudioVolume();

public final native function UpdateEnemyList();

public event function UpdateLocalProfileSettingsCache()
{
    local SFXPRI PRI;
    local SFXGRI GRI;
    local LocalPlayer LP;
    local SFXPawn_Player PlayerPawn;
    local BioAiController SquadController;
    local SFXPawn_PlayerParty SquadMember;
    
    if (ForceFeedbackManager != None)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild() && ProfileSettings != None)
        {
            ForceFeedbackManager.bAllowsForceFeedback = ProfileSettings.GetControllerVibrationOption();
        }
        else
        {
            ForceFeedbackManager.bAllowsForceFeedback = FALSE;
        }
    }
    PRI = SFXPRI(PlayerReplicationInfo);
    if (PRI != None && ProfileSettings != None)
    {
        LP = LocalPlayer(Player);
        PlayerInput.bInvertMouse = ProfileSettings.GetInvertYOption();
        PRI.ControllerSensitivityConfig = ProfileSettings.GetControllerSensitivityValue();
        PRI.TriggerConfig = ProfileSettings.GetTriggerConfigOption();
        PRI.StickConfig = ProfileSettings.GetStickConfigOption();
        PRI.bSwapCrossCircle = ProfileSettings.GetSwappedCrossCircle();
        PRI.bSwapTriggersShoulders = ProfileSettings.GetSwappedTriggersShoulders();
        UpdateInputConfiguration();
        UpdateUIProfileSettings(ProfileSettings);
        SetShowSubtitles(ProfileSettings.GetSubtitleConfigOption());
        PRI.AimAssistConfig = ProfileSettings.GetAimAssistValue();
        PRI.bHideCinematicHelmetPreference = ProfileSettings.GetHideCinematicHelmet();
        PRI.HenchmenHelmetPreference = ProfileSettings.GetHenchmenHelmetOption();
        PRI.AutoLevelUp = ProfileSettings.GetAutoLevelConfigOption();
        PRI.bSquadUsesPowers = ProfileSettings.GetSquadPowerConfigOption();
        PRI.bAutoSave = ProfileSettings.GetAutoSaveConfigOption();
        PRI.bAutoLogin = ProfileSettings.GetAutoLoginConfigOption();
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Volume_Music", float(ProfileSettings.GetMusicVolume()) * 0.00999999978);
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Volume_Sound_Effects", float(ProfileSettings.GetFXVolume()) * 0.00999999978);
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Volume_Dialog", float(ProfileSettings.GetDialogVolume()) * 0.00999999978);
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Dynamic_Range_Setting", float(ProfileSettings.GetAudioDynamicRangeOption()));
        UpdateBinkAudioVolume();
        EnableMotionBlur(ProfileSettings.GetMotionBlurConfigOption());
        EnableFilmgrain(ProfileSettings.GetFilmgrainConfigOption());
        if (LP != None)
        {
            LP.BioRecalculatePostProcessEffects();
        }
        GRI = SFXGRI(WorldInfo.GRI);
        if (GRI != None && GRI.bMultiplayer == FALSE)
        {
            GRI.DifficultyHandler.CurrentDifficulty = ProfileSettings.GetDifficultyConfigOption();
            GRI.DifficultyHandler.bNeedsUpdate = TRUE;
            GRI.DifficultyHandler.Update();
        }
        PlayerPawn = SFXPawn_Player(Pawn);
        if (PlayerPawn != None)
        {
            foreach PlayerPawn.Squad.SquadMembers(SquadController)
            {
                SquadMember = SFXPawn_PlayerParty(SquadController.Pawn);
                if (SquadMember != None)
                {
                    SquadMember.InitDefaultHelmetState();
                }
            }
        }
        bProfileSettingsUpdated = FALSE;
    }
}
public native function bool UpdateMoveToIndicator(Pawn pSquadPawn, Vector vMoveToPosition);

public native function ValidateCinematicModeOff();

public final native function bool ValidatePotentialCover(Vector SourceLoc, Vector Direction, bool OnlyIfBetter, float MaxHeightFactor, out float OutMinDotFOV, out float OutMaxDistanceSquared, out CovPosInfo OutCovPosInfo);

public function AcknowledgePossession(Pawn P)
{
    local Actor A;
    local int i;
    local SeqEvent_Touch TouchEvent;
    
    Super.AcknowledgePossession(P);
    if (P != None)
    {
        P.Controller = Self;
        Pawn = P;
        foreach P.TouchingActors(Class'Actor', A, )
        {
            for (i = 0; i < A.GeneratedEvents.Length; i++)
            {
                TouchEvent = SeqEvent_Touch(A.GeneratedEvents[i]);
                if (TouchEvent != None && (TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerOnly || TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerAndSquad || TouchEvent.WhoTriggers == EWhoTriggers.WT_PlayerOnlyLocal))
                {
                    TouchEvent.CheckTouchActivate(A, P);
                }
            }
        }
    }
}
public function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    if (OldMove != None)
    {
        SendServerMove(OldMove, vect(1.0, 2.0, 3.0), ClientRoll, View, None);
        OldMove = None;
    }
    if (PendingMove != None)
    {
        SendServerMove(PendingMove, vect(1.0, 2.0, 3.0), ClientRoll, View, None);
        PendingMove = None;
    }
    SendServerMove(NewMove, ClientLoc, ClientRoll, View, OldMove);
}
public function bool CanRestartPlayer()
{
    return Super.CanRestartPlayer();
}
public reliable client function ClientSetHUD(Class<HUD> newHUDType, Class<Scoreboard> newScoringType)
{
    local SFXGUIInteraction oInteraction;
    
    Super.ClientSetHUD(newHUDType, newScoringType);
    oInteraction = Class'SFXGUIInteraction'.static.GetInstance();
    if (oInteraction != None)
    {
        oInteraction.InitializeStartupGuiForPlayer(Self, newHUDType);
    }
}
public reliable client function ClientSetOnlineStatus()
{
    SetRichPresence();
}
public function ClientUpdatePosition()
{
    local SavedMove CurrentMove;
    local int realbRun;
    local int realbDuck;
    local bool bRealJump;
    local byte bRealStorm;
    local bool bRealCancelStorm;
    local bool bRealPreciseDestination;
    local bool bRealForceMaxAccel;
    local bool bRealRootMotionFromInterpCurve;
    local ERootMotionMode RealRootMotionMode;
    
    if (!bUsePackedMoves)
    {
        Super.ClientUpdatePosition();
        return;
    }
    bUpdatePosition = FALSE;
    if (Pawn != None && Pawn.Physics == EPhysics.PHYS_RigidBody)
    {
        return;
    }
    realbRun = int(bRun);
    realbDuck = int(bDuck);
    bRealJump = bPressedJump;
    bRealStorm = bWantsToStorm;
    bRealCancelStorm = bCancelStorm;
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
        BioMoveAutonomous(CurrentMove.Delta, rot(0, 0, 0), CurrentMove);
        CurrentMove.ResetMoveFor(Pawn);
        CurrentMove = CurrentMove.NextMove;
    }
    bUpdating = FALSE;
    bDuck = byte(realbDuck);
    bRun = byte(realbRun);
    bPressedJump = bRealJump;
    bWantsToStorm = bRealStorm;
    bCancelStorm = bRealCancelStorm;
    bPreciseDestination = bRealPreciseDestination;
    if (Pawn != None)
    {
        Pawn.bForceMaxAccel = bRealForceMaxAccel;
        Pawn.bRootMotionFromInterpCurve = bRealRootMotionFromInterpCurve;
        Pawn.Mesh.RootMotionMode = RealRootMotionMode;
    }
}
public function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = GetModule(Class'SFXModule_AimAssist');
    if (AimAssist != None && IsZoomed())
    {
        return AimAssist.GetAdjustedAimFor(W, StartFireLoc);
    }
    else
    {
        return Pawn != None ? Pawn.GetBaseAimRotation() : Rotation;
    }
}
public function HandlePickup(Inventory Inv);

public simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx)
{
    local BioPawn MyPawn;
    
    if (!bAdjacentIdx)
    {
        MyPawn = BioPawn(Pawn);
        if (MyPawn != None)
        {
            MyPawn.LeaveCover();
            if (MyPawn.Role == ENetRole.ROLE_Authority)
            {
                if (MyPawn.RequestReaction(2, Self))
                {
                    MyPawn.ReplicateAnimatedReaction(MyPawn.CurrentCustomAction);
                }
            }
        }
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum);

public function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LP;
    local BioMessageBoxOptionalParams stParams;
    local bool bSplashScreen;
    
    bSplashScreen = Class'SFXGUIInteraction'.static.GetInstance().IsInSplashScreen();
    LP = LocalPlayer(Player);
    if (LP != None && LP.ControllerId == ControllerId && WorldInfo.IsConsoleBuild() && (!WorldInfo.IsConsoleBuild(1) || !bSplashScreen) && (WorldInfo.Game == None || !WorldInfo.Game.IsAutomatedPerfTesting()))
    {
        bIsControllerConnected = bIsConnected;
        if (WorldInfo.IsConsoleBuild(2) || WorldInfo.IsConsoleBuild(1))
        {
            if (!bIsConnected)
            {
                stParams.bModal = TRUE;
                stParams.bNoFade = TRUE;
                stParams.bForcePlayersOnly = WorldInfo.Game.bPauseable;
                Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('ControllerRemoved', 2, ControllerRemoved, stParams, None, 0, Self, TRUE);
            }
            else
            {
                Class'SFXGUIInteraction'.static.GetInstance().RemoveNamedMessageBox('ControllerRemoved', Self);
            }
        }
        else
        {
            SetPause(!bIsConnected, CanUnpauseControllerConnected);
        }
    }
}
public function OnExternalUIChanged(bool bIsOpening)
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    bIsExternalUIOpen = bIsOpening;
    if (oEngine != None && oEngine.LoadMovieManager.IsLoadingMoviePlaying())
    {
        if (bIsExternalUIOpen)
        {
            oEngine.LoadMovieManager.RegisterDelegate(0, PauseOnExternalUIState);
        }
        else
        {
            oEngine.LoadMovieManager.RegisterDelegate(0, None);
        }
    }
    else if (!bIsExternalUIOpen || Class'WorldInfo'.static.IsConsoleBuild() || !Class'SFXGUIInteraction'.static.GetInstance().IsInSplashScreen())
    {
        SetPause(bIsExternalUIOpen, CanUnpauseExternalUI);
    }
}
public function PawnDied(Pawn inPawn)
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(inPawn);
    if (BioPawn != None && BioPawn.IsInCover())
    {
        BioPawn.CurrentLink.UnClaim(Pawn, -1, TRUE);
    }
    Super.PawnDied(inPawn);
}
public function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
    local SFXModule_AimAssist AimAssist;
    local SFXWeapon Weapon;
    
    AimAssist = GetModule(Class'SFXModule_AimAssist');
    Weapon = Pawn != None ? SFXWeapon(Pawn.Weapon) : None;
    if (Weapon != None && AimAssist != None)
    {
        AimAssist.CacheCurrentAimAssistTarget();
    }
    if (AimAssist != None)
    {
        AimAssist.ProcessRotation(DeltaTime, DeltaRot);
    }
    Super.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
}
public exec function QuickLoad()
{
    local SFXEngine Engine;
    local SFXSaveDescriptor SaveDescriptor;
    
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        SaveDescriptor = Engine.GetCurrentSaveDescriptor();
        Engine.QueueSaveGameCommand(1, SaveDescriptor, Engine.LoadSaveFromCallback);
    }
}
public exec function QuickSave()
{
    local SFXEngine Engine;
    local string Reason;
    local SFXSaveDescriptor SaveDescriptor;
    
    Engine = SFXEngine(Player.Outer);
    if (Engine != None && CanSave(Reason))
    {
        Engine.bCanWriteSaveToStorage = TRUE;
        SaveDescriptor.Type = ESFXSaveGameType.SaveGameType_Quick;
        SaveGameEx(SaveDescriptor);
    }
}
protected simulated function RegisterCustomPlayerDataStores()
{
    if (ProfileSettings != None)
    {
        UnregisterPlayerDataStores();
    }
    Super.RegisterCustomPlayerDataStores();
}
public function RegisterOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local LocalPlayer LocPlayer;
    
    Super.RegisterOnlineDelegates();
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != None && OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.AddLoginChangeDelegate(NotifyLoginChange);
            PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(LocPlayer.ControllerId), NotifyProfileReadComplete);
        }
        OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(StorageDeviceChanged);
    }
}
public function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    local SavedMove NewMove;
    local SavedMove LastMove;
    local SavedMoveReplicationInfo RepMoves;
    
    if (!bUsePackedMoves)
    {
        Super.ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        return;
    }
    if (Player == None)
    {
        return;
    }
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    DeltaTime = (Pawn != None ? Pawn.CustomTimeDilation : CustomTimeDilation) * FMin(DeltaTime, MaxResponseTime);
    NewMove = GetFreeMove();
    if (NewMove == None)
    {
        return;
    }
    NewMove.SetMoveFor(Self, DeltaTime, newAccel, DoubleClickMove);
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    if (Pawn != None)
    {
        Pawn.AutonomousPhysics(NewMove.Delta);
    }
    else
    {
        AutonomousPhysics(NewMove.Delta);
    }
    NewMove.PostUpdate(Self);
    if (SavedMoves == None)
    {
        SavedMoves = NewMove;
    }
    else
    {
        LastMove = SavedMoves;
        while (LastMove.NextMove != None)
        {
            LastMove = LastMove.NextMove;
        }
        LastMove.NextMove = NewMove;
    }
    ClientUpdateTime = WorldInfo.TimeSeconds;
    if (SavedMoves != None && NumberOfFrameSinceLastMoveRep >= MOVEREP_DELAY_FRAME)
    {
        RepMoves.PC = Self;
        RepMoves.ReplicatedMoves = SFXSavedMove(SavedMoves);
        if (int(PendingAdjustment.bWarning) != 0)
        {
            if (ComputeClientLocationError(PendingAdjustment.NewLoc, Pawn != None ? Pawn.location : location) > BIO_WARNING_MAX_POSITION_ERROR_SQUARED)
            {
                RepMoves.bForceNewLocation = TRUE;
                RepMoves.ForcedLocation = Pawn != None ? Pawn.location : location;
            }
            PendingAdjustment.bWarning = 0;
        }
        BioServerMove(RepMoves, Pawn == None ? location : Pawn.location);
        NumberOfFrameSinceLastMoveRep = 0;
    }
    else
    {
        NumberOfFrameSinceLastMoveRep++;
    }
}
public function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, optional SeqAct_ToggleCinematicMode SFXAction)
{
    local int Cnt;
    local BioPawn PlayerPawn;
    local BioPawn SquadPawn;
    local SFXAI_NativeBase SquadAI;
    local BioSeqAct_BioToggleCinematicMode BioCineAction;
    local BioWorldInfo BioInfo;
    
    Super.SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons, SFXAction);
    BioCineAction = BioSeqAct_BioToggleCinematicMode(SFXAction);
    if (BioCineAction != None && BioCineAction.bCinematicInputMode)
    {
        BioInfo = BioWorldInfo(WorldInfo);
        if (BioInfo != None)
        {
            BioInfo.m_bCinematicSkip = FALSE;
            BioInfo.m_bDisableCinematicSkip = BioCineAction.bDisableCinematicSkip;
            BioInfo.m_sCinematicSkipEvent = BioCineAction.sSkipEvent;
            BioInfo.SetRenderStateOfPlayerToDefault(0);
        }
    }
    if (bInCinematicMode && GameModeManager2.IsActive(8) == FALSE)
    {
        GameModeManager2.EnableMode(8);
        RestorePlayerAndSquad(TRUE, TRUE, FALSE, FALSE);
        EnableMotionBlur(FALSE);
        ProcessCinematicModeHelmetSettings(BioCineAction);
    }
    else if (bInCinematicMode == FALSE && GameModeManager2.IsActive(8))
    {
        ValidateCinematicModeOff();
        GameModeManager2.DisableMode(8);
        DisableDOF();
        RestoreMotionBlur();
        PlayerPawn = BioPawn(Pawn);
        if (PlayerPawn != None && PlayerPawn.Squad != None)
        {
            for (Cnt = 0; Cnt < PlayerPawn.Squad.Members.Length; Cnt++)
            {
                SquadPawn = BioPawn(PlayerPawn.Squad.Members[Cnt]);
                if (SquadPawn != None)
                {
                    SquadAI = SFXAI_NativeBase(SquadPawn.Controller);
                    if (SquadAI != None)
                    {
                        SquadAI.EnableAI(TRUE, 2);
                    }
                }
            }
        }
        if (Pawn != None && BioCineAction != None && BioCineAction.bCinematicInputMode)
        {
            SquadDrawWeapons();
        }
        ProcessCinematicModeHelmetSettings(BioCineAction);
    }
}
public simulated function UnregisterPlayerDataStores()
{
    ProfileSettings = None;
    Super.UnregisterPlayerDataStores();
}
public function AcquireCover(CovPosInfo CovInfo)
{
    local BioPawn PawnAsBioPawn;
    local byte SlotIdx;
    local float TimeStamp;
    
    PawnAsBioPawn = BioPawn(Pawn);
    SlotIdx = byte(CovInfo.LtToRtPct < 0.5 ? CovInfo.LtSlotIdx : CovInfo.RtSlotIdx);
    if (CovInfo.Link.IsValidClaim(PawnAsBioPawn, int(SlotIdx), TRUE, TRUE) == FALSE)
    {
        return;
    }
    Internal_AcquireCover(CovInfo, SlotIdx);
    if (PawnAsBioPawn != None && Role == ENetRole.ROLE_AutonomousProxy)
    {
        TimeStamp = float(Round(WorldInfo.TimeSeconds * float(1000))) * 0.00100000005;
        ServerAcquireCover(PawnAsBioPawn.CurrentLink, byte(PawnAsBioPawn.CurrentSlotIdx), byte(PawnAsBioPawn.LeftSlotIdx), byte(PawnAsBioPawn.RightSlotIdx), PawnAsBioPawn.CurrentSlotPct, PawnAsBioPawn.CoverDirection, TimeStamp);
    }
}
public function ActivateUseModule(Actor Selection)
{
    local SFXSimpleUseModule UseModule;
    
    if (Selection == None)
    {
        return;
    }
    UseModule = Selection.GetModule(Class'SFXSimpleUseModule');
    if (UseModule != None && UseModule.m_bTargetable == TRUE)
    {
        UseModule.__OnUsed__Delegate(Pawn);
    }
}
public unreliable server function AimBackServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag)
{
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (IsInState('PlayerInCover', ) == TRUE && ClientLoc != vect(1.0, 2.0, 3.0))
    {
        GotoState('PlayerInAimBack', , , );
    }
    StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, 'PlayerInAimBack');
}
public function bool AutoUseFromStorm()
{
    local SFXNav_LadderNode LadderNode;
    local Vector LadderDir;
    local SFXJumpReachSpec JumpSpec;
    local SFXLadderReachSpec LadderSpec;
    
    if (FindLadderNode(LadderSpec) && DetectPressInto(LadderSpec.Start.location, LadderSpec.End.Actor.location))
    {
        LadderNode = SFXNav_LadderNode(LadderSpec.Start);
        LadderDir = LadderNode.LadderDest.location - LadderNode.location;
        LadderDir.Z = 0.0;
        LadderDir = Normal(LadderDir);
        if (Vector(PlayerCamera.CameraCache.POV.Rotation) Dot LadderDir > 0.707000017 && VSize2D(LadderNode.location - Pawn.location) < float(250))
        {
            if (Role == ENetRole.ROLE_Authority)
            {
                LadderNode.TriggerEventClass(Class'SeqEvent_Used', Pawn);
                ActivateUseModule(LadderNode);
            }
            else
            {
                ServerUseSelection(LadderNode);
            }
            return TRUE;
        }
    }
    if (FindJumpPoint(JumpSpec))
    {
        CurrentPath = JumpSpec;
        StartCustomAction(28);
        return TRUE;
    }
    return FALSE;
}
public function BreakFromCover(optional Vector BreakDir);

public function bool CanQueueOrder()
{
    if (m_currentOrder.nmPower == 'None' && m_currentOrder.oSwitchWeapon == None)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool CanStartImmediateOrder()
{
    if (!IsDead() && !IsUsingPower())
    {
        if (m_currentOrder.nmPower == 'None' && m_currentOrder.oSwitchWeapon == None)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CanUseLadder(SFXNav_LadderNode LadderNode)
{
    local SFXLadderReachSpec LadderSpec;
    
    if (LadderNode == None)
    {
        return FALSE;
    }
    if (LadderNode.bDisabled)
    {
        return FALSE;
    }
    LadderSpec = SFXLadderReachSpec(LadderNode.GetReachSpecTo(LadderNode.LadderDest, Class'SFXLadderReachSpec'));
    if (LadderSpec != None && (LadderSpec.BlockingPawn == None || LadderSpec.BlockingPawn == Pawn))
    {
        return TRUE;
    }
    return FALSE;
}
public function CheckStormToCover()
{
    local BioPawn BP;
    
    if (!IsLocalPlayerController())
    {
        return;
    }
    BP = BioPawn(Pawn);
    if (BP != None && BP.bStorming && bNoCoverFromStorm == FALSE)
    {
        AutoUseFromStorm();
    }
}
public reliable client function ClientForceLocation(float NewLocX, float NewLocY, float NewLocZ)
{
    local Vector NewLocation;
    
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    ForceLocation(NewLocation);
}
public unreliable client function ClientInvalidCoverClaim()
{
    CleanOutSavedMoves();
    LeaveCover();
}
public reliable client function ClientLockAccomplishment(int AccomplishmentUniqueID);

public reliable client function ClientResetPlayerController(float NewLocX, float NewLocY, float NewLocZ)
{
    local Vector NewLocation;
    
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    Internal_ResetPlayerController(NewLocation);
}
public reliable client function ClientSetAccomplishmentProgression(int AccomplishmentUniqueID, int Progress, bool IsOnlyIncreasing)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local Name AccomplishmentProgressName;
    
    AccomplishmentProgressName = Name(SFXEngine(Class'Engine'.static.GetEngine()).GetStrFromSFXUniqueID(AccomplishmentUniqueID));
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None)
    {
        return;
    }
    if ((!IsOnlyIncreasing || Progress > AccomplishmentManager.GetGrinderAccomplishmentProgress(AccomplishmentProgressName, Self)) && AccomplishmentManager.SetGrinderAccomplishmentProgressWithUpdate(AccomplishmentProgressName, Progress, Self))
    {
        AccomplishmentManager.Save();
    }
}
public reliable client function ClientTestNameReplication(Name InName, string InConfirmString);

public reliable client function ClientUnlockAccomplishment(int AccomplishmentUniqueID)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local Name AccomplishmentName;
    
    AccomplishmentName = Name(SFXEngine(Class'Engine'.static.GetEngine()).GetStrFromSFXUniqueID(AccomplishmentUniqueID));
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None || AccomplishmentManager.HasCompletedAccomplishment(AccomplishmentName))
    {
        return;
    }
    if (AccomplishmentManager.SetAccomplishmentCompleted(AccomplishmentName, Self))
    {
        AccomplishmentManager.Save();
    }
}
public reliable client function ClientUpdateAccomplishmentProgression(int AccomplishmentUniqueID)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local Name AccomplishmentProgressName;
    
    AccomplishmentProgressName = Name(SFXEngine(Class'Engine'.static.GetEngine()).GetStrFromSFXUniqueID(AccomplishmentUniqueID));
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None)
    {
        return;
    }
    if (AccomplishmentManager.GrinderAccomplishmentIncrement(AccomplishmentProgressName, Self))
    {
        AccomplishmentManager.Save();
    }
}
public function CoverLog(string Msg, coerce string Function)
{
}
public unreliable server function CoverServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag, ECoverType InCoverType, ECoverAction InCoverAction, ECoverDirection InCoverDirection, ECoverDirection InCurrentSlotDirection, bool bInIsInstationaryCover)
{
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (IsInState('PlayerInAimBack', ) == TRUE && ClientLoc != vect(1.0, 2.0, 3.0))
    {
        GotoState('PlayerInCover', , , );
    }
    if (PawnAsBioPawn != None && PawnAsBioPawn.IsInCover())
    {
        SetPawnCoverType(InCoverType);
        SetPawnCoverAction(InCoverAction);
        SetCoverDirection(InCoverDirection);
        PawnAsBioPawn.CurrentSlotDirection = InCurrentSlotDirection;
        PawnAsBioPawn.bIsInStationaryCover = bInIsInstationaryCover;
    }
    StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, 'PlayerInCover');
}
public function DebugDraw_CoverCheck(BioHUD HUD)
{
    local float fMaxDistance;
    local Vector VDir;
    local Vector vLoc;
    local float fFov;
    local float fAngle;
    local Color clrCone;
    local CoverAcquisitionParams Params;
    
    if (BioPlayerInput(PlayerInput).LookStickMag > 0.800000012 && SFXPawn(Pawn).bStorming)
    {
        Params = DirectionalCoverAcquireParams;
    }
    else
    {
        Params = CoverAcquireParams;
    }
    if (IsZero(vLoc) == TRUE)
    {
        VDir = Vector(Pawn.Rotation);
        VDir.Z = 0.0;
        VDir = Normal(VDir);
    }
    else
    {
        VDir = Pawn.Acceleration;
        VDir.Z = 0.0;
        VDir = Normal(VDir);
    }
    vLoc = Pawn.location;
    fFov = Params.MinCameraDotCover;
    fMaxDistance = Params.MaxDist;
    Pawn.FlushPersistentDebugLines();
    clrCone.R = 0;
    clrCone.G = 255;
    clrCone.B = 0;
    fAngle = Acos(fFov);
    Pawn.DrawDebugCylinder(vLoc, vLoc, fMaxDistance, 32, 255, 0, 0, TRUE);
    Pawn.DrawDebugCylinder(vLoc, vLoc, fMaxDistance + 512.0, 32, 255, 0, 0, TRUE);
    Pawn.DrawDebugCone(vLoc, VDir, fMaxDistance, fAngle, 0.0, 16, clrCone, TRUE);
}
public function bool DetectPressAway(Vector StartLocation, Vector EndLocation)
{
    local Vector jumpDir;
    local Rotator PlayerAimDir;
    local float AimDot;
    
    jumpDir = EndLocation - StartLocation;
    jumpDir.Z = 0.0;
    jumpDir = Normal(jumpDir);
    PlayerAimDir = Rotation + Rotator(BioPlayerInput(PlayerInput).MoveStick);
    PlayerAimDir.Pitch = 0;
    AimDot = Vector(PlayerAimDir) Dot jumpDir;
    return AimDot < -0.5;
}
public function bool DetectPressInto(Vector StartLocation, Vector EndLocation)
{
    local Vector jumpDir;
    local Rotator PlayerAimDir;
    local Rotator PlayerFaceDir;
    local float AimDot;
    local float FaceDot;
    
    if (BioPlayerInput(PlayerInput).MoveStickMag < 0.899999976)
    {
        return FALSE;
    }
    jumpDir = EndLocation - StartLocation;
    jumpDir.Z = 0.0;
    jumpDir = Normal(jumpDir);
    PlayerAimDir = Rotation + Rotator(BioPlayerInput(PlayerInput).MoveStick);
    PlayerAimDir.Pitch = 0;
    AimDot = Vector(PlayerAimDir) Dot jumpDir;
    PlayerFaceDir = Rotation;
    PlayerFaceDir.Pitch = 0;
    FaceDot = Vector(PlayerFaceDir) Dot jumpDir;
    return AimDot > LadderAimDot && FaceDot > LadderFaceDot;
}
public final function DisableStorm()
{
    StormDisabledCounter++;
}
public reliable server function DispatchCommand(string CommandString)
{
    ConsoleCommand(CommandString);
}
public function DisplayCoverVisualization(RvrClientEffectInterface NewVisualization, RvrClientEffectTarget Target)
{
    if (NewVisualization == None)
    {
        bCoverGUIShowing = FALSE;
    }
    if (NewVisualization != CoverVisualizationClientEffect)
    {
        if (CoverVisualizationClientEffect != None)
        {
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CoverVisualizationClientEffect, CoverVisualizationClientEffectGuid, TRUE);
        }
        CoverVisualizationClientEffect = NewVisualization;
        if (CoverVisualizationClientEffect != None && bShowActionIcons)
        {
            CoverVisualizationClientEffectGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CoverVisualizationClientEffect, Target);
            bCoverGUIShowing = TRUE;
        }
    }
}
public final function EnableStorm()
{
    StormDisabledCounter--;
    if (StormDisabledCounter < 0)
    {
        StormDisabledCounter = 0;
    }
}
public function ForceLocation(Vector NewLocation)
{
    local Actor MoveActor;
    
    if (Pawn != None)
    {
        MoveActor = Pawn;
    }
    else
    {
        MoveActor = Self;
    }
    if (BioPawn(MoveActor) != None && MoveActor.Physics == EPhysics.PHYS_RigidBody)
    {
        BioPawn(MoveActor).ReplicatedRootBodyPos = NewLocation;
    }
    else
    {
        MoveActor.bCanTeleport = FALSE;
        if (!MoveActor.SetLocation(NewLocation, ) && Pawn(MoveActor) != None && Pawn(MoveActor).CylinderComponent.CollisionHeight > Pawn(MoveActor).CrouchHeight && !Pawn(MoveActor).bIsCrouched)
        {
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
    }
}
public final function ECoverDirection GetCoverDirection()
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        return BioPawn.CoverDirection;
    }
    return 0;
}
public function SFXGameModeDefault GetGameModeDefault()
{
    return SFXGameModeDefault(GameModeManager2.GameModes[0]);
}
public final function ECoverAction GetPawnCoverAction()
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        return BioPawn.CoverAction;
    }
    return 0;
}
public final function ECoverType GetPawnCoverType()
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        return BioPawn.CoverType;
    }
    return 0;
}
public function int GetRichPresenceClassContextID()
{
    local SFXPawn_Player PawnPlayer;
    
    PawnPlayer = SFXPawn_Player(Pawn);
    if (PawnPlayer != None && PawnPlayer.PlayerClass != None)
    {
        return PawnPlayer.PlayerClass.RichPresenceContextStringIndex;
    }
    return -1;
}
public function float GetSensitivityScaling()
{
    local SFXPRI PRI;
    local float Multiplier;
    
    Multiplier = RotationSensitivityMedium;
    PRI = SFXPRI(PlayerReplicationInfo);
    if (PRI != None)
    {
        switch (PRI.ControllerSensitivityConfig)
        {
            case EProfileControllerSensitivityOptions.PCSO_Low:
                Multiplier = RotationSensitivityLow;
                break;
            case EProfileControllerSensitivityOptions.PCSO_High:
                Multiplier = RotationSensitivityHigh;
                break;
            case EProfileControllerSensitivityOptions.PCSO_Medium:
            default:
                Multiplier = RotationSensitivityMedium;
                break;
        }
    }
    return Multiplier;
}
public function GiveHenchmanOrder(Pawn oHenchman, HenchmanOrderType eOrder, Actor oTargetActor, Vector vTargetLocation, optional Name nmPower, optional SFXWeapon oWpn, optional int nQueue, optional ECommandInputMethod eInputMethod = 0)
{
    local SFXAI_Henchman oController;
    local array<TelemetryAttribute> aTelAttribs;
    local string sTelAttVal;
    
    if (oHenchman != None)
    {
        oController = SFXAI_Henchman(oHenchman.Controller);
        if (oController != None && oController.IsEnabled())
        {
            oController.AddOrder(eOrder, oTargetActor, vTargetLocation, nmPower, oWpn, nQueue);
        }
        aTelAttribs.Add(3);
        sTelAttVal = "hmn1";
        aTelAttribs[0].Type = ETelemetryAttributeType.AttributeType_String;
        aTelAttribs[0].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
        aTelAttribs[0].sData = string(oHenchman.Tag);
        sTelAttVal = "cmnd";
        aTelAttribs[1].Type = ETelemetryAttributeType.AttributeType_Int;
        aTelAttribs[1].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
        aTelAttribs[1].nData = int(eOrder);
        sTelAttVal = "knkt";
        aTelAttribs[2].Type = ETelemetryAttributeType.AttributeType_Bool;
        aTelAttribs[2].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
        aTelAttribs[2].bData = eInputMethod == ECommandInputMethod.CIM_Kinect;
        Class'SFXTelemetry'.static.SendArray('TelemetryHook_SquadCommand', aTelAttribs);
    }
}
public final function GrantXP(float XP, optional bool bSkipNotify = FALSE)
{
    local float XPGained;
    local int MaxExperience;
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn != None)
    {
        MaxExperience = SFXGRI(WorldInfo.GRI).gameconfig.MaxPlayerExperience;
        XPGained = XP;
        if (PlayerPawn.TotalXP + XPGained > float(MaxExperience))
        {
            XPGained = float(MaxExperience) - PlayerPawn.TotalXP;
        }
        PlayerPawn.TotalXP += XPGained;
        if (XPGained > float(0) && !bSkipNotify)
        {
            BioHintSystem(HintSystem).AddNotification_XP(int(XPGained));
        }
        if (Class'BioLevelUpSystem'.static.AttemptLevelUp(PlayerPawn.Squad))
        {
            if (!bSkipNotify)
            {
                BioHintSystem(HintSystem).AddNotification_LevelUp(PlayerPawn.CharacterLevel);
            }
        }
    }
}
public function bool HasCompletedAccomplishment(Name AccomplishmentName)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        return AccomplishmentManager.HasCompletedAccomplishment(AccomplishmentName);
    }
    return FALSE;
}
public function Internal_AcquireCover(CovPosInfo CovInfo, byte SlotIdx)
{
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn != None && PawnAsBioPawn.IsDead() == FALSE)
    {
        PawnAsBioPawn.PlayerCoverAcquired(CovInfo, SlotIdx);
        if (CovInfo.LtToRtPct == 0.0 || CovInfo.LtToRtPct == 1.0)
        {
            NotifyReachedCoverSlot(PawnAsBioPawn.CurrentSlotIdx, -1);
        }
        if (PawnAsBioPawn.CanDoCoverAction(3))
        {
            PawnAsBioPawn.SetCoverDirection(1);
        }
        else
        {
            PawnAsBioPawn.SetCoverDirection(2);
        }
        PawnAsBioPawn.SetAnimatedTransitionPending();
        GotoState('PlayerInCover', , , );
        PawnAsBioPawn.bRecentlyTookCover = TRUE;
        SetTimer(0.649999976, FALSE, 'ClearRecentCoverFlag', PawnAsBioPawn);
    }
}
public function Internal_ResetPlayerController(Vector NewLocation)
{
    local BioPawn PawnAsBioPawn;
    
    ClearServerMoveExtrapolation();
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn != None)
    {
        if (PawnAsBioPawn.bTearOff)
        {
            return;
        }
        if (PawnAsBioPawn.IsDead() && PawnAsBioPawn.Role == ENetRole.ROLE_Authority)
        {
            PawnAsBioPawn.Resurrect(100.0, TRUE);
        }
        if (PawnAsBioPawn.IsInCover() == TRUE || PawnAsBioPawn.CoverAction == ECoverAction.CA_Aimback)
        {
            PawnAsBioPawn.LeaveCover();
        }
        PawnAsBioPawn.ShouldCrouch(FALSE);
        PawnAsBioPawn.SetPhysics(1);
        PawnAsBioPawn.StopMovement(TRUE);
        ResetCameraMode();
        SetViewTarget(PawnAsBioPawn);
        PawnAsBioPawn.GotoState('Auto', , , );
    }
    GotoState('PlayerWalking', , , );
    ForceLocation(NewLocation);
}
public function InternalSawFirstEnemy()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI != None && Role == ENetRole.ROLE_Authority)
    {
        GRI.TriggerVocalizationEvent(17, BioPawn(Pawn), , , , TRUE);
    }
}
public function InternalSawNewEnemy(const out BioPawn EnemyPawn);

public function bool IsCameraAlignedWithCoverSlot(optional float fThreshold = 0.0)
{
    local BioPawn BioPawn;
    local Vector vSlotDir;
    local Vector vCamDir;
    
    if (IsLocalPlayerController() == FALSE)
    {
        return TRUE;
    }
    BioPawn = BioPawn(Pawn);
    if (BioPawn.CurrentLink != None)
    {
        vSlotDir = Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.CurrentSlotIdx));
        vCamDir = Vector(PlayerCamera.CameraCache.POV.Rotation);
        if (vCamDir Dot vSlotDir >= fThreshold)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool IsInCoverState()
{
    return FALSE;
}
public final function bool IsStormDisabled()
{
    return StormDisabledCounter > 0;
}
public function NotifyLoginChange(byte LocalUserNum)
{
    SetRichPresence();
    CheckThatGameCanContinue();
}
public function NotifyProfileReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    UpdateProfileData();
    InitializeGammaCorrectionSettings();
}
public function NotifyReachedCoverSlot(int SlotIdx, int OldSlotIdx)
{
    local BioPawn BioPawn;
    local CoverLink Link;
    local CoverSlot Slot;
    local float RotationDiff;
    local Rotator NewSlotRotation;
    
    BioPawn = BioPawn(Pawn);
    Link = BioPawn.CurrentLink;
    if (Link != None)
    {
        CoverLog("Slot:" @ SlotIdx, GetFuncName() @ "Cur" @ BioPawn.CurrentSlotIdx @ "L" @ BioPawn.LeftSlotIdx @ "R" @ BioPawn.RightSlotIdx);
        if (OldSlotIdx >= 0)
        {
            RotationDiff = Abs(float(NormalizeRotAxis(Link.GetSlotRotation(OldSlotIdx).Yaw - Link.GetSlotRotation(SlotIdx).Yaw)));
            if (RotationDiff >= float(14500) && IsZoomed() == FALSE)
            {
                GetGameModeDefault().TransitionToFutureSlot(CoverCameraTransitionTime, Link.GetSlotMarker(SlotIdx));
                NewSlotRotation = Link.GetSlotRotation(SlotIdx);
                Pawn.SetRotation(NewSlotRotation);
                Pawn.SetDesiredRotation(NewSlotRotation);
                bLockPosition = TRUE;
                SetTimer(CoverCameraTransitionTime + 0.100000001, FALSE, 'ReenableMovement', );
            }
            Link.UnClaim(Pawn, OldSlotIdx, FALSE);
        }
        Link.Claim(Pawn, SlotIdx);
        Slot = Link.Slots[SlotIdx];
        if (Slot.CoverType == ECoverType.CT_MidLevel)
        {
            BioPawn.ShouldCrouch(TRUE);
        }
        if (Slot.CoverType == ECoverType.CT_Standing)
        {
            BioPawn.StopFire(0);
            BioPawn.ShouldCrouch(FALSE);
        }
        Pawn.SetAnchor(Link.Slots[SlotIdx].SlotMarker);
        if (Link.IsStationarySlot(SlotIdx))
        {
            if (Link.IsEdgeSlot(SlotIdx) == FALSE)
            {
                CoverTransitionCountHold = 0.0;
            }
            SetIsInStationaryCover(TRUE);
        }
    }
}
public function NotifyReadAchievementsComplete(int TitleId)
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;
    local array<AchievementDetails> AchievementsList;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (OnlineSub != None)
    {
        ControllerId = LocalPlayer(Player).ControllerId;
        PlayerInt = OnlineSub.PlayerInterface;
        if (PlayerInt != None)
        {
            PlayerInt.ClearReadAchievementsCompleteDelegate(byte(ControllerId), NotifyReadAchievementsComplete);
            if (ProfileSettings != None)
            {
                PlayerInt.GetAchievements(byte(ControllerId), AchievementsList);
                if (AccomplishmentManager != None)
                {
                    AccomplishmentManager.LoadAchievementData(AchievementsList, Self);
                }
            }
        }
    }
}
public function OnCoverConeProtected(Weapon W)
{
    PlayFlinch(W, TRUE);
}
public function OnTeleportCameraSync(SeqAct_Teleport Action)
{
    local Vector vLocation;
    local Rotator rRotation;
    local Actor destActor;
    local int nYawDiff;
    
    if (PlayerCamera != None)
    {
        if (Action.bUpdateRotation == TRUE)
        {
            if (Action.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
            {
                nYawDiff = rRotation.Yaw - Pawn.Rotation.Yaw;
                PlayerCamera.CameraCache.POV.Rotation.Yaw += nYawDiff;
            }
        }
    }
}
public function OrderWeaponSwitch(Pawn oOrderedPawn, SFXWeapon Wpn, optional ECommandInputMethod eInputMethod = 0)
{
    local SFXAI_Henchman oController;
    
    if (oOrderedPawn != None)
    {
        oController = SFXAI_Henchman(oOrderedPawn.Controller);
        if (oController != None)
        {
            GiveHenchmanOrder(oOrderedPawn, 2, None, vect(0.0, 0.0, 0.0), 'None', Wpn, , eInputMethod);
        }
        else if (oOrderedPawn == Pawn)
        {
            m_currentOrder.oSwitchWeapon = Wpn;
            SFXPawn_Player(oOrderedPawn).OutOfAmmoTimestamp = 0.0;
        }
    }
}
public final function OverwriteGame(int DeleteIndex, int SaveIndex, optional delegate<SFXEngine.SFXSaveCommandCallback> Callback)
{
    local SFXEngine Engine;
    local SFXSaveDescriptor SaveDescriptor;
    
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        SaveDescriptor.Index = DeleteIndex;
        Engine.QueueSaveGameCommand(3, SaveDescriptor);
        SaveDescriptor.Index = SaveIndex;
        SaveGameEx(SaveDescriptor, Callback);
    }
}
public function ParallelServerMove(float TimeStamp, int View)
{
    local Rotator ViewRot;
    
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    CurrentTimeStamp = TimeStamp;
    LastActiveTime = WorldInfo.TimeSeconds;
    ViewRot.Pitch = View & 65535;
    ViewRot.Yaw = View >> 16;
    ViewRot.Roll = 0;
    SetRotation(ViewRot);
    PendingAdjustment.TimeStamp = TimeStamp;
    PendingAdjustment.bAckGoodMove = 1;
}
public function PawnFalling()
{
    GotoState('PlayerFalling', , , );
}
public function PawnLanded()
{
    GotoState('PlayerWalking', , , );
}
public final function PlayCoverPresentation();

public function PlayFlinch(Weapon W, bool bFromCoverCone)
{
    local SFXWeapon EnemyWeapon;
    local SFXWeapon MyWeapon;
    local Class<SFXDamageType> DamageType;
    local BioPawn oPawn;
    
    oPawn = BioPawn(Pawn);
    MyWeapon = SFXWeapon(Pawn.Weapon);
    if (oPawn.IsInCover() && oPawn.IsReloading(TRUE) == FALSE && oPawn.IsUsingPower() == FALSE && oPawn.IsInAnimatedTransition() == FALSE && oPawn.IsPerformingBlockingAction() == FALSE && MyWeapon != None && MyWeapon.IsInState('WeaponEquipping', ) == FALSE && MyWeapon.IsInState('WeaponPuttingDown', ) == FALSE && MyWeapon.IsZoomed() == FALSE && MyWeapon.IsFiring() == FALSE)
    {
        FlinchInterval = RandRange(FlinchIntervalRange.X, FlinchIntervalRange.Y);
        NoShieldFlinchInterval = RandRange(NoShieldFlinchIntervalRange.X, NoShieldFlinchIntervalRange.Y);
        if (bFromCoverCone && WorldInfo.GameTimeSeconds - LastFlinchTime > NoShieldFlinchInterval || oPawn.HasAnyShieldResistance() == FALSE && WorldInfo.GameTimeSeconds - LastFlinchTime > NoShieldFlinchInterval || oPawn.HasAnyShieldResistance() && WorldInfo.GameTimeSeconds - LastFlinchTime > FlinchInterval)
        {
            EnemyWeapon = SFXWeapon(W);
            if (EnemyWeapon != None)
            {
                DamageType = EnemyWeapon.GetDamageType(EnemyWeapon.CurrentFireMode);
                if (FRand() < DamageType.default.FlinchChance)
                {
                    if (FRand() < 0.660000026)
                    {
                        StartCustomAction(101);
                    }
                    else
                    {
                        StartCustomAction(102);
                    }
                    LastFlinchTime = WorldInfo.GameTimeSeconds;
                }
            }
        }
    }
}
public function ProcessCinematicModeHelmetSettings(BioSeqAct_BioToggleCinematicMode Action)
{
    local SFXPawn_Player TargetPawn;
    local SFXPRI PRI;
    local array<SFXPawn_PlayerParty> SquadMembers;
    local BioAiController SquadController;
    local SFXPawn_PlayerParty SquadMember;
    local int idx;
    
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    TargetPawn = SFXPawn_Player(Pawn);
    if (TargetPawn != None)
    {
        SquadMembers.AddItem(TargetPawn);
        if (TargetPawn.Squad != None)
        {
            foreach TargetPawn.Squad.SquadMembers(SquadController)
            {
                SquadMember = SFXPawn_PlayerParty(SquadController.Pawn);
                if (SquadMember != None)
                {
                    SquadMembers.AddItem(SquadMember);
                }
            }
        }
        for (idx = 0; idx < SquadMembers.Length; ++idx)
        {
            if (bCinematicMode)
            {
                if (!Action.m_bSupportsPlayerHelmet)
                {
                    SquadMembers[idx].ForceSquadHelmet(2, 3);
                }
                else if (!Action.m_bSupportsPlayerFace)
                {
                    SquadMembers[idx].ForceSquadHelmet(2, 1);
                }
                else
                {
                    PRI = SFXPRI(PlayerReplicationInfo);
                    if (PRI == None || PRI.bHideCinematicHelmetPreference)
                    {
                        SquadMembers[idx].ForceSquadHelmet(2, 3);
                    }
                }
                continue;
            }
            SquadMembers[idx].ForceSquadHelmet(2, 0);
        }
    }
}
public function ReenableMovement()
{
    bLockPosition = FALSE;
}
public function RemotePlayerResetPendingCustomActionInfo()
{
    RemotePlayerPendingCustomAction = 0;
    RemotePlayerPendingPowerCustomAction = 0;
    ClearTimer('RemotePlayerResetPendingCustomActionInfo');
}
public function ResetCoverAction()
{
    local BioPawn ChkPawn;
    local ECoverAction Action;
    
    ChkPawn = BioPawn(Pawn);
    Action = ECoverAction.CA_Default;
    if (ChkPawn.CoverDirection == ECoverDirection.CD_Left && ChkPawn.IsAtLeftEdgeSlot())
    {
        Action = ECoverAction.CA_PeekLeft;
    }
    else if (ChkPawn.CoverDirection == ECoverDirection.CD_Right && ChkPawn.IsAtRightEdgeSlot())
    {
        Action = ECoverAction.CA_PeekRight;
    }
    ChkPawn.SetCoverAction(Action);
    ChkPawn.SetAnimatedTransitionPending();
}
public final function ResetInitialPlayerPawn(BioPlayerSquad PlayerSquad)
{
    if (PlayerSquad != None && IsLocalPlayerController())
    {
        if (PlayerSquad.m_InitialPlayerPawn != None)
        {
            PlayerSquad.RemoveMember(PlayerSquad.m_InitialPlayerPawn);
        }
        PlayerSquad.m_InitialPlayerPawn = None;
    }
}
public function ResetStormCooldown()
{
    bStormCoolingDown = FALSE;
}
public final function ResumeGame(optional delegate<SFXEngine.OnResumeGameComplete> Callback)
{
    if (SFXEngine(Player.Outer).FastResumeGame(Callback) == FALSE)
    {
        SFXEngine(Player.Outer).ResumeGame(Callback);
    }
}
public reliable server function Revive(Pawn Other)
{
    local SFXPawn_PlayerParty oPartyPawn;
    
    oPartyPawn = SFXPawn_PlayerParty(Other);
    if (oPartyPawn != None)
    {
        if (SFXGRI(WorldInfo.GRI).bMultiplayer)
        {
            SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(135, oPartyPawn, BioPawn(Pawn), , , TRUE);
            oPartyPawn.Resurrect(SFXGRI(WorldInfo.GRI).DifficultyHandler.GetFloat('ReviveHealthReturn', 'MPGlobal'), FALSE);
        }
        else
        {
            oPartyPawn.Resurrect(1.0, FALSE);
        }
    }
}
public unreliable server function RootMotionServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag)
{
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (Pawn != None)
    {
        if (Pawn.Mesh != None && Pawn.Mesh.RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            ParallelServerMove(TimeStamp, View);
            return;
        }
        Pawn.bForceRMVelocity = TRUE;
        Pawn.RMVelocity = InAccel * 0.100000001;
        InAccel = Pawn.AccelRate * Normal(InAccel);
    }
    else
    {
        InAccel = vect(0.0, 0.0, 0.0);
    }
    StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, GetStateName());
    if (Pawn != None)
    {
        Pawn.bForceRMVelocity = FALSE;
    }
}
public final function SaveGameEx(SFXSaveDescriptor SaveDescriptor, optional delegate<SFXEngine.SFXSaveCommandCallback> Callback)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        Class'SFXTelemetry'.static.SendVoid('TelemetryHook_SaveGame');
        Engine.SaveGameEx(SaveDescriptor, Callback);
    }
}
public function SendServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local SFXSavedMove NewSFXSavedMove;
    
    NewSFXSavedMove = SFXSavedMove(NewMove);
    if (NewSFXSavedMove == None)
    {
        return;
    }
    if (NewSFXSavedMove.ControllerState == 'PlayerInCover')
    {
        CoverServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.Acceleration * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag), NewSFXSavedMove.CoverType, NewSFXSavedMove.CoverAction, NewSFXSavedMove.CoverDirection, NewSFXSavedMove.CurrentSlotDirection, NewSFXSavedMove.bIsInStationaryCover);
    }
    else if (NewSFXSavedMove.ControllerState == 'PlayerInAimBack')
    {
        AimBackServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.Acceleration * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag));
    }
    else if (NewSFXSavedMove.bForceRMVelocity == TRUE)
    {
        RootMotionServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.RMVelocity * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag));
    }
    else if (NewSFXSavedMove.ControllerState == 'PlayerWalking')
    {
        if (NewSFXSavedMove.bWantsToStorm)
        {
            StormingServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.Acceleration * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag), NewSFXSavedMove.PawnDesiredYaw);
        }
        else
        {
            WalkingServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.Acceleration * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag));
        }
    }
    else
    {
        StandardServerMove(NewSFXSavedMove.TimeStamp, NewSFXSavedMove.Acceleration * float(10), ClientLoc, NewSFXSavedMove.CompressedFlags(), ClientRoll, View, byte(NewSFXSavedMove.MoveMag), NewSFXSavedMove.ControllerState);
    }
}
public reliable server function ServerAcquireCover(CoverLink Link, byte SlotIdx, byte LeftIdx, byte RightIdx, float SlotPct, ECoverDirection ClientCoverDirection, float TimeStamp)
{
    local CovPosInfo CovInfo;
    local Vector SlotToSlot;
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn != None && PawnAsBioPawn.Role == ENetRole.ROLE_Authority)
    {
        if (Link.IsValidClaim(PawnAsBioPawn, int(SlotIdx), TRUE, TRUE) == FALSE)
        {
            ClientInvalidCoverClaim();
            return;
        }
        CovInfo.Link = Link;
        CovInfo.LtSlotIdx = int(LeftIdx);
        CovInfo.RtSlotIdx = int(RightIdx);
        CovInfo.LtToRtPct = SlotPct;
        SlotToSlot = CovInfo.Link.GetSlotLocation(int(RightIdx)) - CovInfo.Link.GetSlotLocation(int(LeftIdx));
        CovInfo.location = CovInfo.Link.GetSlotLocation(int(LeftIdx)) + SlotToSlot * SlotPct;
        CovInfo.Normal = Vector(CovInfo.Link.GetSlotRotation(int(SlotIdx))) * -1.0;
        Internal_AcquireCover(CovInfo, SlotIdx);
        CurrentTimeStamp = TimeStamp;
    }
}
public unreliable server function ServerSawFirstEnemy()
{
    InternalSawFirstEnemy();
}
public unreliable server function ServerSawNewEnemy(BioPawn EnemyPawn)
{
    InternalSawNewEnemy(EnemyPawn);
}
public reliable server function ServerStartCustomAction(int NewAction, optional BioPawn Sync, optional int NewPowerAction)
{
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None)
    {
        return;
    }
    PawnAsBioPawn.StartCustomAction(NewAction, Sync, FALSE, NewPowerAction);
}
public reliable server function ServerStartCustomActionWithDirection(int NewAction, Vector Direction, optional BioPawn Sync, optional int NewPowerAction)
{
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None)
    {
        return;
    }
    PawnAsBioPawn.ReplicatedDirection = Direction / 100.0;
    ServerStartCustomAction(NewAction, Sync, NewPowerAction);
}
public final reliable server function ServerStartCustomActionWithNav(int NewAction, Object Nav, optional BioPawn Sync, optional int NewPowerAction)
{
    local BioPawn PawnAsBioPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None)
    {
        return;
    }
    PawnAsBioPawn.SetAnchor(NavigationPoint(Nav));
    ServerStartCustomAction(NewAction, Sync, NewPowerAction);
}
public reliable server function ServerStartPowerCustomAction(int PowerCustomAction, Actor Target, Vector TargetLocation, Vector CamLocation, Vector CamDirection)
{
    local BioPawn PawnAsBioPawn;
    
    RemoteCameraLocation = CamLocation * 0.100000001;
    RemoteCameraRotation = Rotator(CamDirection * 0.00999999978);
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None)
    {
        return;
    }
    PawnAsBioPawn.StartPowerCustomAction(PowerCustomAction, Target, TargetLocation);
}
public reliable server function ServerTestNameReplication(Name InName, string InConfirmString);

public reliable server function ServerUseLadder(SFXNav_LadderNode Ladder)
{
    TryUseLadder(Ladder);
}
public reliable server function ServerUseSelection(Actor oActorUsed)
{
    TryUse(oActorUsed);
}
public final function SetCoverDirection(ECoverDirection NewCoverDirection)
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        BioPawn.SetCoverDirection(NewCoverDirection);
    }
}
public function SetDeviceID(int nID)
{
    local SFXEngine Engine;
    
    if (ProfileSettings != None)
    {
        ProfileSettings.SetCurrentDeviceID(nID, Self);
    }
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        Engine.UpdateCurrentDevice(nID);
    }
}
public final function SetIsInStationaryCover(bool bIsInStationaryCover)
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None && bIsInStationaryCover != BioPawn.bIsInStationaryCover)
    {
        BioPawn.bIsInStationaryCover = bIsInStationaryCover;
    }
}
public final function SetPawnCoverAction(ECoverAction NewCoverAction)
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        BioPawn.SetCoverAction(NewCoverAction);
    }
}
public final function SetPawnCoverType(ECoverType NewCoverType)
{
    local BioPawn BioPawn;
    
    BioPawn = BioPawn(Pawn);
    if (BioPawn != None)
    {
        BioPawn.SetCoverType(NewCoverType);
    }
}
public final function SetRichPresenceForIdlePlayers()
{
    local array<LocalizedStringSetting> aContexts;
    local array<SettingsProperty> aProperties;
    local LocalPlayer LocPlayer;
    local int nIndex;
    local bool bIsInSplash;
    local SFXGUIInteraction oGuiInteraction;
    
    if (OnlineSub != None && OnlineSub.PlayerInterface != None)
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != None)
        {
            aContexts.Length = 0;
            aProperties.Length = 0;
            oGuiInteraction = Class'SFXGUIInteraction'.static.GetInstance();
            bIsInSplash = oGuiInteraction.GetMovie(Self, oGuiInteraction.MovieTag_Splash) != None;
            for (nIndex = 0; nIndex < 4; ++nIndex)
            {
                if (nIndex != LocPlayer.ControllerId || bIsInSplash)
                {
                    OnlineSub.PlayerInterface.SetOnlineStatus(byte(nIndex), 4, aContexts, aProperties);
                }
            }
        }
    }
}
public function SetSpectatorMode(bool bOn)
{
    if (IsInState('PlayerFlyCam', ) == bOn)
    {
        return;
    }
    BioPlayerInput(PlayerInput).SetFlyCam(bOn);
    myHUD.bShowHUD = !bOn;
}
public unreliable client function SFXClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
    local Vector NewLocation;
    local Vector NewVelocity;
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
                if (VSizeSq(CurrentMove.SavedLocation - NewLocation) < 3.0 && VSizeSq(CurrentMove.SavedVelocity - NewVelocity) < 9.0 && IsInState('PlayerWalking', ) && (MoveActor.Physics == EPhysics.PHYS_Walking || MoveActor.Physics == EPhysics.PHYS_Falling))
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
    if (Pawn != None && Pawn.Physics != EPhysics.PHYS_Falling && Pawn.Mesh != None && Pawn.Mesh.RootMotionMode != ERootMotionMode.RMM_Ignore)
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
    ForceLocation(NewLocation);
    MoveActor.Velocity = NewVelocity;
    bUpdatePosition = TRUE;
}
public unreliable client function SFXShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ)
{
    SFXClientAdjustPosition(TimeStamp, NewLocX, NewLocY, NewLocZ, 0.0, 0.0, 0.0);
}
public unreliable client function SFXWarnAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ)
{
    local Vector NewLocation;
    
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    if (NewLocation != PendingAdjustment.NewLoc || int(PendingAdjustment.bWarning) == 0)
    {
        PendingAdjustment.NewLoc = NewLocation;
        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.bWarning = 1;
    }
}
public unreliable server function StandardServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag, Name ControllerState)
{
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (IsInState(ControllerState, ) == FALSE && ClientLoc != vect(1.0, 2.0, 3.0))
    {
        InvalidServerMovesReceived = InvalidServerMovesReceived + 1;
        if (InvalidServerMovesReceived >= NUM_SERVERMOVE_BEFORE_RESET)
        {
            ResetPlayerController();
            InvalidServerMovesReceived = 0;
            return;
        }
    }
    else
    {
        InvalidServerMovesReceived = 0;
    }
    if (BioPawn(Pawn) != None)
    {
        BioPawn(Pawn).fMoveMag = ByteToFloat(MoveMag, FALSE);
    }
    ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
}
public function bool StartCustomActionWithSyncPartner(int NewAction)
{
    local BioPawn PawnAsBioPawn;
    local BioPawn TargetPawn;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn != None && PawnAsBioPawn.VerifyCAHasBeenInstanced(NewAction))
    {
        TargetPawn = PawnAsBioPawn.CustomActions[NewAction].GetVictimPawn();
    }
    return StartCustomAction(NewAction, TargetPawn);
}
public function bool StartPowerCustomAction(SFXPowerCustomActionBase Power)
{
    local BioPawn PawnAsBioPawn;
    local bool bCanStartCustomAction;
    
    PawnAsBioPawn = BioPawn(Pawn);
    if (PawnAsBioPawn == None || Power == None || RemotePlayerPendingCustomAction != 0)
    {
        return FALSE;
    }
    if (Role == ENetRole.ROLE_Authority || Role == ENetRole.ROLE_AutonomousProxy && Power.bClientPredictCustomAction)
    {
        bCanStartCustomAction = PawnAsBioPawn.StartPowerCustomAction(Power.PowerCustomActionID, Power.m_oTargetToAimAt, Power.m_vLocationToAimAt);
    }
    else
    {
        bCanStartCustomAction = PawnAsBioPawn.CanDoCustomAction(132, , , Power.PowerCustomActionID);
    }
    if (bCanStartCustomAction == TRUE && Role == ENetRole.ROLE_AutonomousProxy)
    {
        GetPlayerViewPoint(RemoteCameraLocation, RemoteCameraRotation);
        ServerStartPowerCustomAction(Power.PowerCustomActionID, Power.m_oTargetToAimAt, Power.m_vLocationToAimAt, RemoteCameraLocation * 10.0, Vector(RemoteCameraRotation) * 100.0);
        if (!Power.bClientPredictCustomAction)
        {
            RemotePlayerPendingCustomAction = 132;
            RemotePlayerPendingPowerCustomAction = Power.PowerCustomActionID;
            SetTimer(ClientTimeoutForPendingCustomActionReset, FALSE, 'RemotePlayerResetPendingCustomActionInfo', );
        }
    }
    return bCanStartCustomAction;
}
public function StorageDeviceChanged()
{
    local SFXEngine Engine;
    
    CheckThatGameCanContinue();
    Engine = SFXEngine(Player.Outer);
    if (Engine != None)
    {
        Engine.ScanSaveData();
    }
}
public unreliable server function StormingServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag, int PawnDesiredYaw)
{
    local Rotator NewRotation;
    
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    NewRotation.Yaw = PawnDesiredYaw;
    if (Pawn != None)
    {
        Pawn.SetDesiredRotation(NewRotation);
    }
    StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, 'PlayerWalking');
    if (Pawn != None)
    {
        Pawn.UpdatePawnRotation(NewRotation);
    }
}
public function TickCoverVisualization()
{
    local CovPosInfo CoverInfo;
    local ECoverType CoverType;
    local SFXSFHandler_HUD HUD;
    local SFXGUIInteraction GUI;
    local BioCustomAction CurrentCustomAction;
    local BioPawn BP;
    local BioPawn TargetPawn;
    local CoverReference Ignored;
    local BioPlayerInput Input;
    local SFXJumpReachSpec JumpSpec;
    local ESFXHUDActionIcon eDesiredActionIcon;
    local RvrClientEffectTarget Target;
    local bool bStopCoverGUI;
    local bool bForceStop;
    local MantleInfo MyMantleInfo;
    
    Target.Instigator = Self.Pawn;
    Target.HitNormal = Vector(Self.Pawn.Rotation);
    eDesiredActionIcon = ESFXHUDActionIcon.SFXHUD_Action_NONE;
    GUI = Class'SFXGUIInteraction'.static.GetInstance();
    HUD = GUI.CastGetMovie(Class'SFXSFHandler_HUD', Self, GUI.MovieTag_HUD);
    CoverType = BioPawn(Pawn).CoverType;
    BP = BioPawn(Pawn);
    if (IsTimerActive('ReenableCoverIcons'))
    {
        bForceStop = TRUE;
    }
    if (BP.IsInCover())
    {
        if (BP.CoverType == ECoverType.CT_Standing && BP.CoverAction == ECoverAction.CA_Default && !GetGameModeDefault().GetSnapTarget())
        {
            if (!bReticleHidden)
            {
                bReticleHidden = TRUE;
                GameModeManager2.HideReticle();
            }
        }
        else if (bReticleHidden)
        {
            bReticleHidden = FALSE;
            GameModeManager2.ResetReticles();
        }
    }
    else if (bReticleHidden)
    {
        bReticleHidden = FALSE;
        GameModeManager2.ResetReticles();
    }
    Input = BioPlayerInput(PlayerInput);
    if (ProfileSettings != None)
    {
        bShowActionIcons = ProfileSettings.GetActionIconHintOption();
    }
    if (BP.IsInCover() && BP.CurrentLink != None && !bForceStop)
    {
        CoverInfo.Link = BP.CurrentLink;
        CoverInfo.LtSlotIdx = BP.LeftSlotIdx;
        CoverInfo.RtSlotIdx = BP.RightSlotIdx;
        CoverInfo.LtToRtPct = BP.CurrentSlotPct;
        if (BP.CustomActionClasses[62] != None && BP.VerifyCAHasBeenInstanced(62))
        {
            TargetPawn = SFXCustomAction_ClassMelee(BP.CustomActions[62]).GetVictimPawn();
        }
        if (TargetPawn != None && BP.CoverType == ECoverType.CT_MidLevel && BP.CoverAction == ECoverAction.CA_Default)
        {
            DisplayCoverVisualization(CE_Grab, Target);
        }
        else if (TargetPawn == None && CanPerformMantle(CoverInfo) && Input.RawJoyUp > 0.800000012)
        {
            if (CurrentVisualization != ECoverVisualizations.CV_Mantle)
            {
                CurrentVisualization = ECoverVisualizations.CV_Mantle;
                if (BP.CanPerformMantleSlow(MyMantleInfo))
                {
                    if (BP.CurrentCustomAction != 20)
                    {
                        StartCustomAction(20);
                        DisplayCoverVisualization(CE_Mantle, Target);
                    }
                }
                else
                {
                    bCoverGUIShowing = TRUE;
                }
            }
        }
        else if (CanPerformClimb(CoverInfo) && Input.RawJoyUp > 0.800000012)
        {
            if (BP.CurrentCustomAction != 20)
            {
                StartCustomAction(20);
                DisplayCoverVisualization(CE_Mantle, Target);
            }
        }
        else if (BP.CoverAction == ECoverAction.CA_PeekLeft && Input.RawJoyRight < -0.800000012 && BP.bCanSwatTurn == TRUE && Class'SFXCustomAction_SwatTurn_Left'.static.CanPerformSwatTurn(BP, Ignored))
        {
            if (BP.GetCurrentCustomAction(CurrentCustomAction) && CurrentCustomAction.Class == Class'SFXCustomAction_SwatTurn' && bShowActionIcons)
            {
                bForceStop = TRUE;
            }
            else if (CoverType == ECoverType.CT_Standing)
            {
                if (BP.CurrentCustomAction != 24)
                {
                    StartCustomAction(24);
                    DisplayCoverVisualization(CE_HighSwatLeft, Target);
                }
            }
            else if (CoverType == ECoverType.CT_MidLevel)
            {
                if (BP.CurrentCustomAction != 23)
                {
                    StartCustomAction(23);
                    DisplayCoverVisualization(CE_SwatLeft, Target);
                }
            }
        }
        else if (BP.CoverAction == ECoverAction.CA_PeekRight && Input.RawJoyRight > 0.800000012 && BP.bCanSwatTurn == TRUE && Class'SFXCustomAction_SwatTurn_Right'.static.CanPerformSwatTurn(BP, Ignored))
        {
            if (BP.GetCurrentCustomAction(CurrentCustomAction) && CurrentCustomAction.Class == Class'SFXCustomAction_SwatTurn' && bShowActionIcons)
            {
                bForceStop = TRUE;
            }
            else if (CoverType == ECoverType.CT_Standing)
            {
                if (BP.CurrentCustomAction != 24)
                {
                    StartCustomAction(24);
                    DisplayCoverVisualization(CE_HighSwatRight, Target);
                }
            }
            else if (CoverType == ECoverType.CT_MidLevel)
            {
                if (BP.CurrentCustomAction != 23)
                {
                    StartCustomAction(23);
                    DisplayCoverVisualization(CE_SwatRight, Target);
                }
            }
        }
        else if (CoverInfo.Link.Slots[BP.CurrentSlotIdx].bCanCoverSlip_Left && BP.CoverAction == ECoverAction.CA_PeekLeft && Input.RawJoyUp > 0.800000012 && IsCameraAlignedWithCoverSlot(CoverSlipCamAlign))
        {
            if (CoverType == ECoverType.CT_Standing)
            {
                if (BP.CurrentCustomAction != 22)
                {
                    StartCustomAction(22);
                    DisplayCoverVisualization(CE_HighSlipLeft, Target);
                }
            }
            else if (CoverType == ECoverType.CT_MidLevel)
            {
                if (BP.CurrentCustomAction != 21)
                {
                    StartCustomAction(21);
                    DisplayCoverVisualization(CE_SlipLeft, Target);
                }
            }
        }
        else if (CoverInfo.Link.Slots[BP.CurrentSlotIdx].bCanCoverSlip_Right && BP.CoverAction == ECoverAction.CA_PeekRight && Input.RawJoyUp > 0.800000012 && IsCameraAlignedWithCoverSlot(CoverSlipCamAlign))
        {
            if (CoverType == ECoverType.CT_Standing)
            {
                if (BP.CurrentCustomAction != 22)
                {
                    StartCustomAction(22);
                    DisplayCoverVisualization(CE_HighSlipRight, Target);
                }
            }
            else if (CoverType == ECoverType.CT_MidLevel)
            {
                if (BP.CurrentCustomAction != 21)
                {
                    StartCustomAction(21);
                    DisplayCoverVisualization(CE_SlipRight, Target);
                }
            }
        }
        else
        {
            bStopCoverGUI = TRUE;
            eDesiredActionIcon = ESFXHUDActionIcon.SFXHUD_Action_NONE;
        }
    }
    if (HUD != None && int(eDesiredActionIcon) != int(m_eCurrentActionIcon))
    {
        HUD.SetActionIndicator(eDesiredActionIcon);
        m_eCurrentActionIcon = eDesiredActionIcon;
    }
    if (bShowActionIcons && FindJumpPoint(JumpSpec))
    {
        if (!bJumpGUIShowing)
        {
            Target.HitNormal = JumpSpec.GetDirection();
            JumpClientEffectGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_Jump, Target);
            bJumpGUIShowing = TRUE;
        }
    }
    else if (bJumpGUIShowing)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_Jump, JumpClientEffectGuid, TRUE);
        bJumpGUIShowing = FALSE;
    }
    if (!BP.IsInCover() || bStopCoverGUI || bForceStop)
    {
        if (bCoverGUIShowing || bForceStop)
        {
            DisplayCoverVisualization(None, Target);
            CurrentVisualization = ECoverVisualizations.CV_None;
            bShowActionIcons = TRUE;
            if (BP.CurrentCustomAction == 20 || BP.CurrentCustomAction == 21 || BP.CurrentCustomAction == 22 || BP.CurrentCustomAction == 23 || BP.CurrentCustomAction == 24)
            {
                BP.InterruptCustomAction();
            }
        }
        if (!bShowActionIcons)
        {
            if (BP.CurrentCustomAction == 20 || BP.CurrentCustomAction == 21 || BP.CurrentCustomAction == 22 || BP.CurrentCustomAction == 23 || BP.CurrentCustomAction == 24)
            {
                BP.InterruptCustomAction();
            }
        }
    }
}
public function TickJumpDown()
{
    local SFXLadderReachSpec LadderSpec;
    local SFXWeapon PlayerWeapon;
    local SFXNav_LadderNode LadderNode;
    
    PlayerWeapon = SFXWeapon(Pawn.Weapon);
    if (FindLadderNode(LadderSpec) && DetectPressInto(LadderSpec.Start.location, LadderSpec.End.Actor.location))
    {
        LadderNode = SFXNav_LadderNode(LadderSpec.Start);
        if (TryUseLadder(LadderNode))
        {
            if (PlayerWeapon != None)
            {
                PlayerWeapon.CancelReload();
            }
            return;
        }
    }
}
public exec function ToggleSlowFlyCam()
{
    local SFXPlayerCamera TheCamera;
    
    TheCamera = SFXPlayerCamera(PlayerCamera);
    if (TheCamera != None)
    {
        if (Pawn.InFreeCam() == FALSE)
        {
            SetCameraMode('FreeCam');
            TheCamera.m_bIgnoreSlowMo = FALSE;
        }
        else
        {
            ResetCameraMode();
            TheCamera.m_bIgnoreSlowMo = TRUE;
        }
    }
}
public function bool TryUse(Actor Selection)
{
    if (!CanUse(Selection))
    {
        return FALSE;
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        Selection.TriggerEventClass(Class'SeqEvent_Used', Pawn);
        if (IsCombatTargetable(Selection) == FALSE)
        {
            if (Pawn(Selection) != None && BioAiController(Pawn(Selection).Controller) != None)
            {
                BioAiController(Pawn(Selection).Controller).PlayerActivate(Pawn);
            }
        }
        ActivateUseModule(Selection);
        return TRUE;
    }
    else
    {
        ServerUseSelection(Selection);
        return TRUE;
    }
}
public function bool TryUseLadder(SFXNav_LadderNode LadderNode)
{
    if (CanUseLadder(LadderNode))
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            LadderNode.TriggerEventClass(Class'SeqEvent_Used', Pawn);
            LadderNode.OnUse(Pawn);
        }
        else
        {
            ServerUseLadder(LadderNode);
        }
        return TRUE;
    }
    return FALSE;
}
public function UpdateInputConfiguration()
{
    local SFXPRI PRI;
    
    PRI = SFXPRI(PlayerReplicationInfo);
    if (PRI != None)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild() || WorldInfo.bUseConsoleInput)
        {
            GameModeManager2.Console_RestoreBindingsToDefaults();
            GameModeManager2.Console_UpdateStickBindings(PRI.StickConfig);
            GameModeManager2.Console_UpdateTriggerAndShoulderBindings(PRI.TriggerConfig);
            if (Class'WorldInfo'.static.IsConsoleBuild(2))
            {
                GameModeManager2.Console_UpdatePS3ButtonSwapping(Class'BioPlayerInput'.static.IsEnterMenuButtonAssignmentSwapped());
            }
            GameModeManager2.UpdateAllBindMappingCollections();
        }
        else
        {
            LoadPCInputConfiguration();
        }
    }
}
public function UpdateProfileData()
{
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local SFXEngine Engine;
    local int ControllerId;
    local array<AchievementDetails> Achievements;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (OnlineSub != None)
    {
        ControllerId = LocalPlayer(Player).ControllerId;
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            ProfileSettings = SFXProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
            if (ProfileSettings != None)
            {
                Engine = SFXEngine(Player.Outer);
                if (Engine != None)
                {
                    Engine.CacheProfileData(ProfileSettings);
                }
                if (AccomplishmentManager != None)
                {
                    AccomplishmentManager.LoadSettingsData(ProfileSettings);
                }
            }
            bProfileSettingsUpdated = TRUE;
            PlayerIntEx = OnlineSub.PlayerInterfaceEx;
            if (PlayerIntEx != None && int(PlayerInterface.GetLoginStatus(byte(ControllerId))) != 0)
            {
                PlayerInterface.GetAchievements(byte(ControllerId), Achievements);
                if (Achievements.Length == 0)
                {
                    PlayerInterface.AddReadAchievementsCompleteDelegate(byte(ControllerId), NotifyReadAchievementsComplete);
                    if (PlayerInterface.ReadAchievements(byte(ControllerId)) == FALSE)
                    {
                        PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(ControllerId), NotifyReadAchievementsComplete);
                    }
                }
                else if (AccomplishmentManager != None)
                {
                    AccomplishmentManager.LoadAchievementData(Achievements, Self);
                }
            }
        }
    }
}
public final function UpdateSquadPlayerPawn(BioPlayerSquad PlayerSquad, BioPawn oBioPawn)
{
    if (PlayerSquad != None && IsLocalPlayerController() && oBioPawn != PlayerSquad.m_playerPawn)
    {
        if (PlayerSquad.m_InitialPlayerPawn == None)
        {
            PlayerSquad.m_InitialPlayerPawn = PlayerSquad.m_playerPawn;
        }
        else if (PlayerSquad.m_playerPawn != PlayerSquad.m_InitialPlayerPawn)
        {
            PlayerSquad.RemoveMember(PlayerSquad.m_playerPawn);
        }
        PlayerSquad.SetPlayerPawn(oBioPawn);
    }
}
public function UpdateUIProfileSettings(SFXProfileSettings oProfileSettings)
{
    Class'SFXGUIInteraction'.static.GetInstance().UpdateProfileSettings(oProfileSettings);
}
public exec function ViewNextPlayer();

public unreliable server function WalkingServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag)
{
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, 'PlayerWalking');
}

state PlayerFlying 
{
    ignores Bump, SeePlayer, HearNoise
    ;
    public function PlayerMove(float DeltaTime)
    {
        local Vector vNewAccel;
        local Rotator rCamRotation;
        local Rotator rNewRotation;
        local Rotator rNewDirection;
        local float fMoveTheta;
        local float fMoveMag;
        local float fWalkMag;
        local bool bSetRotate;
        local BioPawn MyBP;
        local BioCustomAction CustomAction;
        
        MyBP = BioPawn(Pawn);
        bSetRotate = FALSE;
        vNewAccel = vect(0.0, 0.0, 0.0);
        fWalkMag = MyBP.WalkSpeed / MyBP.GroundSpeed;
        fMoveMag = Sqrt(RemappedJoyRight * RemappedJoyRight + RemappedJoyUp * RemappedJoyUp);
        if (fMoveMag > 0.0)
        {
            fMoveMag = FClamp(fMoveMag, fWalkMag, 1.0);
        }
        fMoveTheta = Atan2(PlayerInput.aStrafe, PlayerInput.aForward);
        rCamRotation = PlayerCamera.CameraCache.POV.Rotation;
        rCamRotation.Pitch = 0;
        if (fMoveMag > 0.0)
        {
            if (!MyBP.bCombatPawn)
            {
                rNewRotation = rCamRotation;
                rNewRotation.Yaw = int(float((rNewRotation.Yaw & 65535)) + fMoveTheta * 57.2957802 * 182.044449);
                vNewAccel = (vect(1.0, 0.0, 0.0) >> Pawn.Rotation) * (Pawn.AccelRate * fMoveMag);
                bSetRotate = TRUE;
            }
            else
            {
                rNewDirection = rCamRotation;
                rNewDirection.Yaw = int(float(rNewDirection.Yaw) + fMoveTheta * 57.2957802 * 182.044449);
                vNewAccel = (vect(1.0, 0.0, 0.0) >> rNewDirection) * (Pawn.AccelRate * fMoveMag);
            }
        }
        if (bSetRotate)
        {
            MyBP.SetDesiredRotation(rNewRotation);
        }
        if (m_bDEBUGFlyUpPressed)
        {
            vNewAccel = vNewAccel + vect(0.0, 0.0, 1.0) * Pawn.AccelRate;
            fMoveMag = 1.0;
        }
        else if (m_bDEBUGFlyDownPressed)
        {
            vNewAccel = vNewAccel + vect(0.0, 0.0, -1.0) * Pawn.AccelRate;
            fMoveMag = 1.0;
        }
        if (VSize(vNewAccel) < 1.0)
        {
            vNewAccel = vect(0.0, 0.0, 0.0);
        }
        MyBP.SetDesiredSpeed(fMoveMag);
        MyBP.fMoveMag = fMoveMag;
        if (MyBP != None)
        {
            MyBP.GetCurrentCustomAction(CustomAction);
        }
        if (Role < ENetRole.ROLE_Authority && (CustomAction == None || CustomAction.bForceLocalSimulation == FALSE))
        {
            ReplicateMove(DeltaTime, vNewAccel, 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, vNewAccel, 0, rot(0, 0, 0));
        }
    }
    
    stop;
};
state PlayerInCover extends PlayerWalking 
{
    public unreliable server function StandardServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag, Name ControllerState)
    {
        if (CurrentTimeStamp >= TimeStamp)
        {
            return;
        }
        if (ControllerState != 'PlayerInCover' && ClientLoc != vect(1.0, 2.0, 3.0))
        {
            LeaveCover();
        }
        Global.StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, ControllerState);
    }
    public function UpdatePlayerPosture(float DeltaTime, out int out_BreakFromCover, out ECoverAction out_PawnCA, out ECoverDirection out_PawnCD, out ECoverDirection out_PawnMoveCD)
    {
        local BioPawn BioPawn;
        local int SlotIdx;
        local CoverSlot CurrentSlot;
        local bool bIsAtSlot;
        local bool bJoyUpDominant;
        local bool bJoyRightDominant;
        local bool bJoyIsLeft;
        local bool bJoyIsRight;
        local ECoverDirection PreviousPawnCD;
        local ECoverAction PreviousPawnCA;
        local bool bCanMoveRight;
        local bool bCanMoveLeft;
        
        BioPawn = BioPawn(Pawn);
        SlotIdx = BioPawn.GetSlotIdxByPct();
        CurrentSlot = BioPawn.CurrentLink.Slots[SlotIdx];
        bIsAtSlot = BioPawn.IsOnACoverSlot();
        bPreferLeanOverPopup = FALSE;
        bJoyUpDominant = Abs(RemappedJoyUp) > Abs(RemappedJoyRight);
        bJoyRightDominant = Abs(RemappedJoyRight) > Abs(RemappedJoyUp);
        if (bJoyRightDominant && Abs(RemappedJoyRight) > DeadZoneThreshold)
        {
            bJoyIsLeft = RemappedJoyRight < -DeadZoneThreshold;
            bJoyIsRight = RemappedJoyRight > DeadZoneThreshold;
            bPreferLeanOverPopup = TRUE;
        }
        else
        {
            bJoyIsLeft = FALSE;
            bJoyIsRight = FALSE;
        }
        out_BreakFromCover = 0;
        if (bJoyUpDominant)
        {
            if (RemappedJoyUp < -DeadZoneThreshold)
            {
                if (out_PawnCA != ECoverAction.CA_LeanRight && out_PawnCA != ECoverAction.CA_LeanLeft && out_PawnCA != ECoverAction.CA_BlindRight && out_PawnCA != ECoverAction.CA_BlindLeft)
                {
                    out_BreakFromCover = 1;
                }
            }
        }
        if (out_BreakFromCover == 0)
        {
            PreviousPawnCD = out_PawnCD;
            PreviousPawnCA = out_PawnCA;
            DetermineLeanDirection(BioPawn, CurrentSlot, out_PawnCA, out_PawnCD);
            if (SFXPlayerController(Self).bLeanDisabled)
            {
                out_PawnCA = ECoverAction.CA_Default;
            }
            if (out_PawnCA != ECoverAction.CA_PopUp && out_PawnCA != ECoverAction.CA_Default)
            {
                out_PawnMoveCD = ECoverDirection.CD_Default;
            }
            else if (int(out_PawnCA) != int(PreviousPawnCA))
            {
                out_PawnMoveCD = ECoverDirection.CD_Default;
            }
            else if (out_PawnCA != ECoverAction.CA_PopUp && int(out_PawnCD) != int(PreviousPawnCD))
            {
                out_PawnMoveCD = ECoverDirection.CD_Default;
            }
            else
            {
                CoverTransitionCountHold += DeltaTime;
                out_PawnMoveCD = ECoverDirection.CD_Default;
                if (bJoyIsRight && out_PawnCD == ECoverDirection.CD_Right)
                {
                    bCanMoveRight = DetermineCanMoveInCoverDirection(BioPawn, 2);
                    if (bCanMoveRight)
                    {
                        out_PawnMoveCD = ECoverDirection.CD_Right;
                    }
                }
                else if (bJoyIsLeft && out_PawnCD == ECoverDirection.CD_Left)
                {
                    bCanMoveLeft = DetermineCanMoveInCoverDirection(BioPawn, 1);
                    if (bCanMoveLeft)
                    {
                        out_PawnMoveCD = ECoverDirection.CD_Left;
                    }
                }
            }
            if (BioPawn.bIsInStationaryCover)
            {
                if (!bIsAtSlot)
                {
                    SetIsInStationaryCover(FALSE);
                }
                else if (out_PawnMoveCD != ECoverDirection.CD_Default)
                {
                    SetIsInStationaryCover(FALSE);
                }
            }
        }
    }
    public function bool DetermineCanMoveInCoverDirection(BioPawn BioPawn, ECoverDirection DesiredDirection)
    {
        local bool bCanMove;
        local bool bIsAtSlot;
        local bool bIsStationary;
        local int SlotIdx;
        local CoverSlot CurrentSlot;
        
        bIsAtSlot = BioPawn.CurrentSlotPct < 0.100000001 || BioPawn.CurrentSlotPct > 0.899999976;
        bIsStationary = BioPawn.bIsInStationaryCover;
        if (!bIsAtSlot || !bIsStationary)
        {
            bCanMove = TRUE;
        }
        else if (DesiredDirection == ECoverDirection.CD_Right && BioPawn.IsAtRightEdgeSlot() || DesiredDirection == ECoverDirection.CD_Left && BioPawn.IsAtLeftEdgeSlot())
        {
            bCanMove = FALSE;
        }
        else
        {
            SlotIdx = BioPawn.GetSlotIdxByPct();
            CurrentSlot = BioPawn.CurrentLink.Slots[SlotIdx];
            if (DesiredDirection == ECoverDirection.CD_Right && !CurrentSlot.bLeanRight || DesiredDirection == ECoverDirection.CD_Left && !CurrentSlot.bLeanLeft)
            {
                bCanMove = TRUE;
            }
            else if (CoverTransitionCountHold >= PlayerCoverTransitionTime)
            {
                bCanMove = TRUE;
            }
            else
            {
                bCanMove = FALSE;
            }
        }
        return bCanMove;
    }
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn BioPawn;
        local int PawnBreakCover;
        local Rotator YawRotation;
        local float D1;
        local float D2;
        local float CamDot;
        local ECoverAction PawnCoverAction;
        local ECoverDirection PawnCoverDirection;
        local ECoverDirection PawnMoveCoverDirection;
        local Vector MoveStickDir;
        local float Dot;
        local SFXWeapon WP;
        local bool bPushOffCover;
        
        BioPawn = BioPawn(Pawn);
        if (BioPawn != None && BioPawn.IsInCover())
        {
            MoveStickDir = vect(0.0, 0.0, 0.0);
            MoveStickDir.X = PlayerInput.RawJoyUp;
            MoveStickDir.Y = PlayerInput.RawJoyRight;
            MoveStickDir = Vector(Rotation + Rotator(MoveStickDir));
            MoveStickDir.Z = 0.0;
            MoveStickDir = Normal(MoveStickDir);
            if (!bBreakFromCover)
            {
                if (Class'WorldInfo'.static.IsConsoleBuild())
                {
                    Dot = MoveStickDir Dot Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.CurrentSlotIdx));
                }
                else
                {
                    Dot = PlayerInput.RawJoyUp;
                }
                if (Dot < -0.707000017 && PawnCoverAction != ECoverAction.CA_LeanRight && PawnCoverAction != ECoverAction.CA_LeanLeft && !IsMoveInputIgnored() && BioWorldInfo(WorldInfo).bPlayersOnly == FALSE)
                {
                    CoverBreakTimer += DeltaTime;
                    if (CoverBreakTimer >= CoverBreakTimeThreshold)
                    {
                        PawnCoverAction = GetPawnCoverAction();
                        PawnCoverDirection = GetCoverDirection();
                        PawnMoveCoverDirection = BioPawn.CurrentSlotDirection;
                        UpdatePlayerPosture(DeltaTime, PawnBreakCover, PawnCoverAction, PawnCoverDirection, PawnMoveCoverDirection);
                        if (IsCameraAlignedWithCoverSlot())
                        {
                            bPushOffCover = TRUE;
                        }
                        bBreakFromCover = TRUE;
                        SFXWeapon(BioPawn.Weapon).CancelReload();
                    }
                }
                else
                {
                    CoverBreakTimer = 0.0;
                }
            }
            if (SFXWeapon_SniperRifle_Base(Pawn.Weapon) != None && IsZoomed())
            {
                bBreakFromCover = FALSE;
            }
            if (bBreakFromCover && !BioPawn.IsInAnimatedTransition())
            {
                BioPawn.LeaveCover();
                BioPawn.SetAnimatedTransitionPending();
                if (bPushOffCover)
                {
                    GotoState('PlayerPushOffCover', , , );
                }
                else
                {
                    GotoState('PlayerWalking', , , );
                }
            }
            else if (!IsMoveInputIgnored() && BioWorldInfo(WorldInfo).bPlayersOnly == FALSE)
            {
                PawnCoverAction = GetPawnCoverAction();
                PawnCoverDirection = GetCoverDirection();
                PawnMoveCoverDirection = BioPawn.CurrentSlotDirection;
                YawRotation.Yaw = Rotation.Yaw;
                D1 = Vector(YawRotation) Dot Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.LeftSlotIdx));
                D2 = Vector(YawRotation) Dot Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.RightSlotIdx));
                CamDot = FMax(D1, D2);
                if (BioPawn.CoverType == ECoverType.CT_Standing && CamDot < 0.300000012 || BioPawn.CoverType == ECoverType.CT_MidLevel && CamDot < 0.0)
                {
                    GotoState('PlayerInAimBack', , , );
                    return;
                }
                if (int(bWantsToStorm) == 1)
                {
                    if (BioPawn.CurrentCustomAction != 0)
                    {
                        return;
                    }
                }
                UpdatePlayerPosture(DeltaTime, PawnBreakCover, PawnCoverAction, PawnCoverDirection, PawnMoveCoverDirection);
                if (!BioPawn.IsInAnimatedTransition())
                {
                    if (int(BioPawn.CoverAction) == int(PawnCoverAction) && IsTimerActive('ResetCoverAction'))
                    {
                        ClearTimer('ResetCoverAction');
                    }
                    if (int(BioPawn.CoverAction) != int(PawnCoverAction) || int(BioPawn.CoverDirection) != int(PawnCoverDirection))
                    {
                        if (!BioPawn.IsUsingPower())
                        {
                            if (int(BioPawn.CoverDirection) != int(PawnCoverDirection) || BioPawn.IsInCoverLeaning() == FALSE || PawnCoverAction != ECoverAction.CA_Default && PawnCoverAction != ECoverAction.CA_PeekLeft && PawnCoverAction != ECoverAction.CA_PeekRight)
                            {
                                if (PawnCoverAction == ECoverAction.CA_LeanLeft && BioPawn.CoverAction == ECoverAction.CA_BlindLeft)
                                {
                                    PawnCoverAction = ECoverAction.CA_PeekLeft;
                                }
                                else if (PawnCoverAction == ECoverAction.CA_LeanRight && BioPawn.CoverAction == ECoverAction.CA_BlindRight)
                                {
                                    PawnCoverAction = ECoverAction.CA_PeekRight;
                                }
                                else if (PawnCoverAction == ECoverAction.CA_PopUp && BioPawn.CoverAction == ECoverAction.CA_BlindUp)
                                {
                                    PawnCoverAction = ECoverAction.CA_Default;
                                }
                                BioPawn.SetCoverAction(PawnCoverAction);
                                BioPawn.SetAnimatedTransitionPending();
                            }
                            else if (IsTimerActive('ResetCoverAction') == FALSE)
                            {
                                WP = SFXWeapon(BioPawn.Weapon);
                                if (WP != None)
                                {
                                    if (BioPawn.IsLeaning())
                                    {
                                        SetTimer(WP.CoverLeanExitDelay, FALSE, 'ResetCoverAction', );
                                    }
                                    else if (BioPawn.IsBlindFiring())
                                    {
                                        SetTimer(WP.CoverPartialLeanExitDelay, FALSE, 'ResetCoverAction', );
                                    }
                                }
                            }
                        }
                        BioPawn.SetCoverDirection(PawnCoverDirection);
                        switch (PawnCoverAction)
                        {
                            case ECoverAction.CA_LeanLeft:
                            case ECoverAction.CA_LeanRight:
                                bPreferLeanOverPopup = FALSE;
                                break;
                            case ECoverAction.CA_PopUp:
                            case ECoverAction.CA_PeekUp:
                                bPreferLeanOverPopup = FALSE;
                                break;
                            default:
                                break;
                        }
                    }
                }
                BioPawn.CurrentSlotDirection = PawnMoveCoverDirection;
            }
            else if (GameModeManager2.StopsMovement())
            {
                BioPawn.CurrentSlotDirection = ECoverDirection.CD_Default;
            }
            if (!bBreakFromCover)
            {
                if (BioPawn.CoverAction == ECoverAction.CA_PopUp)
                {
                    BioPawn.ShouldCrouch(FALSE);
                }
                else if (BioPawn.CoverAction == ECoverAction.CA_LeanLeft || BioPawn.CoverAction == ECoverAction.CA_LeanRight)
                {
                    BioPawn.ShouldCrouch(BioPawn.bIsCrouched);
                }
                else if (BioPawn.CoverType == ECoverType.CT_MidLevel)
                {
                    BioPawn.ShouldCrouch(TRUE);
                }
            }
        }
        else
        {
            GotoState('PlayerWalking', , , );
        }
        Super.PlayerMove(DeltaTime);
    }
    public function EndState(Name NextStateName)
    {
        local BioPawn pPawn;
        local SFXWeapon PlayerWeapon;
        
        Super.EndState(NextStateName);
        pPawn = BioPawn(Pawn);
        if (NextStateName != 'PlayerInAimBack')
        {
            CoverLog("NextStateName:" @ NextStateName, string(GetFuncName()));
            if (pPawn != None && pPawn.IsInCover())
            {
                pPawn.LeaveCover();
            }
        }
        if (IsTimerActive('ResetCoverAction'))
        {
            ClearTimer('ResetCoverAction');
            ResetCoverAction();
        }
        if (IsTimerActive('ReenableCoverIcons'))
        {
            ClearTimer('ReenableCoverIcons');
        }
        PlayerWeapon = SFXWeapon(pPawn.Weapon);
        if (PlayerWeapon != None)
        {
            PlayerWeapon.SetRTPCPlayerPosition(1);
        }
    }
    public function ReenableCoverIcons();
    
    public function BeginState(Name PreviousStateName)
    {
        local BioPawn pPawn;
        local SFXWeapon PlayerWeapon;
        
        Super.BeginState(PreviousStateName);
        CoverLog("PreviousStateName:" @ PreviousStateName, string(GetFuncName()));
        CoverTransitionCountHold = 0.0;
        CoverBreakTimer = 0.0;
        pPawn = BioPawn(Pawn);
        if (pPawn != None && pPawn.CoverType == ECoverType.CT_MidLevel)
        {
            pPawn.ShouldCrouch(TRUE);
        }
        if (PreviousStateName != 'PlayerInAimBack')
        {
            bPreferLeanOverPopup = FALSE;
        }
        Class'SFXGUIInteraction'.static.GetInstance().HideCoverWidget(Self);
        if (PreviousStateName != 'PlayerInAimBack')
        {
            bBreakFromCover = FALSE;
        }
        PlayerWeapon = SFXWeapon(pPawn.Weapon);
        if (PlayerWeapon != None)
        {
            PlayerWeapon.SetRTPCPlayerPosition(5);
        }
        CleanOutSavedMoves();
        SetTimer(0.25, FALSE, 'ReenableCoverIcons', );
    }
    public function bool IsInCoverState()
    {
        return TRUE;
    }
    public event function PlayerTick(float DeltaTime)
    {
        Global.PlayerTick(DeltaTime);
    }
    public function BreakFromCover(optional Vector BreakDir)
    {
        bBreakFromCover = TRUE;
    }
    
    stop;
};
simulated state PlayerPushOffCover extends PlayerWalking 
{
    public function PlayerTick(float DeltaTime)
    {
        Super.PlayerTick(DeltaTime);
        PushOffTimeToGo -= DeltaTime;
        if (PushOffTimeToGo <= 0.0)
        {
            GotoState('PlayerWalking', , , );
        }
    }
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn PawnAsBioPawn;
        local bool bBlockMovement;
        local float MoveStickMag;
        local float MoveStickAngle;
        local Rotator MoveStickRot;
        local Rotator OldRotation;
        local SFXEngine Engine;
        local BioCustomAction CustomAction;
        
        PawnAsBioPawn = BioPawn(Pawn);
        if (PawnAsBioPawn == None)
        {
            return;
        }
        if (GameModeManager2.AllowsMovement() == FALSE || Pawn.IsInState('RagdollRecovery', ) || bLockPosition)
        {
            bBlockMovement = TRUE;
        }
        else
        {
            bBlockMovement = FALSE;
        }
        ComputeMovementStickAngle(MoveStickMag, MoveStickAngle, MoveStickRot);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        if (bBlockMovement == FALSE && Pawn.Physics == EPhysics.PHYS_Walking)
        {
            Engine = SFXEngine(Player.Outer);
            if (PawnAsBioPawn.bStorming)
            {
                PlayerMoveStorming(DeltaTime, MoveStickMag, MoveStickRot);
            }
            else if (PawnAsBioPawn.bCombatPawn && (Engine == None || !Engine.IsInCinematicMode()))
            {
                PlayerMoveCombat(DeltaTime, MoveStickMag);
            }
            else
            {
                PlayerMoveExplore(DeltaTime, MoveStickMag, MoveStickAngle, MoveStickRot);
            }
        }
        else if (Pawn.Physics == EPhysics.PHYS_Walking || Pawn.Physics == EPhysics.PHYS_Interpolating || Pawn.Physics == EPhysics.PHYS_None)
        {
            PawnAsBioPawn.StopMovement(TRUE);
        }
        PawnAsBioPawn.Acceleration = PawnAsBioPawn.AccelRate * PushOffCoverDir;
        PawnAsBioPawn.fMoveMag = 1.0;
        PawnAsBioPawn.GetCurrentCustomAction(CustomAction);
        if (Role < ENetRole.ROLE_Authority && (CustomAction == None || CustomAction.bForceLocalSimulation == FALSE))
        {
            ReplicateMove(DeltaTime, PawnAsBioPawn.Acceleration, 0, OldRotation - PawnAsBioPawn.DesiredRotation);
        }
        else
        {
            ProcessMove(DeltaTime, PawnAsBioPawn.Acceleration, 0, OldRotation - PawnAsBioPawn.DesiredRotation);
        }
    }
    public function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        if (IsLocalPlayerController())
        {
            PushOffCoverDir = Vector(PlayerCamera.CameraCache.POV.Rotation + Rotator(BioPlayerInput(PlayerInput).MoveStick));
        }
        else
        {
            PushOffCoverDir = -Vector(Pawn.Rotation);
        }
        PushOffTimeToGo = PushOffCoverDuration;
    }
    
    stop;
};
state PlayerInAimBack extends PlayerWalking 
{
    public unreliable server function StandardServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View, byte MoveMag, Name ControllerState)
    {
        if (CurrentTimeStamp >= TimeStamp)
        {
            return;
        }
        if (ControllerState != 'PlayerInAimBack' && ClientLoc != vect(1.0, 2.0, 3.0))
        {
            LeaveCover();
        }
        Global.StandardServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View, MoveMag, ControllerState);
    }
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn BioPawn;
        local float CamDot;
        local Rotator YawRotation;
        local Vector CamCross;
        local Rotator Ignored;
        
        BioPawn = BioPawn(Pawn);
        if (BioPawn.CurrentLink == None)
        {
            GotoState('PlayerWalking', , , );
            return;
        }
        YawRotation.Yaw = Rotation.Yaw;
        CamDot = FMax(Vector(YawRotation) Dot Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.LeftSlotIdx)), Vector(YawRotation) Dot Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.RightSlotIdx)));
        if (BioPawn.CoverType == ECoverType.CT_Standing && CamDot > 0.600000024 || BioPawn.CoverType == ECoverType.CT_MidLevel && CamDot > 0.100000001)
        {
            BioPawn.m_eTurningDirection = EBioAnimTurnDirState.eBioAnimTurn_NoTurn;
            BioPawn.CoverAction = ECoverAction.CA_Default;
            if (BioPawn.CoverType == ECoverType.CT_MidLevel)
            {
            }
            GotoState('PlayerInCover', , , );
            return;
        }
        BioPawn.CalcIdealCoverPos(BioPawn.CurrentSlotPct, AimbackBounds.Origin, Ignored);
        if (VSize(Pawn.location - AimbackBounds.Origin) > AimbackBounds.SphereRadius)
        {
            GotoState('PlayerPushOffCover', , , );
            return;
        }
        CamCross = Vector(BioPawn.CurrentLink.GetSlotRotation(BioPawn.CurrentSlotIdx)) Cross Vector(Rotation);
        if (CamCross.Z < float(0))
        {
            BioPawn.CoverDirection = ECoverDirection.CD_Left;
        }
        else
        {
            BioPawn.CoverDirection = ECoverDirection.CD_Right;
        }
        Super.PlayerMove(DeltaTime);
    }
    public function EndState(Name NextState)
    {
        local BioPawn BioPawn;
        
        Super.EndState(NextState);
        BioPawn = BioPawn(Pawn);
        if (NextState == 'PlayerInCover')
        {
            BioPawn.CoverAction = ECoverAction.CA_Default;
        }
        else
        {
            BioPawn.LeaveCover();
        }
    }
    public function BeginState(Name PreviousState)
    {
        local BioPawn BioPawn;
        
        Super.BeginState(PreviousState);
        BioPawn = BioPawn(Pawn);
        BioPawn.TemporaryAimInterpSpeed = 1.0;
        AimbackBounds.BoxExtent = vect(20.0, 20.0, 20.0);
        AimbackBounds.SphereRadius = 50.0;
        if (BioPawn.CoverType == ECoverType.CT_MidLevel && (IsZoomed() == FALSE || BioPawn.CoverAction == ECoverAction.CA_LeanLeft || BioPawn.CoverAction == ECoverAction.CA_LeanRight))
        {
            BioPawn.ShouldCrouch(TRUE);
        }
        BioPawn.CoverAction = ECoverAction.CA_Aimback;
        CleanOutSavedMoves();
    }
    
    stop;
};
state PlayerDriving 
{
    public function bool NotifyBump(Actor Other, Vector HitNormal)
    {
        SFXVehicleHover(Pawn).NotifyBump(Other, HitNormal);
        return Super(Controller).NotifyBump(Other, HitNormal);
    }
    public function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot;
        local Rotator ViewRotation;
        
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
    }
    public unreliable server function ServerUse();
    
    public function EndState(Name NextStateName)
    {
        GameModeManager2.DisableMode(1);
    }
    public function BeginState(Name PreviousStateName)
    {
        Pawn.Weapon.GotoState('Active', , , );
        GameModeManager2.EnableMode(1);
        CleanOutSavedMoves();
    }
    
    stop;
};
state PlayerWalking 
{
    public function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        CleanOutSavedMoves();
    }
    public event function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local BioPawn BP;
        local SFXModule_Locomotion Locomotion;
        local Rotator CoverRotation;
        
        BP = BioPawn(Pawn);
        if (BP == None)
        {
            Super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        }
        else
        {
            if (IsLocalPlayerController() == FALSE || bUpdating)
            {
                BP.Acceleration = newAccel;
                if (BP.IsInCover())
                {
                    CoverRotation = BP.CurrentLink.GetSlotRotation(BP.CurrentSlotIdx);
                    BP.FaceRotation(CoverRotation, DeltaTime);
                    BP.SetDesiredRotation(CoverRotation);
                }
                else
                {
                    BP.SetDesiredRotation(Rotation, FALSE, FALSE, RemotePlayersRotationInterpolationSpeed);
                }
            }
            Locomotion = BP.GetModule(Class'SFXModule_Locomotion');
            if (Locomotion != None)
            {
                Locomotion.SetDesiredRotation(BP.DesiredRotation);
                Locomotion.SetAcceleration(BP.Acceleration);
            }
        }
    }
    public function PlayerMoveExplore(float DeltaTime, float MoveMag, float MoveAngle, Rotator MoveRot)
    {
        local Vector MoveDir;
        local Rotator MoveFacing;
        local float MoveWalkModifier;
        local float MoveWalkModifierAlpha;
        local Rotator MoveRot2D;
        local float MoveAccMag;
        local BioCustomAction CustomAction;
        local BioPawn MyBP;
        
        MyBP = BioPawn(Pawn);
        if (MyBP == None)
        {
            return;
        }
        MoveRot2D.Yaw = MoveRot.Yaw;
        MoveRot2D.Pitch = 0;
        MoveRot2D.Roll = 0;
        MoveWalkModifier = 1.0;
        if (MoveMag > MoveStickIdleThreshold)
        {
            MoveAccMag = MyBP.AccelRate;
            if (MyBP.bIsCrouched)
            {
                MyBP.ShouldCrouch(FALSE);
            }
            if (!MyBP.bIsCrouched)
            {
                if (!MyBP.bIsWalking)
                {
                    if (MoveMag >= MoveStickRunThreshold)
                    {
                        MoveWalkModifier = 1.0;
                    }
                    else if (MoveMag >= MoveStickWalkThreshold)
                    {
                        MoveWalkModifier = MyBP.WalkSpeed / MyBP.GroundSpeed;
                    }
                    else
                    {
                        MoveWalkModifier = MoveMag / MoveStickWalkThreshold * MyBP.WalkSpeed / MyBP.GroundSpeed;
                    }
                }
            }
            if (MyBP.bIsCrouched)
            {
                MoveFacing = MyBP.Rotation;
            }
            else
            {
                MoveFacing = MoveRot2D;
            }
            MoveDir = Vector(MoveFacing);
        }
        else
        {
            MoveDir = vect(1.0, 0.0, 0.0);
            MoveWalkModifier = 0.0;
            MoveAccMag = 0.0;
            MoveFacing = MyBP.Rotation;
        }
        if (MoveWalkModifier < MyBP.fMoveMag)
        {
            MoveWalkModifierAlpha = DeltaTime / MoveWalkModifierBlendTime;
            if (MoveWalkModifierAlpha > 1.0)
            {
                MoveWalkModifierAlpha = 1.0;
            }
            MoveWalkModifier = MyBP.fMoveMag + MoveWalkModifierAlpha * (MoveWalkModifier - MyBP.fMoveMag);
        }
        if (IsMoveInputIgnored() == FALSE)
        {
            MyBP.fMoveMag = MoveWalkModifier;
            MyBP.Acceleration = MoveAccMag * MoveDir;
        }
        else
        {
            MyBP.fMoveMag = 1.0;
            MyBP.Acceleration *= 0.0;
        }
        if (MyBP.GetCurrentCustomAction(CustomAction))
        {
            if (CustomAction.bLockPawnRotation)
            {
                return;
            }
            if (MyBP.Mesh != None && MyBP.Mesh.RootMotionRotationMode == ERootMotionRotationMode.RMRM_RotateActor)
            {
                return;
            }
        }
        MyBP.SetDesiredRotation(MoveFacing);
    }
    public function PlayerMoveCombat(float DeltaTime, float MoveMag)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        local Vector newAccel;
        local BioCustomAction CustomAction;
        local BioPawn MyBP;
        local Rotator NewRotation;
        local Rotator LeftCoverRot;
        local Rotator RightCoverRot;
        
        MyBP = BioPawn(Pawn);
        if (MyBP == None)
        {
            return;
        }
        if (MoveMag > MoveStickIdleThreshold)
        {
            if (MyBP.IsInCover() == FALSE)
            {
                if (MoveMag >= MoveStickRunThreshold || MyBP.bIsWalking)
                {
                    MyBP.fMoveMag = 1.0;
                }
                else if (MoveMag >= MoveStickWalkThreshold)
                {
                    MyBP.fMoveMag = MyBP.CombatWalkSpeed / MyBP.CombatGroundSpeed;
                }
                else
                {
                    MyBP.fMoveMag = MoveMag / MoveStickWalkThreshold * MyBP.CombatWalkSpeed / MyBP.CombatGroundSpeed;
                }
            }
            else
            {
                MyBP.fMoveMag = 1.0;
            }
        }
        else
        {
            MyBP.fMoveMag = 0.0;
        }
        if (IsMoveInputIgnored())
        {
            MyBP.fMoveMag = 1.0;
        }
        GetAxes(Pawn.Rotation, X, Y, Z);
        newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
        newAccel.Z = 0.0;
        newAccel = Pawn.AccelRate * Normal(newAccel);
        MyBP.Acceleration = newAccel;
        if (MyBP.GetCurrentCustomAction(CustomAction))
        {
            if (CustomAction.bLockPawnRotation)
            {
                return;
            }
            if (MyBP.Mesh != None && MyBP.Mesh.RootMotionRotationMode == ERootMotionRotationMode.RMRM_RotateActor)
            {
                return;
            }
        }
        if (MyBP.IsInCover() == FALSE)
        {
            NewRotation.Yaw = Rotation.Yaw;
        }
        else if (MyBP.CurrentLink.Slots.Length == 1 || MyBP.LeftSlotIdx == MyBP.RightSlotIdx)
        {
            NewRotation = MyBP.CurrentLink.GetSlotRotation(MyBP.CurrentSlotIdx);
        }
        else
        {
            LeftCoverRot = MyBP.CurrentLink.GetSlotRotation(MyBP.LeftSlotIdx);
            RightCoverRot = MyBP.CurrentLink.GetSlotRotation(MyBP.RightSlotIdx);
            if (Abs(float(NormalizeRotAxis(LeftCoverRot.Yaw - RightCoverRot.Yaw))) < 10922.0)
            {
                NewRotation = RLerp(LeftCoverRot, RightCoverRot, MyBP.CurrentSlotPct, TRUE);
            }
            else
            {
                NewRotation = MyBP.CurrentLink.GetSlotRotation(MyBP.CurrentSlotIdx);
            }
        }
        NewRotation.Pitch = 0;
        NewRotation.Roll = 0;
        Pawn.SetDesiredRotation(NewRotation);
    }
    public function PlayerMoveStorming(float DeltaTime, float MoveMag, Rotator MoveRot)
    {
        local BioCustomAction CustomAction;
        local BioPawn MyBP;
        local Vector newAccel;
        local Rotator NewRotation;
        
        MyBP = BioPawn(Pawn);
        if (MyBP == None)
        {
            return;
        }
        MyBP.fMoveMag = 1.0;
        if (IsMoveInputIgnored() == FALSE && MoveMag <= MoveStickIdleThreshold)
        {
            MyBP.fMoveMag = 0.0;
        }
        NewRotation.Pitch = MyBP.Rotation.Pitch;
        NewRotation.Roll = MyBP.Rotation.Roll;
        NewRotation.Yaw = LerpMovementStickAngle(MoveRot.Yaw, Pawn.Rotation.Yaw, MyBP.StormTurnSpeed, DeltaTime);
        newAccel = Pawn.AccelRate * Vector(NewRotation);
        if (IsMoveInputIgnored() == FALSE)
        {
            MyBP.Acceleration = newAccel;
        }
        else
        {
            MyBP.Acceleration *= 0.0;
        }
        if (MyBP.GetCurrentCustomAction(CustomAction))
        {
            if (CustomAction.bLockPawnRotation)
            {
                return;
            }
            if (MyBP.Mesh != None && MyBP.Mesh.RootMotionRotationMode == ERootMotionRotationMode.RMRM_RotateActor)
            {
                return;
            }
        }
        MyBP.SetDesiredRotation(NewRotation);
    }
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn PawnAsBioPawn;
        local bool bBlockMovement;
        local bool bIsInRagdoll;
        local float MoveStickMag;
        local float MoveStickAngle;
        local Rotator MoveStickRot;
        local Rotator OldRotation;
        local SFXEngine Engine;
        local BioCustomAction CustomAction;
        
        PawnAsBioPawn = BioPawn(Pawn);
        if (PawnAsBioPawn == None)
        {
            return;
        }
        if (GameModeManager2.AllowsMovement() == FALSE || Pawn.IsInState('RagdollRecovery', ) || bLockPosition)
        {
            bBlockMovement = TRUE;
        }
        else
        {
            bBlockMovement = FALSE;
        }
        ComputeMovementStickAngle(MoveStickMag, MoveStickAngle, MoveStickRot);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        if (bBlockMovement == FALSE && Pawn.Physics == EPhysics.PHYS_Walking)
        {
            Engine = SFXEngine(Player.Outer);
            if (PawnAsBioPawn.bStorming)
            {
                PlayerMoveStorming(DeltaTime, MoveStickMag, MoveStickRot);
            }
            else if (PawnAsBioPawn.bCombatPawn && (Engine == None || !Engine.IsInCinematicMode()))
            {
                PlayerMoveCombat(DeltaTime, MoveStickMag);
            }
            else
            {
                PlayerMoveExplore(DeltaTime, MoveStickMag, MoveStickAngle, MoveStickRot);
            }
        }
        else if (Pawn.Physics == EPhysics.PHYS_Walking || Pawn.Physics == EPhysics.PHYS_Interpolating || Pawn.Physics == EPhysics.PHYS_None)
        {
            PawnAsBioPawn.StopMovement(TRUE);
        }
        if (Pawn.Physics == EPhysics.PHYS_RigidBody || PawnAsBioPawn.IsInState('InRagdoll', ) || PawnAsBioPawn.IsInState('RagdollRecovery', ))
        {
            bIsInRagdoll = TRUE;
        }
        PawnAsBioPawn.GetCurrentCustomAction(CustomAction);
        if (Role < ENetRole.ROLE_Authority && (CustomAction == None || CustomAction.bForceLocalSimulation == FALSE) && !bIsInRagdoll)
        {
            ReplicateMove(DeltaTime, PawnAsBioPawn.Acceleration, 0, OldRotation - PawnAsBioPawn.DesiredRotation);
        }
        else
        {
            ProcessMove(DeltaTime, PawnAsBioPawn.Acceleration, 0, OldRotation - PawnAsBioPawn.DesiredRotation);
        }
    }
    public function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot;
        local Rotator ViewRotation;
        
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
    }
    
    stop;
};
state PlayerFlyCam extends BaseSpectating 
{
    public function PlayerMove(float DeltaTime)
    {
        local Vector X;
        local Vector Y;
        local Vector Z;
        
        DeltaTime /= FMax(0.00100000005, WorldInfo.TimeDilation * CustomTimeDilation);
        GetAxes(Rotation, X, Y, Z);
        Acceleration = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
        UpdateRotation(DeltaTime);
        ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
    }
    public function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot;
        local Rotator ViewRotation;
        
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
    }
    public exec function FastFlyCamOff()
    {
        SpectatorCameraSpeed = GetSpectatorCameraSpeed();
    }
    public exec function FastFlyCamOn()
    {
        SpectatorCameraSpeed = GetSpectatorCameraSpeed() * 2.0;
    }
    public function PoppedState()
    {
        if (GameModeManager2.IsActive(21))
        {
            GameModeManager2.DisableMode(21);
        }
        if (OldIgnoreMoveCount > 0)
        {
            bIgnoreMoveInput = byte(OldIgnoreMoveCount);
            OldIgnoreMoveCount = 0;
        }
    }
    public function float GetSpectatorCameraSpeed()
    {
        if (Class'WorldInfo'.static.IsConsoleBuild())
        {
            return default.SpectatorCameraSpeed * 0.75;
        }
        return default.SpectatorCameraSpeed;
    }
    public function PushedState()
    {
        if (GameModeManager2.IsActive(21) == FALSE && GameModeManager2.IsActive(7) == FALSE)
        {
            GameModeManager2.EnableMode(21);
        }
        if (int(bIgnoreMoveInput) > 0)
        {
            OldIgnoreMoveCount = int(bIgnoreMoveInput);
            bIgnoreMoveInput = 0;
        }
        SetLocation(PlayerCamera.CameraCache.POV.location, );
        SetRotation(PlayerCamera.CameraCache.POV.Rotation);
        Pawn.Velocity *= 0.0;
        Pawn.Acceleration *= 0.0;
        SpectatorCameraSpeed = GetSpectatorCameraSpeed();
    }
    
    stop;
};
state PlayerFalling 
{
    public function BeginState(Name PreviousStateName)
    {
        Super(Object).BeginState(PreviousStateName);
        CleanOutSavedMoves();
    }
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn PawnAsBioPawn;
        local BioCustomAction CustomAction;
        
        UpdateRotation(DeltaTime);
        PawnAsBioPawn = BioPawn(Pawn);
        if (PawnAsBioPawn != None)
        {
            PawnAsBioPawn.GetCurrentCustomAction(CustomAction);
        }
        if (Role < ENetRole.ROLE_Authority && (CustomAction == None || CustomAction.bForceLocalSimulation == FALSE))
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, 0, Pawn.Rotation - Pawn.DesiredRotation);
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, Pawn.Rotation - Pawn.DesiredRotation);
        }
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=BioHintSystem Name=HintSys0
    End Object
    Begin Object Class=BioPlayerSelection Name=oSelection
        Begin Template Class=SFXSelectionLensFlareComponent Name=SelectionFlare0
            ReplacementPrimitive = None
        End Template
        SelectionFlareComp = SelectionFlare0
    End Object
    Begin Object Class=SFXModule_AimAssist Name=AimAssist_0
    End Object
    StormRTPCName = "Player_Storm_Amount"
    TutorialIDs = (10383, 
                   10398, 
                   10384, 
                   10385, 
                   10386, 
                   10387, 
                   10388, 
                   10389, 
                   10390, 
                   10391, 
                   10392, 
                   10393, 
                   10394, 
                   10395, 
                   10397, 
                   10396, 
                   10406, 
                   10415, 
                   10460
                  )
    PostProcessPresets = ({Shadows = 0.0, MidTones = 1.0, HighLights = 1.0, Desaturation = 0.0, Preset = ETVType.TVT_Default}, 
                          {Shadows = -0.0500000007, MidTones = 1.10000002, HighLights = 0.899999976, Desaturation = 0.0, Preset = ETVType.TVT_Soft}, 
                          {Shadows = -0.00999999978, MidTones = 0.800000012, HighLights = 3.0, Desaturation = 0.100000001, Preset = ETVType.TVT_Lucent}, 
                          {Shadows = -0.0500000007, MidTones = 1.07000005, HighLights = 0.600000024, Desaturation = 0.0, Preset = ETVType.TVT_Vibrant}
                         )
    CoverShake = {
                  RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                  RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                  RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                  LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                  LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                  LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                  ShakeName = 'None', 
                  TimeToGo = 0.0, 
                  TimeDuration = 1.0, 
                  RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                  LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                  FOVAmplitude = 2.0, 
                  FOVFrequency = 5.0, 
                  FOVSinOffset = 0.0, 
                  TargetingDampening = 0.0, 
                  bOverrideTargetingDampening = FALSE, 
                  FOVParam = EShakeParam.ESP_OffsetRandom
                 }
    CoverAcquireParams = {MinCameraDotCover = -1.0, MinSlotDotPlayer = 0.707000017, MinPlayerDotCoverOffset = 0.899999976, MaxDist = 400.0, MaxCoverHeightFactor = 0.0}
    DirectionalCoverAcquireParams = {MinCameraDotCover = 0.99000001, MinSlotDotPlayer = 0.707000017, MinPlayerDotCoverOffset = 0.501999974, MaxDist = 400.0, MaxCoverHeightFactor = 1.0}
    FlinchIntervalRange = {X = 2.5, Y = 8.5}
    NoShieldFlinchIntervalRange = {X = 1.0, Y = 3.5}
    MoveStickIdleThreshold = 0.00999999978
    MoveStickWalkThreshold = 0.649999976
    MoveStickRunThreshold = 0.699999988
    MoveWalkModifierBlendTime = 0.5
    DeadZoneThreshold = 0.100000001
    CoverBreakTimeThreshold = 0.0799999982
    CoverCameraTransitionTime = 0.600000024
    CoverSnapScale = 1.5
    CoverUpdateDelay = 0.333000004
    StormCoverUpdateDelay = 0.0329999998
    CoverSlipCamAlign = 0.699999988
    PushOffCoverDuration = 0.400000006
    CE_Grab = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverGrab_VCFX'
    CE_Mantle = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverClimb_VCFX'
    CE_SwatLeft = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_SwatTurn_Left'
    CE_SwatRight = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_SwatTurn_Right'
    CE_HighSwatLeft = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_SwatTurn_Left_High'
    CE_HighSwatRight = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_SwatTurn_Right_High'
    CE_SlipRight = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverSlip_Right'
    CE_SlipLeft = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverSlip_Left'
    CE_HighSlipRight = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverSlip_Right_High'
    CE_HighSlipLeft = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_CoverSlip_Left_High'
    CE_Jump = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_GapJump_VCFX'
    CE_LadderUp = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_LadderUp_VCFX'
    CE_LadderDown = RvrClientEffect'BioVFX_Gui_CoverHUD.VCFX.Hud_LadderDown_VCFX'
    LadderFaceDot = 0.707000017
    LadderAimDot = 0.707000017
    m_fClimbMantleFaceAngleThreshold = 0.699999988
    m_fClimbMantleDistanceThreshold = 50.0
    RotationSensitivityLow = 0.600000024
    RotationSensitivityMedium = 0.75
    RotationSensitivityHigh = 1.0
    SawEnemyTypeShoutCooldownTime = 5.0
    StormCooldownTime = 0.300000012
    StormStartWwiseEvent_M = WwiseEvent'Wwise_Generic_Gameplay.Play_player_male_storm_standard'
    StormPeakWwiseEvent_M = WwiseEvent'Wwise_Generic_Gameplay.Play_player_male_storm_recover'
    StormStartWwiseEvent_F = WwiseEvent'Wwise_Generic_Gameplay.Play_player_female_storm_standard'
    StormPeakWwiseEvent_F = WwiseEvent'Wwise_Generic_Gameplay.Play_player_female_storm_recover'
    StormEndWwiseEvent = WwiseEvent'Wwise_Generic_Gameplay.Stop_player_storm_recover'
    StorageDeviceRemovedText = $346039
    DLCRemovedText = $724952
    RestartGame = $343972
    ProfileChangedText = $153006
    ProfileChangedUnrecoverableText = $695550
    m_fLeaveConvPitch = -20.0
    m_fMoveToDropDistance = 4000.0
    m_fMaxZDifference = 2000.0
    m_fRelativeZUpLimit = 200.0
    m_fRelativeZDownLimit = 100.0
    m_fLastRadarRange = -1.0
    m_fRadarRange = -1.0
    m_fRadarFOV = -1.0
    m_fLastRadarFOV = -1.0
    m_nNavAssistMaxNodeLimit = 4
    m_fDamageIndicatorDisplayTime = 1.0
    m_srVehicleExitFailureMsg = $172833
    m_srVehicleExitAButtonMsg = $172832
    m_fAttackOrderFarAngle = 5.0
    m_fAttackOrderCloseAngle = 14.0
    m_fAttackOrderCloseDistance = 500.0
    NUM_SERVERMOVE_BEFORE_RESET = 90
    MOVEREP_DELAY_FRAME = 1
    RemotePlayersRotationInterpolationSpeed = 0.150000006
    BIO_RESET_MAX_POSITION_ERROR_SQUARED = 400.0
    BIO_WARNING_MAX_POSITION_ERROR_SQUARED = 3.0
    MAX_CONSECUTIVE_POSITION_ERROR = 8
    ClientTimeoutForPendingCustomActionReset = 1.0
    AutonomousProxyLocationInterpSpeed = 20.0
    EdgeCoverSlotSnapRange = 65.0
    srOK = $152938
    srNuiDisconnectError = $724259
    HintSystem = HintSys0
    m_oPlayerSelection = oSelection
    bUsePackedMoves = TRUE
    bShowActionIcons = TRUE
    m_bCanMantleOutsideOfCover = TRUE
    m_bEnableCineModeWarning = TRUE
    CameraClass = Class'SFXPlayerCamera'
    SavedMoveClass = Class'SFXSavedMove'
    CheatClass = Class'BioCheatManagerNonNative'
    InputClass = Class'BioPlayerInput'
    CylinderComponent = CollisionCylinder
    SpectatorCameraSpeed = 1200.0
    Components = (None, CollisionCylinder)
    Modules = (AimAssist_0)
    CollisionComponent = CollisionCylinder
}