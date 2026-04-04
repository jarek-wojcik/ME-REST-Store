Class SFXGameEffect_DisableAI extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn oPawn;
    local SFXAI_Core oController;
    
    Super.OnRemoved();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oController = SFXAI_Core(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    oController.EnableAI(TRUE, 8);
}
public function OnApplied()
{
    local BioPawn oPawn;
    local SFXAI_Core oController;
    
    Super.OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oController = SFXAI_Core(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    if (oController.CanInterruptCurrentState())
    {
        oController.EnableAI(FALSE, 8);
        oController.Focus = None;
        oController.FireTarget = None;
    }
    else
    {
        oPawn.AddRagdollImpulse(vect(0.0, 0.0, 0.0), Instigator, oPawn.location, TRUE, 'Root');
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}