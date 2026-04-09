Class SFXPowerCustomAction_LiftGrenade extends SFXPowerCustomAction_GrenadeBase
    config(Game);

var config PowerData InitialForce;
var config PowerData SlamForce;
var config PowerData SlamRagdollDuration;
var config PowerData MaxGrenadeBonus;
var config float Evolve_DamageBonus;
var config float Evolve_DamageBonus2;
var config float Evolve_DurationBonus;
var config float Evolve_RadiusBonus;
var config float Evolve_RadiusBonus2;
var config int Evolve_GrenadeCountBonus;
var config int Rank2GrenadeUpgrade;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_LiftGrenade Effect;
    local SFXPawn oPawn;
    local Vector vInitialForce;
    local bool bRagdolled;
    
    if (oImpacted == None)
    {
        return FALSE;
    }
    bRagdolled = Resistance == EPowerResistance.Resistance_None && (MaximumRagdollTargets.CurrentValue == float(0) || float(nPreviouslyImpacted) < MaximumRagdollTargets.CurrentValue);
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance != EPowerResistance.Resistance_Full)
    {
        oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, bRagdolled ? PowerAssistFullControlValue : PowerAssistPartialControlValue);
    }
    if (!bRagdolled)
    {
        return FALSE;
    }
    vInitialForce = Normal(vect(0.0, 0.0, 4.0) + Normal(oImpacted.location - HitLocation)) * InitialForce.CurrentValue;
    if (oPawn != None)
    {
        oPawn.AddRagdollImpulse(vInitialForce, m_oPawn.Controller, oPawn.location);
    }
    else if (oImpacted != None && oImpacted.CollisionComponent != None)
    {
        oImpacted.CollisionComponent.AddForce(vInitialForce, oImpacted.location, 'None');
    }
    Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    AddComboEffect(oImpacted, Class'SFXGameEffect_PowerCombo_Biotic', EffectDuration.CurrentValue);
    Effect = SFXGameEffect_LiftGrenade(Manager.CreateEffect(Class'SFXGameEffect_LiftGrenade', Name, EffectDuration.CurrentValue, 1, 0.0, m_oPawn.Controller));
    if (Effect != None)
    {
        Effect.ForceVector = Normal(vInitialForce);
        if (IsEvolvedWithChoice(4))
        {
            Effect.bSlamWhenDone = TRUE;
            Effect.SlamForce = SlamForce.CurrentValue;
            Effect.SlamRagdollDuration = SlamRagdollDuration.CurrentValue;
        }
        Effect.OnApplied();
    }
    return TRUE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(SFXPowerCustomAction).PrecacheVFX(ObjectPool, ClientEffects);
    Class'SFXGameEffect_LiftGrenade'.static.PrecacheVFX(ObjectPool, ClientEffects);
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Force':
            ApplyBonusToParameter(InitialForce, Bonus, bRemove);
            ApplyBonusToParameter(SlamForce, Bonus, bRemove);
            break;
        case 'EffectDuration':
            ApplyBonusToParameter(SlamRagdollDuration, Bonus, bRemove);
            break;
        default:
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(MaxGrenadeBonus, float(Evolve_GrenadeCountBonus));
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(EffectDuration, Evolve_DurationBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGrenadeBonus();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = Damage;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_DamageBonus2;
    PowerStatBars[1].Data = ImpactRadius;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_ImpactRadius;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_RadiusBonus;
    PowerStatBars[1].EvolvedBonuses[5] = Evolve_RadiusBonus2;
    PowerStatBars[2].Data = EffectDuration;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[2].EvolvedBonuses[3] = Evolve_DurationBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(InitialForce, bReset);
    RecalculatePowerData(SlamForce, bReset);
    RecalculatePowerData(SlamRagdollDuration, bReset);
    RecalculatePowerData(MaxGrenadeBonus, bReset);
}
public function ApplyGrenadeBonus()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory(Name);
    }
    if (MaxGrenadeBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MaxGrenadeBonus', MaxGrenadeBonus.CurrentValue, Name, m_oPawn.Controller);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_CB_Grenade
        m_nmOrigSetName = 'HMM_CB_Grenade'
        Sequences = (AnimSequence'BIOG_HMM_CB_A.HMM_CB_Grenade_CB_Grenade2')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_A.HMM_CB_Grenade_BioAnimSetData'
    End Object
    InitialForce = {
                    DynamicBonuses = (), 
                    RankBonuses[0] = 0.0, 
                    RankBonuses[1] = 0.0, 
                    RankBonuses[2] = 0.0, 
                    RankBonuses[3] = 0.0, 
                    RankBonuses[4] = 0.0, 
                    RankBonuses[5] = 0.0, 
                    BaseValue = 600.0, 
                    CurrentValue = 0.0, 
                    Formula = EPowerDataFormula.Normal
                   }
    SlamForce = {
                 DynamicBonuses = (), 
                 RankBonuses[0] = 0.0, 
                 RankBonuses[1] = 0.0, 
                 RankBonuses[2] = 0.0, 
                 RankBonuses[3] = 0.0, 
                 RankBonuses[4] = 0.0, 
                 RankBonuses[5] = 0.0, 
                 BaseValue = 750.0, 
                 CurrentValue = 0.0, 
                 Formula = EPowerDataFormula.Normal
                }
    SlamRagdollDuration = {
                           DynamicBonuses = (), 
                           RankBonuses[0] = 0.0, 
                           RankBonuses[1] = 0.0, 
                           RankBonuses[2] = 0.0, 
                           RankBonuses[3] = 0.0, 
                           RankBonuses[4] = 0.0, 
                           RankBonuses[5] = 0.0, 
                           BaseValue = 3.0, 
                           CurrentValue = 0.0, 
                           Formula = EPowerDataFormula.Normal
                          }
    MaxGrenadeBonus = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 1.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 0.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.BonusIsHardValue
                      }
    Evolve_DamageBonus = 0.300000012
    Evolve_DamageBonus2 = 0.300000012
    Evolve_DurationBonus = 0.5
    Evolve_RadiusBonus = 0.300000012
    Evolve_RadiusBonus2 = 0.300000012
    Evolve_GrenadeCountBonus = 2
    Rank2GrenadeUpgrade = 1
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Biotic', Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Fire', Class'SFXGameEffect_PowerCombo_Cryo')
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_P_liftorb_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_P_liftorb_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_NP_liftorb_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_NP_liftorb_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    DefaultDamageType = Class'SFXDamageType_LiftGrenade'
    NonRagdollDamageType = Class'SFXDamageType_LiftGrenade_NoRagdoll'
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_LiftGrenade'
    DetonationRumbleClass = Class'SFXRumble_Power_FragGrenade'
    DetonationScreenShakeClass = Class'SFXShake_Power_FragGrenade'
    DetonationParameters = {BlockedByObjects = FALSE, DistancedSorted = FALSE}
    CastAnimSet = MY_DYN_HMM_CB_Grenade
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_C_Grenade_Lift.VCFX.Lift_Grenade_Projectile'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_C_Grenade_Lift.VCFX.Lift_Grenade_Explosion_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_P_liftorb_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_P_liftorb_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_NP_liftorb_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_LiftOrb.Play_power_biotic_NP_liftorb_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {BaseValue = 500.0}
    MaximumRagdollTargets = {BaseValue = 3.0}
    EffectDuration = {BaseValue = 4.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 450.0}
    Force = {BaseValue = 300.0}
    Ranks = ({
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $538988, 
              Evolved1Description = $538991, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $538999, 
              Evolved1Description = $654992, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $539000, 
              Evolved1Description = $539004, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $542174, 
              Evolved1Description = $542168, 
              Evolved2Name = $542175, 
              Evolved2Description = $542169
             }, 
             {
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $542176, 
              Evolved1Description = $542170, 
              Evolved2Name = $542177, 
              Evolved2Description = $542171
             }, 
             {
              Icon = 85, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $542178, 
              Evolved1Description = $542172, 
              Evolved2Name = $542179, 
              Evolved2Description = $542173
             }
            )
    PowerName = 'LiftGrenade'
    PowerCustomActionID = 12
    DisplayName = $538988
    Description = $703657
    Icon = 85
    TalentDescription = $703657
}