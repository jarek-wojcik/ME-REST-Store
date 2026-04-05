Class SFXCustomAction_SyncBase extends SFXCustomAction_SyncPawnInstigator_Base
    abstract
    config(Game);

var(Instigator) BodyStance BS_Instigator;
var(Target) BodyStance BS_Target;
var(Instigator) float InstigatorPlayRate;
var(Instigator) float InstigatorBlendInTime;
var(Instigator) float InstigatorBlendOutTime;
var(Target) float TargetAnimDelay;
var(Target) float TargetPlayRate;
var(Target) float TargetBlendInTime;
var(Target) float TargetBlendOutTime;
var(Target) SFXAnimSetCookSpec TargetAnimInfo;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Instigator, UsedAnims);
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function ReachedPrecisePosition()
{
    Super(BioCustomAction).ReachedPrecisePosition();
    StartAnimation();
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (SyncPartner != None && TargetAnimInfo.AnimSet != None)
    {
        SyncPartner.RegisterTemporaryAnim(TargetAnimInfo.AnimSet);
    }
}
public function StartInteraction()
{
    MoveToMarkers();
    m_oPawn.SetTimer(InteractionStartTimeOut, FALSE, 'InteractionStartTimedOut', Self);
    Super.StartInteraction();
}
public function BodyStance GetTargetBodyStance()
{
    return BS_Target;
}
public function OnPartnerReachedDestination()
{
    Super.OnPartnerReachedDestination();
    StartAnimation();
}
public function StartAnimation()
{
    m_oPawn.ClearTimer('InteractionStartTimedOut', Self);
    ApplyTimeline(TimelineTemplate, m_oPawn, SyncPartner);
    m_oPawn.PlayBodyStance(BS_Instigator, InstigatorPlayRate, InstigatorBlendInTime, InstigatorBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Instigator, TRUE);
    m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Instigator, 2, 2, 2);
    SyncPartner.SetTimer(FMax(0.00100000005, TargetAnimDelay), FALSE, 'StartTargetAnim', Self);
}
public function StartTargetAnim()
{
    local BodyStance TargetBS;
    
    TargetBS = GetTargetBodyStance();
    SyncPartner.PlayBodyStance(TargetBS, TargetPlayRate, TargetBlendInTime, TargetBlendOutTime);
    SyncPartner.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
    SyncPartner.SetBodyStanceRootBoneAxisOption(TargetBS, 2, 2, 2);
}
public function StopCustomAction()
{
    local BodyStance TargetBS;
    
    TargetBS = GetTargetBodyStance();
    m_oPawn.StopBodyStance(BS_Instigator, InstigatorBlendOutTime);
    SyncPartner.StopBodyStance(TargetBS, TargetBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Instigator, FALSE);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    SyncPartner.Mesh.RootMotionMode = SyncPartner.Mesh.default.RootMotionMode;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Instigator, 1, 1, 1);
    SyncPartner.SetBodyStanceRootBoneAxisOption(TargetBS, 1, 1, 1);
    RemoveTimeline();
    SyncPartner.UnregisterTemporaryAnim(TargetAnimInfo.AnimSet);
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InstigatorPlayRate = 1.0
    InstigatorBlendInTime = 0.200000003
    InstigatorBlendOutTime = 0.200000003
    TargetPlayRate = 1.0
    TargetBlendInTime = 0.200000003
    TargetBlendOutTime = 0.200000003
    PartnerCustomAction = 3
}