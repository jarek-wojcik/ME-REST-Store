Class SFXCustomAction_OmniWave extends SFXCustomAction_SingleAnim
    config(Game);

var Guid OmniToolGuid;
var RvrClientEffectInterface CE_OmniTool;

public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        m_oPawn.SetTimer(0.25, TRUE, 'CheckMoving', Self);
        m_oPawn.SetTimer(0.25, TRUE, 'CheckFiring', Self);
    }
    OmniToolGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(CE_OmniTool, m_oPawn);
}
public function CheckFiring()
{
    if (m_oPawn.IsFiring())
    {
        m_oPawn.ClearTimer('CheckFiring', Self);
        InterruptThisCustomAction();
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_OmniTool, OmniToolGuid, TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CE_OmniTool = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_VCFX_M'
    BS_Anim = {
               AnimName = ('None', 'AM_ObjectInteract_Alt_01_Combat')
              }
    bDisableMovement = FALSE
    bDisableLeftHandIK = TRUE
    bAllowChargeHolding = TRUE
    bBlockingAction = FALSE
    bReplicateCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_Low
}