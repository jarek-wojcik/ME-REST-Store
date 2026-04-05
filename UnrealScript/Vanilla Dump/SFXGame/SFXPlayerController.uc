Class SFXPlayerController extends BioPlayerController
    config(Game);

const Player_NearImpactDistance = 100;
const Player_NearMissDistance = 200;

var array<SFXSeqAct_LookAtPOI> m_aPOIKismet;
var(SFXPlayerController) array<NavigationPoint> NavList;
var config array<Name> SPMapNames;
var config array<Name> SPN7MapNames;
var array<delegate<OnDestroyCallback>> OnDestroyDelegates;
var delegate<OnDestroyCallback> __OnDestroyCallback__Delegate;
var transient OnlineGameSearchResult CachedInviteResult;
var SFXSeqAct_LookAtPOI m_pActivePOI;
var(SFXPlayerController) editconst transient SFXPlayerCamera MyCamera;
var(SFXPlayerController) int CurrentNavIdx;
var(SFXPlayerController) NavigationPoint CurrentNavGoal;
var const config stringref srConnectionLost;
var const config stringref srHostLeft;
var const config stringref srInviteFailure;
var const config stringref srInviteGameFull;
var const config stringref srInviterLeft;
var const config stringref srInviteProtocolMismatch;
var const config stringref srInviteMissingDLCInvitee;
var const config stringref srInviteMissingDLCInviter;
var const config stringref srMultiplayerUpdate;
var const config stringref srPlayerKicked;
var int nInviteWaitDelay;
var config int nMaxInviteWaitDelay;
var int ObjectiveTimerPositionY;
var float QuickMantleDelay;
var transient SFXLadderReachSpec FoundLadder;
var bool bLeanDisabled;

