Class SFXVocalizationManager extends SFXVocalizationManagerNativeBase
    transient;

struct VocEventLog 
{
    var Pawn Speaker;
    var Pawn ReferredTo;
    var float Time;
    var ESFXVocalizationEventID Id;
};
enum ESFXVocalizationEventID
{
    SFXVocalizationEvent_None,
    SFXVocalizationEvent_EnteredCombat,
    SFXVocalizationEvent_ReceivedOrder_Attack,
    SFXVocalizationEvent_ReceivedOrder_Attack_TargetValid,
    SFXVocalizationEvent_ReceivedOrder_Attack_MovingFirst,
    SFXVocalizationEvent_ReceivedOrder_Attack_KilledTarget,
    SFXVocalizationEvent_ReceivedOrder_ChangeWeapon,
    SFXVocalizationEvent_ReceivedOrder_Move,
    SFXVocalizationEvent_ReceivedOrder_Follow,
    SFXVocalizationEvent_ReceivedOrder_TakeCover,
    SFXVocalizationEvent_ReceivedOrder_Hold,
    SFXVocalizationEvent_CancellingHoldOrder,
    SFXVocalizationEvent_FailedMoveOrder,
    SFXVocalizationEvent_Attacking,
    SFXVocalizationEvent_Attacking_Henchman,
    SFXVocalizationEvent_KilledTarget_Henchman,
    SFXVocalizationEvent_LostSight,
    SFXVocalizationEvent_EnemySighted,
    SFXVocalizationEvent_MovingToCover,
    SFXVocalizationEvent_UsingPower,
    SFXVocalizationEvent_ChangingWeapon,
    SFXVocalizationEvent_Death,
    SFXVocalizationEvent_Death_NonTrivial,
    SFXVocalizationEvent_Death_Henchman,
    SFXVocalizationEvent_ReceivedDamage,
    SFXVocalizationEvent_ReceivedDamage_LowHealth,
    SFXVocalizationEvent_ReceivedDamage_ExtremelyLowHealth,
    SFXVocalizationEvent_RequireHealing,
    SFXVocalizationEvent_ShieldsDown,
    SFXVocalizationEvent_OneEnemyRemaining,
    SFXVocalizationEvent_ZeroEnemiesRemaining,
    SFXVocalizationEvent_Agitation_High,
    SFXVocalizationEvent_Agitation_Medium,
    SFXVocalizationEvent_DamageReaction_GreatPain,
    SFXVocalizationEvent_DamageReaction_OnFire,
    SFXVocalizationEvent_DamageReaction_KnockedBack,
    SFXVocalizationEvent_Falling,
    SFXVocalizationEvent_Tossed,
    SFXVocalizationEvent_Brainwashed,
    SFXVocalizationEvent_Taunt,
    SFXVocalizationEvent_Ambient,
    SFXVocalizationEvent_Power_Failed_ShieldsUp,
    SFXVocalizationEvent_Power_Failed_BarrierUp,
    SFXVocalizationEvent_Power_Failed_ArmorUp,
    SFXVocalizationEvent_Power_EnergyDrain,
    SFXVocalizationEvent_Power_Reave,
    SFXVocalizationEvent_Power_ShockWave,
    SFXVocalizationEvent_Power_Crush,
    SFXVocalizationEvent_Power_CombatDrone,
    SFXVocalizationEvent_Power_Incinerate,
    SFXVocalizationEvent_Power_Lift,
    SFXVocalizationEvent_Power_Pull,
    SFXVocalizationEvent_Power_Singularity,
    SFXVocalizationEvent_Power_Stasis,
    SFXVocalizationEvent_Power_Throw,
    SFXVocalizationEvent_Power_Warp,
    SFXVocalizationEvent_Power_Biotic_Misc,
    SFXVocalizationEvent_Power_AIHack,
    SFXVocalizationEvent_Power_Fissure,
    SFXVocalizationEvent_Power_Flashbang,
    SFXVocalizationEvent_Power_NeuralShock,
    SFXVocalizationEvent_Power_Overload,
    SFXVocalizationEvent_Power_Sabotage,
    SFXVocalizationEvent_Power_Tech_Misc,
    SFXVocalizationEvent_Power_Ammo,
    SFXVocalizationEvent_Power_Explosion,
    SFXVocalizationEvent_Power_Melee,
    SFXVocalizationEvent_Power_Projectile,
    SFXVocalizationEvent_Power_Combat_Misc,
    SFXVocalizationEvent_Power_Buff,
    SFXVocalizationEvent_Power_Cloak,
    SFXVocalizationEvent_Power_Regeneration,
    SFXVocalizationEvent_Power_Resurrection,
    SFXVocalizationEvent_Power_KroganCharge,
    SFXVocalizationEvent_Power_KroganResurrection,
    SFXVocalizationEvent_MultipleAttackers,
    SFXVocalizationEvent_ViolenceAwe,
    SFXVocalizationEvent_Bored,
    SFXVocalizationEvent_DrewWeapon_OutOfCombat,
    SFXVocalizationEvent_StaredAt,
    SFXVocalizationEvent_Bumped,
    SFXVocalizationEvent_FriendlyFire,
    SFXVocalizationEvent_Headshot,
    SFXVocalizationEvent_ShootDeadBody,
    SFXVocalizationEvent_UsedNuclearWeapon,
    SFXVocalizationEvent_CoverCrateExplosion,
    SFXVocalizationEvent_HeavyMechGoingToExplode,
    SFXVocalizationEvent_Flanked,
    SFXVocalizationEvent_UnCloaked,
    SFXVocalizationEvent_ChargeFailed,
    SFXVocalizationEvent_BlockedPower,
    SFXVocalizationEvent_PowerStillOnCooldown,
    SFXVocalizationEvent_Varren_Charge,
    SFXVocalizationEvent_Husk_Charge,
    SFXVocalizationEvent_DamageReaction_PlayerStagger,
    SFXVocalizationEvent_DamageReaction_PlayerMeleed,
    SFXVocalizationEvent_DamageReaction_PlayerMeleedII,
    SFXVocalizationEvent_DamageReaction_PlayerMeleedNoRotate,
    SFXVocalizationEvent_DamageReaction_PlayerStandardImpact,
    SFXVocalizationEvent_DamageReaction_PlayerKnockback,
    SFXVocalizationEvent_DamageReaction_BloodyPlayerStandardImpact,
    SFXVocalizationEvent_DamageReaction_PlayerOnFire,
    SFXVocalizationEvent_CollectorPossession,
    SFXVocalizationEvent_VorchaBloodlust,
    SFXVocalizationEvent_CausedDamage,
    SFXVocalizationEvent_LowAmmo,
    SFXVocalizationEvent_OutOfAmmo,
    SFXVocalizationEvent_Loot_AmmoFound,
    SFXVocalizationEvent_Loot_AmmoFull,
    SFXVocalizationEvent_Loot_TreasureFound,
    SFXVocalizationEvent_Saw_HeavyMech,
    SFXVocalizationEvent_CollectorGeneral_ReceivedDamage,
    SFXVocalizationEvent_Aggressive_Flank,
    SFXVocalizationEvent_PraetorianImmune_ReceivedDamage,
    SFXVocalizationEvent_Krogan_ReceivedDamage,
    SFXVocalizationEvent_CollectorPossessed,
    SFXVocalizationEvent_Multiplayer_Revive,
    SFXVocalizationEvent_Multiplayer_PlayerAssisted,
    SFXVocalizationEvent_Multiplayer_ObjectiveBegin,
    SFXVocalizationEvent_Multiplayer_RequestAssistMelee,
    SFXVocalizationEvent_Multiplayer_RequestAssistRanged,
    SFXVocalizationEvent_Multiplayer_RequestCoveringFire,
    SFXVocalizationEvent_Multiplayer_RangedAssistMelee,
    SFXVocalizationEvent_Multiplayer_RangedAssistRanged,
    SFXVocalizationEvent_Multiplayer_PowerAssist,
    SFXVocalizationEvent_Multiplayer_Combo,
    SFXVocalizationEvent_Multiplayer_Headshot,
    SFXVocalizationEvent_Mutliplayer_Cloaked,
    SFXVocalizationEvent_Multiplayer_Flanking,
    SFXVocalizationEvent_Power_HeavyMelee,
    SFXVocalizationEvent_Custom1,
    SFXVocalizationEvent_Custom2,
    SFXVocalizationEvent_Custom3,
    SFXVocalizationEvent_Custom4,
    SFXVocalizationEvent_Custom5,
    SFXVocalizationEvent_Custom6,
    SFXVocalizationEvent_Custom7,
    SFXVocalizationEvent_Custom8,
    SFXVocalizationEvent_Custom9,
    SFXVocalizationEvent_PlayerControllingAtlas,
    SFXVocalizationEvent_EngineerSetUpTurret,
    SFXVocalizationEvent_EngineerRepairingAtlas,
};

