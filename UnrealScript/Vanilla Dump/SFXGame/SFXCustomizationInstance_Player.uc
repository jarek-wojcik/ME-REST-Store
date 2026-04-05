Class SFXCustomizationInstance_Player extends SFXCustomizationInstance;

var(SFXCustomizationInstance_Player) int CasualID;
var(SFXCustomizationInstance_Player) int FullBodyID;
var(SFXCustomizationInstance_Player) int TorsoID;
var(SFXCustomizationInstance_Player) int ShoulderID;
var(SFXCustomizationInstance_Player) int ArmID;
var(SFXCustomizationInstance_Player) int LegID;
var(SFXCustomizationInstance_Player) int SpecID;
var(SFXCustomizationInstance_Player) int Tint1ID;
var(SFXCustomizationInstance_Player) int Tint2ID;
var(SFXCustomizationInstance_Player) int PatternID;
var(SFXCustomizationInstance_Player) int PatternColorID;
var(SFXCustomizationInstance_Player) int HelmetID;
var(SFXCustomizationInstance_Player) int EmissiveID;
var(SFXCustomizationInstance_Player) bool bUseCasualAppearance;
var(SFXCustomizationInstance_Player) EPlayerAppearanceType CombatAppearance;

public function CustomizeMaterialInstance(MaterialInstanceConstant MIC)
{
    local ScalarParameterValue SParam;
    local VectorParameterValue VParam;
    local LinearColor BaseColor;
    
    if (!bUseCasualAppearance && CombatAppearance != EPlayerAppearanceType.PlayerAppearanceType_Full)
    {
        if (SpecID >= 0 && SpecID < Class'SFXPlayerCustomization'.default.SpecAppearances.Length)
        {
            SParam = Class'SFXPlayerCustomization'.default.SpecAppearances[SpecID].Spec.SpecParam;
            MIC.SetScalarParameterValue(SParam.ParameterName, SParam.ParameterValue);
            SParam = Class'SFXPlayerCustomization'.default.SpecAppearances[SpecID].Spec.SpecPwrParam;
            MIC.SetScalarParameterValue(SParam.ParameterName, SParam.ParameterValue);
            SParam = Class'SFXPlayerCustomization'.default.SpecAppearances[SpecID].Spec.EnvMapParam;
            MIC.SetScalarParameterValue(SParam.ParameterName, SParam.ParameterValue);
        }
        if (Tint1ID >= 0 && Tint1ID < Class'SFXPlayerCustomization'.default.Tint1Appearances.Length)
        {
            VParam = Class'SFXPlayerCustomization'.default.Tint1Appearances[Tint1ID].Tint.TintParam;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            VParam = Class'SFXPlayerCustomization'.default.Tint1Appearances[Tint1ID].Tint.PhongParam;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
        }
        if (Tint2ID >= 0 && Tint2ID < Class'SFXPlayerCustomization'.default.Tint2Appearances.Length)
        {
            VParam = Class'SFXPlayerCustomization'.default.Tint2Appearances[Tint2ID].Tint.TintParam;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
        }
        if (PatternID >= 0 && PatternID < Class'SFXPlayerCustomization'.default.PatternAppearances.Length)
        {
            VParam = Class'SFXPlayerCustomization'.default.PatternAppearances[PatternID].Pattern.Stripe1Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            VParam = Class'SFXPlayerCustomization'.default.PatternAppearances[PatternID].Pattern.Stripe2Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            VParam = Class'SFXPlayerCustomization'.default.PatternAppearances[PatternID].Pattern.Stripe3Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
        }
        if (PatternColorID >= 0 && PatternColorID < Class'SFXPlayerCustomization'.default.PatternColorAppearances.Length)
        {
            VParam = Class'SFXPlayerCustomization'.default.PatternColorAppearances[PatternColorID].Pattern.Stripe1Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            VParam = Class'SFXPlayerCustomization'.default.PatternColorAppearances[PatternColorID].Pattern.Stripe2Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            VParam = Class'SFXPlayerCustomization'.default.PatternColorAppearances[PatternColorID].Pattern.Stripe3Param;
            MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
        }
        if (EmissiveID >= 0 && EmissiveID < Class'SFXPlayerCustomization'.default.EmissiveAppearances.Length)
        {
            VParam = Class'SFXPlayerCustomization'.default.EmissiveAppearances[EmissiveID].Tint.TintParam;
            if (MIC.GetVectorParameterValue(VParam.ParameterName, BaseColor) && BaseColor != MakeLinearColor(0.0, 0.0, 0.0, 1.0))
            {
                MIC.SetVectorParameterValue(VParam.ParameterName, VParam.ParameterValue);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}