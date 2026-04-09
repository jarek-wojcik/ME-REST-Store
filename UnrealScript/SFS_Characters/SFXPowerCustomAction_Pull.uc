Class SFXPowerCustomAction_Pull extends SFXPowerCustomAction_MultiProjectile
    config(Game);

var config PowerData Evolve_DoTDamagePerSec;
var array<Actor> m_oCurrentPulledTargets;
var config array<Name> EffectsToRemove;
var config float Evolve_DurationBonus;
var config float Evolve_RadiusBonus;
var config float Evolve_ExtraDamage;
var config float Evolve_RechargeBonus;
var config float MinimumVelocity;
var config float MinimumVelocityForceMult;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local Vector vForce;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_Pull oPullEffect;
    local int Index;
    
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None)
    {
        if (oPawn.IsA('SFXPawn_Guardian'))
        {
            oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistFullControlValue);
        }
        if (Resistance != EPowerResistance.Resistance_Full && !oPawn.HasResistance(3))
        {
            oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, Resistance == EPowerResistance.Resistance_None ? PowerAssistFullControlValue : PowerAssistPartialControlValue);
        }
    }
    if (Resistance != EPowerResistance.Resistance_None)
    {
        return FALSE;
    }
    if (oImpacted == None)
    {
        return FALSE;
    }
    vForce = HitNormal * Force.CurrentValue;
    oImpacted.ExceededPhysicsThreshold(m_oPawn);
    Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    for (Index = Manager.GameEffects.Length - 1; Index >= 0; Index--)
    {
        if (EffectsToRemove.Find(Manager.GameEffects[Index].Class.Name) != -1)
        {
            Manager.RemoveEffectAt(Index);
        }
    }
    AddComboEffect(oImpacted, Class'SFXGameEffect_PowerCombo_Biotic', EffectDuration.CurrentValue);
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_Ragdoll', EffectDuration.CurrentValue, 0.0, Name, m_oPawn.Controller);
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_AntiGravity', EffectDuration.CurrentValue, 0.0, Name, m_oPawn.Controller);
    oPullEffect = SFXGameEffect_Pull(Manager.CreateEffect(Class'SFXGameEffect_Pull', Name, EffectDuration.CurrentValue, 1, 1.0, m_oPawn.Controller));
    if (oPullEffect != None)
    {
        oPullEffect.ForceVector = vForce;
        oPullEffect.Caster = m_oPawn;
        oPullEffect.MinimumVelocity = MinimumVelocity;
        oPullEffect.MinimumVelocityForceMult = MinimumVelocityForceMult;
        oPullEffect.DamagePerSecond = IsEvolvedWithChoice(2) ? Evolve_DoTDamagePerSec.CurrentValue : 0.0;
        oPullEffect.TargetExtraDamage = IsEvolvedWithChoice(3) ? Evolve_ExtraDamage : 0.0;
        oPullEffect.OnApplied();
    }
    if (m_oCurrentPulledTargets.Find(oImpacted) == -1)
    {
        m_oCurrentPulledTargets.AddItem(oImpacted);
    }
    if (oPawn != None)
    {
        oPawn.RegisterRBCallback(OnRagdollPhysicsImpact, TRUE);
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
    if (int(oPawn.GetCurrentResistance()) != 0)
    {
        return ShouldUsePowerOnShields(oPawn, DefaultDamageType, sOptionalInfo);
    }
    return TRUE;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Damage':
            ApplyBonusToParameter(Evolve_DoTDamagePerSec, Bonus, bRemove);
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
            AddEvolvedRankBonus(EffectDuration, Evolve_DurationBonus);
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
            AddEvolvedRankBonus(CooldownTime, Evolve_RechargeBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_RechargeBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactForce(Actor oImpacted)
{
    return -Force.CurrentValue;
}
public function OnRagdollPhysicsImpact(Pawn oPawn, Actor oImpactActor, Vector vImpactDir)
{
    RagdollPhysicsImpact(oPawn, oImpactActor, vImpactDir);
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_RechargeBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(Evolve_DoTDamagePerSec, bReset);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    bSecondProjectile = FALSE;
}
public function StartPower()
{
    Super(SFXPowerCustomAction).StartPower();
    DropCurrentTargets();
}
public function DropCurrentTargets()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    local Actor oActor;
    
    foreach m_oCurrentPulledTargets(oActor, )
    {
        if (oActor != None)
        {
            Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                foreach Manager.GameEffects(oEffect, )
                {
                    if (oEffect.Category == Name)
                    {
                        oEffect.CurrentTime = oEffect.Duration - 1.5;
                    }
                }
            }
        }
    }
    m_oCurrentPulledTargets.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ThrowBiotic
        m_nmOrigSetName = 'HMM_BC_ThrowBiotic'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BioAnimSetData'
    End Object
    Evolve_DoTDamagePerSec = {
                              DynamicBonuses = (), 
                              RankBonuses[0] = 0.0, 
                              RankBonuses[1] = 0.0, 
                              RankBonuses[2] = 0.0, 
                              RankBonuses[3] = 0.0, 
                              RankBonuses[4] = 0.0, 
                              RankBonuses[5] = 0.0, 
                              BaseValue = 20.0, 
                              CurrentValue = 0.0, 
                              Formula = EPowerDataFormula.Normal
                             }
    EffectsToRemove = ('SFXGameEffect_Stasis')
    Evolve_DurationBonus = 0.5
    Evolve_RadiusBonus = 200.0
    Evolve_ExtraDamage = 0.25
    Evolve_RechargeBonus = 0.600000024
    MinimumVelocity = 130.0
    MinimumVelocityForceMult = 0.100000001
    SecondProjectileDelay = 0.100000001
    SecondProjectileSpeedPercent = 0.800000012
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_P_pull_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_P_pull_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_NP_pull_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_NP_pull_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    DefaultDamageType = Class'SFXDamageType_Pull'
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SuperSeeking'
    ReleaseTime = 0.25
    PhysicsToDamageMultiplier = 0.150000006
    CastAnimSet = MY_DYN_HMM_BC_ThrowBiotic
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_ThrowBiotic'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.Biotics_Charge_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_B_Pull.VCFX.Pull_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_B_Pull.VCFX.Pull_Impact_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_P_pull_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_P_pull_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_NP_pull_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_Pull.Play_power_biotic_NP_pull_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_P_pull_distant'
    HenchmanImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_NP_pull_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 4.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {Formula = EPowerDataFormula.BonusIsHardValue}
    MaximumImpactTargets = {BaseValue = 2.0}
    EffectDuration = {RankBonuses[2] = 0.400000006, BaseValue = 4.0}
    Damage = {BaseValue = 50.0}
    Force = {BaseValue = 200.0}
    VFXIntensity = {BaseValue = 1.0}
    ProjectileSpeed = {BaseValue = 3000.0}
    Ranks = ({
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $189298, 
              Evolved1Description = $189299, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $251101, 
              Evolved1Description = $619264, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $251102, 
              Evolved1Description = $501414, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $194960, 
              Evolved1Description = $194958, 
              Evolved2Name = $194946, 
              Evolved2Description = $194944
             }, 
             {
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501408, 
              Evolved1Description = $501410, 
              Evolved2Name = $501409, 
              Evolved2Description = $501411
             }, 
             {
              Icon = 43, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501415, 
              Evolved1Description = $501412, 
              Evolved2Name = $501416, 
              Evolved2Description = $501413
             }
            )
    PowerName = 'Pull'
    PowerCustomActionID = 3
    DisplayName = $189298
    Description = $703578
    Icon = 43
    TalentDescription = $703578
    PowerType = EPowerType.PowerType_Projectile
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Pull
}