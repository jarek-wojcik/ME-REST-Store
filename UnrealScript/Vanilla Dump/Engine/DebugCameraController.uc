Class DebugCameraController extends PlayerController
    native
    config(Input);

var globalconfig Name PrimaryKey;
var globalconfig Name SecondaryKey;
var globalconfig Name UnselectKey;
var PlayerController OryginalControllerRef;
var Player OryginalPlayer;
var editinline export DrawFrustumComponent DrawFrustum;
var Actor SelectedActor;
var editinline export PrimitiveComponent SelectedComponent;
var globalconfig bool bShowSelectedInfo;
var bool bIsFrozenRendering;

public native function string ConsoleCommand(string Command, optional bool bWriteToLog = TRUE);

public function OnActivate(PlayerController PC)
{
    if (DrawFrustum == None)
    {
        DrawFrustum = new (PC.PlayerCamera) Class'DrawFrustumComponent';
    }
    DrawFrustum.SetHidden(FALSE);
    PC.SetHidden(FALSE);
    PC.PlayerCamera.SetHidden(FALSE);
    DrawFrustum.FrustumAngle = PC.PlayerCamera.CameraCache.POV.FOV;
    DrawFrustum.SetAbsolute(TRUE, TRUE, FALSE);
    DrawFrustum.SetTranslation(PC.PlayerCamera.CameraCache.POV.location);
    DrawFrustum.SetRotation(PC.PlayerCamera.CameraCache.POV.Rotation);
    PC.PlayerCamera.AttachComponent(DrawFrustum);
    ConsoleCommand("show camfrustums");
}
public function OnDeactivate(PlayerController PC)
{
    DrawFrustum.SetHidden(TRUE);
    ConsoleCommand("show camfrustums");
    PC.PlayerCamera.DetachComponent(DrawFrustum);
    PC.SetHidden(TRUE);
    PC.PlayerCamera.SetHidden(TRUE);
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (myHUD != None)
    {
        myHUD.Destroy();
    }
    myHUD = Spawn(Class'DebugCameraHUD', Self);
}
public native function PrimarySelect(Vector HitLoc, Vector HitNormal, TraceHitInfo HitInfo);

public native function SecondarySelect(Vector HitLoc, Vector HitNormal, TraceHitInfo HitInfo);

public native function Unselect();

public function DisableDebugCamera()
{
    if (OryginalControllerRef != None)
    {
        if (bIsFrozenRendering)
        {
            ConsoleCommand("FreezeRendering");
            bIsFrozenRendering = FALSE;
        }
        if (OryginalPlayer != None)
        {
            OnDeactivate(OryginalControllerRef);
            OryginalPlayer.SwitchController(OryginalControllerRef);
            OryginalControllerRef = None;
        }
    }
}
public exec function MoreSpeed()
{
    bRun = 2;
}
public function bool NativeInputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
{
    local Vector CamLoc;
    local Vector ZeroVec;
    local Rotator CamRot;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local Vector HitLoc;
    local Vector HitNormal;
    
    CamLoc = PlayerCamera.CameraCache.POV.location;
    CamRot = PlayerCamera.CameraCache.POV.Rotation;
    if (Event == EInputEvent.IE_Pressed)
    {
        if (Key == UnselectKey)
        {
            Unselect();
            SelectedActor = None;
            SelectedComponent = None;
            return TRUE;
        }
        if (Key == PrimaryKey)
        {
            HitActor = Trace(HitLoc, HitNormal, Vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, TRUE, ZeroVec, HitInfo, );
            if (HitActor != None)
            {
                SelectedActor = HitActor;
                SelectedComponent = HitInfo.HitComponent;
                PrimarySelect(HitLoc, HitNormal, HitInfo);
            }
            return TRUE;
        }
        if (Key == SecondaryKey)
        {
            HitActor = Trace(HitLoc, HitNormal, Vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, TRUE, ZeroVec, HitInfo, );
            if (HitActor != None)
            {
                SelectedActor = HitActor;
                SelectedComponent = HitInfo.HitComponent;
                SecondarySelect(HitLoc, HitNormal, HitInfo);
            }
            return TRUE;
        }
    }
    return FALSE;
}
public exec function NormalSpeed()
{
    bRun = 0;
}
public exec function SetFreezeRendering()
{
    ConsoleCommand("FreezeRendering");
    bIsFrozenRendering = !bIsFrozenRendering;
}
public exec function ShowDebugSelectedInfo()
{
    bShowSelectedInfo = !bShowSelectedInfo;
}

auto state PlayerWaiting 
{
    public function PlayerMove(float DeltaTime)
    {
        local float UndilatedDeltaTime;
        
        UndilatedDeltaTime = DeltaTime / WorldInfo.TimeDilation;
        Super.PlayerMove(UndilatedDeltaTime);
        if (WorldInfo.Pauser != None)
        {
            PlayerCamera.UpdateCamera(DeltaTime);
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
    PrimaryKey = 'LeftMouseButton'
    SecondaryKey = 'RightMouseButton'
    UnselectKey = 'Escape'
    bShowSelectedInfo = TRUE
    InputClass = Class'DebugCameraInput'
    CylinderComponent = CollisionCylinder
    Components = (None, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bHidden = FALSE
    bAlwaysTick = TRUE
    bHiddenEd = FALSE
}