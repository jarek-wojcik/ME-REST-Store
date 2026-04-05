Class GameViewportClient within Engine
    native
    transient;

struct native DebugDisplayProperty 
{
    var Name PropertyName;
    var Object Obj;
    var bool bSpecialProperty;
};
struct native SplitscreenData 
{
    var array<PerPlayerSplitscreenData> PlayerData;
};
struct native PerPlayerSplitscreenData 
{
    var float SizeX;
    var float SizeY;
    var float OriginX;
    var float OriginY;
};
enum ESafeZoneType
{
    eSZ_TOP,
    eSZ_BOTTOM,
    eSZ_LEFT,
    eSZ_RIGHT,
};
enum ESplitScreenType
{
    eSST_NONE,
    eSST_2P_HORIZONTAL,
    eSST_2P_VERTICAL,
    eSST_3P_FAVOR_TOP,
    eSST_3P_FAVOR_BOTTOM,
    eSST_4P,
};
struct native TitleSafeZoneArea 
{
    var float MaxPercentX;
    var float MaxPercentY;
    var float RecommendedPercentX;
    var float RecommendedPercentY;
};

var const native noexport Pointer VfTable_FViewportClient;
var const native noexport Pointer VfTable_FExec;
var const native noexport Pointer VfTable_FCallbackEventDevice;
var string ProgressMessage[2];
var init array<Interaction> GlobalInteractions;
var const localized string LoadingMessage;
var const localized string SavingMessage;
var const localized string ConnectingMessage;
var const localized string PausedMessage;
var const localized string PrecachingMessage;
var array<SplitscreenData> SplitscreenInfo;
var array<DebugDisplayProperty> DebugProperties;
var delegate<HandleInputKey> __HandleInputKey__Delegate;
var delegate<HandleInputAxis> __HandleInputAxis__Delegate;
var delegate<HandleInputChar> __HandleInputChar__Delegate;
var const Pointer Viewport;
var const Pointer ViewportFrame;
var Class<UIInteraction> UIControllerClass;
var const native Pointer pShowFlags;
var TitleSafeZoneArea TitleSafeZone;
var UIInteraction UIController;
var Console ViewportConsole;
var float ProgressTimeOut;
var float ProgressFadeTime;
var bool bShowTitleSafeZone;
var transient bool bDisplayingUIMouseCursor;
var transient bool bUIMouseCaptureOverride;
var bool bDisableWorldRendering;
var ESplitScreenType DesiredSplitscreenType;
var ESplitScreenType ActiveSplitscreenType;
var const ESplitScreenType Default2PSplitType;
var const ESplitScreenType Default3PSplitType;
var byte CurrentMouseCursor;

public native function string ConsoleCommand(string Command);

public event function LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
    local LocalPlayer NewPlayer;
    local int InsertIndex;
    
    assert(Outer.LocalPlayerClass != None);
    NewPlayer = new (Outer) Outer.LocalPlayerClass;
    NewPlayer.ViewportClient = Self;
    NewPlayer.ControllerId = ControllerId;
    InsertIndex = AddLocalPlayer(NewPlayer);
    if (bSpawnActor && InsertIndex != -1)
    {
        if (Outer.GetCurrentWorldInfo().NetMode != ENetMode.NM_Client)
        {
            if (!NewPlayer.SpawnPlayActor("", OutError))
            {
                RemoveLocalPlayer(NewPlayer);
                NewPlayer = None;
            }
        }
        else
        {
            NewPlayer.SendSplitJoin();
        }
    }
    if (OutError != "")
    {
    }
    else if (NewPlayer != None && InsertIndex != -1)
    {
        NotifyPlayerAdded(InsertIndex, NewPlayer);
    }
    return NewPlayer;
}
public final event function LocalPlayer FindPlayerByControllerId(int ControllerId)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < Outer.GamePlayers.Length; PlayerIndex++)
    {
        if (Outer.GamePlayers[PlayerIndex].ControllerId == ControllerId)
        {
            return Outer.GamePlayers[PlayerIndex];
        }
    }
    return None;
}
public event function GameSessionEnded()
{
    local int i;
    
    for (i = 0; i < GlobalInteractions.Length; i++)
    {
        GlobalInteractions[i].NotifyGameSessionEnded();
    }
}
public event function GetSubtitleRegion(out Vector2D MinPos, out Vector2D MaxPos)
{
    MaxPos.X = 1.0;
    MaxPos.Y = Outer.GamePlayers.Length == 1 ? 0.899999976 : 0.5;
}
public final native function GetViewportSize(out Vector2D out_ViewportSize);

