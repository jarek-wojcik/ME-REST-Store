Class SFXGameEffect_DamageImmunity extends SFXGameEffect;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (Owner == None)
    {
        return;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Class == Class && Effect != Self)
            {
                return;
            }
        }
    }
    Owner.bCanBeDamaged = TRUE;
}
public function OnApplied()
{
    Owner.bCanBeDamaged = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}