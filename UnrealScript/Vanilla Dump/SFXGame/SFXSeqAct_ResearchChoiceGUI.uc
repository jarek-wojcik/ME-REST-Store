Class SFXSeqAct_ResearchChoiceGUI extends BioSequenceLatentAction
    deprecated
    config(UI);

struct ResearchMenu 
{
    var biodynamicload string sImagePath;
    var transient array<TechData> m_ResearchChoices;
    var int Index;
    var stringref srTitle;
    var stringref srSubTitle;
    var stringref srAboutLabel;
    var stringref srAboutText;
};
enum EResearchMode
{
    MODE_RESEARCH_TOP,
    MODE_RESEARCH_WEAPON,
    MODE_RESEARCH_ARMOR,
    MODE_RESEARCH_SHIP,
    MODE_RESEARCH_GEAR,
};
enum eMode
{
    MODE_TOPLEVEL,
    MODE_RESEARCH,
    MODE_TECH,
};

var transient TechData m_ChosenTechData;
var transient array<TechData> m_TechChoices;
var transient array<TechData> m_ResearchChoices;
var transient array<TechData> m_ResearchSubMenuChoices;
var config array<SFXChoiceEntry> m_TopLevelChoices;
var config array<SFXChoiceEntry> m_TechTopChoices;
var config array<SFXChoiceEntry> m_ResearchTopChoices;
var config array<ResearchMenu> ResearchSubMenus;
var transient BioSFHandler_ChoiceGUI m_ChoiceGUIHandler;
var transient SFXGameChoiceGUIData_Research m_ChoiceGUIData;
var BioSFHandler_MessageBox m_oMsgBox;
var const stringref srText;
var const stringref srErrorAButton;
var const stringref srErrorCanNotAfford;
var const stringref srErrorDoNotQualify;
var const stringref srErrorKnown;
var const stringref srTechNameLabel;
var const stringref srResearchConfirmMessage;
var const stringref srResearchConfirm;
var const stringref srResearchCancel;
var const stringref srEezo;
var const stringref srPlatinum;
var const stringref srPalladium;
var const stringref srIridium;
var const int nLastUnlockedResearch;
var const int nLastUnlockedTech;
var const stringref srResearchDescription;
var const stringref srResearchTokenizedDescriptionPlural;
var const stringref srResearchTokenizedDescriptionSingular;
var const stringref srResearchTokenizedDescriptionResources;
var const stringref srUpgradeTokenizedDescription;
var const stringref srTokenizedResearchCategory;
var const stringref srTokenizedResearchCategoryCounter;
var const stringref srTopLevelAButton;
var transient bool m_bFinished;
var transient bool m_bAborted;
var transient bool m_bWasPaused;
var transient bool bDidResearch;
var transient bool m_bMessageBoxActivated;
var eMode mode;
var EResearchMode RMode;
var(SFXSeqAct_ResearchChoiceGUI) eMode InitialMode;
var(SFXSeqAct_ResearchChoiceGUI) EResearchMode InitialResearchMode;

