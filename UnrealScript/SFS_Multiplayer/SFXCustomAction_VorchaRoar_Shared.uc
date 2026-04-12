Class SFXCustomAction_VorchaRoar_Shared extends SFXCustomAction_SingleAnim
    config(Game);

var(AnimControl) SFXAnimSetCookSpec AnimInfo;
var WwiseEvent LocalPlayerRoar;
var WwiseEvent NonLocalPlayerRoar;

public function StartCustomAction()
{
    m_oPawn.RegisterTemporaryAnim(AnimInfo.AnimSet);
    Super.StartCustomAction();
    if (m_oPawn.IsLocallyControlled())
    {
        m_oPawn.PlaySound(LocalPlayerRoar, TRUE);
    }
    else
    {
        m_oPawn.PlaySound(NonLocalPlayerRoar, TRUE);
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.UnregisterTemporaryAnim(AnimInfo.AnimSet);
}
public function StopAction()
{
    EndThisCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        Begin Object Class=BioDynamicAnimSet Name=MY_DYN_VOR_CB_Custom_CON_MP2
            m_nmOrigSetName = 'VOR_CB_Custom_CON_MP2'
            Sequences = (AnimSequence'BIOG_HMM_CB_CON_MP2.VOR_CB_Custom_CON_MP2_CB_VOR_Rage')
            m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_CON_MP2.VOR_CB_Custom_CON_MP2_BioAnimSetData'
        End Object
        AnimSet = MY_DYN_VOR_CB_Custom_CON_MP2
    End Object
    Begin Object Class=SFXTimelineData Name=Timeline0
        Begin Object Class=SFXCameraShakeBase Name=ScreenShake0
            TheShake = {
                        RotAmplitude = {X = 175.0, Y = 125.0, Z = 75.0}, 
                        RotFrequency = {X = 75.0, Y = 72.0, Z = 32.0}, 
                        LocAmplitude = {X = 0.0, Y = 1.5, Z = 2.5}, 
                        LocFrequency = {X = 0.5, Y = 5.0, Z = 5.0}, 
                        TimeDuration = 1.0, 
                        FOVAmplitude = 2.0, 
                        FOVFrequency = 25.0
                       }
        End Object
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
                     TimeIndex = 0.460000008, 
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
                     TimeIndex = 0.600000024, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 1.0, 
                     Sound = None, 
                     PlayerSound = None, 
                     Rumble = None, 
                     ScreenShakeObject = ScreenShake0, 
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
                     Type = ETimelineType.TLT_ScreenShake, 
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
                     Func = 'StopAction', 
                     TimeIndex = 1.0, 
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
                     TimeIndex = 0.0, 
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
                     CamAnim = CameraAnim'BioVFX_DLC_CamAnim_MP2.VOR_Rage', 
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
                     Type = ETimelineType.TLT_CameraAnim, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_None, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }
                   )
    End Object
    AnimInfo = tempAnimInfo
    LocalPlayerRoar = WwiseEvent'Wwise_Power_DLC_Bloodlust.Play_power_DLC_P_bloodlust_cast'
    NonLocalPlayerRoar = WwiseEvent'Wwise_Power_DLC_Bloodlust.Play_power_DLC_NP_bloodlust_cast'
    BS_Anim = {
               AnimName = ('None', 'CB_VOR_Rage', 'None')
              }
    DamageReductionLength = 2.0
    DamageReductionAmount = 0.899999976
    TimelineTemplate = Timeline0
    bDisableMovement = FALSE
    bDisableLeftHandIK = TRUE
    bAllowChargeHolding = TRUE
    bAllowDamageReduction = TRUE
    bReplicateCustomAction = TRUE
}