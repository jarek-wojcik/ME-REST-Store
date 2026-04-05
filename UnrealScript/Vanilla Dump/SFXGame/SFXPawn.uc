Class SFXPawn extends BioPawn
    placeable
    abstract
    config(Game);

struct ReplicatedGib 
{
    var Class<SFXDamageType> DamageType;
    var Vector HitLocation;
    var Vector HitNormal;
    var int BoneIndex;
};
struct ScoreRecord 
{
    var SFXPawn_Player Player;
    var float TotalDamage;
    var float TotalPowerAssistValue;
    var float LastScoreTime;
    var stringref LastScoreSourceName;
};
enum EStyleEventMultiplier
{
    STYLE_EVENT_NORMAL,
    STYLE_EVENT_NONE,
    STYLE_EVENT_VERYWEAK,
    STYLE_EVENT_WEAK,
    STYLE_EVENT_GOOD,
    STYLE_EVENT_VERYGOOD,
};
struct PowerImpactNotification 
{
    var Name Label;
    var float TimeBeforeImpact;
};
struct DeathInfo 
{
    var Class<DamageType> DamageType;
    var Pawn KillerPawn;
    var stringref LastDamageSource;
};

var repnotify ReplicatedGib ReplicatedGibInfo;
var transient repnotify DeathInfo ReplicatedDeathInfo;
var array<PowerImpactNotification> PowerImpactNotifications;
var transient array<ScoreRecord> ScoreRecords;
var(SFXPawn) ScreenShakeStruct FootstepShake;
var Guid HeadCapGuid;
var Name MuzzleSocketName;
var Name ShellCasingSocketName;
var transient Name ScoreSourceOverrideSetter;
var(SFXPawn) ParticleSystem PS_HeadGib;
var(SFXPawn) ParticleSystem PS_LimbGib;
var RvrClientEffectInterface CE_HeadGibCap;
var(SFXPawn) WwiseEvent PlayerHeadShot;
var(SFXPawn) WwiseEvent NonPlayerHeadShot;
var WwiseEvent AmbientVoc;
var WwiseEvent PainVoc;
var WwiseEvent ShieldsDownVoc;
var WwiseEvent MoveToCoverVoc;
var WwiseEvent MeleedVoc;
var stringref PrettyName;
var transient SFXPawn DrivenAtlas;
var transient SFXPawn ThreateningPawn;
var config float fThreatDuration;
var config float fAssistVocDelay;
var transient float LastTimeEaten;
var transient int NumConsumeTickets;
var transient int NumReleasedConsumeTickets;
var float AmmoDropPct;
var const int MaxConsumeTickets;
var float PowerControlResistance;
var int CodexPlotState;
var config float DamageScoreBudget;
var config float KillBonusScore;
var config float PowerControlAssistBudget;
var config stringref srScoreTickerEntry;
var config stringref srScoreTickerValueToken;
var transient SFXPawn_Player ScoreSourceOverride;
var(SFXPawn) export ForceFeedbackWaveform FootstepForceFeedback;
var bool bAllowHeadGib;
var(SFXPawn) bool bPlayFootstepScreenShake;
var(SFXPawn) bool bPlayFootstepRumble;
var(Optimization) bool bLimitConsoleLOD;
var(SFXPawn) bool bCanPartialLean;
var bool bSupportsVisibleWeapons;
var transient bool bIsMeleeThreat;
var bool bCanBeEaten;
var bool bCorpseDestroyed;
var bool bRecentlyDeceased;
var const bool bCanUseTurrets;
var const bool bCanDriveAtlas;
var const bool bCanBeRepaired;
var const bool bCanBeMarauderBuffed;
var const bool bCanBeMeleed;
var bool bIgnoreTarget;
var bool bIgnoresPets;
var bool bScoreDistributed;
var bool bIsPet;
var bool bCanDropAmmo;