public exec function bool ActivatePOI()
{
    local bool POIActivated;
    
    POIActivated = FALSE;
    if (m_aPOIKismet.Length != 0)
    {
        m_aPOIKismet[0].ActivatePOI(Self);
        POIActivated = TRUE;
    }
    UpdateHUDPOIIcon();
    return POIActivated;
}
public exec function DeactivatePOI()
{
    local SFXSeqAct_LookAtPOI POI;
    
    foreach m_aPOIKismet(POI, )
    {
        if (POI.m_bPOIActive)
        {
            POI.DeactivatePOI(Self, TRUE);
        }
    }
    UpdateHUDPOIIcon();
}
public simulated function Destroyed()
{
    local delegate<OnDestroyCallback> OnDestroy;
    
    foreach OnDestroyDelegates(OnDestroy, )
    {
        OnDestroy();
    }
    Super.Destroyed();
}
public final function BioSFHandler_DesignerUI GetDUIHandler()
{
    return Class'SFXGUIInteraction'.static.GetInstance().GetDUIHandler(Self);
}
public function bool IsSignedIn()
{
    local SFXOnlineSubsystem oOnlineSub;
    
    oOnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    return oOnlineSub != None && oOnlineSub.GetComponentLogin() != None && oOnlineSub.GetComponentLogin().IsSignedIn();
}
public function bool LoadingScreenTimedOut(EWaitMessage WaitMessage)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    QueueHostLeftMessage(TRUE);
    Engine.LoadMovieManager.StopLoadingMovie();
    Class'SFXTelemetry'.static.SendBool('TelemetryHook_LoadingScreenTimedOut', WorldInfo.NetMode != ENetMode.NM_Standalone);
    return TRUE;
}
public function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local BioCustomAction Action;
    local BioPawn MyBP;
    
    MyBP = BioPawn(Pawn);
    if (MyBP != None && MyBP.GetCurrentCustomAction(Action) && Action.NotifyBump(Other, HitNormal))
    {
        return TRUE;
    }
    return Super(Controller).NotifyBump(Other, HitNormal);
}
public function bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
    local BioCustomAction Action;
    local BioPawn MyBP;
    local BioPlayerInput Input;
    
    MyBP = BioPawn(Pawn);
    if (MyBP != None && MyBP.GetCurrentCustomAction(Action) && Action.NotifyHitWall(HitNormal, Wall))
    {
        return TRUE;
    }
    if (MyBP.IsLocallyControlled())
    {
        Input = BioPlayerInput(PlayerInput);
        if (MyBP.bStorming)
        {
            if (Input.RawJoyRight > 0.707000017 || Input.RawJoyRight < -0.707000017 || Input.RawJoyUp < -0.707000017)
            {
                return FALSE;
            }
            GetGameModeDefault().TryAcquireCover(FALSE);
        }
        if (MyBP.CurrentCustomAction == 56)
        {
            if (Input.RawJoyRight > 0.707000017 || Input.RawJoyRight < -0.707000017 || Input.RawJoyUp < -0.707000017)
            {
                return FALSE;
            }
            GetGameModeDefault().TryAcquireCover(TRUE);
        }
    }
    return Super(Controller).NotifyHitWall(HitNormal, Wall);
}
public function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    local SFXOnlineSubsystem SFXOnlineSub;
    local ISFXOnlineComponentGameEntryFlow InviteFlow;
    
    Class'Engine'.static.GetEngine().StopMovie(FALSE, FALSE);
    SFXOnlineSub = SFXOnlineSubsystem(OnlineSub);
    InviteFlow = SFXOnlineSub.GetComponentGameEntryFlow();
    InviteFlow.ActivateInviteFlow(InviteResult);
}
public event simulated function PostBeginPlay()
{
    local SFXEngine Engine;
    
    Super.PostBeginPlay();
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None && Engine.eNetworkErrorStatus == ESFXNetworkErrorStatus.ErrorStatus_DisplayPromptAfterTravel)
    {
        SetTimer(1.0, FALSE, 'OnGameConnectionLost', );
    }
}
public function SetZoomed(bool bEnabled)
{
    if (!bLeanDisabled)
    {
        Super.SetZoomed(bEnabled);
    }
    else
    {
        Super.SetZoomed(FALSE);
    }
}
public event function SpawnPlayerCamera()
{
    Super.SpawnPlayerCamera();
    MyCamera = SFXPlayerCamera(PlayerCamera);
}
public function CheckNearMiss(Pawn Shooter, Weapon W, Vector WeapLoc, Vector LineDir, Vector HitLocation)
{
    local SFXGRI GRI;
    local BioPawn ChkPawn;
    local SFXWeapon ChkWeapon;
    local BioAiController AI;
    local Vector ClosestPoint;
    local float ClosestDistance;
    local float HitDistance;
    local Class<SFXDamageType> DamageType;
    
    Super(Controller).CheckNearMiss(Shooter, W, WeapLoc, LineDir, HitLocation);
    ChkPawn = BioPawn(Pawn);
    if (ChkPawn != None)
    {
        if (ChkPawn.IsHostile(Shooter))
        {
            GRI = SFXGRI(WorldInfo.GRI);
            if (GRI != None && GRI.bInCombat == FALSE)
            {
                foreach ChkPawn.Squad.SquadMembers(AI)
                {
                    AI.NotifyNewEnemyFromFriendly(Shooter);
                }
            }
            ChkWeapon = SFXWeapon(W);
            if (ChkWeapon != None)
            {
                ClosestDistance = PointDistToLine(ChkPawn.location, LineDir, WeapLoc, ClosestPoint);
                HitDistance = VSize(HitLocation - ChkPawn.location);
                if (ClosestDistance <= float(200) && HitDistance > float(100))
                {
                    if (GetVectorSide(WeapLoc - ChkPawn.location, LineDir) == 1)
                    {
                        if (ChkWeapon.WeaponWhipSoundLeft != None)
                        {
                            ChkWeapon.WeaponPlayWwiseEvent(ChkWeapon.WeaponWhipSoundLeft, 1.0);
                        }
                    }
                    else if (ChkWeapon.WeaponWhipSoundRight != None)
                    {
                        ChkWeapon.WeaponPlayWwiseEvent(ChkWeapon.WeaponWhipSoundRight, 1.0);
                    }
                }
                DamageType = ChkWeapon.GetDamageType(ChkWeapon.CurrentFireMode);
                if (DamageType == None)
                {
                    DamageType = Class'SFXDamageType_Default';
                }
                if (ClosestDistance <= DamageType.default.FlinchDistance || HitDistance < DamageType.default.FlinchDistance)
                {
                    PlayFlinch(W, FALSE);
                }
            }
        }
    }
}
public simulated function EnterStartState()
{
    Super(PlayerController).EnterStartState();
}
public function NotifyInviteFailed()
{
    local BioMessageBoxOptionalParams Params;
    local string sInviteFailedReason;
    local ISFXOnlineComponentGameFlow oGameFlow;
    
    Super(PlayerController).NotifyInviteFailed();
    sInviteFailedReason = Class'SFXGame'.static.GetSimpleString(srInviteFailure);
    oGameFlow = SFXOnlineSubsystem(OnlineSub).GetComponentGameFlow();
    if (!SFXOnlineSubsystem(OnlineSub).GetComponentGame().IsOnLatestMultiplayerVersion())
    {
        sInviteFailedReason = Class'SFXGame'.static.GetSimpleString(srMultiplayerUpdate);
    }
    else if (oGameFlow.GM_HasFailedJoiningFullGame())
    {
        sInviteFailedReason = Class'SFXGame'.static.GetSimpleString(srInviteGameFull);
    }
    else if (oGameFlow.GM_HasFailedJoiningInviterLeft())
    {
        sInviteFailedReason = Class'SFXGame'.static.GetSimpleString(srInviterLeft);
    }
    else if (oGameFlow.GM_HasFailedJoiningGameProtocolMismatch())
    {
        Class'SFXTelemetry'.static.SendString('TelemetryHook_Invite_ProtocolMismatch', SFXOnlineSubsystem(OnlineSub).GetGameProtocolVersion());
        sInviteFailedReason = Class'SFXGame'.static.GetSimpleString(srInviteProtocolMismatch);
    }
    else if (oGameFlow.GM_HasFailedJoiningGameMissingDLCInvitee())
    {
        sInviteFailedReason = BuildMissingDLCString(TRUE);
    }
    else if (oGameFlow.GM_HasFailedJoiningGameMissingDLCInviter())
    {
        sInviteFailedReason = BuildMissingDLCString(FALSE);
    }
    SFXOnlineSubsystem(OnlineSub).GetComponentGameFlow().GM_OnInviteErrorNotified();
    Class'SFXGUIInteraction'.static.GetInstance().RemoveNamedMessageBox('GameEntryFlowPopup');
    Params.srAText = srOK;
    Params.bModal = TRUE;
    Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBoxEx('InviteFailedMsg', 2, sInviteFailedReason, Params, None);
}
public simulated function AddOnDestroyDelegate(delegate<OnDestroyCallback> OnDestroyDelegate)
{
    OnDestroyDelegates.AddItem(OnDestroyDelegate);
}
public simulated function BeginCountdownTimer(float CountdownTime, float CountdownWarningTime);

