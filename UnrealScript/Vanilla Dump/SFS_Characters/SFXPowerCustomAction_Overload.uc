Class SFXPowerCustomAction_Overload extends SFXPowerCustomAction
    config(Game);

var config PowerData NumCharges;
var config PowerData MaxJumpDistance;
var transient Actor LastHitActor;
var config float Evolve_DamageBonus1;
var config float Evolve_DamageBonus2;
var config int Evolve_NumChargeBonus1;
var config int Evolve_NumChargeBonus2;
var config float Evolve_CooldownBonus;
var config float Evolve_ShieldDamageBonus;
var config float ShieldRegenPenalty;
var config float ShieldRegenPenaltyDuration;
var config float OrganicDamageMultiplier;
var config float JumpDelay;
var config float DamageLossPerHit;
var RvrClientEffectInterface CE_HitWallTemplate;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_OverloadChain Effect;
    local BioPawn oPawn;
    
    if (m_oPawn != None)
    {
        TestAchievement(oImpacted);
        Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
        Effect = CreateOverloadChainEffect(Manager);
        if (Effect != None)
        {
            LastHitActor = oImpacted;
            Effect.OnApplied();
            oPawn = BioPawn(oImpacted);
            if (oPawn != None && oPawn.IsInvisible())
            {
                oPawn.BreakStealth();
            }
            return TRUE;
        }
    }
    return FALSE;
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(Target);
    if (oPawn == None || oPawn.RaceType == ERaceType.RaceType_Machine)
    {
        return TRUE;
    }
    if (int(oPawn.GetCurrentResistance()) != 0)
    {
        return ShouldUsePowerOnShields(oPawn, Class'SFXDamageType_Overload', sOptionalInfo);
    }
    return TRUE;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'ImpactRadius':
            ApplyBonusToParameter(MaxJumpDistance, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    local SFXGameEffect_OverloadChain Effect;
    local SFXModule_GameEffectManager Manager;
    local int i;
    
    if (m_oPawn == None)
    {
        return;
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    Effect = CreateOverloadChainEffect(Manager);
    if (Effect != None)
    {
        Effect.Damage = Damage.CurrentValue;
        for (i = 0; i < ImpactCount; i++)
        {
            Effect.Damage = Effect.Damage - Effect.Damage * Effect.DamageLossPerHit;
        }
        Effect.Target = LastHitActor;
        LastHitActor = oActor;
        Effect.ImpactAdditionalTarget(oActor);
        Manager.RemoveEffect(Effect);
    }
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
            AddEvolvedRankBonus(NumCharges, float(Evolve_NumChargeBonus1));
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus1);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(NumCharges, float(Evolve_NumChargeBonus2));
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
public function float GetImpactForce(Actor oImpacted)
{
    return 0.0;
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    Super.OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (m_ImpactedActors.Length == 0)
    {
        if (SFXPawn_Henchman(m_oPawn) != None)
        {
            PlayImpactSounds(HitLocation, HenchmanImpactSound, HenchmanEvolvedImpactSounds);
        }
        else
        {
            PlayImpactSounds(HitLocation, ImpactSound, EvolvedImpactSounds);
        }
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_HitWallTemplate, HitLocation, HitNormal, GetDefaultClientEffectParams());
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[3] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_DamageBonus1;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_DamageBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(NumCharges, bReset);
    RecalculatePowerData(MaxJumpDistance, bReset);
}
public function SFXGameEffect_OverloadChain CreateOverloadChainEffect(SFXModule_GameEffectManager oManager)
{
    local SFXGameEffect_OverloadChain Effect;
    
    if (oManager != None)
    {
        Effect = SFXGameEffect_OverloadChain(oManager.CreateEffect(Class'SFXGameEffect_OverloadChain', Name, JumpDelay + 1.0, 1, 0.0, m_oPawn.Controller));
        if (Effect != None)
        {
            Effect.NumChargesLeft = int(NumCharges.CurrentValue);
            Effect.MaxJumpDistance = MaxJumpDistance.CurrentValue;
            Effect.JumpDelay = JumpDelay;
            Effect.Caster = m_oPawn;
            Effect.Power = Self;
            Effect.Damage = Damage.CurrentValue;
            Effect.DamageLossPerHit = DamageLossPerHit;
            Effect.Force = Force.CurrentValue;
            Effect.DamageOrigin = m_oPawn.location;
            Effect.ElectricComboDuration = EffectDuration.CurrentValue;
            Effect.OrganicDamagePct = OrganicDamageMultiplier;
            Effect.ShieldRegenPenalty = ShieldRegenPenalty;
            Effect.ShieldRegenPenaltyDuration = ShieldRegenPenaltyDuration;
            if (IsEvolvedWithChoice(5))
            {
                Effect.NormalDamageType = Class'SFXDamageType_ImprovedOverload';
                Effect.RobotDamageType = Class'SFXDamageType_ImprovedOverloadRobot';
            }
            else
            {
                Effect.NormalDamageType = Class'SFXDamageType_Overload';
                Effect.RobotDamageType = Class'SFXDamageType_OverloadRobot';
            }
            if (IsEvolvedWithChoice(2))
            {
                Effect.RagdollOrganics = int(MaximumRagdollTargets.CurrentValue);
            }
        }
    }
    return Effect;
}
public function TestAchievement(Actor oTarget)
{
    local SFXShield_Base Shield;
    local SFXModule_Damage DamageMod;
    local BioPlayerController PC;
    local SFXInventoryManager InvManager;
    local BioPawn TargetBP;
    
    PC = BioPlayerController(m_oPawn.Instigator.Controller);
    TargetBP = BioPawn(oTarget);
    if (TargetBP != None && PC != None)
    {
        InvManager = SFXInventoryManager(TargetBP.InvManager);
        if (InvManager != None)
        {
            Shield = SFXShield_Base(InvManager.FindInventoryType(Class'SFXShield_Base', TRUE));
            if (SFXShield_Energy(Shield) != None && Shield.GetCurrentShields() > float(0) && TargetBP.bAchievementDisruptedGranted == FALSE)
            {
                PC.UpdateAccomplishmentProgression('OVERLOADCOUNT');
                TargetBP.bAchievementDisruptedGranted = TRUE;
            }
            else
            {
                DamageMod = TargetBP.GetModule(Class'SFXModule_Damage');
                if (DamageMod != None && DamageMod.HealthType == EHealthType.HealthType_Shields && TargetBP.bAchievementDisruptedGranted == FALSE)
                {
                    PC.UpdateAccomplishmentProgression('OVERLOADCOUNT');
                    TargetBP.bAchievementDisruptedGranted = TRUE;
                }
            }
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
    NumCharges = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.0, 
                  RankBonuses[2] = 0.0, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 1.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.BonusIsHardValue
                 }
    MaxJumpDistance = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 800.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.Normal
                      }
    Evolve_DamageBonus1 = 0.300000012
    Evolve_DamageBonus2 = 0.150000006
    Evolve_NumChargeBonus1 = 1
    Evolve_NumChargeBonus2 = 1
    Evolve_CooldownBonus = 0.25
    Evolve_ShieldDamageBonus = 1.0
    ShieldRegenPenalty = 1.0
    ShieldRegenPenaltyDuration = 8.0
    OrganicDamageMultiplier = 0.5
    JumpDelay = 0.5
    DamageLossPerHit = 0.600000024
    CE_HitWallTemplate = RvrClientEffect'BioVFX_T_TechPowers.05_Overload.VCFX.Overload_Imp_VCFX'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Cryo', Class'SFXGameEffect_PowerCombo_Fire')
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_P_overload_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ReleaseEffectBoneName = 'LeftWrist'
    ReleaseTime = 0.100000001
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.Tech_Attack_Muzzle_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_P_overload_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_P_overload_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_NP_overload_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_Overload.Play_power_tech_NP_overload_cast'
    bCustomCasterCrustParameters = TRUE
    bCustomImpactSound = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 16.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    MaximumRagdollTargets = {BaseValue = 2.0}
    EffectDuration = {BaseValue = 5.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 220.0}
    Force = {BaseValue = 200.0}
    Ranks = ({
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $250696, 
              Evolved1Description = $250701, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $250698, 
              Evolved1Description = $250703, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $250699, 
              Evolved1Description = $560405, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558181, 
              Evolved1Description = $558185, 
              Evolved2Name = $250709, 
              Evolved2Description = $250705
             }, 
             {
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $559725, 
              Evolved1Description = $558186, 
              Evolved2Name = $558183, 
              Evolved2Description = $558187
             }, 
             {
              Icon = 52, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $559726, 
              Evolved1Description = $558188, 
              Evolved2Name = $558184, 
              Evolved2Description = $558189
             }
            )
    PowerName = 'Overload'
    PowerCustomActionID = 28
    DisplayName = $250696
    Description = $682935
    Icon = 52
    TalentDescription = $682935
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Overload
}