public simulated function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, Pawn DamageCauser)
{
    Super.PlayHit(Damage, instigatedBy, HitLocation, DamageType, Momentum, HitInfo, DamageCauser);
    if (PainVoc != None && Damage > 0.0 && IsDead() == FALSE && HasAnyShieldResistance() == FALSE)
    {
        PlaySound(PainVoc, TRUE);
    }
}
public simulated function PostBeginPlay()
{
    local SFXGRI GRI;
    
    Super.PostBeginPlay();
    if (AmbientVoc != None)
    {
        SetTimer(2.0 + FRand(), FALSE, 'PlayAmbientSound', );
    }
    if (bLimitConsoleLOD)
    {
        GRI = SFXGRI(WorldInfo.GRI);
        if (GRI != None && Class'WorldInfo'.static.IsConsoleBuild())
        {
            Mesh.MinAutoLODLevel = 1;
        }
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedDeathInfo')
    {
        if (ReplicatedDeathInfo.DamageType != None)
        {
            KilledByDamageType = ReplicatedDeathInfo.DamageType;
        }
        DistributeScore();
    }
    else if (VarName == 'ReplicatedGibInfo')
    {
        ReplicatedGibUpdated();
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    if (DrivenAtlas == None)
    {
        Super(Actor).TakeRadiusDamage(instigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent, HitInfo);
    }
}
public simulated function EPowerResistance GetPowerResistance(Pawn Caster, Vector HitLocation, Vector HitNormal, out float Damage, out Vector Force, Class<DamageType> DamageType, out Actor TargetOverride)
{
    if (DrivenAtlas != None)
    {
        return 0;
    }
    return Super.GetPowerResistance(Caster, HitLocation, HitNormal, Damage, Force, DamageType, TargetOverride);
}
public simulated function stringref GetPrettyName()
{
    return PrettyName;
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    local int idx;
    local SFXGameEffect Effect;
    local SFXModule_GameEffectManager Manager;
    local Class<SFXDamageType> damageClass;
    
    damageClass = Class<SFXDamageType>(DamageType);
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && SFXGRI(WorldInfo.GRI).bMultiplayer)
    {
        for (idx = 0; idx < Manager.GameEffects.Length; idx++)
        {
            Effect = Manager.GameEffects[idx];
            if (Effect.Instigator != None && Effect.Instigator.Pawn != None && Effect.Instigator.Pawn != Caster && (ClassIsChildOf(Effect.Class, Class'SFXGameEffect_WeldPhysics') || ClassIsChildOf(Effect.Class, Class'SFXGameEffect_PhysicsPower')))
            {
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(125, BioPawn(Caster), BioPawn(Effect.Owner));
                break;
            }
        }
    }
    if (Resistance != EPowerResistance.Resistance_Full && ThreateningPawn != None && Caster != ThreateningPawn && SFXGRI(WorldInfo.GRI).bMultiplayer && (damageClass != None && damageClass.default.bCausesRagdoll || ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Freeze') || ClassIsChildOf(DamageType, Class'SFXDamageType_Stasis')))
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(124, BioPawn(Caster), ThreateningPawn);
    }
    return Super.ImpactWithPower(Resistance, Caster, HitLocation, HitNormal, Damage, Force, DamageType);
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    local BioRemoteLogger Logger;
    local float fLastScoreTime;
    local int idx;
    local BioGlobalVariableTable VarTable;
    
    if (SFXPlayerController(Killer) != None && SFXPawn_Player(Self) == None && SFXPawn_Henchman(Self) == None)
    {
        Logger = Class'BioRemoteLogger'.static.GetLogger();
        if (Logger != None)
        {
            Logger.SendMapEvent(102, Killer.location, string(Name), "", "", "", 0, 0, 0, 0);
        }
    }
    if (DrivenVehicle != None)
    {
        DrivenVehicle.DriverLeave(TRUE);
    }
    if (DrivenAtlas != None)
    {
        DrivenAtlas.DriverDied();
    }
    ReplicatedDeathInfo.DamageType = DamageType;
    ClearTimer('DeferredResetReplicatedDeathInfoDamageType');
    if (Killer != None)
    {
        if (SFXPawn_Player(Killer.Pawn) == None)
        {
            ReplicatedDeathInfo.KillerPawn = Killer.Instigator;
        }
        else
        {
            ReplicatedDeathInfo.KillerPawn = Killer.Pawn;
        }
    }
    for (idx = 0; idx < ScoreRecords.Length; idx++)
    {
        if (ScoreRecords[idx].LastScoreTime > fLastScoreTime)
        {
            ReplicatedDeathInfo.KillerPawn = ScoreRecords[idx].Player;
            ReplicatedDeathInfo.LastDamageSource = ScoreRecords[idx].LastScoreSourceName;
            fLastScoreTime = ScoreRecords[idx].LastScoreTime;
        }
    }
    DistributeScore();
    if (!IsInState('Downed', ))
    {
        bRecentlyDeceased = TRUE;
    }
    if (SFXGRI(WorldInfo.GRI).WaveCoordinator != None)
    {
        SFXGRI(WorldInfo.GRI).WaveCoordinator.PawnDied(Self, BioPawn(ReplicatedDeathInfo.KillerPawn));
    }
    if (!Super.Died(Killer, DamageType, HitLocation))
    {
        return FALSE;
    }
    if (CodexPlotState != 0 && BioWorldInfo(WorldInfo) != None && SFXGRI(WorldInfo.GRI).bMultiplayer == FALSE)
    {
        VarTable = BioWorldInfo(WorldInfo).GetGlobalVariables();
        if (VarTable != None && VarTable.GetBool(CodexPlotState) == FALSE)
        {
            VarTable.SetBool(CodexPlotState, TRUE);
        }
    }
    bForceNetUpdate = TRUE;
    return TRUE;
}
public function DriverDied();

public function HandleMomentum(Vector Momentum, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo);

public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    local Vector impulse;
    
    Super.PlayDying(DamageType, HitLoc);
    impulse = Vector(Rotation);
    if (VSize(impulse) > float(0))
    {
        impulse = impulse * float(-100) / VSize(impulse);
        Mesh.AddImpulse(impulse, HitLoc, AimNodes[4]);
    }
    if (ThreateningPawn != None && !ThreateningPawn.IsDead() && ThreateningPawn != ReplicatedDeathInfo.KillerPawn && SFXGRI(WorldInfo.GRI).bMultiplayer)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(byte(bIsMeleeThreat ? 122 : 123), ThreateningPawn, BioPawn(ReplicatedDeathInfo.KillerPawn));
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(117, ThreateningPawn, BioPawn(ReplicatedDeathInfo.KillerPawn), fAssistVocDelay);
    }
    if (CE_HeadGibCap != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_HeadGibCap, HeadCapGuid, TRUE);
    }
}
public function bool AcquireConsumeTicket()
{
    if (NumConsumeTickets < MaxConsumeTickets)
    {
        NumConsumeTickets++;
        ClearTimer('AllowDeath');
        return TRUE;
    }
    return FALSE;
}
public simulated function AddDamageEvent(SFXPawn PlayerPawn, Controller instigatedBy, float fAmount, stringref SourceName)
{
    local ScoreRecord Record;
    local bool bPlayerFound;
    local int idx;
    local SFXPawn_Player Player;
    local SFXSelectionModule SelectionMod;
    
    if (PlayerPawn != None && PlayerPawn.ScoreSourceOverride != None)
    {
        Player = PlayerPawn.ScoreSourceOverride;
        SelectionMod = PlayerPawn.GetModule(Class'SFXSelectionModule');
        if (SelectionMod != None)
        {
            SourceName = SelectionMod.m_srGameName;
        }
    }
    if (Player == None)
    {
        if (instigatedBy != None && instigatedBy.Instigator != None)
        {
            Player = SFXPawn_Player(instigatedBy.Instigator);
        }
        else if (PlayerPawn != None && PlayerPawn.bIsPet)
        {
            Player = SFXPawn_Player(PlayerPawn.GetPetOwner());
        }
        else
        {
            Player = SFXPawn_Player(PlayerPawn);
        }
    }
    if (Player == None || fAmount <= 0.0 || SFXGRI(WorldInfo.GRI).gameconfig.ScoreEnabled == FALSE)
    {
        return;
    }
    bPlayerFound = FALSE;
    for (idx = 0; idx < ScoreRecords.Length; ++idx)
    {
        if (Player == ScoreRecords[idx].Player)
        {
            bPlayerFound = TRUE;
            break;
        }
    }
    if (!bPlayerFound)
    {
        Record.Player = Player;
        idx = ScoreRecords.Length;
        ScoreRecords[idx] = Record;
    }
    if (SourceName == 0 || SourceName == 0)
    {
        SourceName = ScoreRecords[idx].LastScoreSourceName;
    }
    ScoreRecords[idx].TotalDamage += fAmount;
    ScoreRecords[idx].LastScoreSourceName = SourceName;
    ScoreRecords[idx].LastScoreTime = WorldInfo.GameTimeSeconds;
}
public final simulated function AddPowerAssistEvent(BioPawn PlayerPawn, stringref SourceName, float fAmount)
{
    local ScoreRecord Record;
    local bool bPlayerFound;
    local int idx;
    local SFXPawn_Player Player;
    
    Player = SFXPawn_Player(PlayerPawn);
    if (Player == None || SFXGRI(WorldInfo.GRI).gameconfig.ScoreEnabled == FALSE)
    {
        return;
    }
    bPlayerFound = FALSE;
    for (idx = 0; idx < ScoreRecords.Length; ++idx)
    {
        if (Player == ScoreRecords[idx].Player)
        {
            bPlayerFound = TRUE;
            break;
        }
    }
    if (!bPlayerFound)
    {
        Record.Player = Player;
        idx = ScoreRecords.Length;
        ScoreRecords[idx] = Record;
    }
    ScoreRecords[idx].TotalPowerAssistValue += fAmount;
    ScoreRecords[idx].LastScoreSourceName = SourceName;
    ScoreRecords[idx].LastScoreTime = WorldInfo.GameTimeSeconds;
}
public function AllowDeath()
{
    bCanBeReaped = TRUE;
    bRecentlyDeceased = FALSE;
}
public simulated function ApplyMarauderArmourBuff();

