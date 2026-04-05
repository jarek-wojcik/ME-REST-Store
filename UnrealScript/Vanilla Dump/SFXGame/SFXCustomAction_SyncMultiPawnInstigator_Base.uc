Class SFXCustomAction_SyncMultiPawnInstigator_Base extends BioCustomAction
    abstract
    config(Game);

var array<BioPawn> SyncPartners;
var(SyncInfo) Vector MarkerOffset;
var float InteractionStartTimeOut;
var int PartnerCustomAction;
var float MaxPartnerDistance;
var float SyncCone;
var(SyncInfo) float RotationTime;
var(SyncInfo) bool bMoveSyncPawn;
var(SyncInfo) bool bHideTargetWeapon;
var(SyncInfo) bool bAffectsFriendlies;

public function StartCustomAction()
{
    local BioPawn SyncPartner;
    
    Super.StartCustomAction();
    if (m_oPawn.SyncPawn != None)
    {
        SyncPartners.Length = 0;
        SyncPartners.AddItem(m_oPawn.SyncPawn);
    }
    m_oPawn.SetTimer(InteractionStartTimeOut, FALSE, 'InteractionStartTimedOut', Self);
    CheckReadyToStartInteraction();
    if (bHideTargetWeapon)
    {
        foreach SyncPartners(SyncPartner, )
        {
            if (SyncPartner != None && SyncPartner.Weapon != None)
            {
                SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(TRUE);
            }
        }
    }
}
public function StartInteraction();

public function AddSyncPartner(BioPawn SyncPartner)
{
    if (SyncPartner != None)
    {
        SyncPartners.AddItem(SyncPartner);
    }
}
public function bool CanInteractWithPawn(BioPawn OtherPawn)
{
    if (OtherPawn == None || OtherPawn.IsDead() || OtherPawn.Physics == EPhysics.PHYS_Falling || OtherPawn.Physics == EPhysics.PHYS_RigidBody || bAffectsFriendlies == FALSE && m_oPawn.IsHostile(OtherPawn) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public final function CheckReadyToStartInteraction()
{
    local BioPawn SyncPartner;
    
    if (SyncPartners.Length > 0)
    {
        if (m_oPawn.WorldInfo.NetMode != ENetMode.NM_Client)
        {
            foreach SyncPartners(SyncPartner, )
            {
                StartPartnerAnimation(SyncPartner);
            }
        }
    }
    if (!IsReadyToStartInteraction())
    {
        foreach SyncPartners(SyncPartner, )
        {
            if (SyncPartner == None)
            {
            }
        }
        m_oPawn.SetTimer(m_oPawn.WorldInfo.DeltaSeconds, FALSE, 'CheckReadyToStartInteraction', Self);
    }
    else
    {
        m_oPawn.ClearTimer('CheckReadyToStartInteraction', Self);
        m_oPawn.ClearTimer('InteractionStartTimedOut', Self);
        foreach SyncPartners(SyncPartner, )
        {
            SyncPartner.CustomActionMessageEvent('InteractionStarted', m_oPawn);
        }
        StartInteraction();
    }
}
public function InteractionStartTimedOut()
{
    EndThisCustomAction();
}
public function bool IsReadyToStartInteraction()
{
    local BioPawn SyncPartner;
    local BioCustomAction pAction;
    
    if (PartnerCustomAction == 0)
    {
        return TRUE;
    }
    if (SyncPartners.Length == 0)
    {
        return FALSE;
    }
    foreach SyncPartners(SyncPartner, )
    {
        pAction = None;
        if (SyncPartner != None && SyncPartner.CurrentCustomAction == PartnerCustomAction)
        {
            SyncPartner.GetCurrentCustomAction(pAction);
        }
        if (pAction != None)
        {
            if (!pAction.bStartedCustomAction)
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function bool MessageEvent(Name EventName, Object Sender)
{
    if (EventName == 'PartnerLeavingCustomAction')
    {
        OnPartnerLeavingCustomAction();
        return TRUE;
    }
    else if (EventName == 'PartnerReachedDestination')
    {
        OnPartnerReachedDestination();
        return TRUE;
    }
    return Super.MessageEvent(EventName, Sender);
}
public function OnPartnerLeavingCustomAction();

public function OnPartnerReachedDestination();

public function RemoveSyncPartner(BioPawn SyncPartner)
{
    if (SyncPartner != None)
    {
        SyncPartners.RemoveItem(SyncPartner);
    }
}
public function StartPartnerAnimation(BioPawn SyncPartner)
{
    if (SyncPartner.CurrentCustomAction != PartnerCustomAction)
    {
        SyncPartner.StartCustomAction(PartnerCustomAction);
    }
}
public function StopCustomAction()
{
    local BioPawn SyncPartner;
    local int i;
    
    m_oPawn.ClearTimer('CheckReadyToStartInteraction', Self);
    for (i = SyncPartners.Length - 1; i >= 0; i--)
    {
        SyncPartner = SyncPartners[i];
        if (SyncPartner != None && !SyncPartner.bDeleteMe)
        {
            if (SyncPartner.CurrentCustomAction == PartnerCustomAction)
            {
                SyncPartner.EndCustomAction();
            }
        }
        if (bHideTargetWeapon)
        {
            if (SyncPartner != None && SyncPartner.Weapon != None)
            {
                SFXWeapon(SyncPartner.Weapon).SetWeaponHidden(FALSE);
            }
        }
        RemoveSyncPartner(SyncPartner);
    }
    if (m_oPawn.SyncPawnOwner == Self)
    {
        m_oPawn.SyncPawn = None;
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InteractionStartTimeOut = 4.0
    MaxPartnerDistance = 128.0
    SyncCone = 0.5
    RotationTime = 0.449999988
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bDisableLook = TRUE
}