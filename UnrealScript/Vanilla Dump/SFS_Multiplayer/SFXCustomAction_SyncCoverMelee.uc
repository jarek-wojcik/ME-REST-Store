Class SFXCustomAction_SyncCoverMelee extends SFXCustomAction_PlayerMeleeBase
    config(Game);

var(SFXCustomAction_SyncCoverMelee) BodyStance BS_AnimPistol;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_AnimPistol, UsedAnims);
    Super(SFXCustomAction_SingleAnim).GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(m_oPawn.Weapon);
    if (Weapon.IsInState('WeaponEquipping', ) == FALSE && Weapon.IsInState('WeaponPuttingDown', ) == FALSE)
    {
        if (SFXWeapon_SMG_Base(Weapon) != None || SFXWeapon_Pistol_Base(Weapon) != None)
        {
            BS_Anim = default.BS_AnimPistol;
        }
        else
        {
            BS_Anim = default.BS_Anim;
        }
    }
    m_oPawn.StopMovement(TRUE);
    m_oPawn.CurrentSlotDirection = ECoverDirection.CD_Default;
    Super.StartCustomAction();
}
public function EndThisCustomAction()
{
    local BioPlayerController oPlayer;
    
    Super(BioCustomAction).EndThisCustomAction();
    oPlayer = BioPlayerController(m_oPawn.Controller);
    if (oPlayer != None)
    {
        oPlayer.GetGameModeDefault().TryAcquireCover();
    }
}
public function MeleeImpact()
{
    if (m_oPawn.IsInvisible())
    {
        m_oPawn.BreakStealth();
    }
    if (Power != None)
    {
        MeleeImpactParameters.ConeDirection = Vector(m_oPawn.Rotation);
        Power.AreaExplosion(m_oPawn.location, Power.CoverMeleeImpactRadius.CurrentValue, Power.MeleeDamage.CurrentValue, DamageType, Power.MeleeForce.CurrentValue, MeleeImpactParameters, 0, OnActorImpacted);
    }
}
public function StopCustomAction()
{
    Super(SFXCustomAction_ProceduralSync).StopCustomAction();
    m_oPawn.StopMovement(FALSE);
    m_oPawn.bDisableAnimatedTransitions = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=HitShake0
    End Template
    Begin Object Class=SFXTimelineData Name=Timeline0
        Timeline = ({
                     TimeDilation = {
                                     Points = (), 
                                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                                    }, 
                     Reactions = (), 
                     AOEFunc = None, 
                     InputAlias = "", 
                     InputHandle = None, 
                     RumbleClass = None, 
                     ScreenShakeClass = None, 
                     DamageType = None, 
                     AOEFilterClass = Class'Actor', 
                     GameEffectClass = None, 
                     ScreenShake = {
                                    RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                                    RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                                    RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                                    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                                    LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    ShakeName = 'None', 
                                    TimeToGo = 0.0, 
                                    TimeDuration = 1.0, 
                                    RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    FOVAmplitude = 2.0, 
                                    FOVFrequency = 5.0, 
                                    FOVSinOffset = 0.0, 
                                    TargetingDampening = 0.0, 
                                    bOverrideTargetingDampening = FALSE, 
                                    FOVParam = EShakeParam.ESP_OffsetRandom
                                   }, 
                     ClientEffectID = {A = 0, B = 0, C = 0, D = 0}, 
                     PS_Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                     SocketName = 'None', 
                     Func = 'None', 
                     TimeIndex = 0.0500000007, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 1.0, 
                     Sound = WwiseEvent'Wwise_Generic_Foley.Play_foley_melee_whoosh', 
                     PlayerSound = None, 
                     Rumble = None, 
                     ScreenShakeObject = None, 
                     TimeDilationLength = 1.0, 
                     RagdollForce = 100.0, 
                     Damage = 1.0, 
                     AOERadius = 500.0, 
                     AOEConeAngle = 0.0, 
                     AOEImpactTimeline = None, 
                     SyncPartnerImpactTimeline = None, 
                     TimelineTemplate = None, 
                     nMatchedInputIndex = 0, 
                     BlurMaterial = None, 
                     BlurScale = 1.0, 
                     BlurFalloffExponent = 1.5, 
                     BlurOpacity = 1.0, 
                     CamAnim = None, 
                     CamStartTime = 0.0, 
                     CamBlendInTime = 0.200000003, 
                     CamBlendOutTime = 0.200000003, 
                     CamPlayRate = 1.0, 
                     CamDuration = 0.0, 
                     RVR_CrustTemplate = None, 
                     CEStartIndex = 0, 
                     GameEffectDuration = 0.0, 
                     GameEffectValue = 0.0, 
                     bActivated = FALSE, 
                     bActiveInput = FALSE, 
                     bReceivedInput = FALSE, 
                     bUseWeaponMesh = FALSE, 
                     bApplyBloodColorParam = FALSE, 
                     bDilateSound = TRUE, 
                     bAOEAffectsTarget = FALSE, 
                     bOnPress = FALSE, 
                     bExclusive = TRUE, 
                     bBufferedInput = FALSE, 
                     bLoopCamAnim = FALSE, 
                     bCEAllowCooldown = TRUE, 
                     bCEStopAllMatching = FALSE, 
                     Type = ETimelineType.TLT_Sound, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_None, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }, 
                    {
                     TimeDilation = {
                                     Points = (), 
                                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                                    }, 
                     Reactions = (), 
                     AOEFunc = None, 
                     InputAlias = "", 
                     InputHandle = None, 
                     RumbleClass = None, 
                     ScreenShakeClass = None, 
                     DamageType = None, 
                     AOEFilterClass = Class'Actor', 
                     GameEffectClass = None, 
                     ScreenShake = {
                                    RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                                    RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                                    RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                                    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                                    LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    ShakeName = 'None', 
                                    TimeToGo = 0.0, 
                                    TimeDuration = 1.0, 
                                    RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    FOVAmplitude = 2.0, 
                                    FOVFrequency = 5.0, 
                                    FOVSinOffset = 0.0, 
                                    TargetingDampening = 0.0, 
                                    bOverrideTargetingDampening = FALSE, 
                                    FOVParam = EShakeParam.ESP_OffsetRandom
                                   }, 
                     ClientEffectID = {A = 0, B = 0, C = 0, D = 0}, 
                     PS_Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                     SocketName = 'None', 
                     Func = 'None', 
                     TimeIndex = 0.0500000007, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 1.0, 
                     Sound = None, 
                     PlayerSound = None, 
                     Rumble = None, 
                     ScreenShakeObject = None, 
                     TimeDilationLength = 1.0, 
                     RagdollForce = 100.0, 
                     Damage = 1.0, 
                     AOERadius = 500.0, 
                     AOEConeAngle = 0.0, 
                     AOEImpactTimeline = None, 
                     SyncPartnerImpactTimeline = None, 
                     TimelineTemplate = None, 
                     nMatchedInputIndex = 0, 
                     BlurMaterial = None, 
                     BlurScale = 1.0, 
                     BlurFalloffExponent = 1.5, 
                     BlurOpacity = 1.0, 
                     CamAnim = None, 
                     CamStartTime = 0.0, 
                     CamBlendInTime = 0.200000003, 
                     CamBlendOutTime = 0.200000003, 
                     CamPlayRate = 1.0, 
                     CamDuration = 0.0, 
                     RVR_CrustTemplate = None, 
                     CEStartIndex = 0, 
                     GameEffectDuration = 0.0, 
                     GameEffectValue = 0.0, 
                     bActivated = FALSE, 
                     bActiveInput = FALSE, 
                     bReceivedInput = FALSE, 
                     bUseWeaponMesh = FALSE, 
                     bApplyBloodColorParam = FALSE, 
                     bDilateSound = TRUE, 
                     bAOEAffectsTarget = FALSE, 
                     bOnPress = FALSE, 
                     bExclusive = TRUE, 
                     bBufferedInput = FALSE, 
                     bLoopCamAnim = FALSE, 
                     bCEAllowCooldown = TRUE, 
                     bCEStopAllMatching = FALSE, 
                     Type = ETimelineType.TLT_Voc, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Melee, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }, 
                    {
                     TimeDilation = {
                                     Points = (), 
                                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                                    }, 
                     Reactions = (), 
                     AOEFunc = None, 
                     InputAlias = "", 
                     InputHandle = None, 
                     RumbleClass = None, 
                     ScreenShakeClass = None, 
                     DamageType = None, 
                     AOEFilterClass = Class'Actor', 
                     GameEffectClass = None, 
                     ScreenShake = {
                                    RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                                    RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                                    RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                                    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                                    LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    ShakeName = 'None', 
                                    TimeToGo = 0.0, 
                                    TimeDuration = 1.0, 
                                    RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    FOVAmplitude = 2.0, 
                                    FOVFrequency = 5.0, 
                                    FOVSinOffset = 0.0, 
                                    TargetingDampening = 0.0, 
                                    bOverrideTargetingDampening = FALSE, 
                                    FOVParam = EShakeParam.ESP_OffsetRandom
                                   }, 
                     ClientEffectID = {A = 0, B = 0, C = 0, D = 0}, 
                     PS_Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                     SocketName = 'None', 
                     Func = 'None', 
                     TimeIndex = 0.25, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 1.0, 
                     Sound = None, 
                     PlayerSound = None, 
                     Rumble = None, 
                     ScreenShakeObject = None, 
                     TimeDilationLength = 1.0, 
                     RagdollForce = 100.0, 
                     Damage = 1.0, 
                     AOERadius = 500.0, 
                     AOEConeAngle = 0.0, 
                     AOEImpactTimeline = None, 
                     SyncPartnerImpactTimeline = None, 
                     TimelineTemplate = None, 
                     nMatchedInputIndex = 0, 
                     BlurMaterial = None, 
                     BlurScale = 1.0, 
                     BlurFalloffExponent = 1.5, 
                     BlurOpacity = 1.0, 
                     CamAnim = None, 
                     CamStartTime = 0.0, 
                     CamBlendInTime = 0.200000003, 
                     CamBlendOutTime = 0.200000003, 
                     CamPlayRate = 1.0, 
                     CamDuration = 0.0, 
                     RVR_CrustTemplate = None, 
                     CEStartIndex = 0, 
                     GameEffectDuration = 0.0, 
                     GameEffectValue = 0.0, 
                     bActivated = FALSE, 
                     bActiveInput = FALSE, 
                     bReceivedInput = FALSE, 
                     bUseWeaponMesh = FALSE, 
                     bApplyBloodColorParam = FALSE, 
                     bDilateSound = TRUE, 
                     bAOEAffectsTarget = FALSE, 
                     bOnPress = FALSE, 
                     bExclusive = TRUE, 
                     bBufferedInput = FALSE, 
                     bLoopCamAnim = FALSE, 
                     bCEAllowCooldown = TRUE, 
                     bCEStopAllMatching = FALSE, 
                     Type = ETimelineType.TLT_Voc, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Melee, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }, 
                    {
                     TimeDilation = {
                                     Points = (), 
                                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                                    }, 
                     Reactions = (), 
                     AOEFunc = None, 
                     InputAlias = "", 
                     InputHandle = None, 
                     RumbleClass = None, 
                     ScreenShakeClass = None, 
                     DamageType = None, 
                     AOEFilterClass = Class'Actor', 
                     GameEffectClass = None, 
                     ScreenShake = {
                                    RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                                    RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                                    RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                                    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                                    LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    ShakeName = 'None', 
                                    TimeToGo = 0.0, 
                                    TimeDuration = 1.0, 
                                    RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom}, 
                                    FOVAmplitude = 2.0, 
                                    FOVFrequency = 5.0, 
                                    FOVSinOffset = 0.0, 
                                    TargetingDampening = 0.0, 
                                    bOverrideTargetingDampening = FALSE, 
                                    FOVParam = EShakeParam.ESP_OffsetRandom
                                   }, 
                     ClientEffectID = {A = 0, B = 0, C = 0, D = 0}, 
                     PS_Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                     SocketName = 'None', 
                     Func = 'MeleeImpact', 
                     TimeIndex = 0.370000005, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 1.0, 
                     Sound = None, 
                     PlayerSound = None, 
                     Rumble = None, 
                     ScreenShakeObject = None, 
                     TimeDilationLength = 1.0, 
                     RagdollForce = 100.0, 
                     Damage = 1.0, 
                     AOERadius = 500.0, 
                     AOEConeAngle = 0.0, 
                     AOEImpactTimeline = None, 
                     SyncPartnerImpactTimeline = None, 
                     TimelineTemplate = None, 
                     nMatchedInputIndex = 0, 
                     BlurMaterial = None, 
                     BlurScale = 1.0, 
                     BlurFalloffExponent = 1.5, 
                     BlurOpacity = 1.0, 
                     CamAnim = None, 
                     CamStartTime = 0.0, 
                     CamBlendInTime = 0.200000003, 
                     CamBlendOutTime = 0.200000003, 
                     CamPlayRate = 1.0, 
                     CamDuration = 0.0, 
                     RVR_CrustTemplate = None, 
                     CEStartIndex = 0, 
                     GameEffectDuration = 0.0, 
                     GameEffectValue = 0.0, 
                     bActivated = FALSE, 
                     bActiveInput = FALSE, 
                     bReceivedInput = FALSE, 
                     bUseWeaponMesh = FALSE, 
                     bApplyBloodColorParam = FALSE, 
                     bDilateSound = TRUE, 
                     bAOEAffectsTarget = FALSE, 
                     bOnPress = FALSE, 
                     bExclusive = TRUE, 
                     bBufferedInput = FALSE, 
                     bLoopCamAnim = FALSE, 
                     bCEAllowCooldown = TRUE, 
                     bCEStopAllMatching = FALSE, 
                     Type = ETimelineType.TLT_Function, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_None, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }
                   )
    End Object
    BS_AnimPistol = {
                     AnimName = ('CB_Whack_A_Mole')
                    }
    DamageType = Class'SFXDamageType_SecondMelee'
    MeleeImpactParameters = {ConeAngle = 45.0, BlockedByObjects = FALSE, DistancedSorted = TRUE}
    ForceFeedback = HitShake0
    ImpactActorEffect1 = ParticleSystem'BioVFX_T_Melee.Particles.Punch_Impact'
    ImpactActorEffect2 = ParticleSystem'BioVFX_C_Impacts.Stone.Particles.Stone_Material_Imp'
    ImpactSound = WwiseEvent'Wwise_Generic_Foley.Play_foley_melee_hit_standard_np'
    ImpactSoundPlayer = WwiseEvent'Wwise_Generic_Foley.Play_foley_melee_hit_standard'
    BS_Anim = {
               AnimName = ('CB_RifleAtk1')
              }
    fAnimBlendInTime = 0.100000001
    fAnimBlendOutTime = 0.349999994
    MinTimeBetweenActions = 0.5
    TimelineTemplate = Timeline0
    bBreakFromCover = FALSE
    bDisableMovement = TRUE
    bNotifyKnockedOutOfCover = FALSE
}