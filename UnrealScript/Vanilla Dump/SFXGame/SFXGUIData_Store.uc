Class SFXGUIData_Store extends SFXGameChoiceGUIData
    native
    editinlinenew
    perobjectconfig
    config(UI);

struct native StoreItemData 
{
    var SFXChoiceEntry ChoiceEntry;
    var string ItemClassName;
    var array<int> PlotPurchaseID;
    var biodynamicload string LargeImage;
    var biodynamicload string SmallImage;
    var array<string> PVsToIncrement;
    var array<stringref> CustomTokens;
    var array<int> ItemConditionals;
    var int BaseCost;
    var int PlotUnlockID;
    var int PlotUnlockConditionalID;
    var int ArmorID;
    var int PlotPurchaseInt;
    var float Priority;
    var int CurrentModRank;
    var float Value;
    var bool bIsGameEffect;
    var bool bBuffsGAWAssets;
    var EItemType ItemType;
};
enum EItemType
{
    TYPE_MOD,
    TYPE_QUEST,
    TYPE_DECORATION,
    TYPE_WEAPON,
    TYPE_WEAPONUPGRADE,
    TYPE_HELMET,
    TYPE_TORSO,
    TYPE_SHOULDERS,
    TYPE_LEGS,
    TYPE_ARMS,
    TYPE_UNIQUEARMOR,
    TYPE_PARTBASEDARMOR,
    TYPE_MEDIGEL,
    TYPE_POWER,
    TYPE_TALENTRESET,
    TYPE_INTELREWARD,
    TYPE_NESTEDCATEGORY,
    TYPE_RETURN,
    TYPE_INTELSUMMARY,
};

var config StoreItemData IntelSummary;
var config array<StoreItemData> StoreItemArray;
var config string DefaultImage;
var array<SFXGUIData_Store> MallStoreArray;
var config string StoreHeaderImageRef;
var config Name StoreName;
var config int DiscoveryID;
var config int DiscountUnlockID;
var config float DiscountPercent;
var config float MarkupPercent;
var config stringref srStoreDescription;
var config stringref ConfirmationMessageATextOverride;
var config stringref srOutOfStock;
var config stringref srOutOfStockDescription;
var config bool bApplyIntelSummary;
var config bool bUseChoiceNameAsConfirmationMessage;
var EItemType ItemType;

public final function bool IsStoreDiscovered()
{
    local BioGlobalVariableTable PlotStateData;
    
    PlotStateData = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    if (PlotStateData == None)
    {
        return FALSE;
    }
    if (DiscoveryID == -1)
    {
        return TRUE;
    }
    return PlotStateData.GetBool(DiscoveryID);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IntelSummary = {
                    ChoiceEntry = {
                                   m_mapTokenIDToActual = (), 
                                   sChoiceName = "", 
                                   sChoiceTitle = "", 
                                   sChoiceImageTitle = "", 
                                   sChoiceDescription = "", 
                                   sActionText = "", 
                                   WeaponClassRef = 'None', 
                                   WeaponModClassRef = 'None', 
                                   srChoiceName = $0, 
                                   srChoiceTitle = $0, 
                                   oChoiceImage = None, 
                                   srChoiceImageTitle = $0, 
                                   srChoiceDescription = $0, 
                                   nOptionalPaneItemValue = 0, 
                                   nChoiceID = 0, 
                                   srActionText = $0, 
                                   bDefaultSelection = FALSE, 
                                   bDisabled = FALSE, 
                                   bNested = FALSE, 
                                   bOptionalPaneHideCost = FALSE, 
                                   ChoiceColor = SFXChoiceColors.CHOICECOLOR_Orange, 
                                   eResource = None, 
                                   eDisplayType = EChoiceDisplayType.EChoiceDisplayType_Normal
                                  }, 
                    ItemClassName = "", 
                    PlotPurchaseID = (), 
                    LargeImage = "", 
                    SmallImage = "", 
                    PVsToIncrement = (), 
                    CustomTokens = (), 
                    ItemConditionals = (), 
                    BaseCost = 0, 
                    PlotUnlockID = 0, 
                    PlotUnlockConditionalID = 0, 
                    ArmorID = 0, 
                    PlotPurchaseInt = 0, 
                    Priority = 0.0, 
                    CurrentModRank = 0, 
                    Value = 0.0, 
                    bIsGameEffect = FALSE, 
                    bBuffsGAWAssets = FALSE, 
                    ItemType = EItemType.TYPE_MOD
                   }
}