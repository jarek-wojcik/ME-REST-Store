Class SFXCameraMode_AIDebug extends SFXCameraMode;

var(SFXCameraMode_AIDebug) array<Vector> HookOffsetList;
var(SFXCameraMode_AIDebug) int CurrentOffsetIdx;
var(SFXCameraMode_AIDebug) int NewOffsetIdx;
var(SFXCameraMode_AIDebug) float BlendTimeRemaining;
var(SFXCameraMode_AIDebug) const float TotalBlendTime;

public function Tick(float TimeSeconds)
{
    local float DurationPct;
    local float BlendPct;
    local Pawn P;
    
    Super.Tick(TimeSeconds);
    m_pov.Rotation.Pitch = -16384;
    m_pov.Rotation.Yaw = 0;
    m_pov.Rotation.Roll = 0;
    if (NewOffsetIdx != CurrentOffsetIdx)
    {
        BlendTimeRemaining -= TimeSeconds;
        if (BlendTimeRemaining > float(0))
        {
            DurationPct = 1.0 - BlendTimeRemaining / TotalBlendTime;
            BlendPct = FCubicInterp(0.0, 0.0, 1.0, 0.0, DurationPct);
            HookOffset = VLerp(HookOffsetList[CurrentOffsetIdx], HookOffsetList[NewOffsetIdx], BlendPct);
        }
        else
        {
            CurrentOffsetIdx = NewOffsetIdx;
            BlendTimeRemaining = 0.0;
        }
    }
    P = GetViewTargetAsPawn();
    if (P != None)
    {
        BioWorldInfo(P.WorldInfo).SetRenderStateOfPlayer(0, HookOffset.Z - P.CylinderComponent.CollisionHeight * 5.0);
    }
}
private final function ChangeOffset(int idx)
{
    if (idx >= 0 && idx < HookOffsetList.Length && idx != CurrentOffsetIdx && BlendTimeRemaining == float(0))
    {
        BlendTimeRemaining = TotalBlendTime;
        NewOffsetIdx = idx;
    }
}
public function DecOffset()
{
    ChangeOffset(CurrentOffsetIdx - 1);
}
public function IncOffset()
{
    ChangeOffset(CurrentOffsetIdx + 1);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    HookOffsetList = ({X = 0.0, Y = 0.0, Z = 500.0}, 
                      {X = 0.0, Y = 0.0, Z = 1000.0}, 
                      {X = 0.0, Y = 0.0, Z = 2000.0}, 
                      {X = 0.0, Y = 0.0, Z = 3000.0}, 
                      {X = 0.0, Y = 0.0, Z = 4000.0}, 
                      {X = 0.0, Y = 0.0, Z = 5000.0}
                     )
    CurrentOffsetIdx = 4
    NewOffsetIdx = 4
    TotalBlendTime = 1.0
    HookOffset = {X = 0.0, Y = 0.0, Z = 4000.0}
    HookName = 'Root'
    Input = s_Input
    bCollisionEnabled = FALSE
}