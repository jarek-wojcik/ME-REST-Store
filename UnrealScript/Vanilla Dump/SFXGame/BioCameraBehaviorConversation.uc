Class BioCameraBehaviorConversation extends BioCameraBehavior
    native
    config(Game);

const DEFAULT_NEAR_CLIP_PLANE = 10.0f;
const DEFAULT_CAMERA_FOV = 52.9f;

var Vector m_vFixedCamPosition;
var Rotator m_rFixedCamRotation;
var Vector m_vProceduralCamPosition;
var Rotator m_rProceduralCamRotation;
var BioStageDOFData m_tDOFData;
var Rotator m_rRotationOffset;
var Actor ViewSource;
var Actor Target;
var float m_fNearPlane;
var float CAMERA_FOV;
var float m_fLateralOffset;
var AnimSet m_pIdleCamAnimSet;
var float m_fIdleCamTimeIndex;
var int m_idleCamAnimIndex;
var transient bool m_bDOFSettingDisabled;
var config bool m_bIdleCamEnabled;

public native function ForcePOV();

public function Initialize()
{
    Super(SFXCameraMode).Initialize();
    m_fIdleCamTimeIndex = 0.0;
}
public native function InternalModifyPostProcessSettings(out PostProcessSettings PPSettings);

public event function ModifyPostProcessSettings(out PostProcessSettings PPSettings)
{
    Super(SFXCameraMode).ModifyPostProcessSettings(PPSettings);
    InternalModifyPostProcessSettings(PPSettings);
}
public function Reset()
{
    ForcePOV();
}
public native function ShutDown();

public native function Tick(float TimeDelta);

public function MakeInactive()
{
    local PlayerController PC;
    
    PC = PlayerController(GetViewTargetAsController());
    if (PC != None)
    {
        BioWorldInfo(PC.WorldInfo).SetRenderStateOfPlayerToDefault(0);
    }
    ShutDown();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    m_tDOFData = {fFocusInnerRadius = 600.0, fFocusDistance = 600.0, bEnable = FALSE}
    m_rRotationOffset = {Pitch = 0, Yaw = -3700, Roll = 0}
    m_fNearPlane = 10.0
    CAMERA_FOV = 52.9000015
    m_fLateralOffset = 25.0
    m_pIdleCamAnimSet = AnimSet'BIOG_CAM_FX_A.CAM_FX_Dialog'
    m_idleCamAnimIndex = 1
    Input = s_Input
    bIsCameraShakeEnabled = FALSE
    bCollisionEnabled = FALSE
    bConstrainAspectRatio = TRUE
}