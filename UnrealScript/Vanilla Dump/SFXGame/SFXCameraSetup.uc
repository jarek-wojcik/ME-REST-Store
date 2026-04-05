Class SFXCameraSetup;

var(SFXCameraSetup) InterpCurveFloat ZoomSnapCurve;
var(SFXCameraSetup) float SprintTransitionTime;
var(SFXCameraSetup) float SprintFastTransitionTime;
var(SFXCameraSetup) float DefaultAimTransitionTime;
var(SFXCameraSetup) float DefaultAimTransitionExit;
var(SFXCameraSetup) float DefaultCombatTransitionTime;
var(SFXCameraSetup) float CoverEnter;
var(SFXCameraSetup) float LeanCoverTransitionTime;
var(SFXCameraSetup) float CoverTransitionTime;
var(SFXCameraSetup) float CoverSlowTransitionTime;
var(SFXCameraSetup) float SniperZoomTransitionTime;
var(SFXCameraSetup) float ZoomSnapTransitionTime;
var(SFXCameraSetup) float PeekTransitionTime;
var(SFXCameraSetup) float StormEntranceTime;
var(SFXCameraSetup) float VehicleTransitionTime;
var(SFXCameraSetup) float fCustomCameraTransitionIn;
var(SFXCameraSetup) float fCustomCameraTransitionOut;
var(SFXCameraSetup) export SFXCameraMode_Combat CombatCam;
var(SFXCameraSetup) export SFXCameraMode_Roll RollCam;
var(SFXCameraSetup) export SFXCameraMode CombatTightAim;
var(SFXCameraSetup) export SFXCameraMode_Explore ExploreCam;
var(SFXCameraSetup) export SFXCameraMode_CombatStorm CombatStormCam;
var(SFXCameraSetup) export SFXCameraMode_ExploreStorm ExploreStormCam;
var(SFXCameraSetup) export SFXCameraMode_SplitScreenCombat SSCombatCam;
var(SFXCameraSetup) export SFXCameraMode_JumpStart JumpCam;
var(SFXCameraSetup) export SFXCameraMode_EnterCover EnterCoverCam;
var(SFXCameraSetup) export SFXCameraMode_Melee MeleeCam;
var(SFXCameraSetup) export SFXCameraMode_LadderUp LadderUp;
var(SFXCameraSetup) export SFXCameraMode_LadderDown LadderDown;
var(SFXCameraSetup) export SFXCameraMode_HitReaction HitReact;
var(SFXCameraSetup) export SFXCameraTransition_ZoomSnap ZoomSnapTransition;
var(SFXCameraSetup) export SFXCameraMode DefaultCrouch;
var(SFXCameraSetup) export SFXCameraMode DefaultStand;
var(SFXCameraSetup) export SFXCameraMode PeekLeftCrouch;
var(SFXCameraSetup) export SFXCameraMode PeekLeftStand;
var(SFXCameraSetup) export SFXCameraMode PeekRightCrouch;
var(SFXCameraSetup) export SFXCameraMode PeekRightStand;
var(SFXCameraSetup) export SFXCameraMode DefaultAimback;
var(SFXCameraSetup) export SFXCameraMode AimbackTightAim;
var(SFXCameraSetup) export SFXCameraMode BlindLeftCrouch;
var(SFXCameraSetup) export SFXCameraMode BlindLeftStand;
var(SFXCameraSetup) export SFXCameraMode BlindRightCrouch;
var(SFXCameraSetup) export SFXCameraMode BlindRightStand;
var(SFXCameraSetup) export SFXCameraMode BlindUp;
var(SFXCameraSetup) export SFXCameraMode PopUp;
var(SFXCameraSetup) export SFXCameraMode LeanLeftCrouch;
var(SFXCameraSetup) export SFXCameraMode LeanLeftStand;
var(SFXCameraSetup) export SFXCameraMode LeanRightCrouch;
var(SFXCameraSetup) export SFXCameraMode LeanRightStand;
var(SFXCameraSetup) export SFXCameraMode PowerCoverPopup;
var(SFXCameraSetup) export SFXCameraMode PowerCoverMidLeanLeft;
var(SFXCameraSetup) export SFXCameraMode PowerCoverMidLeanRight;
var(SFXCameraSetup) export SFXCameraMode PowerCoverStdLeanLeft;
var(SFXCameraSetup) export SFXCameraMode PowerCoverStdLeanRight;
var(SFXCameraSetup) bool bCustomCameraMode;

