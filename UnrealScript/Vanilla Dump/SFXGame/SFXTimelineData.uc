Class SFXTimelineData
    native;

struct native TimelineEffect 
{
    var(TimelineEffect) InterpCurveFloat TimeDilation;
    var(TimelineEffect) array<EReactionTypes> Reactions;
    var(TimelineEffect) delegate<AOEEvalFunc> AOEFunc;
    var(TimelineEffect) string InputAlias;
    var(TimelineEffect) delegate<InputHandler> InputHandle;
    var(TimelineEffect) Class<WaveFormBase> RumbleClass;
    var(TimelineEffect) Class<SFXCameraShakeBase> ScreenShakeClass;
    var(TimelineEffect) Class<DamageType> DamageType;
    var(TimelineEffect) Class<Actor> AOEFilterClass;
    var Class<SFXGameEffect> GameEffectClass;
    var(TimelineEffect) ScreenShakeStruct ScreenShake;
    var Guid ClientEffectID;
    var(TimelineEffect) Rotator PS_Rotation;
    var(TimelineEffect) Name SocketName;
    var(TimelineEffect) Name Func;
    var(TimelineEffect) float TimeIndex;
    var float TimeRemaining;
    var editinline export ParticleSystemComponent PSC_Instance;
    var editinline export RadialBlurComponent RBC_BlurInstance;
    var(TimelineEffect) ParticleSystem PS_Template;
    var(TimelineEffect) float CrustDuration;
    var(TimelineEffect) WwiseEvent Sound;
    var(TimelineEffect) WwiseEvent PlayerSound;
    var(TimelineEffect) ForceFeedbackWaveform Rumble;
    var(TimelineEffect) SFXCameraShakeBase ScreenShakeObject;
    var(TimelineEffect) float TimeDilationLength;
    var(TimelineEffect) float RagdollForce;
    var(TimelineEffect) float Damage;
    var(TimelineEffect) float AOERadius;
    var(TimelineEffect) float AOEConeAngle;
    var(TimelineEffect) SFXTimelineData AOEImpactTimeline;
    var(TimelineEffect) SFXTimelineData SyncPartnerImpactTimeline;
    var(TimelineEffect) SFXTimelineData TimelineTemplate;
    var(TimelineEffect) int nMatchedInputIndex;
    var(TimelineEffect) MaterialInterface BlurMaterial;
    var(TimelineEffect) float BlurScale;
    var(TimelineEffect) float BlurFalloffExponent;
    var(TimelineEffect) float BlurOpacity;
    var(TimelineEffect) CameraAnim CamAnim;
    var(TimelineEffect) float CamStartTime;
    var(TimelineEffect) float CamBlendInTime;
    var(TimelineEffect) float CamBlendOutTime;
    var(TimelineEffect) float CamPlayRate;
    var(TimelineEffect) float CamDuration;
    var(TimelineEffect) RvrClientEffectInterface RVR_CrustTemplate;
    var(TimelineEffect) int CEStartIndex;
    var float GameEffectDuration;
    var float GameEffectValue;
    var bool bActivated;
    var bool bActiveInput;
    var bool bReceivedInput;
    var(TimelineEffect) bool bUseWeaponMesh;
    var(TimelineEffect) bool bApplyBloodColorParam;
    var(TimelineEffect) bool bDilateSound;
    var(TimelineEffect) bool bAOEAffectsTarget;
    var(TimelineEffect) bool bOnPress;
    var(TimelineEffect) bool bExclusive;
    var(TimelineEffect) bool bBufferedInput;
    var(TimelineEffect) bool bLoopCamAnim;
    var(TimelineEffect) bool bCEAllowCooldown;
    var(TimelineEffect) bool bCEStopAllMatching;
    var(TimelineEffect) ETimelineType Type;
    var(TimelineEffect) ETimelineTarget TargetType;
    var(TimelineEffect) ESFXVocalizationEventID VocID;
    var(TimelineEffect) EBioPartGroup Constraint;
    var(TimelineEffect) ETimelineAOEType AOEType;
    
    structdefaultproperties
    {
        AOEFilterClass = Class'Actor'
        CrustDuration = 1.0
        TimeDilationLength = 1.0
        RagdollForce = 100.0
        Damage = 1.0
        AOERadius = 500.0
        BlurScale = 1.0
        BlurFalloffExponent = 1.5
        BlurOpacity = 1.0
        CamBlendInTime = 0.200000003
        CamBlendOutTime = 0.200000003
        CamPlayRate = 1.0
        bDilateSound = TRUE
        bExclusive = TRUE
        bCEAllowCooldown = TRUE
    }
};
enum ETimelineAOEType
{
    AOE_Radius,
    AOE_Cone,
};
enum ETimelineTarget
{
    TRG_Source,
    TRG_Target,
};
enum ETimelineType
{
    TLT_None,
    TLT_Visual,
    TLT_Sound,
    TLT_Voc,
    TLT_Rumble,
    TLT_ScreenShake,
    TLT_TimeDilation,
    TLT_Ragdoll,
    TLT_Reaction,
    TLT_Damage,
    TLT_AOE,
    TLT_AOEVisiblePawns,
    TLT_AOESingle,
    TLT_SyncPartner,
    TLT_Timeline,
    TLT_InputOn,
    TLT_InputOff,
    TLT_Function,
    TLT_RadialBlurOn,
    TLT_RadialBlurOff,
    TLT_CameraAnim,
    TLT_ClientEffect,
    TLT_ClientEffect_Stop,
    TLT_GameEffect,
};

var(SFXTimelineData) editinline array<TimelineEffect> Timeline;
var delegate<AOEEvalFunc> __AOEEvalFunc__Delegate;
var delegate<InputHandler> __InputHandler__Delegate;
var(SFXTimelineData) float Lifetime;
var transient float LifetimeLeft;
var(SFXTimelineData) transient Actor Source;
var(SFXTimelineData) transient Actor Target;
var(SFXTimelineData) transient Object FuncOwner;

public delegate function bool AOEEvalFunc(Actor ChkOwner, Actor ChkTarget)
{
    return TRUE;
}
public native function InitializeTimeline(Object oFuncOwner);

public function InputCallback(string Alias, bool bPress)
{
    local int i;
    local delegate<InputHandler> TimedInputHandler;
    
    for (i = 0; i < Timeline.Length; i++)
    {
        if (Timeline[i].Type == ETimelineType.TLT_InputOn && Timeline[i].bActiveInput)
        {
            if (Timeline[i].bOnPress == bPress && Timeline[i].InputAlias == Alias)
            {
                if (Timeline[i].bBufferedInput)
                {
                    Timeline[i].bReceivedInput = TRUE;
                    continue;
                }
                TimedInputHandler = Timeline[i].InputHandle;
                if (TimedInputHandler != None)
                {
                    TimedInputHandler();
                }
            }
        }
    }
}
public delegate function InputHandler();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Lifetime = 5.0
}