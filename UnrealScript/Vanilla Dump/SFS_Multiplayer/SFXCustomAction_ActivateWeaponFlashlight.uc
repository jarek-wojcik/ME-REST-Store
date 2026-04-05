Class SFXCustomAction_ActivateWeaponFlashlight extends SFXCustomAction_SingleAnim
    config(Game);

var(AnimControl) SFXAnimSetCookSpec AnimInfo;

public function StartCustomAction()
{
    m_oPawn.RegisterTemporaryAnim(AnimInfo.AnimSet);
    Super.StartCustomAction();
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.UnregisterTemporaryAnim(AnimInfo.AnimSet);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_SniperSpecial
            m_nmOrigSetName = 'HMM_BC_SniperSpecial'
            Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start')
            m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BioAnimSetData'
        End Object
        AnimSet = MY_DYN_HMM_BC_SniperSpecial
    End Object
    AnimInfo = tempAnimInfo
    BS_Anim = {
               AnimName = ('None', 'BC_Start')
              }
    bDisableMovement = FALSE
    bDisableLeftHandIK = TRUE
    bAllowChargeHolding = TRUE
}