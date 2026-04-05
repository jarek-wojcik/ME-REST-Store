Class SFXPowerCustomAction_Throw extends SFXPowerCustomAction_MultiProjectile
    config(Game);

var config float Evolve_ForceBonus;
var config float Evolve_RadiusBonus;
var config float Evolve_CooldownBonus;
var config float FrozenForceBonus;
var config float Evolve_BioticComboMult;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_PowerCombo_Biotic BioticEffect;
    local SFXGameEffect oEffect;
    
    oPawn = SFXPawn(oImpacted);
    if (oPawn == None)
    {
        return FALSE;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, Resistance == EPowerResistance.Resistance_None ? PowerAssistFullControlValue : PowerAssistPartialControlValue);
    }
    if (Resistance == EPowerResistance.Resistance_None)
    {
        oPawn.RegisterRBCallback(OnRagdollPhysicsImpact, TRUE);
    }
    if (Manager.HasEffectOfType(Class'SFXGameEffect_PowerCombo_Biotic'))
    {
        if (IsEvolvedWithChoice(2))
        {
            foreach Manager.GameEffects(oEffect, )
            {
                if (oEffect.Class == Class'SFXGameEffect_PowerCombo_Biotic')
                {
                    BioticEffect = SFXGameEffect_PowerCombo_Biotic(oEffect);
                    if (BioticEffect != None)
                    {
                        BioticEffect.ComboDamage.X *= 1.0 + Evolve_BioticComboMult;
                        BioticEffect.ComboDamage.Y *= 1.0 + Evolve_BioticComboMult;
                        BioticEffect.ComboForce.X *= 1.0 + Evolve_BioticComboMult;
                        BioticEffect.ComboForce.Y *= 1.0 + Evolve_BioticComboMult;
                    }
                }
            }
        }
        if (IsEvolvedWithChoice(3) && m_oPawn != None && m_oPawn.PowerManager != None)
        {
            m_oPawn.PowerManager.SetSharedCooldown(0.0);
        }
    }
    return TRUE;
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(Target);
    if (oPawn == None)
    {
        return TRUE;
    }
    if (SFXPawn_Player(m_oPawn) == None && SFXPawn_Henchman(m_oPawn) == None)
    {
        return TRUE;
    }
    if (int(oPawn.GetCurrentResistance()) != 0)
    {
        return ShouldUsePowerOnShields(oPawn, DefaultDamageType, sOptionalInfo);
    }
    return TRUE;
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Force, Evolve_ForceBonus);
            AddEvolvedRankBonus(Damage, Evolve_ForceBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            bSecondProjectile = TRUE;
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactForce(Actor oImpacted)
{
    local float fForce;
    local SFXModule_GameEffectManager Manager;
    
    fForce = Force.CurrentValue;
    if (oImpacted != None)
    {
        Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && Manager.HasEffectOfType(Class'SFXGameEffect_CryoFreeze'))
        {
            fForce *= FrozenForceBonus + 1.0;
        }
    }
    return fForce;
}
public function OnRagdollPhysicsImpact(Pawn oPawn, Actor oImpactActor, Vector vImpactDir)
{
    local BioPawn oBioPawn;
    
    oBioPawn = BioPawn(oPawn);
    if (oBioPawn != None)
    {
        oBioPawn.m_bRagdollEnteredPendingBodyFallSound = TRUE;
    }
    RagdollPhysicsImpact(oPawn, oImpactActor, vImpactDir);
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = Force;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Force;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Force;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_ForceBonus;
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    bSecondProjectile = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ThrowBiotic
        m_nmOrigSetName = 'HMM_BC_ThrowBiotic'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BioAnimSetData'
    End Object
    Evolve_ForceBonus = 0.400000006
    Evolve_RadiusBonus = 200.0
    Evolve_CooldownBonus = 0.600000024
    FrozenForceBonus = 1.0
    Evolve_BioticComboMult = 0.5
    SecondProjectileDelay = 0.100000001
    SecondProjectileSpeedPercent = 0.800000012
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Biotic', Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Cryo', Class'SFXGameEffect_PowerCombo_Fire')
    EvolvedImpactSounds = ({Sound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_P_throw_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_P_throw_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_NP_throw_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_NP_throw_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    DefaultDamageType = Class'SFXDamageType_Throw'
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SuperSeeking'
    DetonationRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    DetonationScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    ReleaseTime = 0.25
    CastAnimSet = MY_DYN_HMM_BC_ThrowBiotic
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_ThrowBiotic'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.Biotics_Charge_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_B_Throw.VCFX.Throw_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_B_Throw.VCFX.Throw_Imp_VCFX'
    ImpactSound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_P_throw_impact'
    CastSound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_P_throw_cast'
    HenchmanImpactSound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_NP_throw_impact'
    HenchmanCastSound = WwiseEvent'wwise_power_biotic_throw.Play_power_biotic_NP_throw_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_P_throw_distant'
    HenchmanImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_NP_throw_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 4.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {Formula = EPowerDataFormula.BonusIsHardValue}
    MaximumImpactTargets = {BaseValue = 2.0}
    EffectDuration = {BaseValue = 1.0}
    Damage = {RankBonuses[2] = 0.300000012, BaseValue = 50.0}
    Force = {RankBonuses[2] = 0.300000012, BaseValue = 600.0}
    ProjectileSpeed = {BaseValue = 3000.0}
    Ranks = ({
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501004, 
              Evolved1Description = $170431, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $251098, 
              Evolved1Description = $619238, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $251099, 
              Evolved1Description = $500981, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $195497, 
              Evolved1Description = $195498, 
              Evolved2Name = $195495, 
              Evolved2Description = $195496
             }, 
             {
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501085, 
              Evolved1Description = $501094, 
              Evolved2Name = $501086, 
              Evolved2Description = $501095
             }, 
             {
              Icon = 25, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501087, 
              Evolved1Description = $501096, 
              Evolved2Name = $501084, 
              Evolved2Description = $501093
             }
            )
    PowerName = 'Throw'
    PowerCustomActionID = 2
    DisplayName = $501004
    Description = $682934
    Icon = 25
    TalentDescription = $682934
    PowerType = EPowerType.PowerType_Projectile
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Throw
}