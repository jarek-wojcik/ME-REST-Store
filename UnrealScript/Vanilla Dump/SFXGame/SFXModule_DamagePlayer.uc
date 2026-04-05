Class SFXModule_DamagePlayer extends SFXModule_DamageParty
    editinlinenew
    config(Game);

const NUM_HEALTH_SEGMENTS = 5;

var(SFXModule_DamagePlayer) InterpCurveFloat BleedoutVFXCurve;
var(SFXModule_DamagePlayer) InterpCurveFloat BleedoutSFXCurve;
var string BleedOutRTPC;
var Guid CE_Bleedout_GUID;
var config float HealthRegenPct;
var transient float SoftMaxHealth;
var transient float SavedHealth;
var(SFXModule_DamagePlayer) config float ShieldPresentationTime;
var(SFXModule_DamagePlayer) config float BleedoutStartThreshold;
var(SFXModule_DamagePlayer) config float InitialBleedoutPct;
var(SFXModule_DamagePlayer) config float BleedoutVFXInterpSpeed;
var transient float CurrentBleedoutVFXParam;
var(SFXModule_DamagePlayer) config float BleedoutSFXInterpSpeed;
var transient float CurrentBleedoutSFXParam;
var RvrClientEffectInterface CE_BleedOut;
var MaterialInstanceConstant MIC_Bleedout;
var editinline transient export WwiseAudioComponent WwiseComponent;
var WwiseEventPairObject BleedOutEventPair;
var float HealthRatio;

public simulated function RecoverFromBleedout(optional bool bResetHealth = TRUE)
{
    Super.RecoverFromBleedout();
    if (bResetHealth)
    {
        SetCurrentHealth(GetMaxHealth());
    }
    if (CurrentBleedoutState != EBleedoutState.BleedOutState_None)
    {
        CurrentBleedoutState = EBleedoutState.BleedOutState_None;
    }
    DisableBleedOutVisualEffects();
    DisableBleedoutSoundEffects();
}
public simulated function Tick(float DeltaTime)
{
    Super(SFXModule).Tick(DeltaTime);
    if (CurrentHealth > 0.0 && CurrentHealth < SoftMaxHealth && ModuleOwner.IsTimerActive('RegenFullHealth', Self) == FALSE)
    {
        SetCurrentHealth(FMin(SoftMaxHealth, CurrentHealth + HealthRegenPct * GetMaxHealth() * DeltaTime));
    }
}
public simulated function SFXTakeDamage(float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, Controller instigatedBy, optional Actor DamageCauser)
{
    local Pawn DamageCauserPawn;
    
    DamageCauserPawn = Class'BioPawn'.static.FindAttackingPawn(instigatedBy, DamageCauser);
    if (SFXPawn_Henchman(DamageCauserPawn) != None)
    {
        return;
    }
    Super.SFXTakeDamage(Damage, HitInfo, HitLocation, Momentum, DamageType, instigatedBy, DamageCauser);
}
public simulated function ApplyDamageToHealth(float Damage, Controller instigatedBy, Class<SFXDamageType> DamageType, Vector HitLocation, out float AppliedDamage)
{
    Super.ApplyDamageToHealth(Damage, instigatedBy, DamageType, HitLocation, AppliedDamage);
    RecomputeHealthSegment();
}
public simulated function ApplySavedHealth()
{
    if (SavedHealth != float(0))
    {
        SetCurrentHealth(SavedHealth, TRUE);
    }
    SavedHealth = 0.0;
}
public simulated function DisableBleedoutSoundEffects()
{
    if (WwiseComponent != None)
    {
        CurrentBleedoutSFXParam = 0.0;
        WwiseComponent.SetGlobalRTPCFromScript(BleedOutRTPC, 0.0);
        WwiseComponent.Stop(BleedOutEventPair);
    }
}
public simulated function DisableBleedOutVisualEffects()
{
    ModuleOwner.ClearTimer('UpdateBleedoutFX', Self);
    if (MIC_Bleedout != None)
    {
        CurrentBleedoutVFXParam = 0.0;
        MIC_Bleedout.SetScalarParameterValue('fb_Damage', 0.0);
    }
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_BleedOut, CE_Bleedout_GUID, TRUE);
}
public final simulated function float GetBleedoutPct()
{
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_None || ModuleOwner.IsTimerActive('WaitForShieldPresentation', Self))
    {
        return 0.0;
    }
    HealthRatio = GetHealthRatio();
    if (1.0 - HealthRatio <= BleedoutStartThreshold)
    {
        return InitialBleedoutPct;
    }
    return 1.0 - HealthRatio;
}
public function RecomputeHealthSegment()
{
    local int HealthSegment;
    
    HealthSegment = FCeil(GetHealthRatio() * float(5));
    SoftMaxHealth = float(HealthSegment) * (GetMaxHealth() / float(5));
}
public simulated function RegenFullHealth();