public delegate function bool HandleInputAxis(int ControllerId, Name Key, float Delta, float DeltaTime, bool bGamepad);

public delegate function bool HandleInputChar(int ControllerId, string Unicode);

public delegate function bool HandleInputKey(int ControllerId, Name Key, EInputEvent EventType, float AmountDepressed, optional bool bGamepad);

public event function bool Init(out string OutError)
{
    local PlayerManagerInteraction PlayerInteraction;
    
    assert(Outer.ConsoleClass != None);
    ActiveSplitscreenType = DesiredSplitscreenType;
    ViewportConsole = new (Self) Outer.ConsoleClass;
    if (InsertInteraction(ViewportConsole) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ ViewportConsole;
        return FALSE;
    }
    assert(UIControllerClass != None);
    UIController = new (Self) UIControllerClass;
    if (InsertInteraction(UIController) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ UIController;
        return FALSE;
    }
    PlayerInteraction = new (Self) Class'PlayerManagerInteraction';
    if (InsertInteraction(PlayerInteraction) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ PlayerInteraction;
        return FALSE;
    }
    return CreateInitialPlayer(OutError);
}
public event function int InsertInteraction(Interaction NewInteraction, optional int InIndex = -1)
{
    local int Result;
    
    Result = -1;
    if (NewInteraction != None)
    {
        if (InIndex == -1)
        {
            InIndex = GlobalInteractions.Length;
        }
        if (InIndex >= 0)
        {
            Result = Clamp(InIndex, 0, GlobalInteractions.Length);
            GlobalInteractions.Insert(Result, 1);
            GlobalInteractions[Result] = NewInteraction;
            NewInteraction.Init();
            NewInteraction.__OnInitialize__Delegate();
        }
    }
    return Result;
}
public final native function bool IsFullScreenViewport();

