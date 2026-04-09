Class SFXPowerCustomAction_Slam extends SFXPowerCustomAction
    config(Game);

var config PowerData InitialForce;
var config float Evolve_ForceBonus;
var config float Evolve_ImpactRadius;
var config float Evolve_BioticComboMult;
var config float Evolve_ForceBonus2;
var config float Evolve_RagdollDuration;
var config float Evolve_RechargeSpeedBonus;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_LiftGrenade LiftEffect;
    local SFXPawn oPawn;
    local Vector vInitialForce;
    local SFXGameEffect_PowerCombo_Biotic BioticEffect;
    local SFXGameEffect oEffect;
    
    if (oImpacted == None)
    {
        return FALSE;
    }
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance != EPowerResistance.Resistance_Full)
    {
        oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, Resistance == EPowerResistance.Resistance_None ? PowerAssistFullControlValue : PowerAssistPartialControlValue);
    }
    if (Resistance != EPowerResistance.Resistance_None)
    {
        return FALSE;
    }
    oPawn.RegisterRBCallback(OnRagdollPhysicsImpact, TRUE);
    vInitialForce = vect(0.0, 0.0, 1.0) * InitialForce.CurrentValue;
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
    if (oPawn != None)
    {
        LiftEffect = SFXGameEffect_LiftGrenade(Manager.CreateEffect(Class'SFXGameEffect_LiftGrenade', Name, EffectDuration.CurrentValue, 1, 0.0, m_oPawn.Controller));
        if (LiftEffect != None)
        {
            LiftEffect.ForceVector = Normal(vInitialForce);
            LiftEffect.bSlamWhenDone = TRUE;
            LiftEffect.SlamForce = Force.CurrentValue;
            LiftEffect.bBioticComboOnSlam = TRUE;
            LiftEffect.Power = Self;
            if (IsEvolvedWithChoice(4))
            {
                LiftEffect.SlamRagdollDuration = Evolve_RagdollDuration;
            }
            else
            {
                LiftEffect.SlamRagdollDuration = 1.0;
            }
            LiftEffect.OnApplied();
        }
    }
    AddComboEffect(oImpacted, Class'SFXGameEffect_PowerCombo_Biotic', EffectDuration.CurrentValue);
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
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_ImpactRadius);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(Force, Evolve_ForceBonus2);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(CooldownTime, Evolve_RechargeSpeedBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_RechargeSpeedBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactForce(Actor oImpacted)
{
    return 0.0;
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
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_RechargeSpeedBonus;
    PowerStatBars[1].Data = Force;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Force;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Force;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_ForceBonus;
    PowerStatBars[1].EvolvedBonuses[3] = Evolve_ForceBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(InitialForce, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ThrowBiotic
        m_nmOrigSetName = 'HMM_BC_ThrowBiotic'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BioAnimSetData'
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
    Evolve_ForceBonus = 0.400000006
    Evolve_ImpactRadius = 200.0
    Evolve_BioticComboMult = 0.5
    Evolve_ForceBonus2 = 0.5
    Evolve_RagdollDuration = 5.0
    Evolve_RechargeSpeedBonus = 0.5
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Biotic', Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Cryo', Class'SFXGameEffect_PowerCombo_Fire')
    DefaultDamageType = Class'SFXDamageType_Throw'
    ReleaseTime = 0.25
    CastAnimSet = MY_DYN_HMM_BC_ThrowBiotic
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_ThrowBiotic'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.Biotics_Charge_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_B_Throw.VCFX.Throw_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_B_Throw.VCFX.Throw_Imp_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_Slam.Play_power_biotic_P_slam_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_Slam.Play_power_biotic_P_slam_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_Slam.Play_power_biotic_NP_slam_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_Slam.Play_power_biotic_NP_slam_cast'
    bOverrideComboDetonate = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 4.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {Formula = EPowerDataFormula.BonusIsHardValue}
    EffectDuration = {BaseValue = 1.5}
    Damage = {RankBonuses[2] = 0.300000012, BaseValue = 50.0}
    Force = {RankBonuses[2] = 0.300000012, BaseValue = 900.0}
    Ranks = ({
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $542178, 
              Evolved1Description = $716449, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $170384, 
              Evolved1Description = $717191, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $195497, 
              Evolved1Description = $717192, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $195497, 
              Evolved1Description = $717193, 
              Evolved2Name = $194946, 
              Evolved2Description = $717194
             }, 
             {
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $195623, 
              Evolved1Description = $717195, 
              Evolved2Name = $195497, 
              Evolved2Description = $717196
             }, 
             {
              Icon = 46, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244421, 
              Evolved1Description = $717197, 
              Evolved2Name = $170384, 
              Evolved2Description = $717198
             }
            )
    PowerName = 'Slam'
    PowerCustomActionID = 9
    DisplayName = $542178
    Description = $716449
    Icon = 46
    TalentDescription = $716449
    IsBonusPower = TRUE
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Throw
}