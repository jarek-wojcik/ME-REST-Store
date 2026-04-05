Class SFXCameraNativeBase extends Camera
    native
    transient;

struct native SFXCameraNativeBaseTraceInfo 
{
    var Vector m_vCollVectorLocation;
    var Vector m_vCollVectorNormal;
    var Actor m_oCollVectorActor;
    var Color m_clrDebugDraw;
    var bool m_bCollDetected;
    var bool m_bCollisionDirty;
    var bool m_bDebugDraw;
    
    structdefaultproperties
    {
        m_clrDebugDraw = {B = 255, G = 255, R = 255, A = 255}
        m_bCollisionDirty = TRUE
    }
};

var transient array<SFXCameraMode> CameraModes;
var transient SFXCameraNativeBaseTraceInfo m_aTraceInfo;
var transient Rotator AdditiveRotation;
var transient Rotator SubtractiveRotation;
var transient Vector2D CameraStick;
var transient Vector2D MovementStick;
var transient SFXCameraMode CurrentCameraMode;
var transient SFXCameraMode LastGoodMode;
var transient float AspectRatio;
var transient bool bDisabled;
var bool m_bIgnoreSlowMo;
var bool m_bCameraSwitchEnabled;
var bool bUseCameraRotation;

public event function AddScreenShake(ScreenShakeStruct Shake);

protected final native function float BioAdjustFOVForViewport(float inHorizFOV, Pawn CameraTargetPawn);

public event function CreateIPECommands(BioInGamePropertyEditor IPE, BioPropertyEditorBaseNode Parent)
{
    local BioPropertyEditorPropertyNode oControlNode;
    local SFXCameraMode mode;
    
    foreach CameraModes(mode, )
    {
        oControlNode = new (IPE) Class'BioPropertyEditorPropertyNode';
        oControlNode.m_sNodeDisplayName = string(mode.Name);
        oControlNode.m_oParent = Parent;
        if (mode == CurrentCameraMode)
        {
            oControlNode.m_sDeliminator = " - ";
            oControlNode.m_sValueString = "Current";
        }
        else
        {
            oControlNode.m_sDeliminator = "";
        }
        oControlNode.SetObject(mode);
        oControlNode.MakeNodes("");
        Parent.m_aChildren.AddItem(oControlNode);
    }
}
public final native function Rotator GetRotation();

public final native function bool GetTrace(out Actor oHit, out Vector vLocation, out Vector vNormal);

public final native function Actor LineCheck(out TraceHitInfo HitInfo, out Vector HitLocation, out Vector HitNormal, const out Vector TraceEnd, optional bool TraceActors, optional Vector Extent, optional int ExtraTraceFlags);

public simulated native function CameraAnimInst PlayCameraAnimEx(CameraAnim Anim, optional float Rate = 1.0, optional float Scale = 1.0, optional float StartTime, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional float Duration, optional bool bSingleInstance);

public final native function ResetHiddenActors();

public native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

public final native function TraceCamera(out TViewTarget VT);

public native function Vector WorldToCanonicalScreen(const out Vector vWorldLoc);

public native function Vector WorldToScreenSnapToEdge(const out Vector vWorldLoc, float i_fSafeZoneX, float i_fSafeZoneY);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aTraceInfo = {
                    m_vCollVectorLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                    m_vCollVectorNormal = {X = 0.0, Y = 0.0, Z = 0.0}, 
                    m_oCollVectorActor = None, 
                    m_clrDebugDraw = {B = 255, G = 255, R = 255, A = 255}, 
                    m_bCollDetected = FALSE, 
                    m_bCollisionDirty = TRUE, 
                    m_bDebugDraw = FALSE
                   }
    m_bIgnoreSlowMo = TRUE
}