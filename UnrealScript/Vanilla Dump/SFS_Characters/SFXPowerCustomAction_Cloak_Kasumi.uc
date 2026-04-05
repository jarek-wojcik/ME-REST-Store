Class SFXPowerCustomAction_Cloak_Kasumi extends SFXPowerCustomAction_Cloak
    config(Game);

public function EvolvePower(EEvolveChoice choice)
{
    Super.EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            break;
        case EEvolveChoice.EvolveChoice2:
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(DamageBonus, Evolve_DamageBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[2] = Evolve_RechargeSpeedBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
    PowerStatBars[2].Data = DamageBonus;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[2].srStatBarDisplayTitle = $621116;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_DamageBonus;
    PowerStatBars[2].EvolvedBonuses[5] = Evolve_DamageBonus;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Ranks = ({
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $245248, 
              Evolved1Description = $245249, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314059, 
              Evolved1Description = $621033, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $594293, 
              Evolved1Description = $621034, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $621082, 
              Evolved1Description = $621083, 
              Evolved2Name = $621084, 
              Evolved2Description = $621085
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624127, 
              Evolved1Description = $624128, 
              Evolved2Name = $621086, 
              Evolved2Description = $621087
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624129, 
              Evolved1Description = $624130, 
              Evolved2Name = $621084, 
              Evolved2Description = $621085
             }
            )
}