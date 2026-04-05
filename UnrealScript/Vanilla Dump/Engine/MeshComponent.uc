Class MeshComponent extends PrimitiveComponent
    native
    noexport
    abstract;

var(Rendering) const array<MaterialInterface> Materials;
var transient array<MaterialInstanceConstant> m_aEffectsMaterialMICs;
var const transient array<Texture> CachedTextures;
var transient float CachedTexturesTimer;

public native function ClearEffectsMaterial();

public native function MaterialInterface GetBaseMaterial(int ElementIndex);

public native function Name GetEffectsMaterial();

public native function float GetFractionOfEffectEnabled();

public native function MaterialInterface GetMaterial(int ElementIndex);

public native function int GetNumElements();

public native function GetUnscaledBounds(out BoxSphereBounds UnscaledBounds);

public final native function PrestreamTextures(float Seconds, bool bPrioritizeCharacterTextures, optional int CinematicTextureGroups = 0);

public native function SetEffectsMaterial(Name nmEffect);

public native function SetFractionOfEffectEnabled(float fFraction);

public native function SetMaterial(int ElementIndex, MaterialInterface Material);

public function MaterialInstanceConstant CreateAndSetMaterialInstanceConstant(int ElementIndex)
{
    local MaterialInstanceConstant Instance;
    
    Instance = new (Self) Class'MaterialInstanceConstant';
    Instance.SetParent(GetMaterial(ElementIndex));
    SetMaterial(ElementIndex, Instance);
    return Instance;
}
public function MaterialInstanceTimeVarying CreateAndSetMaterialInstanceTimeVarying(int ElementIndex)
{
    local MaterialInstanceTimeVarying Instance;
    
    Instance = new (Self) Class'MaterialInstanceTimeVarying';
    Instance.SetParent(GetMaterial(ElementIndex));
    SetMaterial(ElementIndex, Instance);
    return Instance;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
    bUseAsOccluder = TRUE
    CastShadow = TRUE
    bAcceptsLights = TRUE
    bCullModulatedShadowOnBackfaces = TRUE
    bCullModulatedShadowOnEmissive = TRUE
}