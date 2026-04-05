Class SFXShield_Player extends SFXShield_Base
    config(Weapon);

var(SFXShield_Player) InterpCurveFloat TimeDilation;
var(SFXShield_Player) InterpCurveFloat BreachTimeDilation;
var(SFXShield_Player) ScreenShakeStruct BreachShake;
var(SFXShield_Player) config float PartialBreakPct;
var(SFXShield_Player) ParticleSystem PS_CriticalHit;
var RvrClientEffectInterface CE_ShieldBreak;
var(SFXShield_Player) float TimeDilationLength;
var(SFXShield_Player) float BreachTimeDilationLength;
var(SFXShield_Player) WwiseEvent PCShieldsBreakSound;
var(SFXShield_Player) WwiseEvent PCShieldsUpSound;
var(SFXShield_Player) WwiseEvent ShieldBreakPainVoc;

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    ObjectPool.PrecacheGenericParticleSystemComponent(default.PS_CriticalHit);
    Super.PrecacheVFX(ObjectPool, ClientEffects);
}
protected simulated function ApplyDamageToShields(out float Damage, Class<SFXDamageType> DamageType, Vector Momentum, Vector HitLocation, TraceHitInfo HitInfo, Controller instigatedBy)
{
    local float OldShields;
    local float ShieldBreakValue;
    local float CurrentShieldValue;
    
    OldShields = GetCurrentShields();
    Super.ApplyDamageToShields(Damage, DamageType, Momentum, HitLocation, HitInfo, instigatedBy);
    CurrentShieldValue = GetCurrentShields();
    if (CurrentShieldValue > 0.0 && Instigator != None && (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled()))
    {
        ShieldBreakValue = MaxShields.Value * PartialBreakPct;
        if (OldShields >= ShieldBreakValue && CurrentShieldValue < ShieldBreakValue)
        {
            ActivatePSC(PS_CriticalHit, 1.0, vect(0.0, 0.0, 65.0));
        }
    }
}
public simulated function BeginRecharge()
{
    if (Instigator != None && Instigator.IsHumanControlled())
    {
        Instigator.PlaySound(PCShieldsUpSound, TRUE);
    }
}
public simulated function BreachShields(Class<SFXDamageType> DamageType)
{
    local BioPlayerController PC;
    local BioPawn PawnOwner;
    local SFXGRI GRI;
    
    Super.BreachShields(DamageType);
    if (Instigator != None && (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled()))
    {
        PC = BioPlayerController(Instigator.Controller);
        if (PC != None)
        {
            SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(BreachShake);
            PawnOwner = BioPawn(Instigator);
            if (PawnOwner != None)
            {
                Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_ShieldBreak, PawnOwner);
            }
            ActivatePSC(PS_CriticalHit, 1.0, vect(0.0, 0.0, 65.0));
            GRI = SFXGRI(WorldInfo.GRI);
            if (GRI != None && GRI.bAllowTimeDilation)
            {
                if (PawnOwner.bStorming == FALSE && PawnOwner.CurrentCustomAction != 56 && PawnOwner.CurrentCustomAction != 57 && PawnOwner.CurrentCustomAction != 54 && PawnOwner.CurrentCustomAction != 55)
                {
                    if (DamageType.default.bCriticalHit)
                    {
                        SFXGame(WorldInfo.Game).RequestTimeDilation(BreachTimeDilation, BreachTimeDilationLength);
                    }
                    else
                    {
                        SFXGame(WorldInfo.Game).RequestTimeDilation(TimeDilation, TimeDilationLength);
                    }
                }
            }
            Instigator.PlaySound(PCShieldsBreakSound, TRUE);
            Instigator.PlaySound(ShieldBreakPainVoc, TRUE);
        }
    }
}
public simulated function float GetShieldRegenDelay()
{
    local SFXDifficultyHandler DH;
    
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None)
    {
        if (CurrentShields > 0.0)
        {
            ShieldRegenDelay.X = DH.PartialShieldRegenDelay;
            ShieldRegenDelay.Y = DH.PartialShieldRegenDelay;
        }
        else
        {
            ShieldRegenDelay.X = DH.ShieldRegenDelay;
            ShieldRegenDelay.Y = DH.ShieldRegenDelay;
        }
    }
    Class'SFXGame'.static.ReCalculate(ShieldRegenDelay);
    return ShieldRegenDelay.Value;
}
public simulated function float GetShieldRegenRate()
{
    local SFXDifficultyHandler DH;
    
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None)
    {
        return DH.ShieldRegenPct;
    }
    return 0.0;
}
public simulated function PlayRecharge()
{
    local BioRemoteLogger GLogger;
    
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendMPEvent(7, 0.0, 0.0, 0.0, string(Instigator.Name), "", 0, 0);
    }
    Super.PlayRecharge();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TimeDilation = {
                    Points = ({InVal = 0.0, OutVal = 0.25, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                              {InVal = 0.150000006, OutVal = 0.649999976, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                              {InVal = 0.5, OutVal = 0.850000024, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                              {InVal = 1.0, OutVal = 1.10000002, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                             ), 
                    InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                   }
    BreachTimeDilation = {
                          Points = ({InVal = 0.0, OutVal = 0.25, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                    {InVal = 0.150000006, OutVal = 0.649999976, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                    {InVal = 0.5, OutVal = 0.850000024, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                    {InVal = 1.0, OutVal = 1.10000002, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                                   ), 
                          InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                         }
    BreachShake = {
                   RotAmplitude = {X = 300.0, Y = 50.0, Z = -300.0}, 
                   RotFrequency = {X = 12.5, Y = 5.0, Z = 5.0}, 
                   RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                   LocAmplitude = {X = 5.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 7.5, Y = 0.0, Z = 0.0}, 
                   LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                   ShakeName = 'None', 
                   TimeToGo = 0.0, 
                   TimeDuration = 0.75, 
                   RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                   LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                   FOVAmplitude = 0.0, 
                   FOVFrequency = 0.0, 
                   FOVSinOffset = 0.0, 
                   TargetingDampening = 0.0, 
                   bOverrideTargetingDampening = FALSE, 
                   FOVParam = EShakeParam.ESP_OffsetRandom
                  }
    PartialBreakPct = 0.550000012
    PS_CriticalHit = ParticleSystem'BioVFX_C_Impacts.Blood.Particles.Blood_Red_CriticalHit_Misty'
    CE_ShieldBreak = RvrClientEffect'BioVFX_C_Shield.VCFX.Shield_Dest_VCFX'
    TimeDilationLength = 1.5
    BreachTimeDilationLength = 2.5
    PCShieldsBreakSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_P_down'
    PCShieldsUpSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_powerup'
    ShieldBreakPainVoc = WwiseEvent'Wwise_VO_Exertions.Play_Exertion_Jumping_Heavy_Down'
    ShieldsBreakSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_NP_down'
    ShieldsUpSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_NP_up'
    PCShieldsUpStopSound = WwiseEvent'Wwise_Generic_Shield.Stop_gen_shield_powerup'
    TOTAL_SHIELD_STEPS = 15
    bRechargeable = TRUE
}