Class SFXGUI_Accomplishments extends SFXGUIMovie
    config(UI);

struct AccomplishmentUIData 
{
    var string AccomplishmentName;
    var string Title;
    var string Description;
    var string IconTextureRef;
    var string ParentName;
    var string SecondDescription;
    var int nIndex;
    var int nPoints;
    var int nInitialValue;
    var int nFinalValue;
    var int nSecondInitialValue;
    var int nSecondFinalValue;
    var bool bIsCompleted;
    var bool bIsGrinder;
    var bool bIsDoubleGrinder;
};

var config stringref srTitle;
var config stringref srReturn;
var config stringref srBrowse;
var config stringref srTree;
var bool bFromMainMenu;
var config bool bShowChildDetails;

public function Exit()
{
    Close();
    if (bFromMainMenu)
    {
        GetSFXUIController().ShowMainMenu();
    }
}
public event function OnStart()
{
    Super.OnStart();
    SetRequiresUIWorld(TRUE);
    SetGameMode(TRUE, 9);
}
public event function OnClose()
{
    Super.OnClose();
    SetGameMode(FALSE, 9);
}
public function bool CanShowChildDetails()
{
    return bShowChildDetails;
}
public function array<AccomplishmentUIData> GetAccomplishmentData()
{
    local int idx;
    local AccomplishmentUIData CurrentUIData;
    local array<GrinderAccomplishment> GAList;
    local array<AccomplishmentUIData> AccomplishmentList;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    for (idx = 0; idx < AccomplishmentManager.AccomplishmentData.Length; ++idx)
    {
        CurrentUIData.AccomplishmentName = string(AccomplishmentManager.AccomplishmentData[idx].Name);
        CurrentUIData.nIndex = AccomplishmentManager.AccomplishmentData[idx].Index;
        CurrentUIData.Title = GetUIString(AccomplishmentManager.AccomplishmentData[idx].Title);
        CurrentUIData.bIsCompleted = AccomplishmentManager.AccomplishmentIsComplete[AccomplishmentManager.AccomplishmentData[idx].Index] != 0;
        CurrentUIData.ParentName = string(AccomplishmentManager.AccomplishmentData[idx].Parent);
        ClearCustomTokens();
        if (CurrentUIData.bIsCompleted)
        {
            CurrentUIData.Description = GetUIString(AccomplishmentManager.AccomplishmentData[idx].Complete, TRUE);
        }
        else
        {
            CurrentUIData.Description = GetUIString(AccomplishmentManager.AccomplishmentData[idx].Incomplete, TRUE);
        }
        CurrentUIData.nPoints = AccomplishmentManager.AccomplishmentData[idx].PointValue;
        CurrentUIData.IconTextureRef = AccomplishmentManager.AccomplishmentData[idx].Icon;
        CurrentUIData.bIsGrinder = FALSE;
        CurrentUIData.bIsDoubleGrinder = FALSE;
        GAList.Length = 0;
        if (AccomplishmentManager.GetGrinderAccomplishment(AccomplishmentManager.AccomplishmentData[idx].Name, GAList))
        {
            CurrentUIData.bIsGrinder = TRUE;
            CurrentUIData.nFinalValue = GAList[0].Goal;
            CurrentUIData.nInitialValue = AccomplishmentManager.GetGrinderAccomplishmentProgress(GAList[0].AccomplishmentProgressName, BioPlayerController(GetPC()));
            if (GAList.Length > 1)
            {
                CurrentUIData.bIsDoubleGrinder = TRUE;
                CurrentUIData.bIsGrinder = FALSE;
                CurrentUIData.nSecondFinalValue = GAList[1].Goal;
                CurrentUIData.nSecondInitialValue = AccomplishmentManager.GetGrinderAccomplishmentProgress(GAList[1].AccomplishmentProgressName, BioPlayerController(GetPC()));
            }
        }
        AccomplishmentList.AddItem(CurrentUIData);
    }
    return AccomplishmentList;
}
public function SetFromMainMenu(bool FromMainMenu)
{
    bFromMainMenu = FromMainMenu;
    if (bFromMainMenu)
    {
        GetSFXUIController().HideMainMenu();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srTitle = $633717
    srReturn = $633718
    srBrowse = $633719
    srTree = $633720
    bShowChildDetails = TRUE
    m_bFocusOnStart = TRUE
}