public event function LayoutPlayers()
{
    local int idx;
    local ESplitScreenType SplitType;
    
    UpdateActiveSplitscreenType();
    SplitType = GetSplitscreenConfiguration();
    for (idx = 0; idx < Outer.GamePlayers.Length; idx++)
    {
        if (int(SplitType) < SplitscreenInfo.Length && idx < SplitscreenInfo[int(SplitType)].PlayerData.Length)
        {
            Outer.GamePlayers[idx].Size.X = SplitscreenInfo[int(SplitType)].PlayerData[idx].SizeX;
            Outer.GamePlayers[idx].Size.Y = SplitscreenInfo[int(SplitType)].PlayerData[idx].SizeY;
            Outer.GamePlayers[idx].Origin.X = SplitscreenInfo[int(SplitType)].PlayerData[idx].OriginX;
            Outer.GamePlayers[idx].Origin.Y = SplitscreenInfo[int(SplitType)].PlayerData[idx].OriginY;
            continue;
        }
        Outer.GamePlayers[idx].Size.X = 0.0;
        Outer.GamePlayers[idx].Size.Y = 0.0;
        Outer.GamePlayers[idx].Origin.X = 0.0;
        Outer.GamePlayers[idx].Origin.Y = 0.0;
    }
}
public event function PostRender(Canvas Canvas)
{
    if (bShowTitleSafeZone)
    {
        DrawTitleSafeArea(Canvas);
    }
    ViewportConsole.PostRender_Console(Canvas);
    DrawTransition(Canvas);
    if (ProgressTimeOut > Class'Engine'.static.GetCurrentWorldInfo().TimeSeconds)
    {
        DisplayProgressMessage(Canvas);
    }
}
public event function bool RemovePlayer(LocalPlayer ExPlayer)
{
    local int OldIndex;
    
    if (ExPlayer.Actor.Role == ENetRole.ROLE_Authority)
    {
        ExPlayer.ViewportClient = None;
        if (ExPlayer.Actor != None)
        {
            ExPlayer.Actor.Destroy();
        }
        OldIndex = RemoveLocalPlayer(ExPlayer);
        if (OldIndex != -1)
        {
            NotifyPlayerRemoved(OldIndex, ExPlayer);
        }
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public event function SetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    if (MessageType == EProgressMessageType.PMT_Clear)
    {
        ClearProgressMessages();
    }
    else if (MessageType == EProgressMessageType.PMT_ConnectionFailure)
    {
        NotifyConnectionError(Message, Title);
    }
    else if (MessageType != EProgressMessageType.PMT_SocketFailure)
    {
        if (Title != "")
        {
            ProgressMessage[0] = Title;
            ProgressMessage[1] = Message;
        }
        else
        {
            ProgressMessage[1] = "";
            ProgressMessage[0] = Message;
        }
    }
    else if (MessageType == EProgressMessageType.PMT_SocketFailure)
    {
        if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
        {
            NotifyConnectionError(Message, Title);
        }
    }
    if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
    {
        Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages = bIgnoreFutureNetworkMessages;
    }
}
public event exec function SetProgressTime(float T)
{
    ProgressTimeOut = T + Class'Engine'.static.GetCurrentWorldInfo().TimeSeconds;
}
public final native function bool ShouldForceFullscreenViewport();

public event function Tick(float DeltaTime);

public final function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local int InteractionIndex;
    
    LayoutPlayers();
    for (InteractionIndex = 0; InteractionIndex < GlobalInteractions.Length; InteractionIndex++)
    {
        if (GlobalInteractions[InteractionIndex] != None)
        {
            GlobalInteractions[InteractionIndex].NotifyPlayerAdded(PlayerIndex, AddedPlayer);
        }
    }
}
public final function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int InteractionIndex;
    
    LayoutPlayers();
    for (InteractionIndex = GlobalInteractions.Length - 1; InteractionIndex >= 0; InteractionIndex--)
    {
        if (GlobalInteractions[InteractionIndex] != None)
        {
            GlobalInteractions[InteractionIndex].NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
        }
    }
}
private final function int AddLocalPlayer(LocalPlayer NewPlayer)
{
    local int InsertIndex;
    
    InsertIndex = -1;
    if (NewPlayer != None)
    {
        InsertIndex = Outer.GamePlayers.Length;
        Outer.GamePlayers[InsertIndex] = NewPlayer;
    }
    return InsertIndex;
}
public final function float CalculateDeadZone(LocalPlayer LPlayer, ESafeZoneType SZType, Canvas Canvas, optional bool bUseMaxPercent)
{
    local bool bHasSafeZone;
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue;
    local float VertSafeZoneValue;
    
    if (LPlayer != None)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            switch (SZType)
            {
                case ESafeZoneType.eSZ_TOP:
                    bHasSafeZone = HasTopSafeZone(LocalPlayerIndex);
                    break;
                case ESafeZoneType.eSZ_BOTTOM:
                    bHasSafeZone = HasBottomSafeZone(LocalPlayerIndex);
                    break;
                case ESafeZoneType.eSZ_LEFT:
                    bHasSafeZone = HasLeftSafeZone(LocalPlayerIndex);
                    break;
                case ESafeZoneType.eSZ_RIGHT:
                    bHasSafeZone = HasRightSafeZone(LocalPlayerIndex);
                    break;
                default:
            }
            if (bHasSafeZone)
            {
                CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
                if (SZType == ESafeZoneType.eSZ_TOP || SZType == ESafeZoneType.eSZ_BOTTOM)
                {
                    return VertSafeZoneValue;
                }
                else
                {
                    return HorizSafeZoneValue;
                }
            }
        }
    }
    return 0.0;
}
public final function bool CalculateDeadZoneForAllSides(LocalPlayer LPlayer, Canvas Canvas, out float fTopSafeZone, out float fBottomSafeZone, out float fLeftSafeZone, out float fRightSafeZone, optional bool bUseMaxPercent)
{
    local bool bHasTopSafeZone;
    local bool bHasBottomSafeZone;
    local bool bHasRightSafeZone;
    local bool bHasLeftSafeZone;
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue;
    local float VertSafeZoneValue;
    
    if (LPlayer != None)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            bHasTopSafeZone = HasTopSafeZone(LocalPlayerIndex);
            bHasBottomSafeZone = HasBottomSafeZone(LocalPlayerIndex);
            bHasLeftSafeZone = HasLeftSafeZone(LocalPlayerIndex);
            bHasRightSafeZone = HasRightSafeZone(LocalPlayerIndex);
            if (bHasTopSafeZone || bHasBottomSafeZone || bHasLeftSafeZone || bHasRightSafeZone)
            {
                CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
                if (bHasTopSafeZone)
                {
                    fTopSafeZone = VertSafeZoneValue;
                }
                else
                {
                    fTopSafeZone = 0.0;
                }
                if (bHasBottomSafeZone)
                {
                    fBottomSafeZone = VertSafeZoneValue;
                }
                else
                {
                    fBottomSafeZone = 0.0;
                }
                if (bHasLeftSafeZone)
                {
                    fLeftSafeZone = HorizSafeZoneValue;
                }
                else
                {
                    fLeftSafeZone = 0.0;
                }
                if (bHasRightSafeZone)
                {
                    fRightSafeZone = HorizSafeZoneValue;
                }
                else
                {
                    fRightSafeZone = 0.0;
                }
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final function CalculatePixelCenter(out float out_CenterX, out float out_CenterY, LocalPlayer LPlayer, Canvas Canvas, optional bool bUseMaxPercent)
{
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue;
    local float VertSafeZoneValue;
    
    out_CenterX = Canvas.ClipX / 2.0;
    out_CenterY = Canvas.ClipY / 2.0;
    if (LPlayer != None)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
            switch (GetSplitscreenConfiguration())
            {
                case 0:
                    return;
                case 1:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    return;
                case 2:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterX += HorizSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterX -= HorizSafeZoneValue / float(2);
                    }
                    return;
                case 3:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                        if (LocalPlayerIndex == 1)
                        {
                            out_CenterX += HorizSafeZoneValue / float(2);
                        }
                        else
                        {
                            out_CenterX -= HorizSafeZoneValue / float(2);
                        }
                    }
                    return;
                case 4:
                    if (LocalPlayerIndex == 2)
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                        if (LocalPlayerIndex == 0)
                        {
                            out_CenterX += HorizSafeZoneValue / float(2);
                        }
                        else
                        {
                            out_CenterX -= HorizSafeZoneValue / float(2);
                        }
                    }
                    return;
                case 5:
                    if (LocalPlayerIndex < 2)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    if (LocalPlayerIndex == 0 || LocalPlayerIndex == 2)
                    {
                        out_CenterX += HorizSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterX -= HorizSafeZoneValue / float(2);
                    }
                    return;
                default:
            }
        }
    }
}
public final function CalculateSafeZoneValues(out float out_Horizontal, out float out_Vertical, Canvas Canvas, int LocalPlayerIndex, bool bUseMaxPercent)
{
    local float ScreenWidth;
    local float ScreenHeight;
    local float XSafeZoneToUse;
    local float YSafeZoneToUse;
    
    XSafeZoneToUse = bUseMaxPercent ? TitleSafeZone.MaxPercentX : TitleSafeZone.RecommendedPercentX;
    YSafeZoneToUse = bUseMaxPercent ? TitleSafeZone.MaxPercentY : TitleSafeZone.RecommendedPercentY;
    GetPixelSizeOfScreen(ScreenWidth, ScreenHeight, Canvas, LocalPlayerIndex);
    out_Horizontal = ScreenWidth * (float(1) - XSafeZoneToUse) / 2.0;
    out_Vertical = ScreenHeight * (float(1) - YSafeZoneToUse) / 2.0;
}
public exec function ClearProgressMessages()
{
    local int i;
    
    for (i = 0; i < 2; i++)
    {
        ProgressMessage[i] = "";
    }
}
public final function int ConvertLocalPlayerToGamePlayerIndex(LocalPlayer LPlayer)
{
    return Outer.GamePlayers.Find(LPlayer);
}
public function bool CreateInitialPlayer(out string OutError)
{
    local int ControllerId;
    local bool bFoundInitialGamepad;
    local bool bResult;
    
    for (ControllerId = 0; ControllerId < 4; ControllerId++)
    {
        if (UIController.IsLoggedIn(ControllerId))
        {
            bFoundInitialGamepad = TRUE;
            bResult = CreatePlayer(ControllerId, OutError, FALSE) != None;
            break;
        }
    }
    if (!bFoundInitialGamepad || !bResult)
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            if (UIController.IsGamepadConnected(ControllerId))
            {
                bFoundInitialGamepad = TRUE;
                bResult = CreatePlayer(ControllerId, OutError, FALSE) != None;
                break;
            }
        }
    }
    if (!bFoundInitialGamepad || !bResult)
    {
        bResult = CreatePlayer(0, OutError, FALSE) != None;
    }
    return bResult;
}
public exec function DebugCreatePlayer(int ControllerId);

