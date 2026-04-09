Class SFXPowerCustomAction_CryoBlast extends SFXPowerCustomAction
    config(Game);

var config PowerData ArmorWeakness;
var config PowerData SpeedReduction;
var config PowerData FreezeExplodeRadius;
var config PowerData DamageTakenBonus;
var config float SpeedReductionDurationMult;
var config float Evolve_DurationBonus;
var config float Evolve_RadiusBonus;
var config float Evolve_SpeedReductionBonus;
var config float Evolve_CooldownBonus;
var config float Evolve_FrozenDamageBonus;
var config float Evolve_FreezeExplodeDurationMultiplier;
var config float Evolve_ArmorWeaknessBonus;
var config float Evolve_DamageTakenBonus;
var RvrClientEffectInterface CE_HalfFrozenTemplate;
var WwiseEvent FreezeExplosionSound;
var config float TimeDilationMin;
var config float TimeDilationMax;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oImpactedPawn;
    local SFXModule_GameEffectManager Manager;
    local float fDelay;
    local float fDuration;
    
    oImpactedPawn = SFXPawn(oImpacted);
    if (oImpactedPawn == None)
    {
        return FALSE;
    }
    Manager = oImpactedPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        if (DamageTakenBonus.CurrentValue > float(0))
        {
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_DamageTakenBonus', Name);
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', Name, EffectDuration.CurrentValue, 1, DamageTakenBonus.CurrentValue, m_oPawn.Controller);
        }
    }
    if (Resistance == EPowerResistance.Resistance_None)
    {
        oImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistFullControlValue);
        if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
        {
            fDelay = FRand() * (TimeDilationMax - TimeDilationMin) + TimeDilationMin;
            fDuration = EffectDuration.CurrentValue;
            ApplyFreezeEffect(oImpactedPawn, fDuration, fDelay, TRUE);
        }
    }
    else if (Resistance == EPowerResistance.Resistance_Partial)
    {
        oImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistPartialControlValue);
        fDuration = EffectDuration.CurrentValue * SpeedReductionDurationMult;
        ApplySlowdownEffect(oImpactedPawn, fDuration);
    }
    Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_ArmorWeakness', Name);
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_ArmorWeakness', fDuration, -ArmorWeakness.CurrentValue, Name, m_oPawn.Controller);
    return TRUE;
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    return TRUE;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'ImpactRadius':
            ApplyBonusToParameter(FreezeExplodeRadius, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    ApplyFreezeEffect(BioPawn(oActor), Duration, Delay, DoCallback);
    if (BioPawn(oActor) != None)
    {
        BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
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
            AddEvolvedRankBonus(SpeedReduction, Evolve_SpeedReductionBonus);
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(DamageTakenBonus, Evolve_DamageTakenBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(ArmorWeakness, Evolve_ArmorWeaknessBonus);
            AddEvolvedRankBonus(DamageTakenBonus, Evolve_FrozenDamageBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function Vector GetDefaultClientEffectParams()
{
    local Vector Param;
    
    Param.X = EffectDuration.CurrentValue;
    if (IsEvolvedWithChoice(1))
    {
        Param.Y = 1.0;
    }
    return Param;
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[4] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_FreezeDuration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
    PowerStatBars[2].Data = SpeedReduction;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_NegativePercent;
    PowerStatBars[2].srStatBarDisplayTitle = $700193;
    PowerStatBars[2].EvolvedBonuses[2] = Evolve_SpeedReductionBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(SpeedReduction, bReset);
    RecalculatePowerData(FreezeExplodeRadius, bReset);
    RecalculatePowerData(ArmorWeakness, bReset);
    RecalculatePowerData(DamageTakenBonus, bReset);
}
public final function ApplyFreezeEffect(BioPawn oPawn, float Duration, float fDelay, bool bCallbackOnDeath)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_DelayedCryoFreeze FreezeEffect;
    
    if (oPawn != None)
    {
        Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (oPawn.Role != ENetRole.ROLE_Authority)
        {
            Manager.RemoveEffectsByType(Class'SFXGameEffect_DelayedCryoFreeze');
            Manager.RemoveEffectsByType(Class'SFXGameEffect_CryoFreeze');
        }
        if (Manager != None && !Manager.HasEffectOfType(Class'SFXGameEffect_DelayedCryoFreeze') && !Manager.HasEffectOfType(Class'SFXGameEffect_CryoFreeze'))
        {
            FreezeEffect = SFXGameEffect_DelayedCryoFreeze(Manager.CreateEffect(Class'SFXGameEffect_DelayedCryoFreeze', Name, fDelay, 1, Duration, m_oPawn.Controller));
            if (FreezeEffect != None)
            {
                FreezeEffect.bPlayFrozenDeathSound = !bCallbackOnDeath;
                FreezeEffect.__OnFrozenPawnDied__Delegate = bCallbackOnDeath ? OnFrozenPawnDied : None;
                FreezeEffect.Power = Self;
                FreezeEffect.OnApplied();
                if (ShouldReplicate())
                {
                    ReplicatePowerSubsequentImpact(oPawn, , Duration, , fDelay, bCallbackOnDeath);
                }
            }
        }
    }
}
public final function ApplySlowdownEffect(BioPawn oPawn, float Duration)
{
    local SFXModule_GameEffectManager Manager;
    local RvrClientEffectTarget TargetInfo;
    local SFXGameEffect_MovementSpeedBonus SpeedEffect;
    local SFXGameEffect Effect;
    
    if (oPawn != None)
    {
        Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            foreach Manager.GameEffects(Effect, )
            {
                SpeedEffect = SFXGameEffect_MovementSpeedBonus(Effect);
                if (SpeedEffect != None && SpeedEffect.EffectValue < float(0))
                {
                    if (SpeedEffect.EffectValue <= -SpeedReduction.CurrentValue)
                    {
                        return;
                    }
                    else
                    {
                        SpeedEffect.CurrentTime = SpeedEffect.Duration + float(1);
                        SpeedEffect.DurationType = EDurationType.DurationType_Temporary;
                    }
                }
            }
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, Duration, 1, -SpeedReduction.CurrentValue, m_oPawn.Controller);
            TargetInfo.Instigator = oPawn;
            TargetInfo.SpawnValue.X = Duration;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_HalfFrozenTemplate, TargetInfo);
        }
    }
}
public final function OnFrozenPawnDied(BioPawn oPawn)
{
    local array<Actor> NearbyActors;
    local Actor NearbyActor;
    local BioPawn NearbyPawn;
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local Vector Params;
    local float fDamage;
    local Vector vForce;
    local float fDelay;
    local float fDuration;
    
    if (oPawn == None || !IsEvolvedWithChoice(3))
    {
        return;
    }
    Params.Y = 1.0;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ImpactTemplate, oPawn.location, vect(0.0, 0.0, 1.0), Params);
    oPawn.PlaySound(FreezeExplosionSound);
    GetNearbyActors(NearbyActors, oPawn.location, FreezeExplodeRadius.CurrentValue, FreezeExplodeRadius.CurrentValue, DetonationParameters);
    foreach NearbyActors(NearbyActor, )
    {
        NearbyPawn = BioPawn(NearbyActor);
        if (NearbyPawn != None && NearbyPawn != oPawn)
        {
            Resistance = NearbyPawn.GetPowerResistance(m_oPawn, oPawn.location, Normal(oPawn.location - NearbyPawn.location), fDamage, vForce, DefaultDamageType, oTargetOverride);
            if (oTargetOverride != None)
            {
                NearbyPawn = BioPawn(oTargetOverride);
                if (NearbyPawn == None)
                {
                    continue;
                }
            }
            if (Resistance == EPowerResistance.Resistance_None)
            {
                if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
                {
                    fDelay = FRand() * 0.699999988 + 1.0;
                    fDuration = EffectDuration.CurrentValue * Evolve_FreezeExplodeDurationMultiplier;
                    ApplyFreezeEffect(NearbyPawn, fDuration, fDelay, FALSE);
                }
            }
            else if (Resistance == EPowerResistance.Resistance_Partial)
            {
                fDuration = EffectDuration.CurrentValue * SpeedReductionDurationMult * Evolve_FreezeExplodeDurationMultiplier;
                ApplySlowdownEffect(NearbyPawn, fDuration);
            }
            ApplyTemporaryGameEffect(NearbyPawn, Class'SFXGameEffect_ArmorWeakness', fDuration, -ArmorWeakness.CurrentValue, Name, m_oPawn.Controller);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTechTool
        m_nmOrigSetName = 'HMM_BC_RifleTechTool'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BioAnimSetData'
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
    SpeedReduction = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 0.150000006, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.BonusIsHardValue
                     }
    FreezeExplodeRadius = {
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
    DamageTakenBonus = {
                        DynamicBonuses = (), 
                        RankBonuses[0] = 0.0, 
                        RankBonuses[1] = 0.0, 
                        RankBonuses[2] = 0.0, 
                        RankBonuses[3] = 0.0, 
                        RankBonuses[4] = 0.0, 
                        RankBonuses[5] = 0.0, 
                        BaseValue = 0.0, 
                        CurrentValue = 0.0, 
                        Formula = EPowerDataFormula.BonusIsHardValue
                       }
    SpeedReductionDurationMult = 2.0
    Evolve_DurationBonus = 0.600000024
    Evolve_RadiusBonus = 200.0
    Evolve_SpeedReductionBonus = 0.200000003
    Evolve_CooldownBonus = 0.5
    Evolve_FrozenDamageBonus = 0.150000006
    Evolve_FreezeExplodeDurationMultiplier = 0.5
    Evolve_ArmorWeaknessBonus = 0.25
    Evolve_DamageTakenBonus = 0.100000001
    CE_HalfFrozenTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Half_Frozen_VCFX'
    FreezeExplosionSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_cryo_evolexplode'
    TimeDilationMin = 0.5
    TimeDilationMax = 0.699999988
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_P_cryo_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_NP_cryo_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    DefaultDamageType = Class'SFXDamageType_CryoFreeze'
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SuperSeeking'
    DetonationRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    DetonationScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    DetonationParameters = {ImpactPlaceables = FALSE}
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ProjectileAttachPoint = 'LeftWrist'
    ReleaseEffectBoneName = 'LeftWrist'
    ReleaseTime = 0.100000001
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.Tech_Attack_Muzzle_VCFX'
    CE_ProjectileTemplate = RvrClientEffect'BioVFX_T_TechPowers.11_Cryo.VCFX.Cryo_Projectile_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_T_TechPowers.11_Cryo.VCFX.Cryo_Imp_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_P_cryo_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_P_cryo_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_NP_cryo_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_CryoBlast.Play_power_tech_NP_cryo_cast'
    bCustomCasterCrustParameters = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 6.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 12.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 4000.0}
    ImpactRadius = {Formula = EPowerDataFormula.BonusIsHardValue}
    MaximumImpactTargets = {BaseValue = 2.0}
    EffectDuration = {RankBonuses[2] = 0.400000006, BaseValue = 3.0}
    Force = {BaseValue = 150.0}
    ProjectileSpeed = {BaseValue = 3000.0}
    Ranks = ({
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $325479, 
              Evolved1Description = $325480, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $250711, 
              Evolved1Description = $558676, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $250710, 
              Evolved1Description = $560407, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $313925, 
              Evolved1Description = $558681, 
              Evolved2Name = $313985, 
              Evolved2Description = $558682
             }, 
             {
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $313986, 
              Evolved1Description = $558683, 
              Evolved2Name = $313987, 
              Evolved2Description = $558684
             }, 
             {
              Icon = 60, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $313927, 
              Evolved1Description = $558685, 
              Evolved2Name = $558680, 
              Evolved2Description = $558686
             }
            )
    PowerName = 'CryoBlast'
    PowerCustomActionID = 30
    DisplayName = $325479
    Description = $682936
    Icon = 60
    TalentDescription = $682936
    PowerType = EPowerType.PowerType_Projectile
}