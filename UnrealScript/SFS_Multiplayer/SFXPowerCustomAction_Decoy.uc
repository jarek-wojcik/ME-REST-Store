Class SFXPowerCustomAction_Decoy extends SFXPowerCustomAction
    config(Game);

var config PowerData DecoyShields;
var config PowerData ExplosionDamage;
var config PowerData ExplosionForce;
var config PowerData ExplosionRadius;
var config PowerData ShockDamage;
var config PowerData ShockForce;
var config PowerData ShockRadius;
var config PowerData DecoyDamageProtection;
var Class<SFXPawn_Decoy> DecoyClass;
var Class<SFXAI_Core> DecoyAIClass;
var config AreaEffectParameters ExplosionParameters;
var config AreaEffectParameters ShockParameters;
var RvrClientEffectInterface CE_DecoyExplosionTemplate;
var RvrClientEffectInterface CE_ShockExplosionImpact;
var SFXPawn_Decoy DecoyPawn;
var config float DecoySpawnOffset;
var config float Evolve_DurationBonus;
var config float Evolve_ShieldBonus;
var config float Evolve_ExplosionRadius;
var config float Evolve_RechargeSpeedBonus;
var config float Evolve_DurationBonus2;
var config float Evolve_ShieldBonus2;
var config float Evolve_ShockRadius;
var WwiseEvent ExplosionSound;
var config float ShockCooldown;
var RvrClientEffectInterface CE_ShockTemplate;
var float DistAboveFloor;
var bool UserDespawn;

