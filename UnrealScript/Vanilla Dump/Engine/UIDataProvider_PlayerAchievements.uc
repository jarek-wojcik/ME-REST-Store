Class UIDataProvider_PlayerAchievements extends UIDataProvider_OnlinePlayerDataBase
    implements(UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var transient array<AchievementDetails> Achievements;

public final native function int GetMaxTotalGamerScore();

public final native function int GetTotalGamerScore();

public function OnLoginChange(byte LocalUserNum)
{
    if (int(LocalUserNum) == Player.ControllerId)
    {
        UpdateAchievements();
    }
}
public event function OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    
    Super.OnRegister(InPlayer);
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            if (OnlineSub.PlayerInterface != None)
            {
                OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
                OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementsChanged);
                OnlineSub.PlayerInterface.AddUnlockAchievementCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementUnlocked);
                OnlineSub.PlayerInterface.ReadAchievements(byte(Player.ControllerId));
            }
        }
    }
}
public event function OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        if (OnlineSub.PlayerInterface != None)
        {
            OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
        if (OnlineSub.PlayerInterface != None)
        {
            OnlineSub.PlayerInterface.ClearUnlockAchievementCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementUnlocked);
            OnlineSub.PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementsChanged);
        }
    }
    Achievements.Length = 0;
    Super.OnUnregister();
}
public function GetAchievementDetails(const int AchievementId, out AchievementDetails OutAchievementDetails)
{
    local int idx;
    
    idx = Achievements.Find('Id', AchievementId);
    if (idx != -1)
    {
        OutAchievementDetails = Achievements[idx];
    }
}
public function string GetAchievementIconPathName(int AchievementId, optional bool bReturnLockedIcon);

public function OnPlayerAchievementsChanged(int TitleId)
{
    local OnlineSubsystem OnlineSub;
    local EOnlineEnumerationReadState Result;
    
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None && OnlineSub.PlayerInterface != None && TitleId == 0)
        {
            Result = OnlineSub.PlayerInterface.GetAchievements(byte(Player.ControllerId), Achievements, TitleId);
            if (Result == EOnlineEnumerationReadState.OERS_Done)
            {
                PopulateAchievementIcons();
                NotifyPropertyChanged('Achievements');
                NotifyPropertyChanged('TotalGamerPoints');
            }
        }
    }
}
public function OnPlayerAchievementUnlocked(bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        UpdateAchievements();
    }
}
public function PopulateAchievementIcons();

public function UpdateAchievements()
{
    local OnlineSubsystem OnlineSub;
    
    if (Player != None)
    {
        Achievements.Length = 0;
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None && OnlineSub.PlayerInterface != None && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
        {
            OnlineSub.PlayerInterface.ReadAchievements(byte(Player.ControllerId));
        }
        NotifyPropertyChanged('Achievements');
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}