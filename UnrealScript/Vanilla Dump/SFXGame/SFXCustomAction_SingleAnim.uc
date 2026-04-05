Class SFXCustomAction_SingleAnim extends BioCustomAction
    abstract
    config(Game);

var(SFXCustomAction_SingleAnim) BodyStance BS_Anim;
var(SFXCustomAction_SingleAnim) float fAnimPlayRate;
var(SFXCustomAction_SingleAnim) float fAnimBlendInTime;
var(SFXCustomAction_SingleAnim) float fAnimBlendOutTime;
var(SFXCustomAction_SingleAnim) float fAnimStartTime;
var(SFXCustomAction_SingleAnim) float fAnimDuration;
var(SFXCustomAction_SingleAnim) bool bAllowAnimInterrupt;
var(SFXCustomAction_SingleAnim) const bool bResetPhysics;
var(SFXCustomAction_SingleAnim) ERootMotionMode ERootMotionMode;
var(SFXCustomAction_SingleAnim) ERootMotionRotationMode ERootMotionRotationMode;
var(SFXCustomAction_SingleAnim) ERootBoneAxis RootBoneX;
var(SFXCustomAction_SingleAnim) ERootBoneAxis RootBoneY;
var(SFXCustomAction_SingleAnim) ERootBoneAxis RootBoneZ;
var AlphaBlendType StartBlendType;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Anim, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local BodyStance BS_ToPlay;
    
    Super.StartCustomAction();
    BS_ToPlay = GetBodyStanceAnim();
    ApplyTimeline(TimelineTemplate, m_oPawn);
    if (bResetPhysics && m_oPawn.Physics == EPhysics.PHYS_PathApproximation)
    {
        m_oPawn.SetPhysics(1);
        m_oPawn.LastPhysicsSetter = Outer;
    }
    if (m_oPawn.PlayBodyStance(BS_ToPlay, fAnimPlayRate, fAnimBlendInTime, fAnimBlendOutTime, , FALSE, , fAnimStartTime, StartBlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, TRUE);
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode;
        if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, RootBoneX, RootBoneY, RootBoneZ);
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        m_oPawn.Mesh.RootMotionRotationMode = ERootMotionRotationMode;
        if (ERootMotionRotationMode != ERootMotionRotationMode.RMRM_Ignore)
        {
            m_oPawn.SetBodyStanceRootRotationOption(BS_ToPlay, 0, 2, 0);
        }
        if (fAnimDuration > 0.0)
        {
            m_oPawn.SetTimer(fAnimDuration, FALSE, 'OnCustomActionTimeUp', Self);
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local BodyStance BS_ToPlay;
    
    BS_ToPlay = GetBodyStanceAnim();
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, 1, 1, 1);
    }
    EndThisCustomAction();
}
public function BodyStance GetBodyStanceAnim()
{
    return BS_Anim;
}
public function OnCustomActionTimeUp()
{
    local BodyStance BS_ToPlay;
    
    BS_ToPlay = GetBodyStanceAnim();
    if (bAllowAnimInterrupt)
    {
        EndThisCustomAction();
    }
    else
    {
        m_oPawn.SetBodyStanceAnimLooping(BS_ToPlay, FALSE);
    }
}
public function StopCustomAction()
{
    local BodyStance BS_ToPlay;
    
    BS_ToPlay = GetBodyStanceAnim();
    Super.StopCustomAction();
    m_oPawn.ClearTimer('OnCustomActionTimeUp', Self);
    RemoveTimeline();
    m_oPawn.StopBodyStance(BS_ToPlay, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, FALSE);
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, 1, 1, 1);
    }
    if (ERootMotionRotationMode != ERootMotionRotationMode.RMRM_Ignore)
    {
        m_oPawn.Mesh.RootMotionRotationMode = m_oPawn.Mesh.default.RootMotionRotationMode;
        m_oPawn.SetBodyStanceRootRotationOption(BS_ToPlay, 1, 1, 1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fAnimPlayRate = 1.0
    fAnimBlendInTime = 0.200000003
    fAnimBlendOutTime = 0.200000003
    bAllowAnimInterrupt = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Ignore
    RootBoneX = ERootBoneAxis.RBA_Translate
    RootBoneY = ERootBoneAxis.RBA_Translate
    RootBoneZ = ERootBoneAxis.RBA_Discard
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bNotifyKnockedOutOfCover = TRUE
    Priority = ECustomActionPriority.CA_Priority_Medium
}