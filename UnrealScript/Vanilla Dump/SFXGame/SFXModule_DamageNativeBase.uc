Class SFXModule_DamageNativeBase extends SFXModule_DamageBase
    native
    abstract
    config(Game);

const HEALTH_CHANGE_RTPC_AMOUNT = 0.15f;

var(SFXModule_DamageNativeBase) protectedwrite repnotify ScaledFloat MaxHealth;
var(SFXModule_DamageNativeBase) privatewrite float CurrentHealth;
var(SFXModule_DamageNativeBase) transient float NormalizedHealth;
var(SFXModule_DamageNativeBase) transient float LevelScaledHealth;
var config int TOTAL_HEALTH_STEPS;
var transient float LastHealthPct;
var transient repnotify byte ReplicatedHealth;

public final native function float GetCurrentHealth();

public final native function float GetHealthRatio();

public final native function float GetMaxHealth();

public event simulated function HandlePostBeginPlay()
{
    Super(SFXModule).HandlePostBeginPlay();
    ReplicatedHealth = byte(TOTAL_HEALTH_STEPS);
}
public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedHealth':
        case 'MaxHealth':
            CurrentHealth = float(ReplicatedHealth) / float(TOTAL_HEALTH_STEPS) * GetMaxHealth();
            break;
        default:
            Super(SFXModule).ReplicatedEvent(VarName);
            break;
    }
}
public final simulated function ScaledFloat GetMaxHealthStats()
{
    return MaxHealth;
}
public final function InitializeMaxHealth(float Value)
{
    MaxHealth.X = Value;
    MaxHealth.Y = Value;
    MaxHealth.Value = Value;
    SetCurrentHealth(MaxHealth.Value);
}
public function ReplicateCurrentHealth()
{
    local float NewHealth;
    
    NewHealth = float(Max(int(CurrentHealth), 0));
    ReplicatedHealth = byte(FCeil(NewHealth / GetMaxHealth() * float(TOTAL_HEALTH_STEPS)));
}
public function SetCurrentHealth(float NewHealth, optional bool bRecomputeHealthSegment)
{
    if (ModuleOwner.Role == ENetRole.ROLE_Authority)
    {
        NewHealth = FClamp(NewHealth, 0.0, MaxHealth.Value);
        CurrentHealth = NewHealth;
        ReplicateCurrentHealth();
    }
}
public final simulated function SetMaxHealth(ScaledFloat NewMaxHealth)
{
    MaxHealth = NewMaxHealth;
}

replication
{
    if (bNetDirty && int(GetActorRole()) == 3)
        MaxHealth, ReplicatedHealth;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxHealth = {
                 Bonuses = (), 
                 X = 0.0, 
                 Y = 0.0, 
                 MaxLevel = 100, 
                 Level = 0, 
                 Value = 0.0, 
                 StaticBonus = 1.0
                }
    TOTAL_HEALTH_STEPS = 10
}