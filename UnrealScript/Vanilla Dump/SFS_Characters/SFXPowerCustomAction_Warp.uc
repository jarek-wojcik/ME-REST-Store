Class SFXPowerCustomAction_Warp extends SFXPowerCustomAction
    config(Game);

var config PowerData ArmorWeakness;
var config PowerData Evolve_DebuffDamageTakenDuration;
var config AreaEffectParameters BioticExplosionParameters;
var config float Evolve_DamageBonus;
var config float Evolve_DamageBonus2;
var config float Evolve_DoTDuration;
var config float Evolve_DebuffWeaponDamageTakenStrength;
var config float Evolve_DebuffBioticDamageTakenStrength;
var config float Evolve_CooldownBonus;
var config float Evolve_ComboForce;
var config float Evolve_ComboDamage;
var config float Evolve_ComboRadius;
var config float Evolve_ArmorWeaknessBonus;
var config float Evolve_ShieldDamageBonus;
var config float InstantDamagePercent;
var RvrClientEffectInterface CE_DeathEffect;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn ImpactedPawn;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_FireDamageOverTime DOTEffect;
    local Class<SFXDamageType> DamageType;
    local SFXGameEffect_DeathEffect DeathEffect;
    local float fDamagePerSecond;
    local SFXGameEffect_PowerCombo_Biotic BioticEffect;
    local SFXGameEffect oEffect;
    local Vector Param;
    local float fAssistAmount;
    
    if (Resistance == EPowerResistance.Resistance_Full)
    {
        return FALSE;
    }
    ImpactedPawn = SFXPawn(oImpacted);
    if (ImpactedPawn == None)
    {
        return FALSE;
    }
    Manager = ImpactedPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    AddComboEffect(oImpacted, Class'SFXGameEffect_PowerCombo_Biotic', EffectDuration.CurrentValue);
    if (IsEvolvedWithChoice(1))
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_PowerCombo_Biotic')
            {
                BioticEffect = SFXGameEffect_PowerCombo_Biotic(oEffect);
                if (BioticEffect != None)
                {
                    BioticEffect.ComboDamage.X *= 1.0 + Evolve_ComboDamage;
                    BioticEffect.ComboDamage.Y *= 1.0 + Evolve_ComboDamage;
                    BioticEffect.ComboForce.X *= 1.0 + Evolve_ComboForce;
                    BioticEffect.ComboForce.Y *= 1.0 + Evolve_ComboForce;
                    BioticEffect.ComboRadius.X *= 1.0 + Evolve_ComboRadius;
                    BioticEffect.ComboRadius.Y *= 1.0 + Evolve_ComboRadius;
                }
            }
        }
    }
    fDamagePerSecond = GetTotalDamage(oImpacted, DamageType) * (1.0 - InstantDamagePercent) / EffectDuration.CurrentValue;
    if (IsEvolvedWithChoice(4))
    {
        DamageType = Class'SFXDamageType_ImprovedWarpDoT';
    }
    else
    {
        DamageType = Class'SFXDamageType_WarpDoT';
    }
    DOTEffect = SFXGameEffect_FireDamageOverTime(Manager.CreateEffect(Class'SFXGameEffect_FireDamageOverTime', Name, EffectDuration.CurrentValue, 1, fDamagePerSecond, m_oPawn.Controller));
    if (DOTEffect != None)
    {
        DOTEffect.DamageType = DamageType;
        DOTEffect.bCanCauseCombo = FALSE;
        DOTEffect.OnApplied();
        Param.X = EffectDuration.CurrentValue;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_TargetCrustTemplate, ImpactedPawn, Param);
    }
    if (Resistance == EPowerResistance.Resistance_None)
    {
        if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_HealthRegenPenalty', Name))
        {
            ApplyPermanentGameEffect(oImpacted, Class'SFXGameEffect_HealthRegenPenalty', 1.0, Name, m_oPawn.Controller);
        }
    }
    if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_DeathEffect', Name))
    {
        DeathEffect = SFXGameEffect_DeathEffect(Manager.CreateEffect(Class'SFXGameEffect_DeathEffect', Name, EffectDuration.CurrentValue + 0.5, 1, 0.0, m_oPawn.Controller));
        if (DeathEffect != None)
        {
            DeathEffect.CE_DeathEffectTemplate = CE_DeathEffect;
            DeathEffect.OnApplied();
        }
    }
    if (IsEvolvedWithChoice(3))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_BioticPowerDamageTakenBonus', Name);
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_WeaponDamageTakenBonus', Name);
        ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_BioticPowerDamageTakenBonus', Evolve_DebuffDamageTakenDuration.CurrentValue, Evolve_DebuffBioticDamageTakenStrength, Name, m_oPawn.Controller);
        ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_WeaponDamageTakenBonus', Evolve_DebuffDamageTakenDuration.CurrentValue, Evolve_DebuffWeaponDamageTakenStrength, Name, m_oPawn.Controller);
        fAssistAmount += Evolve_DebuffBioticDamageTakenStrength;
    }
    if (ImpactedPawn.HasResistance(3))
    {
        fAssistAmount += ArmorWeakness.CurrentValue;
    }
    if (fAssistAmount > float(0))
    {
        ImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, fAssistAmount);
    }
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_ArmorWeakness', EffectDuration.CurrentValue, -ArmorWeakness.CurrentValue, Name, m_oPawn.Controller);
    return TRUE;
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local BioPawn oPawn;
    
    if (SFXPawn_Player(m_oPawn) == None && SFXPawn_Henchman(m_oPawn) == None)
    {
        return TRUE;
    }
    oPawn = BioPawn(Target);
    if (oPawn == None)
    {
        return TRUE;
    }
    if (int(oPawn.GetCurrentResistance()) != 0)
    {
        return ShouldUsePowerOnShields(oPawn, Class'SFXDamageType_Warp', sOptionalInfo);
    }
    return TRUE;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'EffectDuration':
            ApplyBonusToParameter(Evolve_DebuffDamageTakenDuration, Bonus, bRemove);
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
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(EffectDuration, Evolve_DoTDuration);
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(ArmorWeakness, Evolve_ArmorWeaknessBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    return GetTotalDamage(oImpacted, DamageType) * InstantDamagePercent;
}
public function PlayImpactEffects(Actor oImpacted, Vector ImpactLocation, Vector ImpactNormal)
{
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].EvolvedBonuses[2] = Evolve_DamageBonus2;
    PowerStatBars[2].Data = EffectDuration;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[2].EvolvedBonuses[2] = Evolve_DoTDuration;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(Evolve_DebuffDamageTakenDuration, bReset);
    RecalculatePowerData(ArmorWeakness, bReset);
}
public function float GetTotalDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    if (IsEvolvedWithChoice(4))
    {
        DamageType = Class'SFXDamageType_ImprovedWarp';
    }
    else
    {
        DamageType = Class'SFXDamageType_Warp';
    }
    return Damage.CurrentValue;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ThrowBiotic
        m_nmOrigSetName = 'HMM_BC_ThrowBiotic'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BioAnimSetData'
    End Object
    ArmorWeakness = {
                     DynamicBonuses = (), 
                     RankBonuses[0] = 0.0, 
                     RankBonuses[1] = 0.0, 
                     RankBonuses[2] = 0.0, 
                     RankBonuses[3] = 0.0, 
                     RankBonuses[4] = 0.0, 
                     RankBonuses[5] = 0.0, 
                     BaseValue = 0.25, 
                     CurrentValue = 0.0, 
                     Formula = EPowerDataFormula.BonusIsHardValue
                    }
    Evolve_DebuffDamageTakenDuration = {
                                        DynamicBonuses = (), 
                                        RankBonuses[0] = 0.0, 
                                        RankBonuses[1] = 0.0, 
                                        RankBonuses[2] = 0.0, 
                                        RankBonuses[3] = 0.0, 
                                        RankBonuses[4] = 0.0, 
                                        RankBonuses[5] = 0.0, 
                                        BaseValue = 10.0, 
                                        CurrentValue = 0.0, 
                                        Formula = EPowerDataFormula.Normal
                                       }
    BioticExplosionParameters = {
                                 ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                 ConeAngle = 0.0, 
                                 ImpactFriends = FALSE, 
                                 ImpactDeadPawns = FALSE, 
                                 ImpactPlaceables = TRUE, 
                                 BlockedByObjects = FALSE, 
                                 DistancedSorted = FALSE
                                }
    Evolve_DamageBonus = 0.300000012
    Evolve_DamageBonus2 = 0.400000006
    Evolve_DoTDuration = 0.600000024
    Evolve_DebuffWeaponDamageTakenStrength = 0.150000006
    Evolve_DebuffBioticDamageTakenStrength = 0.150000006
    Evolve_CooldownBonus = 0.349999994
    Evolve_ComboForce = 0.5
    Evolve_ComboDamage = 0.5
    Evolve_ComboRadius = 0.5
    Evolve_ArmorWeaknessBonus = 0.25
    Evolve_ShieldDamageBonus = 0.5
    InstantDamagePercent = 0.75
    CE_DeathEffect = RvrClientEffect'BioVFX_B_Warp.VCFX.Warp_Death_VCFX'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Biotic', Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Cryo', Class'SFXGameEffect_PowerCombo_Fire')
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_P_warp_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_P_warp_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_NP_warp_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_NP_warp_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SuperSeeking'
    DetonationRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    DetonationScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    ReleaseTime = 0.25
    CastAnimSet = MY_DYN_HMM_BC_ThrowBiotic
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_ThrowBiotic'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.Biotics_Charge_VCFX'
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_B_Warp.VCFX.WarpFire_TargetCrust_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_B_Warp.VCFX.Warp_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_B_Warp.VCFX.Warp_Impact_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_P_warp_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_P_warp_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_NP_warp_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_Warp.Play_power_biotic_NP_warp_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_P_warp_distant'
    HenchmanImpactDistanceLayer = WwiseEvent'Wwise_Power_Shared.Play_power_shared_NP_warp_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 16.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    MaximumImpactTargets = {BaseValue = 1.0}
    EffectDuration = {BaseValue = 10.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 250.0}
    Force = {BaseValue = 250.0}
    ProjectileSpeed = {BaseValue = 3000.0}
    Ranks = ({
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501005, 
              Evolved1Description = $687430, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $252166, 
              Evolved1Description = $512758, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $252167, 
              Evolved1Description = $581491, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $195621, 
              Evolved1Description = $195622, 
              Evolved2Name = $195623, 
              Evolved2Description = $195624
             }, 
             {
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501140, 
              Evolved1Description = $501142, 
              Evolved2Name = $501119, 
              Evolved2Description = $501118
             }, 
             {
              Icon = 26, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $501146, 
              Evolved1Description = $501148, 
              Evolved2Name = $501141, 
              Evolved2Description = $501143
             }
            )
    PowerName = 'Warp'
    PowerCustomActionID = 5
    DisplayName = $501005
    Description = $170520
    Icon = 26
    TalentDescription = $170520
    PowerType = EPowerType.PowerType_Projectile
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Warp
}