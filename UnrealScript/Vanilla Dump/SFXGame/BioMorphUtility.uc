Class BioMorphUtility
    native;

struct native AdditionalData 
{
    var HairData Hair;
};
struct native MaterialData 
{
    var array<MaterialPanel> Panels;
};
struct native MaterialPanel 
{
    var string Name;
    var array<MaterialGroup> Groups;
};
struct native MaterialGroup 
{
    var string Name;
    var array<MaterialComponent> Components;
};
struct native MaterialComponent 
{
    var string Label;
    var string Name;
    var string Panel;
    var string ParameterName;
    var array<string> Params;
    var EBioMorphUtilityComponentType Type;
};
struct native HairData 
{
    var string PackageName;
    var string HairMorphSpecMaskName;
    var array<HairComponent> HairComponents;
};
struct native HairComponent 
{
    var string StyleName;
    var string MeshName;
    var string ScalpMorphName;
    var array<TextureData> m_aHairTextures;
    var array<ScalarData> m_aHairScalars;
    var SkeletalMesh HairMesh;
    var float ScalpMorphWeight;
    var EBioMorphUtilityHairComponentType HairType;
};
struct native ScalarData 
{
    var Name m_nParamName;
    var float m_fScalarValue;
};
struct native TextureData 
{
    var Name m_nParamName;
    var Texture m_oTexture;
};
enum EBioMorphUtilityHairComponentType
{
    BMU_HairComponent_Hair,
    BMU_HairComponent_Other,
};
enum EBioMorphUtilityComponentType
{
    BMU_Component_Unknown,
    BMU_Component_Picker,
    BMU_Component_Slider,
    BMU_Component_Combo,
    BMU_Component_RGBA,
    BMU_Component_Compound,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}