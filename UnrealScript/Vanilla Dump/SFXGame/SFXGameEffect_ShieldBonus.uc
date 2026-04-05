Class SFXGameEffect_ShieldBonus extends SFXGameEffect;

var float PercentShieldBonus;
var bool bEffectValueIsPercent;
var bool bRemoveEffectWhenShieldsDown;

public function OnRemoved()
{
    local BioPawn OwnerPawn;
    local SFXShield_Base Shields;
    local ScaledFloat MaxShields;
    
    Super.OnRemoved();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        Shields = OwnerPawn.GetShields();
        if (Shields != None)
        {
            MaxShields = Shields.GetMaxShieldStruct();
            MaxShields.Bonuses.RemoveItem(Self);
            Shields.SetMaxShields(MaxShields);
            Shields.ScaleShields();
            Shields.SetCurrentShields(FClamp(Shields.GetCurrentShields(), 0.0, Shields.GetMaxShields()));
        }
    }
}
public function OnUpdate(float DeltaSeconds)
{
    Super.OnUpdate(DeltaSeconds);
    if (bRemoveEffectWhenShieldsDown)
    {
        if (BioPawn(Owner) != None && BioPawn(Owner).HasAnyShieldResistance() == FALSE)
        {
            CurrentTime = Duration + 1.0;
            DurationType = EDurationType.DurationType_Temporary;
        }
    }
}
public function ComputeCustomEffectValue(out float Value)
{
    Value += PercentShieldBonus;
}
public function OnApplied()
{
    local BioPawn OwnerPawn;
    local SFXShield_Base Shields;
    local float fMaxBaseShields;
    local ScaledFloat MaxShields;
    
    Super.OnApplied();
    OwnerPawn = BioPawn(Owner);
    if (OwnerPawn != None)
    {
        Shields = OwnerPawn.GetShields();
        if (Shields != None)
        {
            MaxShields = Shields.GetMaxShieldStruct();
            fMaxBaseShields = Lerp(MaxShields.X, MaxShields.Y, float(MaxShields.Level / MaxShields.MaxLevel));
            if (fMaxBaseShields > float(0))
            {
                if (bEffectValueIsPercent)
                {
                    PercentShieldBonus = EffectValue;
                }
                else
                {
                    PercentShieldBonus = EffectValue / fMaxBaseShields;
                }
                MaxShields.Bonuses.AddItem(Self);
                Shields.SetMaxShields(MaxShields);
                Shields.ScaleShields();
                MaxShields = Shields.GetMaxShieldStruct();
                MaxShields.Value = float(int(MaxShields.Value + 0.5));
                Shields.SetMaxShields(MaxShields);
                if (bEffectValueIsPercent)
                {
                    Shields.SetCurrentShields(Shields.GetCurrentShields() + EffectValue * fMaxBaseShields);
                }
                else
                {
                    Shields.SetCurrentShields(Shields.GetCurrentShields() + EffectValue);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BonusFormula = EBonusFormula.BonusFormula_Custom
}