public event function Activated()
{
    local BioPlayerController PC;
    local BioWorldInfo WorldInfo;
    
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo != None)
    {
        PC = WorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            PC.GameModeManager2.EnableMode(9, 'ChoiceGUI');
        }
    }
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    bDidResearch = FALSE;
    m_bFinished = FALSE;
    m_bMessageBoxActivated = FALSE;
    m_ChosenTechData = default.m_ChosenTechData;
    if (m_ChoiceGUIData == None)
    {
        m_bAborted = TRUE;
        return;
    }
    mode = InitialMode;
    RMode = InitialResearchMode;
    m_bWasPaused = BioWorldInfo(GetWorldInfo()).bPlayersOnly;
    SetupTreasureData();
    Reset();
}
public final function ChoiceGUIInputPressed(bool bAPressed, int nContext)
{
    switch (mode)
    {
        case eMode.MODE_TOPLEVEL:
            HandleInput_TopLevel(bAPressed, nContext);
            break;
        case eMode.MODE_TECH:
            HandleInput_Tech(bAPressed, nContext);
            break;
        case eMode.MODE_RESEARCH:
            HandleInput_Research(bAPressed, nContext);
            break;
        default:
    }
}
public event function Deactivated()
{
    local BioPlayerController PC;
    local BioWorldInfo WorldInfo;
    
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo != None)
    {
        PC = WorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            PC.GameModeManager2.DisableMode(9, 'ChoiceGUI');
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}
public function Reset()
{
    local BioPlayerController Controller;
    local SFXGUIInteraction Manager;
    local BioWorldInfo WorldInfo;
    local int idx;
    local bool bResult;
    
    m_TechChoices.Remove(0, m_TechChoices.Length);
    m_TechChoices.Length = 0;
    m_ResearchChoices.Remove(0, m_ResearchChoices.Length);
    m_ResearchChoices.Length = 0;
    for (idx = 0; idx < ResearchSubMenus.Length; idx++)
    {
        ResearchSubMenus[idx].m_ResearchChoices.Remove(0, ResearchSubMenus[idx].m_ResearchChoices.Length);
        ResearchSubMenus[idx].m_ResearchChoices.Length = 0;
    }
    m_ResearchSubMenuChoices.Remove(0, m_ResearchSubMenuChoices.Length);
    m_ResearchSubMenuChoices.Length = 0;
    m_ChoiceGUIData.lstChoices.Remove(0, m_ChoiceGUIData.lstChoices.Length);
    m_ChoiceGUIData.lstChoices.Length = 0;
    SetupChoiceGUI();
    bResult = FALSE;
    switch (mode)
    {
        case eMode.MODE_TOPLEVEL:
            bResult = RenderModeTopLevel();
            break;
        case eMode.MODE_TECH:
            bResult = RenderModeTech();
            break;
        case eMode.MODE_RESEARCH:
            bResult = RenderModeResearch();
            break;
        default:
    }
    if (!bResult)
    {
        m_bAborted = TRUE;
        return;
    }
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo != None)
    {
        Controller = WorldInfo.GetLocalPlayerController();
        if (Controller != None)
        {
            Manager = Class'SFXGUIInteraction'.static.GetInstance();
            if (Manager != None)
            {
                m_ChoiceGUIHandler = Manager.CreateChoiceGUI('None', Controller);
                if (m_ChoiceGUIHandler != None)
                {
                    m_ChoiceGUIHandler.SetInputDelegate(ChoiceGUIInputPressed);
                    m_ChoiceGUIHandler.Initialize(m_ChoiceGUIData);
                    m_ChoiceGUIHandler.ShowChoiceGUI();
                    WorldInfo.bPlayersOnly = TRUE;
                }
            }
        }
    }
}
public function bool UpdateOp(float fDeltaT)
{
    if (m_bAborted)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    if (m_bFinished)
    {
        OutputLinks[0].bHasImpulse = bDidResearch;
        OutputLinks[1].bHasImpulse = !bDidResearch;
    }
    if (m_bAborted || m_bFinished)
    {
        if (m_ChoiceGUIHandler != None)
        {
            m_ChoiceGUIHandler.HideChoiceGUI(TRUE);
            m_ChoiceGUIHandler = None;
        }
        return TRUE;
    }
    return FALSE;
}
public function DoResearch()
{
    local SFXPlotTreasure oTreasure;
    
    oTreasure = BioWorldInfo(GetWorldInfo()).m_oTreasure;
    oTreasure.AwardTreasure(m_ChosenTechData.TreasureId, TRUE);
    bDidResearch = TRUE;
}
public function ExitChosen();

