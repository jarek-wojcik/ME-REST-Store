Class SFXPowerCustomAction_Cloak extends SFXPowerCustomAction
    config(Game);

const RTPC_Cloak_Off = 0;
const RTPC_Cloak_On = 1;

var config PowerData DamageBonus;
var string CloakRTPC_Category;
var Name EffectCategory;
var config float MinimumCloakCooldown;
var config float Evolve_DurationBonus;
var config float Evolve_DamageBonus;
var config float Evolve_MeleeDamageBonus;
var config float Evolve_RechargeSpeedBonus;
var config float Evolve_SniperDamageBonus;
var config float BonusRemovalDelay;
var float CloakRTPC_Off_Duration;
var float CloakRTPC_On_Duration;
var float CloakRTPC_UpdateTime;
var float CloakRTPC_CurrentValue;
var stringref srCloakActive;
var config float MinTimeBeforeCancel;
var transient int AuthorativeReplicatedEvent;
var WwiseEvent DecloakSound;
var WwiseEvent HenchmanDecloakSound;
var bool bBreakCloakOnAttack;
var bool bCloakEnded;
var bool bFirstPowerReleased;

public function bool CanUsePower(Actor oTarget)
{
    if (TimeSinceStart < MinTimeBeforeCancel)
    {
        return FALSE;
    }
    return Super.CanUsePower(oTarget);
}
public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local BioPawn oPawn;
    
    if (m_oPawn == None || m_oPawn.Role == ENetRole.ROLE_SimulatedProxy)
    {
        return TRUE;
    }
    if (m_oPawn.Role == ENetRole.ROLE_AutonomousProxy && AuthorativeReplicatedEvent != 0)
    {
        ClientDoPowerSubsequentImpact(m_oPawn, , , AuthorativeReplicatedEvent);
        return TRUE;
    }
    oPawn = BioPawn(oImpacted);
    if (oPawn == None)
    {
        return FALSE;
    }
    if (IsCloakActive())
    {
        m_oPawn.BreakStealth();
        if (ShouldReplicate())
        {
            ReplicatePowerSubsequentImpact(m_oPawn, , , -2);
        }
        return FALSE;
    }
    Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        if (Manager.HasEffectOfCategory(EffectCategory))
        {
            return FALSE;
        }
        ApplyCloak(oPawn);
    }
    return TRUE;
}
public function OnPowerReleased(SFXPowerCustomAction oPower)
{
    if (SFXPowerCustomAction_Cloak(oPower) == None && oPower.UsesSharedCooldown)
    {
        if (!IsEvolvedWithChoice(4) || bFirstPowerReleased)
        {
            m_oPawn.BreakStealth();
        }
        bFirstPowerReleased = TRUE;
    }
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    if (IsCloakActive())
    {
        sOptionalInfo = string(srCloakActive);
        return FALSE;
    }
    return TRUE;
}
public function StartCustomAction()
{
    if (!IsCloakActive())
    {
        bCloakEnded = FALSE;
        bFirstPowerReleased = FALSE;
    }
    Super.StartCustomAction();
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (m_oPawn.Role == ENetRole.ROLE_AutonomousProxy && !bPowerReleased)
    {
        AuthorativeReplicatedEvent = ImpactCount;
        return;
    }
    switch (ImpactCount)
    {
        case -1:
            if (m_oPawn.Role != ENetRole.ROLE_AutonomousProxy)
            {
                ApplyCloak(BioPawn(oActor));
            }
            else
            {
                TryApplyCloak(BioPawn(oActor));
            }
            break;
        case -2:
            m_oPawn.BreakStealth();
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
            AddEvolvedRankBonus(DamageBonus, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(CooldownTime, Evolve_RechargeSpeedBonus);
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
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[2] = Evolve_RechargeSpeedBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
    PowerStatBars[2].Data = DamageBonus;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[2].srStatBarDisplayTitle = $621116;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_DamageBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(DamageBonus, bReset);
}
public function StartPowerCooldown();

public function ActivateCloakRTPC()
{
    local float RTPC_Change;
    
    if (bCloakEnded)
    {
        return;
    }
    RTPC_Change = CloakRTPC_UpdateTime / CloakRTPC_On_Duration;
    CloakRTPC_CurrentValue += RTPC_Change;
    CloakRTPC_CurrentValue = FMin(CloakRTPC_CurrentValue, 1.0);
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(CloakRTPC_Category, CloakRTPC_CurrentValue);
    if (CloakRTPC_CurrentValue < float(1))
    {
        m_oPawn.SetTimer(CloakRTPC_UpdateTime, FALSE, 'ActivateCloakRTPC', Self);
    }
}
public function ApplyCloak(BioPawn oPawn)
{
    local SFXGameEffect oEffect;
    local SFXGameEffect_Cloak oCloakEffect;
    local float fDuration;
    local float fDamageMultiplier;
    local SFXWeapon Weapon;
    local SFXWeapon_SniperRifle_Base SniperRifle;
    local SFXModule_GameEffectManager Manager;
    local float fMeleeDamageBonus;
    
    if (oPawn == None)
    {
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    fDuration = EffectDuration.CurrentValue;
    oCloakEffect = SFXGameEffect_Cloak(Manager.CreateEffect(Class'SFXGameEffect_Cloak', EffectCategory, fDuration, 1, 0.0));
    if (oCloakEffect != None)
    {
        ActivateCloakRTPC();
        oCloakEffect.__OnCloakEnded__Delegate = OnCloakEnded;
        oCloakEffect.OnApplied();
    }
    fDamageMultiplier = DamageBonus.CurrentValue;
    oEffect = Manager.CreateEffect(Class'SFXGameEffect_CloakDamageBonus', Name, fDuration, 1, fDamageMultiplier);
    if (oEffect != None)
    {
        oEffect.OnApplied();
    }
    m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', fDamageMultiplier, fDuration, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
    fMeleeDamageBonus = fDamageMultiplier;
    if (IsEvolvedWithChoice(3))
    {
        fMeleeDamageBonus += Evolve_MeleeDamageBonus;
    }
    ApplyTemporaryGameEffect(m_oPawn, Class'SFXGameEffect_MeleeDamageBonus', fDuration, fMeleeDamageBonus, Name, m_oPawn.Controller);
    if (SFXPawn_Player(oPawn) != None || SFXPawn_Henchman(oPawn) != None)
    {
        ApplyTemporaryGameEffect(oPawn, Class'SFXGameEffect_StopShieldRegen', fDuration, 1.0, EffectCategory, oPawn.Controller);
    }
    if (IsEvolvedWithChoice(5))
    {
        foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            SniperRifle = SFXWeapon_SniperRifle_Base(Weapon);
            if (SniperRifle == None)
            {
                continue;
            }
            Manager = SniperRifle.GetModule(Class'SFXModule_GameEffectManager');
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXWeaponGameEffect_DamageBonus', Name);
            ApplyPermanentGameEffect(SniperRifle, Class'SFXWeaponGameEffect_DamageBonus', Evolve_SniperDamageBonus, Name, m_oPawn.Controller);
        }
    }
    m_oPawn.PowerManager.RegisterPowerReleasedCallback(OnPowerReleased);
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(oPawn, , , -1);
    }
}
public function DeactivateCloakRTPC()
{
    local float RTPC_Change;
    
    if (!bCloakEnded)
    {
        return;
    }
    RTPC_Change = CloakRTPC_UpdateTime / CloakRTPC_Off_Duration;
    CloakRTPC_CurrentValue -= RTPC_Change;
    CloakRTPC_CurrentValue = FMax(CloakRTPC_CurrentValue, 0.0);
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(CloakRTPC_Category, CloakRTPC_CurrentValue);
    if (CloakRTPC_CurrentValue > float(0))
    {
        m_oPawn.SetTimer(CloakRTPC_UpdateTime, FALSE, 'DeactivateCloakRTPC', Self);
    }
}
public function bool IsCloakActive()
{
    local SFXModule_GameEffectManager Manager;
    
    if (m_oPawn.bIsStealthed)
    {
        return TRUE;
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        if (Manager.HasEffectOfCategory(EffectCategory))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function OnCloakEnded(float TimeInCloak)
{
    local SFXModule_GameEffectManager Manager;
    local SFXWeapon Weapon;
    local SFXWeapon_SniperRifle_Base SniperRifle;
    local float Cooldown;
    local BioCheatManager CheatManager;
    local SFXGameEffect Effect;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Category == Name)
            {
                Effect.DurationType = EDurationType.DurationType_Temporary;
                Effect.CurrentTime = 0.0;
                Effect.Duration = BonusRemovalDelay;
            }
        }
    }
    if (DecloakSound != None && m_oPawn.IsLocallyControlled() && m_oPawn.IsHumanControlled())
    {
        m_oPawn.PlaySound(DecloakSound, TRUE);
    }
    else if (HenchmanDecloakSound != None)
    {
        m_oPawn.PlaySound(HenchmanDecloakSound, TRUE);
    }
    if (IsEvolvedWithChoice(5))
    {
        foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            SniperRifle = SFXWeapon_SniperRifle_Base(Weapon);
            if (SniperRifle == None)
            {
                continue;
            }
            Manager = SniperRifle.GetModule(Class'SFXModule_GameEffectManager');
            foreach Manager.GameEffects(Effect, )
            {
                if (Effect.Category == Name)
                {
                    Effect.DurationType = EDurationType.DurationType_Temporary;
                    Effect.CurrentTime = 0.0;
                    Effect.Duration = BonusRemovalDelay;
                }
            }
        }
    }
    if (SFXPawn_Player(m_oPawn) != None || SFXPawn_Henchman(m_oPawn) != None)
    {
        bCloakEnded = TRUE;
        DeactivateCloakRTPC();
    }
    else
    {
        TimeUntilNextUse = 2.0;
    }
    m_oPawn.PowerManager.UnregisterPowerReleasedCallback(OnPowerReleased);
    CheatManager = m_oPawn.PowerManager.GetCheatManager();
    if (CheatManager != None && CheatManager.m_bEnablePowerCooldown == FALSE)
    {
        return;
    }
    if (EffectDuration.CurrentValue > float(0))
    {
        Cooldown = FMax(MinimumCloakCooldown, Lerp(0.0, GetPowerCooldown(), TimeInCloak / EffectDuration.CurrentValue));
        m_oPawn.PowerManager.SetSharedCooldown(Cooldown);
        m_oPawn.PowerManager.PowerReleased(Self);
    }
}
public function TryApplyCloak(BioPawn oPawn)
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && !Manager.HasEffectOfCategory(EffectCategory))
    {
        ApplyCloak(oPawn);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageBonus = {
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
    CloakRTPC_Category = "Power_Tactical_Cloak"
    EffectCategory = 'BreakableStealth'
    MinimumCloakCooldown = 3.0
    Evolve_DurationBonus = 0.400000006
    Evolve_DamageBonus = 0.400000006
    Evolve_MeleeDamageBonus = 0.5
    Evolve_RechargeSpeedBonus = 0.300000012
    Evolve_SniperDamageBonus = 0.400000006
    BonusRemovalDelay = 1.5
    CloakRTPC_Off_Duration = 0.300000012
    CloakRTPC_On_Duration = 0.75
    CloakRTPC_UpdateTime = 0.100000001
    srCloakActive = $680659
    MinTimeBeforeCancel = 1.0
    DecloakSound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_P_cloak_out'
    HenchmanDecloakSound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_NP_cloak_out'
    bBreakCloakOnAttack = TRUE
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_P_cloak_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_NP_cloak_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    CastSound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_P_cloak_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_TactCloak.Play_power_tech_NP_cloak_cast'
    LeanOutToCast = FALSE
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 20.0, Formula = EPowerDataFormula.DivideByBonusSum}
    EffectDuration = {RankBonuses[2] = 0.300000012, BaseValue = 8.0}
    Ranks = ({
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $245248, 
              Evolved1Description = $245249, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314059, 
              Evolved1Description = $621033, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 33, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $594293, 
              Evolved1Description = $621034, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $621082, 
              Evolved1Description = $621083, 
              Evolved2Name = $621084, 
              Evolved2Description = $621085
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624127, 
              Evolved1Description = $624128, 
              Evolved2Name = $621086, 
              Evolved2Description = $621087
             }, 
             {
              Icon = 59, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624129, 
              Evolved1Description = $624130, 
              Evolved2Name = $537976, 
              Evolved2Description = $633576
             }
            )
    PowerName = 'Cloak'
    PowerCustomActionID = 40
    DisplayName = $245248
    Description = $664219
    Icon = 33
    TalentDescription = $664219
    PowerType = EPowerType.PowerType_Buff
    HenchmanPowerType = EPowerType.PowerType_Buff
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Cloak
}