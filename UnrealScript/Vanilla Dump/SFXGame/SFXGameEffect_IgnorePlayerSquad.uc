Class SFXGameEffect_IgnorePlayerSquad extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn oPawn;
    local BioBaseSquad oPlayerSquad;
    local SFXAI_Core oController;
    
    Super.OnRemoved();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    if (IsStillIgnoring(oPawn))
    {
        return;
    }
    oPlayerSquad = BioWorldInfo(Owner.WorldInfo).m_playerSquad;
    oController = SFXAI_Core(oPawn.Controller);
    if (oController != None)
    {
        oController.IgnoredSquads.RemoveItem(oPlayerSquad);
    }
}
public function bool IsStillIgnoring(BioPawn oPawn)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    if (oPawn == None)
    {
        return FALSE;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_IgnorePlayerSquad' && oEffect != Self)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function OnApplied()
{
    local BioPawn oPawn;
    local BioBaseSquad oPlayerSquad;
    local SFXAI_Core oController;
    
    Super.OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oPlayerSquad = BioWorldInfo(Owner.WorldInfo).m_playerSquad;
    oController = SFXAI_Core(oPawn.Controller);
    if (oController != None)
    {
        if (oController.IgnoredSquads.Find(oPlayerSquad) == -1)
        {
            oController.IgnoredSquads.AddItem(oPlayerSquad);
        }
        oController.Focus = None;
        oController.MoveTarget = None;
        oController.SelectTarget();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}