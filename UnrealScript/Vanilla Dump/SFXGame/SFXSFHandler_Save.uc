Class SFXSFHandler_Save extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum ESaveGuiMode
{
    SaveGuiMode_BrowserWheel,
    SaveGuiMode_MainMenu,
    SaveGuiMode_GameOver,
};
struct native SaveGUIRecord 
{
    var(SaveGUIRecord) init SFXSaveDescriptor SaveDescriptor;
    var(SaveGUIRecord) string FriendlyName;
    var(SaveGUIRecord) string ImagePath;
    var(SaveGUIRecord) SFXSaveGame SaveGame;
    var(SaveGUIRecord) Texture2D AreaImage;
};
struct native SaveGUIAreaInfo 
{
    var(SaveGUIAreaInfo) biodynamicload string ImageName;
    var(SaveGUIAreaInfo) Name AreaName;
    var(SaveGUIAreaInfo) stringref AreaStrRef;
};
const SaveOption_NewSaveGame = 11;
const SaveOption_ChangeStorageDevice = 10;
const SaveOption_DeleteGame = 4;
const SaveOption_SaveGame = 2;
const SaveOption_Initialize = 1;

var(SFXSFHandler_Save) transient Double CheckingDataStartTime;
var(SFXSFHandler_Save) config array<SaveGUIAreaInfo> AreaData;
var(SFXSFHandler_Save) string DefaultImageName;
var(SFXSFHandler_Save) array<SaveGUIRecord> SaveList;
var(SFXSFHandler_Save) transient string ImagePackageName;
var(SFXSFHandler_Save) config transient Name ME3ImportSaveAreaOverride;
var(SFXSFHandler_Save) Texture2D DefaultAreaImage;
var(SFXSFHandler_Save) transient int MaxSaves;
var(SFXSFHandler_Save) transient int PendingOverwriteIndex;
var(SFXSFHandler_Save) transient int PreparedSaveSize;
var(SFXSFHandler_Save) config transient stringref DefaultAreaNameText;
var(SFXSFHandler_Save) config transient stringref AutoSaveText;
var(SFXSFHandler_Save) config transient stringref ChapterSaveText;
var(SFXSFHandler_Save) config transient stringref QuickSaveText;
var(SFXSFHandler_Save) config transient stringref SaveGameText;
var(SFXSFHandler_Save) config transient stringref SaveDisplayText;
var(SFXSFHandler_Save) config transient stringref NewGameText;
var(SFXSFHandler_Save) config transient stringref TimePlayedText;
var(SFXSFHandler_Save) config transient stringref LastPlayedText;
var(SFXSFHandler_Save) config transient stringref LastPlayedTimeText;
var(SFXSFHandler_Save) config transient stringref OverwriteSaveGameText;
var(SFXSFHandler_Save) config transient stringref ConfirmOverwriteSaveGameText;
var(SFXSFHandler_Save) config transient stringref CancelOverwriteSaveGameText;
var(SFXSFHandler_Save) config transient stringref DeleteGameText;
var(SFXSFHandler_Save) config transient stringref ConfirmDeleteGameText;
var(SFXSFHandler_Save) config transient stringref CancelDeleteGameText;
var(SFXSFHandler_Save) config transient stringref InsufficentSpaceText;
var(SFXSFHandler_Save) config transient stringref InsufficentSpaceTextPC;
var(SFXSFHandler_Save) config transient stringref InsufficentSpaceTextPS3;
var(SFXSFHandler_Save) config transient stringref InsufficentSpaceOverwriteTextPS3;
var(SFXSFHandler_Save) config transient stringref InsufficentSpaceAcknowledgedText;
var(SFXSFHandler_Save) config transient stringref SaveActionText;
var(SFXSFHandler_Save) config transient stringref CheckingSaveDataText;
var(SFXSFHandler_Save) transient float CheckingDataMessageDelay;
var(SFXSFHandler_Save) transient float CheckingDataMessageMinimum;
var(SFXSFHandler_Save) transient bool bWaitingOnMsgBox;
var(SFXSFHandler_Save) transient bool bEnumeratingSaves;
var(SFXSFHandler_Save) transient bool bCheckingDataComplete;
var(SFXSFHandler_Save) transient bool bCheckingDataMessageVisible;
var(SFXSFHandler_Save) ESaveGuiMode GuiMode;

