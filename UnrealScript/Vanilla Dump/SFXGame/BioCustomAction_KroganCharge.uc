Class BioCustomAction_KroganCharge extends BioCustomAction
    native
    config(Game);

enum EKroganChargeActions
{
    EKC_Start,
    EKC_Miss,
    EKC_Hit,
};

var(BioCustomAction_KroganCharge) BodyStance BS_Start;
var(BioCustomAction_KroganCharge) BodyStance BS_Miss;
var(BioCustomAction_KroganCharge) BodyStance BS_Hit;
var transient array<Actor> m_oHitTargets;
var transient Actor m_oChargeTarget;
var transient bool m_bHitTarget;
var transient EKroganChargeActions m_ChargeAction;
var transient EKroganChargeActions m_NextAction;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Start, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_Miss, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_Hit, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    m_ChargeAction = EKroganChargeActions.EKC_Start;
    m_NextAction = EKroganChargeActions.EKC_Miss;
    if (m_oPawn.PlayBodyStance(BS_Start, 1.0, 0.200000003, 0.0) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 2, 2);
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Accel;
        m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local BodyStance Stance;
    
    if (m_ChargeAction == EKroganChargeActions.EKC_Start)
    {
        m_ChargeAction = m_NextAction;
        Stance = GetBodyStance(m_NextAction);
        if (m_oPawn.PlayBodyStance(Stance, 1.0, 0.0, 0.0) != 0.0)
        {
            m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, FALSE);
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 1, 1, 1);
            m_oPawn.SetBodyStanceAnimEndNotification(Stance, TRUE);
            m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 2, 2);
        }
    }
    else
    {
        Stance = GetBodyStance(m_ChargeAction);
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
        EndThisCustomAction();
    }
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function BodyStance GetBodyStance(EKroganChargeActions eAction)
{
    switch (eAction)
    {
        case EKroganChargeActions.EKC_Start:
            return BS_Start;
            break;
        case EKroganChargeActions.EKC_Miss:
            return BS_Miss;
            break;
        case EKroganChargeActions.EKC_Hit:
            return BS_Hit;
            break;
        default:
    }
}
public function bool PlayHitAnim(Actor oHitTarget)
{
    if (m_oHitTargets.Find(oHitTarget) == -1)
    {
        m_NextAction = EKroganChargeActions.EKC_Hit;
        m_bHitTarget = TRUE;
        m_oHitTargets.AddItem(oHitTarget);
        return TRUE;
    }
    return FALSE;
}
public function StopCustomAction()
{
    local BodyStance Stance;
    local float fBlendOutTime;
    
    Super.StopCustomAction();
    Stance = GetBodyStance(m_ChargeAction);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    switch (m_ChargeAction)
    {
        case EKroganChargeActions.EKC_Start:
            fBlendOutTime = 0.200000003;
            break;
        case EKroganChargeActions.EKC_Miss:
        case EKroganChargeActions.EKC_Hit:
            fBlendOutTime = 0.100000001;
            break;
        default:
    }
    m_oPawn.StopBodyStance(Stance, fBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
    m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
    m_oChargeTarget = None;
    m_bHitTarget = FALSE;
    m_oHitTargets.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start = {
                AnimName = ('SM_ChargeStart')
               }
    BS_Miss = {
               AnimName = ('SM_ChargeEnd_Miss')
              }
    BS_Hit = {
              AnimName = ('SM_ChargeEnd_Hit')
             }
    AICommand = Class'SFXAICmd_CA_KroganCharge'
}