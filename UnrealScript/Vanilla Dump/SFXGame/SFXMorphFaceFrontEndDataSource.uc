Class SFXMorphFaceFrontEndDataSource
    native
    editinlinenew
    config(UI);

var Slider ModifierData;
var AdditionalData AdditionalParams;
var array<Category> MorphCategories;
var array<Texture2D> Textures;
var array<BaseHeads> m_aDefaultSettings;
var array<BaseHeads> m_aBaseHeads;
var native Object NameHeadIndexMap;
var BioMorphFace MorphFace;
var AnimTree MorphAnimTree;
var MorphTargetSet MorphTargetSet;
var(SFXMorphFaceFrontEndDataSource) bool PlayerIsMale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}