public function GetAimbackCameraMode(BioPlayerController PC, out SFXCameraMode NewCameraMode, out float TransitionTime)
{
    if (PC.IsZoomed())
    {
        NewCameraMode = AimbackTightAim;
        TransitionTime = DefaultAimTransitionTime;
    }
    else
    {
        NewCameraMode = DefaultAimback;
    }
}
public function SFXCameraMode GetCameraMode(BioPlayerController PC, SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    local BioPawn PlayerPawn;
    local SFXCameraMode NewCameraMode;
    local bool bCustomTransitionTime;
    local float fCustomTransitionTime;
    local SFXModule_AimAssist AimAssist;
    local ECoverType CoverType;
    
    PlayerPawn = BioPawn(PC.Pawn);
    AimAssist = PC.GetModule(Class'SFXModule_AimAssist');
    if (PlayerPawn != None)
    {
        CoverType = PlayerPawn.CoverType;
        if (SFXGame(PC.WorldInfo.Game) != None && !SFXGame(PC.WorldInfo.Game).bPerfProto || PC.IsLocalPlayerController())
        {
            if (!PlayerPawn.bCombatPawn)
            {
                GetExploreCameraMode(PC, NewCameraMode, TransitionTime);
            }
            else
            {
                bCustomTransitionTime = GetCustomCameraMode(PC, NewCameraMode, fCustomTransitionTime);
                if (bCustomCameraMode)
                {
                    fCustomTransitionTime = fCustomCameraTransitionIn;
                }
                else if (PlayerPawn.bNotifyCoverAlignment && CoverType == ECoverType.CT_MidLevel)
                {
                    NewCameraMode = EnterCoverCam;
                }
                else if (PlayerPawn.IsInCover() || PlayerPawn.CoverAction == ECoverAction.CA_Aimback)
                {
                    NewCameraMode = GetCoverCameraMode(PC, OldCameraMode, PreserveTarget, TransitionTime, Transition);
                }
                else if (PlayerPawn.bStorming)
                {
                    NewCameraMode = CombatStormCam;
                }
                else
                {
                    GetStandingCombatCamera(PC, OldCameraMode, NewCameraMode, TransitionTime);
                }
            }
        }
    }
    GetTransitionTime(OldCameraMode, NewCameraMode, TransitionTime);
    if (AimAssist != None && AimAssist.LastZoomSnapTarget != None)
    {
        Transition = ZoomSnapTransition;
        TransitionTime = ZoomSnapTransitionTime;
        ZoomSnapTransition.ZoomSnapTargetLocation = AimAssist.LastZoomSnapTarget.location + AimAssist.ZoomSnapTarget;
    }
    if (bCustomTransitionTime)
    {
        TransitionTime = fCustomTransitionTime;
    }
    return NewCameraMode;
}
public function SFXCameraMode GetCombatCamera()
{
    return Class'Engine'.static.IsSplitScreen() ? SSCombatCam : CombatCam;
}
public function SFXCameraMode GetCoverCameraMode(BioPlayerController PC, SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    local BioPawn PlayerPawn;
    local BioCustomAction CustomAction;
    local SFXCameraMode NewCameraMode;
    
    PlayerPawn = BioPawn(PC.Pawn);
    if (PC.IsInState('PlayerInAimBack', ))
    {
        GetAimbackCameraMode(PC, NewCameraMode, TransitionTime);
    }
    else
    {
        switch (PlayerPawn.CoverAction)
        {
            case ECoverAction.CA_LeanLeft:
                if (PC.IsZoomed() || !SFXWeapon(PlayerPawn.Weapon).CanPartialLean())
                {
                    TransitionTime = LeanCoverTransitionTime;
                    NewCameraMode = PlayerPawn.bIsCrouched ? LeanLeftCrouch : LeanLeftStand;
                }
                else if (PlayerPawn.IsUsingPower())
                {
                    if (PlayerPawn.GetCurrentCustomAction(CustomAction) && SFXPowerCustomAction(CustomAction) != None)
                    {
                        if (PlayerPawn.CoverType == ECoverType.CT_MidLevel)
                        {
                            NewCameraMode = PowerCoverMidLeanLeft;
                        }
                        else
                        {
                            NewCameraMode = PowerCoverStdLeanLeft;
                        }
                        TransitionTime = DefaultAimTransitionExit;
                    }
                }
                else
                {
                    NewCameraMode = PlayerPawn.CoverType == ECoverType.CT_MidLevel ? DefaultCrouch : DefaultStand;
                    TransitionTime = DefaultAimTransitionExit;
                }
                break;
            case ECoverAction.CA_BlindLeft:
                TransitionTime = CoverTransitionTime;
                NewCameraMode = PlayerPawn.bIsCrouched ? BlindLeftCrouch : BlindLeftStand;
                break;
            case ECoverAction.CA_PeekLeft:
                TransitionTime = PeekTransitionTime;
                NewCameraMode = PlayerPawn.bIsCrouched ? PeekLeftCrouch : PeekLeftStand;
                break;
            case ECoverAction.CA_LeanRight:
                if (PC.IsZoomed() || !SFXWeapon(PlayerPawn.Weapon).CanPartialLean())
                {
                    TransitionTime = LeanCoverTransitionTime;
                    NewCameraMode = PlayerPawn.bIsCrouched ? LeanRightCrouch : LeanRightStand;
                }
                else if (PlayerPawn.IsUsingPower())
                {
                    if (PlayerPawn.GetCurrentCustomAction(CustomAction) && SFXPowerCustomAction(CustomAction) != None)
                    {
                        if (PlayerPawn.CoverType == ECoverType.CT_MidLevel)
                        {
                            NewCameraMode = PowerCoverMidLeanRight;
                        }
                        else
                        {
                            NewCameraMode = PowerCoverStdLeanRight;
                        }
                        TransitionTime = DefaultAimTransitionExit;
                    }
                }
                else
                {
                    NewCameraMode = PlayerPawn.CoverType == ECoverType.CT_MidLevel ? DefaultCrouch : DefaultStand;
                    TransitionTime = DefaultAimTransitionExit;
                }
                break;
            case ECoverAction.CA_BlindRight:
                TransitionTime = CoverTransitionTime;
                NewCameraMode = PlayerPawn.bIsCrouched ? BlindRightCrouch : BlindRightStand;
                break;
            case ECoverAction.CA_PeekRight:
                NewCameraMode = PlayerPawn.bIsCrouched ? PeekRightCrouch : PeekRightStand;
                TransitionTime = PeekTransitionTime;
                break;
            case ECoverAction.CA_PopUp:
                if (PC.IsZoomed() || !SFXWeapon(PlayerPawn.Weapon).CanPartialLean())
                {
                    TransitionTime = CoverTransitionTime;
                    NewCameraMode = PopUp;
                }
                else if (PlayerPawn.IsUsingPower())
                {
                    if (PlayerPawn.GetCurrentCustomAction(CustomAction) && SFXPowerCustomAction(CustomAction) != None)
                    {
                        NewCameraMode = PowerCoverPopup;
                        TransitionTime = DefaultAimTransitionExit;
                    }
                }
                else
                {
                    NewCameraMode = PlayerPawn.CoverType == ECoverType.CT_MidLevel ? DefaultCrouch : DefaultStand;
                    TransitionTime = DefaultAimTransitionExit;
                }
                break;
            case ECoverAction.CA_BlindUp:
                NewCameraMode = BlindUp;
                TransitionTime = DefaultAimTransitionExit;
                break;
            case ECoverAction.CA_Default:
                NewCameraMode = PlayerPawn.CoverType == ECoverType.CT_MidLevel ? DefaultCrouch : DefaultStand;
                TransitionTime = CoverEnter;
                break;
            default:
        }
    }
    GetTransitionTime(OldCameraMode, NewCameraMode, TransitionTime);
    return NewCameraMode;
}
public function bool GetCustomCameraMode(BioPlayerController PC, out SFXCameraMode NewCameraMode, out float fCustomTransitionTime)
{
    local BioCustomAction CustomAction;
    local bool bCustomTransitionTime;
    local BioPawn PlayerPawn;
    
    PlayerPawn = BioPawn(PC.Pawn);
    PlayerPawn.GetCurrentCustomAction(CustomAction);
    if (!bCustomCameraMode)
    {
        if (CustomAction != None && CustomAction.GetCustomActionCamera(NewCameraMode, fCustomCameraTransitionIn, fCustomCameraTransitionOut))
        {
            bCustomCameraMode = TRUE;
            bCustomTransitionTime = TRUE;
        }
    }
    else
    {
        bCustomTransitionTime = TRUE;
        bCustomCameraMode = CustomAction != None ? CustomAction.GetCustomActionCamera(NewCameraMode, fCustomCameraTransitionIn, fCustomCameraTransitionOut) : FALSE;
        if (!bCustomCameraMode)
        {
            fCustomTransitionTime = fCustomCameraTransitionOut;
        }
    }
    return bCustomTransitionTime;
}
public function GetExploreCameraMode(BioPlayerController PC, out SFXCameraMode NewCameraMode, out float TransitionTime)
{
    local BioPawn PlayerPawn;
    
    PlayerPawn = BioPawn(PC.Pawn);
    if (PlayerPawn != None && PlayerPawn.bStorming)
    {
        NewCameraMode = ExploreStormCam;
        TransitionTime = SprintTransitionTime;
    }
    else
    {
        NewCameraMode = ExploreCam;
    }
}
public function GetStandingCombatCamera(BioPlayerController PC, SFXCameraMode OldCameraMode, out SFXCameraMode NewCameraMode, out float TransitionTime)
{
    if (PC.IsZoomed())
    {
        NewCameraMode = CombatTightAim;
        TransitionTime = DefaultAimTransitionTime;
    }
    else
    {
        NewCameraMode = GetCombatCamera();
        TransitionTime = DefaultCombatTransitionTime;
    }
}
public function GetTransitionTime(out SFXCameraMode OldCameraMode, out SFXCameraMode NewCameraMode, out float TransitionTime)
{
    if (OldCameraMode == None || NewCameraMode == None)
    {
        TransitionTime = 0.0;
        return;
    }
    if (OldCameraMode == CombatStormCam || NewCameraMode == CombatStormCam || OldCameraMode == ExploreStormCam || NewCameraMode == ExploreStormCam || OldCameraMode == ExploreCam || NewCameraMode == ExploreCam)
    {
        TransitionTime = DefaultAimTransitionExit;
    }
    if (SFXCameraMode_Vehicle(OldCameraMode) != None || SFXCameraMode_Vehicle(NewCameraMode) != None)
    {
        TransitionTime = VehicleTransitionTime;
    }
    if (OldCameraMode == CombatCam && NewCameraMode == LadderUp)
    {
        TransitionTime = DefaultAimTransitionTime;
    }
    if (OldCameraMode == CombatCam && NewCameraMode == LadderDown)
    {
        TransitionTime = DefaultAimTransitionTime;
    }
    if (OldCameraMode == GetCombatCamera() && NewCameraMode == ExploreCam)
    {
        TransitionTime = DefaultAimTransitionExit;
    }
    if (OldCameraMode == ExploreCam && NewCameraMode == GetCombatCamera())
    {
        TransitionTime = DefaultAimTransitionExit;
    }
    if (OldCameraMode == CombatStormCam && NewCameraMode == CombatCam)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == RollCam && NewCameraMode == CombatCam)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == PeekLeftStand && NewCameraMode == RollCam)
    {
        TransitionTime = CoverEnter;
    }
    if (OldCameraMode == PeekLeftCrouch && NewCameraMode == RollCam)
    {
        TransitionTime = CoverEnter;
    }
    if (OldCameraMode == PeekRightCrouch && NewCameraMode == RollCam)
    {
        TransitionTime = CoverEnter;
    }
    if (OldCameraMode == PeekRightStand && NewCameraMode == RollCam)
    {
        TransitionTime = CoverEnter;
    }
    if (OldCameraMode == CombatStormCam && NewCameraMode == JumpCam)
    {
        TransitionTime = SprintFastTransitionTime;
    }
    if (OldCameraMode == JumpCam && NewCameraMode == CombatStormCam)
    {
        TransitionTime = SprintFastTransitionTime;
    }
    if (OldCameraMode == CombatCam && NewCameraMode == MeleeCam)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == CombatStormCam && NewCameraMode == MeleeCam)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == CombatCam && NewCameraMode == HitReact)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == CombatStormCam && NewCameraMode == HitReact)
    {
        TransitionTime = DefaultCombatTransitionTime;
    }
    if (OldCameraMode == ExploreStormCam && NewCameraMode == ExploreCam)
    {
        TransitionTime = DefaultAimTransitionExit;
    }
    if (OldCameraMode == ExploreStormCam && NewCameraMode == GetCombatCamera())
    {
        TransitionTime = SprintTransitionTime;
    }
    if (OldCameraMode == CombatStormCam && NewCameraMode == CombatCam)
    {
        TransitionTime = DefaultAimTransitionExit;
    }
    if (NewCameraMode == CombatStormCam)
    {
        TransitionTime = StormEntranceTime;
    }
    if (NewCameraMode.bFirstPerson)
    {
        TransitionTime = SniperZoomTransitionTime;
    }
    else if (OldCameraMode.bFirstPerson)
    {
        TransitionTime = SniperZoomTransitionTime;
    }
}
public function bool ShouldUseScope(Pawn inPawn)
{
    local SFXWeapon Weapon;
    local BioPawn BP;
    
    BP = BioPawn(inPawn);
    if (BP != None)
    {
        Weapon = SFXWeapon(BP.Weapon);
        if (Weapon != None && Weapon.CurrentAimMode >= 0 && Weapon.CurrentAimMode < Weapon.AimModes.Length)
        {
            return Weapon.AimModes[Weapon.CurrentAimMode].bScoped && !BP.IsUsingPower();
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Combat Name=Aimback0
        Offset = {X = 125.0, Y = -40.0, Z = 0.0}
        HookOffset = {X = -30.0, Y = 0.0, Z = 90.0}
        CameraName = 'DefaultAimback'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=BlindLeftCrouch0
        Offset = {X = 125.0, Y = 70.0, Z = 20.0}
        HookOffset = {X = -20.0, Y = -30.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'BlindLeftCrouch'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=BlindLeftStand0
        Offset = {X = 125.0, Y = 60.0, Z = 40.0}
        HookOffset = {X = 0.0, Y = -25.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'BlindLeftStand'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=BlindRightCrouch0
        Offset = {X = 125.0, Y = -70.0, Z = 20.0}
        HookOffset = {X = -20.0, Y = 10.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'BlindRightCrouch'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=BlindRightStand0
        Offset = {X = 125.0, Y = -60.0, Z = 40.0}
        HookOffset = {X = -20.0, Y = 25.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'BlindRightStand'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=CombatCam0
        Offset = {X = 90.0, Y = -22.0, Z = 25.0}
        HookOffset = {X = -30.0, Y = 20.0, Z = 90.0}
        CameraName = 'CombatCam'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=DefaultCrouch0
        Offset = {X = 125.0, Y = -40.0, Z = 20.0}
        HookOffset = {X = -40.0, Y = -10.0, Z = 45.0}
        CameraName = 'DefaultCrouch'
        FOV = 83.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=DefaultStand0
        Offset = {X = 125.0, Y = 0.0, Z = 40.0}
        HookOffset = {X = -40.0, Y = 0.0, Z = 110.0}
        CameraName = 'DefaultStand'
        FOV = 83.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PeekLeftCrouch0
        Offset = {X = 125.0, Y = 70.0, Z = 20.0}
        HookOffset = {X = -30.0, Y = 30.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'PeekLeftCrouch'
        FOV = 80.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PeekLeftStand0
        Offset = {X = 125.0, Y = 60.0, Z = 40.0}
        HookOffset = {X = -30.0, Y = 0.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'PeekLeftStand'
        FOV = 80.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PeekRightCrouch0
        Offset = {X = 125.0, Y = -70.0, Z = 20.0}
        HookOffset = {X = -30.0, Y = -20.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'PeekRightCrouch'
        FOV = 80.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PeekRightStand0
        Offset = {X = 125.0, Y = -60.0, Z = 40.0}
        HookOffset = {X = -30.0, Y = 0.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'PeekRightStand'
        FOV = 80.9700012
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PowerCover0
        Offset = {X = 125.0, Y = 0.0, Z = 40.0}
        HookOffset = {X = 0.0, Y = 0.0, Z = 110.0}
        CameraName = 'PowerCoverPopup'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PowerCoverMidLeft0
        Offset = {X = 125.0, Y = 70.0, Z = 20.0}
        HookOffset = {X = -20.0, Y = -30.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'PowerCoverMidLeanLeft'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PowerCoverMidRight0
        Offset = {X = 125.0, Y = -70.0, Z = 20.0}
        HookOffset = {X = -20.0, Y = 10.0, Z = 70.0}
        HookName = 'CoverSlot'
        CameraName = 'PowerCoverMidLeanRight'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PowerCoverStdLeft0
        Offset = {X = 125.0, Y = 60.0, Z = 40.0}
        HookOffset = {X = 0.0, Y = -25.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'PowerCoverStdLeanLeft'
    End Object
    Begin Object Class=SFXCameraMode_Combat Name=PowerCoverStdRight0
        Offset = {X = 125.0, Y = -60.0, Z = 40.0}
        HookOffset = {X = -20.0, Y = 25.0, Z = 140.0}
        HookName = 'CoverSlot'
        CameraName = 'PowerCoverStdLeanRight'
    End Object
    Begin Object Class=SFXCameraMode_CombatStorm Name=CombatStormCam0
        CameraName = 'CombatStormCam'
    End Object
    Begin Object Class=SFXCameraMode_EnterCover Name=EnterCoverCam0
        CameraName = 'EnterCoverCam'
    End Object
    Begin Object Class=SFXCameraMode_Explore Name=ExploreCam0
        CameraName = 'ExploreCam'
    End Object
    Begin Object Class=SFXCameraMode_ExploreStorm Name=ExploreStormCam0
        CameraName = 'ExploreStormCam'
    End Object
    Begin Object Class=SFXCameraMode_HipAimCover Name=BlindUp0
        Offset = {X = 125.0, Y = -60.0, Z = 50.0}
        HookOffset = {X = 0.0, Y = -10.0, Z = 90.0}
        CameraName = 'BlindUp'
        FOV = 80.0
    End Object
    Begin Object Class=SFXCameraMode_HitReaction Name=HitReact0
        CameraName = 'HitReact'
    End Object
    Begin Object Class=SFXCameraMode_LadderDown Name=LadderDown0
        CameraName = 'LadderDown'
    End Object
    Begin Object Class=SFXCameraMode_LadderUp Name=LadderUp0
        CameraName = 'LadderUp'
    End Object
    Begin Object Class=SFXCameraMode_Melee Name=MeleeCam0
        CameraName = 'EnterCoverCam'
    End Object
    Begin Object Class=SFXCameraMode_Roll Name=RollCam0
        CameraName = 'RollCam'
    End Object
    Begin Object Class=SFXCameraMode_SplitScreenCombat Name=SSCombatCam0
        CameraName = 'SSCombatCam'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=AimbackTightAim0
        Offset = {X = 50.0, Y = -40.0, Z = 40.0}
        HookOffset = {X = -10.0, Y = 0.0, Z = 120.0}
        CameraName = 'AimbackTightAim'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=CombatTightAim0
        Offset = {X = 50.0, Y = -20.0, Z = 15.0}
        HookOffset = {X = -30.0, Y = 20.0, Z = 80.0}
        CameraName = 'CombatTightAim'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=LeanLeftCrouch0
        Offset = {X = 125.0, Y = 115.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = 15.0, Z = 75.0}
        HookName = 'CoverSlot'
        CameraName = 'LeanLeftStand'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=LeanLeftStand0
        Offset = {X = 125.0, Y = 110.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = 15.0, Z = 115.0}
        HookName = 'CoverSlot'
        CameraName = 'LeanLeftStand'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=LeanRightCrouch0
        Offset = {X = 135.0, Y = -110.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = -10.0, Z = 65.0}
        HookName = 'CoverSlot'
        CameraName = 'LeanRightCrouch'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=LeanRightStand0
        Offset = {X = 125.0, Y = -115.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = -12.0, Z = 115.0}
        HookName = 'CoverSlot'
        CameraName = 'LeanRightStand'
    End Object
    Begin Object Class=SFXCameraMode_TightAim Name=PopUp0
        Offset = {X = 85.0, Y = -32.0, Z = -38.0}
        HookOffset = {X = 0.0, Y = 5.0, Z = 28.0}
        HookName = 'God'
        CameraName = 'PopUp'
    End Object
    Begin Object Class=SFXCameraTransition_ZoomSnap Name=ZoomSnapTransition0
    End Object
    ZoomSnapCurve = {
                     Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                               {InVal = 1.0, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                              ), 
                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                    }
    SprintTransitionTime = 0.300000012
    SprintFastTransitionTime = 0.379999995
    DefaultAimTransitionTime = 0.0799999982
    DefaultAimTransitionExit = 0.5
    DefaultCombatTransitionTime = 0.25
    CoverEnter = 0.5
    LeanCoverTransitionTime = 0.25
    CoverTransitionTime = 0.25
    CoverSlowTransitionTime = 1.0
    SniperZoomTransitionTime = 0.150000006
    ZoomSnapTransitionTime = 0.100000001
    PeekTransitionTime = 0.5
    StormEntranceTime = 1.0
    VehicleTransitionTime = 1.0
    CombatCam = CombatCam0
    RollCam = RollCam0
    CombatTightAim = CombatTightAim0
    ExploreCam = ExploreCam0
    CombatStormCam = CombatStormCam0
    ExploreStormCam = ExploreStormCam0
    SSCombatCam = SSCombatCam0
    EnterCoverCam = EnterCoverCam0
    MeleeCam = MeleeCam0
    LadderUp = LadderUp0
    LadderDown = LadderDown0
    HitReact = HitReact0
    ZoomSnapTransition = ZoomSnapTransition0
    DefaultCrouch = DefaultCrouch0
    DefaultStand = DefaultStand0
    PeekLeftCrouch = PeekLeftCrouch0
    PeekLeftStand = PeekLeftStand0
    PeekRightCrouch = PeekRightCrouch0
    PeekRightStand = PeekRightStand0
    DefaultAimback = Aimback0
    AimbackTightAim = AimbackTightAim0
    BlindLeftCrouch = BlindLeftCrouch0
    BlindLeftStand = BlindLeftStand0
    BlindRightCrouch = BlindRightCrouch0
    BlindRightStand = BlindRightStand0
    BlindUp = BlindUp0
    PopUp = PopUp0
    LeanLeftCrouch = LeanLeftCrouch0
    LeanLeftStand = LeanLeftStand0
    LeanRightCrouch = LeanRightCrouch0
    LeanRightStand = LeanRightStand0
    PowerCoverPopup = PowerCover0
    PowerCoverMidLeanLeft = PowerCoverMidLeft0
    PowerCoverMidLeanRight = PowerCoverMidRight0
    PowerCoverStdLeanLeft = PowerCoverStdLeft0
    PowerCoverStdLeanRight = PowerCoverStdRight0
}