public function string BuildMissingDLCString(bool bInvitee)
{
    local int i;
    local string missingDLCStr;
    local array<MPDLCInfo> missingDLCs;
    
    if (bInvitee)
    {
        missingDLCStr = Class'SFXGame'.static.GetSimpleString(srInviteMissingDLCInvitee);
    }
    else
    {
        missingDLCStr = Class'SFXGame'.static.GetSimpleString(srInviteMissingDLCInviter);
    }
    SFXOnlineSubsystem(OnlineSub).GetComponentGame().GetMultiplayer_MissingDLCs(missingDLCs, bInvitee);
    missingDLCStr = missingDLCStr $ "\n";
    for (i = 0; i < missingDLCs.Length; i++)
    {
        missingDLCStr = missingDLCStr $ "\n" $ Class'SFXGame'.static.GetSimpleString(missingDLCs[i].PrettyName);
    }
    return missingDLCStr;
}
public function Callback_GameDestroyedMessage(bool bAPressed, int Context)
{
    if (IsSignedIn())
    {
        ConsoleCommand("open " $ SFXEngine(Class'Engine'.static.GetEngine()).GetDisconnectFallbackMap());
    }
    SFXEngine(Class'Engine'.static.GetEngine()).eNetworkErrorStatus = ESFXNetworkErrorStatus.ErrorStatus_NoError;
}
public function Callback_HostLeftMessage(bool bAPressed, int Context)
{
    ConsoleCommand("open EntryMenu?nosplash");
}
public reliable client function CancelCountdownTimer()
{
    ClearTimer('UpdateCountdownTimer');
}
public function CheckCancelCover()
{
    local Vector jumpDir;
    local Rotator PlayerAimDir;
    local float AimDot;
    local BioPlayerInput Input;
    local BioPawn BP;
    
    Input = BioPlayerInput(PlayerInput);
    BP = BioPawn(Pawn);
    if (BP == None)
    {
        return;
    }
    if (Input.MoveStickMag < 0.5)
    {
        return;
    }
    jumpDir = Vector(BP.CurrentLink.GetSlotRotation(BP.CurrentSlotIdx));
    jumpDir.Z = 0.0;
    jumpDir = Normal(jumpDir);
    PlayerAimDir = Rotation + Rotator(Input.MoveStick);
    PlayerAimDir.Pitch = 0;
    AimDot = Vector(PlayerAimDir) Dot jumpDir;
    if (AimDot < -0.5)
    {
        BP.LeaveCover();
        GotoState('PlayerPushOffCover', , , );
    }
}
public final function CheckQuickCoverAction()
{
    local CovPosInfo CoverInfo;
    local BioPlayerInput Input;
    local BioPawn BP;
    local MantleInfo MyMantleInfo;
    
    BP = BioPawn(Pawn);
    if (BP == None)
    {
        return;
    }
    CoverInfo.Link = BP.CurrentLink;
    CoverInfo.LtSlotIdx = BP.LeftSlotIdx;
    CoverInfo.RtSlotIdx = BP.RightSlotIdx;
    CoverInfo.LtToRtPct = BP.CurrentSlotPct;
    if (IsInCoverState())
    {
        CheckCancelCover();
    }
    if (int(bWantsToStorm) == 1)
    {
        GetGameModeDefault().TryCoverSlip();
        Input = BioPlayerInput(PlayerInput);
        if (Input.MoveStick.X > 0.5 && CanPerformMantle(CoverInfo) && BP.CanPerformMantleSlow(MyMantleInfo))
        {
            SetTimer(QuickMantleDelay, , 'TryQuickMantle', );
        }
        if (BP.CurrentCustomAction != 0)
        {
            return;
        }
    }
}
public final function ComputeConstrainedAngle(out float Mag)
{
    local Vector StickRot;
    local Rotator AngleStick;
    local Rotator FinalRot;
    local float ANGLE_LIMIT;
    
    Mag = 0.0;
    ANGLE_LIMIT = 55.0;
    if (Pawn != None && PlayerInput != None)
    {
        StickRot.X = PlayerInput.RawJoyRight;
        StickRot.Y = PlayerInput.RawJoyUp;
        Mag = Sqrt(StickRot.X * StickRot.X + StickRot.Y * StickRot.Y);
        AngleStick = Rotator(StickRot);
        AngleStick.Yaw -= 16384;
        AngleStick.Yaw *= -1.0;
        FinalRot.Yaw = Rotation.Yaw + AngleStick.Yaw;
        if (RDiff(FinalRot, Pawn.Rotation) > ANGLE_LIMIT)
        {
            Mag = 0.0;
        }
    }
}
public exec function ConnectToMPMap(string mapPackageName, optional bool fromGalaxyMap = FALSE, optional SFXOnlineGameDifficulty Difficulty = 0, optional int objectiveMode = 0)
{
    local SFXOnlineSubsystem SFXOnlineSub;
    local ISFXOnlineComponentGameEntryFlow InviteFlow;
    
    SFXOnlineSub = SFXOnlineSubsystem(OnlineSub);
    InviteFlow = SFXOnlineSub.GetComponentGameEntryFlow();
    InviteFlow.ActivateConnectToMapFlow(mapPackageName, fromGalaxyMap, Difficulty, objectiveMode);
}
public function ContinueGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    CachedInviteResult = InviteResult;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentNotification().RequestBinaryLiveINIData(FALSE);
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentNotification().RequestLiveTlkTable(FALSE);
    SetTimer(1.0, FALSE, 'ContinueGameInviteAcceptedPart2', );
    nInviteWaitDelay = 1;
}
public function ContinueGameInviteAcceptedPart2()
{
    if (!IsSignedIn())
    {
        NotifyInviteFailed();
        return;
    }
    if (Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentNotification().IsFetchingLiveBinaryINIData() && nInviteWaitDelay < nMaxInviteWaitDelay)
    {
        SetTimer(1.0, FALSE, 'ContinueGameInviteAcceptedPart2', );
        nInviteWaitDelay += int(1.0);
        return;
    }
    if (SFXOnlineSubsystem(OnlineSub).GetComponentGame().IsOnLatestMultiplayerVersion())
    {
        Super(PlayerController).OnGameInviteAccepted(CachedInviteResult);
    }
    else
    {
        NotifyInviteFailed();
    }
}
public simulated function DisplayTextPopup(coerce string Text)
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oGUI.CastGetMovie(Class'SFXGUI_Markers', Self, oGUI.MovieTag_Markers).DisplayTextPopup(Text);
}
public reliable client function DUI_ClearAll(bool bModal)
{
    GetDUIHandler().ClearAll(bModal);
}
public reliable client function DUI_ClearElementPulse(BioDUIElements nElement)
{
    GetDUIHandler().ClearElementPulse(nElement);
}
public reliable client function DUI_SetBarFillDirection(bool bModalBar, bool bLeftToRight)
{
    GetDUIHandler().SetBarFillDirection(bModalBar, bLeftToRight);
}
public reliable client function DUI_SetBarFillPercent(bool bModalBar, int nPercent)
{
    GetDUIHandler().SetBarFillPercent(bModalBar, nPercent);
}
public reliable client function DUI_SetBarMarkerPoints(bool bModalBar, int nMarker1, int nMarker2)
{
    GetDUIHandler().SetBarMarkerPoints(bModalBar, nMarker1, nMarker2);
}
public reliable client function DUI_SetCounterValue(bool bModalCounter, int nValue)
{
    GetDUIHandler().SetCounterValue(bModalCounter, nValue);
}
public reliable client function DUI_SetElementAlpha(BioDUIElements nElement, float fAlpha)
{
    GetDUIHandler().SetElementAlpha(nElement, fAlpha);
}
public reliable client function DUI_SetElementColor(BioDUIElements nElement, Color stColor)
{
    GetDUIHandler().SetElementColor(nElement, stColor);
}
public reliable client function DUI_SetElementText(BioDUIElements nElement, string sText)
{
    GetDUIHandler().SetElementText(nElement, sText);
}
public reliable client function DUI_SetElementVisible(BioDUIElements nElement, bool bVisible, optional float fFadeTime = 0.0)
{
    GetDUIHandler().SetElementVisible(nElement, bVisible, fFadeTime);
}
public reliable client function DUI_SetQuasarLayout(bool bShow)
{
    GetDUIHandler().SetQuasarLayout(bShow);
}
public reliable client function DUI_SetTextStringRef(BioDUIElements nElement, stringref srText)
{
    GetDUIHandler().SetTextStringRef(nElement, srText);
}
public reliable client function DUI_SetTimerDetails(bool bModalTimer, bool bVisible, float fStartTime, float fEndTime, float fInterval)
{
    GetDUIHandler().SetTimerDetails(bModalTimer, bVisible, fStartTime, fEndTime, fInterval);
}
public reliable client function DUI_SetupElementPulse(BioDUIElements nElement, float fMinAlpha, float fCycleTime)
{
    GetDUIHandler().SetupElementPulse(nElement, fMinAlpha, fCycleTime);
}
public static final function ForceOnlineSubCleanUp()
{
    local OnlineSubsystem oOnlineSub;
    
    oOnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (oOnlineSub != None && oOnlineSub.GameInterface != None)
    {
        oOnlineSub.GameInterface.ForceCleanUp();
    }
}
public function ForceUnZoom(float Time)
{
    SetZoomed(FALSE);
    bLeanDisabled = TRUE;
    SetTimer(Time, FALSE, 'ResetLean', );
}
public simulated function float GetRemainingCountdownTime();

