Class SFXGUI_JournalCodex extends SFXGUIMovie
    native
    config(UI);

struct native CodexImageDetails 
{
    var biodynamicload string sName;
    var int nID;
    var Texture2D oTexture;
};
struct native JCUIListItem 
{
    var string sName;
    var int nIndex;
    var int nID;
    var bool bComplete;
    var bool bUpdated;
    var bool bHasSubItems;
};
struct native JCEntry extends JCItem 
{
    var native Pointer pCodexEntry;
    var int nQuestAdded;
    var bool bQuestComplete;
};
struct native JCItem 
{
    var string sName;
    var int nID;
    var stringref srDesc;
    var bool bUpdated;
};

var array<JCEntry> lstJCQuests;
var array<JCEntry> lstJCCodexPrimary;
var array<JCEntry> lstJCCodexSecondary;
var config array<CodexImageDetails> lstImages;
var config biodynamicload string sDefaultCodexImage;
var native Pointer m_pJCDisplayList;
var config stringref lstSortLabels[3];
var config stringref lstSortTitles[3];
var int m_nCurrentDisplayCategory;
var int m_nCurrentListEntry;
var int m_nQuestPrimaryUpdatedCount;
var int m_nQuestSecondaryUpdatedCount;
var int m_nCodexPrimaryUpdatedCount;
var int m_nCodexSecondaryUpdatedCount;
var config stringref srMarkAllCompleteMessage;
var config stringref srMarkAllCompleteMessageConfirm;
var config stringref srMarkAllCompleteMessageCancel;
var int m_nVoiceOverPage;
var float m_fTimeUntilVoiceOver;
var editinline transient export WwiseAudioComponent m_oVoiceOver;
var config float fVoiceOverDelay;
var config float fVoiceOverCancelFadeOut;
var int m_nUpStamp;
var config stringref TitleText;
var config stringref ExitText;
var config stringref BackText;
var config stringref CloseSubListText;
var config stringref Tab1Text;
var config stringref Tab2Text;
var config stringref Tab3Text;
var config stringref MarkAllViewedText;
var config stringref ViewText;

public final event function AS_AddListItems(array<JCUIListItem> aItems)
{
    ActionScriptVoid("mcGUI.AddListItems");
}
public final event function AS_EndDisplayList(int nLastEntryID)
{
    ActionScriptVoid("mcGUI.EndDisplayList");
}
public final event function AS_MarkAllViewedConfirmed()
{
    ActionScriptVoid("mcGUI.MarkAllViewedConfirmed");
}
public final event function AS_ScrollDetailsAnalog(float fScroll)
{
    ActionScriptVoid("mcGUI.scrollDetailsAnalog");
}
public final event function AS_SetDetails(string sInfo, string sImgResource)
{
    ActionScriptVoid("mcGUI.SetDetails");
}
public final event function AS_SetSubItems(array<JCItem> aSubItems)
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
public final event function AS_StartDisplayList(const string sLabel, const string sTitle, int nListLen)
{
    ActionScriptVoid("mcGUI.StartDisplayList");
}
public final native function ExExitEntries();

public final native function ExExpandEntry();

public final native function ExFocusOnEntry();

public final native function ExFocusOnSubentry(int nSublistSelection);

public final native function ExFocusOnTab(int nTab);

public final native function ExInitializeJournal();

public final native function ExMarkAllDataViewed();

public final native function ExSetItemRead(int nID, int nSubID);

public final native function ExSetLastEntry(int nEntry);

public final native function ExSortList();

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
public function MarkAllDataViewed(bool bAPressed, int nContext)
{
    NativeMarkAllDataViewed(bAPressed, nContext);
}
public native function NativeMarkAllDataViewed(bool bAPressed, int nContext);

