Class SFXPowerCustomAction_FragGrenade extends SFXPowerCustomAction_GrenadeBase
    config(Game);

var config PowerData MaxGrenadeBonus;
var config float Evolve_DamageBonus;
var config float Evolve_RadiusBonus;
var config int Evolve_GrenadeCountBonus;
var config float Evolve_ShieldDamageBonus;
var config float Evolve_ArmorDamageBonus;
var config float Evolve_DoTDamage;
var config float Evolve_DoTDuration;
var config int Rank2GrenadeUpgrade;
var RvrClientEffectInterface CE_GrenadeImpact;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_DamageOverTime Effect;
    local BioPawn oPawn;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn == None)
    {
        return FALSE;
    }
    if (Resistance != EPowerResistance.Resistance_Full && IsEvolvedWithChoice(3) && oPawn.RaceType != ERaceType.RaceType_Machine)
    {
        Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Effect = SFXGameEffect_DamageOverTime(Manager.CreateEffect(Class'SFXGameEffect_DamageOverTime', Name, Evolve_DoTDuration, 1, Evolve_DoTDamage * Damage.CurrentValue / Evolve_DoTDuration, m_oPawn.Controller));
            if (Effect != None)
            {
                Effect.DamageType = GetDamageType();
                Effect.OnApplied();
            }
        }
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
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(MaxGrenadeBonus, float(Evolve_GrenadeCountBonus));
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGrenadeBonus();
}
public function Class<SFXDamageType> GetDamageType()
{
    if (IsEvolvedWithChoice(4))
    {
        return Class'SFXDamageType_FragGrenade_Armor';
    }
    else if (IsEvolvedWithChoice(5))
    {
        return Class'SFXDamageType_FragGrenade_Shields';
    }
    else
    {
        return Class'SFXDamageType_FragGrenade';
    }
}
public function Vector GetDefaultClientEffectParams()
{
    local Vector Param;
    
    if (IsEvolvedWithChoice(1))
    {
        Param.Y = 1.0;
    }
    if (IsEvolvedWithChoice(5))
    {
        Param.Z = 1.0;
    }
    return Param;
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    DamageType = GetDamageType();
    return Damage.CurrentValue;
}
public function PlayDetonationEffects(Vector ImpactLocation, Vector ImpactNormal, optional SFXProjectile_PowerCustomAction oProjectile)
{
    Super(SFXPowerCustomAction).PlayDetonationEffects(ImpactLocation, ImpactNormal, oProjectile);
    if (CE_GrenadeImpact != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_GrenadeImpact, ImpactLocation, vect(1.0, 0.0, 0.0), GetDefaultClientEffectParams());
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = Damage;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].Data = ImpactRadius;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_ImpactRadius;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_RadiusBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(MaxGrenadeBonus, bReset);
}
public function ApplyGrenadeBonus()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory(Name);
    }
    if (MaxGrenadeBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MaxGrenadeBonus', MaxGrenadeBonus.CurrentValue, Name, m_oPawn.Controller);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_CB_Grenade
        m_nmOrigSetName = 'HMM_CB_Grenade'
        Sequences = (AnimSequence'BIOG_HMM_CB_A.HMM_CB_Grenade_CB_Grenade2')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_A.HMM_CB_Grenade_BioAnimSetData'
    End Object
    MaxGrenadeBonus = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 1.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 0.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.BonusIsHardValue
                      }
    Evolve_DamageBonus = 0.300000012
    Evolve_RadiusBonus = 0.300000012
    Evolve_GrenadeCountBonus = 2
    Evolve_ShieldDamageBonus = 0.5
    Evolve_ArmorDamageBonus = 0.5
    Evolve_DoTDamage = 0.400000006
    Evolve_DoTDuration = 10.0
    Rank2GrenadeUpgrade = 1
    CE_GrenadeImpact = RvrClientEffect'BioVFX_C_Grenades.Generic.VCFX.FragGrenade_Imp_VCFX'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Fire', Class'SFXGameEffect_PowerCombo_Cryo')
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_P_fraggren_emp', bAnyEvolved = FALSE, bReplaceBaseSound = FALSE, EvolveChoice = EEvolveChoice.EvolveChoice6}, 
                           {Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_P_fraggren_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_P_fraggren_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_NP_fraggren_emp', bAnyEvolved = FALSE, bReplaceBaseSound = FALSE, EvolveChoice = EEvolveChoice.EvolveChoice6}, 
                                   {Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_NP_fraggren_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_NP_fraggren_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_FragGrenade'
    DetonationRumbleClass = Class'SFXRumble_Power_FragGrenade'
    DetonationScreenShakeClass = Class'SFXShake_Power_FragGrenade'
    CastAnimSet = MY_DYN_HMM_CB_Grenade
    ImpactSound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_P_fraggren_impact'
    CastSound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_P_fraggren_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_NP_fraggren_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Soldier_FragGren.Play_power_soldier_NP_fraggren_cast'
    ImpactDistanceLayer = WwiseEvent'Wwise_Generic_Explosions.Play_power_soldier_P_fraggren_distant'
    HenchmanImpactDistanceLayer = WwiseEvent'Wwise_Generic_Explosions.Play_power_soldier_NP_flashgren_distant'
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {BaseValue = 650.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 600.0}
    Force = {BaseValue = 1500.0}
    Ranks = ({
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506269, 
              Evolved1Description = $506270, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506273, 
              Evolved1Description = $506287, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506274, 
              Evolved1Description = $506278, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506280, 
              Evolved1Description = $506281, 
              Evolved2Name = $506282, 
              Evolved2Description = $506283
             }, 
             {
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506288, 
              Evolved1Description = $506289, 
              Evolved2Name = $506290, 
              Evolved2Description = $506296
             }, 
             {
              Icon = 78, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506295, 
              Evolved1Description = $506294, 
              Evolved2Name = $506293, 
              Evolved2Description = $506291
             }
            )
    PowerName = 'FragGrenade'
    PowerCustomActionID = 25
    DisplayName = $506269
    Description = $703562
    Icon = 78
    TalentDescription = $703562
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Flashbang
}