public function ExitGui()
{
    m_bFinished = TRUE;
    GetWorldInfo().bPlayersOnly = m_bWasPaused;
}
public function string GetResearchCanAffordString(TechData ResearchData)
{
    local SFXPlotTreasure oTreasure;
    local STreasure stTreasure;
    local int nPlayerCash;
    local int nResearchCost;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    if (oTreasure.CanAffordTreasure(ResearchData.TreasureId, TRUE))
    {
        return "";
    }
    stTreasure = oTreasure.TREASURE(ResearchData.TreasureId);
    ClearCustomTokens();
    nResearchCost = int(oTreasure.Price(ResearchData.TreasureId, TRUE));
    nPlayerCash = SFXInventoryManager(SFXPawn(oWorldInfo.GetLocalPlayerController().Pawn).InvManager).GetResource(stTreasure.Resource);
    SetCustomToken(0, "" $ nResearchCost - nPlayerCash);
    switch (stTreasure.Resource)
    {
        case EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO:
            SetCustomToken(1, string(srEezo));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM:
            SetCustomToken(1, string(srIridium));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM:
            SetCustomToken(1, string(srPalladium));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM:
            SetCustomToken(1, string(srPlatinum));
            break;
        default:
            break;
    }
    return string(srResearchTokenizedDescriptionResources);
}
public function string GetResearchDescription(TechData ResearchData)
{
    local string sQualifiesFor;
    local string sCanAfford;
    local string sDescription;
    local int nNewTechLevel;
    
    sQualifiesFor = GetResearchQualifiesForString(ResearchData);
    sCanAfford = GetResearchCanAffordString(ResearchData);
    nNewTechLevel = BioWorldInfo(GetWorldInfo()).GetGlobalVariables().GetIntByName(ResearchData.stTech.nmTech) + 1;
    sDescription = TokenizeResearchString(nNewTechLevel, ResearchData.stTech.srDescription);
    if (sQualifiesFor == "" && sCanAfford == "")
    {
        return sDescription;
    }
    else
    {
        ClearCustomTokens();
        SetCustomToken(0, sQualifiesFor);
        SetCustomToken(1, sCanAfford);
        SetCustomToken(2, sDescription);
        sDescription = string(srResearchDescription);
    }
    return sDescription;
}
public function string GetResearchQualifiesForString(TechData ResearchData)
{
    local SFXPlotTreasure oTreasure;
    local STreasure stTreasure;
    local STech stRequiredTech;
    local int nTechLevel;
    local int nRequiredTechLevel;
    local string sDescription;
    local bool bQualifiesFor;
    
    oTreasure = BioWorldInfo(GetWorldInfo()).m_oTreasure;
    bQualifiesFor = oTreasure.QualifiesForTreasure(ResearchData.TreasureId);
    if (bQualifiesFor)
    {
        return "";
    }
    stTreasure = oTreasure.TREASURE(ResearchData.TreasureId);
    stRequiredTech = oTreasure.Tech(stTreasure.nmRequiredTech);
    nTechLevel = BioWorldInfo(GetWorldInfo()).GetGlobalVariables().GetIntByName(stTreasure.nmRequiredTech);
    nRequiredTechLevel = stTreasure.RequiredTechLevel;
    bQualifiesFor = oTreasure.QualifiesForTreasure(ResearchData.TreasureId);
    ClearCustomTokens();
    SetCustomToken(0, "" $ nRequiredTechLevel - nTechLevel);
    SetCustomToken(1, string(stRequiredTech.srName));
    if (nRequiredTechLevel - nTechLevel == 1)
    {
        sDescription = string(srResearchTokenizedDescriptionSingular);
    }
    else
    {
        sDescription = string(srResearchTokenizedDescriptionPlural);
    }
    return sDescription;
}
public final function HandleInput_Research(bool bAPressed, int nContext)
{
    local SFXPlotTreasure oTreasure;
    local STreasure stTreasure;
    
    if (!bAPressed && !m_bFinished)
    {
        if (RMode == EResearchMode.MODE_RESEARCH_TOP)
        {
            ExitGui();
            return;
        }
        else
        {
            RMode = EResearchMode.MODE_RESEARCH_TOP;
            Reset();
            return;
        }
    }
    if (bAPressed && !m_bFinished)
    {
        if (nContext == 0)
        {
            return;
        }
        if (RMode == EResearchMode.MODE_RESEARCH_TOP)
        {
            RMode = byte(nContext);
            Reset();
        }
        else if (!m_bMessageBoxActivated)
        {
            m_ChosenTechData = ResearchSubMenus[int(RMode)].m_ResearchChoices[nContext - 1];
            oTreasure = BioWorldInfo(GetWorldInfo()).m_oTreasure;
            if (oTreasure == None || oTreasure.QualifiesForTreasure(m_ChosenTechData.TreasureId) == FALSE)
            {
                ShowErrorMessageBox(srErrorDoNotQualify);
            }
            else if (oTreasure.CanAffordTreasure(m_ChosenTechData.TreasureId, TRUE) == FALSE)
            {
                ShowErrorMessageBox(srErrorCanNotAfford);
            }
            else
            {
                stTreasure = oTreasure.TREASURE(m_ChosenTechData.TreasureId);
                ShowResearchMessageBox(stTreasure, m_ChosenTechData.stTech);
            }
        }
        return;
    }
}
public final function HandleInput_Tech(bool bAPressed, int nContext)
{
    if (!bAPressed && !m_bFinished)
    {
        ExitGui();
    }
}
public final function HandleInput_TopLevel(bool bAPressed, int nContext)
{
    if (!bAPressed && !m_bFinished)
    {
        ExitGui();
        return;
    }
    if (bAPressed && !m_bFinished)
    {
        if (nContext == 0)
        {
            mode = eMode.MODE_TECH;
            Reset();
        }
        else if (nContext == 1)
        {
            mode = eMode.MODE_RESEARCH;
            Reset();
        }
        return;
    }
}
public final function MessageInputPressed(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
    }
    m_bMessageBoxActivated = FALSE;
}
public final function MessageInputPressedError(bool bAPressed, int nContext)
{
    m_bMessageBoxActivated = FALSE;
}
public final function MessageInputPressedResearch(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        DoResearch();
        ExitGui();
    }
    m_bMessageBoxActivated = FALSE;
}
public function bool RenderModeResearch()
{
    local ResearchMenu Menu;
    local int idx;
    
    for (idx = 0; idx < ResearchSubMenus.Length; idx++)
    {
        if (ResearchSubMenus[idx].Index == int(RMode))
        {
            Menu = ResearchSubMenus[idx];
        }
    }
    SetupResearch(Menu);
    m_ChoiceGUIData.m_srTitle = ResearchSubMenus[int(RMode)].srTitle;
    m_ChoiceGUIData.m_srSubTitle = ResearchSubMenus[int(RMode)].srSubTitle;
    m_ChoiceGUIData.m_srAText = RMode == EResearchMode.MODE_RESEARCH_TOP ? srTopLevelAButton : m_ChoiceGUIData.default.m_srResearchAText;
    m_ChoiceGUIData.m_srBText = m_ChoiceGUIData.default.m_srResearchBText;
    return TRUE;
}
public function bool RenderModeTech()
{
    SetupTech();
    if (m_ChoiceGUIData.lstChoices.Length == 0)
    {
        m_bAborted = TRUE;
        return FALSE;
    }
    m_ChoiceGUIData.m_srTitle = m_ChoiceGUIData.m_srTechTitle;
    m_ChoiceGUIData.m_srSubTitle = m_ChoiceGUIData.m_srTechSubTitle;
    m_ChoiceGUIData.m_srAText = m_ChoiceGUIData.m_srTechAText;
    m_ChoiceGUIData.m_srBText = m_ChoiceGUIData.m_srTechBText;
    return TRUE;
}
public function bool RenderModeTopLevel()
{
    SetupTop();
    if (m_ChoiceGUIData.lstChoices.Length == 0)
    {
        m_bAborted = TRUE;
        return FALSE;
    }
    m_ChoiceGUIData.m_srTitle = m_ChoiceGUIData.default.m_srTitle;
    m_ChoiceGUIData.m_srSubTitle = m_ChoiceGUIData.default.m_srSubTitle;
    m_ChoiceGUIData.m_srAText = m_ChoiceGUIData.default.m_srAText;
    m_ChoiceGUIData.m_srBText = m_ChoiceGUIData.default.m_srBText;
    return TRUE;
}
public function ResearchMenuChosen();

