Class BioCameraBehaviorFlourish extends BioCameraBehavior;

const UUCircle = 65535.99999999984;

var Vector CameraHook;
var float ZOffset;
var float SpeedYaw;
var float DesiredPitch;
var float SpeedPitch;
var float DesiredDistance;
var float SpeedDistance;
var float fPitchDir;
var float fDesiredPitch;

public function Vector GetCameraLocation()
{
    return m_pov.location;
}
public function Initialize()
{
    CameraHook = ViewTarget.Target.GetPrimarySkelMeshComponent().GetBoneLocation('God');
    m_pov.location = CameraHook;
    fDesiredPitch = DesiredPitch * 182.044449;
    fPitchDir = 1.0;
    if (float(m_pov.Rotation.Pitch) > fDesiredPitch || float(m_pov.Rotation.Pitch) < fDesiredPitch - 65536.0 / float(2))
    {
        fPitchDir = -1.0;
    }
}
public function Tick(float TimeDelta)
{
    local float fCurrentYaw;
    local float fCurrentPitch;
    local float fPitchAdj;
    local float fRange;
    local float fRangeAdj;
    local float fRangeDir;
    local Vector vDirection;
    
    CameraHook = ViewTarget.Target.GetPrimarySkelMeshComponent().GetBoneLocation('God');
    fCurrentYaw = float(m_pov.Rotation.Yaw);
    fCurrentYaw += SpeedYaw * 182.044449 * TimeDelta;
    fCurrentPitch = float(m_pov.Rotation.Pitch);
    if (Abs(fCurrentPitch - fDesiredPitch) < float(1))
    {
        fCurrentPitch = fDesiredPitch;
    }
    else
    {
        fPitchAdj = SpeedPitch * 182.044449 * TimeDelta;
        fCurrentPitch += fPitchDir * fPitchAdj;
        if (fCurrentPitch > 65536.0)
        {
            fCurrentPitch -= 65536.0;
        }
        if (fCurrentPitch < float(0))
        {
            fCurrentPitch += 65536.0;
        }
        if (Abs(fCurrentPitch - fDesiredPitch) < fPitchAdj)
        {
            fCurrentPitch = fDesiredPitch;
        }
    }
    vDirection = m_pov.location;
    vDirection -= CameraHook;
    fRange = VSize(vDirection);
    fRangeAdj = SpeedDistance * TimeDelta;
    fRangeDir = 1.0;
    if (fRange > DesiredDistance)
    {
        fRangeDir = -1.0;
    }
    if (Abs(fRange - DesiredDistance) < Abs(fRangeAdj))
    {
        fRangeAdj = Abs(fRange - DesiredDistance);
    }
    fRange += fRangeDir * fRangeAdj;
    m_pov.Rotation.Yaw = int(fCurrentYaw);
    m_pov.Rotation.Pitch = int(fCurrentPitch);
    m_pov.Rotation.Roll = 0;
    m_pov.location = CameraHook - Vector(m_pov.Rotation) * fRange;
    m_pov.FOV = FOV;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    ZOffset = 200.0
    SpeedYaw = 15.0
    DesiredPitch = 315.0
    SpeedPitch = 40.0
    DesiredDistance = 300.0
    SpeedDistance = 50.0
    FOV = 80.0
    Input = s_Input
    bAllowSpectate = FALSE
}