public final function ExPlayEntryVO();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    lstImages = ({sName = "gui_codex_images.Codex.CDX_AI_512x256", nID = 1, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Alliance_512x256", nID = 2, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Anderson2_512x256", nID = 3, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Asari_512x256", nID = 4, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Ashley_512x256", nID = 5, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Banshee_512x256", nID = 6, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Batarians_512x256", nID = 7, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Biotics_512x256", nID = 8, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Brute_512x256", nID = 9, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Cannibal_512x256", nID = 10, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Cerberus_512x256", nID = 11, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Chakwas_512x256", nID = 12, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Citadel_512x256", nID = 13, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_CitSpace_512x256", nID = 14, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Collectors_512x256", nID = 15, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_ContactWar_512x256", nID = 16, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Council_512x256", nID = 17, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Crucible_512x256", nID = 18, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Cyclonic_512x256", nID = 19, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Drell_512x256", nID = 20, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Earth_512x256", nID = 21, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_EDI_512x256", nID = 22, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Eezo_512x256", nID = 23, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Elcor_512x256", nID = 24, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_FTL_512x256", nID = 25, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Garrus_512x256", nID = 26, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Geno_512x256", nID = 27, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_GenoCure_512x256", nID = 28, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Geth_512x256", nID = 29, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Grissom_512x256", nID = 30, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Hackett1_512x256", nID = 31, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Hanar_512x256", nID = 32, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Harbinger_512x256", nID = 33, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Harvester_512x256", nID = 34, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Horizon_512x256", nID = 35, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Husk2_512x256", nID = 36, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_IllusiveMan1_512x256", nID = 37, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Indoctination_512x256", nID = 38, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Jacob2_512x256", nID = 39, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_JacobP_512x256", nID = 40, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_James_512x256", nID = 41, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Joker_512x256", nID = 42, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Kaidan_512x256", nID = 43, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Keepers_512x256", nID = 44, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Kodiak_512x256", nID = 45, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Krogan_512x256", nID = 46, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Liara_512x256", nID = 47, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Marauder_512x256", nID = 48, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_MassAccel_512x256", nID = 49, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_MassRelays2_512x256", nID = 50, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_MediGel_512x256", nID = 51, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_MEFields_512x256", nID = 52, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Menae_512x256", nID = 53, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_MilitaryShips_512x256", nID = 54, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Miranda2_512x256", nID = 55, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Mordin_512x256", nID = 56, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Normandy02_512x256", nID = 57, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_OmniBlade_512x256", nID = 58, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_OmniTool_512x256", nID = 59, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Palaven_512x256", nID = 60, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Protheans_512x256", nID = 61, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Quarians_512x256", nID = 62, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_RAlliance_512x256", nID = 63, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Rannoch_512x256", nID = 64, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Ravager_512x256", nID = 65, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Reapers_512x256", nID = 66, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_RVariants_512x256", nID = 67, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Salarians_512x256", nID = 68, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_SamaraP_512x256", nID = 69, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Shields_512x256", nID = 70, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Shroud_512x256", nID = 71, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Silaris_512x256", nID = 72, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Sovereign_512x256", nID = 73, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_SpaceCombat_512x256", nID = 74, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Spectres_512x256", nID = 75, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_SurKesh_512x256", nID = 76, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Tali_512x256", nID = 77, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Thanix_512x256", nID = 78, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Thessia_512x256", nID = 79, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Thresher_512x256", nID = 80, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Tuchanka_512x256", nID = 81, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Turians_512x256", nID = 82, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Udina_512x256", nID = 83, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_VI_512x256", nID = 84, oTexture = None}, 
                 {sName = "gui_codex_images.Codex.CDX_Volus_512x256", nID = 85, oTexture = None}, 
                 {sName = "gui_codex_images.Weapons.hvy_cain_512x256", nID = 86, oTexture = None}, 
                 {sName = "gui_codex_images.Weapons.hvy_titan_512x256", nID = 87, oTexture = None}, 
                 {sName = "gui_codex_images.Weapons.hvy_blackstar_512x256", nID = 88, oTexture = None}, 
                 {sName = "gui_codex_images.Weapons.hvy_spitfire_512x256", nID = 89, oTexture = None}
                )
    sDefaultCodexImage = "GUI_Codex_images.PDAComputerLogo_512"
    lstSortLabels[0] = $134552
    lstSortLabels[1] = $134551
    lstSortLabels[2] = $134553
    lstSortTitles[0] = $134552
    lstSortTitles[1] = $134551
    lstSortTitles[2] = $134553
    srMarkAllCompleteMessage = $227125
    srMarkAllCompleteMessageConfirm = $227126
    srMarkAllCompleteMessageCancel = $227127
    fVoiceOverDelay = 0.5
    fVoiceOverCancelFadeOut = 0.25
    TitleText = $126260
    ExitText = $315114
    BackText = $103236
    CloseSubListText = $163668
    Tab1Text = $162926
    Tab2Text = $163664
    Tab3Text = $163665
    MarkAllViewedText = $162955
    ViewText = $143602
    m_bFocusOnStart = TRUE
    m_bHandleKeyPresses = TRUE
    m_bRequiresUIWorld = TRUE
    m_bApplyRightThumbstickDeadzone = TRUE
}