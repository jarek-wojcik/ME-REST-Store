Class SFXCustomAction_PlayerHeavyMeleeBase extends SFXCustomAction_ProceduralSync
    config(Game);

var transient array<Actor> AffectedActors;
var Class<SFXDamageType> DamageType;
var AreaEffectParameters MeleeImpactParameters;
var(AnimControl) SFXAnimSetCookSpec AnimInfo;
var(Power) SFXPowerCustomAction_MeleePassivePower Power;
var int OmniWeaponPlotID;

public function bool OnActorImpacted(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn oPawn;
    
    if (Power == None)
    {
        return FALSE;
    }
    oPawn = BioPawn(oImpacted);
    if (ShouldReplicate() && oPawn != None)
    {
        ReplicateImpact(oPawn, , , , , oPawn.CurrentCustomAction);
    }
    return TRUE;
}
public function StartCustomAction()
{
    local Actor NearbyActor;
    local SFXPowerCustomActionBase oPower;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    local SFXGRI GRI;
    
    m_oPawn.RegisterTemporaryAnim(AnimInfo.AnimSet);
    Super.StartCustomAction();
    if (Power == None && m_oPawn.PowerManager != None)
    {
        foreach m_oPawn.PowerManager.Powers(oPower, )
        {
            Power = SFXPowerCustomAction_MeleePassivePower(oPower);
            if (Power != None)
            {
                break;
            }
        }
    }
    if (m_oPawn.Role == ENetRole.ROLE_Authority && Power != None)
    {
        AffectedActors.Length = 0;
        if (Power.MaximumImpactTargets.CurrentValue == 1.0 && SyncPartner != None)
        {
            Power.ApplyTemporaryGameEffect(SyncPartner, Class'SFXGameEffect_MovementSpeedBonus', 1.0, -1.0, Name, m_oPawn.Controller);
            AffectedActors.AddItem(SyncPartner);
        }
        else
        {
            MeleeImpactParameters.ConeDirection = Vector(m_oPawn.Rotation);
            MeleeImpactParameters.ConeAngle = Power.HeavyMeleeConeAngle.CurrentValue;
            Power.GetNearbyActors(AffectedActors, m_oPawn.location, Power.HeavyMeleeImpactRadius.CurrentValue, Power.HeavyMeleeImpactRadius.CurrentValue, MeleeImpactParameters);
            foreach AffectedActors(NearbyActor, )
            {
                Power.ApplyTemporaryGameEffect(NearbyActor, Class'SFXGameEffect_MovementSpeedBonus', 1.0, -1.0, Name, m_oPawn.Controller);
            }
        }
    }
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI != None)
    {
        GRI = SFXGRI(WI.GRI);
        VarTable = WI.GetGlobalVariables();
        if (VarTable != None && GRI != None && GRI.bIsMultiplayerCharacter == FALSE)
        {
            VarTable.SetBool(OmniWeaponPlotID, TRUE);
        }
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXModule_Timeline TimeMod;
    
    if (oActor != None && m_oPawn != None && Power != None)
    {
        Power.DoAreaExplosionForActor(oActor, m_oPawn.location, ImpactCount, Power.HeavyMeleeDamage.CurrentValue, DamageType, Power.HeavyMeleeForce.CurrentValue, MeleeImpactParameters, 0, OnActorImpacted);
        if (BioPawn(oActor) != None && CustomActionReactionType != 0)
        {
            BioPawn(oActor).StartCustomAction(int(byte(CustomActionReactionType)));
        }
        TimeMod = m_oPawn.GetModule(Class'SFXModule_Timeline');
        if (TimeMod != None)
        {
            TimeMod.SpawnTimeline(ImpactTimeline, Self, m_oPawn, oActor);
        }
    }
}
public function MeleeImpact()
{
    if (m_oPawn.IsInvisible())
    {
        m_oPawn.BreakStealth();
    }
    if (Power != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (Power.MaximumImpactTargets.CurrentValue == 1.0 && SyncPartner != None)
        {
            Power.DoAreaExplosionForActor(SyncPartner, m_oPawn.location, 0, Power.HeavyMeleeDamage.CurrentValue, DamageType, Power.HeavyMeleeForce.CurrentValue, MeleeImpactParameters, 0, OnActorImpacted);
        }
        else
        {
            MeleeImpactParameters.ConeDirection = Vector(m_oPawn.Rotation);
            MeleeImpactParameters.ConeAngle = Power.HeavyMeleeConeAngle.CurrentValue;
            Power.AreaExplosion(m_oPawn.location, Power.HeavyMeleeImpactRadius.CurrentValue, Power.HeavyMeleeDamage.CurrentValue, DamageType, Power.HeavyMeleeForce.CurrentValue, MeleeImpactParameters, int(Power.MaximumImpactTargets.CurrentValue), OnActorImpacted);
        }
    }
}
public function OnTimelineImpact(Actor Target);

public function ReplicateImpact(BioPawn Target, optional int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    if (Target != None)
    {
        Target.AcquireReplicatedCustomActionImpact();
        Super(BioCustomAction).ReplicateImpact(Target, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
        Target.ReplicatedCustomActionImpactInfo.CustomActionType = 58;
        Target.ReplicatedCustomActionImpactInfo.PowerCustomActionType = 0;
        Target.ReleaseReplicatedCustomActionImpact();
    }
}
public function StopCustomAction()
{
    local SFXModule_GameEffectManager Manager;
    local Actor AffectedActor;
    
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        foreach AffectedActors(AffectedActor, )
        {
            Manager = AffectedActor.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                Manager.RemoveEffectsByCategory(Name);
            }
        }
        AffectedActors.Length = 0;
    }
    Super.StopCustomAction();
    m_oPawn.UnregisterTemporaryAnim(AnimInfo.AnimSet);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageType = Class'SFXDamageType_HeavyMelee'
    MeleeImpactParameters = {
                             ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                             HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                             ConeAngle = 0.0, 
                             ImpactFriends = FALSE, 
                             ImpactDeadPawns = FALSE, 
                             ImpactPlaceables = TRUE, 
                             BlockedByObjects = TRUE, 
                             DistancedSorted = TRUE
                            }
    OmniWeaponPlotID = 20881
    DestinationOffset = 150.0
    bTryForceLocalSimulation = TRUE
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'SFXCustomAction_PlayerEvadeBase', Class'SFXCustomAction_PlayerMeleeBase', Class'SFXCustomAction_ReloadBase')
    PlayerCameraMode = Class'SFXCameraMode_CustomAction'
    MinTimeBetweenActions = 0.5
    fCameraTransitionIn = 0.100000001
    fCameraTransitionOut = 0.100000001
    bHideWeapon = TRUE
    bTurnOffReticle = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_High
}