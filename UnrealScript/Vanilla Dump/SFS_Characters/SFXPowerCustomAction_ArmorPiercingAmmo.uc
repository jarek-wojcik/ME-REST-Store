Class SFXPowerCustomAction_ArmorPiercingAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

var config PowerData ArmorReduction;
var config PowerData PiercingRange;
var config PowerData PiercingDamage;
var config float Evolve_DamageBonus1;
var config float Evolve_DamageBonus2;
var config float Evolve_AmmoCapacityBonus;
var config float Evolve_HeadShotDamageBonus;
var config float Evolve_PiercingBonus;
var config float Evolve_ArmorReductionBonus;

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    Class'SFXGameEffect_ArmorPiercingAmmo'.static.PrecacheVFX(ObjectPool, ClientEffects);
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'AmmoPowerDamage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
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
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus1);
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
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(PiercingRange, Evolve_PiercingBonus);
            AddEvolvedRankBonus(ArmorReduction, Evolve_ArmorReductionBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 4;
    PowerStatBars[0].Data = Damage;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_HealthDamage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_DamageBonus1;
    PowerStatBars[0].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_ArmorDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus1;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[2].Data = ArmorReduction;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_NegativePercent;
    PowerStatBars[2].srStatBarDisplayTitle = $700238;
    PowerStatBars[2].EvolvedBonuses[5] = Evolve_ArmorReductionBonus;
    PowerStatBars[3].Data = PiercingRange;
    PowerStatBars[3].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[3].srStatBarDisplayTitle = $700240;
    PowerStatBars[3].EvolvedBonuses[5] = Evolve_PiercingBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(ArmorReduction, bReset);
    RecalculatePowerData(PiercingRange, bReset);
    RecalculatePowerData(PiercingDamage, bReset);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    BuffAppliesToSquad = FALSE;
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_ArmorPiercingAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_ArmorPiercingAmmo(Manager.CreateEffect(Class'SFXGameEffect_ArmorPiercingAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
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
    local SFXGameEffect_ArmorPiercingAmmo effectAPAmmo;
    local float fEffectValue;
    
    effectAPAmmo = SFXGameEffect_ArmorPiercingAmmo(Effect);
    fEffectValue = 1.0;
    if (oPawn != None && oPawn != m_oPawn)
    {
        fEffectValue = SquadEffectiveness;
    }
    if (effectAPAmmo != None)
    {
        effectAPAmmo.DamageType = DefaultDamageType;
        effectAPAmmo.Damage = Damage.CurrentValue * fEffectValue;
        effectAPAmmo.ArmorReduction = ArmorReduction.CurrentValue * fEffectValue;
        effectAPAmmo.Penetration = PiercingRange.CurrentValue * fEffectValue;
        effectAPAmmo.PenetrationDamage = -PiercingDamage.CurrentValue;
        if (IsEvolvedWithChoice(2))
        {
            effectAPAmmo.SpareAmmoBonus = Evolve_AmmoCapacityBonus * fEffectValue;
        }
        if (IsEvolvedWithChoice(3))
        {
            effectAPAmmo.HeadShotDamageBonus = Evolve_HeadShotDamageBonus * fEffectValue;
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
    ArmorReduction = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 0.5, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.BonusIsHardValue
                     }
    PiercingRange = {
                     DynamicBonuses = (), 
                     RankBonuses[0] = 0.0, 
                     RankBonuses[1] = 0.400000006, 
                     RankBonuses[2] = 0.0, 
                     RankBonuses[3] = 0.0, 
                     RankBonuses[4] = 0.0, 
                     RankBonuses[5] = 0.0, 
                     BaseValue = 0.5, 
                     CurrentValue = 0.0, 
                     Formula = EPowerDataFormula.Normal
                    }
    PiercingDamage = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 0.5, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.Normal
                     }
    Evolve_DamageBonus1 = 0.0599999987
    Evolve_DamageBonus2 = 0.100000001
    Evolve_AmmoCapacityBonus = 0.300000012
    Evolve_HeadShotDamageBonus = 0.25
    Evolve_PiercingBonus = 0.600000024
    Evolve_ArmorReductionBonus = 0.25
    WeaponPowerEffectClass = Class'SFXGameEffect_ArmorPiercingAmmo'
    ConcussiveShotDamageType = Class'SFXDamageType_ConcussiveShot_ArmorPiercing'
    oTracer = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Yellow_Mesh'
    oImpactVFX = ParticleSystem'BioVFX_C_Impacts.Armor.Particles.Armor_Imp'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_ArmorPiercing'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_ArmorPiercing'
    CE_ConcussiveShotImpact = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Piercing_Imp_VCFX'
    CE_ConcussiveShotProjectile = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Piercing_Proj_VCFX'
    ConcussiveShotImpactSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_concussiveshot_armor'
    bModifyTracer = TRUE
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    DefaultDamageType = Class'SFXDamageType_ArmorPiercingAmmo'
    CastAnimSet = MY_DYN_HMM_BC_SniperSpecial
    Damage = {RankBonuses[2] = 0.0399999991, BaseValue = 0.100000001, Formula = EPowerDataFormula.BonusIsHardValue}
    Ranks = ({
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $93965, 
              Evolved1Description = $700231, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573493, 
              Evolved1Description = $573498, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573494, 
              Evolved1Description = $700232, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573499, 
              Evolved1Description = $573505, 
              Evolved2Name = $573500, 
              Evolved2Description = $573506
             }, 
             {
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573501, 
              Evolved1Description = $573507, 
              Evolved2Name = $573502, 
              Evolved2Description = $573508
             }, 
             {
              Icon = 58, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573503, 
              Evolved1Description = $573509, 
              Evolved2Name = $573504, 
              Evolved2Description = $573510
             }
            )
    PowerName = 'ArmorPiercingAmmo'
    PowerCustomActionID = 20
    DisplayName = $93965
    Description = $155053
    Icon = 58
    TalentDescription = $155053
    IsBonusPower = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Ammo
}