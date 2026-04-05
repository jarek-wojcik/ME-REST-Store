Class SFXGameEffect_HealOverTime extends SFXGameEffect;

var bool bPercentOfMaxHealth;

public function OnUpdate(float DeltaSeconds)
{
    local SFXModule_Damage DmgModule;
    local float RegenAmount;
    local SFXModule_GameEffectManager Manager;
    local BioPawn PawnOwner;
    
    Super.OnUpdate(DeltaSeconds);
    if (Owner != None)
    {
        PawnOwner = BioPawn(Owner);
        Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && Manager.HasEffectOfType(Class'SFXGameEffect_HealthRegenPenalty') && (PawnOwner == None || int(PawnOwner.GetCurrentResistance()) == 0))
        {
            return;
        }
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            if (DmgModule.GetCurrentHealth() <= float(0))
            {
                return;
            }
            RegenAmount = EffectValue * DeltaSeconds;
            if (bPercentOfMaxHealth)
            {
                RegenAmount *= DmgModule.GetMaxHealth();
            }
            DmgModule.SetCurrentHealth(FMin(DmgModule.GetMaxHealth(), DmgModule.GetCurrentHealth() + RegenAmount), TRUE);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}