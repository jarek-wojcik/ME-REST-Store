Class SFXGameEffect_CloakDamageBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn oPawn;
    local float fDelay;
    
    Super.OnRemoved();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    if (CurrentTime < Duration)
    {
        fDelay = FMin(Duration - CurrentTime, 1.0);
        oPawn.SetTimer(fDelay, FALSE, 'RemoveDamageBonuses', Self);
    }
    else
    {
        RemoveDamageBonuses();
    }
}
public function OnApplied()
{
    local BioPawn oPawn;
    local InventoryManager oInventoryManager;
    local SFXWeapon oWeapon;
    
    Super.OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oInventoryManager = oPawn.InvManager;
    if (oInventoryManager != None)
    {
        foreach oInventoryManager.InventoryActors(Class'SFXWeapon', oWeapon)
        {
            if (oWeapon != None)
            {
                oWeapon.StealthDamageIncrease = EffectValue;
            }
        }
    }
}
public function OnCombatEnd()
{
    CurrentTime = Duration;
}
public function RemoveDamageBonuses()
{
    local BioPawn oPawn;
    local InventoryManager oInventoryManager;
    local SFXWeapon oWeapon;
    
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oInventoryManager = oPawn.InvManager;
    if (oInventoryManager != None)
    {
        foreach oInventoryManager.InventoryActors(Class'SFXWeapon', oWeapon)
        {
            if (oWeapon != None)
            {
                oWeapon.StealthDamageIncrease = 0.0;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BonusFormula = EBonusFormula.BonusFormula_LargestValue
}