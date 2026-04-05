Class MaterialInstance extends MaterialInterface
    native
    abstract;

var const native duplicatetransient Pointer StaticParameters[2];
var const native duplicatetransient Pointer StaticPermutationResources[2];
var const native duplicatetransient Pointer Resources[2];
var const Guid ParentLightingGuid;
var(MaterialInstance) PhysicalMaterial PhysMaterial;
var(MaterialInstance) const MaterialInterface Parent;
var bool bHasStaticPermutationResource;
var transient native bool bStaticPermutationDirty;
var const native bool ReentrantFlag;

public native function ClearParameterValues();

public native function bool IsInMapOrTransientPackage();

public native function SetEffectsMaterialFractionValue(float Value);

public native function SetEffectsMaterialNameValue(Name EffectName);

public native function SetFontParameterValue(Name ParameterName, Font FontValue, int FontPage);

public native function SetParent(MaterialInterface NewParent);

public native function SetScalarCurveParameterValue(Name ParameterName, const out InterpCurveFloat Value);

public native function SetScalarParameterValue(Name ParameterName, float Value);

public native function SetTextureParameterValue(Name ParameterName, Texture Value);

public native function SetVectorParameterValue(Name ParameterName, const out LinearColor Value);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}