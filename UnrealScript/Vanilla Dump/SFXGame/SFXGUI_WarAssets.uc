Class SFXGUI_WarAssets extends SFXGUIMovie
    config(UI);

struct WarAssetGUIData 
{
    var string AssetName;
    var string AssetStrength;
    var int AssetID;
    var bool bIsNewItem;
};
struct WarAssetCategoryGUIData 
{
    var string CategoryName;
    var string CategoryStrength;
    var int categoryId;
    var bool bHasNewItems;
};

var delegate<OnFinished> __OnFinished__Delegate;
var delegate<OnSwitchScreens> __OnSwitchScreens__Delegate;
var config stringref srReadinessPercent;
var SFXGAWAssetsHandler GAWAssetsHandler;
var config stringref srWarAssetsTutorialMessage;

public function Exit()
{
    PlayGuiSound('WarAssetsFinish');
    Close();
    if (__OnFinished__Delegate != None)
    {
        __OnFinished__Delegate();
    }
}
public function ExSetItemRead(int nPrimaryID, int nSecondaryID)
{
    GAWAssetsHandler.MarkAssetAsRead(nSecondaryID);
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            AS_ScrollDetails(fValue);
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public delegate function OnFinished();

public event function OnStart()
{
    Super.OnStart();
    PlayGuiSound('WarAssetsStart');
    SetRequiresUIWorld(TRUE);
    SetGameMode(TRUE, 9);
    SetMouseVisible(TRUE);
    GAWAssetsHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    AS_InitializeScreen();
    ShowTutorial();
}
public event function OnClose()
{
    SetMouseVisible(FALSE);
    SetGameMode(FALSE, 9);
    GAWAssetsHandler.FlagAllUnlockedAssetsAsDisplayedInGUI();
    Super.OnClose();
}
public function AS_InitializeScreen()
{
    ActionScriptVoid("screen.InitializeScreen");
}
public function AS_ScrollDetails(float fValue)
{
    ActionScriptVoid("screen.ScrollDetails");
}
private final function bool CategoryHasUnlockedAssets(int categoryId)
{
    local int idx;
    
    for (idx = 0; idx < GAWAssetsHandler.AllAssets.Length; ++idx)
    {
        if (GAWAssetsHandler.IsAssetUnlockedForGUICategory(idx, categoryId))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function array<WarAssetCategoryGUIData> GetAssetCategories()
{
    local array<WarAssetCategoryGUIData> AssetCategories;
    local WarAssetCategoryGUIData CurrCategory;
    local int idx;
    
    for (idx = 0; idx < GAWAssetsHandler.GAWGUICategories.Length; ++idx)
    {
        if (CategoryHasUnlockedAssets(GAWAssetsHandler.GAWGUICategories[idx].Id))
        {
            CurrCategory.categoryId = GAWAssetsHandler.GAWGUICategories[idx].Id;
            CurrCategory.CategoryName = GetUIString(GAWAssetsHandler.GAWGUICategories[idx].srCategoryName);
            CurrCategory.CategoryStrength = string(GetCategoryStrength(GAWAssetsHandler.GAWGUICategories[idx].Id));
            CurrCategory.bHasNewItems = GAWAssetsHandler.DoesCategoryHaveNewAssets(GAWAssetsHandler.GAWGUICategories[idx].Id);
            AssetCategories.AddItem(CurrCategory);
        }
    }
    return AssetCategories;
}
public function string GetAssetDetailsText(int AssetID)
{
    local string AssetName;
    local string DetailsText;
    
    GAWAssetsHandler.GetGAWAssetGUIInfo(AssetID, AssetName, TRUE, DetailsText);
    return DetailsText;
}
public function string GetAssetImageReference(int AssetID)
{
    return GAWAssetsHandler.GetImagePath(AssetID);
}
public function string GetAssetSummaryText()
{
    return GAWAssetsHandler.GetWarAssetsSummaryText();
}
public function string GetCategoryDetailsText(int categoryId)
{
    local int nCategoryIndex;
    
    nCategoryIndex = GAWAssetsHandler.GAWGUICategories.Find('Id', categoryId);
    if (nCategoryIndex >= 0)
    {
        return GetUIString(GAWAssetsHandler.GAWGUICategories[nCategoryIndex].srCategoryDescription);
    }
    return "";
}
public function string GetCategoryImageReference(int categoryId)
{
    return GAWAssetsHandler.GetCategoryImagePath(categoryId);
}
private final function int GetCategoryStrength(int categoryId)
{
    local int idx;
    local int nTotalCategoryStrength;
    local int nCurrentStrength;
    
    nTotalCategoryStrength = 0;
    for (idx = 0; idx < GAWAssetsHandler.AllAssets.Length; ++idx)
    {
        if (GAWAssetsHandler.IsAssetUnlockedForGUICategory(idx, categoryId, nCurrentStrength))
        {
            if (nCurrentStrength >= 0)
            {
                nTotalCategoryStrength += nCurrentStrength;
            }
        }
    }
    return nTotalCategoryStrength;
}
public function int GetEffectiveMilitaryStrength()
{
    return GAWAssetsHandler.GetFinalScore(GAWAssetsHandler.GetOverallReadinessRating());
}
public function string GetFormattedReadinessPercent(int nReadiness)
{
    local string ResultString;
    
    SetCustomToken(0, string(nReadiness));
    ResultString = GetUIString(srReadinessPercent, TRUE);
    ClearCustomTokens();
    return ResultString;
}
public function int GetMaxMilitaryStrength()
{
    return GAWAssetsHandler.MaxStrengthForGUI;
}
public function int GetMinMilitaryStrength()
{
    return GAWAssetsHandler.MinimumStrengthForGUI;
}
public function int GetReadinessRating()
{
    return GAWAssetsHandler.GetOverallReadinessRating();
}
public function int GetTotalMilitaryStrength()
{
    return GAWAssetsHandler.GetTotalScore();
}
public function array<WarAssetGUIData> GetWarAssetData(int categoryId)
{
    local array<WarAssetGUIData> AssetData;
    local WarAssetGUIData CurrAsset;
    local int idx;
    local int nCurrentStrength;
    
    for (idx = 0; idx < GAWAssetsHandler.AllAssets.Length; ++idx)
    {
        if (GAWAssetsHandler.IsAssetUnlockedForGUICategory(idx, categoryId, nCurrentStrength))
        {
            CurrAsset.AssetID = GAWAssetsHandler.AllAssets[idx].Id;
            CurrAsset.AssetName = GetUIString(GAWAssetsHandler.AllAssets[idx].GUIName);
            CurrAsset.AssetStrength = string(nCurrentStrength);
            CurrAsset.bIsNewItem = GAWAssetsHandler.IsAssetNew(GAWAssetsHandler.AllAssets[idx].Id);
            AssetData.AddItem(CurrAsset);
        }
    }
    return AssetData;
}
public function GoToGalaxyAtWar()
{
    Close();
    if (__OnSwitchScreens__Delegate != None)
    {
        __OnSwitchScreens__Delegate();
    }
}
public delegate function OnSwitchScreens();

public function ShowTutorial()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local SFXEngine Engine;
    
    if (srWarAssetsTutorialMessage == 0)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine.GetPlayerVariable('WarAssetsTutorialDisplayed') != 0)
    {
        return;
    }
    Engine.SetPlayerVariable('WarAssetsTutorialDisplayed', 1);
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    Params.srAText = Class'SFXGUI_GalaxyAtWar'.default.srOK;
    messageBox.DisplayMessageBox(srWarAssetsTutorialMessage, Params);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srReadinessPercent = $710700
    srWarAssetsTutorialMessage = $727390
    m_bFocusOnStart = TRUE
}