public function SetCurrentHealth(float NewHealth, optional bool bRecomputeHealthSegment)
{
    Super(SFXModule_DamageNativeBase).SetCurrentHealth(NewHealth, bRecomputeHealthSegment);
    if (bRecomputeHealthSegment)
    {
        RecomputeHealthSegment();
    }
}
public simulated function SetPlayerHealthFromSave(float Health)
{
    SavedHealth = Health;
    SetCurrentHealth(Health, TRUE);
}
public simulated function StartBleedOut()
{
    local bool bIsAutoBot;
    local BioWorldInfo WorldInfo;
    local PlayerController PC;
    
    Super.StartBleedOut();
    WorldInfo = BioWorldInfo(ModuleOwner.WorldInfo);
    if (WorldInfo != None && WorldInfo.GetAutoBotsEnabled())
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC != None && PC.IsLocalPlayerController() && PC.GetViewTarget() == ModuleOwner)
            {
                bIsAutoBot = TRUE;
                break;
            }
        }
    }
    if (Pawn(ModuleOwner).IsLocallyControlled() || bIsAutoBot)
    {
        ModuleOwner.SetTimer(ShieldPresentationTime, FALSE, 'WaitForShieldPresentation', Self);
        ModuleOwner.SetTimer(0.0500000007, TRUE, 'UpdateBleedoutFX', Self);
        if (WwiseComponent == None)
        {
            WwiseComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(ModuleOwner, "_BleedOut");
            if (WwiseComponent != None)
            {
                WwiseComponent.SetGlobalRTPCFromScript(BleedOutRTPC, 0.0);
            }
        }
        if (WwiseComponent != None)
        {
            WwiseComponent.Play(BleedOutEventPair);
        }
        if (CE_BleedOut != None)
        {
            CE_Bleedout_GUID = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(CE_BleedOut, ModuleOwner);
            if (MIC_Bleedout != None)
            {
                CurrentBleedoutVFXParam = 0.0;
                MIC_Bleedout.SetScalarParameterValue('fb_Damage', CurrentBleedoutVFXParam);
            }
        }
    }
}
public final simulated function UpdateBleedoutFX()
{
    local float NewBleedoutVFXParam;
    local float NewBleedoutSFXParam;
    local float BleedoutPct;
    
    if (ModuleOwner.IsTimerActive('WaitForShieldPresentation', Self))
    {
        return;
    }
    BleedoutPct = GetBleedoutPct();
    Class'BioInterpolator'.static.InterpolateFloatCurve(NewBleedoutVFXParam, BleedoutVFXCurve, 0.0, 1.0, BleedoutPct);
    CurrentBleedoutVFXParam = Lerp(CurrentBleedoutVFXParam, NewBleedoutVFXParam, 0.0500000007 * BleedoutVFXInterpSpeed);
    if (MIC_Bleedout != None)
    {
        MIC_Bleedout.SetScalarParameterValue('fb_Damage', CurrentBleedoutVFXParam);
    }
    Class'BioInterpolator'.static.InterpolateFloatCurve(NewBleedoutSFXParam, BleedoutSFXCurve, 0.0, 1.0, BleedoutPct);
    CurrentBleedoutSFXParam = Lerp(CurrentBleedoutSFXParam, NewBleedoutSFXParam, 0.0500000007 * BleedoutSFXInterpSpeed);
    if (WwiseComponent != None)
    {
        WwiseComponent.SetGlobalRTPCFromScript(BleedOutRTPC, CurrentBleedoutSFXParam);
    }
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_None && CurrentBleedoutVFXParam ~= 0.0)
    {
        DisableBleedOutVisualEffects();
    }
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_None && CurrentBleedoutSFXParam <= 0.100000001)
    {
        DisableBleedoutSoundEffects();
    }
}
public final simulated function WaitForShieldPresentation();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=WwiseEventPairObject Name=BleedOutWwiseEventPair
        Play = WwiseEvent'Wwise_Generic_GUI.Play_GUI_Bleedout'
        Stop = WwiseEvent'Wwise_Generic_GUI.Stop_GUI_Bleedout'
    End Object
    BleedoutVFXCurve = {
                        Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                  {InVal = 0.75, OutVal = 0.300000012, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                  {InVal = 1.0, OutVal = 0.75, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                                 ), 
                        InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                       }
    BleedoutSFXCurve = {
                        Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                  {InVal = 0.25, OutVal = 0.400000006, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                  {InVal = 0.600000024, OutVal = 0.899999976, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                  {InVal = 1.0, OutVal = 0.99000001, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                                 ), 
                        InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                       }
    BleedOutRTPC = "Player_Bleedout_Amount"
    HealthRegenPct = 0.25
    ShieldPresentationTime = 0.5
    BleedoutStartThreshold = 0.25
    InitialBleedoutPct = 0.25
    BleedoutVFXInterpSpeed = 4.0
    BleedoutSFXInterpSpeed = 4.0
    CE_BleedOut = RvrClientEffect'BioVFX_FB_PlayerDamage.VCFX.GameOver_Screen_VCFX'
    MIC_Bleedout = MaterialInstanceConstant'BioVFX_FB_PlayerDamage.Materials.Inst_GameOverBlood'
    BleedOutEventPair = BleedOutWwiseEventPair
    HealthGateThreshold = 0.0500000007
    TOTAL_HEALTH_STEPS = 15
}