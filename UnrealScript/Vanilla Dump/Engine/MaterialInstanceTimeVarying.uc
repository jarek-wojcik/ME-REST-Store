Class MaterialInstanceTimeVarying extends MaterialInstance
    native;

struct native VectorParameterValueOverTime extends ParameterValueOverTime 
{
    var(VectorParameterValueOverTime) InterpCurveVector ParameterValueCurve;
    var(VectorParameterValueOverTime) LinearColor ParameterValue;
    
    structdefaultproperties
    {
        ParameterValue = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
        StartTime = 0.0
        CycleTime = 0.0
    }
};
struct native TextureParameterValueOverTime extends ParameterValueOverTime 
{
    var(TextureParameterValueOverTime) Texture ParameterValue;
    
    structdefaultproperties
    {
        StartTime = 0.0
        CycleTime = 0.0
    }
};
struct native ScalarParameterValueOverTime extends ParameterValueOverTime 
{
    var(ScalarParameterValueOverTime) InterpCurveFloat ParameterValueCurve;
    var(ScalarParameterValueOverTime) float ParameterValue;
    
    structdefaultproperties
    {
        StartTime = 0.0
        CycleTime = 0.0
    }
};
struct native FontParameterValueOverTime extends ParameterValueOverTime 
{
    var(FontParameterValueOverTime) Font FontValue;
    var(FontParameterValueOverTime) int FontPage;
    
    structdefaultproperties
    {
        StartTime = 0.0
        CycleTime = 0.0
    }
};
struct native ParameterValueOverTime 
{
    var Guid ExpressionGUID;
    var(ParameterValueOverTime) Name ParameterName;
    var transient float StartTime;
    var(ParameterValueOverTime) float CycleTime;
    var(ParameterValueOverTime) float OffsetTime;
    var(ParameterValueOverTime) bool bLoop;
    var(ParameterValueOverTime) bool bAutoActivate;
    var(ParameterValueOverTime) bool bNormalizeTime;
    var(ParameterValueOverTime) bool bOffsetFromEnd;
    
    structdefaultproperties
    {
        StartTime = -1.0
        CycleTime = 1.0
    }
};

var(MaterialInstanceTimeVarying) const array<FontParameterValueOverTime> FontParameterValues;
var(MaterialInstanceTimeVarying) const array<ScalarParameterValueOverTime> ScalarParameterValues;
var(MaterialInstanceTimeVarying) const array<TextureParameterValueOverTime> TextureParameterValues;
var(MaterialInstanceTimeVarying) const array<VectorParameterValueOverTime> VectorParameterValues;
var transient float Duration;
var(MaterialInstanceTimeVarying) bool bAutoActivateAll;

public native function ClearParameterValues();

public native function float GetMaxDurationFromAllParameters();

public native function SetDuration(float Value);

public native function SetFontParameterValue(Name ParameterName, Font FontValue, int FontPage);

public native function SetParent(MaterialInterface NewParent);

public native function SetScalarCurveParameterValue(Name ParameterName, const out InterpCurveFloat Value);

public native function SetScalarParameterValue(Name ParameterName, float Value);

public native function SetScalarStartTime(Name ParameterName, float Value);

public native function SetTextureParameterValue(Name ParameterName, Texture Value);

public native function SetVectorCurveParameterValue(Name ParameterName, const out InterpCurveVector Value);

public native function SetVectorParameterValue(Name ParameterName, const out LinearColor Value);

public native function SetVectorStartTime(Name ParameterName, float Value);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}