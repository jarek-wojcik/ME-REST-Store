Class BioHUD extends HUD
    native
    transient
    config(Game);

const HUD_SEGMENTS = 64.0f;
struct native DesignerBar 
{
    var Name Id;
    var float X;
    var float Y;
    var float Width;
    var float Lifetime;
    var float SpawnTime;
    var int Color;
    var bool Grows;
    var bool Shrinks;
};
struct native DesignerText 
{
    var string Text;
    var Name Id;
    var float X;
    var float Y;
    var float Duration;
    var float Scale;
    var float TimeStamp;
    var bool Center;
};
struct native TraceStripChannel 
{
    var array<TraceStripKey> Keys;
    var LinearColor DrawColor;
    var Name nmButton;
    var Name nmAxis;
    var Name nmProperty;
    var Name nmAnimnode;
    var Actor Owner;
    var float fDynamicMax;
    var Property CachedProperty;
    var AnimNodeBlendBase CachedAnimNode;
    
    structdefaultproperties
    {
        fDynamicMax = 1.0
    }
};
struct native TraceStripKey 
{
    var float fTime;
    var float fValue;
};

var array<delegate<DebugDraw>> DebugDrawList;
var(BioHUD) array<TraceStripChannel> TraceStrips;
var array<DesignerText> DesignerHudText;
var array<DesignerBar> DesignerHudBars;
var delegate<DebugDraw> __DebugDraw__Delegate;
var(BioHUD) LinearColor TraceStripTickColor;
var Actor m_oActorForInfoDisplay;
var(BioHUD) float TraceStripTickInterval;
var(BioHUD) float TraceStripTimeSeconds;
var(BioHUD) float TraceStripDrawHeight;
var float m_ShowCoverLastTime;
var Material oGUIMaterial;
var config float SafeAreaRatioX;
var config float SafeAreaRatioY;
var float m_fSafeXOffset;
var float m_fSafeYOffset;
var Texture2D SafeAreaTexture;
var int m_textX;
var int m_textY;
var const int m_lineHeight;
var const int m_charWidth;
var const int m_leftColumnX;
var const int m_rightColumnX;
var const int m_farrightColumnX;
var const int m_topRowY;
var float LastSaveStartTime;
var float LastSaveEndTime;
var const Color YellowColor;
var const Color OrangeColor;
var const Color DarkGreyColor;
var float FadeTime;
var float MinFadeDuration;
var bool m_bLockActorInfo;
var bool TraceStripsPaused;
var bool m_bShowCoverRotation;
var bool m_bShowClaimedCoverOnly;
var bool bDisplaySafeArea;
var bool bDisplayingSave;
var config bool m_bUseGeneratedItemNames;
var config bool bDesignerHud;

public delegate function DebugDraw(BioHUD H);

public final exec native function DisplayRouteInfo(Pawn pPawn, Color PathColor, optional bool bDrawPathOnly = FALSE);

public final function DrawCircle(float fX, float fY, float Radius)
{
    local int idx;
    local float X1;
    local float Y1;
    local float X2;
    local float Y2;
    local float XPos;
    local float YPos;
    
    XPos = Canvas.CurX;
    YPos = Canvas.CurY;
    X1 = fX + Radius;
    Y1 = fY;
    for (idx = 0; float(idx) < 64.0 + float(1); idx++)
    {
        X2 = fX + Radius * Cos(2.0 * 3.14159274 * float(idx) / 64.0);
        Y2 = fY + Radius * Sin(2.0 * 3.14159274 * float(idx) / 64.0);
        Canvas.Draw2DLine(X1, Y1, X2, Y2, Canvas.DrawColor);
        X1 = X2;
        Y1 = Y2;
    }
    Canvas.CurX = XPos;
    Canvas.CurY = YPos;
}
public event function DrawText(string valueName, string Value, optional Color LabelColor = MakeColor(255, 255, 0), optional Color DataColor = MakeColor(0, 255, 0))
{
    DrawTextWithColor(valueName, Value, MakeColor(255, 255, 0), MakeColor(0, 255, 0));
}
public event function DrawTextWithColor(string valueName, string Value, Color LabelColor, Color DataColor)
{
    local float strX;
    local float dummyStrY;
    local float Alpha;
    
    Alpha = 255.0 * (1.0 - BioPlayerController(PlayerOwner).PlayerCamera.FadeAmount);
    Canvas.StrLen(valueName, strX, dummyStrY);
    Canvas.SetPos(float(m_textX + 1), float(m_textY + 1));
    Canvas.SetDrawColor(0, 0, 0, byte(Alpha));
    Canvas.DrawText(valueName);
    Canvas.SetPos(float(m_textX), float(m_textY));
    Canvas.SetDrawColor(LabelColor.R, LabelColor.G, LabelColor.B, byte(Alpha));
    Canvas.DrawText(valueName);
    Canvas.SetPos(float(m_textX) + strX + float(m_charWidth) + float(1), float(m_textY + 1));
    Canvas.SetDrawColor(0, 0, 0, byte(Alpha));
    Canvas.DrawText(Value);
    Canvas.SetPos(float(m_textX) + strX + float(m_charWidth), float(m_textY));
    Canvas.SetDrawColor(DataColor.R, DataColor.G, DataColor.B, byte(Alpha));
    Canvas.DrawText(Value);
    m_textY += m_lineHeight;
}
private final native function DrawTraceStrip(TraceStripChannel Chan, Vector2D Origin, Vector2D Extent, float fTimeScale);

