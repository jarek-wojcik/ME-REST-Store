Class SFXCustomAction_HolsterWeapon extends BioCustomAction
    config(Game);

var(SFXCustomAction_HolsterWeapon) BodyStance BS_Holster;
var(SFXCustomAction_HolsterWeapon) float fAnimBlendInTime;
var(SFXCustomAction_HolsterWeapon) float fAnimBlendOutTime;
var(SFXCustomAction_HolsterWeapon) float fAnimPlaybackRate;
var(SFXCustomAction_HolsterWeapon) AlphaBlendType BlendType;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Holster, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn.PlayBodyStance(BS_Holster, fAnimPlaybackRate, fAnimBlendInTime, fAnimBlendOutTime, , , , , BlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Holster, TRUE);
    }
    m_oPawn.DisableLeftHandIK();
}
public function StopCustomAction()
{
    local SFXWeapon CurrWeapon;
    
    Super.StopCustomAction();
    m_oPawn.StopBodyStance(BS_Holster, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Holster, FALSE);
    CurrWeapon = SFXWeapon(m_oPawn.Weapon);
    if (CurrWeapon != None)
    {
        CurrWeapon.UnEquipFinished();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Holster = {
                  AnimName = ('None', 
                              'CB_Holster', 
                              'CB_Holster', 
                              'CB_Holster_Cover', 
                              'None', 
                              'CB_Holster_Cover_Mid', 
                              'None', 
                              'None', 
                              'None', 
                              'None', 
                              'None', 
                              'CB_Holster'
                             )
                 }
    fAnimBlendInTime = 0.100000001
    fAnimBlendOutTime = 0.100000001
    fAnimPlaybackRate = 1.0
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'SFXCustomAction_DrawWeapon')
    bDisableLeftHandIK = TRUE
    bDisableAiming = FALSE
    bBlockingAction = FALSE
    Priority = ECustomActionPriority.CA_Priority_Medium
}