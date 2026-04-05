Class SFXGameEffect_PowerBonus extends SFXGameEffect;

var array<Class<SFXPowerCustomActionBase>> IgnoredPowers;
var Name AffectedParameter;
var bool bApplyToBiotics;
var bool bApplyToTech;
var bool bApplyToCombat;
var bool bApplyToWeapons;

public function OnRemoved()
{
    Super.OnRemoved();
    RemoveBonuses();
}
public function ApplyBonus(bool bRemove)
{
    local SFXPowerCustomAction oPower;
    local BioPawn oPawn;
    local int nIndex;
    
    if (AffectedParameter == 'None')
    {
        return;
    }
    oPawn = BioPawn(Owner);
    if (oPawn != None && oPawn.PowerManager != None)
    {
        for (nIndex = 0; nIndex < oPawn.PowerManager.Powers.Length; nIndex++)
        {
            oPower = SFXPowerCustomAction(oPawn.PowerManager.Powers[nIndex]);
            if (oPower != None)
            {
                if (IgnoredPowers.Length > 0 && IgnoredPowers.Find(oPower.Class) != -1)
                {
                    continue;
                }
                if (oPower.Discipline == EBioCapMode.BIO_CAPMODE_BIOTICS && bApplyToBiotics || oPower.Discipline == EBioCapMode.BIO_CAPMODE_TECH && bApplyToTech || oPower.Discipline == EBioCapMode.BIO_CAPMODE_COMBAT && bApplyToCombat || oPower.Discipline == EBioCapMode.BIO_CAPMODE_WEAPON && bApplyToWeapons)
                {
                    oPower.ApplyBonus(AffectedParameter, Self, bRemove);
                }
            }
        }
    }
}
public function OnApplied()
{
    Super.OnApplied();
    ApplyBonus(FALSE);
}
public function RemoveBonuses()
{
    ApplyBonus(TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}