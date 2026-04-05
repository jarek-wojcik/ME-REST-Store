Class SFXPowerCustomAction_CombatDroneShock extends SFXPowerCustomAction
    config(Game);

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local SFXPawn_CombatDrone Drone;
    local SFXPowerCustomAction DronePower;
    local SFXPawn CasterPawn;
    
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance == EPowerResistance.Resistance_None)
    {
        Drone = SFXPawn_CombatDrone(m_oPawn);
        if (Drone != None)
        {
            CasterPawn = SFXPawn(Drone.Caster);
            if (CasterPawn != None)
            {
                DronePower = SFXPowerCustomAction(CasterPawn.PowerManager.GetPower('CombatDrone'));
                if (DronePower != None)
                {
                    oPawn.AddPowerAssistEvent(CasterPawn, DronePower.DisplayName, DronePower.PowerAssistFullControlValue);
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
    DefaultDamageType = Class'SFXDamageType_Power'
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Shock_AOE_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_shock_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    MaximumRange = {BaseValue = 190.0}
    MaximumImpactTargets = {BaseValue = 2.0}
    PowerName = 'CombatDroneShock'
    PowerCustomActionID = 49
    Rank = 1.0
    DelayBeforeFirstUse = 3.0
    bEnabled = FALSE
    AimingIgnoresObstructions = TRUE
    UsesSharedCooldown = FALSE
}