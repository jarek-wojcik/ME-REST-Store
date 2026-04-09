Class SFXPowerCustomAction_JackPassive extends SFXPowerCustomAction_LiaraPassive
    config(Game);

var float Evolve_PowerCooldownBonus2;

public function EvolvePower(EEvolveChoice choice)
{
    Super.EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(PowerCooldownBonus, Evolve_PowerCooldownBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGlobalBonus();
}
public function PopulatePowerStatBarEvolves()
{
    Super.PopulatePowerStatBarEvolves();
    PowerStatBars[1].EvolvedBonuses[5] = Evolve_PowerCooldownBonus2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Evolve_PowerCooldownBonus2 = 0.600000024
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $313943, 
              Evolved1Description = $537962, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537965, 
              Evolved1Description = $537970, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537966, 
              Evolved1Description = $537970, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537971, 
              Evolved1Description = $537977, 
              Evolved2Name = $537972, 
              Evolved2Description = $537978
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537973, 
              Evolved1Description = $537979, 
              Evolved2Name = $537974, 
              Evolved2Description = $537980
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537975, 
              Evolved1Description = $537981, 
              Evolved2Name = $537971, 
              Evolved2Description = $812273
             }
            )
    PowerName = 'JackPassive'
    DisplayName = $313943
}