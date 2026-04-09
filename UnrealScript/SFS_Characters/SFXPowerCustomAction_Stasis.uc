Class SFXPowerCustomAction_Stasis extends SFXPowerCustomAction
    config(Game);

var config PowerData StasisBubbleRadius;
var config PowerData HealthDamageThreshold;
var config PowerData PushAwayForce;
var array<Actor> m_oAffectedTargets;
var array<Actor> m_oCurrentStasisTargets;
var config array<Name> EffectsToRemove;
var config AreaEffectParameters StasisBubbleParameters;
var Guid StasisBubbleGuid;
var Vector StasisBubbleLocation;
var transient Vector StasisBubbleNormal;
var float StasisBubbleTimer;
var float LookForActorsTimer;
var config float LookForActorsInterval;
var config float Evolve_DurationBonus;
var config float Evolve_CooldownBonus;
var config float Evolve_VulnerableDamageBonus;
var config float Evolve_NoCooldownChance;
var config float Evolve_DamageTakenBonus;
var config float Evolve_HealthThresholdPct;
var SFXPawn LastImpactedPawn;
var stringref TargetImmuneToStasis;
var RvrClientEffectInterface CE_StasisBubble;
var bool bStasisBubbleActive;
var transient bool bClientCanProcessNoCooldown;
var transient EClientNoCooldownDecision ClientNoCooldown;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local float fDuration;
    local SFXGameEffect_Stasis StasisEffect;
    local int Index;
    local float fDamage;
    local Vector vForce;
    local Actor oTargetOverride;
    
    if (Resistance == EPowerResistance.Resistance_Full)
    {
        return FALSE;
    }
    if (m_oAffectedTargets.Find(oImpacted) != -1)
    {
        return FALSE;
    }
    LastImpactedPawn = SFXPawn(oImpacted);
    if (LastImpactedPawn == None || LastImpactedPawn.HasResistance(3))
    {
        return FALSE;
    }
    if (LastImpactedPawn.bCanRagdoll == FALSE || LastImpactedPawn.bAffectedByRagdollPowers == FALSE)
    {
        return FALSE;
    }
    fDuration = EffectDuration.CurrentValue * (1.0 - LastImpactedPawn.PowerControlResistance);
    if (fDuration <= float(0))
    {
        return FALSE;
    }
    Manager = LastImpactedPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    if (Manager.HasEffectOfType(Class'SFXGameEffect_Stasis'))
    {
        if (oImpacted.Role == ENetRole.ROLE_Authority)
        {
            return FALSE;
        }
        else
        {
            Manager.RemoveEffectsByType(Class'SFXGameEffect_Stasis');
        }
    }
    for (Index = Manager.GameEffects.Length - 1; Index >= 0; Index--)
    {
        if (Manager.GameEffects[Index].Class.Name == 'SFXGameEffect_DelayedCryoFreeze' || Manager.GameEffects[Index].Class.Name == 'SFXGameEffect_CryoFreeze')
        {
            if (oImpacted.Role == ENetRole.ROLE_Authority)
            {
                return FALSE;
                continue;
            }
            Manager.RemoveEffectAt(Index);
        }
    }
    if (MaximumRagdollTargets.CurrentValue > float(0) && float(m_oCurrentStasisTargets.Length) >= MaximumRagdollTargets.CurrentValue)
    {
        fDamage = 0.0;
        HitNormal = Normal(oImpacted.location - StasisBubbleLocation);
        vForce = HitNormal * PushAwayForce.CurrentValue;
        Resistance = oImpacted.GetPowerResistance(m_oPawn, StasisBubbleLocation, HitNormal, fDamage, vForce, DefaultDamageType, oTargetOverride);
        if (oTargetOverride != None)
        {
            oImpacted = oTargetOverride;
        }
        oImpacted.ImpactWithPower(Resistance, m_oPawn, StasisBubbleLocation, HitNormal, fDamage, vForce, DefaultDamageType);
        LastImpactedPawn = SFXPawn(oImpacted);
        if (LastImpactedPawn != None)
        {
            LastImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistPartialControlValue);
        }
        return TRUE;
    }
    for (Index = Manager.GameEffects.Length - 1; Index >= 0; Index--)
    {
        if (EffectsToRemove.Find(Manager.GameEffects[Index].Class.Name) != -1)
        {
            Manager.RemoveEffectAt(Index);
        }
    }
    StasisEffect = SFXGameEffect_Stasis(Manager.CreateEffect(Class'SFXGameEffect_Stasis', Name, fDuration, 1, 1.0, m_oPawn.Controller));
    if (StasisEffect != None)
    {
        StasisEffect.HealthThreshold = HealthDamageThreshold.CurrentValue;
        StasisEffect.Power = Self;
        if (IsEvolvedWithChoice(5))
        {
            ApplyTemporaryGameEffect(LastImpactedPawn, Class'SFXGameEffect_DamageTakenBonus', fDuration, Evolve_DamageTakenBonus, Name, m_oPawn.Controller);
        }
        StasisEffect.OnApplied();
    }
    AddComboEffect(oImpacted, Class'SFXGameEffect_PowerCombo_Biotic', fDuration);
    ApplyTemporaryGameEffect(LastImpactedPawn, Class'SFXGameEffect_AntiGravity', fDuration, 0.0, Name, m_oPawn.Controller);
    ApplyTemporaryGameEffect(LastImpactedPawn, Class'SFXGameEffect_HealthRegenPenalty', fDuration, 1.0, Name, m_oPawn.Controller);
    LastImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistFullControlValue);
    LastImpactedPawn.PowerControlResistance += (1.0 - LastImpactedPawn.PowerControlResistance) * 0.5;
    if (LastImpactedPawn.PowerControlResistance > 0.899999976)
    {
        LastImpactedPawn.PowerControlResistance = 1.0;
    }
    if (m_oCurrentStasisTargets.Find(LastImpactedPawn) == -1)
    {
        m_oCurrentStasisTargets.AddItem(LastImpactedPawn);
    }
    m_oAffectedTargets.AddItem(LastImpactedPawn);
    return TRUE;
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local SFXPawn oPawn;
    
    oPawn = SFXPawn(Target);
    if (oPawn != None)
    {
        if (oPawn.HasResistance(3))
        {
            sOptionalInfo = string(NotRecommended_TargetHasArmor);
            return FALSE;
        }
        else if (oPawn.PowerControlResistance >= 1.0)
        {
            sOptionalInfo = string(NotRecommended_TargetImmune);
            return FALSE;
        }
    }
    return TRUE;
}
public function StartCustomAction()
{
    UnStasisCurrentTargets();
    StopStasisBubble(FALSE);
    m_oAffectedTargets.Length = 0;
    Super.StartCustomAction();
}
public event function TickCustomAction(float fDeltaTime)
{
    Super.TickCustomAction(fDeltaTime);
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (IsEvolvedWithChoice(4) && bStasisBubbleActive)
        {
            StasisBubbleTimer -= fDeltaTime;
            if (StasisBubbleTimer < float(0))
            {
                StopStasisBubble(TRUE);
                return;
            }
            LookForActorsTimer -= fDeltaTime;
            if (LookForActorsTimer < float(0))
            {
                LookForActorsTimer = LookForActorsInterval;
                AreaExplosion(StasisBubbleLocation, StasisBubbleRadius.CurrentValue, 0.0, DefaultDamageType, 0.0, StasisBubbleParameters, 0, OnImpact);
            }
        }
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    switch (ImpactCount)
    {
        case -1:
            if (!bStasisBubbleActive)
            {
                bStasisBubbleActive = TRUE;
                StasisBubbleLocation = HitLocation;
                StasisBubbleNormal = HitNormal;
                StartStasisBubbleVFX();
            }
            break;
        default:
            Super.ClientDoCustomActionImpact(oActor, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
            break;
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    switch (ImpactCount)
    {
        case -1:
            if (bClientCanProcessNoCooldown)
            {
                ResetPowerCooldown();
            }
            ClientNoCooldown = EClientNoCooldownDecision.NoCooldown_Success;
            break;
        case -2:
            ClientNoCooldown = EClientNoCooldownDecision.NoCooldown_Failure;
            break;
        case -3:
            StopStasisBubble(FALSE);
            break;
        case -4:
            ClientEndStasisEffect(oActor);
            break;
        default:
            DoAreaExplosionForActor(oActor, StasisBubbleLocation, ImpactCount, 0.0, DefaultDamageType, 0.0, StasisBubbleParameters, 0, OnImpact);
            if (BioPawn(oActor) != None)
            {
                BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
            }
    }
    if (ImpactCount > -3 && ImpactCount < 0 && bClientCanProcessNoCooldown)
    {
        bClientCanProcessNoCooldown = FALSE;
        ClientNoCooldown = EClientNoCooldownDecision.NoCooldown_NoDecision;
    }
}
public function DoJoinInProgress()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    local Actor oActor;
    local BioPawn BP;
    
    if (bStasisBubbleActive && ShouldReplicate())
    {
        ReplicateImpact(m_oPawn, -1, , StasisBubbleLocation, StasisBubbleNormal);
    }
    foreach m_oCurrentStasisTargets(oActor, )
    {
        if (oActor != None)
        {
            Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                foreach Manager.GameEffects(oEffect, )
                {
                    if (oEffect.Category == Name)
                    {
                        BP = BioPawn(oActor);
                        if (BP != None)
                        {
                            ReplicatePowerSubsequentImpact(BP, BP.CurrentCustomAction);
                            break;
                        }
                    }
                }
            }
        }
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
            AddEvolvedRankBonus(HealthDamageThreshold, Evolve_HealthThresholdPct);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(HealthDamageThreshold, Evolve_DamageTakenBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function OnOwnerDestroyed()
{
    if (bStasisBubbleActive)
    {
        StopStasisBubble(FALSE);
    }
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    Super.OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (IsEvolvedWithChoice(4))
    {
        bStasisBubbleActive = TRUE;
        StasisBubbleTimer = EffectDuration.CurrentValue;
        StasisBubbleLocation = HitLocation;
        StasisBubbleNormal = HitNormal;
        StartStasisBubbleVFX();
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[3] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(StasisBubbleRadius, bReset);
    RecalculatePowerData(HealthDamageThreshold, bReset);
    RecalculatePowerData(PushAwayForce, bReset);
}
public function StartPowerCooldown()
{
    bClientCanProcessNoCooldown = TRUE;
    if (!IsEvolvedWithChoice(2) || m_oPawn.Role != ENetRole.ROLE_Authority || FRand() > Evolve_NoCooldownChance)
    {
        if (m_oPawn.Role == ENetRole.ROLE_Authority || ClientNoCooldown != EClientNoCooldownDecision.NoCooldown_Success)
        {
            Super.StartPowerCooldown();
        }
        if (m_oPawn.Role == ENetRole.ROLE_Authority)
        {
            ReplicatePowerSubsequentImpact(m_oPawn, , , -2);
        }
    }
    else if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        ReplicatePowerSubsequentImpact(m_oPawn, , , -1);
    }
    if (m_oPawn.Role != ENetRole.ROLE_Authority && ClientNoCooldown != EClientNoCooldownDecision.NoCooldown_NoDecision)
    {
        bClientCanProcessNoCooldown = FALSE;
        ClientNoCooldown = EClientNoCooldownDecision.NoCooldown_NoDecision;
    }
}
public final function ClientEndStasisEffect(Actor oActor)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_Stasis Effect;
    
    Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Effect = SFXGameEffect_Stasis(Manager.GetFirstEffectOfTypeAndCategory(Class'SFXGameEffect_Stasis', Name));
        if (Effect != None)
        {
            Effect.UnStasisTarget();
        }
    }
}
public function OnGameEffectEnded(Actor oActor)
{
    m_oCurrentStasisTargets.RemoveItem(oActor);
}
public final function StartStasisBubbleVFX()
{
    local Vector VParam;
    local RvrClientEffectManager Manager;
    
    if (CE_StasisBubble != None)
    {
        Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
        if (Manager != None)
        {
            VParam.Y = StasisBubbleRadius.CurrentValue / 100.0;
            StasisBubbleGuid = Manager.StartAtLocation(CE_StasisBubble, StasisBubbleLocation, StasisBubbleNormal, VParam);
        }
        else
        {
            m_oPawn.SetTimer(0.100000001, FALSE, 'StartStasisBubbleVFX', Self);
        }
    }
}
public function StopStasisBubble(bool bReplicate)
{
    bStasisBubbleActive = FALSE;
    UnStasisCurrentTargets();
    if (CE_StasisBubble != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_StasisBubble, StasisBubbleGuid, TRUE);
    }
    if (bReplicate && ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(m_oPawn, , , -3);
    }
}
public function UnStasisCurrentTargets()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    local Actor oActor;
    
    foreach m_oCurrentStasisTargets(oActor, )
    {
        if (oActor != None)
        {
            Manager = oActor.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                foreach Manager.GameEffects(oEffect, )
                {
                    if (oEffect.Category == Name)
                    {
                        oEffect.CurrentTime = oEffect.Duration - 0.5;
                    }
                }
            }
        }
    }
    m_oCurrentStasisTargets.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTelekenesis
        m_nmOrigSetName = 'HMM_BC_RifleTelekenesis'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTelekenesis_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTelekenesis_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTelekenesis_BioAnimSetData'
    End Object
    StasisBubbleRadius = {
                          DynamicBonuses = (), 
                          RankBonuses[0] = 0.0, 
                          RankBonuses[1] = 0.0, 
                          RankBonuses[2] = 0.0, 
                          RankBonuses[3] = 0.0, 
                          RankBonuses[4] = 0.0, 
                          RankBonuses[5] = 0.0, 
                          BaseValue = 150.0, 
                          CurrentValue = 0.0, 
                          Formula = EPowerDataFormula.Normal
                         }
    HealthDamageThreshold = {
                             DynamicBonuses = (), 
                             RankBonuses[0] = 0.0, 
                             RankBonuses[1] = 0.0, 
                             RankBonuses[2] = 0.0, 
                             RankBonuses[3] = 0.0, 
                             RankBonuses[4] = 0.0, 
                             RankBonuses[5] = 0.0, 
                             BaseValue = 150.0, 
                             CurrentValue = 0.0, 
                             Formula = EPowerDataFormula.Normal
                            }
    PushAwayForce = {
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
    EffectsToRemove = ('SFXGameEffect_Singularity', 'SFXGameEffect_Pull', 'SFXGameEffect_AntiGravity')
    LookForActorsInterval = 0.5
    Evolve_DurationBonus = 0.400000006
    Evolve_CooldownBonus = 0.349999994
    Evolve_VulnerableDamageBonus = 0.5
    Evolve_NoCooldownChance = 0.300000012
    Evolve_DamageTakenBonus = 0.349999994
    Evolve_HealthThresholdPct = 1.5
    TargetImmuneToStasis = $366134
    CE_StasisBubble = RvrClientEffect'BioVFX_B_Stasis.VCFX.Stasis_Sphere_VCFX'
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_P_stasis_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_P_stasis_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_NP_stasis_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_NP_stasis_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    DefaultDamageType = Class'SFXDamageType_Stasis'
    ReleaseTime = 0.400000006
    CastAnimSet = MY_DYN_HMM_BC_RifleTelekenesis
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_RifleTelekinesis'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.Biotics_Charge_VCFX'
    CE_ImpactTemplate = RvrClientEffect'BioVFX_B_Stasis.VCFX.Stasis_Impact_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_P_stasis_impact'
    CastSound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_P_stasis_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_NP_stasis_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Biotic_Stasis.Play_power_biotic_NP_stasis_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 12.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    MaximumImpactTargets = {BaseValue = 1.0}
    MaximumRagdollTargets = {BaseValue = 2.0}
    EffectDuration = {RankBonuses[2] = 0.300000012, BaseValue = 6.0}
    Damage = {BaseValue = 25.0}
    Ranks = ({
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $127059, 
              Evolved1Description = $365834, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $170381, 
              Evolved1Description = $501646, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $158540, 
              Evolved1Description = $716444, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $543467, 
              Evolved1Description = $543473, 
              Evolved2Name = $543468, 
              Evolved2Description = $543474
             }, 
             {
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $543469, 
              Evolved1Description = $543475, 
              Evolved2Name = $543470, 
              Evolved2Description = $543476
             }, 
             {
              Icon = 76, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $543472, 
              Evolved1Description = $543477, 
              Evolved2Name = $543471, 
              Evolved2Description = $543478
             }
            )
    PowerName = 'Stasis'
    PowerCustomActionID = 7
    DisplayName = $127059
    Description = $703654
    Icon = 76
    TalentDescription = $703654
    IsBonusPower = TRUE
    bDisableLeftHandIK = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Stasis
}