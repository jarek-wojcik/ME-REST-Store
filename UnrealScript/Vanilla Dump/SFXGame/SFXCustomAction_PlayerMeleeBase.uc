Class SFXCustomAction_PlayerMeleeBase extends SFXCustomAction_ProceduralSync
    abstract
    config(Game);

var Class<SFXDamageType> DamageType;
var ScreenShakeStruct ScreenShake;
var AreaEffectParameters MeleeImpactParameters;
var(Power) SFXPowerCustomAction_MeleePassivePower Power;
var ForceFeedbackWaveform ForceFeedback;
var ParticleSystem ImpactActorEffect1;
var ParticleSystem ImpactActorEffect2;
var WwiseEvent ImpactSound;
var WwiseEvent ImpactSoundPlayer;
var editinline export RadialBlurComponent RBC_BlurInstance;
var float BlurScale;
var float BlurFalloffExponent;
var float BlurOpacity;
var float BlurDuration;
var float SyncMoveSpeed;
var float NonSyncMoveSpeed;
var bool bPlayMeleedVoc;
var bool ApplyBlurEffect;

public function bool OnActorImpacted(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPlayerController PC;
    local SFXPawn oPawn;
    
    oPawn = SFXPawn(oImpacted);
    if (oPawn != None && ShouldReplicate())
    {
        ReplicateImpact(oPawn, , , , , oPawn.CurrentCustomAction);
    }
    if (oPawn != None && bPlayMeleedVoc)
    {
        oPawn.PlayMeleedVoc();
    }
    if (nPreviouslyImpacted == 0 && Power != None)
    {
        Power.PlayParticleSystemOnSocket(ImpactActorEffect1, m_oPawn, 'Socket_01', m_oPawn.Rotation);
        Power.PlayParticleSystemOnSocket(ImpactActorEffect2, m_oPawn, 'Socket_01', m_oPawn.Rotation);
        if (ImpactSoundPlayer != None && m_oPawn.IsHumanControlled() && m_oPawn.IsLocallyControlled())
        {
            oImpacted.PlaySound(ImpactSoundPlayer, TRUE);
        }
        else if (ImpactSound != None)
        {
            oImpacted.PlaySound(ImpactSound, TRUE);
        }
        PC = SFXPlayerController(m_oPawn.Controller);
        if (PC != None && PC.IsLocalPlayerController() && PC.PlayerCamera != None)
        {
            SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(ScreenShake);
            PC.ClientPlayForceFeedbackWaveform(ForceFeedback);
        }
        if (ApplyBlurEffect && oPawn != None)
        {
            RBC_BlurInstance = new (Self) Class'RadialBlurComponent';
            RBC_BlurInstance.SetMaterial(None);
            RBC_BlurInstance.SetBlurScale(0.349999994);
            RBC_BlurInstance.SetBlurFalloffExponent(0.5);
            RBC_BlurInstance.SetBlurOpacity(0.349999994);
            oPawn.Mesh.AttachComponentToSocket(RBC_BlurInstance, 'Socket_06');
            RBC_BlurInstance.SetEnabled(TRUE);
            m_oPawn.SetTimer(BlurDuration, FALSE, 'StopBlur', Self);
        }
        if (oPawn != None && oPawn.IsDead())
        {
            Power.OnRegularMeleeKill(oImpacted);
        }
    }
    return TRUE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(BioCustomAction).PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheGenericParticleSystemComponent(default.ImpactActorEffect1);
    ObjectPool.PrecacheGenericParticleSystemComponent(default.ImpactActorEffect2);
}
public function StartCustomAction()
{
    local SFXPowerCustomActionBase oPower;
    local SFXPowerCustomAction_MeleePassivePower oMeleePassive;
    
    Super.StartCustomAction();
    if (Power == None)
    {
        foreach m_oPawn.PowerManager.Powers(oPower, )
        {
            oMeleePassive = SFXPowerCustomAction_MeleePassivePower(oPower);
            if (oMeleePassive != None)
            {
                Power = oMeleePassive;
            }
        }
    }
}
public function StartInteraction()
{
    MoveSpeed = SyncMoveSpeed;
}
public function Breakout()
{
    local BioPlayerInput Input;
    
    if (m_oPawn != None && m_oPawn.Controller != None)
    {
        Input = BioPlayerInput(BioPlayerController(m_oPawn.Controller).PlayerInput);
        if (Input != None && (Input.RawJoyRight > 0.800000012 || Input.RawJoyRight < -0.800000012 || Input.RawJoyUp > 0.800000012 || Input.RawJoyUp < -0.800000012))
        {
            InterruptThisCustomAction();
        }
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXModule_Timeline TimeMod;
    
    if (oActor != None && m_oPawn != None && Power != None)
    {
        Power.DoAreaExplosionForActor(oActor, m_oPawn.location, ImpactCount, Power.MeleeDamage.CurrentValue, DamageType, Power.MeleeForce.CurrentValue, MeleeImpactParameters, 0, OnActorImpacted);
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
public function GetMeleeImpactParameters(out AreaEffectParameters ImpactParams)
{
    if (Power != None)
    {
        ImpactParams = MeleeImpactParameters;
        ImpactParams.ConeDirection = Vector(m_oPawn.Rotation);
        ImpactParams.ConeAngle = Power.MeleeConeAngle.CurrentValue;
    }
}
public function MeleeImpact()
{
    if (m_oPawn.IsInvisible())
    {
        m_oPawn.BreakStealth();
    }
    if (m_oPawn.Role == ENetRole.ROLE_Authority && Power != None)
    {
        GetMeleeImpactParameters(MeleeImpactParameters);
        Power.AreaExplosion(m_oPawn.location, Power.MeleeImpactRadius.CurrentValue, Power.MeleeDamage.CurrentValue, DamageType, Power.MeleeForce.CurrentValue, MeleeImpactParameters, 0, OnActorImpacted);
    }
}
public function NonSyncedAction()
{
    MoveSpeed = NonSyncMoveSpeed;
}
public function OnTimelineImpact(Actor Target);

public function StopBlur()
{
    if (RBC_BlurInstance != None)
    {
        RBC_BlurInstance.SetEnabled(FALSE);
        RBC_BlurInstance = None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=HitShake0
        Samples = ({Duration = 0.200000003, LeftAmplitude = 65, RightAmplitude = 65, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Object
    DamageType = Class'SFXDamageType_Melee'
    ScreenShake = {
                   RotAmplitude = {X = 200.0, Y = 200.0, Z = 500.0}, 
                   RotFrequency = {X = 50.0, Y = 50.0, Z = 50.0}, 
                   RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                   LocAmplitude = {X = 0.0, Y = 1.0, Z = 2.5}, 
                   LocFrequency = {X = 1.0, Y = 5.0, Z = 5.0}, 
                   LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                   ShakeName = 'None', 
                   TimeToGo = 0.0, 
                   TimeDuration = 0.300000012, 
                   RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                   LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                   FOVAmplitude = 2.0, 
                   FOVFrequency = 5.0, 
                   FOVSinOffset = 0.0, 
                   TargetingDampening = 0.0, 
                   bOverrideTargetingDampening = FALSE, 
                   FOVParam = EShakeParam.ESP_OffsetRandom
                  }
    MeleeImpactParameters = {
                             ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                             HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                             ConeAngle = 0.0, 
                             ImpactFriends = FALSE, 
                             ImpactDeadPawns = FALSE, 
                             ImpactPlaceables = TRUE, 
                             BlockedByObjects = TRUE, 
                             DistancedSorted = FALSE
                            }
    ForceFeedback = HitShake0
    SyncMoveSpeed = 800.0
    NonSyncMoveSpeed = 400.0
    bTryForceLocalSimulation = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Translate
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'SFXCustomAction_ClassMelee')
    MinTimeBetweenActions = 0.100000001
    bDisableMovement = FALSE
    bDisableLeftHandIK = TRUE
    bTurnOffReticle = TRUE
    bAllowChargeHolding = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_Low
}