public native function BeginInitializeSaveList();

public native function EndInitializeSaveList(SFXSaveGameCommandEventArgs Args);

public final event function bool GetPlayerData(out string firstName, out stringref LastName, out stringref className, out int Level)
{
    local SFXGUIInteraction GuiMan;
    local SFXPawn_Player Player;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        LastName = Class'SFXPawn_Player'.static.GetLastNameStringRef();
        Player = SFXPawn_Player(GetPC().Pawn);
        if (Player != None)
        {
            firstName = Player.firstName;
            className = stringref(Player.PlayerClass.srClassName);
            Level = Player.CharacterLevel;
            return TRUE;
        }
    }
    return FALSE;
}
public function Initialize()
{
    SetLoadSave(TRUE, FALSE, FALSE, 0, int(ScreenLayout), FALSE);
    if (Class'Engine'.static.IsShip() == FALSE)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild(2))
        {
            MaxSaves = 113;
        }
        else
        {
            MaxSaves = 1000;
        }
    }
    BeginInitializeSaveList();
}
public final function SaveGame(int nIndex)
{
    local BioMessageBoxOptionalParams Params;
    local BioSFHandler_MessageBox messageBox;
    
    if (nIndex == -1)
    {
        PendingOverwriteIndex = -1;
        PrepareSaveGame();
    }
    if (nIndex >= 0 && nIndex < SaveList.Length)
    {
        messageBox = GetSFXUIController().CreateMessageBox(GetPC());
        messageBox.SetInputDelegate(Callback_ConfirmOverwrite, nIndex);
        Params.srAText = ConfirmOverwriteSaveGameText;
        Params.srBText = CancelOverwriteSaveGameText;
        Params.bNoFade = TRUE;
        messageBox.DisplayMessageBox(OverwriteSaveGameText, Params);
        bWaitingOnMsgBox = TRUE;
    }
}
protected final native function bool UpdateCheckingDataMessage(stringref Message);

