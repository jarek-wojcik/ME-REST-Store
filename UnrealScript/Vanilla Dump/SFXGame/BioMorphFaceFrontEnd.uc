Class BioMorphFaceFrontEnd extends BioMorphUtility
    native
    config(UI);

struct native SliderRemapping 
{
    var string CategoryName;
    var string SliderName;
    var array<int> Remappings;
};
struct native BaseHeads 
{
    var array<BaseSliders> m_fBaseHeadSettings;
};
struct native BaseSliders 
{
    var string m_sSliderName;
    var float m_fValue;
};
struct native FaceData 
{
    var AdditionalData m_pAdditionalParams;
    var array<Category> m_oCategories;
};
struct native Category 
{
    var string m_sCatName;
    var array<Slider> m_aoSliders;
    var int m_iCatIndex;
    var int m_iStringRef;
    var int m_iDescriptionStringRef;
};
struct native Slider 
{
    var string m_sName;
    var array<BioMorphFaceFESliderBase> m_aoSliderData;
    var array<float> m_fRandWeights;
    var array<SliderModifier> m_aSliderModifiers;
    var int m_iIndex;
    var int m_iValue;
    var int m_iSteps;
    var int m_iStringRef;
    var int m_iDescriptionStringRef;
    var float m_fRandWeightsTotal;
    var float m_fRandMin;
    var float m_fRandMax;
    var bool m_bNotched;
};
struct native SliderModifier 
{
    var string m_sName;
    var array<float> m_aRandMin;
    var array<float> m_aRandMax;
    var array<SliderModifierSliderData> m_aSliders;
};
struct native SliderModifierSliderData 
{
    var array<BioMorphFaceFESliderBase> m_aoSliderData;
    var array<float> m_fRandWeights;
    var float m_fRandWeightsTotal;
};
enum EBioMorphFrontendSliderType
{
    BMFE_SLIDER_MORPH_SINGLE,
    BMFE_SLIDER_MORPH_DOUBLE,
    BMFE_SLIDER_MATERIAL,
};

var Slider m_pModifierData;
var native Map_Mirror CachedFaceCodeRemappings;
var FaceData m_oFaceData;
var string m_sPlayerName;
var BaseHeads m_oBaseSettings;
var array<BaseHeads> m_aBaseHeads;
var config array<SliderRemapping> MaleRemappings;
var config array<SliderRemapping> FemaleRemappings;
var BioMorphFace WorkingMorphFace;
var int m_iCurrentBaseHead;
var config bool m_bDebugStrings;
var bool bIsMale;

public native function ApplyFaceCode(string sFaceCode);

public native function CalibrateToPawn(BioPawn pSrcPawn, optional bool bUpdate = TRUE);

public native function Cleanup();

public native function string GenerateFaceCode();

public native function int GetCategoryDescription(int categoryIndex);

public native function int GetCategoryString(int categoryIndex);

public native function int GetNumberOfFeatureCategories();

public native function int GetNumSlidersInCategory(int categoryIndex);

public native function int GetSliderDesc(int categoryIndex, int sliderIndex);

public native function int GetSliderLabel(int categoryIndex, int sliderIndex);

public native function int GetSliderMax(int categoryIndex, int sliderIndex);

public native function int GetSliderMin(int categoryIndex, int sliderIndex);

public native function bool GetSliderNotched(int categoryIndex, int sliderIndex);

public native function int GetSliderStep(int categoryIndex, int sliderIndex);

public native function int GetSliderValue(int categoryIndex, int sliderIndex);

public native function HandleSliderChange(int categoryIndex, int sliderIndex, int sliderValue, optional bool bUpdate = TRUE);

public native function BioMorphFace Initialize(SFXMorphFaceFrontEndDataSource Data, optional bool bReset = TRUE);

public native function RandomizeAll();

public native function RandomizeCategory(int nCategory, optional bool bUpdate = TRUE);

public native function ResetAll();

public native function ResetCategory(int nCategory, optional bool bUpdate = TRUE);

public native function SelectNextBaseHead();

public native function SelectPreviousBaseHead();

public native function SetPlayerName(string sPlayerName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaleRemappings = ({
                       CategoryName = "Hair", 
                       SliderName = "Hair", 
                       Remappings = (9, 
                                     1, 
                                     2, 
                                     7, 
                                     10, 
                                     3, 
                                     5, 
                                     8, 
                                     0, 
                                     4, 
                                     6
                                    )
                      }, 
                      {
                       CategoryName = "Hair", 
                       SliderName = "FacialHair_Colour", 
                       Remappings = (0, 
                                     1, 
                                     2, 
                                     10, 
                                     3, 
                                     4, 
                                     5, 
                                     6, 
                                     7, 
                                     8, 
                                     9, 
                                     11
                                    )
                      }, 
                      {
                       CategoryName = "Hair", 
                       SliderName = "Hair_Colour", 
                       Remappings = (0, 
                                     2, 
                                     3, 
                                     2, 
                                     3, 
                                     4, 
                                     4, 
                                     1, 
                                     5, 
                                     6, 
                                     7, 
                                     8, 
                                     9, 
                                     10, 
                                     11
                                    )
                      }, 
                      {
                       CategoryName = "Eyes", 
                       SliderName = "Iris_Colour", 
                       Remappings = (0, 
                                     1, 
                                     2, 
                                     3, 
                                     4, 
                                     5, 
                                     6, 
                                     6, 
                                     8, 
                                     9, 
                                     10, 
                                     11, 
                                     12, 
                                     7, 
                                     13, 
                                     14, 
                                     15
                                    )
                      }
                     )
    FemaleRemappings = ({
                         CategoryName = "Hair", 
                         SliderName = "BrowColour", 
                         Remappings = (2, 
                                       1, 
                                       11, 
                                       12, 
                                       3, 
                                       4, 
                                       5, 
                                       0, 
                                       6, 
                                       7, 
                                       8, 
                                       9, 
                                       10, 
                                       13, 
                                       14, 
                                       15
                                      )
                        }, 
                        {
                         CategoryName = "Hair", 
                         SliderName = "Hair_Colour", 
                         Remappings = (1, 
                                       3, 
                                       10, 
                                       2, 
                                       4, 
                                       4, 
                                       5, 
                                       0, 
                                       6, 
                                       7, 
                                       8, 
                                       9, 
                                       11, 
                                       12, 
                                       13, 
                                       14, 
                                       15
                                      )
                        }, 
                        {
                         CategoryName = "Eyes", 
                         SliderName = "Iris_Colour", 
                         Remappings = (0, 
                                       1, 
                                       2, 
                                       3, 
                                       4, 
                                       5, 
                                       6, 
                                       6, 
                                       8, 
                                       9, 
                                       10, 
                                       11, 
                                       12, 
                                       7, 
                                       13, 
                                       14, 
                                       15
                                      )
                        }
                       )
    m_iCurrentBaseHead = -1
}