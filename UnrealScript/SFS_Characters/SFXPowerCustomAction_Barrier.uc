Class SFXPowerCustomAction_Barrier extends SFXPowerCustomAction_DefensiveShield
    config(Game);

var config PowerData BlastRadius;
var config PowerData BlastDamage;
var config PowerData BlastForce;
var config PowerData BlastLiftDuration;
var Class<SFXDamageType> BlastDamageType;
var Class<SFXRumble_Power> RumbleClass;
var Class<SFXShake_Power> ScreenShakeClass;
var config AreaEffectParameters BlastParameters;
var config float Evolve_DamageReductionBonus1;
var config float Evolve_DamageReductionBonus2;
var config float Evolve_BlastDamageBonus;
var config float Evolve_ShieldRegenBonus;
var config float Evolve_PowerDamageBonus;
var config float Evolve_EncumbranceBonus;
var RvrClientEffectInterface CE_BlastEffect;
var config int BlastMaxTargets;
var WwiseEvent BlastSound;
var float BlastDelay;
var float PostBlastEndAnimDelay;

public function StartCustomAction()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_DefensiveArmor', Name))
    {
        CastAnimSet = default.CastAnimSet;
    }
    else
    {
        CastAnimSet = None;
    }
    Super(SFXPowerCustomAction).StartCustomAction();
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Damage':
            ApplyBonusToParameter(BlastDamage, Bonus, bRemove);
            break;
        case 'Force':
            ApplyBonusToParameter(BlastForce, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(BlastRadius, Bonus, bRemove);
            break;
        case 'EffectDuration':
            ApplyBonusToParameter(BlastLiftDuration, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (ImpactCount < 0)
    {
        Super.ClientDoPowerSubsequentImpact(oActor, CustomActionReactionType, Duration, ImpactCount, Delay, DoCallback);
    }
    else if (oActor != None)
    {
        DoAreaExplosionForActor(oActor, m_oPawn.location, ImpactCount, BlastDamage.CurrentValue, BlastDamageType, BlastForce.CurrentValue, BlastParameters, 0, OnBlastImpact);
        if (BioPawn(oActor) != None)
        {
            BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(BlastDamage, Evolve_BlastDamageBonus);
            AddEvolvedRankBonus(BlastForce, Evolve_BlastDamageBonus);
            AddEvolvedRankBonus(BlastRadius, Evolve_BlastDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(DamageReduction, Evolve_DamageReductionBonus1);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(EncumbrancePenalty, -Evolve_EncumbranceBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(DamageReduction, Evolve_DamageReductionBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 4;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[1].Data = DamageReduction;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_DamageReduction;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_DamageReductionBonus1;
    PowerStatBars[1].EvolvedBonuses[5] = Evolve_DamageReductionBonus2;
    PowerStatBars[2].Data = BlastDamage;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[2].srStatBarDisplayTitle = $694308;
    PowerStatBars[2].EvolvedBonuses[0] = Evolve_BlastDamageBonus;
    PowerStatBars[3].Data = BlastRadius;
    PowerStatBars[3].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[3].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[3].srStatBarDisplayTitle = $694309;
    PowerStatBars[3].EvolvedBonuses[0] = Evolve_BlastDamageBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super.RecalculateAllPowerData(bReset);
    RecalculatePowerData(BlastRadius, bReset);
    RecalculatePowerData(BlastDamage, bReset);
    RecalculatePowerData(BlastForce, bReset);
    RecalculatePowerData(BlastLiftDuration, bReset);
}
public function StartPowerCooldown();

public function ApplyArmor()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.ApplyArmor();
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (IsEvolvedWithChoice(2))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_ShieldRegenBonus', -Evolve_ShieldRegenBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(3))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus, 0.0, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Force', Evolve_PowerDamageBonus, 0.0, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
    }
}
public function DoBlast()
{
    local BioCheatManager CheatManager;
    
    AreaExplosion(m_oPawn.location, BlastRadius.CurrentValue, BlastDamage.CurrentValue, BlastDamageType, BlastForce.CurrentValue, BlastParameters, BlastMaxTargets, OnBlastImpact);
    PlayPowerControllerRumble(RumbleClass, m_oPawn.location);
    PlayPowerScreenShake(ScreenShakeClass, m_oPawn.location);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_BlastEffect, m_oPawn);
    m_oPawn.PlaySound(BlastSound, TRUE);
    m_oPawn.SetTimer(PostBlastEndAnimDelay, FALSE, 'EndThisCustomAction', Self);
    CheatManager = m_oPawn.PowerManager.GetCheatManager();
    if (CheatManager != None && CheatManager.m_bEnablePowerCooldown == FALSE)
    {
        return;
    }
    m_oPawn.PowerManager.SetSharedCooldown(GetPowerCooldown());
}
public function bool OnBlastImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    local bool bRagdolled;
    
    bRagdolled = Resistance == EPowerResistance.Resistance_None && (MaximumRagdollTargets.CurrentValue == float(0) || float(nPreviouslyImpacted) < MaximumRagdollTargets.CurrentValue);
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance != EPowerResistance.Resistance_Full)
    {
        oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, bRagdolled ? PowerAssistFullControlValue : PowerAssistPartialControlValue);
    }
    if (oPawn != None && bRagdolled)
    {
        ApplyTemporaryGameEffect(oPawn, Class'SFXGameEffect_AntiGravity', BlastLiftDuration.CurrentValue, 0.0, Name, m_oPawn.Controller);
        ApplyTemporaryGameEffect(oPawn, Class'SFXGameEffect_BarrierLift', BlastLiftDuration.CurrentValue, 0.0, Name, m_oPawn.Controller);
        AddComboEffect(oPawn, Class'SFXGameEffect_PowerCombo_Biotic', BlastLiftDuration.CurrentValue);
    }
    return TRUE;
}
public function RemoveArmor()
{
    Super.RemoveArmor();
    m_oPawn.SetTimer(BlastDelay, FALSE, 'DoBlast', Self);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_DG_Deaths
        m_nmOrigSetName = 'HMM_DG_Deaths'
        Sequences = (AnimSequence'BIOG_HMM_DG_A.HMM_DG_Deaths_DG_FireInTheSky')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_DG_A.HMM_DG_Deaths_BioAnimSetData'
    End Object
    BlastRadius = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.300000012, 
                   RankBonuses[2] = 0.200000003, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 300.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    BlastDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.300000012, 
                   RankBonuses[2] = 0.200000003, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 90.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    BlastForce = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.300000012, 
                  RankBonuses[2] = 0.200000003, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 500.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.Normal
                 }
    BlastLiftDuration = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.0, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 3.0, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.Normal
                        }
    BlastDamageType = Class'SFXDamageType_BarrierBlast'
    RumbleClass = Class'SFXRumble_Power_HeavyImpact'
    ScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    BlastParameters = {
                       ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                       HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                       ConeAngle = 0.0, 
                       ImpactFriends = FALSE, 
                       ImpactDeadPawns = FALSE, 
                       ImpactPlaceables = TRUE, 
                       BlockedByObjects = TRUE, 
                       DistancedSorted = TRUE
                      }
    Evolve_DamageReductionBonus1 = 0.0500000007
    Evolve_DamageReductionBonus2 = 0.100000001
    Evolve_BlastDamageBonus = 0.300000012
    Evolve_ShieldRegenBonus = 0.150000006
    Evolve_PowerDamageBonus = 0.25
    Evolve_EncumbranceBonus = 0.300000012
    CE_BlastEffect = RvrClientEffect'BioVFX_B_Vanguard.VCFX.Van_Discharge_VCFX'
    BlastMaxTargets = 4
    BlastDelay = 0.300000012
    PostBlastEndAnimDelay = 0.75
    DamageReduction = {BaseValue = 0.150000006, Formula = EPowerDataFormula.BonusIsHardValue}
    EncumbrancePenalty = {BaseValue = 0.600000024, Formula = EPowerDataFormula.BonusIsHardValue}
    CE_ArmorCrustTemplate = RvrClientEffect'BioVFX_B_Pull.VCFX.Pull_Lift_Crust_VCFX'
    BS_StartCastAnimation = {
                             AnimName = ('None', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'DG_FireInTheSky', 
                                         'None', 
                                         'None', 
                                         'None', 
                                         'DG_FireInTheSky'
                                        )
                            }
    NonRagdollDamageType = Class'SFXDamageType_BarrierBlast_NoRagdoll'
    CastAnimSet = MY_DYN_HMM_DG_Deaths
    fStartAnimBlendInTime = 0.25
    fEndAnimBlendInTime = 0.5
    fEndAnimBlendOutTime = 0.400000006
    fAnimStartTime = 0.800000012
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_B_Biotics_Charge.VCFX.BioticMode_FrameBuffer_VCFX'
    bPlayEndCastAnim = FALSE
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 20.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRagdollTargets = {BaseValue = 2.0}
    Ranks = ({
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $158537, 
              Evolved1Description = $155446, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $170532, 
              Evolved1Description = $676400, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $155449, 
              Evolved1Description = $676401, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $155451, 
              Evolved1Description = $338772, 
              Evolved2Name = $195903, 
              Evolved2Description = $195904
             }, 
             {
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676406, 
              Evolved1Description = $676407, 
              Evolved2Name = $676408, 
              Evolved2Description = $676409
             }, 
             {
              Icon = 22, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676410, 
              Evolved1Description = $676411, 
              Evolved2Name = $676412, 
              Evolved2Description = $676413
             }
            )
    PowerName = 'Barrier'
    PowerCustomActionID = 10
    DisplayName = $93973
    Description = $155065
    Icon = 22
    TalentDescription = $155065
    IsBonusPower = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Buff
}