public function HideInGameConsumableUI();

public function OnBeginIllusiveManConflict(SFXSeqAct_BeginIllusiveManConflict Seq)
{
    Seq.OutputLinks[0].bHasImpulse = TRUE;
    if (Seq.InputLinks[0].bHasImpulse)
    {
        Seq.bRunning = TRUE;
        Seq.OutputLinks[0].bHasImpulse = TRUE;
        GameModeManager2.EnableMode(18);
        SFXGameModeIllusiveManConflict(GameModeManager2.GameModes[18]).InitializeMiniGame(Seq);
    }
    else if (Seq.InputLinks[1].bHasImpulse)
    {
        Seq.bRunning = FALSE;
        Seq.AbortFor(Self);
        Seq.OutputLinks[0].bHasImpulse = TRUE;
        GameModeManager2.DisableMode(18);
    }
    else if (Seq.InputLinks[2].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(GameModeManager2.GameModes[18]).IncreaseDifficulty();
    }
    else if (Seq.InputLinks[3].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(GameModeManager2.GameModes[18]).DecreaseDifficulty();
    }
    else if (Seq.InputLinks[4].bHasImpulse)
    {
        SFXGameModeIllusiveManConflict(GameModeManager2.GameModes[18]).StartPush();
    }
}
public delegate function OnDestroyCallback();

