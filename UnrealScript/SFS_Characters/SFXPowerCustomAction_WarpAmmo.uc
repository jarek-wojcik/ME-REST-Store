Class SFXPowerCustomAction_WarpAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

var config PowerData LiftedDamageBonus;
var config PowerData BarrierDamage;
var config PowerData ArmorWeakness;
var config PowerData ArmorWeaknessDuration;
var config float Evolve_DamageBonus1;
var config float Evolve_DamageBonus2;
var config float Evolve_BarrierDamageBonus1;
var config float Evolve_BarrierDamageBonus2;
var config float Evolve_AmmoIncrease;
var config float Evolve_HeadShotDamage;
var config float Evolve_LiftedDamageBonus;
var config float Evolve_ArmorWeaknessBonus;

public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'AmmoPowerDamage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
            ApplyBonusToParameter(BarrierDamage, Bonus, bRemove);
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
            AddEvolvedRankBonus(BarrierDamage, Evolve_BarrierDamageBonus1);
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
            AddEvolvedRankBonus(BarrierDamage, Evolve_BarrierDamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(LiftedDamageBonus, Evolve_LiftedDamageBonus);
            AddEvolvedRankBonus(ArmorWeakness, Evolve_ArmorWeaknessBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 5;
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
    PowerStatBars[2].Data = BarrierDamage;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_BarrierDamage;
    PowerStatBars[2].EvolvedBonuses[0] = Evolve_BarrierDamageBonus1;
    PowerStatBars[2].EvolvedBonuses[4] = Evolve_BarrierDamageBonus2;
    PowerStatBars[3].Data = ArmorWeakness;
    PowerStatBars[3].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[3].srDisplayTotalToken = StatBarToken_NegativePercent;
    PowerStatBars[3].srStatBarDisplayTitle = $700196;
    PowerStatBars[3].EvolvedBonuses[5] = Evolve_ArmorWeaknessBonus;
    PowerStatBars[4].Data = LiftedDamageBonus;
    PowerStatBars[4].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[4].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[4].srStatBarDisplayTitle = $700207;
    PowerStatBars[4].EvolvedBonuses[5] = Evolve_LiftedDamageBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(LiftedDamageBonus, bReset);
    RecalculatePowerData(BarrierDamage, bReset);
    RecalculatePowerData(ArmorWeakness, bReset);
    RecalculatePowerData(ArmorWeaknessDuration, bReset);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    BuffAppliesToSquad = FALSE;
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_WarpAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_WarpAmmo(Manager.CreateEffect(Class'SFXGameEffect_WarpAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
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
    local SFXGameEffect_WarpAmmo effectWarpAmmo;
    local float fEffectValue;
    
    effectWarpAmmo = SFXGameEffect_WarpAmmo(Effect);
    fEffectValue = 1.0;
    if (oPawn != None && oPawn != m_oPawn)
    {
        fEffectValue = SquadEffectiveness;
    }
    if (effectWarpAmmo != None)
    {
        effectWarpAmmo.Damage = Damage.CurrentValue * fEffectValue;
        effectWarpAmmo.LiftedDamageBonus = LiftedDamageBonus.CurrentValue * fEffectValue;
        effectWarpAmmo.ArmorWeakness = ArmorWeakness.CurrentValue * fEffectValue;
        effectWarpAmmo.ArmorWeaknessDuration = ArmorWeaknessDuration.CurrentValue;
        if (IsEvolvedWithChoice(2))
        {
            effectWarpAmmo.SpareAmmoBonus = Evolve_AmmoIncrease * fEffectValue;
        }
        if (IsEvolvedWithChoice(3))
        {
            effectWarpAmmo.HeadShotDamageBonus = Evolve_HeadShotDamage * fEffectValue;
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
    LiftedDamageBonus = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.25, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 0.5, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.BonusIsHardValue
                        }
    BarrierDamage = {
                     DynamicBonuses = (), 
                     RankBonuses[0] = 0.0, 
                     RankBonuses[1] = 0.0, 
                     RankBonuses[2] = 0.100000001, 
                     RankBonuses[3] = 0.0, 
                     RankBonuses[4] = 0.0, 
                     RankBonuses[5] = 0.0, 
                     BaseValue = 0.300000012, 
                     CurrentValue = 0.0, 
                     Formula = EPowerDataFormula.BonusIsHardValue
                    }
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
    ArmorWeaknessDuration = {
                             DynamicBonuses = (), 
                             RankBonuses[0] = 0.0, 
                             RankBonuses[1] = 0.0, 
                             RankBonuses[2] = 0.0, 
                             RankBonuses[3] = 0.0, 
                             RankBonuses[4] = 0.0, 
                             RankBonuses[5] = 0.0, 
                             BaseValue = 4.0, 
                             CurrentValue = 0.0, 
                             Formula = EPowerDataFormula.Normal
                            }
    Evolve_DamageBonus1 = 0.075000003
    Evolve_DamageBonus2 = 0.125
    Evolve_BarrierDamageBonus1 = 0.150000006
    Evolve_BarrierDamageBonus2 = 0.25
    Evolve_AmmoIncrease = 0.300000012
    Evolve_HeadShotDamage = 0.25
    Evolve_LiftedDamageBonus = 0.5
    Evolve_ArmorWeaknessBonus = 0.25
    WeaponPowerEffectClass = Class'SFXGameEffect_WarpAmmo'
    ConcussiveShotDamageType = Class'SFXDamageType_ConcussiveShot_Warp'
    oTracer = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Purple_Mesh'
    oImpactVFX = ParticleSystem'BioVFX_C_Modal.Particles.WarpRounds_Imp'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_Warp'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_Warp'
    CE_ConcussiveShotImpact = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Warp_Imp_VCFX'
    CE_ConcussiveShotProjectile = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Warp_Proj_VCFX'
    ConcussiveShotImpactSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_concussiveshot_warp'
    LoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_P_ammo_warp_cast'
    HenchmanLoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_NP_ammo_warp_cast'
    bModifyTracer = TRUE
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    DefaultDamageType = Class'SFXDamageType_WarpAmmo'
    CastAnimSet = MY_DYN_HMM_BC_SniperSpecial
    Damage = {RankBonuses[2] = 0.0500000007, BaseValue = 0.150000006, Formula = EPowerDataFormula.BonusIsHardValue}
    Ranks = ({
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $339929, 
              Evolved1Description = $326673, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676414, 
              Evolved1Description = $339493, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676415, 
              Evolved1Description = $339495, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676402, 
              Evolved1Description = $676403, 
              Evolved2Name = $676404, 
              Evolved2Description = $676405
             }, 
             {
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505537, 
              Evolved1Description = $505538, 
              Evolved2Name = $505539, 
              Evolved2Description = $505540
             }, 
             {
              Icon = 54, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676416, 
              Evolved1Description = $676417, 
              Evolved2Name = $676418, 
              Evolved2Description = $676419
             }
            )
    PowerName = 'WarpAmmo'
    PowerCustomActionID = 21
    DisplayName = $326671
    Description = $326672
    Icon = 54
    TalentDescription = $326672
    IsBonusPower = TRUE
}