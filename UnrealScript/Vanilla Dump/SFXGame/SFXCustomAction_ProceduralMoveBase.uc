Class SFXCustomAction_ProceduralMoveBase extends BioCustomAction
    native
    config(Game);

enum EMoveStage
{
    EMS_Sync,
    EMS_Start,
    EMS_Loop,
    EMS_End,
};

var(SFXCustomAction_ProceduralMoveBase) BodyStance BS_Start;
var(SFXCustomAction_ProceduralMoveBase) BodyStance BS_Loop;
var(SFXCustomAction_ProceduralMoveBase) BodyStance BS_End;
var Vector Destination;
var float fEndAnimDist;
var float fStartBlendInTime;
var float fStartBlendOutTime;
var float fLoopBlendInTime;
var float fLoopBlendOutTime;
var float fEndBlendInTime;
var float fEndBlendOutTime;
var float fStartAnimPlayRate;
var float fEndAnimPlayRate;
var float fLoopTimeout;
var const bool bAlignPawnBeforeMove;
var bool bPlayedEndAnim;
var bool bDelayReplication;
var EMoveStage MoveStage;
var AlphaBlendType StartBlendType;
var AlphaBlendType LoopBlendType;
var AlphaBlendType EndBlendType;
var ERootBoneAxis StartRootBoneX;
var ERootBoneAxis StartRootBoneY;
var ERootBoneAxis StartRootBoneZ;
var ERootBoneAxis EndRootBoneX;
var ERootBoneAxis EndRootBoneY;
var ERootBoneAxis EndRootBoneZ;
var ERootMotionMode StartRMM;
var ERootMotionMode EndRMM;
var ERootRotationOption StartRootRotationPitch;
var ERootRotationOption StartRootRotationYaw;
var ERootRotationOption StartRootRotationRoll;
var ERootRotationOption EndRootRotationPitch;
var ERootRotationOption EndRootRotationYaw;
var ERootRotationOption EndRootRotationRoll;
var ERootMotionRotationMode StartRMRM;
var ERootMotionRotationMode EndRMRM;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Start, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_Loop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_End, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public event function PlayEndAnimation()
{
    local BodyStance EndStance;
    local BodyStance CurrentStance;
    local float BlendOutTime;
    
    GetEndAnim(EndStance);
    switch (MoveStage)
    {
        case EMoveStage.EMS_Start:
            GetStartAnim(CurrentStance);
            BlendOutTime = fStartBlendOutTime;
            break;
        case EMoveStage.EMS_Loop:
            GetLoopAnim(CurrentStance);
            BlendOutTime = fLoopBlendOutTime;
            break;
        case EMoveStage.EMS_End:
            return;
        default:
    }
    SetMoveStage(3);
    bPlayedEndAnim = TRUE;
    if (m_oPawn.PlayBodyStance(EndStance, fEndAnimPlayRate, fEndBlendInTime, fEndBlendOutTime, , , , , EndBlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(CurrentStance, FALSE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(CurrentStance, 1, 1, 1);
        m_oPawn.SetBodyStanceRootRotationOption(CurrentStance, 1, 1, 1);
        m_oPawn.StopBodyStance(CurrentStance, BlendOutTime);
        m_oPawn.SetBodyStanceAnimEndNotification(EndStance, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(EndStance, EndRootBoneX, EndRootBoneY, EndRootBoneZ);
        m_oPawn.SetBodyStanceRootRotationOption(EndStance, EndRootRotationPitch, EndRootRotationYaw, EndRootRotationRoll);
        m_oPawn.Mesh.RootMotionMode = EndRMM;
        m_oPawn.Mesh.RootMotionRotationMode = EndRMRM;
    }
}
public event function ReachedPrecisePosition()
{
    if (MoveStage == EMoveStage.EMS_Sync)
    {
        if (bDelayReplication)
        {
            bDelayReplication = FALSE;
            if (ShouldReplicate())
            {
                Replicate();
            }
        }
        PlayStartAnimation();
    }
}
public function StartCustomAction()
{
    if (bAlignPawnBeforeMove == TRUE && !bForceLocalSimulation)
    {
        bDelayReplication = TRUE;
    }
    else
    {
        bDelayReplication = FALSE;
    }
    Super.StartCustomAction();
    bPlayedEndAnim = FALSE;
    if (bAlignPawnBeforeMove && (m_oPawn.Role > ENetRole.ROLE_SimulatedProxy || bForceLocalSimulation))
    {
        SetMoveStage(0);
        PreAlignPawnLocation();
    }
    else
    {
        PlayStartAnimation();
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local bool bContinueMove;
    local float fDistToEnd;
    local float fBlendInTime;
    local float fBlendOutTime;
    local BodyStance StartStance;
    local BodyStance Stance;
    local bool bLooping;
    local ERootBoneAxis RBA_X;
    local ERootBoneAxis RBA_Y;
    local ERootBoneAxis RBA_Z;
    local ERootRotationOption RRO_P;
    local ERootRotationOption RRO_Y;
    local ERootRotationOption RRO_R;
    
    bContinueMove = FALSE;
    if (MoveStage == EMoveStage.EMS_Start)
    {
        bContinueMove = TRUE;
        GetStartAnim(Stance);
        m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
        fDistToEnd = VSize(m_oPawn.location - Destination);
        if (fDistToEnd < fEndAnimDist)
        {
            SetMoveStage(3);
            GetEndAnim(Stance);
            bLooping = FALSE;
            bPlayedEndAnim = TRUE;
            m_oPawn.Mesh.RootMotionMode = EndRMM;
            fBlendInTime = GetBlendInTime();
            fBlendOutTime = GetBlendOutTime();
            RBA_X = EndRootBoneX;
            RBA_Y = EndRootBoneY;
            RBA_Z = EndRootBoneZ;
            RRO_P = EndRootRotationPitch;
            RRO_Y = EndRootRotationYaw;
            RRO_R = EndRootRotationRoll;
        }
        else
        {
            SetMoveStage(2);
            GetLoopAnim(Stance);
            bLooping = TRUE;
            fBlendInTime = fLoopBlendInTime;
            fBlendOutTime = fLoopBlendOutTime;
            m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Ignore;
            RBA_X = ERootBoneAxis.RBA_Default;
            RBA_Y = ERootBoneAxis.RBA_Default;
            RBA_Z = ERootBoneAxis.RBA_Default;
            RRO_P = ERootRotationOption.RRO_Default;
            RRO_Y = ERootRotationOption.RRO_Default;
            RRO_R = ERootRotationOption.RRO_Default;
            if (fLoopTimeout > 0.0)
            {
                m_oPawn.SetTimer(fLoopTimeout, FALSE, 'DestTimeout', Self);
            }
        }
        if (m_oPawn.PlayBodyStance(Stance, 1.0, fBlendInTime, fBlendOutTime, bLooping, , , , LoopBlendType) != 0.0)
        {
            GetStartAnim(StartStance);
            m_oPawn.SetBodyStanceAnimEndNotification(StartStance, FALSE);
            m_oPawn.SetBodyStanceRootBoneAxisOption(StartStance, 1, 1, 1);
            m_oPawn.SetBodyStanceRootRotationOption(Stance, 1, 1, 1);
            m_oPawn.SetBodyStanceAnimEndNotification(Stance, TRUE);
            m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, RBA_X, RBA_Y, RBA_Z);
            m_oPawn.SetBodyStanceRootRotationOption(Stance, RRO_P, RRO_Y, RRO_R);
        }
    }
    else if (MoveStage == EMoveStage.EMS_End)
    {
        GetEndAnim(Stance);
        m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
        m_oPawn.SetBodyStanceRootRotationOption(Stance, 1, 1, 1);
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.Mesh.RootMotionRotationMode = m_oPawn.Mesh.default.RootMotionRotationMode;
    }
    if (!bContinueMove)
    {
        EndThisCustomAction();
    }
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function DestTimeout()
{
    if (MoveStage == EMoveStage.EMS_Loop)
    {
        PlayEndAnimation();
    }
}
public function float GetBlendInTime()
{
    return fEndBlendInTime;
}
public function float GetBlendOutTime()
{
    return fEndBlendOutTime;
}
public function GetEndAnim(out BodyStance Stance)
{
    Stance = BS_End;
}
public function GetLoopAnim(out BodyStance Stance)
{
    Stance = BS_Loop;
}
public function GetStartAnim(out BodyStance Stance)
{
    Stance = BS_Start;
}
public function PlayStartAnimation()
{
    local BodyStance StartStance;
    
    SetMoveStage(1);
    GetStartAnim(StartStance);
    if (m_oPawn.PlayBodyStance(StartStance, fStartAnimPlayRate, fStartBlendInTime, fStartBlendOutTime, , , , , StartBlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(StartStance, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(StartStance, StartRootBoneX, StartRootBoneY, StartRootBoneZ);
        m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        m_oPawn.Mesh.RootMotionMode = StartRMM;
        m_oPawn.SetBodyStanceRootRotationOption(StartStance, StartRootRotationPitch, StartRootRotationYaw, StartRootRotationRoll);
        m_oPawn.Mesh.RootMotionRotationMode = StartRMRM;
    }
}
public function PreAlignPawnLocation();

public function SetMoveStage(EMoveStage NextStage)
{
    MoveStage = NextStage;
}
public function bool ShouldReplicate()
{
    if (bDelayReplication)
    {
        return FALSE;
    }
    return Super.ShouldReplicate();
}
public function StopCustomAction()
{
    local BodyStance Stance;
    local float fBlendOutTime;
    
    Super.StopCustomAction();
    switch (MoveStage)
    {
        case EMoveStage.EMS_Start:
            GetStartAnim(Stance);
            fBlendOutTime = fStartBlendOutTime;
            break;
        case EMoveStage.EMS_Loop:
            GetLoopAnim(Stance);
            fBlendOutTime = fLoopBlendOutTime;
            break;
        case EMoveStage.EMS_End:
            GetEndAnim(Stance);
            fBlendOutTime = fEndBlendOutTime;
            break;
        default:
    }
    m_oPawn.ClearTimer('DestTimeout', Self);
    m_oPawn.StopBodyStance(Stance, fBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
    m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
    m_oPawn.SetBodyStanceRootRotationOption(Stance, 1, 1, 1);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    m_oPawn.Mesh.RootMotionRotationMode = m_oPawn.Mesh.default.RootMotionRotationMode;
    m_oPawn.StopMovement(TRUE);
    if (MoveStage == EMoveStage.EMS_End)
    {
        if (m_oAI != None && m_oAI.MoveTarget != None && m_oPawn.Physics != EPhysics.PHYS_RigidBody)
        {
            if (VSize(m_oPawn.location - m_oAI.MoveTarget.location) < VSize(m_oPawn.location - m_oPawn.Anchor.location))
            {
                m_oAI.ReachedMoveTarget();
                m_oAI.UpdateMovementFocus();
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fStartBlendInTime = 0.100000001
    fStartBlendOutTime = 0.100000001
    fLoopBlendInTime = 0.100000001
    fLoopBlendOutTime = 0.100000001
    fEndBlendInTime = 0.100000001
    fEndBlendOutTime = 0.100000001
    fStartAnimPlayRate = 1.0
    fEndAnimPlayRate = 1.0
    StartRootBoneX = ERootBoneAxis.RBA_Translate
    StartRootBoneY = ERootBoneAxis.RBA_Translate
    StartRootBoneZ = ERootBoneAxis.RBA_Translate
    EndRootBoneX = ERootBoneAxis.RBA_Translate
    EndRootBoneY = ERootBoneAxis.RBA_Translate
    EndRootBoneZ = ERootBoneAxis.RBA_Translate
    StartRMM = ERootMotionMode.RMM_Accel
    EndRMM = ERootMotionMode.RMM_Velocity
    bDisableMovement = TRUE
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}