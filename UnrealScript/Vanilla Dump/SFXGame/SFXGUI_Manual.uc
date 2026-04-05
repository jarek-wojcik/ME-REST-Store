Class SFXGUI_Manual extends SFXGUIMovie
    native
    config(UI);

struct native ManualPage 
{
    var biodynamicload string Image;
    var int Id;
    var int Chapter;
    var stringref PageNum;
    var stringref Title;
    var stringref Body;
    var stringref ConsoleBody;
    var transient int ChapterIndex;
};
struct native ManualChapter 
{
    var biodynamicload string Image;
    var transient array<int> PageIndices;
    var Name FncChapterExclusion;
    var int Id;
    var stringref ChapterNum;
    var stringref Title;
    var stringref Body;
    var stringref ConsoleBody;
};
struct native ManualCategory 
{
    var array<int> Chapters;
    var transient array<int> ChapterIndices;
};
struct native ManualListItem 
{
    var string sName;
    var string sListTag;
    var int nIndex;
    var int nID;
};

var config ManualCategory Category1;
var config ManualCategory Category2;
var config ManualCategory Category3;
var config array<ManualChapter> Chapters;
var config array<ManualPage> Pages;
var transient array<int> m_aCurrentChapterIndicies;
var config stringref TitleText;
var config stringref ExitText;
var config stringref BackText;
var config stringref CloseSubListText;
var config stringref Tab1Text;
var config stringref Tab2Text;
var config stringref Tab3Text;
var config stringref ViewText;
var config stringref ContinueText;
var transient int m_nCurrentChapterIndex;
var transient int m_nCurrentTab;
var config transient int KinectStartTabOverride;
var config transient int KinectStartChapterOverride;
var transient int m_nStartTabOverride;
var transient int m_nStartChapterOverride;
var transient bool m_bInitialized;
var transient bool m_bOpenedFromMainMenu;

public final event function AS_AddListItems(array<ManualListItem> aItems)
{
    ActionScriptVoid("mcGUI.AddListItems");
}
public final event function AS_EndDisplayList(int nLastEntryID)
{
    ActionScriptVoid("mcGUI.EndDisplayList");
}
public final event function AS_ScrollDetailsAnalog(float fScroll)
{
    ActionScriptVoid("mcGUI.scrollDetailsAnalog");
}
public final event function AS_SetDetails(string sInfo, string sImgResource)
{
    ActionScriptVoid("mcGUI.SetDetails");
}
public final event function AS_SetSubItems(array<ManualListItem> aSubItems)
{
    ActionScriptVoid("mcGUI.SetSubItems");
}
public final event function AS_SetUnreadItemCounts(int nQuestPrimary, int nQuestSecondary, int nCodexPrimary, int nCodexSecondary)
{
    ActionScriptVoid("mcGUI.SetUnreadItemCounts");
}
public final event function AS_SetupVisualState(int nForceTab)
{
    ActionScriptVoid("mcGUI.setupVisualState");
}
public final event function AS_ShowFullScreenController()
{
    ActionScriptVoid("mcGUI.ShowFullScreenController");
}
public final event function AS_StartDisplayList(const string sLabel, const string sTitle, int nListLen)
{
    ActionScriptVoid("mcGUI.StartDisplayList");
}
public final native function bool CallScriptExclusionFunction(Name Fnc);