public event function OnClose()
{
    oPanel.oParentManager.RemoveNamedMessageBox('CheckingDataMessage');
}
public function Callback_ConfirmDelete(bool bAPressed, int Context)
{
    local SFXEngine Engine;
    
    if (bAPressed)
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Engine != None)
        {
            GetSFXUIController().GetSaveLoadWidget().ShowDeletingMessage(TRUE);
            oPanel.SetInputDisabled(TRUE);
            Engine.QueueSaveGameCommand(3, SaveList[Context].SaveDescriptor, ResetGui);
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public function Callback_ConfirmOverwrite(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        PendingOverwriteIndex = Context;
        PrepareSaveGame();
    }
    bWaitingOnMsgBox = FALSE;
}
public function Callback_DeviceSelectionComplete(bool bWasSuccessful, bool bWasBlocked)
{
    local BioPlayerController PC;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    
    if (bWasSuccessful)
    {
        BeginInitializeSaveList();
    }
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        PlayerIntEx = PC.OnlineSub.PlayerInterfaceEx;
        PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(LocalPlayer(PC.Player).ControllerId), Callback_DeviceSelectionComplete);
    }
}
public final function CheckFreeSpace(SFXSaveGameCommandEventArgs Args)
{
    local SFXEngine Engine;
    local BioPlayerController PC;
    local int RequiredFreeBytes;
    local bool bDeferFreeSpaceCheck;
    local delegate<SFXEngine.SFXSaveCommandCallback> SaveGameCallback;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None)
    {
        if (Args.bSuccess && Args.bTotalFreeBytesSet)
        {
            RequiredFreeBytes = PreparedSaveSize;
            if (PendingOverwriteIndex != -1)
            {
                RequiredFreeBytes -= SaveList[PendingOverwriteIndex].SaveGame.SerializedSize;
            }
            if (RequiredFreeBytes > Args.TotalFreeBytes && Class'WorldInfo'.static.IsConsoleBuild(1))
            {
                SaveGameCallback = SaveGameCompleted;
                bDeferFreeSpaceCheck = TRUE;
            }
            if (RequiredFreeBytes > Args.TotalFreeBytes && !bDeferFreeSpaceCheck)
            {
                DisplayInsufficientSpaceMessage(RequiredFreeBytes - Args.TotalFreeBytes);
            }
            else
            {
                Engine.bCanWriteSaveToStorage = TRUE;
                PC = BioPlayerController(GetPC());
                if (PC != None)
                {
                    if (PendingOverwriteIndex != -1)
                    {
                        PC.OverwriteGame(SaveList[PendingOverwriteIndex].SaveDescriptor.Index, GetNewSaveIdx(), SaveGameCallback);
                    }
                    else
                    {
                        PC.SaveGame(GetNewSaveIdx(), SaveGameCallback);
                    }
                    if (bDeferFreeSpaceCheck)
                    {
                        return;
                    }
                    GetSFXUIController().ReturnToBrowserWheel(oPanel, TRUE);
                    GetSFXUIController().GetSaveLoadWidget().ShowSavingMessage(TRUE);
                }
            }
        }
        Engine.QueueSaveGameCommand(10);
    }
    SetInputEnabled(TRUE);
}
public function DeleteGame(int SaveIdx)
{
    local BioMessageBoxOptionalParams Params;
    local BioSFHandler_MessageBox messageBox;
    
    if (SaveIdx >= 0 && SaveIdx < SaveList.Length)
    {
        messageBox = GetSFXUIController().CreateMessageBox(GetPC());
        messageBox.SetInputDelegate(Callback_ConfirmDelete, SaveIdx);
        Params.srAText = ConfirmDeleteGameText;
        Params.srBText = CancelDeleteGameText;
        Params.bNoFade = TRUE;
        messageBox.DisplayMessageBox(DeleteGameText, Params);
        bWaitingOnMsgBox = TRUE;
    }
}
public final function DisplayInsufficientSpaceMessage(int AdditionalBytesNeeded)
{
    local BioSFHandler_MessageBox InsufficientSpaceMessage;
    local BioMessageBoxOptionalParams messageParams;
    local string InsufficientSpaceTextWithSize;
    
    InsufficientSpaceMessage = GetSFXUIController().CreateMessageBox(GetPC());
    messageParams.srAText = InsufficentSpaceAcknowledgedText;
    messageParams.srBText = $0;
    messageParams.bModal = TRUE;
    messageParams.bNoFade = TRUE;
    if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        SetCustomToken(1, string((AdditionalBytesNeeded + 1023) / 1024));
        if (PendingOverwriteIndex != -1)
        {
            InsufficientSpaceTextWithSize = GetTokenisedString(InsufficentSpaceOverwriteTextPS3);
        }
        else
        {
            InsufficientSpaceTextWithSize = GetTokenisedString(InsufficentSpaceTextPS3);
        }
        ClearCustomTokens();
        InsufficientSpaceMessage.DisplayMessageBoxEx(InsufficientSpaceTextWithSize, messageParams);
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        InsufficientSpaceMessage.DisplayMessageBox(InsufficentSpaceText, messageParams);
    }
    else
    {
        SetCustomToken(1, string((AdditionalBytesNeeded + 1023) / 1024));
        InsufficientSpaceTextWithSize = GetTokenisedString(InsufficentSpaceTextPC);
        ClearCustomTokens();
        InsufficientSpaceMessage.DisplayMessageBoxEx(InsufficientSpaceTextWithSize, messageParams);
    }
}
public final function int GetNewSaveIdx()
{
    local int idx;
    local int NewIdx;
    
    NewIdx = -1;
    if (SaveList.Length == 0)
    {
        return 1;
    }
    for (idx = 0; idx < SaveList.Length; idx++)
    {
        if (SaveList[idx].SaveDescriptor.Index > NewIdx)
        {
            NewIdx = SaveList[idx].SaveDescriptor.Index;
        }
    }
    NewIdx++;
    return NewIdx;
}
public final function PrepareSaveGame()
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local string CantSaveReason;
    
    PC = BioPlayerController(GetPC());
    if (PC != None && PC.CanSave(CantSaveReason))
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Engine != None)
        {
            SetInputEnabled(FALSE);
            Engine.QueueSaveGameCommand(9, , QueryFreeSpace);
        }
    }
}
public final function QueryFreeSpace(SFXSaveGameCommandEventArgs Args)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None && Args.bSuccess && Args.bPreparedSaveSizeSet)
    {
        PreparedSaveSize = Args.PreparedSaveSize;
        Engine.QueueSaveGameCommand(8, , CheckFreeSpace);
    }
    else
    {
        SetInputEnabled(TRUE);
    }
}
public function ResetGui(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    BeginInitializeSaveList();
}
public final function SaveGameCompleted(SFXSaveGameCommandEventArgs Args)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Args.bSuccess)
    {
        GetSFXUIController().ReturnToBrowserWheel(oPanel, TRUE);
        GetSFXUIController().GetSaveLoadWidget().ShowSavingMessage(TRUE);
    }
    else if (Args.bNeedsFreeSpace)
    {
        DisplayInsufficientSpaceMessage(Args.AdditionalFreeBytesNeeded);
    }
    if (Engine != None)
    {
        Engine.QueueSaveGameCommand(10);
    }
    SetInputEnabled(TRUE);
}
public final function SetLoadSave(bool bIsSave, bool bLegacySave, bool ME2Import, int nLastGUI, int nLayout, bool bCarreerSelection)
{
    ActionScriptVoid("loadSave.SetLoadSave");
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AreaData = ({ImageName = "GUI_SF_SaveLoad_Images.Elevators.LVL_NorCIC_512x256", AreaName = 'BioP_Nor', AreaStrRef = $315282}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Earth_512x256", AreaName = 'Biop_ProEar', AreaStrRef = $500213}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Mars_512x256", AreaName = 'Biop_ProMar', AreaStrRef = $500214}, 
                {ImageName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitHosp_512x256", AreaName = 'BioP_ProCit', AreaStrRef = $500215}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geth01_512x256", AreaName = 'Biop_Gth001', AreaStrRef = $500216}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geth02_512x256", AreaName = 'Biop_Gth002', AreaStrRef = $500217}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GethAdmiral_512x256", AreaName = 'Biop_GthN7a', AreaStrRef = $500218}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GethLegion_512x256", AreaName = 'Biop_GthLeg', AreaStrRef = $500220}, 
                {ImageName = "GUI_SF_SaveLoad_Images.BioP_HorCr1_IMG", AreaName = 'BioP_Cat001', AreaStrRef = $500221}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Garrus_512x256", AreaName = 'Biop_KroGar', AreaStrRef = $724704}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geno01_512x256", AreaName = 'Biop_Kro001', AreaStrRef = $500222}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geno02_512x256", AreaName = 'Biop_Kro002', AreaStrRef = $500223}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoRescue_512x256", AreaName = 'Biop_KroN7a', AreaStrRef = $500224}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoBomb_512x256", AreaName = 'Biop_KroN7b', AreaStrRef = $500225}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoGrunt_512x256", AreaName = 'Biop_KroGru', AreaStrRef = $500226}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat2Thessia_512x256", AreaName = 'Biop_Cat002', AreaStrRef = $500227}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat3Coup_512x256", AreaName = 'Biop_Cat003', AreaStrRef = $135823}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Miranda_512x256", AreaName = 'Biop_CerMir', AreaStrRef = $500232}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Jacob_512x256", AreaName = 'Biop_CerJcb', AreaStrRef = $500233}, 
                {ImageName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitCommon_512x256", AreaName = 'BioP_CitHub', AreaStrRef = $500234}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Samara_512x256", AreaName = 'Biop_CitSam', AreaStrRef = $500240}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Grissom_512x256", AreaName = 'Biop_OmgJck', AreaStrRef = $500246}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBDagger_512x256", AreaName = 'Biop_SPDish', AreaStrRef = $663714}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGhost_512x256", AreaName = 'Biop_SPSlum', AreaStrRef = $663715}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGiant_512x256", AreaName = 'Biop_SPTowr', AreaStrRef = $663716}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGlacier_512x256", AreaName = 'Biop_SPCer', AreaStrRef = $663717}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBReactor_512x256", AreaName = 'Biop_SPRctr', AreaStrRef = $663719}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBWhite_512x256", AreaName = 'Biop_SPNov', AreaStrRef = $663721}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat4Illusive_512x256", AreaName = 'Biop_Cat004', AreaStrRef = $724703}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_EndEarth_512x256", AreaName = 'Biop_End001', AreaStrRef = $500248}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_EndCitadel_512x256", AreaName = 'Biop_End002', AreaStrRef = $500249}, 
                {ImageName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_EndCitadel_512x256", AreaName = 'BioP_End003', AreaStrRef = $500250}, 
                {ImageName = "", AreaName = 'Biop_Procer', AreaStrRef = $348789}, 
                {ImageName = "", AreaName = 'Biop_Twrasa', AreaStrRef = $315283}, 
                {ImageName = "", AreaName = 'BioP_BchLmL', AreaStrRef = $315284}, 
                {ImageName = "", AreaName = 'BioP_BlbGtl', AreaStrRef = $315285}, 
                {ImageName = "", AreaName = 'BioP_CitAsL', AreaStrRef = $315286}, 
                {ImageName = "", AreaName = 'BioP_CitGrL', AreaStrRef = $315287}, 
                {ImageName = "", AreaName = 'BioP_CitTwr', AreaStrRef = $724465}, 
                {ImageName = "", AreaName = 'BioP_EndGm1', AreaStrRef = $315290}, 
                {ImageName = "", AreaName = 'BioP_EndGm2', AreaStrRef = $315291}, 
                {ImageName = "", AreaName = 'BioP_EndGm3', AreaStrRef = $315292}, 
                {ImageName = "", AreaName = 'BioP_HorCr1', AreaStrRef = $315293}, 
                {ImageName = "", AreaName = 'BioP_JnkKgA', AreaStrRef = $315294}, 
                {ImageName = "", AreaName = 'BioP_JunCvL', AreaStrRef = $315295}, 
                {ImageName = "", AreaName = 'BioP_KroHub', AreaStrRef = $315296}, 
                {ImageName = "", AreaName = 'BioP_KroKgL', AreaStrRef = $315297}, 
                {ImageName = "", AreaName = 'BioP_KroPrL', AreaStrRef = $315298}, 
                {ImageName = "", AreaName = 'BioP_OmgGrA', AreaStrRef = $315299}, 
                {ImageName = "", AreaName = 'BioP_OmgHub', AreaStrRef = $315300}, 
                {ImageName = "", AreaName = 'BioP_OmgPrA', AreaStrRef = $315301}, 
                {ImageName = "", AreaName = 'BioP_ProFre', AreaStrRef = $315302}, 
                {ImageName = "", AreaName = 'BioP_ProNor', AreaStrRef = $315303}, 
                {ImageName = "", AreaName = 'BioP_PrsCvA', AreaStrRef = $315304}, 
                {ImageName = "", AreaName = 'BioP_QuaTlL', AreaStrRef = $315305}, 
                {ImageName = "", AreaName = 'BioP_RprGtA', AreaStrRef = $315306}, 
                {ImageName = "", AreaName = 'BioP_ShpCr2', AreaStrRef = $315307}, 
                {ImageName = "", AreaName = 'BioP_SunTlA', AreaStrRef = $315308}, 
                {ImageName = "", AreaName = 'BioP_TwrHub', AreaStrRef = $315309}, 
                {ImageName = "", AreaName = 'BioP_TwrMwA', AreaStrRef = $315310}, 
                {ImageName = "", AreaName = 'BioP_TwrVxL', AreaStrRef = $315311}, 
                {ImageName = "", AreaName = 'Biop_N7BldInv1', AreaStrRef = $315872}, 
                {ImageName = "", AreaName = 'BioP_N7BldInv2', AreaStrRef = $315873}, 
                {ImageName = "", AreaName = 'BioP_N7Crsh', AreaStrRef = $315875}, 
                {ImageName = "", AreaName = 'BioP_N7DriveBy', AreaStrRef = $315878}, 
                {ImageName = "", AreaName = 'BioP_N7Geth1', AreaStrRef = $315880}, 
                {ImageName = "", AreaName = 'BioP_N7Geth2', AreaStrRef = $315881}, 
                {ImageName = "", AreaName = 'BioP_N7Ruins', AreaStrRef = $315883}, 
                {ImageName = "", AreaName = 'BioP_N7ShipWreck', AreaStrRef = $315884}, 
                {ImageName = "", AreaName = 'BioP_N7Spdr1', AreaStrRef = $315885}, 
                {ImageName = "", AreaName = 'BioP_N7Spdr2', AreaStrRef = $315886}, 
                {ImageName = "", AreaName = 'BioP_N7Spdr3', AreaStrRef = $315887}, 
                {ImageName = "", AreaName = 'BioP_N7VIQ1', AreaStrRef = $315888}, 
                {ImageName = "", AreaName = 'BioP_N7VIQ2', AreaStrRef = $315889}, 
                {ImageName = "", AreaName = 'BioP_N7VIQ3', AreaStrRef = $315890}, 
                {ImageName = "", AreaName = 'BioP_N7Mine', AreaStrRef = $344407}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt1', AreaStrRef = $344408}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt2', AreaStrRef = $344409}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt3', AreaStrRef = $344410}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt4', AreaStrRef = $344411}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt5', AreaStrRef = $344412}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt6', AreaStrRef = $344413}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt7', AreaStrRef = $344414}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt8', AreaStrRef = $344415}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt10', AreaStrRef = $344416}, 
                {ImageName = "", AreaName = 'BioP_Unc1Base1', AreaStrRef = $362117}, 
                {ImageName = "", AreaName = 'BioP_Unc1Base2', AreaStrRef = $362116}, 
                {ImageName = "", AreaName = 'BioP_Unc1Base3', AreaStrRef = $362115}, 
                {ImageName = "", AreaName = 'BioP_Unc1Base4', AreaStrRef = $362118}, 
                {ImageName = "", AreaName = 'BioP_Unc1Explore', AreaStrRef = $362119}, 
                {ImageName = "", AreaName = 'Biop_N7NorCrash', AreaStrRef = $311991}, 
                {ImageName = "", AreaName = 'BioP_N7ShipWreck', AreaStrRef = $315090}, 
                {ImageName = "", AreaName = 'BioP_N7mmnt8', AreaStrRef = $327109}, 
                {ImageName = "", AreaName = 'BioP_N7DriveBy', AreaStrRef = $310893}, 
                {ImageName = "", AreaName = 'BioP_ZyaVTL', AreaStrRef = $351284}, 
                {ImageName = "", AreaName = 'BioP_PtyMtL', AreaStrRef = $356663}, 
                {ImageName = "", AreaName = 'BioP_ArvLvl1', AreaStrRef = $391722}, 
                {ImageName = "", AreaName = 'BioP_ArvLvl2', AreaStrRef = $391723}, 
                {ImageName = "", AreaName = 'BioP_ArvLvl3', AreaStrRef = $391723}, 
                {ImageName = "", AreaName = 'BioP_ArvLvl4', AreaStrRef = $391723}, 
                {ImageName = "", AreaName = 'BioP_ArvLvl5', AreaStrRef = $391723}, 
                {ImageName = "", AreaName = 'BioP_Exp1Lvl1', AreaStrRef = $724466}, 
                {ImageName = "", AreaName = 'BioP_Exp1Lvl2', AreaStrRef = $724467}, 
                {ImageName = "", AreaName = 'BioP_Exp1Lvl3', AreaStrRef = $724468}, 
                {ImageName = "", AreaName = 'BioP_Exp1Lvl4', AreaStrRef = $724469}, 
                {ImageName = "", AreaName = 'BioP_Exp1Lvl5', AreaStrRef = $724469}
               )
    DefaultImageName = "GUI_SF_SaveLoad_Images.Images_UNC93_I1"
    ME3ImportSaveAreaOverride = 'ME3_NewGamePlus'
    MaxSaves = 30
    DefaultAreaNameText = $335319
    AutoSaveText = $168498
    ChapterSaveText = $335439
    QuickSaveText = $282869
    SaveGameText = $170884
    SaveDisplayText = $170864
    NewGameText = $165713
    TimePlayedText = $168814
    LastPlayedText = $168815
    LastPlayedTimeText = $168816
    OverwriteSaveGameText = $147163
    ConfirmOverwriteSaveGameText = $147164
    CancelOverwriteSaveGameText = $147165
    DeleteGameText = $153187
    ConfirmDeleteGameText = $147164
    CancelDeleteGameText = $147165
    InsufficentSpaceText = $344243
    InsufficentSpaceTextPC = $386029
    InsufficentSpaceTextPS3 = $361971
    InsufficentSpaceOverwriteTextPS3 = $386028
    InsufficentSpaceAcknowledgedText = $153007
    SaveActionText = $166169
    CheckingSaveDataText = $389294
    CheckingDataMessageDelay = 0.25
    CheckingDataMessageMinimum = 1.5
    nHandlerID = 17
}