Class BioSFHandler_Achievement extends SFXGUIMovieLegacyAdapter
    config(UI);

const DumpDebug = 6;
const UpdateItemList = 5;
const PrevItem = 4;
const NextItem = 3;
const Initialize = 2;
const CloseAchievement = 1;
const MaxIcons = 8;

var int m_nSelectedItemIndex;
var int m_nShiftItemIndex;
var config stringref srEmpty;
var bool m_bFromMainMenu;

public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    switch (nCommand)
    {
        case 5:
            break;
        case 1:
            if (m_bFromMainMenu)
            {
                GetSFXUIController().ShowMainMenu();
                oPanel.oParentManager.RemovePanel(oPanel);
            }
            else
            {
                GetSFXUIController().HideAchievementGui(GetPC());
            }
            break;
        case 2:
            Init();
            PopulateAccomplishmentItemList();
            break;
        case 6:
            break;
        default:
    }
}
public final function Init()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = int(ScreenLayout);
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("initialize", lstParams);
}
public event function OnPanelAdded()
{
    GetSFXUIController().HideMainMenu();
}
public function bool IsAccomplishmentValid(out Accomplishment Data)
{
    return TRUE;
}
public final function PopulateAccomplishmentItemList()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    local int idx;
    local Accomplishment Data;
    local array<Accomplishment> lstValidAccomplishments;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        for (idx = 0; idx < AccomplishmentManager.AccomplishmentData.Length; idx++)
        {
            Data = AccomplishmentManager.AccomplishmentData[idx];
            if (IsAccomplishmentValid(Data))
            {
                lstValidAccomplishments.AddItem(Data);
            }
        }
        stParam.Type = ASParamTypes.ASParam_Integer;
        stParam.nVar = lstValidAccomplishments.Length;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("createList", lstParams);
        for (idx = 0; idx < lstValidAccomplishments.Length; idx++)
        {
            Data = lstValidAccomplishments[idx];
            PopulateAchivementItemListEntry(idx, Data);
        }
    }
}
public final function PopulateAchivementItemListEntry(int nDisplayIndex, out Accomplishment CurrentAccomplishment)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    local bool bEarned;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        stParam.Type = ASParamTypes.ASParam_Integer;
        stParam.nVar = nDisplayIndex;
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_String;
        stParam.sVar = CurrentAccomplishment.Icon;
        lstParams.AddItem(stParam);
        bEarned = AccomplishmentManager.HasCompletedAccomplishment(CurrentAccomplishment.Name);
        stParam.Type = ASParamTypes.ASParam_Boolean;
        stParam.bVar = bEarned;
        lstParams.AddItem(stParam);
        stParam.Type = ASParamTypes.ASParam_Integer;
        stParam.nVar = int(CurrentAccomplishment.Title);
        lstParams.AddItem(stParam);
        ClearCustomTokens();
        oPanel.InvokeMethodArgs("contentHold.PopulateAchievementItem", lstParams);
    }
}
public function SetFromMainMenu()
{
    m_bFromMainMenu = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nHandlerID = 18
}