public function SetupChoiceGUI()
{
    local TechData Data;
    
    foreach m_ChoiceGUIData.Tech(Data, )
    {
        m_TechChoices.AddItem(Data);
    }
    foreach m_ChoiceGUIData.Research(Data, )
    {
        m_ResearchChoices.AddItem(Data);
    }
}
public function SetupResearch(ResearchMenu Menu)
{
    local TechData ResearchData;
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    local SFXChoiceEntry choice;
    local BioGlobalVariableTable oGV;
    local int i;
    local int J;
    local int nTechLevel;
    local int nResearchLevel;
    local bool bInOrder;
    local ResearchMenu TmpMenu;
    local string sTmp;
    local string sLargeImage;
    
    m_ChoiceGUIData.lstChoices.Remove(0, m_ChoiceGUIData.lstChoices.Length);
    m_ChoiceGUIData.lstChoices.Length = 0;
    m_ChoiceGUIData.m_ShowOptionalPane = TRUE;
    if (Menu.Index != 0)
    {
        choice = m_ResearchTopChoices[0];
        choice.srChoiceDescription = Menu.srAboutText;
        choice.srChoiceName = Menu.srAboutLabel;
        choice.bDisabled = TRUE;
        choice.bOptionalPaneHideCost = TRUE;
        choice.oChoiceImage = Class'SFXPlotTreasure'.static.FindImage(Menu.sImagePath);
        choice.srChoiceImageTitle = Menu.srAboutLabel;
        m_ChoiceGUIData.lstChoices.AddItem(choice);
    }
    else
    {
        choice.bOptionalPaneHideCost = FALSE;
    }
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    oTreasure.SetNewResearchAvailable(FALSE);
    oGV = BioWorldInfo(GetWorldInfo()).GetGlobalVariables();
    for (i = 0; i < m_ResearchChoices.Length; i++)
    {
        ResearchData = m_ResearchChoices[i];
        nTechLevel = oGV.GetIntByName(ResearchData.stTech.nmTech);
        nResearchLevel = oGV.GetIntByName(ResearchData.stTreasure.nmRequiredTech);
        if (ResearchData.stTech.nLevels <= 1 && nTechLevel > 0)
        {
            continue;
        }
        if (oGV.GetBool(ResearchData.DisableId))
        {
            continue;
        }
        if (ResearchData.stTech.nLevels > 1 && nTechLevel >= nResearchLevel)
        {
            continue;
        }
        if (oTreasure.DiscoveredResearch(ResearchData.TreasureId) == FALSE)
        {
            continue;
        }
        TokenizeTechData(ResearchData, 1);
        ResearchData.ChoiceEntry.srChoiceImageTitle = ResearchData.stTech.srTitle;
        ResearchData.ChoiceEntry.srChoiceTitle = ResearchData.stTech.srName;
        ResearchData.ChoiceEntry.sChoiceDescription = GetResearchDescription(ResearchData);
        ResearchData.ChoiceEntry.sChoiceName = oTreasure.GetTechName(ResearchData.stTech, TRUE);
        ResearchData.ChoiceEntry.bDisabled = !oTreasure.CanAffordTreasure(ResearchData.TreasureId, TRUE);
        ResearchData.ChoiceEntry.bDisabled = ResearchData.ChoiceEntry.bDisabled || !oTreasure.QualifiesForTreasure(ResearchData.TreasureId);
        ResearchData.ChoiceEntry.eResource = ResearchData.stTreasure.Resource;
        ResearchData.ChoiceEntry.nOptionalPaneItemValue = int(oTreasure.Price(ResearchData.TreasureId, TRUE));
        ResearchData.ChoiceEntry.bDefaultSelection = ResearchData.TreasureId == oGV.GetInt(nLastUnlockedResearch);
        sLargeImage = Class'SFXPlotTreasure'.static.GetTreasureLargeImageResourcePath(ResearchData.TreasureId);
        ResearchData.ChoiceEntry.oChoiceImage = Class'SFXPlotTreasure'.static.FindImage(sLargeImage);
        if (ResearchData.RMode == Menu.Index)
        {
            m_ChoiceGUIData.lstChoices.AddItem(ResearchData.ChoiceEntry);
        }
        ResearchSubMenus[ResearchData.RMode].m_ResearchChoices.AddItem(ResearchData);
    }
    for (i = 1; i < m_ChoiceGUIData.lstChoices.Length; i++)
    {
        for (J = i + 1; J < m_ChoiceGUIData.lstChoices.Length; J++)
        {
            if (m_ChoiceGUIData.lstChoices[i].bDisabled == m_ChoiceGUIData.lstChoices[J].bDisabled)
            {
                bInOrder = m_ChoiceGUIData.lstChoices[i].sChoiceName <= m_ChoiceGUIData.lstChoices[J].sChoiceName;
            }
            else
            {
                bInOrder = m_ChoiceGUIData.lstChoices[J].bDisabled;
            }
            if (!bInOrder)
            {
                ResearchData = ResearchSubMenus[Menu.Index].m_ResearchChoices[i - 1];
                choice = m_ChoiceGUIData.lstChoices[i];
                ResearchSubMenus[Menu.Index].m_ResearchChoices[i - 1] = ResearchSubMenus[Menu.Index].m_ResearchChoices[J - 1];
                m_ChoiceGUIData.lstChoices[i] = m_ChoiceGUIData.lstChoices[J];
                ResearchSubMenus[Menu.Index].m_ResearchChoices[J - 1] = ResearchData;
                m_ChoiceGUIData.lstChoices[J] = choice;
            }
        }
    }
    if (Menu.Index == 0)
    {
        foreach ResearchSubMenus(TmpMenu, )
        {
            if (TmpMenu.m_ResearchChoices.Length == 0)
            {
                if (RMode == EResearchMode.MODE_RESEARCH_TOP && TmpMenu.Index == 0)
                {
                    sTmp = string(TmpMenu.srAboutLabel);
                }
                else
                {
                    sTmp = string(TmpMenu.srTitle);
                }
                choice.bDisabled = TRUE;
            }
            else
            {
                ClearCustomTokens();
                SetCustomToken(0, "" $ TmpMenu.m_ResearchChoices.Length);
                sTmp = string(srTokenizedResearchCategoryCounter);
                SetCustomToken(0, string(TmpMenu.srTitle));
                SetCustomToken(1, sTmp);
                sTmp = string(srTokenizedResearchCategory);
                choice.bDisabled = FALSE;
            }
            choice = m_ResearchTopChoices[0];
            choice.srChoiceDescription = TmpMenu.srAboutText;
            choice.sChoiceName = sTmp;
            choice.oChoiceImage = Class'SFXPlotTreasure'.static.FindImage(TmpMenu.sImagePath);
            choice.srChoiceImageTitle = TmpMenu == ResearchSubMenus[0] ? TmpMenu.srAboutLabel : TmpMenu.srTitle;
            choice.bDisabled = TmpMenu.m_ResearchChoices.Length == 0;
            m_ChoiceGUIData.lstChoices.AddItem(choice);
        }
        m_ChoiceGUIData.m_ShowOptionalPane = FALSE;
        return;
    }
}
public function SetupTech()
{
    local TechData TechData;
    local SFXChoiceEntry choice;
    local int nLevel;
    local int i;
    local int J;
    local BioGlobalVariableTable oGV;
    local SFXPlotTreasure oTreasure;
    local STech stTech;
    local bool bInOrder;
    local string sTechSmallImagePath;
    local string sTechLargeImagePath;
    
    oTreasure = BioWorldInfo(GetWorldInfo()).m_oTreasure;
    oTreasure.SetNewUpgradesAvailable(FALSE);
    m_ChoiceGUIData.lstChoices.Remove(0, m_ChoiceGUIData.lstChoices.Length);
    m_ChoiceGUIData.lstChoices.Length = 0;
    foreach m_TechTopChoices(choice, )
    {
        m_ChoiceGUIData.lstChoices.AddItem(choice);
    }
    oGV = BioWorldInfo(GetWorldInfo()).GetGlobalVariables();
    foreach m_TechChoices(TechData, )
    {
        nLevel = BioWorldInfo(GetWorldInfo()).GetGlobalVariables().GetIntByName(TechData.stTech.nmTech);
        if (nLevel <= 0)
        {
            continue;
        }
        TokenizeTechData(TechData, nLevel);
        if (TechData.stTech.nLevels > 1)
        {
            stTech = oTreasure.Tech(TechData.PlotName);
            TechData.ChoiceEntry.sChoiceName = oTreasure.GetTechName(stTech);
        }
        else
        {
            TechData.ChoiceEntry.sChoiceName = string(TechData.stTech.srName);
        }
        TechData.ChoiceEntry.srChoiceTitle = TechData.stTech.srName;
        TechData.ChoiceEntry.srChoiceImageTitle = TechData.stTech.srTitle;
        Class'SFXPlotTreasure'.static.GetTechImageResourcePath(TechData.PlotName, sTechSmallImagePath, sTechLargeImagePath);
        TechData.ChoiceEntry.oChoiceImage = Class'SFXPlotTreasure'.static.FindImage(sTechLargeImagePath);
        TechData.ChoiceEntry.srChoiceDescription = TechData.stTech.srDescription;
        TechData.ChoiceEntry.bDefaultSelection = TechData.TreasureId == oGV.GetInt(nLastUnlockedTech);
        m_ChoiceGUIData.lstChoices.AddItem(TechData.ChoiceEntry);
    }
    m_ChoiceGUIData.m_ShowOptionalPane = FALSE;
    for (i = 1; i < m_ChoiceGUIData.lstChoices.Length; i++)
    {
        for (J = i + 1; J < m_ChoiceGUIData.lstChoices.Length; J++)
        {
            bInOrder = m_ChoiceGUIData.lstChoices[i].sChoiceName <= m_ChoiceGUIData.lstChoices[J].sChoiceName;
            if (!bInOrder)
            {
                choice = m_ChoiceGUIData.lstChoices[i];
                m_ChoiceGUIData.lstChoices[i] = m_ChoiceGUIData.lstChoices[J];
                m_ChoiceGUIData.lstChoices[J] = choice;
            }
        }
    }
    if (m_ChoiceGUIData.lstChoices.Length > 0)
    {
        m_ChoiceGUIData.lstChoices[0].oChoiceImage = Class'SFXPlotTreasure'.static.FindImage(ResearchSubMenus[0].sImagePath);
    }
}
public function SetupTop()
{
    local SFXChoiceEntry choice;
    
    m_ChoiceGUIData.lstChoices.Remove(0, m_ChoiceGUIData.lstChoices.Length);
    m_ChoiceGUIData.lstChoices.Length = 0;
    foreach m_TopLevelChoices(choice, )
    {
        m_ChoiceGUIData.lstChoices.AddItem(choice);
    }
    m_ChoiceGUIData.m_ShowOptionalPane = FALSE;
}
public function SetupTreasureData()
{
    local SFXPlotTreasure oTreasure;
    local int i;
    
    oTreasure = BioWorldInfo(GetWorldInfo()).m_oTreasure;
    for (i = 0; i < m_ChoiceGUIData.Tech.Length; i++)
    {
        m_ChoiceGUIData.Tech[i].stTech = oTreasure.Tech(m_ChoiceGUIData.Tech[i].PlotName);
    }
    for (i = 0; i < m_ChoiceGUIData.Research.Length; i++)
    {
        m_ChoiceGUIData.Research[i].stTech = oTreasure.Tech(m_ChoiceGUIData.Research[i].PlotName);
        m_ChoiceGUIData.Research[i].stTreasure = oTreasure.TREASURE(m_ChoiceGUIData.Research[i].TreasureId);
    }
}
public function ShowErrorMessageBox(stringref srError)
{
    local BioMessageBoxOptionalParams stParams;
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    m_oMsgBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(PC);
    m_oMsgBox.SetInputDelegate(MessageInputPressedError);
    stParams.srAText = srErrorAButton;
    stParams.bNoFade = TRUE;
    m_oMsgBox.DisplayMessageBox(srError, stParams);
    m_bMessageBoxActivated = TRUE;
}
public function ShowResearchMessageBox(STreasure stTreasure, STech stTech)
{
    local BioMessageBoxOptionalParams stParams;
    local BioPlayerController PC;
    
    ClearCustomTokens();
    SetCustomToken(0, string(stTech.srName));
    SetCustomToken(1, string(stTreasure.ResourcePrice));
    switch (stTreasure.Resource)
    {
        case EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO:
            SetCustomToken(2, string(srEezo));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM:
            SetCustomToken(2, string(srIridium));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM:
            SetCustomToken(2, string(srPalladium));
            break;
        case EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM:
            SetCustomToken(2, string(srPlatinum));
            break;
        default:
    }
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    m_oMsgBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(PC);
    m_oMsgBox.SetInputDelegate(MessageInputPressedResearch);
    stParams.srAText = srResearchConfirm;
    stParams.srBText = srResearchCancel;
    stParams.bNoFade = TRUE;
    m_oMsgBox.DisplayMessageBoxEx(string(srResearchConfirmMessage), stParams);
    m_bMessageBoxActivated = TRUE;
}
public function TechChosen();

