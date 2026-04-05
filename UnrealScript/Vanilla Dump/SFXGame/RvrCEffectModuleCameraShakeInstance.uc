Class RvrCEffectModuleCameraShakeInstance extends RvrClientEffectModuleInstance
    native
    transient;

public event function StartCameraShake(PlayerController pPC)
{
    local RvrCEffectModuleCameraShake pModule;
    
    pModule = RvrCEffectModuleCameraShake(m_pModule);
    if (pModule.bRadialShake)
    {
        Class'Camera'.static.PlayWorldCameraShake(pModule.Shake, m_pComponent.Owner, m_pComponent.Owner.location, pModule.RadialShake_InnerRadius, pModule.RadialShake_OuterRadius, pModule.RadialShake_Falloff, pModule.bDoControllerVibration, pModule.bOrientTowardRadialEpicenter);
    }
    else
    {
        pPC.ClientPlayCameraShake(pModule.Shake, pModule.ShakeScale, pModule.bDoControllerVibration, pModule.PlaySpace, m_pComponent.Owner.Rotation);
    }
}
public event function StopCameraShake(PlayerController pPC)
{
    local RvrCEffectModuleCameraShake pModule;
    
    pModule = RvrCEffectModuleCameraShake(m_pModule);
    pPC.ClientStopCameraShake(pModule.Shake);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}