public final function ExExpandEntry()
{
    local int nPageIndex;
    local array<ManualListItem> aListItems;
    local ManualListItem NewItem;
    
    foreach Chapters[m_nCurrentChapterIndex].PageIndices(nPageIndex, )
    {
        if (nPageIndex != -1)
        {
            NewItem.nIndex = aListItems.Length;
            NewItem.nID = nPageIndex;
            NewItem.sName = UIStrRef(Pages[nPageIndex].Title);
            NewItem.sListTag = UIStrRef(Pages[nPageIndex].PageNum);
            aListItems.AddItem(NewItem);
        }
    }
    AS_SetSubItems(aListItems);
}
public final function ExFocusOnSubentry(int nPageIndex)
{
    local stringref srBody;
    local string sImage;
    
    srBody = Pages[nPageIndex].Body;
    if (oWorldInfo.IsConsoleBuild(0))
    {
        if (Pages[nPageIndex].ConsoleBody != 0)
        {
            srBody = Pages[nPageIndex].ConsoleBody;
        }
    }
    sImage = Pages[nPageIndex].Image;
    if (sImage == "" && Pages[nPageIndex].ChapterIndex != -1)
    {
        sImage = Chapters[Pages[nPageIndex].ChapterIndex].Image;
    }
    AS_SetDetails(UIStrRef(srBody), sImage);
}
public final function ExFocusOnTab(int nTab)
{
    m_nCurrentTab = nTab;
    switch (nTab)
    {
        case 1:
            DisplayManualChapters(Category1.ChapterIndices, m_nStartChapterOverride);
            break;
        case 2:
            DisplayManualChapters(Category2.ChapterIndices, m_nStartChapterOverride);
            break;
        case 3:
            DisplayManualChapters(Category3.ChapterIndices, m_nStartChapterOverride);
            break;
        default:
    }
    ResetStartupOverrides();
}
public final function ExInitializeJournal()
{
    CheckInitializeData();
    if (oWorldInfo.IsConsoleBuild(0) && !HasStartupOverride())
    {
        AS_ShowFullScreenController();
    }
    AS_SetupVisualState(m_nStartTabOverride > -1 ? m_nStartTabOverride : 1);
    AS_SetUnreadItemCounts(0, 0, 0, 0);
}
public final function ExSetLastEntry(int nListIndex)
{
    local stringref srBody;
    
    m_nCurrentChapterIndex = m_aCurrentChapterIndicies[nListIndex];
    srBody = Chapters[m_nCurrentChapterIndex].Body;
    if (oWorldInfo.IsConsoleBuild(0))
    {
        if (Chapters[m_nCurrentChapterIndex].ConsoleBody != 0)
        {
            srBody = Chapters[m_nCurrentChapterIndex].ConsoleBody;
        }
    }
    AS_SetDetails(UIStrRef(srBody), Chapters[m_nCurrentChapterIndex].Image);
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            AS_ScrollDetailsAnalog(fValue);
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public event function OnStart()
{
    CheckInitializeData();
}
public final native function bool ShouldRemoveKinectManualChapter();

public final function CheckInitializeData()
{
    local int nChapter;
    local int nPage;
    
    if (m_bInitialized)
    {
        return;
    }
    Category1.ChapterIndices = GetChapterIndices(Category1.Chapters);
    Category2.ChapterIndices = GetChapterIndices(Category2.Chapters);
    Category3.ChapterIndices = GetChapterIndices(Category3.Chapters);
    for (nPage = 0; nPage < Pages.Length; ++nPage)
    {
        for (nChapter = 0; nChapter < Chapters.Length; ++nChapter)
        {
            if (Chapters[nChapter].Id == Pages[nPage].Chapter)
            {
                Chapters[nChapter].PageIndices.AddItem(nPage);
                Pages[nPage].ChapterIndex = nChapter;
            }
        }
    }
    m_bInitialized = TRUE;
}
public final function DisplayManualChapters(const array<int> aChapterIndices, optional int nSelectChapterId = -1)
{
    local array<ManualListItem> aListItems;
    local ManualListItem NewItem;
    local int nIndex;
    local int nChapterIndex;
    local int displayId;
    
    m_aCurrentChapterIndicies.Length = 0;
    displayId = 0;
    for (nIndex = 0; nIndex < aChapterIndices.Length; ++nIndex)
    {
        nChapterIndex = aChapterIndices[nIndex];
        if (nChapterIndex != -1)
        {
            NewItem.nIndex = aListItems.Length;
            NewItem.nID = Chapters[nChapterIndex].Id;
            if (NewItem.nID == nSelectChapterId)
            {
                displayId = nSelectChapterId;
            }
            NewItem.sName = UIStrRef(Chapters[nChapterIndex].Title);
            NewItem.sListTag = UIStrRef(Chapters[nChapterIndex].ChapterNum);
            aListItems.AddItem(NewItem);
            m_aCurrentChapterIndicies.AddItem(nChapterIndex);
        }
    }
    if (displayId == 0)
    {
        displayId = aListItems[0].nID;
    }
    AS_StartDisplayList("", "", aListItems.Length);
    AS_AddListItems(aListItems);
    AS_EndDisplayList(displayId);
}
public final function array<int> GetChapterIndices(array<int> ChapterIDs)
{
    local array<int> Indices;
    local int nIndex1;
    local int nIndex2;
    
    Indices.Length = ChapterIDs.Length;
    for (nIndex1 = 0; nIndex1 < ChapterIDs.Length; ++nIndex1)
    {
        Indices[nIndex1] = -1;
        for (nIndex2 = 0; nIndex2 < Chapters.Length; ++nIndex2)
        {
            if (Chapters[nIndex2].FncChapterExclusion != 'None' && CallScriptExclusionFunction(Chapters[nIndex2].FncChapterExclusion))
            {
                continue;
            }
            if (Chapters[nIndex2].Id == ChapterIDs[nIndex1])
            {
                Indices[nIndex1] = nIndex2;
                break;
            }
        }
    }
    return Indices;
}
public final function bool HasStartupOverride()
{
    return m_nStartTabOverride != -1 || m_nStartChapterOverride != -1;
}
public final function ResetStartupOverrides()
{
    m_nStartTabOverride = -1;
    m_nStartChapterOverride = -1;
}
public function ReturnToBrowser()
{
    if (m_bOpenedFromMainMenu)
    {
        GetSFXUIController().ShowMainMenu(GetPC());
    }
    Close();
}
public final function SetFromMainMenu()
{
    m_bOpenedFromMainMenu = TRUE;
    GetSFXUIController().HideMainMenu(FALSE, GetPC());
}
public final function StartOnKinectChapter()
{
    m_nStartTabOverride = KinectStartTabOverride;
    m_nStartChapterOverride = KinectStartChapterOverride;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Category1 = {
                 Chapters = (1, 
                             2, 
                             3, 
                             4, 
                             5, 
                             6, 
                             7, 
                             8, 
                             9, 
                             10, 
                             11, 
                             12
                            ), 
                 ChapterIndices = ()
                }
    Category2 = {
                 Chapters = (19, 
                             20, 
                             21, 
                             22, 
                             23, 
                             24, 
                             25, 
                             26, 
                             27, 
                             28
                            ), 
                 ChapterIndices = ()
                }
    Category3 = {
                 Chapters = (14, 15, 16, 17, 18), 
                 ChapterIndices = ()
                }
    Chapters = ({
                 Image = "GUI_GameManual.SP_MainMenu_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 1, 
                 ChapterNum = $174566, 
                 Title = $719674, 
                 Body = $719694, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_CharCreation_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 2, 
                 ChapterNum = $174567, 
                 Title = $719675, 
                 Body = $719725, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_MissionComputer_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 3, 
                 ChapterNum = $174568, 
                 Title = $719678, 
                 Body = $721051, 
                 ConsoleBody = $719733
                }, 
                {
                 Image = "GUI_GameManual.SP_SquadScreen_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 4, 
                 ChapterNum = $174569, 
                 Title = $721053, 
                 Body = $719734, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_Journal_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 5, 
                 ChapterNum = $174570, 
                 Title = $721054, 
                 Body = $722291, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_GeneralHUD_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 6, 
                 ChapterNum = $174571, 
                 Title = $719829, 
                 Body = $722293, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_BasicControls_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 7, 
                 ChapterNum = $174572, 
                 Title = $721707, 
                 Body = $722686, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_LowCover_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 8, 
                 ChapterNum = $174573, 
                 Title = $719828, 
                 Body = $722395, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_SquadCommand_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 9, 
                 ChapterNum = $174574, 
                 Title = $721723, 
                 Body = $722688, 
                 ConsoleBody = $721320
                }, 
                {
                 Image = "GUI_GameManual.SP_SquadScreen_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 10, 
                 ChapterNum = $723086, 
                 Title = $721728, 
                 Body = $722689, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_WeaponLoadout_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 11, 
                 ChapterNum = $723087, 
                 Title = $721731, 
                 Body = $722690, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.SP_GMGalaxy_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 12, 
                 ChapterNum = $723088, 
                 Title = $721744, 
                 Body = $722584, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.Tips_Action_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 14, 
                 ChapterNum = $174566, 
                 Title = $721761, 
                 Body = $722680, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.Tips_GenericAction_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 15, 
                 ChapterNum = $174567, 
                 Title = $721765, 
                 Body = $722681, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.Tips_Powers_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 16, 
                 ChapterNum = $174568, 
                 Title = $721763, 
                 Body = $722682, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.Tips_Combat_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 17, 
                 ChapterNum = $174569, 
                 Title = $721762, 
                 Body = $722683, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.Tips_Help_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 18, 
                 ChapterNum = $174570, 
                 Title = $721767, 
                 Body = $722684, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_GalaxyAtWar_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 19, 
                 ChapterNum = $174566, 
                 Title = $611521, 
                 Body = $723410, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_MainMenu_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 20, 
                 ChapterNum = $174567, 
                 Title = $723400, 
                 Body = $723389, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_GameCreation_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 21, 
                 ChapterNum = $174568, 
                 Title = $723092, 
                 Body = $723431, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_Missions_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 22, 
                 ChapterNum = $174569, 
                 Title = $724484, 
                 Body = $724485, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_Lobby_Xbox_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 23, 
                 ChapterNum = $174570, 
                 Title = $723093, 
                 Body = $723447, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_ClassKit_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 24, 
                 ChapterNum = $174571, 
                 Title = $723095, 
                 Body = $724400, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_InsideReinforcementPack_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 25, 
                 ChapterNum = $174572, 
                 Title = $723096, 
                 Body = $724476, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_BasicControls_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 26, 
                 ChapterNum = $174573, 
                 Title = $721707, 
                 Body = $722686, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_Cover_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 27, 
                 ChapterNum = $174574, 
                 Title = $719828, 
                 Body = $722395, 
                 ConsoleBody = $0
                }, 
                {
                 Image = "GUI_GameManual.MP_HUD1_512x256", 
                 PageIndices = (), 
                 FncChapterExclusion = 'None', 
                 Id = 28, 
                 ChapterNum = $723086, 
                 Title = $719829, 
                 Body = $724632, 
                 ConsoleBody = $0
                }
               )
    Pages = ({
              Image = "", 
              Id = 10, 
              Chapter = 1, 
              PageNum = $719624, 
              Title = $341858, 
              Body = $719695, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 11, 
              Chapter = 1, 
              PageNum = $719625, 
              Title = $156620, 
              Body = $719711, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 12, 
              Chapter = 1, 
              PageNum = $719626, 
              Title = $506692, 
              Body = $719713, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 13, 
              Chapter = 1, 
              PageNum = $719627, 
              Title = $156621, 
              Body = $719717, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 14, 
              Chapter = 1, 
              PageNum = $719628, 
              Title = $724571, 
              Body = $724805, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 15, 
              Chapter = 1, 
              PageNum = $719629, 
              Title = $344566, 
              Body = $722042, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 20, 
              Chapter = 2, 
              PageNum = $719633, 
              Title = $719685, 
              Body = $719726, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 21, 
              Chapter = 2, 
              PageNum = $719634, 
              Title = $719686, 
              Body = $719724, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 22, 
              Chapter = 2, 
              PageNum = $719635, 
              Title = $719687, 
              Body = $719728, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 23, 
              Chapter = 2, 
              PageNum = $719636, 
              Title = $722203, 
              Body = $722949, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 30, 
              Chapter = 3, 
              PageNum = $719642, 
              Title = $721757, 
              Body = $719734, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 31, 
              Chapter = 3, 
              PageNum = $719643, 
              Title = $721758, 
              Body = $719811, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 32, 
              Chapter = 3, 
              PageNum = $719644, 
              Title = $721759, 
              Body = $722220, 
              ConsoleBody = $722219, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 33, 
              Chapter = 3, 
              PageNum = $719645, 
              Title = $721760, 
              Body = $719813, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 34, 
              Chapter = 3, 
              PageNum = $719646, 
              Title = $719692, 
              Body = $719823, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "GUI_GameManual.SP_Squad_512x256", 
              Id = 40, 
              Chapter = 4, 
              PageNum = $719651, 
              Title = $721055, 
              Body = $722229, 
              ConsoleBody = $722228, 
              ChapterIndex = 0
             }, 
             {
              Image = "GUI_GameManual.SP_SquadScreen_512x256", 
              Id = 41, 
              Chapter = 4, 
              PageNum = $719652, 
              Title = $721056, 
              Body = $722231, 
              ConsoleBody = $722232, 
              ChapterIndex = 0
             }, 
             {
              Image = "GUI_GameManual.SP_PowerUpgrade_512x256", 
              Id = 42, 
              Chapter = 4, 
              PageNum = $719653, 
              Title = $721057, 
              Body = $722285, 
              ConsoleBody = $722286, 
              ChapterIndex = 0
             }, 
             {
              Image = "GUI_GameManual.SP_SquadScreen_512x256", 
              Id = 43, 
              Chapter = 4, 
              PageNum = $719654, 
              Title = $721058, 
              Body = $722287, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 50, 
              Chapter = 5, 
              PageNum = $719660, 
              Title = $721060, 
              Body = $722292, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 51, 
              Chapter = 5, 
              PageNum = $719661, 
              Title = $721061, 
              Body = $721062, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 60, 
              Chapter = 6, 
              PageNum = $721007, 
              Title = $721063, 
              Body = $722294, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 61, 
              Chapter = 6, 
              PageNum = $721008, 
              Title = $721064, 
              Body = $722295, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 62, 
              Chapter = 6, 
              PageNum = $721009, 
              Title = $721065, 
              Body = $722296, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 63, 
              Chapter = 6, 
              PageNum = $721010, 
              Title = $721066, 
              Body = $722297, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 64, 
              Chapter = 6, 
              PageNum = $721011, 
              Title = $721067, 
              Body = $722298, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 70, 
              Chapter = 7, 
              PageNum = $721016, 
              Title = $721708, 
              Body = $722318, 
              ConsoleBody = $722319, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 71, 
              Chapter = 7, 
              PageNum = $721017, 
              Title = $643404, 
              Body = $722320, 
              ConsoleBody = $722321, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 72, 
              Chapter = 7, 
              PageNum = $721018, 
              Title = $724628, 
              Body = $724629, 
              ConsoleBody = $724630, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 73, 
              Chapter = 7, 
              PageNum = $721019, 
              Title = $721709, 
              Body = $722324, 
              ConsoleBody = $722325, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 74, 
              Chapter = 7, 
              PageNum = $721020, 
              Title = $722394, 
              Body = $722331, 
              ConsoleBody = $722330, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 75, 
              Chapter = 7, 
              PageNum = $721021, 
              Title = $721733, 
              Body = $722332, 
              ConsoleBody = $722333, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 76, 
              Chapter = 7, 
              PageNum = $721022, 
              Title = $721728, 
              Body = $722687, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 77, 
              Chapter = 7, 
              PageNum = $721023, 
              Title = $721711, 
              Body = $722328, 
              ConsoleBody = $722329, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 78, 
              Chapter = 7, 
              PageNum = $721024, 
              Title = $721712, 
              Body = $722322, 
              ConsoleBody = $722323, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 79, 
              Chapter = 7, 
              PageNum = $724631, 
              Title = $721713, 
              Body = $722326, 
              ConsoleBody = $722327, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 80, 
              Chapter = 8, 
              PageNum = $721025, 
              Title = $721714, 
              Body = $722398, 
              ConsoleBody = $722397, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 81, 
              Chapter = 8, 
              PageNum = $721026, 
              Title = $721721, 
              Body = $722413, 
              ConsoleBody = $722414, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 82, 
              Chapter = 8, 
              PageNum = $721027, 
              Title = $721722, 
              Body = $722415, 
              ConsoleBody = $722416, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 83, 
              Chapter = 8, 
              PageNum = $721028, 
              Title = $721716, 
              Body = $722401, 
              ConsoleBody = $722402, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 84, 
              Chapter = 8, 
              PageNum = $721029, 
              Title = $721715, 
              Body = $722403, 
              ConsoleBody = $722404, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 85, 
              Chapter = 8, 
              PageNum = $721030, 
              Title = $721717, 
              Body = $722405, 
              ConsoleBody = $722406, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 86, 
              Chapter = 8, 
              PageNum = $721031, 
              Title = $721718, 
              Body = $722407, 
              ConsoleBody = $722408, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 87, 
              Chapter = 8, 
              PageNum = $721032, 
              Title = $721719, 
              Body = $722409, 
              ConsoleBody = $722410, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 88, 
              Chapter = 8, 
              PageNum = $721033, 
              Title = $721720, 
              Body = $722411, 
              ConsoleBody = $722412, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 90, 
              Chapter = 9, 
              PageNum = $721034, 
              Title = $721724, 
              Body = $722373, 
              ConsoleBody = $722379, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 91, 
              Chapter = 9, 
              PageNum = $721035, 
              Title = $721726, 
              Body = $722375, 
              ConsoleBody = $722381, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 92, 
              Chapter = 9, 
              PageNum = $721036, 
              Title = $721727, 
              Body = $722376, 
              ConsoleBody = $722382, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 93, 
              Chapter = 9, 
              PageNum = $721037, 
              Title = $722378, 
              Body = $722377, 
              ConsoleBody = $722383, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 100, 
              Chapter = 10, 
              PageNum = $722916, 
              Title = $721729, 
              Body = $722334, 
              ConsoleBody = $722335, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 101, 
              Chapter = 10, 
              PageNum = $722917, 
              Title = $721730, 
              Body = $722371, 
              ConsoleBody = $722372, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 102, 
              Chapter = 10, 
              PageNum = $723459, 
              Title = $722662, 
              Body = $724785, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 200, 
              Chapter = 11, 
              PageNum = $722918, 
              Title = $722394, 
              Body = $722331, 
              ConsoleBody = $722330, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 201, 
              Chapter = 11, 
              PageNum = $722919, 
              Title = $724260, 
              Body = $724261, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 202, 
              Chapter = 11, 
              PageNum = $722920, 
              Title = $721735, 
              Body = $722437, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 203, 
              Chapter = 11, 
              PageNum = $722921, 
              Title = $721736, 
              Body = $722438, 
              ConsoleBody = $722439, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 204, 
              Chapter = 11, 
              PageNum = $722922, 
              Title = $721737, 
              Body = $722440, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 205, 
              Chapter = 11, 
              PageNum = $724262, 
              Title = $721738, 
              Body = $722441, 
              ConsoleBody = $722442, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 206, 
              Chapter = 11, 
              PageNum = $724263, 
              Title = $721740, 
              Body = $722444, 
              ConsoleBody = $722445, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 207, 
              Chapter = 11, 
              PageNum = $724264, 
              Title = $721741, 
              Body = $722446, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 208, 
              Chapter = 11, 
              PageNum = $724265, 
              Title = $721742, 
              Body = $722447, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 209, 
              Chapter = 11, 
              PageNum = $724266, 
              Title = $721743, 
              Body = $722459, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 210, 
              Chapter = 11, 
              PageNum = $724267, 
              Title = $722448, 
              Body = $722460, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 211, 
              Chapter = 11, 
              PageNum = $724268, 
              Title = $722449, 
              Body = $722461, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 300, 
              Chapter = 12, 
              PageNum = $722923, 
              Title = $721745, 
              Body = $722585, 
              ConsoleBody = $722586, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 301, 
              Chapter = 12, 
              PageNum = $722924, 
              Title = $721746, 
              Body = $722610, 
              ConsoleBody = $722611, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 302, 
              Chapter = 12, 
              PageNum = $722925, 
              Title = $721752, 
              Body = $722615, 
              ConsoleBody = $722616, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 303, 
              Chapter = 12, 
              PageNum = $722926, 
              Title = $721748, 
              Body = $722617, 
              ConsoleBody = $722618, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 304, 
              Chapter = 12, 
              PageNum = $722927, 
              Title = $721749, 
              Body = $722619, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 305, 
              Chapter = 12, 
              PageNum = $722928, 
              Title = $722620, 
              Body = $722622, 
              ConsoleBody = $722623, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 306, 
              Chapter = 12, 
              PageNum = $722929, 
              Title = $721751, 
              Body = $722624, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 307, 
              Chapter = 12, 
              PageNum = $724473, 
              Title = $721750, 
              Body = $722625, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 500, 
              Chapter = 14, 
              PageNum = $719624, 
              Title = $722649, 
              Body = $720238, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 501, 
              Chapter = 14, 
              PageNum = $719625, 
              Title = $722650, 
              Body = $722007, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 502, 
              Chapter = 14, 
              PageNum = $719626, 
              Title = $722651, 
              Body = $720214, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 503, 
              Chapter = 14, 
              PageNum = $719627, 
              Title = $722652, 
              Body = $720794, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 504, 
              Chapter = 14, 
              PageNum = $719628, 
              Title = $722653, 
              Body = $721605, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 505, 
              Chapter = 14, 
              PageNum = $719629, 
              Title = $722654, 
              Body = $720231, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 506, 
              Chapter = 14, 
              PageNum = $719630, 
              Title = $722655, 
              Body = $720223, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 507, 
              Chapter = 14, 
              PageNum = $719631, 
              Title = $722656, 
              Body = $720211, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 508, 
              Chapter = 14, 
              PageNum = $719632, 
              Title = $722657, 
              Body = $720244, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 600, 
              Chapter = 15, 
              PageNum = $719633, 
              Title = $547072, 
              Body = $720235, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 601, 
              Chapter = 15, 
              PageNum = $719634, 
              Title = $549712, 
              Body = $720230, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 602, 
              Chapter = 15, 
              PageNum = $719635, 
              Title = $549708, 
              Body = $720229, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 603, 
              Chapter = 15, 
              PageNum = $719636, 
              Title = $549706, 
              Body = $720226, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 604, 
              Chapter = 15, 
              PageNum = $719637, 
              Title = $547070, 
              Body = $720232, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 605, 
              Chapter = 15, 
              PageNum = $719638, 
              Title = $360543, 
              Body = $720233, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 606, 
              Chapter = 15, 
              PageNum = $719639, 
              Title = $168818, 
              Body = $720240, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 607, 
              Chapter = 15, 
              PageNum = $719640, 
              Title = $158747, 
              Body = $720242, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 608, 
              Chapter = 15, 
              PageNum = $719641, 
              Title = $549703, 
              Body = $720241, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 609, 
              Chapter = 15, 
              PageNum = $722691, 
              Title = $547071, 
              Body = $720234, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 610, 
              Chapter = 15, 
              PageNum = $722692, 
              Title = $549707, 
              Body = $720227, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 611, 
              Chapter = 15, 
              PageNum = $722693, 
              Title = $547076, 
              Body = $720236, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 612, 
              Chapter = 15, 
              PageNum = $722694, 
              Title = $547074, 
              Body = $720237, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 613, 
              Chapter = 15, 
              PageNum = $722695, 
              Title = $549710, 
              Body = $720228, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 700, 
              Chapter = 16, 
              PageNum = $719642, 
              Title = $722668, 
              Body = $720224, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 701, 
              Chapter = 16, 
              PageNum = $719643, 
              Title = $722674, 
              Body = $720221, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 702, 
              Chapter = 16, 
              PageNum = $719644, 
              Title = $722660, 
              Body = $720209, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 703, 
              Chapter = 16, 
              PageNum = $719645, 
              Title = $722661, 
              Body = $720245, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 704, 
              Chapter = 16, 
              PageNum = $719646, 
              Title = $722662, 
              Body = $724785, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 705, 
              Chapter = 16, 
              PageNum = $719647, 
              Title = $722663, 
              Body = $720210, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 706, 
              Chapter = 16, 
              PageNum = $719648, 
              Title = $722664, 
              Body = $720222, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 707, 
              Chapter = 16, 
              PageNum = $719649, 
              Title = $722665, 
              Body = $720239, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 708, 
              Chapter = 16, 
              PageNum = $719650, 
              Title = $722666, 
              Body = $720243, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 709, 
              Chapter = 16, 
              PageNum = $722696, 
              Title = $722667, 
              Body = $720217, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 800, 
              Chapter = 17, 
              PageNum = $719651, 
              Title = $722668, 
              Body = $720224, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 801, 
              Chapter = 17, 
              PageNum = $719652, 
              Title = $722674, 
              Body = $720221, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 802, 
              Chapter = 17, 
              PageNum = $719653, 
              Title = $722669, 
              Body = $720220, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 803, 
              Chapter = 17, 
              PageNum = $719654, 
              Title = $722670, 
              Body = $720215, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 804, 
              Chapter = 17, 
              PageNum = $719655, 
              Title = $722671, 
              Body = $720246, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 805, 
              Chapter = 17, 
              PageNum = $719656, 
              Title = $722672, 
              Body = $720212, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 806, 
              Chapter = 17, 
              PageNum = $719657, 
              Title = $722673, 
              Body = $720218, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 807, 
              Chapter = 17, 
              PageNum = $719658, 
              Title = $722675, 
              Body = $720213, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 808, 
              Chapter = 17, 
              PageNum = $719659, 
              Title = $722676, 
              Body = $720216, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 809, 
              Chapter = 17, 
              PageNum = $722697, 
              Title = $722677, 
              Body = $720219, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 810, 
              Chapter = 17, 
              PageNum = $722698, 
              Title = $722678, 
              Body = $720217, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 900, 
              Chapter = 18, 
              PageNum = $719660, 
              Title = $721767, 
              Body = $722684, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1000, 
              Chapter = 19, 
              PageNum = $719624, 
              Title = $723412, 
              Body = $723419, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1001, 
              Chapter = 19, 
              PageNum = $719625, 
              Title = $723413, 
              Body = $723417, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1002, 
              Chapter = 19, 
              PageNum = $719626, 
              Title = $723414, 
              Body = $723421, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1003, 
              Chapter = 19, 
              PageNum = $719627, 
              Title = $723415, 
              Body = $723422, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1004, 
              Chapter = 19, 
              PageNum = $719628, 
              Title = $723416, 
              Body = $723423, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1100, 
              Chapter = 20, 
              PageNum = $719633, 
              Title = $578297, 
              Body = $723391, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1101, 
              Chapter = 20, 
              PageNum = $719634, 
              Title = $616765, 
              Body = $723393, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1102, 
              Chapter = 20, 
              PageNum = $719635, 
              Title = $591330, 
              Body = $723395, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1103, 
              Chapter = 20, 
              PageNum = $719636, 
              Title = $591333, 
              Body = $723397, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1104, 
              Chapter = 20, 
              PageNum = $719637, 
              Title = $682953, 
              Body = $723443, 
              ConsoleBody = $724687, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1200, 
              Chapter = 21, 
              PageNum = $719642, 
              Title = $683884, 
              Body = $723429, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1201, 
              Chapter = 21, 
              PageNum = $719643, 
              Title = $681602, 
              Body = $723421, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1202, 
              Chapter = 21, 
              PageNum = $719644, 
              Title = $681603, 
              Body = $723422, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1203, 
              Chapter = 21, 
              PageNum = $719645, 
              Title = $681604, 
              Body = $723423, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1204, 
              Chapter = 21, 
              PageNum = $719646, 
              Title = $724496, 
              Body = $724497, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1300, 
              Chapter = 22, 
              PageNum = $719651, 
              Title = $724486, 
              Body = $724487, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1301, 
              Chapter = 22, 
              PageNum = $719652, 
              Title = $724488, 
              Body = $724489, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1302, 
              Chapter = 22, 
              PageNum = $719653, 
              Title = $724492, 
              Body = $724493, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1303, 
              Chapter = 22, 
              PageNum = $719654, 
              Title = $724494, 
              Body = $724495, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1400, 
              Chapter = 23, 
              PageNum = $719660, 
              Title = $682954, 
              Body = $723436, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1401, 
              Chapter = 23, 
              PageNum = $719661, 
              Title = $723453, 
              Body = $723454, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1402, 
              Chapter = 23, 
              PageNum = $719662, 
              Title = $723434, 
              Body = $723437, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1403, 
              Chapter = 23, 
              PageNum = $719663, 
              Title = $592436, 
              Body = $723438, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1404, 
              Chapter = 23, 
              PageNum = $719664, 
              Title = $682956, 
              Body = $723439, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1405, 
              Chapter = 23, 
              PageNum = $719665, 
              Title = $591331, 
              Body = $723440, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1406, 
              Chapter = 23, 
              PageNum = $719666, 
              Title = $656070, 
              Body = $723441, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1407, 
              Chapter = 23, 
              PageNum = $719667, 
              Title = $660462, 
              Body = $723442, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1408, 
              Chapter = 23, 
              PageNum = $719668, 
              Title = $682953, 
              Body = $723443, 
              ConsoleBody = $724687, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1409, 
              Chapter = 23, 
              PageNum = $723455, 
              Title = $591513, 
              Body = $723444, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1410, 
              Chapter = 23, 
              PageNum = $723456, 
              Title = $592439, 
              Body = $723445, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1411, 
              Chapter = 23, 
              PageNum = $723457, 
              Title = $724498, 
              Body = $724499, 
              ConsoleBody = $724500, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1412, 
              Chapter = 23, 
              PageNum = $723458, 
              Title = $592437, 
              Body = $723446, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1500, 
              Chapter = 24, 
              PageNum = $721007, 
              Title = $723448, 
              Body = $724397, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1501, 
              Chapter = 24, 
              PageNum = $721008, 
              Title = $723449, 
              Body = $724398, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1502, 
              Chapter = 24, 
              PageNum = $721009, 
              Title = $724509, 
              Body = $724399, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1600, 
              Chapter = 25, 
              PageNum = $721016, 
              Title = $591331, 
              Body = $724477, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1601, 
              Chapter = 25, 
              PageNum = $721017, 
              Title = $723450, 
              Body = $724478, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1602, 
              Chapter = 25, 
              PageNum = $721018, 
              Title = $723451, 
              Body = $724479, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1603, 
              Chapter = 25, 
              PageNum = $721019, 
              Title = $688844, 
              Body = $724480, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1604, 
              Chapter = 25, 
              PageNum = $721020, 
              Title = $619732, 
              Body = $724481, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1605, 
              Chapter = 25, 
              PageNum = $721021, 
              Title = $723452, 
              Body = $724482, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1606, 
              Chapter = 25, 
              PageNum = $721022, 
              Title = $708438, 
              Body = $724483, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1700, 
              Chapter = 26, 
              PageNum = $721025, 
              Title = $721708, 
              Body = $722318, 
              ConsoleBody = $722319, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1701, 
              Chapter = 26, 
              PageNum = $721026, 
              Title = $643404, 
              Body = $722320, 
              ConsoleBody = $722321, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1702, 
              Chapter = 26, 
              PageNum = $721027, 
              Title = $724628, 
              Body = $724629, 
              ConsoleBody = $724630, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1703, 
              Chapter = 26, 
              PageNum = $721028, 
              Title = $721709, 
              Body = $722324, 
              ConsoleBody = $722325, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1704, 
              Chapter = 26, 
              PageNum = $721029, 
              Title = $722394, 
              Body = $722331, 
              ConsoleBody = $722330, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1705, 
              Chapter = 26, 
              PageNum = $721030, 
              Title = $721728, 
              Body = $722687, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1706, 
              Chapter = 26, 
              PageNum = $721031, 
              Title = $721711, 
              Body = $722328, 
              ConsoleBody = $722329, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1707, 
              Chapter = 26, 
              PageNum = $721032, 
              Title = $721712, 
              Body = $722322, 
              ConsoleBody = $722323, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1708, 
              Chapter = 26, 
              PageNum = $721033, 
              Title = $721713, 
              Body = $722326, 
              ConsoleBody = $722327, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1800, 
              Chapter = 27, 
              PageNum = $721034, 
              Title = $721714, 
              Body = $722398, 
              ConsoleBody = $722397, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1801, 
              Chapter = 27, 
              PageNum = $721035, 
              Title = $721721, 
              Body = $722413, 
              ConsoleBody = $722414, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1802, 
              Chapter = 27, 
              PageNum = $721036, 
              Title = $721722, 
              Body = $722415, 
              ConsoleBody = $722416, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1803, 
              Chapter = 27, 
              PageNum = $721037, 
              Title = $721716, 
              Body = $722401, 
              ConsoleBody = $722402, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1804, 
              Chapter = 27, 
              PageNum = $721038, 
              Title = $721715, 
              Body = $722403, 
              ConsoleBody = $722404, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1805, 
              Chapter = 27, 
              PageNum = $721039, 
              Title = $721717, 
              Body = $722405, 
              ConsoleBody = $722406, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1806, 
              Chapter = 27, 
              PageNum = $721040, 
              Title = $721718, 
              Body = $722407, 
              ConsoleBody = $722408, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1807, 
              Chapter = 27, 
              PageNum = $721041, 
              Title = $721719, 
              Body = $722409, 
              ConsoleBody = $722410, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1808, 
              Chapter = 27, 
              PageNum = $721042, 
              Title = $721720, 
              Body = $722411, 
              ConsoleBody = $722412, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1900, 
              Chapter = 28, 
              PageNum = $722916, 
              Title = $721063, 
              Body = $722294, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1901, 
              Chapter = 28, 
              PageNum = $722917, 
              Title = $721064, 
              Body = $722295, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1902, 
              Chapter = 28, 
              PageNum = $723459, 
              Title = $721065, 
              Body = $722296, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1903, 
              Chapter = 28, 
              PageNum = $723460, 
              Title = $721066, 
              Body = $722297, 
              ConsoleBody = $0, 
              ChapterIndex = 0
             }, 
             {
              Image = "", 
              Id = 1904, 
              Chapter = 28, 
              PageNum = $723461, 
              Title = $724948, 
              Body = $724947, 
              ConsoleBody = $724946, 
              ChapterIndex = 0
             }
            )
    TitleText = $387214
    ExitText = $529360
    BackText = $103236
    CloseSubListText = $163668
    Tab1Text = $721052
    Tab2Text = $721647
    Tab3Text = $719834
    ViewText = $244393
    ContinueText = $163589
    KinectStartTabOverride = 1
    KinectStartChapterOverride = 13
    m_nStartTabOverride = -1
    m_nStartChapterOverride = -1
    m_bFocusOnStart = TRUE
    m_bHandleKeyPresses = TRUE
    m_bRequiresUIWorld = TRUE
    m_bApplyRightThumbstickDeadzone = TRUE
}