public exec function DebugRemovePlayer(int ControllerId);

public function DisplayProgressMessage(Canvas Canvas)
{
    local int i;
    local int LineCount;
    local float FontDX;
    local float FontDY;
    local float X;
    local float Y;
    local byte Alpha;
    local float TimeLeft;
    
    TimeLeft = ProgressTimeOut - Class'Engine'.static.GetCurrentWorldInfo().TimeSeconds;
    Alpha = TimeLeft >= ProgressFadeTime ? 255 : byte(float(255) * TimeLeft / ProgressFadeTime);
    LineCount = 0;
    for (i = 0; i < 2; i++)
    {
        if (ProgressMessage[i] != "")
        {
            LineCount++;
        }
    }
    Canvas.Font = Class'Engine'.static.GetMediumFont();
    Canvas.TextSize("A", FontDX, FontDY);
    X = 0.5 * float(Canvas.SizeX);
    Y = 0.5 * float(Canvas.SizeY);
    Y -= FontDY * (float(LineCount) / 2.0);
    Canvas.DrawColor.R = 255;
    Canvas.DrawColor.G = 255;
    Canvas.DrawColor.B = 255;
    for (i = 0; i < 2; i++)
    {
        if (ProgressMessage[i] != "")
        {
            Canvas.DrawColor.A = Alpha;
            Canvas.TextSize(ProgressMessage[i], FontDX, FontDY);
            Canvas.SetPos(X - FontDX / 2.0, Y);
            Canvas.DrawText(ProgressMessage[i]);
            Y += FontDY;
        }
    }
}
public function DrawTitleSafeArea(Canvas Canvas)
{
    Canvas.SetDrawColor(255, 0, 0, 255);
    Canvas.SetPos(Canvas.ClipX * (float(1) - TitleSafeZone.MaxPercentX) / 2.0, Canvas.ClipY * (float(1) - TitleSafeZone.MaxPercentY) / 2.0);
    Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.MaxPercentX, Canvas.ClipY * TitleSafeZone.MaxPercentY);
    Canvas.SetDrawColor(255, 255, 0, 255);
    Canvas.SetPos(Canvas.ClipX * (float(1) - TitleSafeZone.RecommendedPercentX) / 2.0, Canvas.ClipY * (float(1) - TitleSafeZone.RecommendedPercentY) / 2.0);
    Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.RecommendedPercentX, Canvas.ClipY * TitleSafeZone.RecommendedPercentY);
}
public function DrawTransition(Canvas Canvas)
{
    switch (Outer.TransitionType)
    {
        case ETransitionType.TT_Loading:
            break;
        case ETransitionType.TT_Saving:
            DrawTransitionMessage(Canvas, SavingMessage);
            break;
        case ETransitionType.TT_Connecting:
            DrawTransitionMessage(Canvas, ConnectingMessage);
            break;
        case ETransitionType.TT_Precaching:
            DrawTransitionMessage(Canvas, PrecachingMessage);
            break;
        case ETransitionType.TT_Paused:
            break;
        default:
    }
}
public function DrawTransitionMessage(Canvas Canvas, string Message)
{
    local float XL;
    local float YL;
    
    Canvas.Font = Class'Engine'.static.GetLargeFont();
    Canvas.bCenter = FALSE;
    Canvas.StrLen(Message, XL, YL);
    Canvas.SetPos(0.5 * (Canvas.ClipX - XL) + float(1), 0.660000026 * Canvas.ClipY - YL * 0.5 + float(1));
    Canvas.SetDrawColor(0, 0, 0);
    Canvas.DrawText(Message, FALSE);
    Canvas.SetPos(0.5 * (Canvas.ClipX - XL), 0.660000026 * Canvas.ClipY - YL * 0.5);
    Canvas.SetDrawColor(0, 0, 255);
    Canvas.DrawText(Message, FALSE);
}
public final function GetPixelSizeOfScreen(out float out_Width, out float out_Height, Canvas Canvas, int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
            out_Width = Canvas.ClipX;
            out_Height = Canvas.ClipY;
            return;
        case 1:
            out_Width = Canvas.ClipX;
            out_Height = Canvas.ClipY * float(2);
            return;
        case 2:
            out_Width = Canvas.ClipX * float(2);
            out_Height = Canvas.ClipY;
            return;
        case 3:
            if (LocalPlayerIndex == 0)
            {
                out_Width = Canvas.ClipX;
            }
            else
            {
                out_Width = Canvas.ClipX * float(2);
            }
            out_Height = Canvas.ClipY * float(2);
            return;
        case 4:
            if (LocalPlayerIndex == 2)
            {
                out_Width = Canvas.ClipX;
            }
            else
            {
                out_Width = Canvas.ClipX * float(2);
            }
            out_Height = Canvas.ClipY * float(2);
            return;
        case 5:
            out_Width = Canvas.ClipX * float(2);
            out_Height = Canvas.ClipY * float(2);
            return;
        default:
    }
}
public function ESplitScreenType GetSplitscreenConfiguration()
{
    return ActiveSplitscreenType;
}
public final function bool HasBottomSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 2:
            return TRUE;
        case 1:
        case 3:
            return LocalPlayerIndex == 0 ? FALSE : TRUE;
        case 4:
        case 5:
            return LocalPlayerIndex > 1 ? TRUE : FALSE;
        default:
    }
    return FALSE;
}
public final function bool HasLeftSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 1:
            return TRUE;
        case 2:
            return LocalPlayerIndex == 0 ? TRUE : FALSE;
        case 3:
            return LocalPlayerIndex < 2 ? TRUE : FALSE;
        case 4:
        case 5:
            return LocalPlayerIndex == 0 || LocalPlayerIndex == 2 ? TRUE : FALSE;
        default:
    }
    return FALSE;
}
public final function bool HasRightSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 1:
            return TRUE;
        case 2:
        case 4:
            return LocalPlayerIndex > 0 ? TRUE : FALSE;
        case 3:
            return LocalPlayerIndex == 1 ? FALSE : TRUE;
        case 5:
            return LocalPlayerIndex == 0 || LocalPlayerIndex == 2 ? FALSE : TRUE;
        default:
    }
    return FALSE;
}
public final function bool HasTopSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 2:
            return TRUE;
        case 1:
        case 3:
            return LocalPlayerIndex == 0 ? TRUE : FALSE;
        case 4:
        case 5:
            return LocalPlayerIndex < 2 ? TRUE : FALSE;
        default:
    }
    return FALSE;
}
public function NotifyConnectionError(optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
    local WorldInfo WI;
    
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    if (WI.NetMode != ENetMode.NM_Standalone)
    {
        if (WI.Game != None)
        {
            WI.Game.bHasNetworkError = TRUE;
        }
        ConsoleCommand("start ?failed");
    }
}
private final function int RemoveLocalPlayer(LocalPlayer ExistingPlayer)
{
    local int Index;
    
    Index = Outer.GamePlayers.Find(ExistingPlayer);
    if (Index != -1)
    {
        Outer.GamePlayers.Remove(Index, 1);
    }
    return Index;
}
public exec function SetConsoleTarget(int PlayerIndex);