public function OnGameConnectionLost()
{
    ForceOnlineSubCleanUp();
    if (IsSignedIn())
    {
        ShowNetworkErrorMessage();
    }
}
public function OnMultiplayerGameDestroyed(Name SessionName, bool bWasSuccessful)
{
    local SFXEngine oEngine;
    local ISFXOnlineComponentGameFlow oGameFlow;
    
    if (!bWasSuccessful)
    {
        if (IsSignedIn())
        {
            QueueHostLeftMessage();
        }
        oEngine = SFXEngine(Class'Engine'.static.GetEngine());
        if (oEngine.LoadMovieManager != None && oEngine.LoadMovieManager.IsLoadingMoviePlaying())
        {
            ConsoleCommand("start ?failed");
            if (!IsSignedIn())
            {
                oGameFlow = SFXOnlineSubsystem(OnlineSub).GetComponentGameFlow();
                if (oGameFlow != None)
                {
                    oGameFlow.GM_OnExitMPFlow();
                }
            }
        }
    }
    else if (WasKickedOutOfGame())
    {
        ShowNetworkErrorMessage();
    }
}
public simulated function OnWaveFinished();

public final function PlayDistanceScaledCameraShake(Vector ImpactLocation, ScreenShakeStruct CameraShake, optional float MinShakeDistance = 3000.0, optional float MinShakeMultiplier = 0.0)
{
    local float Distance;
    local float ScaleFactor;
    local ScreenShakeStruct ModifiedCameraShake;
    
    if (PlayerCamera != None)
    {
        Distance = VSize(Pawn.location - ImpactLocation);
        ScaleFactor = 1.0 - FClamp(Distance / MinShakeDistance, 0.0, 1.0 - FClamp(MinShakeMultiplier, 0.0, 1.0));
        ModifiedCameraShake = CameraShake;
        ModifiedCameraShake.FOVAmplitude *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.X *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.Y *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.Z *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.X *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.Y *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.Z *= ScaleFactor;
        SFXPlayerCamera(PlayerCamera).AddScreenShake(ModifiedCameraShake);
    }
}
public final function PlayDistanceScaledForceFeedback(Vector ImpactLocation, ForceFeedbackWaveform ForceFeedback, optional float MinShakeDistance = 3000.0, optional float MinShakeMultiplier = 0.0)
{
    local float Distance;
    local float ScaleFactor;
    local ForceFeedbackWaveform ModifiedForceFeedback;
    local WaveformSample Sample;
    
    Distance = VSize(Pawn.location - ImpactLocation);
    ScaleFactor = 1.0 - FClamp(Distance / MinShakeDistance, 0.0, 1.0 - FClamp(MinShakeMultiplier, 0.0, 1.0));
    ModifiedForceFeedback = new (None) Class'ForceFeedbackWaveform' (ForceFeedback);
    foreach ForceFeedback.Samples(Sample, )
    {
        Sample.LeftAmplitude *= ScaleFactor;
        Sample.RightAmplitude *= ScaleFactor;
        ModifiedForceFeedback.Samples.AddItem(Sample);
    }
    ClientPlayForceFeedbackWaveform(ModifiedForceFeedback);
}
public final function PlayScaledCameraShake(ScreenShakeStruct CameraShake, float ScaleFactor)
{
    local ScreenShakeStruct ModifiedCameraShake;
    
    if (PlayerCamera != None)
    {
        ModifiedCameraShake = CameraShake;
        ModifiedCameraShake.FOVAmplitude *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.X *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.Y *= ScaleFactor;
        ModifiedCameraShake.RotAmplitude.Z *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.X *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.Y *= ScaleFactor;
        ModifiedCameraShake.LocAmplitude.Z *= ScaleFactor;
        SFXPlayerCamera(PlayerCamera).AddScreenShake(ModifiedCameraShake);
    }
}
public function PulsePowerDisplay();

