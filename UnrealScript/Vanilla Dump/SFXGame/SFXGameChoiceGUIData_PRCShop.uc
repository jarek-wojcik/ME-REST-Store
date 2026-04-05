Class SFXGameChoiceGUIData_PRCShop extends SFXGameChoiceGUIData
    native
    editinlinenew
    config(UI);

struct native SFXChoiceEntryNoStrRef 
{
    var(SFXChoiceEntryNoStrRef) string sChoiceName;
    var(SFXChoiceEntryNoStrRef) string sChoiceTitle;
    var(SFXChoiceEntryNoStrRef) string sChoiceImageTitle;
    var(SFXChoiceEntryNoStrRef) string sChoiceDescription;
    var(SFXChoiceEntryNoStrRef) string sActionText;
    var(SFXChoiceEntryNoStrRef) array<SFXTokenMapping> m_mapTokenIDToActual;
    var(SFXChoiceEntryNoStrRef) Texture2D oChoiceImage;
    var(SFXChoiceEntryNoStrRef) int nOptionalPaneItemValue;
    var(SFXChoiceEntryNoStrRef) int nChoiceID;
    var(SFXChoiceEntryNoStrRef) bool bDefaultSelection;
    var(SFXChoiceEntryNoStrRef) bool bDisabled;
    var(SFXChoiceEntryNoStrRef) bool bNested;
    var(SFXChoiceEntryNoStrRef) SFXChoiceColors ChoiceColor;
    var(SFXChoiceEntryNoStrRef) EInventoryResourceTypes eResource;
};

var transient array<SFXChoiceEntryNoStrRef> lstChoicesNoStrRef;

public function AddChoiceNoStrRef(SFXChoiceEntryNoStrRef oChoice)
{
    lstChoicesNoStrRef.AddItem(oChoice);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}