private final native function DrawTraceStripBacking(Vector2D Origin, Vector2D Extent, float fTimeScale, float fMostRecentTime, LinearColor LineColor);

public final function bool IsFinalReleaseBuild()
{
    return Class'Engine'.static.IsShip();
}
public final native function string LoadTestTextStringFromFile();

public function PostRender()
{
    local BioCheatManager CheatManager;
    local bool bShowHudOld;
    local Vector2D CanvasOrg;
    local Vector2D CanvasBk;
    local float CanvasDrawAlpha;
    
    bShowHudOld = bShowHUD;
    if (!Class'Engine'.static.IsShip())
    {
        CheatManager = BioCheatManager(PlayerOwner.CheatManager);
        if (CheatManager != None)
        {
            if (CheatManager.CurrentProfile > EProfileType.Profile_None && int(CheatManager.CurrentProfile) < 47)
            {
                bShowHUD = TRUE;
            }
        }
    }
    Super.PostRender();
    bShowHUD = bShowHudOld;
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    CanvasOrg.X = Canvas.OrgX;
    CanvasOrg.Y = Canvas.OrgY;
    if (oGUIMaterial != None)
    {
        Canvas.SetPos(0.0, 0.0);
        Canvas.DrawMaterialTile(oGUIMaterial, SizeX, SizeY);
    }
    if (Canvas.OrgY != float(0))
    {
        CanvasDrawAlpha = 255.0 * (1.0 - BioPlayerController(PlayerOwner).PlayerCamera.FadeAmount);
        Canvas.SetDrawColor(0, 0, 0, byte(CanvasDrawAlpha));
        Canvas.SetPos(0.0, -Canvas.OrgY);
        Canvas.DrawRect(float(Canvas.SizeX), Canvas.OrgY);
        Canvas.SetPos(0.0, float(Canvas.SizeY));
        Canvas.DrawRect(float(Canvas.SizeX), Canvas.OrgY);
    }
    CanvasBk.X = Canvas.OrgX;
    CanvasBk.Y = Canvas.OrgY;
    Canvas.OrgX = CanvasOrg.X;
    Canvas.OrgY = CanvasOrg.Y;
    DisplaySafeArea();
    Canvas.OrgX = CanvasBk.X;
    Canvas.OrgY = CanvasBk.Y;
}
public native function ProfileAnim(Actor TargetActor);

public native function ProfileAnimPreload(Actor TargetActor);

public native function ProfileConversation(Actor TargetActor);

public native function ProfileConversationBug(Actor TargetActor);

public event function ProfileConversationExtra(BioConversationController oCurConv)
{
    local BioStage stg;
    local LocalPlayer pLocalPlayer;
    
    if (oCurConv.IsCurrentlyAmbient())
    {
        DrawText("Ambient Conversation", "");
        if (oCurConv.m_fInterruptRange == -1.0)
        {
            DrawText("   Set not interruptable by range", "");
        }
        else
        {
            DrawText("   Interrupt Range:", "" $ (oCurConv.m_fInterruptRange > float(0) ? oCurConv.m_fInterruptRange : BioWorldInfo(WorldInfo).m_fConversationInterruptDistance));
            DrawText("   Speaker Dist:", "" $ VSize(oCurConv.m_pPlayer.location - oCurConv.m_pSpeaker.location));
        }
        return;
    }
    stg = oCurConv.m_pStage;
    DrawText("", "");
    if (oCurConv.m_pKismetStart != None && !oCurConv.m_pKismetStart.m_bLookAtActive)
    {
        DrawText("Look At DISABLED by PlayConversation", "");
    }
    if (stg == None)
    {
        DrawText("No stage", "");
        return;
    }
    if (oCurConv.m_bHasAttachedCameraTrack)
    {
        DrawText("Matinee Camera", "");
    }
    else
    {
        DrawText("Camera: ", "" $ stg.m_nmCurrentCamera);
        DrawText("Stage: ", stg.GetPackageName() $ "." $ stg.Name $ " (" $ stg.Tag $ ")");
        DrawText("   Height Adjust   ", stg.m_bDoHeightAdjustment ? "True" : "False");
    }
    pLocalPlayer = LocalPlayer(BioWorldInfo(WorldInfo).GetLocalPlayerController().Player);
    if (pLocalPlayer == None || pLocalPlayer.CurrentPPInfo.LastSettings.bEnableDOF == FALSE)
    {
        DrawText("No DOF Active", "");
    }
    else
    {
        if (oCurConv.m_bHasAttachedDOFTrack == TRUE)
        {
            DrawText("DOF Track Active", "");
        }
        else if (stg.m_bDOFActive == TRUE && oCurConv.m_bHasAttachedCameraTrack == FALSE)
        {
            DrawText("Stage DOF Active", "");
        }
        else
        {
            DrawText("World DOF Active", "");
        }
        DrawText("   FocusInnerRadius   ", "" $ pLocalPlayer.CurrentPPInfo.LastSettings.DOF_FocusInnerRadius);
        DrawText("   FocusDistance   ", "" $ pLocalPlayer.CurrentPPInfo.LastSettings.DOF_FocusDistance);
    }
    if (!stg.m_bLookAtActive)
    {
        DrawText("Look At DISABLED for this stage", "");
    }
    else if (BioWorldInfo(WorldInfo).m_fLookAtDelays.Length < 2)
    {
        DrawText("Look at config error", "");
    }
    else
    {
        DrawText("Look At On", "");
    }
    stg.ProfileStage(Self);
    DrawText("", "");
    if (oCurConv.m_pStage.m_fHeightAdjust != 0.0 && oCurConv.m_bHasAttachedCameraTrack == FALSE)
    {
        DrawText("Height Adjust: ", "" $ oCurConv.m_pStage.m_fHeightAdjust);
        DrawText("  Spk Ht: ", "Feet(" $ oCurConv.m_pStage.m_fSpeakerFeetZ $ ") EyeHeight(" $ oCurConv.m_pStage.m_fSpeakerEyeHeight $ ")");
        DrawText("  Stage Ht: ", "" $ oCurConv.m_pStage.m_fStageZ);
    }
    else
    {
        DrawText("No height adjust", "");
    }
}
public native function ProfileCover(Actor TargetActor);

