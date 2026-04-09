Class SFXPowerCustomAction_DisruptorAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

var config PowerData StunChance;
var config PowerData ShieldDamage;
var config float Evolve_DamageBonus;
var config float Evolve_DamageBonus2;
var config float Evolve_ShieldDamageBonus;
var config float Evolve_ShieldDamageBonus2;
var config float Evolve_AmmoIncrease;
var config float Evolve_HeadShotDamage;
var config float Evolve_StunChanceBonus;
var config float ShieldRegenPenalty;
var config float ShieldRegenPenaltyDuration;

public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'AmmoPowerDamage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
            ApplyBonusToParameter(ShieldDamage, Bonus, bRemove);
            break;
        case 'Damage':
            ApplyBonusToParameter(ShieldDamage, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_DisruptorAmmo oEffect;
    
    Super.ClientDoCustomActionImpact(oActor, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
    if (ImpactCount > 0)
    {
        if (oActor == None && m_oPawn.Weapon != None)
        {
            return;
        }
        Manager = m_oPawn.Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager == None)
        {
            return;
        }
        oEffect = SFXGameEffect_DisruptorAmmo(Manager.GetFirstEffectOfType(Class'SFXGameEffect_DisruptorAmmo'));
        if (oEffect != None)
        {
            oEffect.StunEnemy(BioPawn(oActor));
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus);
            AddEvolvedRankBonus(ShieldDamage, Evolve_ShieldDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            BuffAppliesToSquad = TRUE;
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ShieldDamage, Evolve_ShieldDamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(StunChance, Evolve_StunChanceBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = Damage;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_HealthDamage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[0].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[1].Data = ShieldDamage;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_ShieldBarrierDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_ShieldDamageBonus;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_ShieldDamageBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(ShieldDamage, bReset);
    RecalculatePowerData(StunChance, bReset);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    BuffAppliesToSquad = FALSE;
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_DisruptorAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_DisruptorAmmo(Manager.CreateEffect(Class'SFXGameEffect_DisruptorAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
    if (oEffect != None)
    {
        SetupEffect(oEffect);
        oEffect.Power = Self;
        oEffect.AddedByPlayer = m_bPlayerOrderedPowerUse;
        oEffect.OnApplied();
    }
}
public function SetupEffect(SFXGameEffect_AmmoPower Effect, optional BioPawn oPawn)
{
    local SFXGameEffect_DisruptorAmmo effectDisruptorAmmo;
    local float fEffectValue;
    
    fEffectValue = 1.0;
    if (oPawn != None && oPawn != m_oPawn)
    {
        fEffectValue = SquadEffectiveness;
    }
    effectDisruptorAmmo = SFXGameEffect_DisruptorAmmo(Effect);
    if (effectDisruptorAmmo != None)
    {
        effectDisruptorAmmo.Damage = Damage.CurrentValue * fEffectValue;
        effectDisruptorAmmo.StunChance = StunChance.CurrentValue * fEffectValue;
        effectDisruptorAmmo.ElectricComboDuration = EffectDuration.CurrentValue;
        effectDisruptorAmmo.DamageType = DefaultDamageType;
        effectDisruptorAmmo.ShieldRegenPenalty = ShieldRegenPenalty;
        effectDisruptorAmmo.ShieldRegenPenaltyDuration = ShieldRegenPenaltyDuration;
        if (IsEvolvedWithChoice(2))
        {
            effectDisruptorAmmo.SpareAmmoBonus = Evolve_AmmoIncrease * fEffectValue;
        }
        if (IsEvolvedWithChoice(3))
        {
            effectDisruptorAmmo.HeadShotDamageBonus = Evolve_HeadShotDamage * fEffectValue;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_SniperSpecial
        m_nmOrigSetName = 'HMM_BC_SniperSpecial'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral_Mid', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral_Mid')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BioAnimSetData'
    End Object
    StunChance = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.150000006, 
                  RankBonuses[2] = 0.0, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 1.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.BonusIsHardValue
                 }
    ShieldDamage = {
                    DynamicBonuses = (), 
                    RankBonuses[0] = 0.0, 
                    RankBonuses[1] = 0.0, 
                    RankBonuses[2] = 0.0799999982, 
                    RankBonuses[3] = 0.0, 
                    RankBonuses[4] = 0.0, 
                    RankBonuses[5] = 0.0, 
                    BaseValue = 0.200000003, 
                    CurrentValue = 0.0, 
                    Formula = EPowerDataFormula.BonusIsHardValue
                   }
    Evolve_DamageBonus = 0.0299999993
    Evolve_DamageBonus2 = 0.0500000007
    Evolve_ShieldDamageBonus = 0.119999997
    Evolve_ShieldDamageBonus2 = 0.200000003
    Evolve_AmmoIncrease = 0.300000012
    Evolve_HeadShotDamage = 0.25
    Evolve_StunChanceBonus = 0.25
    ShieldRegenPenalty = 1.0
    ShieldRegenPenaltyDuration = 8.0
    WeaponPowerEffectClass = Class'SFXGameEffect_DisruptorAmmo'
    ConcussiveShotDamageType = Class'SFXDamageType_ConcussiveShot_Disruptor'
    oImpactVFX = ParticleSystem'BioVFX_C_Modal.Particles.Overload_Imp'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_Overload'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_Overload'
    CE_ConcussiveShotImpact = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Disruptor_Imp_VCFX'
    LoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_P_ammo_dis_cast'
    HenchmanLoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_NP_ammo_dis_cast'
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    DefaultDamageType = Class'SFXDamageType_DisruptorAmmo'
    CastAnimSet = MY_DYN_HMM_BC_SniperSpecial
    EffectDuration = {BaseValue = 3.5}
    Damage = {RankBonuses[2] = 0.0199999996, BaseValue = 0.0500000007, Formula = EPowerDataFormula.BonusIsHardValue}
    Ranks = ({
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505658, 
              Evolved1Description = $170538, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244421, 
              Evolved1Description = $196532, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244422, 
              Evolved1Description = $700190, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $196373, 
              Evolved1Description = $196374, 
              Evolved2Name = $196379, 
              Evolved2Description = $196385
             }, 
             {
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505639, 
              Evolved1Description = $505640, 
              Evolved2Name = $505642, 
              Evolved2Description = $505641
             }, 
             {
              Icon = 45, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505654, 
              Evolved1Description = $505655, 
              Evolved2Name = $505656, 
              Evolved2Description = $505657
             }
            )
    PowerName = 'DisruptorAmmo'
    PowerCustomActionID = 18
    DisplayName = $505658
    Description = $664216
    Icon = 45
    TalentDescription = $664216
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Ammo
}