public function QueueHostLeftMessage(optional bool bTransitionToMainMenu = FALSE)
{
    local BioMessageBoxOptionalParams stParams;
    local stringref srError;
    
    srError = IsSignedIn() ? srHostLeft : srConnectionLost;
    stParams.srAText = srOK;
    stParams.bModal = TRUE;
    stParams.bNoFade = TRUE;
    stParams.bForcePlayersOnly = TRUE;
    if (bTransitionToMainMenu)
    {
        Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('HostLeft', 1, srError, stParams, Callback_HostLeftMessage, 0, Self);
    }
    else
    {
        Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('HostLeft', 1, srError, stParams, None, 0, Self);
    }
}
public simulated function RemoveOnDestroyDelegate(delegate<OnDestroyCallback> OnDestroyDelegate)
{
    OnDestroyDelegates.RemoveItem(OnDestroyDelegate);
}
public function ResetLean()
{
    bLeanDisabled = FALSE;
}
public reliable server function ServerBecomeActivePlayer()
{
    local SFXGame Game;
    
    Game = SFXGame(WorldInfo.Game);
    BroadcastLocalizedMessage(Game.GameMessageClass, 1, PlayerReplicationInfo);
    if (!Game.bDelayedStart)
    {
        Game.RestartPlayer(Self);
    }
    else
    {
        Game.RestartPlayer(Self);
    }
}
public simulated function SetObjectiveCircleProgress(int nNumComplete);

public simulated function SetObjectiveCircleText(const string s1, const string s2, const string s3, const string s4);

public simulated function SetScoreHudObjectiveProgress(float Progress, optional bool bBoostAnim = FALSE);

public simulated function SetScoreHudObjectiveText(stringref ObjectiveText);

public function ShowNetworkErrorMessage()
{
    local BioMessageBoxOptionalParams Params;
    local string sErrorMsg;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (!IsSignedIn())
    {
    }
    sErrorMsg = Class'SFXGame'.static.GetSimpleString(WasKickedOutOfGame() ? srPlayerKicked : srHostLeft);
    Params.srAText = srOK;
    Params.bModal = TRUE;
    Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBoxEx('NetworkErrorMsg', 0, sErrorMsg, Params, Callback_GameDestroyedMessage);
    Engine.LoadMovieManager.StopLoadingMovie();
    WorldInfo.bPlayersOnly = TRUE;
}
public function TickCoverVisualization()
{
    local SFXLadderReachSpec LadderSpec;
    local RvrClientEffectTarget Target;
    
    Super.TickCoverVisualization();
    FindLadderNode(LadderSpec, 2000.0);
    if (ProfileSettings != None)
    {
        bShowActionIcons = ProfileSettings.GetActionIconHintOption();
    }
    if (!bShowActionIcons)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderUp, LadderUpClientEffectGuid, TRUE);
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderDown, LadderDownClientEffectGuid, TRUE);
    }
    if (bShowActionIcons)
    {
        if (FoundLadder != LadderSpec)
        {
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderUp, LadderUpClientEffectGuid, TRUE);
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderDown, LadderDownClientEffectGuid, TRUE);
            if (LadderSpec != None)
            {
                Target.Instigator = LadderSpec.Start;
                Target.HitNormal = LadderSpec.GetDirection();
                if (SFXNav_LadderNode(LadderSpec.Start).bTopNode)
                {
                    LadderDownClientEffectGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_LadderDown, Target);
                    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderUp, LadderUpClientEffectGuid, TRUE);
                }
                else
                {
                    LadderUpClientEffectGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_LadderUp, Target);
                    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LadderDown, LadderDownClientEffectGuid, TRUE);
                }
            }
        }
    }
    FoundLadder = LadderSpec;
}
public function TryQuickMantle()
{
    local BioPlayerInput Input;
    
    Input = BioPlayerInput(PlayerInput);
    if (int(bWantsToStorm) == 1)
    {
        if (Input.MoveStick.X > 0.5)
        {
            GetGameModeDefault().MantleCover();
        }
    }
}
public simulated function UpdateCountdownTimer();

