Class SFXCustomAction_SyncMultiBase extends SFXCustomAction_SyncMultiPawnInstigator_Base
    abstract
    config(Game);

var(Instigator) BodyStance BS_Instigator;
var(Instigator) float InstigatorPlayRate;
var(Instigator) float InstigatorBlendInTime;
var(Instigator) float InstigatorBlendOutTime;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Instigator, UsedAnims);
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function StartInteraction()
{
    m_oPawn.PlayBodyStance(BS_Instigator, InstigatorPlayRate, InstigatorBlendInTime, InstigatorBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Instigator, TRUE);
    m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Instigator, 2, 2, 2);
    Super.StartInteraction();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    StartAllTargetAnims();
    EndThisCustomAction();
}
public function StartAllTargetAnims()
{
    local BioPawn SyncPartner;
    
    foreach SyncPartners(SyncPartner, )
    {
        StartPartnerAnimation(SyncPartner);
    }
}
public function StopCustomAction()
{
    local BioPawn SyncPartner;
    
    foreach SyncPartners(SyncPartner, )
    {
        RemoveSyncPartner(SyncPartner);
    }
    m_oPawn.StopBodyStance(BS_Instigator, InstigatorBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Instigator, FALSE);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Instigator, 1, 1, 1);
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InstigatorPlayRate = 1.0
    InstigatorBlendInTime = 0.200000003
    InstigatorBlendOutTime = 0.200000003
}