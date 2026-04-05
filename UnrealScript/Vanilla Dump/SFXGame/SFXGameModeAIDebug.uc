Class SFXGameModeAIDebug extends SFXGameModeBase within BioPlayerController
    config(Input);

var ViewTargetTransitionParams VTTransParms;
var Vector2D TopLeft;
var SFXPathWeightLog TotalWeightLog;
var int CurrentConstraintIndex;
var Pawn DebugTarget;
var Color TitleColor;
var Color DrawWhite;
var Color DrawRed;
var Color DrawOrange;
var Color DrawGreen;
var(SFXGameModeAIDebug) export SFXCameraMode_AIDebug AICamera;
var bool bPaused;
var(Options) bool bShowAITarget;
var(Options) bool bShowAIPath;
var(Options) bool bShowDecisionLog;
var bool bViewingConstraintEvals;
var bool bLoggingAllAI;
var bool bUnPauseOnExit;
var bool bShowLegend;

public function Activated()
{
    local BioHUD HUD;
    
    Super.Activated();
    AICamera = new (Self) Class'SFXCameraMode_AIDebug';
    PauseAI();
    DebugTarget = Outer.Pawn;
    Outer.ConsoleCommand("show postprocess");
    Outer.ConsoleCommand("show scaleform");
    Outer.ConsoleCommand("god");
    BioWorldInfo(Outer.WorldInfo).bShowDebugText = FALSE;
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.AddDebugDraw(DrawAIHUD);
    }
}
public function Deactivated()
{
    local BioHUD HUD;
    
    Super.Deactivated();
    if (bUnPauseOnExit)
    {
        UnpauseAI();
    }
    DebugTarget = None;
    Outer.SetViewTarget(Outer.Pawn, VTTransParms);
    Outer.ConsoleCommand("show postprocess");
    Outer.ConsoleCommand("show scaleform");
    Outer.ConsoleCommand("god");
    DisableAllCoverLogging();
    BioWorldInfo(Outer.WorldInfo).bShowDebugText = FALSE;
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && HUD.IsDrawing(DrawAIHUD))
    {
        HUD.ClearDebugDraw(DrawAIHUD);
    }
}
public exec function NextPawn()
{
    local array<Pawn> PawnList;
    local Pawn P;
    local int idx;
    local SFXAI_NativeBase AI;
    local SFXAI_NativeBase LastAI;
    
    if (Outer.PlayerCamera.PendingViewTarget.Target == None)
    {
        foreach Outer.WorldInfo.AllPawns(Class'Pawn', P)
        {
            if (!P.bDeleteMe)
            {
                PawnList.AddItem(P);
            }
        }
        idx = PawnList.Find(DebugTarget);
        if (idx != -1)
        {
            idx = idx < PawnList.Length - 1 ? idx + 1 : 0;
            LastAI = SFXAI_NativeBase(DebugTarget.Controller);
            DebugTarget = PawnList[idx];
            AI = SFXAI_NativeBase(DebugTarget.Controller);
            if (AI != None && AI.PathWeightLog != None)
            {
                TotalWeightLog = AI.PathWeightLog;
            }
            else
            {
                TotalWeightLog = None;
            }
            if (!bLoggingAllAI && LastAI != None && LastAI != AI)
            {
                LastAI.PathWeightLog = None;
            }
            Outer.PlayerCamera.SetViewTarget(DebugTarget, VTTransParms);
        }
    }
}
public exec function Option(string Param)
{
    switch (Param)
    {
        case "target":
            bShowAITarget = !bShowAITarget;
            break;
        case "path":
            bShowAIPath = !bShowAIPath;
            break;
        case "decision":
            bShowDecisionLog = !bShowDecisionLog;
            break;
        default:
    }
}
public exec function ZoomCamera()
{
    AICamera.DecOffset();
}
public exec function Eval(string param1, optional int param2)
{
    local SFXAI_Cover AI;
    local array<CoverGoalConstraint> CoverConstraints;
    
    AI = SFXAI_Cover(Pawn(Outer.GetViewTarget()).Controller);
    if (AI == None)
    {
        Outer.ClientMessage("Can only evaluate AI pawns");
        return;
    }
    switch (param1)
    {
        case "cover":
            TotalWeightLog = AI.PathWeightLog;
            if (AI.PathWeightLog == None)
            {
                AI.PathWeightLog = new (AI) Class'SFXPathWeightLog';
                TotalWeightLog = AI.PathWeightLog;
            }
            AI.InitializeCoverConstraints(AI.MyCoverEval, AI.FireTarget);
            AI.FindPathToward(AI.FireTarget, , , );
            break;
        case "constraint":
            if (param2 >= 0 && param2 < AI.MyCoverEval.CoverGoalConstraints.Length)
            {
                TotalWeightLog = AI.PathWeightLog;
                if (AI.PathWeightLog == None)
                {
                    AI.PathWeightLog = new (AI) Class'SFXPathWeightLog';
                    TotalWeightLog = AI.PathWeightLog;
                }
                CoverConstraints = AI.MyCoverEval.CoverGoalConstraints;
                AI.MyCoverEval.CoverGoalConstraints.Length = 0;
                AI.MyCoverEval.CoverGoalConstraints.AddItem(CoverConstraints[param2]);
                AI.InitializeCoverConstraints(AI.MyCoverEval, AI.FireTarget);
                AI.FindPathToward(AI.FireTarget, , , );
                AI.MyCoverEval.CoverGoalConstraints = CoverConstraints;
            }
            break;
        case "clear":
            if (AI.PathWeightLog != None)
            {
                AI.PathWeightLog = None;
            }
            TotalWeightLog = None;
            break;
        default:
    }
}
public exec function DisableAllCoverLogging()
{
    local SFXAI_NativeBase C;
    
    bLoggingAllAI = FALSE;
    foreach Outer.WorldInfo.AllControllers(Class'SFXAI_NativeBase', C)
    {
        C.PathWeightLog = None;
    }
}
public function DrawAIHUD(BioHUD H)
{
    local float XL;
    local float YL;
    local float X;
    local float Y;
    local Canvas Canvas;
    local Vector ScreenCoords;
    local int idx;
    local SFXAI_Cover AI;
    local Vector Start;
    local Rotator Rot;
    local NavigationPoint LastNav;
    local NavigationPoint Nav;
    local Goal_AtCover CoverEval;
    local float NavWeight;
    
    Canvas = Outer.myHUD.Canvas;
    if (Canvas == None)
    {
        return;
    }
    if (DebugTarget != None && (DebugTarget.bPendingDelete || DebugTarget.bTearOff))
    {
        NextPawn();
    }
    Canvas.bCenter = TRUE;
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    Canvas.TextSize("M", XL, YL);
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        Canvas.SetPos(H.SafeAreaRatioX * float(Canvas.SizeX), H.SafeAreaRatioY * float(Canvas.SizeY));
    }
    else
    {
        Canvas.SetPos(2.0, 0.0);
    }
    Canvas.CurY += YL;
    Canvas.DrawColor = TitleColor;
    Canvas.Font = Class'Engine'.static.GetMediumFont();
    Canvas.DrawText("AI DEBUGGING MODE");
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    Canvas.CurY += YL;
    Canvas.DrawColor = DrawWhite;
    Canvas.DrawText("Currently Viewing <<" @ Outer.GetViewTarget() @ ">> (" @ Outer.GetViewTarget().Tag @ ")");
    Canvas.DrawColor = TitleColor;
    Canvas.Draw2DLine(0.0, Canvas.CurY, Canvas.ClipX, Canvas.CurY, Canvas.DrawColor);
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        TopLeft.X = H.SafeAreaRatioX * float(Canvas.SizeX);
    }
    else
    {
        TopLeft.X = 2.0;
    }
    TopLeft.Y = Canvas.CurY + YL;
    Canvas.bCenter = FALSE;
    Canvas.DrawColor = DrawWhite;
    Canvas.CurY += YL;
    if (bPaused)
    {
        Canvas.Font = Class'Engine'.static.GetMediumFont();
        Canvas.bCenter = TRUE;
        Canvas.DrawColor = DrawRed;
        Canvas.DrawText("PAUSED");
        Canvas.bCenter = FALSE;
        Canvas.DrawColor = DrawWhite;
        Canvas.Font = Class'Engine'.static.GetSmallFont();
    }
    AI = SFXAI_Cover(Pawn(Outer.GetViewTarget()).Controller);
    if (AI != None)
    {
        CoverEval = AI.MyCoverEval;
        if (CoverEval != None)
        {
            Canvas.SetPos(TopLeft.X + float(5), TopLeft.Y);
            Canvas.DrawText("Cover Evaluator:" @ CoverEval.Class);
            for (idx = 0; idx < CoverEval.CoverGoalConstraints.Length; idx++)
            {
                if (idx == CurrentConstraintIndex && bViewingConstraintEvals)
                {
                    Canvas.DrawColor = DrawOrange;
                }
                Canvas.CurX = TopLeft.X + float(5);
                Canvas.DrawText(" " $ idx $ ":" @ CoverEval.CoverGoalConstraints[idx].Class);
                if (idx == CurrentConstraintIndex && bViewingConstraintEvals)
                {
                    Canvas.DrawColor = DrawWhite;
                }
            }
        }
        if (bShowLegend)
        {
            Canvas.SetPos(TopLeft.X + float(950), TopLeft.Y);
            Canvas.DrawText("Draw FireTarget:" @ bShowAITarget);
            Canvas.CurX = TopLeft.X + float(950);
            Canvas.DrawText("Draw AI Path:" @ bShowAIPath);
            Canvas.CurX = TopLeft.X + float(950);
            Canvas.DrawText("Draw Decision Log:" @ bShowDecisionLog);
            Canvas.CurX = TopLeft.X + float(950);
            Canvas.CurY += YL;
            Canvas.DrawText("Commands:");
            Canvas.DrawText(" eval cover - show cover eval results");
            Canvas.DrawText(" eval constraint # - show constraint # eval");
            Canvas.DrawText(" eval clear - clear eval");
            Canvas.DrawText(" option target - toggle firetarget");
            Canvas.DrawText(" option path - toggle AI path");
            Canvas.DrawText(" option decision - toggle decisions");
            Canvas.DrawText(" ViewConstraint # - view constraint # eval");
            Canvas.DrawText(" ViewCoverEval - view normal cover eval");
            Canvas.DrawText(" ToggleAIPause - pauses/unpauses the AI");
            Canvas.DrawText(" KeepPaused - keep the AI paused on exit");
            Canvas.DrawText(" EnableAllCoverLogging - enable the log for all AI");
            Canvas.DrawText(" ToggleLegend - show/hide this legend");
            Canvas.DrawText("Hotkeys:");
            Canvas.DrawText(" # - view constraint # eval");
            Canvas.DrawText(" R - view normal cover eval");
            Canvas.DrawText(" Spacebar - pauses/unpauses the AI");
        }
        if (TotalWeightLog != None)
        {
            X = Canvas.CurX;
            Y = Canvas.CurY;
            YL = Canvas.CurYL;
            Canvas.DrawColor = DrawOrange;
            for (idx = 0; idx < TotalWeightLog.NavWeights.Length; idx++)
            {
                ScreenCoords = Canvas.Project(TotalWeightLog.NavWeights[idx].Nav.location);
                Canvas.CurX = ScreenCoords.X;
                Canvas.CurY = ScreenCoords.Y;
                if (bViewingConstraintEvals && CurrentConstraintIndex >= 0 && CurrentConstraintIndex < TotalWeightLog.NavWeights[idx].ConstraintWeights.Length)
                {
                    NavWeight = TotalWeightLog.NavWeights[idx].ConstraintWeights[CurrentConstraintIndex];
                }
                else
                {
                    NavWeight = TotalWeightLog.NavWeights[idx].Weight;
                }
                if (TotalWeightLog.NavWeights[idx].FailedIndex != -1)
                {
                    Canvas.DrawColor = DrawRed;
                    if (bViewingConstraintEvals)
                    {
                        Canvas.DrawText(PrettyFloat(NavWeight));
                    }
                    else
                    {
                        Canvas.DrawText("(" $ TotalWeightLog.NavWeights[idx].FailedIndex $ ")");
                    }
                    Canvas.DrawColor = DrawOrange;
                    continue;
                }
                if (TotalWeightLog.NavWeights[idx].Nav == TotalWeightLog.BestWeight.Nav)
                {
                    Canvas.DrawColor = DrawGreen;
                    Canvas.DrawText(PrettyFloat(NavWeight));
                    Canvas.DrawColor = DrawOrange;
                    continue;
                }
                Canvas.DrawText(PrettyFloat(NavWeight));
            }
            Canvas.CurX = X;
            Canvas.CurY = Y;
            Canvas.CurYL = YL;
            Canvas.DrawColor = DrawWhite;
        }
        if (bShowAITarget && AI.FireTarget != None)
        {
            AI.GetActorEyesViewPoint(Start, Rot);
            Outer.DrawDebugLine(Start, AI.FireTarget.location, 255, 0, 0);
        }
        if (bShowAIPath && AI.RouteCache.Length > 0)
        {
            if (AI.MoveTarget != None)
            {
                Outer.DrawDebugLine(DebugTarget.location, AI.MoveTarget.location, 255, 255, 255);
            }
            LastNav = NavigationPoint(AI.MoveTarget);
            foreach AI.RouteCache(Nav, )
            {
                if (LastNav != None)
                {
                    Outer.DrawDebugLine(LastNav.location, Nav.location, 0, 0, 255);
                }
                LastNav = Nav;
            }
        }
    }
}
public exec function EnableAllCoverLogging()
{
    local SFXAI_NativeBase C;
    
    bLoggingAllAI = TRUE;
    foreach Outer.WorldInfo.AllControllers(Class'SFXAI_NativeBase', C)
    {
        if (C.PathWeightLog == None)
        {
            C.PathWeightLog = new (C) Class'SFXPathWeightLog';
        }
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.200000003;
    PreserveTarget = 0;
    return AICamera;
}
public exec function KeepPaused(bool bKeepPaused)
{
    bUnPauseOnExit = !bKeepPaused;
}
public function PauseAI()
{
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        C.bNoTick = TRUE;
        if (C.Pawn != None)
        {
            C.Pawn.bNoTick = TRUE;
        }
    }
    bPaused = TRUE;
}
public function string PrettyFloat(float F, optional int decimals = 1)
{
    return Left(string(F), Len(string(F)) - 4 + decimals);
}
public exec function PrevPawn()
{
    local array<Pawn> PawnList;
    local Pawn P;
    local int idx;
    local SFXAI_NativeBase AI;
    local SFXAI_NativeBase LastAI;
    
    if (Outer.PlayerCamera.PendingViewTarget.Target == None)
    {
        foreach Outer.WorldInfo.AllPawns(Class'Pawn', P)
        {
            if (!P.bDeleteMe)
            {
                PawnList.AddItem(P);
            }
        }
        idx = PawnList.Find(DebugTarget);
        if (idx != -1)
        {
            idx = idx > 0 ? idx - 1 : PawnList.Length - 1;
            LastAI = SFXAI_NativeBase(DebugTarget.Controller);
            DebugTarget = PawnList[idx];
            AI = SFXAI_NativeBase(DebugTarget.Controller);
            if (AI != None && AI.PathWeightLog != None)
            {
                TotalWeightLog = AI.PathWeightLog;
            }
            else
            {
                TotalWeightLog = None;
            }
            if (!bLoggingAllAI && LastAI != None && LastAI != AI)
            {
                LastAI.PathWeightLog = None;
            }
            Outer.PlayerCamera.SetViewTarget(DebugTarget, VTTransParms);
        }
    }
}
public exec function ToggleAIPause()
{
    if (!bPaused)
    {
        PauseAI();
    }
    else
    {
        UnpauseAI();
    }
}
public exec function ToggleLegend()
{
    bShowLegend = !bShowLegend;
}
public function UnpauseAI()
{
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        C.bNoTick = FALSE;
        if (C.Pawn != None)
        {
            C.Pawn.bNoTick = FALSE;
        }
    }
    bPaused = FALSE;
}
public exec function UnzoomCamera()
{
    AICamera.IncOffset();
}
public exec function ViewConstraint(int Param)
{
    if (TotalWeightLog != None)
    {
        bViewingConstraintEvals = Param >= 0 ? TRUE : FALSE;
        CurrentConstraintIndex = Param;
    }
    else
    {
        bViewingConstraintEvals = FALSE;
    }
}
public exec function ViewCoverEval()
{
    bViewingConstraintEvals = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VTTransParms = {BlendTime = 1.0, BlendExp = 2.0, bSkipCameraReset = FALSE, BlendFunction = EViewTargetBlendFunction.VTBlend_Cubic}
    CurrentConstraintIndex = -1
    TitleColor = {B = 255, G = 248, R = 51, A = 255}
    DrawWhite = {B = 255, G = 255, R = 255, A = 255}
    DrawRed = {B = 0, G = 0, R = 255, A = 255}
    DrawOrange = {B = 51, G = 153, R = 255, A = 255}
    DrawGreen = {B = 0, G = 255, R = 0, A = 255}
    bUnPauseOnExit = TRUE
    bShowLegend = TRUE
    Bindings = ({
                 Command = "ZoomCamera", 
                 Name = 'Up', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UnzoomCamera", 
                 Name = 'Down', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "NextPawn", 
                 Name = 'Right', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PrevPawn", 
                 Name = 'Left', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ToggleAIPause", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 0", 
                 Name = 'Zero', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 1", 
                 Name = 'One', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 2", 
                 Name = 'Two', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 3", 
                 Name = 'Three', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 4", 
                 Name = 'Four', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 5", 
                 Name = 'Five', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 6", 
                 Name = 'Six', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 7", 
                 Name = 'Seven', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 8", 
                 Name = 'Eight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewConstraint 9", 
                 Name = 'Nine', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewCoverEval", 
                 Name = 'R', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_StrafeLeft", 
                 Name = 'A', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_StrafeRight", 
                 Name = 'D', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_MoveForward", 
                 Name = 'W', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_MoveBackward", 
                 Name = 'S', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bAllowMovement = TRUE
    bMergeNotifications = TRUE
    bAllowPowerWeaponUI = TRUE
    Priority = EGameModePriority2.ModePriority_CheatMenu
}