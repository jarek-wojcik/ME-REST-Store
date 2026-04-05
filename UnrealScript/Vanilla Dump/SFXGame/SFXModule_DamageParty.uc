Class SFXModule_DamageParty extends SFXModule_Damage
    editinlinenew
    config(Game);

enum EBleedoutState
{
    BleedOutState_None,
    BleedOutState_InBleedOut,
    BleedOutState_ShieldGate,
    BleedOutState_HealthGate,
};

var const config float HealthRegenDelay;
var transient float LastShieldGateTime;
var transient float LastHealthGateTime;
var config float MinShieldGateInterval;
var config float MinHealthGateInterval;
var(SFXModule_DamageParty) config float HealthGateThreshold;
var(SFXModule_DamageParty) transient EBleedoutState CurrentBleedoutState;

public simulated function RecoverFromBleedout(optional bool bResetHealth = TRUE)
{
    if (bResetHealth)
    {
        RegenFullHealth();
    }
}
public simulated function SFXTakeDamage(float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, Controller instigatedBy, optional Actor DamageCauser)
{
    Super.SFXTakeDamage(Damage, HitInfo, HitLocation, Momentum, DamageType, instigatedBy, DamageCauser);
    if (GetCurrentHealth() <= 0.0 && ModuleOwner.IsTimerActive('RegenFullHealth', Self))
    {
        ModuleOwner.ClearTimer('RegenFullHealth', Self);
    }
}
public simulated function ApplyDamageToHealth(float Damage, Controller instigatedBy, Class<SFXDamageType> DamageType, Vector HitLocation, out float AppliedDamage)
{
    local float OldHealthRatio;
    local float NewHealthRatio;
    local SFXDifficultyHandler DH;
    
    ResetRegenTimer();
    if (DamageType.default.bIgnoreDamageGating == FALSE && (CurrentBleedoutState == EBleedoutState.BleedOutState_ShieldGate || CurrentBleedoutState == EBleedoutState.BleedOutState_HealthGate))
    {
        Damage = 0.0;
        Super.ApplyDamageToHealth(Damage, instigatedBy, DamageType, HitLocation, AppliedDamage);
        return;
    }
    OldHealthRatio = GetHealthRatio();
    Super.ApplyDamageToHealth(Damage, instigatedBy, DamageType, HitLocation, AppliedDamage);
    NewHealthRatio = GetHealthRatio();
    if (OldHealthRatio > HealthGateThreshold && NewHealthRatio <= HealthGateThreshold && ModuleOwner.WorldInfo.GameTimeSeconds - LastHealthGateTime >= MinHealthGateInterval)
    {
        if (DamageType.default.bIgnoreDamageGating == FALSE)
        {
            SetCurrentHealth(HealthGateThreshold * MaxHealth.Value);
        }
        CurrentBleedoutState = EBleedoutState.BleedOutState_HealthGate;
        LastHealthGateTime = ModuleOwner.WorldInfo.GameTimeSeconds;
        if (ModuleOwner != None && ModuleOwner.WorldInfo != None && ModuleOwner.WorldInfo.GRI != None)
        {
            DH = SFXGRI(ModuleOwner.WorldInfo.GRI).DifficultyHandler;
            if (DH != None && DH.PlayerPartyHealthGateDuration > float(0))
            {
                ModuleOwner.SetTimer(DH.PlayerPartyHealthGateDuration, FALSE, 'TurnOffHealthGate', Self);
                return;
            }
        }
        TurnOffHealthGate();
    }
}
public simulated function bool KillForStasis(bool bImmediate, optional Controller Killer, optional Class<DamageType> DamageType);

public simulated function OnShieldBreached()
{
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_None)
    {
        CurrentBleedoutState = EBleedoutState.BleedOutState_InBleedOut;
        if (ModuleOwner.WorldInfo.GameTimeSeconds - LastShieldGateTime >= MinShieldGateInterval)
        {
            StartBleedOut();
            LastShieldGateTime = ModuleOwner.WorldInfo.GameTimeSeconds;
        }
    }
}
public simulated function RegenFullHealth()
{
    SetCurrentHealth(GetMaxHealth());
    if (CurrentBleedoutState != EBleedoutState.BleedOutState_None)
    {
        CurrentBleedoutState = EBleedoutState.BleedOutState_None;
    }
}
public simulated function ResetRegenTimer()
{
    ModuleOwner.SetTimer(HealthRegenDelay, FALSE, 'RegenFullHealth', Self);
}
public simulated function StartBleedOut()
{
    local SFXDifficultyHandler DH;
    
    CurrentBleedoutState = EBleedoutState.BleedOutState_ShieldGate;
    if (ModuleOwner != None && ModuleOwner.WorldInfo != None && ModuleOwner.WorldInfo.GRI != None)
    {
        DH = SFXGRI(ModuleOwner.WorldInfo.GRI).DifficultyHandler;
        if (DH != None && DH.PlayerPartyShieldGateDuration > float(0))
        {
            ModuleOwner.SetTimer(DH.PlayerPartyShieldGateDuration, FALSE, 'TurnOffShieldGate', Self);
            return;
        }
    }
    TurnOffShieldGate();
}
public final simulated function TurnOffHealthGate()
{
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_HealthGate)
    {
        CurrentBleedoutState = EBleedoutState.BleedOutState_InBleedOut;
    }
}
public final simulated function TurnOffShieldGate()
{
    if (CurrentBleedoutState == EBleedoutState.BleedOutState_ShieldGate)
    {
        CurrentBleedoutState = EBleedoutState.BleedOutState_InBleedOut;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HealthRegenDelay = 3.0
    MinShieldGateInterval = 4.0
    MinHealthGateInterval = 3.0
    bPartBasedDamageEnabled = FALSE
}