var transient array<VocEventLog> PastEvents;

public function DebugDraw(BioHUD H)
{
    local array<Actor> Done;
    local Actor A;
    local int idx;
    
    for (idx = PastEvents.Length - 1; idx >= 0; idx--)
    {
        if (WorldInfo.TimeSeconds - PastEvents[idx].Time > float(2))
        {
            PastEvents.Remove(idx, 1);
        }
    }
    for (idx = PastEvents.Length - 1; idx >= 0; idx--)
    {
        if (PastEvents[idx].Speaker != None)
        {
            A = PastEvents[idx].Speaker;
        }
        else
        {
            A = PastEvents[idx].ReferredTo;
        }
        if (Done.Find(A) == -1)
        {
            DrawActorLog(A, H);
            Done.AddItem(A);
        }
    }
}
protected event simulated function bool PlaySFXVocalizationSLineInternal(const out SFXVocalizationEvent E, const out SFXVocalizationLine LineToPlay, BioPawn Speaker, optional float DelaySec)
{
    return Super.PlaySFXVocalizationSLineInternal(E, LineToPlay, Speaker, DelaySec);
}
public event function PostBeginPlay()
{
    EventProperties.Length = 142;
}
public event simulated function TickEvents(float DeltaTime)
{
    local int idx;
    local int SoundsThisFrame;
    local bool bHandledVocEvent;
    local bool bInCooldown;
    local SFXVocalizationEvent CurrentEvent;
    
    SoundsThisFrame = 0;
    for (idx = 0; idx < QueuedEvents.Length; ++idx)
    {
        bHandledVocEvent = FALSE;
        bInCooldown = FALSE;
        if (QueuedEvents[idx].DelayTimeRemainingSec <= 0.0)
        {
            if (WorldInfo.GameTimeSeconds - EventProperties[QueuedEvents[idx].Id].TimeLastPlayed > EventProperties[QueuedEvents[idx].Id].MinTimeBetweenSec || bAlwaysPlay)
            {
                if (SoundsThisFrame < 1)
                {
                    CurrentEvent = QueuedEvents[idx];
                    HandleSFXVocalizationEvent(CurrentEvent);
                    bHandledVocEvent = TRUE;
                }
                SoundsThisFrame++;
            }
            else
            {
                bInCooldown = TRUE;
            }
            if (!bHandledVocEvent && EventProperties[QueuedEvents[idx].Id].bQueueIfBlocked)
            {
                continue;
            }
            if (bInCooldown || bHandledVocEvent || WorldInfo.GameTimeSeconds - QueuedEvents[idx].TriggerTimeSec > EventProperties[QueuedEvents[idx].Id].MaxDelayedTime)
            {
                QueuedEvents.Remove(idx, 1);
                --idx;
            }
            continue;
        }
        QueuedEvents[idx].DelayTimeRemainingSec -= DeltaTime;
    }
}
public final function TriggerVocalizationEvent(ESFXVocalizationEventID Id, BioPawn inInstigator, optional BioPawn Recipient, optional BioPawn ReferringTo, optional float DelaySec = -1.0, optional float fChanceToPlayModifier = 1.0, optional bool bReplicated = TRUE)
{
    local SFXVocalizationEventProperties EventProps;
    local SFXVocalizationEvent NewEvent;
    local BioWorldInfo TheWorldInfo;
    local BioPlayerController PC;
    local BioPlayerController ClientPC;
    
    if (inInstigator != None)
    {
        TheWorldInfo = BioWorldInfo(inInstigator.WorldInfo);
        if (TheWorldInfo != None)
        {
            PC = TheWorldInfo.GetLocalPlayerController();
        }
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        if (PC == None || PC.GameModeManager2 == None || PC.GameModeManager2.ShouldPlayVocalizations() == FALSE)
        {
            return;
        }
        if (Id != ESFXVocalizationEventID.SFXVocalizationEvent_None)
        {
            EventProps = EventProperties[int(Id)];
            if (FRand() <= EventProps.ChanceToPlay * fChanceToPlayModifier)
            {
                NewEvent.Instigator = inInstigator;
                NewEvent.Recipient = Recipient;
                NewEvent.Id = int(Id);
                if (DelaySec < 0.0)
                {
                    NewEvent.DelayTimeRemainingSec = EventProps.Delay;
                }
                else
                {
                    NewEvent.DelayTimeRemainingSec = DelaySec;
                }
                NewEvent.TriggerTimeSec = WorldInfo.GameTimeSeconds + NewEvent.DelayTimeRemainingSec;
                NewEvent.DebugIndex = DebugCounter++;
                if (Id == ESFXVocalizationEventID.SFXVocalizationEvent_DamageReaction_OnFire || Id == ESFXVocalizationEventID.SFXVocalizationEvent_Falling)
                {
                    if (PC != None)
                    {
                    }
                }
                QueuedEvents.AddItem(NewEvent);
                if (bReplicated)
                {
                    foreach WorldInfo.AllControllers(Class'BioPlayerController', ClientPC)
                    {
                        if (!ClientPC.IsLocalPlayerController())
                        {
                            ClientPC.ClientVocalizationEvent(NewEvent);
                        }
                    }
                }
            }
        }
    }
}
public function DrawActorLog(Actor oActor, BioHUD H)
{
    local Vector ScreenCoords;
    local float X;
    local float Y;
    local float YL;
    local Vector CamLoc;
    local Rotator CamRot;
    local int idx;
    
    if (WorldInfo == None || WorldInfo.bShowDebugText == FALSE)
    {
        return;
    }
    H.PlayerOwner.GetPlayerViewPoint(CamLoc, CamRot);
    if (oActor != None && WorldInfo.TimeSeconds - oActor.LastRenderTime < 1.0 && (oActor.location - CamLoc) Dot Vector(CamRot) > 0.0)
    {
        X = H.Canvas.CurX;
        Y = H.Canvas.CurY;
        YL = H.Canvas.CurYL;
        ScreenCoords = H.Canvas.Project(oActor.location);
        H.Canvas.CurX = ScreenCoords.X;
        H.Canvas.CurY = ScreenCoords.Y;
        for (idx = PastEvents.Length - 1; idx >= 0; idx--)
        {
            if (PastEvents[idx].Speaker == None && PastEvents[idx].ReferredTo == oActor)
            {
                H.Canvas.SetDrawColor(255, 0, 0);
                H.Canvas.DrawText(string(PastEvents[idx].Id));
                H.Canvas.CurY += float(15);
                continue;
            }
            if (PastEvents[idx].Speaker == oActor)
            {
                H.Canvas.SetDrawColor(0, 255, 0);
                H.Canvas.DrawText(string(PastEvents[idx].Id));
                H.Canvas.CurY += float(15);
            }
        }
        H.Canvas.CurX = X;
        H.Canvas.CurY = Y;
        H.Canvas.CurYL = YL;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventProperties = ({
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.100000001, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 2.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.600000024, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Instigator_Stealth), 
                        ChanceToPlay = 0.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 100.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 100.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 15.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 15.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 1.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 2.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 2.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 30.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 80.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 15.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.100000001, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = TRUE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.100000001, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = TRUE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_HenchmanWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.100000001, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = TRUE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.25, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = TRUE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.25, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.25, 
                        MinTimeBetweenSec = 0.800000012, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.800000012, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.200000003, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 2.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = TRUE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = TRUE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = TRUE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.5, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 240.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 0.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Instigator_NonCombat, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 15.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 2.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.25, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.300000012, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 30.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 6.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 0.100000001, 
                        MinTimeBetweenSec = 480.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 15.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 240.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 30.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = TRUE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 30.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 60.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 3.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 10.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 1.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = TRUE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 5.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.5, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = TRUE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 20.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.0, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = FALSE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 120.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 0.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }, 
                       {
                        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness), 
                        ChanceToPlay = 1.0, 
                        MinTimeBetweenSec = 1.0, 
                        TimeLastPlayed = -999.0, 
                        Delay = 2.0, 
                        MaxWitnessDistSq = 1e09, 
                        MaxDelayedTime = 0.5, 
                        bQueueIfBlocked = FALSE, 
                        bCanInterrupt = TRUE, 
                        bCanPlayIfDead = FALSE, 
                        bCanPlayIfRagdolled = FALSE
                       }
                      )
}