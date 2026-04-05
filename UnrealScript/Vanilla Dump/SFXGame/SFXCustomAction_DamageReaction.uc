Class SFXCustomAction_DamageReaction extends BioCustomAction
    abstract
    config(Game);

var(SFXCustomAction_DamageReaction) BodyStance BS_Reaction;
var(SFXCustomAction_DamageReaction) BodyStance BS_ReactionExplore;
var(SFXCustomAction_DamageReaction) float fAnimPlayRate;
var(SFXCustomAction_DamageReaction) float fAnimBlendInTime;
var(SFXCustomAction_DamageReaction) float fAnimBlendOutTime;
var(SFXCustomAction_DamageReaction) float fAnimStartTime;
var(SFXCustomAction_DamageReaction) float fReactionDuration;
var(SFXCustomAction_DamageReaction) float RotationTime;
var(SFXCustomAction_DamageReaction) float ImpactScale;
var(SFXCustomAction_DamageReaction) ParticleSystem PS_Impact;
var(SFXCustomAction_DamageReaction) bool bAnimLooping;
var(SFXCustomAction_DamageReaction) bool bAllowAnimInterrupt;
var(SFXCustomAction_DamageReaction) bool bRagdollOnFinish;
var(SFXCustomAction_DamageReaction) bool bRotateOnHit;
var(SFXCustomAction_DamageReaction) bool bDeathReaction;
var(SFXCustomAction_DamageReaction) ERootMotionMode ERootMotionMode;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Reaction, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_ReactionExplore, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function Init(Vector HitLocation, Vector HitNormal, int BoneIndex, bool bPlayImpact, Class<SFXDamageType> DamageType)
{
    local Name BoneName;
    
    if (bPlayImpact && PS_Impact != None)
    {
        if (m_oPawn != None && m_oPawn.Mesh != None)
        {
            BoneName = m_oPawn.Mesh.GetBoneName(BoneIndex);
        }
        ActivateImpactEmitter(HitLocation, HitNormal, BoneName, DamageType);
    }
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactEmitter(default.PS_Impact);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (!m_oPawn.bCombatPawn && BS_ReactionExplore.AnimName.Length != 0)
    {
        BS_Reaction = BS_ReactionExplore;
    }
    else
    {
        BS_Reaction = BS_Reaction;
    }
    ApplyTimeline(TimelineTemplate, m_oPawn);
    if (m_oPawn.PlayBodyStance(BS_Reaction, fAnimPlayRate, fAnimBlendInTime, fAnimBlendOutTime, bAnimLooping, FALSE, , fAnimStartTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Reaction, TRUE);
        if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Reaction, 2, 2);
            m_oPawn.Mesh.RootMotionMode = ERootMotionMode;
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        if (fReactionDuration > 0.0)
        {
            m_oPawn.SetTimer(fReactionDuration, FALSE, 'OnCustomActionTimeUp', Self);
        }
    }
    if (bRotateOnHit && m_oPawn.LastHitBy != None)
    {
        SetFacePreciseRotation(Rotator(m_oPawn.LastHitBy.Pawn.location - m_oPawn.location), RotationTime);
    }
    m_oPawn.LastAnimatedReactionTime = m_oPawn.WorldInfo.GameTimeSeconds;
}
public simulated function ActivateImpactEmitter(Vector HitLocation, Vector HitNormal, Name BoneName, Class<SFXDamageType> DamageType)
{
    local SFXObjectPool Pool;
    local ParticleSystemComponent ImpactPSC;
    
    if (m_oPawn.Mesh != None)
    {
        Pool = SFXGRI(m_oPawn.WorldInfo.GRI).ObjectPool;
        if (Pool != None)
        {
            ImpactPSC = Pool.GetGenericParticleSystemComponent(PS_Impact);
            if (ImpactPSC != None)
            {
                Pool.AttachParticleSystemComponent(ImpactPSC, m_oPawn, m_oPawn.Mesh, BoneName, HitLocation, HitNormal, FALSE);
                Pool.ApplyBloodColor(ImpactPSC, m_oPawn);
                ImpactPSC.SetScale(ImpactScale);
                Pool.ApplyLODLevel(ImpactPSC, HitLocation);
                ImpactPSC.SetActive(TRUE);
            }
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Reaction, 1, 1, 1);
    }
    if (bRagdollOnFinish)
    {
        m_oPawn.InitRagdoll();
        m_oPawn.SetTimer(0.100000001, TRUE, 'CheckForRagdollRecovery', Self);
    }
    else
    {
        EndThisCustomAction();
    }
}
public function CheckForRagdollRecovery()
{
    if (!m_oPawn.IsInState('InRagdoll', ) && !m_oPawn.IsInState('RagdollRecovery', ))
    {
        m_oPawn.ClearTimer('CheckForRagdollRecovery', Self);
        EndThisCustomAction();
    }
}
public function OnCustomActionTimeUp()
{
    if (bAllowAnimInterrupt)
    {
        EndThisCustomAction();
    }
    else
    {
        m_oPawn.SetBodyStanceAnimLooping(BS_Reaction, FALSE);
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    RemoveTimeline();
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    }
    m_oPawn.StopBodyStance(BS_Reaction, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Reaction, FALSE);
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Reaction, 1, 1, 1);
    }
    if (bDeathReaction == FALSE && m_oPawn.bUseLargeReactions)
    {
        m_oPawn.LastLargeReactionTime = m_oPawn.WorldInfo.GameTimeSeconds;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fAnimPlayRate = 1.0
    fAnimBlendInTime = 0.200000003
    fAnimBlendOutTime = 0.200000003
    RotationTime = 0.200000003
    ImpactScale = 1.0
    bAllowAnimInterrupt = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Ignore
    AICommand = Class'SFXAICmd_CA_DamageReaction'
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bNotifyKnockedOutOfCover = TRUE
    bAllowChargeHolding = TRUE
    Priority = ECustomActionPriority.CA_Priority_Medium
}