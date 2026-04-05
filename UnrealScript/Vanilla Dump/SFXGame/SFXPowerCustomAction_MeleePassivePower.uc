Class SFXPowerCustomAction_MeleePassivePower extends SFXPowerCustomAction_PassivePower
    abstract
    config(Game);

var config PowerData MeleeDamage;
var config PowerData MeleeForce;
var config PowerData MeleeImpactRadius;
var config PowerData MeleeConeAngle;
var config PowerData HeavyMeleeDamage;
var config PowerData HeavyMeleeForce;
var config PowerData HeavyMeleeImpactRadius;
var config PowerData HeavyMeleeConeAngle;
var config PowerData CoverMeleeImpactRadius;
var Name MeleeKillCategory;

public function OnHeavyMeleeKill(Actor oImpacted);

public function OnRegularMeleeKill(Actor oImpacted);

public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(MeleeDamage, bReset);
    RecalculatePowerData(MeleeForce, bReset);
    RecalculatePowerData(MeleeImpactRadius, bReset);
    RecalculatePowerData(MeleeConeAngle, bReset);
    RecalculatePowerData(HeavyMeleeDamage, bReset);
    RecalculatePowerData(HeavyMeleeForce, bReset);
    RecalculatePowerData(HeavyMeleeImpactRadius, bReset);
    RecalculatePowerData(HeavyMeleeConeAngle, bReset);
    RecalculatePowerData(CoverMeleeImpactRadius, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MeleeDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.0, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 150.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    MeleeForce = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.0, 
                  RankBonuses[2] = 0.0, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 350.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.Normal
                 }
    MeleeImpactRadius = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.0, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 100.0, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.Normal
                        }
    MeleeConeAngle = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 90.0, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.Normal
                     }
    HeavyMeleeDamage = {
                        DynamicBonuses = (), 
                        RankBonuses[0] = 0.0, 
                        RankBonuses[1] = 0.0, 
                        RankBonuses[2] = 0.0, 
                        RankBonuses[3] = 0.0, 
                        RankBonuses[4] = 0.0, 
                        RankBonuses[5] = 0.0, 
                        BaseValue = 400.0, 
                        CurrentValue = 0.0, 
                        Formula = EPowerDataFormula.Normal
                       }
    HeavyMeleeForce = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 300.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.Normal
                      }
    HeavyMeleeImpactRadius = {
                              DynamicBonuses = (), 
                              RankBonuses[0] = 0.0, 
                              RankBonuses[1] = 0.0, 
                              RankBonuses[2] = 0.0, 
                              RankBonuses[3] = 0.0, 
                              RankBonuses[4] = 0.0, 
                              RankBonuses[5] = 0.0, 
                              BaseValue = 125.0, 
                              CurrentValue = 0.0, 
                              Formula = EPowerDataFormula.Normal
                             }
    HeavyMeleeConeAngle = {
                           DynamicBonuses = (), 
                           RankBonuses[0] = 0.0, 
                           RankBonuses[1] = 0.0, 
                           RankBonuses[2] = 0.0, 
                           RankBonuses[3] = 0.0, 
                           RankBonuses[4] = 0.0, 
                           RankBonuses[5] = 0.0, 
                           BaseValue = 90.0, 
                           CurrentValue = 0.0, 
                           Formula = EPowerDataFormula.Normal
                          }
    CoverMeleeImpactRadius = {
                              DynamicBonuses = (), 
                              RankBonuses[0] = 0.0, 
                              RankBonuses[1] = 0.25, 
                              RankBonuses[2] = 0.25, 
                              RankBonuses[3] = 0.0, 
                              RankBonuses[4] = 0.0, 
                              RankBonuses[5] = 0.0, 
                              BaseValue = 200.0, 
                              CurrentValue = 0.0, 
                              Formula = EPowerDataFormula.Normal
                             }
    MeleeKillCategory = 'HeavyMeleeKillBonus'
    MaximumImpactTargets = {BaseValue = 1.0}
    PowerCustomActionID = 43
    DisplayInHUD = FALSE
    bReplicateCustomAction = FALSE
}