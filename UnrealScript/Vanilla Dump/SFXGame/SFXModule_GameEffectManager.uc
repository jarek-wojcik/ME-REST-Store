Class SFXModule_GameEffectManager extends SFXModule_GameEffectManager_NativeBase
    editinlinenew;

var transient ScaledFloat WeaponPassiveDamageBonus;
var transient ScaledFloat HeavyWeaponPassiveDamageBonus;
var transient ScaledFloat WeaponPassiveConstraintDamageBonus;
var transient ScaledFloat GlobalCooldownBonus;
var transient ScaledFloat PhysicsDamageTakenBonus;
var transient ScaledFloat NegotiationBonus;
var transient ScaledFloat WeaponModDamageBonus;
var transient ScaledFloat WeaponMatchConsumableDamageBonus;
var transient float RecoilBonus;

public event simulated function HandlePostBeginPlay()
{
    Super(SFXModule).HandlePostBeginPlay();
    Class'SFXGame'.static.ReCalculate(WeaponPassiveDamageBonus);
    Class'SFXGame'.static.ReCalculate(HeavyWeaponPassiveDamageBonus);
    Class'SFXGame'.static.ReCalculate(WeaponPassiveConstraintDamageBonus);
    Class'SFXGame'.static.ReCalculate(GlobalCooldownBonus);
    Class'SFXGame'.static.ReCalculate(PhysicsDamageTakenBonus);
    Class'SFXGame'.static.ReCalculate(NegotiationBonus);
    Class'SFXGame'.static.ReCalculate(WeaponModDamageBonus);
    Class'SFXGame'.static.ReCalculate(WeaponMatchConsumableDamageBonus);
}
public event simulated function RemoveAllEffects()
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        Effect.OnRemoved();
        GameEffects.Remove(idx, 1);
    }
}
public final simulated function SFXGameEffect CreateAndApplyEffect(Class<SFXGameEffect> EffectClass, Name Category, float Duration, EDurationType DurationType, float EffectValue, optional Controller Instigator, optional Actor Causer)
{
    local SFXGameEffect Effect;
    
    Effect = CreateEffect(EffectClass, Category, Duration, DurationType, EffectValue, Instigator, Causer);
    if (Effect != None)
    {
        Effect.OnApplied();
    }
    return Effect;
}
public final simulated function SFXGameEffect CreateEffect(Class<SFXGameEffect> EffectClass, Name Category, float Duration, EDurationType DurationType, float EffectValue, optional Controller Instigator, optional Actor Causer)
{
    local SFXGameEffect Effect;
    
    Effect = new (Self) EffectClass;
    Effect.Duration = Duration;
    Effect.DurationType = DurationType;
    Effect.EffectValue = EffectValue;
    Effect.Category = Category;
    Effect.Owner = Actor(Outer);
    Effect.Causer = Causer;
    if (Instigator == None && Pawn(Outer) != None)
    {
        Instigator = Pawn(Outer).Controller;
    }
    Effect.Instigator = Instigator;
    GameEffects.AddItem(Effect);
    return Effect;
}
public simulated function SFXGameEffect GetFirstEffectOfCategory(Name Category)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Category == Category)
        {
            return Effect;
        }
    }
    return None;
}
public simulated function SFXGameEffect GetFirstEffectOfType(Class<SFXGameEffect> EffectClass)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Class == EffectClass)
        {
            return Effect;
        }
    }
    return None;
}
public simulated function SFXGameEffect GetFirstEffectOfTypeAndCategory(Class<SFXGameEffect> EffectClass, Name Category)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Class == EffectClass && Effect.Category == Category)
        {
            return Effect;
        }
    }
    return None;
}
public final simulated function bool HasEffectOfCategory(Name Category)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Category == Category)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function bool HasEffectOfType(Class<SFXGameEffect> EffectClass)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Class == EffectClass)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function bool HasEffectOfTypeAndCategory(Class<SFXGameEffect> EffectClass, Name Category)
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        if (Effect.Class == EffectClass && Effect.Category == Category)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function OnCombatEnd()
{
    local SFXGameEffect Effect;
    
    foreach GameEffects(Effect, )
    {
        Effect.OnCombatEnd();
    }
}
public final simulated function PauseEffectsByType(Class<SFXGameEffect> EffectClass)
{
    local int idx;
    local SFXGameEffect Effect;
    
    for (idx = 0; idx < GameEffects.Length; idx++)
    {
        Effect = GameEffects[idx];
        if (Effect.Class == EffectClass)
        {
            Effect.OnPaused();
        }
    }
}
public final simulated function RemoveEffect(SFXGameEffect Effect)
{
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    if (Effect == None)
    {
        return;
    }
    Effect.OnRemoved();
    GameEffects.RemoveItem(Effect);
}
public final simulated function RemoveEffectAt(int Index)
{
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    if (Index < 0 || Index >= GameEffects.Length)
    {
        return;
    }
    if (GameEffects[Index] != None)
    {
        GameEffects[Index].OnRemoved();
    }
    GameEffects.Remove(Index, 1);
}
public final simulated function RemoveEffectsByCategory(Name Category)
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (Effect.Category == Category)
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
}
public final simulated function RemoveEffectsByDuration(EDurationType Duration)
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (int(Effect.DurationType) == int(Duration))
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
}
public final function RemoveEffectsByParentType(Class<SFXGameEffect> ParentClass)
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (ClassIsChildOf(Effect.Class, ParentClass))
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
}
public final simulated function RemoveEffectsByType(Class<SFXGameEffect> EffectClass)
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (Effect.Class == EffectClass)
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
}
public final simulated function RemoveEffectsByTypeAndCategory(Class<SFXGameEffect> EffectClass, Name Category)
{
    local int idx;
    local SFXGameEffect Effect;
    
    if (EffectListLocked)
    {
        ScriptTrace();
        return;
    }
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (Effect.Class == EffectClass && Effect.Category == Category)
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
}
public final simulated function UnpauseEffectsByType(Class<SFXGameEffect> EffectClass)
{
    local int idx;
    local SFXGameEffect Effect;
    
    for (idx = 0; idx < GameEffects.Length; idx++)
    {
        Effect = GameEffects[idx];
        if (Effect.Class == EffectClass)
        {
            Effect.OnUnpaused();
        }
    }
}
public final simulated function UpdateEffectsByCategory(const out array<Class<SFXGameEffect>> EffectClasses, Name Category, Controller Instigator)
{
    local int idx;
    local SFXGameEffect Effect;
    local Class<SFXGameEffect> EffectClass;
    
    for (idx = GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = GameEffects[idx];
        if (Effect.Category == Category)
        {
            Effect.OnRemoved();
            GameEffects.Remove(idx, 1);
        }
    }
    foreach EffectClasses(EffectClass, )
    {
        Effect = CreateEffect(EffectClass, Category, EffectClass.default.Duration, EffectClass.default.DurationType, EffectClass.default.EffectValue, Instigator);
        Effect.OnApplied();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponPassiveDamageBonus = {
                                Bonuses = (), 
                                X = 1.0, 
                                Y = 1.0, 
                                MaxLevel = 100, 
                                Level = 0, 
                                Value = 0.0, 
                                StaticBonus = 1.0
                               }
    HeavyWeaponPassiveDamageBonus = {
                                     Bonuses = (), 
                                     X = 1.0, 
                                     Y = 1.0, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    WeaponPassiveConstraintDamageBonus = {
                                          Bonuses = (), 
                                          X = 1.0, 
                                          Y = 1.0, 
                                          MaxLevel = 100, 
                                          Level = 0, 
                                          Value = 0.0, 
                                          StaticBonus = 1.0
                                         }
    GlobalCooldownBonus = {
                           Bonuses = (), 
                           X = 1.0, 
                           Y = 1.0, 
                           MaxLevel = 100, 
                           Level = 0, 
                           Value = 0.0, 
                           StaticBonus = 1.0
                          }
    PhysicsDamageTakenBonus = {
                               Bonuses = (), 
                               X = 1.0, 
                               Y = 1.0, 
                               MaxLevel = 100, 
                               Level = 0, 
                               Value = 0.0, 
                               StaticBonus = 1.0
                              }
    NegotiationBonus = {
                        Bonuses = (), 
                        X = 1.0, 
                        Y = 1.0, 
                        MaxLevel = 100, 
                        Level = 0, 
                        Value = 0.0, 
                        StaticBonus = 1.0
                       }
    WeaponModDamageBonus = {
                            Bonuses = (), 
                            X = 1.0, 
                            Y = 1.0, 
                            MaxLevel = 100, 
                            Level = 0, 
                            Value = 0.0, 
                            StaticBonus = 1.0
                           }
    WeaponMatchConsumableDamageBonus = {
                                        Bonuses = (), 
                                        X = 1.0, 
                                        Y = 1.0, 
                                        MaxLevel = 100, 
                                        Level = 0, 
                                        Value = 0.0, 
                                        StaticBonus = 1.0
                                       }
    RecoilBonus = 1.0
}