Class HUD extends Actor
    native
    transient
    config(Game);

struct native KismetDrawTextInfo 
{
    var(KismetDrawTextInfo) string MessageText;
    var(KismetDrawTextInfo) Vector2D MessageFontScale;
    var(KismetDrawTextInfo) Vector2D MessageOffset;
    var(KismetDrawTextInfo) Font MessageFont;
    var(KismetDrawTextInfo) Color MessageColor;
    var float MessageEndTime;
};
struct native HudLocalizedMessage 
{
    var string StringMessage;
    var Class<LocalMessage> Message;
    var int Switch;
    var float EndOfLife;
    var float Lifetime;
    var float PosY;
    var Color DrawColor;
    var int FontSize;
    var Font StringFont;
    var float dx;
    var float DY;
    var int Count;
    var Object OptionalObject;
    var bool Drawn;
};
struct native ConsoleMessage 
{
    var string Text;
    var Color TextColor;
    var float MessageLife;
    var PlayerReplicationInfo PRI;
};

var(HUD) transient HudLocalizedMessage LocalMessages[8];
var array<Actor> PostRenderedActors;
var array<ConsoleMessage> ConsoleMessages;
var globalconfig array<Name> DebugDisplay;
var array<KismetDrawTextInfo> KismetTextInfo;
var const Color WhiteColor;
var const Color GreenColor;
var const Color RedColor;
var PlayerController PlayerOwner;
var HUD HudOwner;
var PlayerReplicationInfo ViewedInfo;
var Scoreboard Scoreboard;
var globalconfig float HudCanvasScale;
var const Color ConsoleColor;
var globalconfig int ConsoleMessageCount;
var globalconfig int ConsoleFontSize;
var globalconfig int MessageFontOffset;
var int MaxHUDAreaMessageCount;
var(HUD) float ConsoleMessagePosX;
var(HUD) float ConsoleMessagePosY;
var Canvas Canvas;
var transient float LastHUDRenderTime;
var transient float RenderDelta;
var transient float SizeX;
var transient float SizeY;
var transient float CenterX;
var transient float CenterY;
var transient float RatioX;
var transient float RatioY;
var transient bool LostFocusPaused;
var config bool bShowHUD;
var config bool bShowGameHUD;
var bool bShowScores;
var bool bShowDebugInfo;
var bool bShowGameDebug;
var(HUD) bool bShowBadConnectionAlert;
var globalconfig bool bMessageBeep;
var bool bShowOverlays;

public event function Destroyed()
{
    if (Scoreboard != None)
    {
        Scoreboard.Destroy();
        Scoreboard = None;
    }
    Super.Destroyed();
}
public final native function Draw2DLine(int X1, int Y1, int X2, int Y2, Color LineColor);

public final native function Draw3DLine(Vector Start, Vector End, Color LineColor);

public native function DrawActorOverlays(Vector Viewpoint, Rotator ViewRotation);

