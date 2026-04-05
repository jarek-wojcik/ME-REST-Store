Class SFXPowerCustomAction_StimPack extends SFXPowerCustomAction_GrenadeBase
    config(Game);

var config PowerData MaxGrenadeBonus;
var config PowerData ShieldStrength;
var config PowerData Duration;
var config PowerData DamageBonus;
var config int Evolve_GrenadeCountBonus;
var config int Rank2GrenadeUpgrade;
var config float Evolve_DamageBonus;
var config float Evolve_Duration;
var config float Evolve_ShieldStrengthBonus;
var config float Evolve_ShieldStrengthBonus2;
var config float Evolve_WeaponDamageBonus;
var config float Evolve_MeleeDamageBonus;
var RvrClientEffectInterface CE_HealCrust;
var RvrClientEffectInterface CE_SuperHealCrust;
var config float DamageImmunityLength;

public function bool CanUsePower(Actor oTarget)
{
    local string EmptyString;
    
    return Super(SFXPowerCustomAction).CanUsePower(oTarget) && ShouldUsePower(oTarget, EmptyString);
}
public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local SFXShield_Base Shields;
    local RvrClientEffectTarget CETarget;
    local SFXModule_GameEffectManager Manager;
    
    oPawn = SFXPawn(oImpacted);
    CETarget.Instigator = m_oPawn;
    CETarget.SpawnValue.X = Duration.CurrentValue;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_HealCrust, CETarget);
    if (IsEvolvedWithChoice(5))
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_SuperHealCrust, CETarget);
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    Manager.RemoveEffectsByCategory(Name);
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_WeaponDamageBonus', Duration.CurrentValue, DamageBonus.CurrentValue, Name, m_oPawn.Controller);
    ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_MeleeDamageBonus', Duration.CurrentValue, DamageBonus.CurrentValue, Name, m_oPawn.Controller);
    m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', DamageBonus.CurrentValue, Duration.CurrentValue, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
    ApplyShieldBonus(m_oPawn, ShieldStrength.CurrentValue, FALSE, Duration.CurrentValue, Name, FALSE);
    Shields = oPawn.GetShields();
    if (Shields != None)
    {
        Shields.SetCurrentShields(Shields.GetMaxShields());
    }
    if (IsEvolvedWithChoice(4))
    {
        ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_WeaponDamageBonus', Duration.CurrentValue, Evolve_WeaponDamageBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(5))
    {
        ApplyTemporaryGameEffect(oImpacted, Class'SFXGameEffect_MeleeDamageBonus', Duration.CurrentValue, Evolve_MeleeDamageBonus, Name, m_oPawn.Controller);
    }
    m_oPawn.bCanBeDamaged = FALSE;
    m_oPawn.SetTimer(DamageImmunityLength, FALSE, 'RemoveImmunity', Self);
    return TRUE;
}
public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    if (GetGrenadeCount() <= 0)
    {
        sOptionalInfo = string(srNoGrenades);
        return FALSE;
    }
    if (SFXPawn_Henchman(m_oPawn) != None && m_oPawn.GetCurrentShields() <= 0.0 && m_oPawn.GetHealthPct() < 0.5)
    {
        return TRUE;
    }
    return TRUE;
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(DamageBonus, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ShieldStrength, Evolve_ShieldStrengthBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(MaxGrenadeBonus, float(Evolve_GrenadeCountBonus));
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(Duration, Evolve_Duration);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(ShieldStrength, Evolve_ShieldStrengthBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGrenadeBonus();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = ShieldStrength;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Normal;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[0].srStatBarDisplayTitle = $766370;
    PowerStatBars[0].EvolvedBonuses[1] = Evolve_ShieldStrengthBonus;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_ShieldStrengthBonus2;
    PowerStatBars[1].Data = DamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = $766367;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[2].Data = Duration;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Normal;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[2].srStatBarDisplayTitle = $766372;
    PowerStatBars[2].EvolvedBonuses[3] = Evolve_Duration;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(ShieldStrength, bReset);
    RecalculatePowerData(Duration, bReset);
    RecalculatePowerData(DamageBonus, bReset);
    RecalculatePowerData(MaxGrenadeBonus, bReset);
}
public function ApplyGrenadeBonus()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_MaxGrenadeBonus', 'StimPackGrenadeBonus');
    }
    if (MaxGrenadeBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MaxGrenadeBonus', MaxGrenadeBonus.CurrentValue, 'StimPackGrenadeBonus', m_oPawn.Controller);
    }
}
private final function RemoveImmunity()
{
    local SFXModule_GameEffectManager Manager;
    local int idx;
    
    if (m_oPawn == None)
    {
        return;
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        for (idx = 0; idx < Manager.GameEffects.Length; idx++)
        {
            if (Manager.GameEffects[idx].IsA('SFXGameEffect_DamageImmunity') == TRUE)
            {
                return;
            }
        }
    }
    m_oPawn.bCanBeDamaged = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTechToolActivate
        m_nmOrigSetName = 'HMM_BC_RifleTechToolActivate'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_Start_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_Start_Cover_Neutral_Mid', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_End', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_End_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BC_End_Cover_Neutral_Mid')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTechToolActivate_BioAnimSetData'
    End Object
    CE_SuperHealCrust = RvrClientEffect'BioVFX_C_Shield.VCFX.ShieldBoost_VCFX'
    BS_EndCastAnimation = {
                           AnimName = ('None', 
                                       'BC_End', 
                                       'BC_End', 
                                       'BC_End_Cover_Neutral', 
                                       'BC_End', 
                                       'BC_End_Cover_Neutral_Mid', 
                                       'BC_End', 
                                       'BC_End', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'BC_End'
                                      )
                          }
    CustomCasterCrustParameters = {X = 1.5, Y = 0.0, Z = 0.0}
    ReleaseTime = 0.0
    CastAnimSet = MY_DYN_HMM_BC_RifleTechToolActivate
    fAnimPlayRate = 2.0
    CastSound = WwiseEvent'Wwise_Crt_DLC_MP4_Tur.Play_crt_turian_mp4_crust_p'
    HenchmanCastSound = WwiseEvent'Wwise_Crt_DLC_MP4_Tur.Play_crt_turian_mp4_crust_np'
    LeanOutToCast = FALSE
    bPlayStartCastAnim = TRUE
    bCustomCasterCrustParameters = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $766365, 
              Evolved1Description = $766366, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $770317, 
              Evolved1Description = $770318, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $766367, 
              Evolved1Description = $766368, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $766367, 
              Evolved1Description = $766369, 
              Evolved2Name = $766370, 
              Evolved2Description = $766371
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $770317, 
              Evolved1Description = $770319, 
              Evolved2Name = $766372, 
              Evolved2Description = $766373
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $766374, 
              Evolved1Description = $766375, 
              Evolved2Name = $766376, 
              Evolved2Description = $766377
             }
            )
    PowerName = 'StimPack'
    PowerCustomActionID = 38
    DisplayName = $766365
    Description = $766366
    Icon = 2
    IconResource = GFxMovieInfo'GUI_SF_SP_StimPak.StimPak'
    TalentDescription = $766366
    PowerType = EPowerType.PowerType_Buff
    HenchmanPowerType = EPowerType.PowerType_Buff
    MinTimeBetweenActions = 0.5
}