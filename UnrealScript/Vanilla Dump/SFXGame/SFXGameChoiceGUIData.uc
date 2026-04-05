Class SFXGameChoiceGUIData
    native
    editinlinenew
    config(UI);

struct native SFXChoiceEntry 
{
    var(SFXChoiceEntry) array<SFXTokenMapping> m_mapTokenIDToActual;
    var string sChoiceName;
    var string sChoiceTitle;
    var string sChoiceImageTitle;
    var string sChoiceDescription;
    var string sActionText;
    var Name WeaponClassRef;
    var Name WeaponModClassRef;
    var(SFXChoiceEntry) stringref srChoiceName;
    var(SFXChoiceEntry) stringref srChoiceTitle;
    var(SFXChoiceEntry) Texture2D oChoiceImage;
    var(SFXChoiceEntry) stringref srChoiceImageTitle;
    var(SFXChoiceEntry) stringref srChoiceDescription;
    var(SFXChoiceEntry) int nOptionalPaneItemValue;
    var(SFXChoiceEntry) int nChoiceID;
    var(SFXChoiceEntry) stringref srActionText;
    var(SFXChoiceEntry) bool bDefaultSelection;
    var(SFXChoiceEntry) bool bDisabled;
    var(SFXChoiceEntry) bool bNested;
    var(SFXChoiceEntry) bool bOptionalPaneHideCost;
    var(SFXChoiceEntry) SFXChoiceColors ChoiceColor;
    var(SFXChoiceEntry) EInventoryResourceTypes eResource;
    var(SFXChoiceEntry) EChoiceDisplayType eDisplayType;
    
    structdefaultproperties
    {
        eResource = None
    }
};
enum EChoiceDisplayType
{
    EChoiceDisplayType_Normal,
    EChoiceDisplayType_Nested,
    EChoiceDisplayType_Special,
    EChoiceDisplayType_None,
};
enum SFXChoiceColors
{
    CHOICECOLOR_Orange,
    CHOICECOLOR_Red,
    CHOICECOLOR_Green,
};

var(SFXGameChoiceGUIData) array<SFXTokenMapping> m_mapTokenIDToActual;
var(SFXGameChoiceGUIData) config editconst array<SFXChoiceEntry> lstChoices;
var(SFXGameChoiceGUIData) config stringref m_srTitle;
var(SFXGameChoiceGUIData) config stringref m_srSubTitle;
var(SFXGameChoiceGUIData) config stringref m_srAText;
var(SFXGameChoiceGUIData) config stringref m_srBText;
var(SFXGameChoiceGUIData) config stringref m_srOptionalPaneTitleText;
var(SFXGameChoiceGUIData) config stringref m_srOptionalPaneItemValuePrefixText;
var(SFXGameChoiceGUIData) config bool m_ShowOptionalPane;
var(SFXGameChoiceGUIData) config EInventoryResourceTypes m_eOptionalPaneResourceType;

public native function bool AddChoice(SFXChoiceEntry Params);

public native function ClearChoiceList();

public static final native function RemoveTokenMapping(out SFXChoiceEntry Data, int nTokenID);

public native function SetDisplayText(stringref srTitle, stringref srSubTitle, stringref srAText, stringref srBText);

public static final native function SetTokenMapping(out SFXChoiceEntry Data, int nTokenID, string sValue);

public native function SetupOptionalPane(bool bShowOptionalPane, optional stringref srOptionalPaneTitleText = $0, optional stringref srOptionalPaneItemValuePrefixText = $0, optional stringref srOptionalPaneValuePrefixText = $0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}