public native function ProfileGestures(Actor TargetActor);

public native function ProfileKinect(Actor TargetActor);

public native function ProfileLookAt(Actor TargetActor);

public native function ProfileWwise(Actor TargetActor);

private final native function UpdateCover(bool bShowRotation);

private final native function UpdateTraceStrips(float fBufferTime);

public final native function ViewportDeProject(LocalPlayer LocalPlayerOwner, Vector ScreenLocation, out Vector OutLocation, out Vector OutDirection);

public function DrawEngineHUD();

public function DrawHUD()
{
    local int idx;
    
    if (!Class'Engine'.static.IsShip())
    {
        Canvas.SetDrawColor(255, 255, 255);
        for (idx = 0; idx < DebugDrawList.Length; idx++)
        {
            __DebugDraw__Delegate = DebugDrawList[idx];
            __DebugDraw__Delegate(Self);
        }
        if (bDesignerHud)
        {
            DrawDesignerHud();
        }
    }
    Super.DrawHUD();
}
public final function AddAnimNodeTraceStrip(Actor TargetActor, Name nmAnimnode, LinearColor DrawColor)
{
    local TraceStripChannel NewStrip;
    
    NewStrip.Owner = TargetActor;
    NewStrip.nmAnimnode = nmAnimnode;
    NewStrip.DrawColor = DrawColor;
    TraceStrips.AddItem(NewStrip);
    StartTraceStrips();
}
public final function AddAxisTraceStrip(Name nmAxis, LinearColor DrawColor)
{
    local TraceStripChannel NewStrip;
    
    NewStrip.nmAxis = nmAxis;
    NewStrip.DrawColor = DrawColor;
    TraceStrips.AddItem(NewStrip);
    StartTraceStrips();
}
public final function AddBar(Name Id, float X, float Y, float Width, optional float Lifetime = 3600.0, optional int C = 0, optional bool Grows = FALSE, optional bool Shrinks = FALSE)
{
    local DesignerBar Bar;
    
    RemoveBar(Id);
    Bar.Id = Id;
    Bar.X = X;
    Bar.Y = Y;
    Bar.Width = Width;
    Bar.Lifetime = Lifetime;
    Bar.Color = C;
    Bar.Grows = Grows;
    Bar.Shrinks = Shrinks;
    Bar.SpawnTime = WorldInfo.GameTimeSeconds;
    DesignerHudBars[DesignerHudBars.Length] = Bar;
}
public final function AddButtonTraceStrip(Name nmButton, LinearColor DrawColor)
{
    local TraceStripChannel NewStrip;
    
    NewStrip.nmButton = nmButton;
    NewStrip.DrawColor = DrawColor;
    TraceStrips.AddItem(NewStrip);
    StartTraceStrips();
}
public final function AddDebugDraw(delegate<DebugDraw> DebugDrawFunc)
{
    local int idx;
    
    idx = DebugDrawList.Find(DebugDrawFunc);
    if (idx == -1)
    {
        DebugDrawList[DebugDrawList.Length] = DebugDrawFunc;
    }
}
public final function AddDesignerText(Name Id, coerce string S, float X, float Y, optional float TimeOut = 0.0, optional float Scale = 0.0, optional bool Center = TRUE)
{
    local DesignerText Text;
    
    RemoveDesignerText(Id);
    Text.Id = Id;
    Text.Text = S;
    Text.X = X;
    Text.Y = Y;
    Text.Duration = TimeOut;
    Text.Scale = Scale > float(0) ? Scale : 2.0;
    Text.TimeStamp = WorldInfo.GameTimeSeconds;
    Text.Center = Center;
    DesignerHudText[DesignerHudText.Length] = Text;
}
public final function AddPropertyTraceStrip(Actor TargetActor, Name nmProperty, LinearColor DrawColor)
{
    local TraceStripChannel NewStrip;
    
    NewStrip.Owner = TargetActor;
    NewStrip.nmProperty = nmProperty;
    NewStrip.DrawColor = DrawColor;
    TraceStrips.AddItem(NewStrip);
    StartTraceStrips();
}
public final function CDrawSquare(int nSize)
{
    local int X;
    local int Y;
    
    X = int(Canvas.CurX);
    Y = int(Canvas.CurY);
    Canvas.SetPos(float(X) - float(nSize) * 0.5 + 0.5, float(Y) - float(nSize) * 0.5 + 0.5);
    Canvas.DrawRect(float(nSize), float(nSize));
}
public final function ClearDebugDraw(delegate<DebugDraw> DebugDrawFunc)
{
    local int idx;
    
    idx = DebugDrawList.Find(DebugDrawFunc);
    if (idx != -1)
    {
        DebugDrawList.Remove(idx, 1);
    }
}
public final function ClearTraceStrips()
{
    TraceStrips.Length = 0;
    HideTraceStrips();
}
public final function DebugDraw_ActorInfo(BioHUD HUD)
{
    local BioPlayerController oPlayerController;
    local Actor oActor;
    local Vector vHitLocation;
    local Vector vHitNormal;
    local float fGuiAlpha;
    local float fX;
    local float fY;
    local BioPawn oPawn;
    
    oPlayerController = BioPlayerController(PlayerOwner);
    if (oPlayerController == None || oPlayerController.Pawn == None)
    {
        return;
    }
    if (m_oActorForInfoDisplay == None)
    {
        if (SFXPlayerCamera(oPlayerController.PlayerCamera).GetTrace(oActor, vHitLocation, vHitNormal) == FALSE)
        {
            return;
        }
    }
    else
    {
        oActor = m_oActorForInfoDisplay;
    }
    oPawn = BioPawn(oActor);
    fGuiAlpha = 255.0 * (1.0 - BioPlayerController(PlayerOwner).PlayerCamera.FadeAmount);
    Canvas.SetDrawColor(255, 255, 255, byte(fGuiAlpha));
    fX = float(Canvas.SizeX) - float(Canvas.SizeX) * SafeAreaRatioX - 300.0;
    fY = float(Canvas.SizeY) * 0.5 - float(140);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Player loc=(" $ oPlayerController.Pawn.location $ ")");
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Tag=" $ oActor.Tag);
    if (oPawn != None)
    {
        fY += float(15);
        Canvas.SetPos(fX, fY);
        Canvas.DrawText("Game name=" $ oPawn.GetActorGameName());
    }
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object name=(" $ oActor $ ")");
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object loc=(" $ oActor.location $ ")");
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object velocity=(" $ oActor.Velocity $ ")");
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object acceleration=(" $ oActor.Acceleration $ ")");
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object physics mode=(" $ oActor.Physics $ ")");
    if (oActor.Base != None)
    {
        fY += float(15);
        Canvas.SetPos(fX, fY);
        Canvas.DrawText("Object base=(" $ oActor.Base.Tag $ ")");
    }
    if (oActor.CollisionComponent != None)
    {
        oActor.DrawDebugBox(oActor.CollisionComponent.Bounds.Origin, oActor.CollisionComponent.Bounds.BoxExtent, 0, 0, 255, FALSE);
    }
    fY += float(15);
    Canvas.SetPos(fX, fY);
    Canvas.DrawText("Object rotation=(" $ Vector(oActor.Rotation) $ ")");
    oActor.DrawDebugLine(oActor.location, oActor.location + Vector(oActor.Rotation) * 100.0, 0, 0, 255, FALSE);
    if (oPawn != None)
    {
        fY += float(15);
        Canvas.SetPos(fX, fY);
        Canvas.DrawText("Object desired rotation=(" $ Vector(oPawn.DesiredRotation) $ ")");
        if (VSize(Vector(oPawn.DesiredRotation) - Vector(oActor.Rotation)) > 1.0)
        {
            oActor.DrawDebugLine(oActor.location, oActor.location + Vector(oPawn.DesiredRotation) * 100.0, 0, 255, 0, FALSE);
        }
    }
}
private final function DebugDraw_CoverNames(BioHUD HUD)
{
    local BioWorldInfo oWorldInfo;
    local SFXPlayerCamera oCameraManager;
    local Vector vCameraLocation;
    local Vector vCameraRotation;
    local CoverLink oCoverLink;
    local Vector vLocation;
    local Vector vDirection;
    local CoverSlotMarker oCoverSlotMarker;
    local string sText;
    local Pawn oSlotOwner;
    local bool bSlotClaimed;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None || Canvas == None)
    {
        return;
    }
    oCameraManager = SFXPlayerCamera(oWorldInfo.GetLocalPlayerController().PlayerCamera);
    if (oCameraManager == None)
    {
        return;
    }
    Canvas.SetDrawColor(255, 255, 255, 255);
    vCameraLocation = oWorldInfo.GetLocalPlayerController().PlayerCamera.CameraCache.POV.location;
    vCameraRotation = Vector(oWorldInfo.GetLocalPlayerController().PlayerCamera.CameraCache.POV.Rotation);
    foreach AllActors(Class'CoverLink', oCoverLink, )
    {
        if (oCoverLink != None && (m_bShowClaimedCoverOnly == FALSE || oCoverLink.Claims.Length > 0))
        {
            vDirection = oCoverLink.location - vCameraLocation;
            if (VSizeSq(vDirection) <= float(4000000) || m_bShowClaimedCoverOnly)
            {
                if (Normal(vDirection) Dot vCameraRotation >= 0.100000001)
                {
                    vLocation = Canvas.Project(oCoverLink.location);
                    Canvas.SetPos(vLocation.X - 40.0, vLocation.Y - 30.0);
                    sText = oCoverLink.Name $ " (" $ oCoverLink.Claims.Length $ ")";
                    Canvas.DrawText(sText);
                }
            }
        }
    }
    Canvas.SetDrawColor(255, 0, 0, 255);
    foreach AllActors(Class'CoverSlotMarker', oCoverSlotMarker, )
    {
        if (oCoverSlotMarker != None)
        {
            if (oCoverSlotMarker.OwningSlot.Link != None && oCoverSlotMarker.OwningSlot.SlotIdx >= 0 && oCoverSlotMarker.OwningSlot.SlotIdx < oCoverSlotMarker.OwningSlot.Link.Slots.Length && oCoverSlotMarker.OwningSlot.Link.Slots[oCoverSlotMarker.OwningSlot.SlotIdx].SlotOwner != None)
            {
                bSlotClaimed = TRUE;
            }
            else
            {
                bSlotClaimed = FALSE;
            }
            vDirection = oCoverSlotMarker.location - vCameraLocation;
            if (VSizeSq(vDirection) <= float(4000000) || m_bShowClaimedCoverOnly && bSlotClaimed)
            {
                if (Normal(vDirection) Dot vCameraRotation >= 0.100000001)
                {
                    vLocation = Canvas.Project(oCoverSlotMarker.location);
                    Canvas.SetPos(vLocation.X - 40.0, vLocation.Y - 30.0);
                    if (bSlotClaimed)
                    {
                        oSlotOwner = oCoverSlotMarker.OwningSlot.Link.Slots[oCoverSlotMarker.OwningSlot.SlotIdx].SlotOwner;
                        sText = oCoverSlotMarker.Name $ " (" $ oSlotOwner $ ")";
                        Canvas.DrawText(sText);
                    }
                    else if (!m_bShowClaimedCoverOnly)
                    {
                        Canvas.DrawText(string(oCoverSlotMarker.Name));
                    }
                }
            }
        }
    }
}
private final function DebugDraw_PlayerLocation(BioHUD HUD)
{
    local string sLocation;
    
    sLocation = "PlayerLocation: (" $ PlayerOwner.Pawn.location.X $ ", " $ PlayerOwner.Pawn.location.Y $ ", " $ PlayerOwner.Pawn.location.Z $ ")";
    Canvas.bCenter = TRUE;
    DrawFakeShadowText(Canvas.SizeX / 2, Canvas.SizeY / 2, YellowColor, sLocation);
}
private final function DebugDraw_TraceStrips(BioHUD HUD)
{
    local float X;
    local float Y;
    local float DeltaY;
    local float TextX;
    local float TextY;
    local Vector2D vStripExtent;
    local string sTrackName;
    local int i;
    
    X = float(Canvas.SizeX) * SafeAreaRatioX;
    Y = float(Canvas.SizeY) * SafeAreaRatioY + float(20);
    vStripExtent.X = float(Canvas.SizeX) - float(Canvas.SizeX) * SafeAreaRatioX - X;
    vStripExtent.Y = TraceStripDrawHeight;
    DeltaY = vStripExtent.Y + float(10);
    Canvas.TextSize("label height", TextX, TextY);
    if (!TraceStripsPaused)
    {
        UpdateTraceStrips(TraceStripTimeSeconds);
    }
    for (i = 0; i < TraceStrips.Length; ++i)
    {
        sTrackName = "strangely unidentified track";
        if (TraceStrips[i].nmButton != 'None')
        {
            sTrackName = string(TraceStrips[i].nmButton);
        }
        else if (TraceStrips[i].nmAxis != 'None')
        {
            sTrackName = string(TraceStrips[i].nmAxis);
        }
        else if (TraceStrips[i].nmProperty != 'None')
        {
            sTrackName = TraceStrips[i].Owner.GetDebugName() $ "." $ TraceStrips[i].nmProperty;
        }
        else if (TraceStrips[i].nmAnimnode != 'None')
        {
            sTrackName = TraceStrips[i].Owner.GetDebugName() $ ":" $ TraceStrips[i].nmAnimnode;
        }
        Canvas.SetPos(X, Y);
        Canvas.SetDrawColor(byte(TraceStrips[i].DrawColor.R * float(255)), byte(TraceStrips[i].DrawColor.G * float(255)), byte(TraceStrips[i].DrawColor.B * float(255)), byte(TraceStrips[i].DrawColor.A * float(255)));
        Canvas.DrawText(sTrackName);
        Y += TextY * 0.5;
        if (TraceStrips[i].Keys.Length > 0)
        {
            if (TraceStrips[i].nmAxis != 'None')
            {
                DrawTraceStripBacking(vect2d(X, Y + vStripExtent.Y * 0.400000006), vect2d(vStripExtent.X, vStripExtent.Y * 0.200000003), vStripExtent.X / TraceStripTimeSeconds, TraceStrips[i].Keys[TraceStrips[i].Keys.Length - 1].fTime, TraceStripTickColor);
            }
            else
            {
                DrawTraceStripBacking(vect2d(X, Y + vStripExtent.Y * 0.899999976), vect2d(vStripExtent.X, vStripExtent.Y * 0.200000003), vStripExtent.X / TraceStripTimeSeconds, TraceStrips[i].Keys[TraceStrips[i].Keys.Length - 1].fTime, TraceStripTickColor);
            }
        }
        DrawTraceStrip(TraceStrips[i], vect2d(X, Y), vStripExtent, vStripExtent.X / TraceStripTimeSeconds);
        Y += DeltaY;
    }
}
private final function DebugDraw_UpdateCover(BioHUD HUD)
{
    if (WorldInfo.GameTimeSeconds - m_ShowCoverLastTime > 1.0)
    {
        UpdateCover(m_bShowCoverRotation);
        m_ShowCoverLastTime = WorldInfo.GameTimeSeconds;
    }
}
public final exec function DisplayActorInfo()
{
    ToggleDebugDraw(DebugDraw_ActorInfo);
}
public final function DisplaySafeArea()
{
    if (bDisplaySafeArea)
    {
        Canvas.SetPos(float(Canvas.SizeX) * SafeAreaRatioX, float(Canvas.SizeY) * SafeAreaRatioY);
        Canvas.SetDrawColor(255, 255, 255, 50);
        Canvas.DrawTile(SafeAreaTexture, float(Canvas.SizeX) * (float(1) - SafeAreaRatioX * float(2)), float(Canvas.SizeY) * (float(1) - SafeAreaRatioY * float(2)), 0.0, 0.0, float(SafeAreaTexture.SizeX), float(SafeAreaTexture.SizeY));
    }
}
public function DrawDesignerHud()
{
    local DesignerText Text;
    local DesignerBar Bar;
    local float Width;
    local float Ratio;
    local float Alpha;
    local float X;
    local float Y;
    
    foreach DesignerHudBars(Bar, )
    {
        switch (Bar.Color)
        {
            case 1:
                Canvas.SetDrawColor(255, 0, 0, 64);
                break;
            case 2:
                Canvas.SetDrawColor(0, 255, 0, 64);
                break;
            case 3:
                Canvas.SetDrawColor(0, 0, 255, 64);
                break;
            case 0:
            default:
                Canvas.SetDrawColor(255, 255, 255, 64);
                break;
        }
        Width = Bar.Width;
        Ratio = Bar.Lifetime > float(0) ? (WorldInfo.GameTimeSeconds - Bar.SpawnTime) / Bar.Lifetime : 1.0;
        if (Ratio > float(1))
        {
            Ratio = 1.0;
            RemoveBar(Bar.Id);
        }
        Width = Bar.Grows ? Width * Ratio : Width;
        Width = Bar.Shrinks ? Width * (float(1) - Ratio) : Width;
        Canvas.SetPos(float(int(Bar.X * float(Canvas.SizeX) / 100.0)), float(int(Bar.Y * float(Canvas.SizeY) / 100.0)));
        Canvas.DrawRect(Width * float(Canvas.SizeX) / 100.0, float(Canvas.SizeY) / 30.0);
    }
    Canvas.Font = Class'Engine'.static.GetLargeFont();
    foreach DesignerHudText(Text, )
    {
        if (Text.Duration > float(0) && WorldInfo.GameTimeSeconds > Text.TimeStamp + Text.Duration)
        {
            RemoveDesignerText(Text.Id);
            continue;
        }
        Canvas.TextSize(Text.Text, X, Y);
        X = Text.Center ? X * 0.5 * Text.Scale : 0.0;
        X = float(int(Text.X * float(Canvas.SizeX) / 100.0)) - X;
        Y = float(int(Text.Y * float(Canvas.SizeY) / 100.0));
        Alpha = 255.0;
        if (Text.Duration > MinFadeDuration)
        {
            Alpha = WorldInfo.GameTimeSeconds - Text.TimeStamp < FadeTime ? (WorldInfo.GameTimeSeconds - Text.TimeStamp) * float(255) / FadeTime : Alpha;
            Alpha = WorldInfo.GameTimeSeconds + FadeTime > Text.TimeStamp + Text.Duration ? (FadeTime - (WorldInfo.GameTimeSeconds - Text.TimeStamp - Text.Duration)) * float(255) / FadeTime : Alpha;
        }
        Canvas.SetDrawColor(0, 0, 0, byte(Alpha));
        Canvas.SetPos(X - float(2), Y - float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X - float(2), Y);
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X - float(2), Y + float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X + float(2), Y - float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X + float(2), Y);
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X + float(2), Y + float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X, Y - float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetPos(X, Y + float(2));
        Canvas.DrawText(Text.Text, FALSE, Text.Scale, Text.Scale);
        Canvas.SetDrawColor(255, 255, 255, byte(Alpha));
        Canvas.SetPos(X, Y);
        Canvas.DrawText(Text.Text, TRUE, Text.Scale, Text.Scale);
    }
}
private final function DrawFakeShadowText(int X, int Y, Color DrawColor, string sText)
{
    local float fGuiAlpha;
    
    fGuiAlpha = 255.0 * (1.0 - BioPlayerController(PlayerOwner).PlayerCamera.FadeAmount);
    Canvas.SetDrawColor(0, 0, 0, byte(fGuiAlpha));
    Canvas.SetPos(float(X - 2), float(Y - 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X - 2), float(Y));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X - 2), float(Y + 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X + 2), float(Y - 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X + 2), float(Y));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X + 2), float(Y + 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X), float(Y - 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X), float(Y + 2));
    Canvas.DrawText(sText, FALSE);
    Canvas.SetPos(float(X), float(Y));
    Canvas.DrawColor = DrawColor;
    Canvas.DrawColor.A = byte(fGuiAlpha);
    Canvas.DrawText(sText, FALSE);
}
public function DUI_ClearAll(bool bModal)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_ClearAll(bModal);
}
public function DUI_ClearElementPulse(BioDUIElements nElement)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_ClearElementPulse(nElement);
}
public function DUI_SetBarFillDirection(bool bModalBar, bool bLeftToRight)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetBarFillDirection(bModalBar, bLeftToRight);
}
public function DUI_SetBarFillPercent(bool bModalBar, int nPercent)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetBarFillPercent(bModalBar, nPercent);
}
public function DUI_SetBarMarkerPoints(bool bModalBar, int nMarker1, int nMarker2)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetBarMarkerPoints(bModalBar, nMarker1, nMarker2);
}
public function DUI_SetCounterValue(bool bModalCounter, int nValue)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetCounterValue(bModalCounter, nValue);
}
public function DUI_SetElementAlpha(BioDUIElements nElement, float fAlpha)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetElementAlpha(nElement, fAlpha);
}
public function DUI_SetElementColor(BioDUIElements nElement, Color stColor)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetElementColor(nElement, stColor);
}
public function DUI_SetElementText(BioDUIElements nElement, string sText)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetElementText(nElement, sText);
}
public function DUI_SetElementVisible(BioDUIElements nElement, bool bVisible, optional float fFadeTime = 0.0)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetElementVisible(nElement, bVisible, fFadeTime);
}
public function DUI_SetQuasarLayout(bool bShow)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetQuasarLayout(bShow);
}
public function DUI_SetTextStringRef(BioDUIElements nElement, stringref srText)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetTextStringRef(nElement, srText);
}
public function DUI_SetTimerDetails(bool bModalTimer, bool bVisible, float fStartTime, float fEndTime, float fInterval)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetTimerDetails(bModalTimer, bVisible, fStartTime, fEndTime, fInterval);
}
public function DUI_SetupElementPulse(BioDUIElements nElement, float fMinAlpha, float fCycleTime)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(PlayerOwner);
    PC.DUI_SetupElementPulse(nElement, fMinAlpha, fCycleTime);
}
public final function bool HasDesignerText(Name Id, optional string S = "")
{
    local int idx;
    
    for (idx = 0; idx < DesignerHudText.Length; idx++)
    {
        if (DesignerHudText[idx].Id == Id && (S == "" || S == DesignerHudText[idx].Text))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final exec function HideLocation()
{
    ClearDebugDraw(DebugDraw_PlayerLocation);
}
public final function HideTraceStrips()
{
    if (IsDrawing(DebugDraw_TraceStrips))
    {
        ClearDebugDraw(DebugDraw_TraceStrips);
    }
}
public final function bool IsDrawing(delegate<DebugDraw> DebugDrawFunc)
{
    local int idx;
    
    idx = DebugDrawList.Find(DebugDrawFunc);
    if (idx >= 0)
    {
        return TRUE;
    }
    return FALSE;
}
public final exec function LockActorInfo()
{
    local Actor oActor;
    local Vector vHitLocation;
    local Vector vHitNormal;
    
    m_bLockActorInfo = !m_bLockActorInfo;
    if (m_bLockActorInfo)
    {
        if (SFXPlayerCamera(BioWorldInfo(WorldInfo).GetLocalPlayerController().PlayerCamera).GetTrace(oActor, vHitLocation, vHitNormal))
        {
            m_oActorForInfoDisplay = oActor;
        }
    }
    else
    {
        m_oActorForInfoDisplay = None;
    }
}
public final function RemoveBar(Name Id)
{
    local int idx;
    
    for (idx = 0; idx < DesignerHudBars.Length; idx++)
    {
        if (DesignerHudBars[idx].Id == Id)
        {
            DesignerHudBars.Remove(idx, 1);
            return;
        }
    }
}
public final function RemoveDesignerText(Name Id)
{
    local int idx;
    
    for (idx = 0; idx < DesignerHudText.Length; idx++)
    {
        if (DesignerHudText[idx].Id == Id)
        {
            DesignerHudText.Remove(idx, 1);
            idx = DesignerHudText.Length;
        }
    }
}
public final function RemoveTraceAtIndex(int nTrace)
{
    if (nTrace < 0)
    {
        nTrace += TraceStrips.Length;
    }
    if (nTrace >= 0 && nTrace < TraceStrips.Length)
    {
        TraceStrips.Remove(nTrace, 1);
        if (TraceStrips.Length == 0)
        {
            HideTraceStrips();
        }
    }
}
public final exec function SetActorForActorInfo(Name nmActor)
{
    local Actor oActor;
    
    foreach AllActors(Class'Actor', oActor, )
    {
        if (nmActor == oActor.Name)
        {
            break;
        }
    }
    if (oActor == None)
    {
        return;
    }
    m_oActorForInfoDisplay = oActor;
    m_bLockActorInfo = TRUE;
}
public final exec function ShowCover(optional bool bShowRotation = FALSE)
{
    if (IsDrawing(DebugDraw_UpdateCover))
    {
        ClearDebugDraw(DebugDraw_UpdateCover);
        FlushPersistentDebugLines();
    }
    else
    {
        m_bShowCoverRotation = bShowRotation;
        AddDebugDraw(DebugDraw_UpdateCover);
    }
}
public final exec function ShowLocation()
{
    AddDebugDraw(DebugDraw_PlayerLocation);
}
public final exec function ShowReachSpecs(Name nmNavigationPoint)
{
    local NavigationPoint oNavPoint;
    local int nIndex;
    local ReachSpec oReachSpec;
    
    foreach AllActors(Class'NavigationPoint', oNavPoint, )
    {
        if (nmNavigationPoint == oNavPoint.Name)
        {
            break;
        }
    }
    if (oNavPoint == None)
    {
        return;
    }
    for (nIndex = 0; nIndex < oNavPoint.PathList.Length; nIndex++)
    {
        oReachSpec = oNavPoint.PathList[nIndex];
        if (oReachSpec != None && oReachSpec.Start != None && oReachSpec.End.Actor != None)
        {
            if (oReachSpec.IsBlocked())
            {
                oNavPoint.DrawDebugLine(oReachSpec.Start.location, oReachSpec.End.Actor.location, 255, 0, 0, TRUE);
            }
            else
            {
                oNavPoint.DrawDebugLine(oReachSpec.Start.location, oReachSpec.End.Actor.location, 0, 255, 0, TRUE);
            }
            if (oReachSpec.IsBlocked())
            {
                continue;
            }
        }
    }
}
public final function StartTraceStrips()
{
    if (!IsDrawing(DebugDraw_TraceStrips))
    {
        AddDebugDraw(DebugDraw_TraceStrips);
    }
}
public final exec function ToggleCoverNames(optional bool ClaimedCoverOnly = FALSE)
{
    ToggleDebugDraw(DebugDraw_CoverNames);
    m_bShowClaimedCoverOnly = ClaimedCoverOnly;
}
public final function ToggleDebugDraw(delegate<DebugDraw> DebugDrawFunc)
{
    local int idx;
    
    idx = DebugDrawList.Find(DebugDrawFunc);
    if (idx == -1)
    {
        DebugDrawList[DebugDrawList.Length] = DebugDrawFunc;
    }
    else if (idx != -1)
    {
        DebugDrawList.Remove(idx, 1);
    }
}
public final exec function ToggleSafeArea()
{
    bDisplaySafeArea = !bDisplaySafeArea;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TraceStripTickColor = {R = 0.100000001, G = 0.100000001, B = 0.100000001, A = 1.0}
    TraceStripTickInterval = 0.0333333313
    TraceStripTimeSeconds = 5.0
    TraceStripDrawHeight = 30.0
    SafeAreaRatioX = 0.0500000007
    SafeAreaRatioY = 0.0500000007
    m_fSafeXOffset = 60.0
    m_fSafeYOffset = 35.0
    SafeAreaTexture = Texture2D'EngineMaterials.DefaultDiffuse'
    m_lineHeight = 11
    m_charWidth = 12
    m_leftColumnX = 100
    m_rightColumnX = 600
    m_farrightColumnX = 900
    m_topRowY = 70
    YellowColor = {B = 0, G = 255, R = 255, A = 255}
    OrangeColor = {B = 0, G = 165, R = 255, A = 255}
    DarkGreyColor = {B = 64, G = 64, R = 64, A = 255}
    FadeTime = 0.25
    MinFadeDuration = 1.0
    m_bUseGeneratedItemNames = TRUE
    bDesignerHud = TRUE
}