Class SFXGameEffect_AntiGravity extends SFXGameEffect_PhysicsPower;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    Super(SFXGameEffect).OnRemoved();
    if (Owner == None)
    {
        return;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_AntiGravity' && oEffect != Self)
            {
                return;
            }
        }
    }
    Owner.m_fGravityScaling = 1.0;
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    Super(SFXGameEffect).OnApplied();
    if (Owner == None)
    {
        return;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_AntiGravity' && oEffect != Self)
            {
                if (oEffect.EffectValue < EffectValue)
                {
                    return;
                }
            }
        }
    }
    Owner.m_fGravityScaling = EffectValue;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}