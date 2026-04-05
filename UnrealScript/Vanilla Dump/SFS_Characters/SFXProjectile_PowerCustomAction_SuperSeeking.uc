Class SFXProjectile_PowerCustomAction_SuperSeeking extends SFXProjectile_PowerCustomAction_Seeking
    config(Game);

var Vector2D DownwardPitchScale;
var Vector2D DownwardPitchScaleRange;
var float CornerStrength;
var float ApexDist;
var float MaxAngleOffset;
var float OffsetAimMaxDistance;
var float OffsetAimMinDistance;

public simulated function TickAimRotation(float DeltaTime, Vector SeekVector)
{
    local float Factor;
    local Quat Q;
    
    Factor = FMax(VSize(SeekVector) - ApexDist, 1.0) ** CornerStrength;
    Q = QuatSlerp(StartRotation, QuatFromRotator(Rotator(SeekVector)), FClamp(InterpRate / Factor, 0.0, UpperBound), TRUE);
    StartRotation = Q;
    SetRotation(QuatToRotator(Q));
}
public function InitializeRotation(Pawn oCasterPawn)
{
    local BioPlayerController PC;
    local float fAngle;
    local Vector vToTarget;
    local Rotator rToTarget;
    local Rotator rDeltaRot;
    local Quat qToTarget;
    local Quat qCameraRot;
    local Quat qDeltaRot;
    local float fPitchRatio;
    local Quat AimOffset;
    local float fAimScale;
    
    if (oCasterPawn != None && TargetActor != None)
    {
        PC = BioPlayerController(oCasterPawn.Controller);
        if (PC != None && Role == ENetRole.ROLE_Authority)
        {
            if (IsZero(CameraLocation))
            {
                if (PC.IsLocalPlayerController() == TRUE)
                {
                    CameraLocation = PC.PlayerCamera.CameraCache.POV.location;
                    CameraRotation = PC.PlayerCamera.CameraCache.POV.Rotation;
                }
                else
                {
                    CameraLocation = PC.RemoteCameraLocation;
                    CameraRotation = PC.RemoteCameraRotation;
                }
            }
            qCameraRot = QuatFromRotator(CameraRotation);
            vToTarget = TargetLocation - CameraLocation;
            rToTarget = Rotator(vToTarget);
            qToTarget = QuatFromRotator(rToTarget);
            qDeltaRot = QuatProduct(QuatInvert(qCameraRot), qToTarget);
            rDeltaRot = QuatToRotator(qDeltaRot);
            qDeltaRot = QuatFromRotator(rDeltaRot);
            fAimScale = FClamp(OffsetAimMaxDistance - VSize(vToTarget), 0.0, OffsetAimMaxDistance - OffsetAimMinDistance) / (OffsetAimMaxDistance - OffsetAimMinDistance);
            if (rDeltaRot.Pitch > 0)
            {
                fPitchRatio = (FClamp(TargetActor.location.Z - oCasterPawn.location.Z, DownwardPitchScaleRange.X, DownwardPitchScaleRange.Y) - DownwardPitchScaleRange.X) / (DownwardPitchScaleRange.Y - DownwardPitchScaleRange.X);
                rDeltaRot.Pitch = int(Lerp(0.0, float(rDeltaRot.Pitch), Lerp(DownwardPitchScale.X, DownwardPitchScale.Y, fPitchRatio)));
                qDeltaRot = QuatFromRotator(rDeltaRot);
            }
            AimOffset = QuatSlerp(qDeltaRot, QuatInvert(qDeltaRot), fAimScale, TRUE);
            qCameraRot = QuatProduct(qCameraRot, AimOffset);
            SetRotation(QuatToRotator(qCameraRot));
            fAngle = GetAngleBetween(Vector(Rotation), Vector(CameraRotation));
            if (fAngle > MaxAngleOffset)
            {
                SetRotation(QuatToRotator(QuatSlerp(QuatFromRotator(CameraRotation), QuatFromRotator(Rotation), MaxAngleOffset / fAngle)));
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    DownwardPitchScale = {X = -0.75, Y = -1.0}
    DownwardPitchScaleRange = {X = 0.0, Y = 200.0}
    CornerStrength = 2.0
    ApexDist = 100.0
    MaxAngleOffset = 0.200000003
    OffsetAimMaxDistance = 5000.0
    OffsetAimMinDistance = 2000.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}