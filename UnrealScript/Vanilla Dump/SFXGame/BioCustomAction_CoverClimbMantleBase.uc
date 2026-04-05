Class BioCustomAction_CoverClimbMantleBase extends BioCustomAction
    config(Game);

enum ECoverBodyStanceID
{
    ECS_None,
    ECS_FromExplore,
    ECS_FromCombat,
    ECS_FromCover,
};

var(BioCustomAction_CoverClimbMantleBase) BodyStance m_BS_StanceFromExplore;
var(BioCustomAction_CoverClimbMantleBase) BodyStance m_BS_StanceFromCombat;
var(BioCustomAction_CoverClimbMantleBase) BodyStance m_BS_StanceFromCover;
var float m_fCollisionOffPerioud;
var transient float m_fCollisionOffTime;
var bool bWasInCover;
var ECoverBodyStanceID m_CurrentBodyStance;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.m_BS_StanceFromExplore, UsedAnims);
    GetAnimsUsedByBodyStance(default.m_BS_StanceFromCombat, UsedAnims);
    GetAnimsUsedByBodyStance(default.m_BS_StanceFromCover, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local bool bPlaySuccess;
    
    m_oPawn.SetCollision(m_oPawn.bCollideActors, FALSE, );
    m_fCollisionOffTime = 0.0;
    bWasInCover = m_oPawn.IsInCover();
    if (m_oPawn.bRecentlyTookCover && m_oPawn.bStorming == FALSE)
    {
        bWasInCover = FALSE;
    }
    Super.StartCustomAction();
    if (m_CurrentBodyStance != ECoverBodyStanceID.ECS_None)
    {
        StopCustomAction();
    }
    if (bWasInCover)
    {
        bPlaySuccess = StartPlayBodyStance(3);
    }
    else if (!m_oPawn.bCombatPawn)
    {
        bPlaySuccess = StartPlayBodyStance(1);
    }
    else if (m_oPawn.bCombatPawn)
    {
        bPlaySuccess = StartPlayBodyStance(2);
    }
    if (bPlaySuccess)
    {
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
        m_oPawn.Mesh.bRootMotionModeChangeNotify = TRUE;
        m_oPawn.SetPhysics(0);
        m_oPawn.LastPhysicsSetter = Self;
        m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
    }
}
public event function TickCustomAction(float fDeltaTime)
{
    Super.TickCustomAction(fDeltaTime);
    m_fCollisionOffTime += fDeltaTime;
    if (m_fCollisionOffTime > m_fCollisionOffPerioud)
    {
        m_oPawn.SetCollision(m_oPawn.bCollideActors, TRUE, );
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    EndPlayBodyStance(m_CurrentBodyStance);
    EndThisCustomAction();
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    if (m_oPawn.LastPhysicsSetter == Self)
    {
        m_oPawn.SetPhysics(1);
    }
}
private final function EndPlayBodyStance(ECoverBodyStanceID StanceID)
{
    local BodyStance Stance;
    
    if (GetBodyStance(StanceID, Stance))
    {
        m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
    }
}
private final function bool GetBodyStance(ECoverBodyStanceID StanceID, out BodyStance out_BodyStance)
{
    switch (StanceID)
    {
        case ECoverBodyStanceID.ECS_FromExplore:
            out_BodyStance = m_BS_StanceFromExplore;
            return TRUE;
        case ECoverBodyStanceID.ECS_FromCombat:
            out_BodyStance = m_BS_StanceFromCombat;
            return TRUE;
        case ECoverBodyStanceID.ECS_FromCover:
            out_BodyStance = m_BS_StanceFromCover;
            return TRUE;
        default:
    }
    return FALSE;
}
private final function bool StartPlayBodyStance(ECoverBodyStanceID StanceID)
{
    local BodyStance Stance;
    local float fBlendOutTime;
    
    if (GetBodyStance(StanceID, Stance))
    {
        if (m_oPawn.IsPlayerPawn())
        {
            fBlendOutTime = 1.0;
        }
        m_CurrentBodyStance = StanceID;
        if (m_oPawn.PlayBodyStance(Stance, 1.0, 0.200000003, fBlendOutTime) != 0.0)
        {
            m_oPawn.SetBodyStanceAnimEndNotification(Stance, TRUE);
            m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 2, 2, 2);
            return TRUE;
        }
    }
    return FALSE;
}
public function StopCustomAction()
{
    m_oPawn.SetCollision(m_oPawn.bCollideActors, TRUE, );
    EndPlayBodyStance(m_CurrentBodyStance);
    StopPlayBodyStance(m_CurrentBodyStance);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    if (m_oPawn.LastPhysicsSetter == Self)
    {
        m_oPawn.SetPhysics(1);
    }
    Super.StopCustomAction();
}
private final function StopPlayBodyStance(ECoverBodyStanceID StanceID)
{
    local BodyStance Stance;
    
    if (GetBodyStance(StanceID, Stance))
    {
        m_oPawn.StopBodyStance(Stance, 0.100000001);
        m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
        m_CurrentBodyStance = ECoverBodyStanceID.ECS_None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fCollisionOffPerioud = 0.400000006
    AICommand = Class'SFXAICmd_CA_CoverMantleClimbBase'
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    bForceLocalSimulation = TRUE
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}