public function TechMenuChosen();

public function string TokenizeResearchString(int nLevel, stringref srString)
{
    ClearCustomTokens();
    SetCustomToken(0, string(nLevel));
    SetCustomToken(1, string(nLevel * 5));
    SetCustomToken(2, string(nLevel * 10));
    SetCustomToken(3, string(nLevel * 15));
    SetCustomToken(4, string(nLevel * 20));
    SetCustomToken(5, string(nLevel * 25));
    SetCustomToken(6, string(nLevel * 35));
    SetCustomToken(7, string(nLevel * 50));
    return string(srString);
}
public function TokenizeTechData(out TechData Data, int nLevel)
{
    local SFXTokenMapping TokenMapping;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    TokenMapping.TokenId = 0;
    TokenMapping.Data = "" $ nLevel;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 1;
    TokenMapping.Data = "" $ nLevel * 5;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 2;
    TokenMapping.Data = "" $ nLevel * 10;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 3;
    TokenMapping.Data = "" $ nLevel * 15;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 4;
    TokenMapping.Data = "" $ nLevel * 20;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 5;
    TokenMapping.Data = "" $ nLevel * 25;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 6;
    TokenMapping.Data = "" $ nLevel * 35;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 7;
    TokenMapping.Data = "" $ nLevel * 50;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 8;
    TokenMapping.Data = Class'SFXGame'.static.GetSimpleString(Data.stTech.srName);
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 9;
    TokenMapping.Data = string(oWorldInfo.GetGlobalVariables().GetIntByName(Data.stTech.nmTech));
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
    TokenMapping.TokenId = 10;
    TokenMapping.Data = "" $ Data.stTech.nLevels;
    Data.ChoiceEntry.m_mapTokenIDToActual.AddItem(TokenMapping);
}
public function TopLevelChosen();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGameChoiceGUIData_Research Name=ChoiceGUIData
    End Object
    m_ChosenTechData = {
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
                        stTech = {
                                  sImage = "", 
                                  sLargeImage = "", 
                                  nmTech = 'None', 
                                  nmResearch = 'None', 
                                  srTitle = $0, 
                                  srName = $0, 
                                  srMessage = $0, 
                                  srDescription = $0, 
                                  nLevels = 0, 
                                  UnlockId = 0
                                 }, 
                        stTreasure = {
                                      nmLevel = 'None', 
                                      nmTreasure = 'None', 
                                      nmTech = 'None', 
                                      nmRequiredTech = 'None', 
                                      nTreasureId = -1, 
                                      ResourcePrice = 0, 
                                      RequiredTechLevel = 0, 
                                      DiscoverTechLevel = 0, 
                                      bNoAnimation = FALSE, 
                                      bMultiLevel = FALSE, 
                                      Resource = EInventoryResourceTypes.INV_RESOURCE_CREDITS
                                     }, 
                        PlotName = 'None', 
                        TechId = 0, 
                        PlotId = 0, 
                        TreasureId = 0, 
                        UnlockId = 0, 
                        nContextId = 0, 
                        RMode = 0, 
                        DisableId = 0
                       }
    m_ChoiceGUIData = ChoiceGUIData
    srErrorAButton = $335576
    srErrorCanNotAfford = $335577
    srErrorDoNotQualify = $335578
    srErrorKnown = $335579
    srTechNameLabel = $337709
    srResearchConfirmMessage = $335580
    srResearchConfirm = $335585
    srResearchCancel = $335586
    srEezo = $335583
    srPlatinum = $335582
    srPalladium = $335584
    srIridium = $335581
    nLastUnlockedResearch = 579
    nLastUnlockedTech = 580
    srResearchDescription = $348634
    srResearchTokenizedDescriptionPlural = $348635
    srResearchTokenizedDescriptionSingular = $348713
    srResearchTokenizedDescriptionResources = $348714
    srUpgradeTokenizedDescription = $348636
    srTokenizedResearchCategory = $348786
    srTokenizedResearchCategoryCounter = $348787
    srTopLevelAButton = $348807
    bHasTargets = FALSE
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Research", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "No Research", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}