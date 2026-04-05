Class SFXPowerCustomAction_DarkChannel extends SFXPowerCustomAction
    config(Game);

var config float Evolve_DamageBonus;
var config float Evolve_DurationBonus;
var config float Evolve_MoveSpeedPenalty;
var config float Evolve_RechargeSpeedBonus;
var config float Evolve_DamageBonus2;
var config float Evolve_ArmorBarrierDamage;
var BioPawn CurrentTarget;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local BioPawn oPawn;
    local SFXGameEffect_DarkChannel oEffect;
    
    if (Resistance == EPowerResistance.Resistance_Full)
    {
        return FALSE;
    }
    oPawn = BioPawn(oImpacted);
    if (oPawn != None)
    {
        if (CurrentTarget != None)
        {
            Manager = CurrentTarget.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                Manager.RemoveEffectsByCategory(Name);
            }
        }
        Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            oEffect = SFXGameEffect_DarkChannel(Manager.CreateEffect(Class'SFXGameEffect_DarkChannel', Name, EffectDuration.CurrentValue, 1, Damage.CurrentValue, m_oPawn.Controller));
            if (oEffect != None)
            {
                if (IsEvolvedWithChoice(5))
                {
                    oEffect.DamageType = Class'SFXDamageType_DarkChannel_Improved';
                }
                else
                {
                    oEffect.DamageType = Class'SFXDamageType_DarkChannel';
                }
                oEffect.Power = Self;
                oEffect.OnApplied();
            }
            if (IsEvolvedWithChoice(2))
            {
                Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, EffectDuration.CurrentValue, 1, -Evolve_MoveSpeedPenalty, m_oPawn.Controller);
            }
            CurrentTarget = oPawn;
        }
        return TRUE;
    }
    return FALSE;
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
        return ShouldUsePowerOnShields(oPawn, Class'SFXDamageType_DarkChannel', sOptionalInfo);
    }
    return TRUE;
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
            AddEvolvedRankBonus(EffectDuration, Evolve_DurationBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(CooldownTime, Evolve_RechargeSpeedBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_RechargeSpeedBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    return 0.0;
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[3] = Evolve_RechargeSpeedBonus;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_DamagePerSecond;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[2].Data = EffectDuration;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_DurationBonus;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ThrowBiotic
        m_nmOrigSetName = 'HMM_BC_ThrowBiotic'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ThrowBiotic_BioAnimSetData'
    End Object
    Evolve_DamageBonus = 0.300000012
    Evolve_DurationBonus = 0.400000006
    Evolve_MoveSpeedPenalty = 0.300000012
    Evolve_RechargeSpeedBonus = 0.349999994
    Evolve_DamageBonus2 = 0.5
    Evolve_ArmorBarrierDamage = 0.75
    ReleaseTime = 0.349999994
    CastAnimSet = MY_DYN_HMM_BC_ThrowBiotic
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_ThrowBiotic'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_Hch_Prothean.VCFX.DarkChannel_Charge_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_Hch_Prothean.VCFX.DarkChannel_Impact_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_P_darkchan_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_P_darkchan_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_NP_darkchan_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_DarkChan.Play_power_biotic_NP_darkchan_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 20.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    EffectDuration = {BaseValue = 30.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 20.0}
    Force = {BaseValue = 50.0}
    Ranks = ({
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $716448, 
              Evolved1Description = $716450, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $170384, 
              Evolved1Description = $717199, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244477, 
              Evolved1Description = $717200, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244477, 
              Evolved1Description = $717201, 
              Evolved2Name = $155499, 
              Evolved2Description = $717202
             }, 
             {
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572679, 
              Evolved1Description = $717203, 
              Evolved2Name = $170384, 
              Evolved2Description = $717204
             }, 
             {
              Icon = 95, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244477, 
              Evolved1Description = $717205, 
              Evolved2Name = $501146, 
              Evolved2Description = $717206
             }
            )
    PowerName = 'DarkChannel'
    PowerCustomActionID = 65
    DisplayName = $716448
    Description = $716450
    Icon = 95
    TalentDescription = $716450
    IsBonusPower = TRUE
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Warp
}