public final function UpdateHUDPOIIcon()
{
    local SFXGUIInteraction pGUI;
    local SFXSFHandler_HUD pHUD;
    local ESFXHUDPOIIconState eDesiredState;
    local SFXSeqAct_LookAtPOI POI;
    
    pGUI = Class'SFXGUIInteraction'.static.GetInstance();
    pHUD = pGUI == None ? None : pGUI.CastGetMovie(Class'SFXSFHandler_HUD', Self, pGUI.MovieTag_HUD);
    if (pHUD != None)
    {
        eDesiredState = ESFXHUDPOIIconState.SFXHUD_POI_Off;
        foreach m_aPOIKismet(POI, )
        {
            if (POI.m_bAutoActivate == FALSE)
            {
                eDesiredState = ESFXHUDPOIIconState.SFXHUD_POI_On;
                break;
            }
        }
        if (m_pActivePOI != None)
        {
            if (m_pActivePOI.m_bAutoActivate == TRUE)
            {
                eDesiredState = ESFXHUDPOIIconState.SFXHUD_POI_Off;
            }
            else
            {
                eDesiredState = ESFXHUDPOIIconState.SFXHUD_POI_Activated;
            }
        }
        pHUD.SetPOIState(eDesiredState);
    }
}
public function UpdateInGameConsumableUI();

public function UpdateMapsCompletedHelper(Name MapName, Name PlayedMaps, Name PlayedMapsCount, array<Name> MapNames)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local int BitMask;
    local int MapsPlayed;
    local int NumMapsPlayed;
    local int MapIndex;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None)
    {
        return;
    }
    MapIndex = MapNames.Find(MapName);
    BitMask = 0;
    if (MapIndex >= 0)
    {
        BitMask = 1 << MapIndex;
    }
    if (BitMask > 0)
    {
        MapsPlayed = AccomplishmentManager.GetGrinderAccomplishmentProgress(PlayedMaps, Self);
        if (MapsPlayed > -1 && (MapsPlayed & BitMask) == 0)
        {
            MapsPlayed = MapsPlayed | BitMask;
            AccomplishmentManager.SetGrinderAccomplishmentProgress(PlayedMaps, MapsPlayed, Self);
        }
        NumMapsPlayed = 0;
        while (MapsPlayed != 0)
        {
            NumMapsPlayed += MapsPlayed & 1;
            MapsPlayed = MapsPlayed >> 1;
        }
        if (AccomplishmentManager.SetGrinderAccomplishmentProgressWithUpdate(PlayedMapsCount, NumMapsPlayed, Self))
        {
            AccomplishmentManager.Save();
        }
    }
}
public event function UpdateSPInsaneMapsCompleted(Name MapName)
{
    UpdateMapsCompletedHelper(MapName, 'SPPLAYEDMAPSINSANE', 'SPMAPSINSANECOUNT', SPMapNames);
}
public event function UpdateSPN7MapsCompleted(Name MapName)
{
    UpdateMapsCompletedHelper(MapName, 'SPPLAYEDMAPS', 'SPMAPSCOUNT', SPN7MapNames);
}
public function bool WasKickedOutOfGame()
{
    local SFXOnlineSubsystem oOnlineSub;
    
    oOnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    return oOnlineSub != None && oOnlineSub.GetComponentGame() != None && oOnlineSub.GetComponentGame().WasKickedOutOfGame();
}

