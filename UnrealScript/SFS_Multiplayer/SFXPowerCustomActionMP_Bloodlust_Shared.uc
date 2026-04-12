Class SFXPowerCustomActionMP_Bloodlust_Shared extends SFXPowerCustomAction
    config(Game);

var config PowerData MovementSpeedBonus;
var config PowerData HealthRegenerationBonus;
var config PowerData MeleeDamageBonus;
var config PowerData EncumbrancePenalty;
var Guid BloodLustGuid;
var RvrClientEffectInterface CE_BloodLust[3];
var config float Evolve_MeleeDamageBonus;
var config float Evolve_HealthRegenerationBonus1;
var config float Evolve_PowerDamageBonus;
var config float Evolve_WeaponDamageBonus;
var config float Evolve_MovementComboBonus;
var config float Evolve_MeleeDamageComboBonus;
var config float Evolve_HealthRegenerationBonus2;
var config float ChanceToGrowl1;
var config float ChanceToGrowl2;
var config float ChanceToGrowl3;
var WwiseEvent Growl;
var float LastTimeChecked;
var config int MaxCharges;
var int CurrentCharges;
var float UpdateFrequency;
var bool IsActive;
var bool bStopMovement;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager GEManager;
    
    GEManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager != None)
    {
        if (GEManager.HasEffectOfCategory(Name))
        {
            EndBloodlust();
        }
        else
        {
            StartBloodlust();
        }
        return TRUE;
    }
    return FALSE;
}
public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    return TRUE;
}
public function StartCustomAction()
{
    local SFXPlayerController PC;
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && Manager.HasEffectOfCategory(Name))
    {
        CastAnimSet = None;
    }
    else
    {
        CastAnimSet = default.CastAnimSet;
        PC = SFXPlayerController(m_oPawn.Controller);
        if (PC != None && bStopMovement == FALSE)
        {
            PC.m_bPermanentWalk = TRUE;
            bStopMovement = TRUE;
        }
    }
    Super.StartCustomAction();
}
public function TickCustomAction(float fDeltaTime)
{
    local WorldInfo WI;
    
    Super.TickCustomAction(fDeltaTime);
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        if (WI.TimeSeconds - LastTimeChecked > UpdateFrequency)
        {
            LastTimeChecked = WI.TimeSeconds;
            if (CurrentCharges == 1)
            {
                if (FRand() <= ChanceToGrowl1)
                {
                    m_oPawn.PlaySound(Growl, TRUE);
                }
            }
            else if (CurrentCharges == 2)
            {
                if (FRand() <= ChanceToGrowl2)
                {
                    m_oPawn.PlaySound(Growl, TRUE);
                }
            }
            else if (CurrentCharges == 3)
            {
                if (FRand() <= ChanceToGrowl3)
                {
                    m_oPawn.PlaySound(Growl, TRUE);
                }
            }
        }
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (ImpactCount <= 0)
    {
        CurrentCharges = -ImpactCount;
        DeferredIncreaseBloodlustCount();
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(MeleeDamageBonus, Evolve_MeleeDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(HealthRegenerationBonus, Evolve_HealthRegenerationBonus1);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(MovementSpeedBonus, Evolve_MovementComboBonus);
            AddEvolvedRankBonus(MeleeDamageBonus, Evolve_MeleeDamageComboBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(HealthRegenerationBonus, Evolve_HealthRegenerationBonus2);
            break;
        default:
    }
    RecalculateAllPowerData();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 5;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Normal;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[2].Data = MovementSpeedBonus;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[2].srStatBarDisplayTitle = $734844;
    PowerStatBars[2].EvolvedBonuses[4] = Evolve_MovementComboBonus;
    PowerStatBars[3].Data = HealthRegenerationBonus;
    PowerStatBars[3].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Normal;
    PowerStatBars[3].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[3].srStatBarDisplayTitle = $734213;
    PowerStatBars[3].EvolvedBonuses[1] = Evolve_HealthRegenerationBonus1;
    PowerStatBars[3].EvolvedBonuses[5] = Evolve_HealthRegenerationBonus2;
    PowerStatBars[4].Data = MeleeDamageBonus;
    PowerStatBars[4].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[4].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[4].srStatBarDisplayTitle = StatBarTitle_MeleeDamage;
    PowerStatBars[4].EvolvedBonuses[0] = Evolve_MeleeDamageBonus;
    PowerStatBars[4].EvolvedBonuses[4] = Evolve_MeleeDamageComboBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(MovementSpeedBonus, bReset);
    RecalculatePowerData(HealthRegenerationBonus, bReset);
    RecalculatePowerData(MeleeDamageBonus, bReset);
    RecalculatePowerData(EncumbrancePenalty, bReset);
}
public function StartPowerCooldown();

public function StopCustomAction()
{
    local SFXPlayerController PC;
    
    Super.StopCustomAction();
    PC = SFXPlayerController(m_oPawn.Controller);
    if (PC != None && bStopMovement)
    {
        PC.m_bPermanentWalk = FALSE;
        bStopMovement = FALSE;
    }
}
public function StartBloodlust()
{
    IsActive = TRUE;
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        IncreaseBloodlustCount();
    }
}
public function StopTryingBloodlustRoar()
{
    m_oPawn.ClearTimer('TryStartBloodlustRoar', Self);
}
public function TryStartBloodlustRoar()
{
    if (m_oPawn.StartCustomAction(149))
    {
        StopTryingBloodlustRoar();
    }
}
public function DeferredIncreaseBloodlustCount()
{
    if (IsActive)
    {
        IncreaseBloodlustCount();
    }
    else
    {
        m_oPawn.SetTimer(0.100000001, FALSE, 'DeferredIncreaseBloodlustCount', Self);
    }
}
public function EndBloodlust()
{
    local SFXModule_GameEffectManager GEManager;
    local RvrClientEffectManager CEManager;
    
    IsActive = FALSE;
    m_oPawn.ClearTimer('ResetBloodlust', Self);
    CurrentCharges = 0;
    m_oPawn.PowerManager.SetSharedCooldown(CooldownTime.CurrentValue);
    GEManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager != None)
    {
        GEManager.RemoveEffectsByCategory(Name);
    }
    CEManager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (CEManager != None)
    {
        CEManager.Stop(None, BloodLustGuid, TRUE);
    }
}
public function IncreaseBloodlustCount()
{
    local int nLastBloodlustLevel;
    
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(m_oPawn, , , -CurrentCharges);
    }
    nLastBloodlustLevel = CurrentCharges;
    if (CurrentCharges < MaxCharges)
    {
        CurrentCharges++;
        if (CurrentCharges == MaxCharges && m_oPawn.Role == ENetRole.ROLE_Authority)
        {
            m_oPawn.SetTimer(0.5, TRUE, 'TryStartBloodlustRoar', Self);
            m_oPawn.SetTimer(2.0, FALSE, 'StopTryingBloodlustRoar', Self);
        }
    }
    PlayBloodlustEffects(CurrentCharges, nLastBloodlustLevel);
}
public function PlayBloodlustEffects(int BloodlustLevel, int LastBloodlustLevel)
{
    local SFXPowerManager PowerManager;
    local SFXModule_GameEffectManager GEManager;
    local RvrClientEffectManager CEManager;
    local RvrClientEffectTarget Target;
    
    if (BloodlustLevel == 0 || BloodlustLevel > MaxCharges)
    {
        return;
    }
    if (BloodlustLevel != MaxCharges || LastBloodlustLevel != MaxCharges)
    {
        CEManager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
        if (CEManager != None)
        {
            CEManager.Stop(None, BloodLustGuid, TRUE);
            Target.Instigator = m_oPawn;
            BloodLustGuid = CEManager.StartOnTarget(CE_BloodLust[BloodlustLevel - 1], Target, m_oPawn.Controller);
        }
    }
    PowerManager = m_oPawn.PowerManager;
    if (PowerManager != None)
    {
        GEManager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (GEManager != None)
        {
            GEManager.RemoveEffectsByCategory(Name);
            ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MovementSpeedBonus', MovementSpeedBonus.CurrentValue * float(BloodlustLevel), Name, m_oPawn.Controller);
            ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_HealOverTime', HealthRegenerationBonus.CurrentValue * float(BloodlustLevel), Name, m_oPawn.Controller);
            ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MeleeDamageBonus', MeleeDamageBonus.CurrentValue * float(BloodlustLevel), Name, m_oPawn.Controller);
            m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'CooldownTime', -EncumbrancePenalty.CurrentValue, 0.0, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
            if (IsEvolvedWithChoice(2))
            {
                PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus * float(BloodlustLevel), 0.0, Name, Self);
                PowerManager.ApplyPowerBonus(m_oPawn, 'Force', Evolve_PowerDamageBonus * float(BloodlustLevel), 0.0, Name, Self);
            }
            if (IsEvolvedWithChoice(3))
            {
                ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_WeaponDamageBonus', Evolve_WeaponDamageBonus * float(BloodlustLevel), Name, m_oPawn.Controller);
            }
        }
    }
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (BloodlustLevel == 1)
        {
            m_oPawn.ClearTimer('ResetBloodlust', Self);
        }
        else
        {
            m_oPawn.SetTimer(EffectDuration.CurrentValue, FALSE, 'ResetBloodlust', Self);
        }
    }
}
public function ResetBloodlust()
{
    CurrentCharges = 0;
    IncreaseBloodlustCount();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_VOR_CB_Custom_CON_MP2
        m_nmOrigSetName = 'VOR_CB_Custom_CON_MP2'
        Sequences = (AnimSequence'BIOG_HMM_CB_CON_MP2.VOR_CB_Custom_CON_MP2_CB_VOR_Rage')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_CON_MP2.VOR_CB_Custom_CON_MP2_BioAnimSetData'
    End Object
    MovementSpeedBonus = {
                          DynamicBonuses = (), 
                          RankBonuses[0] = 0.0, 
                          RankBonuses[1] = 0.0, 
                          RankBonuses[2] = 0.0, 
                          RankBonuses[3] = 0.0, 
                          RankBonuses[4] = 0.0, 
                          RankBonuses[5] = 0.0, 
                          BaseValue = 0.0500000007, 
                          CurrentValue = 0.0, 
                          Formula = EPowerDataFormula.BonusIsHardValue
                         }
    HealthRegenerationBonus = {
                               DynamicBonuses = (), 
                               RankBonuses[0] = 0.0, 
                               RankBonuses[1] = 0.0, 
                               RankBonuses[2] = 0.300000012, 
                               RankBonuses[3] = 0.0, 
                               RankBonuses[4] = 0.0, 
                               RankBonuses[5] = 0.0, 
                               BaseValue = 50.0, 
                               CurrentValue = 0.0, 
                               Formula = EPowerDataFormula.Normal
                              }
    MeleeDamageBonus = {
                        DynamicBonuses = (), 
                        RankBonuses[0] = 0.0, 
                        RankBonuses[1] = 0.0, 
                        RankBonuses[2] = 0.0, 
                        RankBonuses[3] = 0.0, 
                        RankBonuses[4] = 0.0, 
                        RankBonuses[5] = 0.0, 
                        BaseValue = 0.100000001, 
                        CurrentValue = 0.0, 
                        Formula = EPowerDataFormula.BonusIsHardValue
                       }
    EncumbrancePenalty = {
                          DynamicBonuses = (), 
                          RankBonuses[0] = 0.0, 
                          RankBonuses[1] = 0.0, 
                          RankBonuses[2] = 0.0, 
                          RankBonuses[3] = 0.0, 
                          RankBonuses[4] = 0.0, 
                          RankBonuses[5] = 0.0, 
                          BaseValue = 0.600000024, 
                          CurrentValue = 0.0, 
                          Formula = EPowerDataFormula.BonusIsHardValue
                         }
    CE_BloodLust[0] = RvrClientEffect'BioVFX_DLC_MP2_Vorcha.VCFX.BloodLust_01_VCFX'
    CE_BloodLust[1] = RvrClientEffect'BioVFX_DLC_MP2_Vorcha.VCFX.BloodLust_02_VCFX'
    CE_BloodLust[2] = RvrClientEffect'BioVFX_DLC_MP2_Vorcha.VCFX.BloodLust_03_VCFX'
    Evolve_MeleeDamageBonus = 0.100000001
    Evolve_HealthRegenerationBonus1 = 0.5
    Evolve_PowerDamageBonus = 0.0500000007
    Evolve_WeaponDamageBonus = 0.0500000007
    Evolve_MovementComboBonus = 0.0500000007
    Evolve_MeleeDamageComboBonus = 0.100000001
    Evolve_HealthRegenerationBonus2 = 1.0
    ChanceToGrowl1 = 0.0500000007
    ChanceToGrowl2 = 0.200000003
    ChanceToGrowl3 = 0.5
    Growl = WwiseEvent'Wwise_VO_Exertions_DLC_MP2.Play_Exertion_BloodLust_Mode'
    MaxCharges = 3
    UpdateFrequency = 0.5
    BS_EndCastAnimation = {
                           AnimName = ('CB_VOR_Rage', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None'
                                      )
                          }
    CustomCasterCrustParameters = {X = 1.5, Y = 0.0, Z = 0.0}
    CastAnimSet = MY_DYN_VOR_CB_Custom_CON_MP2
    CastCameraAnim = CameraAnim'BioVFX_DLC_CamAnim_MP2.VOR_Rage'
    CameraAnimBlendIn = 0.0500000007
    CameraAnimBlendOut = 0.300000012
    CameraAnimDuration = 2.0
    CastSound = WwiseEvent'Wwise_Power_DLC_Bloodlust.Play_power_DLC_P_bloodlust_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_DLC_Bloodlust.Play_power_DLC_NP_bloodlust_cast'
    LeanOutToCast = FALSE
    bPlayStartCastAnim = FALSE
    bCustomCasterCrustParameters = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 4.0, Formula = EPowerDataFormula.DivideByBonusSum}
    EffectDuration = {BaseValue = 15.0}
    Ranks = ({
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734214, 
              Evolved1Description = $734721, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734216, 
              Evolved1Description = $734217, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734222, 
              Evolved1Description = $734219, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734220, 
              Evolved1Description = $734221, 
              Evolved2Name = $734222, 
              Evolved2Description = $734223
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734224, 
              Evolved1Description = $734225, 
              Evolved2Name = $734226, 
              Evolved2Description = $734227
             }, 
             {
              Icon = 2, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $734228, 
              Evolved1Description = $734229, 
              Evolved2Name = $734230, 
              Evolved2Description = $734231
             }
            )
    PowerName = 'Bloodlust'
    PowerCustomActionID = 38
    DisplayName = $734214
    Description = $734215
    Icon = 2
    IconResource = GFxMovieInfo'GUI_SF_BloodLust.Bloodlust'
    TalentDescription = $734215
    PowerType = EPowerType.PowerType_Buff
    HenchmanPowerType = EPowerType.PowerType_Buff
}