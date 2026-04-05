Class SFXPowerCustomAction_SentryTurretShock extends SFXPowerCustomAction
    config(Game);

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local SFXPawn_SentryTurret Turret;
    local SFXPowerCustomAction TurretPower;
    local SFXPawn CasterPawn;
    
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance == EPowerResistance.Resistance_None)
    {
        Turret = SFXPawn_SentryTurret(m_oPawn);
        if (Turret != None)
        {
            CasterPawn = SFXPawn(Turret.Caster);
            if (CasterPawn != None)
            {
                TurretPower = SFXPowerCustomAction(CasterPawn.PowerManager.GetPower('SentryTurret'));
                if (TurretPower != None)
                {
                    oPawn.AddPowerAssistEvent(CasterPawn, TurretPower.DisplayName, TurretPower.PowerAssistFullControlValue);
                }
            }
        }
    }
    return TRUE;
}
public function ReleaseInstantPower()
{
    OnPowerDetonated(m_oPawn.location, vect(0.0, 0.0, 1.0));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultDamageType = Class'SFXDamageType_SentryTurretShock'
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Shock_AOE_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_SenTurret.Play_power_tech_S_turret_shock'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    MaximumRange = {BaseValue = 190.0}
    PowerName = 'SentryTurretShock'
    PowerCustomActionID = 57
    Rank = 1.0
    bEnabled = FALSE
    AimingIgnoresObstructions = TRUE
    UsesSharedCooldown = FALSE
}