state PlayerConstrained extends PlayerWalking 
{
    public function PlayerMove(float DeltaTime)
    {
        local BioPawn PawnAsBioPawn;
        local float MoveStickMag;
        
        PawnAsBioPawn = BioPawn(Pawn);
        ComputeConstrainedAngle(MoveStickMag);
        UpdateRotation(DeltaTime);
        if (Pawn.Physics == EPhysics.PHYS_Walking)
        {
            PlayerMoveConstrained(PawnAsBioPawn, DeltaTime, MoveStickMag);
        }
    }
    public function PlayerMoveConstrained(BioPawn PawnAsBioPawn, float DeltaTime, float MoveMag)
    {
        local Rotator MoveFacing;
        local Vector MoveDir;
        local float MoveAccMag;
        local float MoveWalkModifier;
        local float MoveWalkModifierAlpha;
        local float MaxSpeed;
        
        MaxSpeed = 180.0;
        MoveWalkModifier = 1.0;
        if (MaxSpeed > 0.0 && MoveMag > 0.00999999978)
        {
            MoveAccMag = PawnAsBioPawn.AccelRate;
            if (!PawnAsBioPawn.bIsWalking)
            {
                if (MoveMag >= 0.699999988)
                {
                    MoveWalkModifier = 1.0;
                }
                else if (MoveMag >= 0.600000024)
                {
                    MoveWalkModifier = PawnAsBioPawn.WalkSpeed / PawnAsBioPawn.GroundSpeed;
                }
                else
                {
                    MoveWalkModifier = MoveMag / 0.600000024 * PawnAsBioPawn.WalkSpeed / PawnAsBioPawn.GroundSpeed;
                }
            }
            if (NavList.Length > 0 && CurrentNavIdx < NavList.Length)
            {
                if (CurrentNavGoal == None)
                {
                    CurrentNavGoal = NavList[CurrentNavIdx++];
                }
                if (CurrentNavGoal != None && VSize(CurrentNavGoal.location - Pawn.location) <= 100.0)
                {
                    CurrentNavIdx++;
                    CurrentNavGoal = None;
                    if (CurrentNavIdx < NavList.Length)
                    {
                        CurrentNavGoal = NavList[CurrentNavIdx];
                    }
                }
                if (CurrentNavGoal != None)
                {
                    MoveFacing = Rotator(CurrentNavGoal.location - Pawn.location);
                    MoveDir = Vector(MoveFacing);
                }
            }
        }
        else
        {
            MoveAccMag = 0.0;
            MoveDir = vect(1.0, 0.0, 0.0);
            MoveWalkModifier = 0.0;
            MoveFacing = PawnAsBioPawn.Rotation;
        }
        if (MoveWalkModifier < PawnAsBioPawn.fMoveMag)
        {
            MoveWalkModifierAlpha = DeltaTime / 0.5;
            if (MoveWalkModifierAlpha > 1.0)
            {
                MoveWalkModifierAlpha = 1.0;
            }
            MoveWalkModifier = PawnAsBioPawn.fMoveMag + MoveWalkModifierAlpha * (MoveWalkModifier - PawnAsBioPawn.fMoveMag);
        }
        if (IsMoveInputIgnored() == FALSE)
        {
            PawnAsBioPawn.fMoveMag = MoveWalkModifier;
            PawnAsBioPawn.Acceleration = MoveDir * MoveAccMag;
        }
        else
        {
            PawnAsBioPawn.fMoveMag = 1.0;
            PawnAsBioPawn.Acceleration *= 0.0;
        }
        PawnAsBioPawn.SetDesiredRotation(MoveFacing);
        if (PawnAsBioPawn.GetModule(Class'SFXModule_Locomotion') != None)
        {
            PawnAsBioPawn.GetModule(Class'SFXModule_Locomotion').SetDesiredRotation(MoveFacing);
            PawnAsBioPawn.GetModule(Class'SFXModule_Locomotion').SetAcceleration(PawnAsBioPawn.Acceleration);
        }
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioHintSystem Name=HintSys0
    End Template
    Begin Template Class=BioPlayerSelection Name=oSelection
        Begin Template Class=SFXSelectionLensFlareComponent Name=SelectionFlare0
            ReplacementPrimitive = None
        End Template
        SelectionFlareComp = SelectionFlare0
    End Template
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SFXModule_AimAssist Name=AimAssist_0
    End Template
    SPMapNames = ('Biop_Cat002', 
                  'Biop_Cat003', 
                  'Biop_Cat004', 
                  'Biop_CerJcb', 
                  'Biop_CerMir', 
                  'Biop_CitSam', 
                  'Biop_End001', 
                  'Biop_End002', 
                  'Biop_Gth001', 
                  'Biop_Gth002', 
                  'Biop_GthLeg', 
                  'Biop_GthN7a', 
                  'Biop_Kro001', 
                  'Biop_Kro002', 
                  'Biop_KroGar', 
                  'Biop_KroGru', 
                  'Biop_KroN7a', 
                  'Biop_KroN7b', 
                  'Biop_SPCer', 
                  'Biop_SPDish', 
                  'Biop_SPNov', 
                  'Biop_SPRctr', 
                  'Biop_SPSlum', 
                  'Biop_SPTowr', 
                  'Biop_OmgJck', 
                  'Biop_ProEar', 
                  'Biop_ProMar'
                 )
    SPN7MapNames = ('Biop_SPCer', 'Biop_SPDish', 'Biop_SPNov', 'Biop_SPRctr', 'Biop_SPSlum', 'Biop_SPTowr')
    srConnectionLost = $602982
    srHostLeft = $588200
    srInviteFailure = $626903
    srInviteGameFull = $633665
    srInviterLeft = $699472
    srInviteProtocolMismatch = $649162
    srInviteMissingDLCInvitee = $657809
    srInviteMissingDLCInviter = $727595
    srMultiplayerUpdate = $641919
    srPlayerKicked = $709446
    nMaxInviteWaitDelay = 30
    ObjectiveTimerPositionY = 25
    QuickMantleDelay = 0.649999976
    HintSystem = HintSys0
    m_oPlayerSelection = oSelection
    CylinderComponent = CollisionCylinder
    MinHitWall = 0.0
    Components = (None, CollisionCylinder)
    Modules = (AimAssist_0)
    CollisionComponent = CollisionCylinder
}