public exec function SetSplit(int mode);

public function SetSplitscreenConfiguration(ESplitScreenType SplitType)
{
    DesiredSplitscreenType = SplitType;
}
public exec function ShowTitleSafeArea();

public exec function SSSwapControllers();

public function UpdateActiveSplitscreenType()
{
    local ESplitScreenType SplitType;
    
    SplitType = DesiredSplitscreenType;
    switch (Outer.GamePlayers.Length)
    {
        case 0:
        case 1:
            SplitType = ESplitScreenType.eSST_NONE;
            break;
        case 2:
            if (SplitType != ESplitScreenType.eSST_2P_HORIZONTAL && SplitType != ESplitScreenType.eSST_2P_VERTICAL)
            {
                SplitType = Default2PSplitType;
            }
            break;
        case 3:
            if (SplitType != ESplitScreenType.eSST_3P_FAVOR_TOP && SplitType != ESplitScreenType.eSST_3P_FAVOR_BOTTOM)
            {
                SplitType = Default3PSplitType;
            }
            break;
        default:
            SplitType = ESplitScreenType.eSST_4P;
            break;
    }
    ActiveSplitscreenType = SplitType;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoadingMessage = "LOADING"
    SavingMessage = "SAVING"
    ConnectingMessage = "CONNECTING"
    PausedMessage = "PAUSED"
    PrecachingMessage = "PRECACHING"
    SplitscreenInfo = ({
                        PlayerData = ({SizeX = 1.0, SizeY = 1.0, OriginX = 0.0, OriginY = 0.0}
                                     )
                       }, 
                       {
                        PlayerData = ({SizeX = 1.0, SizeY = 0.5, OriginX = 0.0, OriginY = 0.0}, 
                                      {SizeX = 1.0, SizeY = 0.5, OriginX = 0.0, OriginY = 0.5}
                                     )
                       }, 
                       {
                        PlayerData = ({SizeX = 0.5, SizeY = 1.0, OriginX = 0.0, OriginY = 0.0}, 
                                      {SizeX = 0.5, SizeY = 1.0, OriginX = 0.5, OriginY = 0.0}
                                     )
                       }, 
                       {
                        PlayerData = ({SizeX = 1.0, SizeY = 0.5, OriginX = 0.0, OriginY = 0.0}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.0, OriginY = 0.5}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.5, OriginY = 0.5}
                                     )
                       }, 
                       {
                        PlayerData = ({SizeX = 0.5, SizeY = 0.5, OriginX = 0.0, OriginY = 0.0}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.5, OriginY = 0.0}, 
                                      {SizeX = 1.0, SizeY = 0.5, OriginX = 0.0, OriginY = 0.5}
                                     )
                       }, 
                       {
                        PlayerData = ({SizeX = 0.5, SizeY = 0.5, OriginX = 0.0, OriginY = 0.0}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.5, OriginY = 0.0}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.0, OriginY = 0.5}, 
                                      {SizeX = 0.5, SizeY = 0.5, OriginX = 0.5, OriginY = 0.5}
                                     )
                       }
                      )
    UIControllerClass = Class'UIInteraction'
    TitleSafeZone = {MaxPercentX = 0.899999976, MaxPercentY = 0.899999976, RecommendedPercentX = 0.800000012, RecommendedPercentY = 0.800000012}
    ProgressTimeOut = 8.0
    ProgressFadeTime = 1.0
    Default3PSplitType = ESplitScreenType.eSST_3P_FAVOR_TOP
    CurrentMouseCursor = 2
}