public function bool CanBeDrivenBy(SFXPawn PossibleDriver);

public function bool CanUseWeapon(Class<SFXWeapon> WeaponClass)
{
    local SFXInventoryManager oInventory;
    local Class<SFXWeapon> LoadoutWeapon;
    local BioGlobalVariableTable VarTable;
    local SFXPlayerSquadLoadoutData SquadLoadout;
    
    oInventory = SFXInventoryManager(InvManager);
    VarTable = BioWorldInfo(WorldInfo).GetGlobalVariables();
    if (oInventory == None || VarTable == None || Loadout == None)
    {
        return FALSE;
    }
    SquadLoadout = SFXPlayerSquadLoadoutData(Loadout);
    if (SquadLoadout != None)
    {
        if (SFXPawn_Player(Self) != None)
        {
            return Class'SFXPlayerSquadLoadoutData'.static.CanPlayerUseWeaponClass(WeaponClass);
        }
        else
        {
            return Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponClass(Tag, WeaponClass);
        }
    }
    foreach Loadout.Weapons(LoadoutWeapon, )
    {
        if (LoadoutWeapon == WeaponClass)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function DeferredResetReplicatedDeathInfoDamageType()
{
    ReplicatedDeathInfo.DamageType = None;
}
public simulated function DistributeScore()
{
    local int idx;
    local SFXScoreManager ScoreManager;
    local SFXMPEventTicker EventTicker;
    local float fDamageScore;
    local float fTotalDamageDone;
    local float fTotalAssistScore;
    local float fEnvironmentDamage;
    local float fTotalDefenses;
    local SFXGRI GRI;
    local string KillSource;
    local SFXSelectionModule SelectionMod;
    local SFXPRI PRI;
    local float fAssistBudget;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI == None || GRI.gameconfig == None || !GRI.gameconfig.ScoreEnabled)
    {
        return;
    }
    if (int(GetTeamNum()) == 0)
    {
        return;
    }
    ScoreManager = GRI.GetScoreManager();
    if (ScoreManager == None)
    {
        return;
    }
    if (bScoreDistributed)
    {
        return;
    }
    bScoreDistributed = TRUE;
    for (idx = 0; idx < ScoreRecords.Length; ++idx)
    {
        if (ScoreRecords[idx].Player != None)
        {
            fTotalAssistScore += ScoreRecords[idx].TotalPowerAssistValue;
            fTotalDamageDone += ScoreRecords[idx].TotalDamage;
        }
    }
    if (fTotalAssistScore < 1.0)
    {
        fAssistBudget = fTotalAssistScore * PowerControlAssistBudget;
    }
    else
    {
        fAssistBudget = PowerControlAssistBudget;
    }
    fTotalDefenses = GetMaxHealth() + GetMaxShields();
    if (fTotalDamageDone < fTotalDefenses)
    {
        fEnvironmentDamage = fTotalDefenses - fTotalDamageDone;
        fTotalDamageDone = fTotalDefenses;
    }
    for (idx = 0; idx < ScoreRecords.Length; ++idx)
    {
        if (ScoreRecords[idx].Player == None)
        {
            continue;
        }
        fDamageScore = 0.0;
        if (ScoreRecords[idx].Player == ReplicatedDeathInfo.KillerPawn)
        {
            fDamageScore += KillBonusScore;
            ScoreRecords[idx].TotalDamage += fEnvironmentDamage;
            fEnvironmentDamage = 0.0;
        }
        fDamageScore += FClamp(ScoreRecords[idx].TotalDamage / fTotalDamageDone, 0.0, 1.0) * DamageScoreBudget;
        if (ScoreRecords[idx].TotalPowerAssistValue > float(0))
        {
            fDamageScore += fAssistBudget * (ScoreRecords[idx].TotalPowerAssistValue / fTotalAssistScore);
        }
        if (fDamageScore > float(0))
        {
            fDamageScore = ScoreManager.AddScore(ScoreRecords[idx].Player, fDamageScore, 0);
        }
        if (fDamageScore > float(0))
        {
            if (ScoreRecords[idx].Player == ReplicatedDeathInfo.KillerPawn)
            {
                ScoreManager.DisplayScoreTag(ScoreRecords[idx].Player, fDamageScore, 0);
                continue;
            }
            ScoreManager.DisplayScoreTag(ScoreRecords[idx].Player, fDamageScore, 1);
            ScoreManager.IncrementMedalStanding(ScoreRecords[idx].Player, 14);
        }
    }
    EventTicker = GRI.GetEventTicker();
    if (EventTicker != None)
    {
        if (ReplicatedDeathInfo.KillerPawn != None && ReplicatedDeathInfo.LastDamageSource != 0)
        {
            PRI = SFXPRI(ReplicatedDeathInfo.KillerPawn.PlayerReplicationInfo);
            if (PRI != None)
            {
                SetCustomToken(0, "");
                KillSource = Class'SFXGame'.static.GetSimpleString(ReplicatedDeathInfo.LastDamageSource, TRUE);
                ClearCustomTokens();
                SetCustomToken(0, PRI.PlayerName);
                SetCustomToken(1, KillSource);
                SelectionMod = GetModule(Class'SFXSelectionModule');
                if (SelectionMod != None)
                {
                    SetCustomToken(2, string(SelectionMod.m_srGameName));
                }
                EventTicker.AddTickerEntry(Class'SFXGame'.static.GetSimpleString(srScoreTickerEntry, TRUE));
                ClearCustomTokens();
            }
        }
    }
}
public simulated function Actor GetPetOwner()
{
    return bIsPet ? Instigator : None;
}
public simulated function string GetShieldTypeAsDisplayString()
{
    local SFXShield_Base Shields;
    
    Shields = GetShields();
    if (Shields != None)
    {
        return string(Shields.ShieldDisplayName);
    }
    return string(Class'SFXShield_Base'.default.ShieldDisplayName);
}
public simulated function GibHead(Vector HitLocation, Vector HitNormal, Name BoneName, Class<SFXDamageType> DamageType)
{
    local SFXObjectPool Pool;
    local ParticleSystemComponent ImpactPSC;
    
    if (Mesh != None && DamageType.default.bCanGibHead && bAllowHeadGib == TRUE)
    {
        Mesh.HideBoneByName('Head', 1);
        Mesh.HideBoneByName('Neck', 1);
        Pool = SFXGRI(WorldInfo.GRI).ObjectPool;
        if (Pool != None)
        {
            ImpactPSC = Pool.GetGenericParticleSystemComponent(PS_HeadGib);
            if (ImpactPSC != None)
            {
                Pool.AttachParticleSystemComponent(ImpactPSC, Self, Mesh, BoneName, HitLocation, HitNormal, TRUE);
                Pool.ApplyBloodColor(ImpactPSC, Self);
                ImpactPSC.SetScale(1.25);
                Pool.ApplyLODLevel(ImpactPSC, HitLocation);
                ImpactPSC.SetActive(TRUE);
            }
        }
        if (Role == ENetRole.ROLE_Authority)
        {
            ReplicateGibHead(HitLocation, HitNormal, BoneName, DamageType);
        }
        if (CE_HeadGibCap != None)
        {
            HeadCapGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(CE_HeadGibCap, Self);
        }
        if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
        {
            PlaySound(PlayerHeadShot, FALSE);
        }
        else
        {
            PlaySound(NonPlayerHeadShot, FALSE);
        }
    }
}
public simulated function NotifyHealed();

public simulated function OnCorpseDestroyed()
{
    Super.OnCorpseDestroyed();
    bCorpseDestroyed = TRUE;
    bCanBeEaten = FALSE;
}
public function OnPowersLoaded()
{
    local BioGlobalVariableTable VarTable;
    local SFXPowerCustomActionBase Power;
    local array<SFXPowerCustomActionBase> UniquePowers;
    local int HighestRank;
    local int GruntLoyalPlotID;
    local Name LoyaltyRequirementPowerName;
    
    if (Tag != 'hench_grunt')
    {
        return;
    }
    GruntLoyalPlotID = 189;
    LoyaltyRequirementPowerName = 'LoyaltyRequirement';
    HighestRank = 0;
    VarTable = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    if (VarTable != None && VarTable.GetBool(GruntLoyalPlotID))
    {
        if (PowerManager != None)
        {
            Power = PowerManager.GetPower(LoyaltyRequirementPowerName);
            if (Power != None)
            {
                if (Power.Rank < 1.0)
                {
                    Power.Rank = 1.0;
                    foreach PowerManager.Powers(Power, )
                    {
                        if (Power.IsHenchmenUnique)
                        {
                            UniquePowers.AddItem(Power);
                            if (Power.Rank > float(HighestRank))
                            {
                                HighestRank = int(Power.Rank);
                            }
                        }
                    }
                    if (float(HighestRank) >= 1.0)
                    {
                        return;
                    }
                    if (UniquePowers.Length == 1)
                    {
                        UniquePowers[0].Rank = 1.0;
                    }
                }
            }
        }
    }
}
public simulated function PlayAmbientSound()
{
    local SFXAI_Core AI;
    
    Super.PlayAmbientSound();
    if (AmbientVoc != None && IsDead() == FALSE)
    {
        AI = SFXAI_Core(Controller);
        if (AI == None || AI.HasAnyEnemies())
        {
            PlaySound(AmbientVoc, TRUE);
        }
        SetTimer(2.0 + FRand(), FALSE, 'PlayAmbientSound', );
    }
}
public simulated function PlayDeathVocalization(BioPawn Killer)
{
    if (!Mesh.IsBoneHidden(Mesh.MatchRefBone('Head')))
    {
        Super.PlayDeathVocalization(Killer);
    }
}
public function PlayMeleedVoc()
{
    if (MeleedVoc != None)
    {
        PlaySound(MeleedVoc, TRUE);
    }
}
public function PlayMoveToCoverSound()
{
    if (MoveToCoverVoc != None)
    {
        PlaySound(MoveToCoverVoc);
    }
}
public simulated function PlayRepairEffects(bool bActivate);

public simulated function PlayStepEffect(int FootDown, TraceHitInfo HitInfo, float Loudness)
{
    local SFXPlayerController PC;
    local SFXModule_Audio AudioModule;
    
    Super.PlayStepEffect(FootDown, HitInfo, Loudness);
    if (bPlayFootstepRumble || bPlayFootstepScreenShake)
    {
        AudioModule = GetModule(Class'SFXModule_Audio');
        foreach LocalPlayerControllers(Class'SFXPlayerController', PC)
        {
            if (PC != None && PC.IsLocalPlayerController() && CheckMaxEffectDistance(PC, location, AudioModule.FootstepCullDistance))
            {
                if (bPlayFootstepScreenShake)
                {
                    PC.PlayDistanceScaledCameraShake(location, FootstepShake);
                }
                if (bPlayFootstepRumble)
                {
                    PC.PlayDistanceScaledForceFeedback(location, FootstepForceFeedback);
                }
            }
        }
    }
}
public function ReleaseConsumeTicket()
{
    NumReleasedConsumeTickets++;
    if (NumReleasedConsumeTickets >= NumConsumeTickets)
    {
        AllowDeath();
    }
}
public final simulated function ReplicatedGibUpdated()
{
    local Name BoneName;
    
    BoneName = Mesh.GetBoneName(ReplicatedGibInfo.BoneIndex);
    if (BoneName != 'None')
    {
        GibHead(ReplicatedGibInfo.HitLocation, ReplicatedGibInfo.HitNormal, BoneName, ReplicatedGibInfo.DamageType);
    }
}
public final function ReplicateGibHead(Vector HitLocation, Vector HitNormal, Name BoneName, Class<SFXDamageType> DamageType)
{
    ReplicatedGibInfo.HitLocation = HitLocation;
    ReplicatedGibInfo.HitNormal = HitNormal;
    ReplicatedGibInfo.BoneIndex = Mesh.MatchRefBone(BoneName);
    ReplicatedGibInfo.DamageType = DamageType;
    bForceNetUpdate = TRUE;
}
public simulated function ResetThreat()
{
    ThreateningPawn = None;
}
public simulated function SetThreat(SFXPawn oPawn, bool bMelee)
{
    ClearTimer('ResetThreat', Self);
    ThreateningPawn = oPawn;
    bIsMeleeThreat = bMelee;
    SetTimer(fThreatDuration, FALSE, 'ResetThreat', );
}
public simulated function ShieldsDown()
{
    Super.ShieldsDown();
    if (ShieldsDownVoc != None)
    {
        PlaySound(ShieldsDownVoc, TRUE);
    }
}
public function TryToDriveMe(SFXPawn NewDriver);

public function bool TryToExitMe();


simulated state Downed 
{
    public event simulated function BeginState(Name PreviousStateName)
    {
        if (bCanBeEaten)
        {
            bCanBeReaped = FALSE;
            SetTimer(5.0, FALSE, 'AllowDeath', );
        }
        Super.BeginState(PreviousStateName);
    }
    
    stop;
};
simulated state RagdollRecovery 
{
    public simulated function EndState(Name NextState)
    {
        Super.EndState(NextState);
        if (IsPlayerPawn())
        {
            SetTimer(1.0, FALSE, 'DeferredResetReplicatedDeathInfoDamageType', );
        }
    }
    
    stop;
};

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ReplicatedGibInfo, ReplicatedDeathInfo;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Object Class=ForceFeedbackWaveform Name=FootstepShakeFF0
        Samples = ({Duration = 0.0, LeftAmplitude = 0, RightAmplitude = 0, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Sin0to90}
                  )
    End Object
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
    End Template
    Begin Template Class=SFXModule_Damage Name=DmgMod0
    End Template
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Object Class=SFXModule_Timeline Name=TimelineMod0
    End Object
    PS_HeadGib = ParticleSystem'BioVFX_C_Blood.Particles.Gib_Head_01'
    CE_HeadGibCap = RvrClientEffect'BioVFX_C_Blood.VCFX.HeadGib_Cap_VCFX'
    PlayerHeadShot = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_imp_gore_head'
    NonPlayerHeadShot = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_imp_gore_head'
    fThreatDuration = 3.0
    fAssistVocDelay = 1.0
    MaxConsumeTickets = 2
    srScoreTickerEntry = $702117
    srScoreTickerValueToken = $702118
    FootstepForceFeedback = FootstepShakeFF0
    bAllowHeadGib = TRUE
    bLimitConsoleLOD = TRUE
    bSupportsVisibleWeapons = TRUE
    bCanBeMeleed = TRUE
    bCanDropAmmo = TRUE
    CustomActionClasses = (None, 
                           Class'SFXCustomAction_Ragdoll', 
                           None, 
                           Class'SFXCustomAction_SyncPawnPartner_Base', 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_Frozen', 
                           None, 
                           Class'SFXCustomAction_MountedGunReload', 
                           None, 
                           None, 
                           Class'SFXCustomAction_EnterMountedGun', 
                           Class'SFXCustomAction_ExitMountedGun'
                          )
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    PowerManager = PowerMgr
    bCombatPawn = TRUE
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    bCanWalkOffLedges = TRUE
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               DmgMod0, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0
              )
    CollisionComponent = CollisionCylinder
}