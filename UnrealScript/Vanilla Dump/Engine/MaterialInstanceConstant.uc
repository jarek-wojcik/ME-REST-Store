Class MaterialInstanceConstant extends MaterialInstance
    native;

struct native VectorParameterValue 
{
    var(VectorParameterValue) LinearColor ParameterValue;
    var Guid ExpressionGUID;
    var(VectorParameterValue) Name ParameterName;
};
struct native TextureParameterValue 
{
    var Guid ExpressionGUID;
    var(TextureParameterValue) Name ParameterName;
    var(TextureParameterValue) Texture ParameterValue;
};
struct native ScalarParameterValue 
{
    var Guid ExpressionGUID;
    var(ScalarParameterValue) Name ParameterName;
    var(ScalarParameterValue) float ParameterValue;
};
struct native FontParameterValue 
{
    var Guid ExpressionGUID;
    var(FontParameterValue) Name ParameterName;
    var(FontParameterValue) Font FontValue;
    var(FontParameterValue) int FontPage;
};

var(ParameterValues) const array<FontParameterValue> FontParameterValues;
var(ParameterValues) const array<VectorParameterValue> VectorParameterValues;
var(ParameterValues) const array<ScalarParameterValue> ScalarParameterValues;
var(ParameterValues) const array<TextureParameterValue> TextureParameterValues;

public native function ClearParameterValues();

public native function SetFontParameterValue(Name ParameterName, Font FontValue, int FontPage);

public native function SetParent(MaterialInterface NewParent);

public native function SetScalarParameterValue(Name ParameterName, float Value);

public native function SetTextureParameterValue(Name ParameterName, Texture Value);

public native function SetVectorParameterValue(Name ParameterName, const out LinearColor Value);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}