Class SFXCustomAction_PickupRetrieveObject extends SFXCustomAction_SingleAnim
    config(Game);

var Name BarName;
var Name BackgroundName;
var float MinimumTimeToPickup;
var float TimeStarted;
var SFXObjective_Retrieve_PickupObject PickUpObject;
var int BarScreenPosX;
var int BarScreenPosY;
var int BarScreenWidth;
var int BarColor;
var int BackgroundColor;

public function StartCustomAction()
{
    local BioPlayerController PC;
    local BioHUD HUD;
    
    Super.StartCustomAction();
    TimeStarted = m_oPawn.WorldInfo.GameTimeSeconds;
    m_oPawn.SetTimer(0.5, TRUE, 'CheckMoving', Self);
    m_oPawn.SetTimer(0.5, TRUE, 'CheckFiring', Self);
    if (SFXGRI(m_oPawn.WorldInfo.GRI).NumLivingPlayers() > 1)
    {
        SFXGRI(m_oPawn.WorldInfo.GRI).TriggerVocalizationEvent(121, m_oPawn);
    }
    PC = BioPlayerController(m_oPawn.Controller);
    if (PC != None)
    {
        HUD = BioHUD(PC.myHUD);
        if (HUD != None)
        {
            HUD.AddBar(BackgroundName, float(BarScreenPosX), float(BarScreenPosY), float(BarScreenWidth), MinimumTimeToPickup, BackgroundColor, FALSE, FALSE);
            HUD.AddBar(BarName, float(BarScreenPosX), float(BarScreenPosY), float(BarScreenWidth), MinimumTimeToPickup, BarColor, TRUE, FALSE);
        }
    }
}
public function CheckFiring()
{
    if (m_oPawn.IsFiring())
    {
        m_oPawn.ClearTimer('CheckFiring', Self);
        InterruptThisCustomAction();
    }
}
public function StopCustomAction()
{
    local BioPlayerController PC;
    local BioHUD HUD;
    
    Super.StopCustomAction();
    m_oPawn.ClearTimer('CheckMoving', Self);
    m_oPawn.ClearTimer('CheckFiring', Self);
    if (m_oPawn.Role == ENetRole.ROLE_Authority && m_oPawn.WorldInfo.GameTimeSeconds - TimeStarted > MinimumTimeToPickup)
    {
        if (PickUpObject != None && PickUpObject.PickedUpBy == None)
        {
            PickUpObject.OnPickedUp(SFXPawn_Player(m_oPawn));
        }
    }
    PickUpObject = None;
    PC = BioPlayerController(m_oPawn.Controller);
    if (PC != None)
    {
        HUD = BioHUD(PC.myHUD);
        if (HUD != None)
        {
            HUD.RemoveBar(BackgroundName);
            HUD.RemoveBar(BarName);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
                     TimeIndex = 0.00999999978, 
                     TimeRemaining = 0.0, 
                     PSC_Instance = None, 
                     RBC_BlurInstance = None, 
                     PS_Template = None, 
                     CrustDuration = 5.0, 
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
                     RVR_CrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_RightFull_VCFX_M', 
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
                     Type = ETimelineType.TLT_ClientEffect, 
                     TargetType = ETimelineTarget.TRG_Source, 
                     VocID = ESFXVocalizationEventID.SFXVocalizationEvent_None, 
                     Constraint = EBioPartGroup.BIOPARTGROUP_NONE, 
                     AOEType = ETimelineAOEType.AOE_Radius
                    }
                   )
        Lifetime = 6.0
    End Object
    BarName = 'RetrievePickup'
    BackgroundName = 'RetrievePickupBackground'
    MinimumTimeToPickup = 4.5
    BarScreenPosX = 30
    BarScreenPosY = 75
    BarScreenWidth = 40
    BarColor = 3
    BS_Anim = {
               AnimName = ('CB_MP_Revive')
              }
    fAnimBlendInTime = 0.400000006
    fAnimBlendOutTime = 0.400000006
    ERootMotionMode = ERootMotionMode.RMM_Translate
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'SFXCustomAction_ClassMelee')
    TimelineTemplate = Timeline0
    bDisableMovement = FALSE
    bReplicateCustomAction = TRUE
}