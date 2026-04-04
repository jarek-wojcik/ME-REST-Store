Class SFXGameEffect_IgnorePawn extends SFXGameEffect;

var bool bAffectHenchmen;

public function OnRemoved()
{
    local SFXAI_Core oController;
    
    Super.OnRemoved();
    foreach Owner.WorldInfo.AllControllers(Class'SFXAI_Core', oController)
    {
        if (!bAffectHenchmen && oController.IsA('SFXAI_Henchman'))
        {
            continue;
        }
        oController.IgnoredTargets.RemoveItem(Owner);
    }
}
public function OnApplied()
{
    local SFXAI_Core oController;
    
    Super.OnApplied();
    foreach Owner.WorldInfo.AllControllers(Class'SFXAI_Core', oController)
    {
        if (!bAffectHenchmen && oController.IsA('SFXAI_Henchman'))
        {
            continue;
        }
        if (oController.IgnoredTargets.Find(Owner) == -1)
        {
            oController.IgnoredTargets.AddItem(Owner);
        }
        if (oController.FireTarget == Owner)
        {
            oController.SelectTarget();
            if (oController.Focus == Owner || oController.MoveTarget == Owner)
            {
                oController.Focus = None;
                oController.MoveTarget = None;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAffectHenchmen = TRUE
}