public function Message(PlayerReplicationInfo PRI, coerce string Msg, Name msgType, optional float Lifetime)
{
    if (bMessageBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (msgType == 'Say' || msgType == 'TeamSay')
    {
        Msg = PRI.PlayerName $ ": " $ Msg;
    }
    AddConsoleMessage(Msg, Class'LocalMessage', PRI, Lifetime);
}
public event function OnLostFocusPause(bool enable)
{
    if (LostFocusPaused == enable)
    {
        return;
    }
    if (WorldInfo.NetMode != ENetMode.NM_Client)
    {
        LostFocusPaused = enable;
        PlayerOwner.SetPause(enable);
    }
}
public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    PlayerOwner = PlayerController(Owner);
}
public event function PostRender()
{
    local float XL;
    local float YL;
    local float YPos;
    
    RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
    if (SizeX != float(Canvas.SizeX) || SizeY != float(Canvas.SizeY))
    {
        PreCalcValues();
    }
    if (PlayerOwner != None)
    {
        if (PlayerOwner.ViewTarget != None)
        {
            if (Pawn(PlayerOwner.ViewTarget) != None)
            {
                ViewedInfo = Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo;
            }
            else
            {
                ViewedInfo = PlayerOwner.PlayerReplicationInfo;
            }
        }
        else if (PlayerOwner.Pawn != None)
        {
            ViewedInfo = PlayerOwner.Pawn.PlayerReplicationInfo;
        }
        else
        {
            ViewedInfo = PlayerOwner.PlayerReplicationInfo;
        }
        PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);
    }
    if (bShowGameDebug)
    {
        Canvas.Font = Class'Engine'.static.GetTinyFont();
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0.0;
        WorldInfo.Game.DisplayDebug(Self, YL, YPos);
    }
    else if (bShowDebugInfo)
    {
        Canvas.Font = Class'Engine'.static.GetTinyFont();
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0.0;
        PlayerOwner.ViewTarget.DisplayDebug(Self, YL, YPos);
        if (ShouldDisplayDebug('AI') && Pawn(PlayerOwner.ViewTarget) != None)
        {
            DrawRoute(Pawn(PlayerOwner.ViewTarget));
        }
    }
    else if (bShowHUD)
    {
        if (bShowScores)
        {
            if (Scoreboard != None)
            {
                Scoreboard.Canvas = Canvas;
                Scoreboard.DrawHUD();
                if (Scoreboard.bDisplayMessages)
                {
                    DisplayConsoleMessages();
                }
            }
        }
        else
        {
            DrawHUD();
            DisplayConsoleMessages();
            DisplayLocalMessages();
            DisplayKismetMessages();
        }
    }
    else
    {
        DrawDemoHUD();
    }
    if (bShowBadConnectionAlert)
    {
        DisplayBadConnectionAlert();
    }
    LastHUDRenderTime = WorldInfo.TimeSeconds;
}
public function AddConsoleMessage(string M, Class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    local int idx;
    local int MsgIdx;
    
    MsgIdx = -1;
    if (bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (ConsoleMessages.Length < ConsoleMessageCount)
    {
        MsgIdx = ConsoleMessages.Length;
    }
    else
    {
        for (idx = 0; idx < ConsoleMessages.Length && MsgIdx == -1; idx++)
        {
            if (ConsoleMessages[idx].Text == "")
            {
                MsgIdx = idx;
            }
        }
    }
    if (MsgIdx == ConsoleMessageCount || MsgIdx == -1)
    {
        for (idx = 0; idx < ConsoleMessageCount - 1; idx++)
        {
            ConsoleMessages[idx] = ConsoleMessages[idx + 1];
        }
        MsgIdx = ConsoleMessageCount - 1;
    }
    if (MsgIdx >= ConsoleMessages.Length)
    {
        ConsoleMessages.Length = MsgIdx + 1;
    }
    ConsoleMessages[MsgIdx].Text = M;
    if (Lifetime != 0.0)
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + Lifetime;
    }
    else
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + InMessageClass.default.Lifetime;
    }
    ConsoleMessages[MsgIdx].TextColor = InMessageClass.static.GetConsoleColor(PRI);
    ConsoleMessages[MsgIdx].PRI = PRI;
}
public function AddLocalizedMessage(int Index, Class<LocalMessage> InMessageClass, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional int MessageCount, optional Object OptionalObject)
{
    LocalMessages[Index].Message = InMessageClass;
    LocalMessages[Index].Switch = Switch;
    LocalMessages[Index].EndOfLife = Lifetime + WorldInfo.TimeSeconds;
    LocalMessages[Index].StringMessage = CriticalString;
    LocalMessages[Index].Lifetime = Lifetime;
    LocalMessages[Index].PosY = Position;
    LocalMessages[Index].DrawColor = DrawColor;
    LocalMessages[Index].FontSize = FontSize;
    LocalMessages[Index].Count = MessageCount;
    LocalMessages[Index].OptionalObject = OptionalObject;
}
public function AddPostRenderedActor(Actor A)
{
    local int i;
    
    for (i = 0; i < PostRenderedActors.Length; i++)
    {
        if (PostRenderedActors[i] == A)
        {
            return;
        }
    }
    for (i = 0; i < PostRenderedActors.Length; i++)
    {
        if (PostRenderedActors[i] == None)
        {
            PostRenderedActors[i] = A;
            return;
        }
    }
    PostRenderedActors[PostRenderedActors.Length] = A;
}
public function ClearMessage(out HudLocalizedMessage M)
{
    M.Message = None;
    M.StringFont = None;
}
public function DisplayBadConnectionAlert();