public function bool CanImpactActor(Actor oActor)
{
    if (oActor == DecoyPawn)
    {
        return FALSE;
    }
    return Super.CanImpactActor(oActor);
}
public function StartCustomAction()
{
    UserDespawn = TRUE;
    DespawnDecoy(DecoyPawn);
    UserDespawn = FALSE;
    Super.StartCustomAction();
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Damage':
            ApplyBonusToParameter(ExplosionDamage, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            break;
        case 'Force':
            ApplyBonusToParameter(ExplosionForce, Bonus, bRemove);
            ApplyBonusToParameter(ShockForce, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(ExplosionRadius, Bonus, bRemove);
            ApplyBonusToParameter(ShockRadius, Bonus, bRemove);
            break;
        case 'DroneShields':
            ApplyBonusToParameter(DecoyShields, Bonus, bRemove);
            break;
        case 'DroneDamage':
            ApplyBonusToParameter(ExplosionDamage, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            break;
        case 'DroneCooldown':
            ApplyBonusToParameter(CooldownTime, Bonus, bRemove);
            ApplyBonusToParameter(HenchmanCooldownTime, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType);

public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (BioPawn(oActor) == None)
    {
        return;
    }
    switch (ImpactCount)
    {
        case -1:
            DecoyKilledExplosion(SFXPawn_Decoy(oActor));
            break;
        case -2:
            CastShock();
            break;
        case -3:
            DoAreaExplosionForActor(oActor, DecoyPawn.location, ImpactCount, ExplosionDamage.CurrentValue, Class'SFXDamageType_Decoy', ExplosionForce.CurrentValue, ExplosionParameters, 0, OnDeathExplosionImpact);
            BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
            break;
        case -4:
            DoAreaExplosionForActor(oActor, DecoyPawn.location, ImpactCount, ShockDamage.CurrentValue, Class'SFXDamageType_Decoy', ShockForce.CurrentValue, ShockParameters, 0, OnShockImpact);
            BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
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
            AddEvolvedRankBonus(DecoyShields, Evolve_ShieldBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(CooldownTime, Evolve_RechargeSpeedBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_RechargeSpeedBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(EffectDuration, Evolve_DurationBonus2);
            AddEvolvedRankBonus(DecoyShields, Evolve_ShieldBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    local Vector SpawnLocation;
    local Vector X;
    local Vector Y;
    local Vector Z;
    local BioPlayerController PC;
    local Vector CasterRotation;
    local float fOffset;
    
    Super.OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (m_oPawn == None || m_oPawn.Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    PC = BioPlayerController(m_oPawn.Controller);
    if (PC != None)
    {
        fOffset = 75.0;
    }
    else if (SFXPawn_Henchman(m_oPawn) != None)
    {
        PC = BioPlayerController(m_oPawn.WorldInfo.GetALocalPlayerController());
        fOffset = -75.0;
    }
    if (PC == None || PC.Pawn == None)
    {
        return;
    }
    CasterRotation = Vector(PC.Rotation);
    CasterRotation.Z = 0.0;
    CasterRotation = Normal(CasterRotation);
    GetAxes(PC.Rotation, X, Y, Z);
    SpawnLocation = PC.Pawn.location + CasterRotation * 400.0 + X * fOffset;
    if (!IsSafeSpawnLocation(SpawnLocation))
    {
        SpawnLocation = PC.Pawn.location + CasterRotation * 200.0 + X * fOffset;
        if (!IsSafeSpawnLocation(SpawnLocation))
        {
            SpawnLocation = PC.Pawn.location;
        }
    }
    DecoyPawn = SpawnDecoy(SpawnLocation, Rotator(CasterRotation));
}
public function OnPowerRankIncreased()
{
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    DespawnDecoy(DecoyPawn);
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[3] = Evolve_RechargeSpeedBonus;
    PowerStatBars[1].Data = EffectDuration;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Duration;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DurationBonus;
    PowerStatBars[1].EvolvedBonuses[5] = Evolve_DurationBonus2;
    PowerStatBars[2].Data = DecoyShields;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[2].srStatBarDisplayTitle = $702988;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_ShieldBonus;
    PowerStatBars[2].EvolvedBonuses[5] = Evolve_ShieldBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(DecoyShields, bReset);
    RecalculatePowerData(ExplosionDamage, bReset);
    RecalculatePowerData(ExplosionForce, bReset);
    RecalculatePowerData(ExplosionRadius, bReset);
    RecalculatePowerData(ShockDamage, bReset);
    RecalculatePowerData(ShockForce, bReset);
    RecalculatePowerData(ShockRadius, bReset);
    RecalculatePowerData(DecoyDamageProtection, bReset);
}
public function ReplicatePowerSubsequentImpact(BioPawn Target, optional int CustomActionReactionType = 0, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (ImpactCount < 0)
    {
        Super.ReplicatePowerSubsequentImpact(Target, CustomActionReactionType, Duration, ImpactCount, Delay, DoCallback);
    }
}
public function CastShock()
{
    local Vector Param;
    
    Param.Y = ShockRadius.CurrentValue / 100.0;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ShockTemplate, DecoyPawn.location, vect(0.0, 0.0, 1.0), Param);
    AreaExplosion(DecoyPawn.location, ShockRadius.CurrentValue, ShockDamage.CurrentValue, Class'SFXDamageType_Decoy', ShockForce.CurrentValue, ShockParameters, 0, OnShockImpact);
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(m_oPawn, , , -2);
    }
}
public function DecoyKilledExplosion(SFXPawn_Decoy oDecoy)
{
    if (oDecoy != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_DecoyExplosionTemplate, oDecoy);
        oDecoy.PlaySound(ExplosionSound);
    }
}
public function DespawnDecoy(SFXPawn_Decoy oDecoy)
{
    if (oDecoy != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (m_oPawn.Controller != None)
        {
            oDecoy.KilledBy = m_oPawn.Controller;
        }
        oDecoy.Died(m_oPawn.Controller, Class'SFXDamageType_Default', oDecoy.location);
    }
}
public function bool IsDecoyAlive()
{
    if (DecoyPawn != None && DecoyPawn.LifeSpan > float(0) && !DecoyPawn.IsDead())
    {
        return TRUE;
    }
    return FALSE;
}
public function bool IsSafeSpawnLocation(out Vector SpawnLocation)
{
    local Vector FloorLocation;
    
    SpawnLocation.Z += 100.0;
    if (!GetFloorLocation(SpawnLocation, FloorLocation))
    {
        return FALSE;
    }
    if (VSize(SpawnLocation - FloorLocation) < 500.0)
    {
        SpawnLocation = FloorLocation;
        SpawnLocation.Z += DistAboveFloor;
        return TRUE;
    }
    return FALSE;
}
public function bool OnDeathExplosionImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn oPawn;
    
    CheckForPowerCombo(oImpacted, Resistance, HitLocation, HitNormal);
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && Resistance == EPowerResistance.Resistance_None)
    {
        oPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistFullControlValue);
    }
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(oPawn, , , -3);
    }
    return TRUE;
}
public function OnDecoyKilled(SFXPawn_Decoy oDecoy)
{
    if (!UserDespawn && IsEvolvedWithChoice(4) && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        DecoyKilledExplosion(oDecoy);
        AreaExplosion(oDecoy.location, ExplosionRadius.CurrentValue, ExplosionDamage.CurrentValue, Class'SFXDamageType_Decoy', ExplosionForce.CurrentValue, ExplosionParameters, 0, OnDeathExplosionImpact);
        if (ShouldReplicate())
        {
            ReplicatePowerSubsequentImpact(oDecoy, , , -1);
        }
    }
}
public function bool OnShockImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_ShockExplosionImpact, oImpacted);
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(BioPawn(oImpacted), , , -4);
    }
    return TRUE;
}
public function SetupSpawnedDecoy(SFXPawn_Decoy SpawnedDecoy)
{
    local SFXPowerCustomActionBase oPower;
    local ScaledFloat MaxShields;
    local SFXModule_Damage DmgModule;
    local SFXModule_GameEffectManager Manager;
    
    if (SpawnedDecoy == None)
    {
        return;
    }
    SpawnedDecoy.__OnDecoyKilled__Delegate = OnDecoyKilled;
    if (SpawnedDecoy.PowerManager != None)
    {
        foreach SpawnedDecoy.PowerManager.Powers(oPower, )
        {
            oPower.Rank = Rank;
        }
    }
    DecoyPawn = SpawnedDecoy;
    DecoyPawn.ShockCooldown = ShockCooldown;
    DmgModule = DecoyPawn.GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        MaxShields.X = DecoyShields.CurrentValue;
        MaxShields.Y = DecoyShields.CurrentValue;
        Class'SFXGame'.static.ReCalculate(MaxShields);
        DmgModule.SetMaxHealth(MaxShields);
        DmgModule.SetCurrentHealth(MaxShields.Value);
    }
    Manager = DecoyPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', Name, 0.0, 2, -DecoyDamageProtection.CurrentValue, m_oPawn.Controller, m_oPawn);
    }
    DecoyPawn.bExplosiveCooldown = IsEvolvedWithChoice(4);
    DecoyPawn.StartDecoyVFX();
}
public function SFXPawn_Decoy SpawnDecoy(Vector location, Rotator Rotation)
{
    local SFXPawn_Decoy Decoy;
    local SFXAI_Core DecoyAI;
    
    Decoy = m_oPawn.Spawn(DecoyClass, , 'Decoy', location, Rotation, , , TRUE);
    if (Decoy == None)
    {
        return None;
    }
    Decoy.SetupCasterAndReplication(m_oPawn);
    Decoy.Duration = EffectDuration.CurrentValue;
    Decoy.SetDeathTimer();
    DecoyAI = m_oPawn.Spawn(DecoyAIClass, , , location, Rotation, None, TRUE);
    if (DecoyAI == None)
    {
        return None;
    }
    DecoyAI.Instigator = m_oPawn;
    Decoy.Instigator = m_oPawn;
    DecoyAI.Possess(Decoy, FALSE);
    DecoyAI = SFXAI_Core(Decoy.Controller);
    if (DecoyAI != None)
    {
        DecoyAI.SetTeam(0);
    }
    if (IsEvolvedWithChoice(2))
    {
        Decoy.ShockRadius = ShockRadius.CurrentValue;
        Decoy.DecoyPower = Self;
    }
    SetupSpawnedDecoy(Decoy);
    return Decoy;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTechTool
        m_nmOrigSetName = 'HMM_BC_RifleTechTool'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BioAnimSetData'
    End Object
    DecoyShields = {
                    DynamicBonuses = (), 
                    RankBonuses[0] = 0.0, 
                    RankBonuses[1] = 0.0, 
                    RankBonuses[2] = 0.0, 
                    RankBonuses[3] = 0.0, 
                    RankBonuses[4] = 0.0, 
                    RankBonuses[5] = 0.0, 
                    BaseValue = 1000.0, 
                    CurrentValue = 0.0, 
                    Formula = EPowerDataFormula.Normal
                   }
    ExplosionDamage = {
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
    ExplosionForce = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 500.0, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.Normal
                     }
    ExplosionRadius = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 400.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.Normal
                      }
    ShockDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.0, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 100.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    ShockForce = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.0, 
                  RankBonuses[2] = 0.0, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 450.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.Normal
                 }
    ShockRadius = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.0, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 250.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    DecoyDamageProtection = {
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
    DecoyClass = Class'SFXPawn_Decoy'
    DecoyAIClass = Class'SFXAI_None'
    ExplosionParameters = {
                           ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                           HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                           ConeAngle = 0.0, 
                           ImpactFriends = FALSE, 
                           ImpactDeadPawns = FALSE, 
                           ImpactPlaceables = TRUE, 
                           BlockedByObjects = TRUE, 
                           DistancedSorted = FALSE
                          }
    ShockParameters = {
                       ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                       HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                       ConeAngle = 0.0, 
                       ImpactFriends = FALSE, 
                       ImpactDeadPawns = FALSE, 
                       ImpactPlaceables = TRUE, 
                       BlockedByObjects = TRUE, 
                       DistancedSorted = FALSE
                      }
    CE_DecoyExplosionTemplate = RvrClientEffect'BioVFX_Hch_Edi.VCFX.Decoy_Explosive_VCFX'
    CE_ShockExplosionImpact = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_VCFX'
    DecoySpawnOffset = 500.0
    Evolve_DurationBonus = 0.400000006
    Evolve_ShieldBonus = 0.400000006
    Evolve_ExplosionRadius = 300.0
    Evolve_RechargeSpeedBonus = 0.349999994
    Evolve_DurationBonus2 = 0.5
    Evolve_ShieldBonus2 = 0.5
    Evolve_ShockRadius = 250.0
    ExplosionSound = WwiseEvent'Wwise_Power_Tech_Decoy.Play_power_tech_S_decoy_explode'
    ShockCooldown = 5.0
    CE_ShockTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Shock_AOE_VCFX'
    DistAboveFloor = 50.0
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Fire', Class'SFXGameEffect_PowerCombo_Cryo')
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ReleaseTime = 0.300000012
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CastSound = WwiseEvent'Wwise_Power_Tech_Decoy.Play_power_tech_P_decoy_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_Decoy.Play_power_tech_NP_decoy_cast'
    bCustomCasterCrustParameters = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 16.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    EffectDuration = {RankBonuses[2] = 0.300000012, BaseValue = 15.0}
    Ranks = ({
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $674631, 
              Evolved1Description = $690837, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690838, 
              Evolved1Description = $690839, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690840, 
              Evolved1Description = $690841, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690842, 
              Evolved1Description = $690843, 
              Evolved2Name = $690844, 
              Evolved2Description = $690845
             }, 
             {
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690846, 
              Evolved1Description = $690847, 
              Evolved2Name = $690848, 
              Evolved2Description = $690849
             }, 
             {
              Icon = 89, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690850, 
              Evolved1Description = $690851, 
              Evolved2Name = $690852, 
              Evolved2Description = $690853
             }
            )
    PowerName = 'Decoy'
    PowerCustomActionID = 52
    DisplayName = $674631
    Description = $690836
    Icon = 89
    TalentDescription = $690836
    IsBonusPower = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_CombatDrone
}