public function DisplayConsoleMessages()
{
    local int idx;
    local int XPos;
    local int YPos;
    local float XL;
    local float YL;
    
    if (ConsoleMessages.Length == 0)
    {
        return;
    }
    for (idx = 0; idx < ConsoleMessages.Length; idx++)
    {
        if (ConsoleMessages[idx].Text == "" || ConsoleMessages[idx].MessageLife < WorldInfo.TimeSeconds)
        {
            ConsoleMessages.Remove(idx--, 1);
        }
    }
    XPos = int(ConsoleMessagePosX * HudCanvasScale * float(Canvas.SizeX) + (1.0 - HudCanvasScale) / 2.0 * float(Canvas.SizeX));
    YPos = int(ConsoleMessagePosY * HudCanvasScale * float(Canvas.SizeY) + (1.0 - HudCanvasScale) / 2.0 * float(Canvas.SizeY));
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    Canvas.DrawColor = ConsoleColor;
    Canvas.TextSize("A", XL, YL);
    YPos -= int(YL * float(ConsoleMessages.Length));
    YPos -= int(YL);
    for (idx = 0; idx < ConsoleMessages.Length; idx++)
    {
        if (ConsoleMessages[idx].Text == "")
        {
            continue;
        }
        Canvas.StrLen(ConsoleMessages[idx].Text, XL, YL);
        Canvas.SetPos(float(XPos), float(YPos));
        Canvas.DrawColor = ConsoleMessages[idx].TextColor;
        Canvas.DrawText(ConsoleMessages[idx].Text, FALSE);
        YPos += int(YL);
    }
}
public function DisplayKismetMessages()
{
    local int KismetTextIdx;
    local float XL;
    local float YL;
    
    KismetTextIdx = 0;
    while (KismetTextIdx < KismetTextInfo.Length)
    {
        if (KismetTextInfo[KismetTextIdx].MessageEndTime > float(0) && KismetTextInfo[KismetTextIdx].MessageEndTime <= WorldInfo.TimeSeconds)
        {
            KismetTextInfo.Remove(KismetTextIdx, 1);
            continue;
        }
        Canvas.Font = KismetTextInfo[KismetTextIdx].MessageFont;
        Canvas.TextSize(KismetTextInfo[KismetTextIdx].MessageText, XL, YL);
        Canvas.SetPos(Canvas.ClipX / float(2) - XL / float(2) + KismetTextInfo[KismetTextIdx].MessageOffset.X, Canvas.ClipY / float(3) - YL / float(2) + KismetTextInfo[KismetTextIdx].MessageOffset.Y);
        Canvas.SetDrawColor(KismetTextInfo[KismetTextIdx].MessageColor.R, KismetTextInfo[KismetTextIdx].MessageColor.G, KismetTextInfo[KismetTextIdx].MessageColor.B, KismetTextInfo[KismetTextIdx].MessageColor.A);
        Canvas.DrawText(KismetTextInfo[KismetTextIdx].MessageText, FALSE, KismetTextInfo[KismetTextIdx].MessageFontScale.X, KismetTextInfo[KismetTextIdx].MessageFontScale.Y);
        ++KismetTextIdx;
    }
}
public function DisplayLocalMessages()
{
    local float PosY;
    local float DY;
    local float dx;
    local int i;
    local int J;
    local int LocalMessagesArrayCount;
    local int AreaMessageCount;
    local float FadeValue;
    local int FontSize;
    
    if (LocalMessages[0].Message == None)
    {
        return;
    }
    Canvas.Reset(TRUE);
    LocalMessagesArrayCount = 8;
    for (i = 0; i < LocalMessagesArrayCount; i++)
    {
        if (LocalMessages[i].Message == None)
        {
            break;
        }
        LocalMessages[i].Drawn = FALSE;
        if (LocalMessages[i].StringFont == None)
        {
            FontSize = LocalMessages[i].FontSize + MessageFontOffset;
            LocalMessages[i].StringFont = GetFontSizeIndex(FontSize);
            Canvas.Font = LocalMessages[i].StringFont;
            Canvas.TextSize(LocalMessages[i].StringMessage, dx, DY);
            LocalMessages[i].dx = dx;
            LocalMessages[i].DY = DY;
            if (LocalMessages[i].StringFont == None)
            {
                for (J = i; J < LocalMessagesArrayCount - 1; J++)
                {
                    LocalMessages[J] = LocalMessages[J + 1];
                }
                ClearMessage(LocalMessages[J]);
                i--;
                continue;
            }
        }
        FadeValue = LocalMessages[i].EndOfLife - WorldInfo.TimeSeconds;
        if (FadeValue <= 0.0)
        {
            for (J = i; J < LocalMessagesArrayCount - 1; J++)
            {
                LocalMessages[J] = LocalMessages[J + 1];
            }
            ClearMessage(LocalMessages[J]);
            i--;
            continue;
        }
    }
    for (i = 0; i < LocalMessagesArrayCount; i++)
    {
        if (LocalMessages[i].Message == None)
        {
            break;
        }
        if (LocalMessages[i].Drawn)
        {
            continue;
        }
        PosY = LocalMessages[i].PosY;
        AreaMessageCount = 0;
        for (J = i; J < LocalMessagesArrayCount; J++)
        {
            if (LocalMessages[J].Drawn || LocalMessages[i].PosY != LocalMessages[J].PosY)
            {
                continue;
            }
            DrawMessage(J, PosY, dx, DY);
            PosY += DY;
            AreaMessageCount++;
        }
        if (AreaMessageCount > MaxHUDAreaMessageCount)
        {
            LocalMessages[i].EndOfLife = WorldInfo.TimeSeconds;
        }
    }
}
public function DrawDemoHUD();

public function DrawEngineHUD()
{
    local float CrosshairSize;
    local float XL;
    local float YL;
    local float Y;
    local string myText;
    
    Canvas.SetDrawColor(255, 255, 255, 255);
    myText = "UnrealEngine3";
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    Canvas.StrLen(myText, XL, YL);
    Y = YL * 1.66999996;
    Canvas.SetPos(CenterX - XL / float(2), YL * 0.5);
    Canvas.DrawText(myText, TRUE);
    Canvas.SetDrawColor(200, 200, 200, 255);
    myText = "Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.";
    Canvas.Font = Class'Engine'.static.GetTinyFont();
    Canvas.StrLen(myText, XL, YL);
    Canvas.SetPos(CenterX - XL / float(2), Y);
    Canvas.DrawText(myText, TRUE);
    if (PlayerOwner != None && Pawn(PlayerOwner.ViewTarget) != None)
    {
        CrosshairSize = 4.0;
        Canvas.SetPos(CenterX - CrosshairSize, CenterY);
        Canvas.DrawRect(2.0 * CrosshairSize + float(1), 1.0);
        Canvas.SetPos(CenterX, CenterY - CrosshairSize);
        Canvas.DrawRect(1.0, 2.0 * CrosshairSize + float(1));
    }
}
public function DrawHUD()
{
    local Vector Viewpoint;
    local Rotator ViewRotation;
    
    if (bShowOverlays && PlayerOwner != None)
    {
        Canvas.Font = GetFontSizeIndex(0);
        PlayerOwner.GetPlayerViewPoint(Viewpoint, ViewRotation);
        DrawActorOverlays(Viewpoint, ViewRotation);
    }
    PlayerOwner.DrawHUD(Self);
}
public function DrawMessage(int i, float PosY, out float dx, out float DY)
{
    local float FadeValue;
    local float ScreenX;
    local float ScreenY;
    
    FadeValue = FMin(1.0, LocalMessages[i].EndOfLife - WorldInfo.TimeSeconds);
    Canvas.DrawColor = LocalMessages[i].DrawColor;
    Canvas.DrawColor.A = byte(FadeValue * float(Canvas.DrawColor.A));
    Canvas.Font = LocalMessages[i].StringFont;
    GetScreenCoords(PosY, ScreenX, ScreenY, LocalMessages[i]);
    dx = LocalMessages[i].dx / Canvas.ClipX;
    DY = LocalMessages[i].DY / Canvas.ClipY;
    DrawMessageText(LocalMessages[i], ScreenX, ScreenY);
    LocalMessages[i].Drawn = TRUE;
}
public function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
    local FontRenderInfo FontInfo;
    
    Canvas.SetPos(ScreenX, ScreenY);
    FontInfo.bClipText = TRUE;
    Canvas.DrawText(LocalMessage.StringMessage, FALSE, , , FontInfo);
}
public function DrawRoute(Pawn Target)
{
    local int i;
    local Controller C;
    local Vector Start;
    local Vector RealStart;
    local Vector Dest;
    local bool bPath;
    local Actor FirstRouteCache;
    
    C = Target.Controller;
    if (C == None)
    {
        return;
    }
    if (C.CurrentPath != None)
    {
        Start = C.CurrentPath.Start.location;
    }
    else
    {
        Start = Target.location;
    }
    RealStart = Start;
    if (C.bAdjusting)
    {
        Draw3DLine(C.Pawn.location, C.GetAdjustLocation(), MakeColor(255, 0, 255, 255));
        Start = C.GetAdjustLocation();
    }
    if (C.RouteCache.Length > 0)
    {
        FirstRouteCache = C.RouteCache[0];
    }
    Dest = C.GetDestinationPosition();
    if (C == PlayerOwner || C.MoveTarget == FirstRouteCache && C.MoveTarget != None)
    {
        if (C == PlayerOwner && Dest != vect(0.0, 0.0, 0.0))
        {
            if (C.PointReachable(Dest))
            {
                Draw3DLine(C.Pawn.location, Dest, MakeColor(255, 255, 255, 255));
                return;
            }
            C.FindPathTo(Dest, , );
        }
        if (C.RouteCache.Length > 0)
        {
            for (i = 0; i < C.RouteCache.Length; i++)
            {
                if (C.RouteCache[i] == None)
                {
                    break;
                }
                bPath = TRUE;
                Draw3DLine(Start, C.RouteCache[i].location, MakeColor(0, 255, 0, 255));
                Start = C.RouteCache[i].location;
            }
            if (bPath)
            {
                Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
            }
        }
    }
    else if (Target.Velocity != vect(0.0, 0.0, 0.0))
    {
        Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
    }
    if (C == PlayerOwner)
    {
        return;
    }
    Draw3DLine(Target.location + Target.BaseEyeHeight * vect(0.0, 0.0, 1.0), C.GetFocalPoint(), MakeColor(255, 0, 0, 255));
}
public exec function FXPlay(Class<Pawn> aClass, string FXAnimPath)
{
    local Pawn P;
    local Pawn ClosestPawn;
    local float ThisDistance;
    local float ClosestPawnDistance;
    local string FxAnimGroup;
    local string FxAnimName;
    local int dotPos;
    
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ClosestPawn = None;
        ClosestPawnDistance = 10000000.0;
        foreach DynamicActors(Class'Pawn', P, )
        {
            if (ClassIsChildOf(P.Class, aClass) && P != PlayerController(Owner).Pawn)
            {
                ThisDistance = VSize(P.location - PlayerController(Owner).Pawn.location);
                if (ThisDistance < ClosestPawnDistance)
                {
                    ClosestPawn = P;
                    ClosestPawnDistance = ThisDistance;
                }
            }
        }
        if (ClosestPawn.Mesh != None)
        {
            dotPos = InStr(FXAnimPath, ".", , , );
            if (dotPos != -1)
            {
                FxAnimGroup = Left(FXAnimPath, dotPos);
                FxAnimName = Right(FXAnimPath, Len(FXAnimPath) - dotPos - 1);
                ClosestPawn.Mesh.PlayFaceFXAnim(None, FxAnimName, FxAnimGroup, None);
            }
        }
    }
}
public exec function FXStop(Class<Pawn> aClass)
{
    local Pawn P;
    local Pawn ClosestPawn;
    local float ThisDistance;
    local float ClosestPawnDistance;
    
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        ClosestPawn = None;
        ClosestPawnDistance = 10000000.0;
        foreach DynamicActors(Class'Pawn', P, )
        {
            if (ClassIsChildOf(P.Class, aClass) && P != PlayerController(Owner).Pawn)
            {
                ThisDistance = VSize(P.location - PlayerController(Owner).Pawn.location);
                if (ThisDistance < ClosestPawnDistance)
                {
                    ClosestPawn = P;
                    ClosestPawnDistance = ThisDistance;
                }
            }
        }
        if (ClosestPawn.Mesh != None)
        {
            ClosestPawn.Mesh.StopFaceFXAnim();
        }
    }
}
public static function Font GetFontSizeIndex(int FontSize)
{
    if (FontSize == 0)
    {
        return Class'Engine'.static.GetTinyFont();
    }
    else if (FontSize == 1)
    {
        return Class'Engine'.static.GetSmallFont();
    }
    else if (FontSize == 2)
    {
        return Class'Engine'.static.GetMediumFont();
    }
    else if (FontSize == 3)
    {
        return Class'Engine'.static.GetLargeFont();
    }
    else
    {
        return Class'Engine'.static.GetLargeFont();
    }
}
public static function Color GetRYGColorRamp(float Pct)
{
    local Color GYRColor;
    
    GYRColor.A = 255;
    if (Pct < 0.340000004)
    {
        GYRColor.R = byte(float(128) + float(127) * FClamp(3.0 * Pct, 0.0, 1.0));
        GYRColor.G = 0;
        GYRColor.B = 0;
    }
    else if (Pct < 0.670000017)
    {
        GYRColor.R = 255;
        GYRColor.G = byte(float(255) * FClamp(3.0 * (Pct - 0.330000013), 0.0, 1.0));
        GYRColor.B = 0;
    }
    else
    {
        GYRColor.R = byte(float(255) * FClamp(3.0 * (1.0 - Pct), 0.0, 1.0));
        GYRColor.G = 255;
        GYRColor.B = 0;
    }
    return GYRColor;
}
public function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
    ScreenX = 0.5 * Canvas.ClipX;
    ScreenY = PosY * HudCanvasScale * Canvas.ClipY + (1.0 - HudCanvasScale) * 0.5 * Canvas.ClipY;
    ScreenX -= InMessage.dx * 0.5;
    ScreenY -= InMessage.DY * 0.5;
}
public function LocalizedMessage(Class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
    local int i;
    local int LocalMessagesArrayCount;
    local int MessageCount;
    
    if (InMessageClass == None || CriticalString == "")
    {
        return;
    }
    if (bMessageBeep && InMessageClass.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (!InMessageClass.default.bIsSpecial)
    {
        AddConsoleMessage(CriticalString, InMessageClass, RelatedPRI_1);
        return;
    }
    LocalMessagesArrayCount = 8;
    i = LocalMessagesArrayCount;
    if (InMessageClass.default.bIsUnique)
    {
        for (i = 0; i < LocalMessagesArrayCount; i++)
        {
            if (LocalMessages[i].Message == InMessageClass)
            {
                if (InMessageClass.default.bCountInstances && LocalMessages[i].StringMessage ~= CriticalString)
                {
                    MessageCount = LocalMessages[i].Count == 0 ? 2 : LocalMessages[i].Count + 1;
                }
                break;
            }
        }
    }
    else if (InMessageClass.default.bIsPartiallyUnique)
    {
        for (i = 0; i < LocalMessagesArrayCount; i++)
        {
            if (LocalMessages[i].Message == InMessageClass && InMessageClass.static.PartiallyDuplicates(Switch, LocalMessages[i].Switch, OptionalObject, LocalMessages[i].OptionalObject))
            {
                break;
            }
        }
    }
    if (i == LocalMessagesArrayCount)
    {
        for (i = 0; i < LocalMessagesArrayCount; i++)
        {
            if (LocalMessages[i].Message == None)
            {
                break;
            }
        }
    }
    if (i == LocalMessagesArrayCount)
    {
        for (i = 0; i < LocalMessagesArrayCount - 1; i++)
        {
            LocalMessages[i] = LocalMessages[i + 1];
        }
    }
    ClearMessage(LocalMessages[i]);
    AddLocalizedMessage(i, InMessageClass, CriticalString, Switch, Position, Lifetime, FontSize, DrawColor, MessageCount, OptionalObject);
}
public function PlayerOwnerDied();

public function PreCalcValues()
{
    SizeX = float(Canvas.SizeX);
    SizeY = float(Canvas.SizeY);
    CenterX = SizeX * 0.5;
    CenterY = SizeY * 0.5;
    RatioX = SizeX / 1024.0;
    RatioY = SizeY / 768.0;
}
public function RemovePostRenderedActor(Actor A)
{
    local int i;
    
    for (i = 0; i < PostRenderedActors.Length; i++)
    {
        if (PostRenderedActors[i] == A)
        {
            PostRenderedActors[i] = None;
            return;
        }
    }
}
public exec function SetShowScores(bool bNewValue)
{
    bShowScores = bNewValue;
    if (Scoreboard != None)
    {
        Scoreboard.ChangeState(bShowScores);
    }
}
public function bool ShouldDisplayDebug(Name DebugType)
{
    local int i;
    
    for (i = 0; i < DebugDisplay.Length; i++)
    {
        if (DebugDisplay[i] == DebugType)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public exec function ShowDebug(optional Name DebugType)
{
    local int i;
    local bool bFound;
    
    if (DebugType == 'None')
    {
        bShowDebugInfo = !bShowDebugInfo;
    }
    else
    {
        bShowDebugInfo = TRUE;
        for (i = 0; i < DebugDisplay.Length && !bFound; i++)
        {
            if (DebugDisplay[i] == DebugType)
            {
                DebugDisplay.Remove(i, 1);
                bFound = TRUE;
            }
        }
        if (!bFound)
        {
            DebugDisplay[DebugDisplay.Length] = DebugType;
        }
        SaveConfig();
    }
}
public exec function ShowGameDebug()
{
    bShowGameDebug = !bShowGameDebug;
}
public exec function ShowHUD()
{
    ToggleHUD();
}
public exec function ShowScores()
{
    SetShowScores(!bShowScores);
}
public function SpawnScoreBoard(Class<Scoreboard> ScoringType)
{
    if (ScoringType != None)
    {
        Scoreboard = Spawn(ScoringType, PlayerOwner);
    }
    if (Scoreboard != None)
    {
        Scoreboard.HudOwner = Self;
    }
}
public exec function ToggleHUD()
{
    bShowHUD = !bShowHUD;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DebugDisplay = ('AI')
    WhiteColor = {B = 255, G = 255, R = 255, A = 255}
    GreenColor = {B = 0, G = 255, R = 0, A = 255}
    RedColor = {B = 0, G = 0, R = 255, A = 255}
    HudCanvasScale = 0.949999988
    ConsoleColor = {B = 253, G = 216, R = 153, A = 255}
    ConsoleMessageCount = 4
    ConsoleFontSize = 5
    MaxHUDAreaMessageCount = 3
    ConsoleMessagePosY = 0.800000012
    bShowHUD = TRUE
    bShowGameHUD = TRUE
    bMessageBeep = TRUE
    bHidden = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}