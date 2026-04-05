Class SFXAccomplishmentManager
    native
    config(Game);

struct native AchievementReward 
{
    var string Effect;
    var Name Name;
    var Name AccomplishmentName;
};
struct native GrinderAccomplishment 
{
    var Name AccomplishmentName;
    var Name AccomplishmentProgressName;
    var int Goal;
    var int Interval;
    var stringref Title;
    var stringref Description;
    var stringref MPDescription;
};
struct native AccomplishmentProgress 
{
    var Name Name;
    var int Index;
    var EProfileSetting LinkedProfileSetting;
};
struct native Accomplishment 
{
    var string Icon;
    var Name Name;
    var Name Parent;
    var int Index;
    var int XboxAchievementID;
    var int XboxAvatarAwardID;
    var int PS3TrophyID;
    var stringref Title;
    var stringref Incomplete;
    var stringref Complete;
    var int PointValue;
    var stringref NotificationText;
    var stringref MPNotificationText;
    var bool IsMultiplayerOnly;
    var EAchievementID LinkedAchievementID;
    
    structdefaultproperties
    {
        XboxAchievementID = -1
        XboxAvatarAwardID = -1
        PS3TrophyID = -1
        LinkedAchievementID = EAchievementID.ACHIEVEMENT_NONE
    }
};
enum EAccomplishmentStorage
{
    ACCSTOR_None,
    ACCSTOR_AsAchievement,
    ACCSTOR_InOnlineStorage,
    ACCSTOR_InProfileSettings,
};

var(SFXAccomplishmentManager) config array<Accomplishment> AccomplishmentData;
var(SFXAccomplishmentManager) array<int> AccomplishmentIsComplete;
var(SFXAccomplishmentManager) config array<AccomplishmentProgress> AccomplishmentProgressData;
var(SFXAccomplishmentManager) config array<GrinderAccomplishment> GrinderAccomplishmentData;
var(SFXAccomplishmentManager) config array<AchievementReward> Rewards;
var SFXAccomplishmentStorage AccomplishmentStorage;
var transient bool IsDataValidated;

private final event function SFXOnlineJobSendMessage CreateJobSendAchievementMessage(int AchievementId)
{
    local array<string> Params;
    
    Params.AddItem(string(AchievementId));
    return Class'SFXOnlineJobSendMessage'.static.CreateSendMessageToAllFriendsJob(0, Params);
}
public function Destroyed()
{
    local int UserNum;
    
    if (AccomplishmentStorage != None)
    {
        for (UserNum = 0; UserNum < 4; ++UserNum)
        {
            AccomplishmentStorage.AcknowledgeWriteComplete(byte(UserNum), SaveComplete);
        }
    }
}
public final event function Initialize()
{
    local int MaxProgressIndex;
    local int MaxAccomplishmentIndex;
    local int i;
    
    if (AccomplishmentStorage == None)
    {
        AccomplishmentStorage = new (Self) Class'SFXAccomplishmentStorage';
    }
    MaxProgressIndex = 0;
    for (i = 0; i < AccomplishmentProgressData.Length; i++)
    {
        if (AccomplishmentProgressData[i].Index > MaxProgressIndex)
        {
            MaxProgressIndex = AccomplishmentProgressData[i].Index;
        }
    }
    AccomplishmentStorage.Initialize(MaxProgressIndex + 1);
    MaxAccomplishmentIndex = 0;
    for (i = 0; i < AccomplishmentData.Length; i++)
    {
        if (AccomplishmentData[i].Index > MaxAccomplishmentIndex)
        {
            MaxAccomplishmentIndex = AccomplishmentData[i].Index;
        }
    }
    if (MaxAccomplishmentIndex > AccomplishmentIsComplete.Length)
    {
        AccomplishmentIsComplete.Length = MaxAccomplishmentIndex + 1;
    }
}
public final function Save()
{
    local WorldInfo World;
    local int ControllerId;
    local PlayerController pController;
    
    World = Class'Engine'.static.GetCurrentWorldInfo();
    if (World != None)
    {
        pController = World.GetALocalPlayerController();
        if (pController != None && LocalPlayer(pController.Player) != None)
        {
            ControllerId = LocalPlayer(pController.Player).ControllerId;
            AccomplishmentStorage.UpdateFromAccomplishments(AccomplishmentIsComplete, AccomplishmentProgressData);
            if (!AccomplishmentStorage.Write(byte(ControllerId), SaveComplete))
            {
            }
        }
    }
}
public final function Name AccomplishmentIndexToName(int AccomplishmentIndex)
{
    local int i;
    local Name AccomplishmentName;
    
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (AccomplishmentData[i].Index == AccomplishmentIndex)
        {
            AccomplishmentName = AccomplishmentData[i].Name;
            break;
        }
    }
    return AccomplishmentName;
}
public final function Name AccomplishmentProgressIndexToName(int AccomplishmentProgressIndex)
{
    local int i;
    local Name AccomplishmentProgressName;
    
    for (i = 0; i < AccomplishmentProgressData.Length; ++i)
    {
        if (AccomplishmentProgressData[i].Index == AccomplishmentProgressIndex)
        {
            AccomplishmentProgressName = AccomplishmentProgressData[i].Name;
            break;
        }
    }
    return AccomplishmentProgressName;
}
private final function bool AreAllChildAccomplishmentsCompleted(Name ParentAccomplishment)
{
    local int i;
    
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (AccomplishmentData[i].Parent == ParentAccomplishment && AccomplishmentIsComplete[AccomplishmentData[i].Index] == 0)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public static final function EAccomplishmentStorage GetAccomplishmentParamsStorage(EAchievementID AchievementId, bool IsMultiplayerOnly)
{
    if (AchievementId != EAchievementID.ACHIEVEMENT_NONE && Class'WorldInfo'.static.IsConsoleBuild())
    {
        return EAccomplishmentStorage.ACCSTOR_AsAchievement;
    }
    else if (IsMultiplayerOnly)
    {
        return EAccomplishmentStorage.ACCSTOR_InOnlineStorage;
    }
    return EAccomplishmentStorage.ACCSTOR_InProfileSettings;
}
public final function EAccomplishmentStorage GetAccomplishmentStorage(int ArrayIndex)
{
    return GetAccomplishmentParamsStorage(AccomplishmentData[ArrayIndex].LinkedAchievementID, AccomplishmentData[ArrayIndex].IsMultiplayerOnly);
}
public final function bool GetGrinderAccomplishment(Name AccomplishmentName, out array<GrinderAccomplishment> GAList)
{
    local int i;
    
    for (i = 0; i < GrinderAccomplishmentData.Length; i++)
    {
        if (GrinderAccomplishmentData[i].AccomplishmentName == AccomplishmentName)
        {
            GAList.AddItem(GrinderAccomplishmentData[i]);
        }
    }
    return GAList.Length > 0;
}
public final function int GetGrinderAccomplishmentProgress(Name AccomplishmentProgressName, BioPlayerController PC)
{
    local EProfileSetting ProfileSettingId;
    local int Progress;
    local int i;
    local bool bFound;
    
    Progress = -1;
    ProfileSettingId = GetProfileSettingFromAccomplishmentProgress(AccomplishmentProgressName);
    if (ProfileSettingId != EProfileSetting.Setting_Unknown)
    {
        if (PC != None && PC.ProfileSettings != None && PC.ProfileSettings.GetProfileSettingValueInt(int(ProfileSettingId), Progress))
        {
        }
    }
    else
    {
        bFound = FALSE;
        for (i = 0; i < AccomplishmentProgressData.Length; ++i)
        {
            if (AccomplishmentProgressData[i].Name == AccomplishmentProgressName)
            {
                Progress = AccomplishmentStorage.ProgressValues[AccomplishmentProgressData[i].Index];
                bFound = TRUE;
                break;
            }
        }
        if (!bFound)
        {
        }
    }
    return Progress;
}
private final function EProfileSetting GetProfileSettingFromAccomplishmentProgress(Name AccomplishmentProgressName)
{
    local int i;
    
    for (i = 0; i < AccomplishmentProgressData.Length; ++i)
    {
        if (AccomplishmentProgressData[i].Name == AccomplishmentProgressName)
        {
            return AccomplishmentProgressData[i].LinkedProfileSetting;
        }
    }
    return EProfileSetting.Setting_Unknown;
}
public final function bool GrinderAccomplishmentIncrement(Name AccomplishmentProgressName, BioPlayerController PC)
{
    local int Progress;
    
    Progress = GetGrinderAccomplishmentProgress(AccomplishmentProgressName, PC);
    ++Progress;
    return SetGrinderAccomplishmentProgressWithUpdate(AccomplishmentProgressName, Progress, PC);
}
public final function GrinderAccomplishmentReset(Name AccomplishmentProgressName, BioPlayerController PC)
{
    SetGrinderAccomplishmentProgress(AccomplishmentProgressName, 0, PC);
}
public final function bool HasCompletedAccomplishment(Name AccomplishmentName)
{
    local int i;
    
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (AccomplishmentData[i].Name == AccomplishmentName)
        {
            return AccomplishmentIsComplete[AccomplishmentData[i].Index] != 0;
        }
    }
    return FALSE;
}
public final function LoadAchievementData(array<AchievementDetails> AchievementsList, BioPlayerController PC)
{
    local int idx;
    local int AccomplishmentArrayIndex;
    local bool bSaveProfile;
    local AchievementDetails Achievement;
    
    if (!IsDataValidated)
    {
        Validate();
    }
    for (idx = 0; idx < AchievementsList.Length; idx++)
    {
        Achievement = AchievementsList[idx];
        if (Class'WorldInfo'.static.IsConsoleBuild(2))
        {
            AccomplishmentArrayIndex = AccomplishmentData.Find('PS3TrophyID', Achievement.Id);
        }
        else
        {
            AccomplishmentArrayIndex = AccomplishmentData.Find('XboxAchievementID', Achievement.Id);
        }
        if (AccomplishmentArrayIndex != -1)
        {
            if (int(GetAccomplishmentStorage(AccomplishmentArrayIndex)) != 1)
            {
            }
            if (PropagateAccomplishmentCompletion(AccomplishmentData[AccomplishmentArrayIndex].Index, Achievement.bWasAchievedOffline || Achievement.bWasAchievedOnline, PC, FALSE))
            {
                bSaveProfile = TRUE;
            }
            continue;
        }
    }
    if (bSaveProfile)
    {
        PC.SaveProfile(TRUE, FALSE);
    }
}
public final function LoadSettingsData(SFXProfileSettings CurrentProfileSettings)
{
    local int i;
    
    if (!IsDataValidated)
    {
        Validate();
    }
    if (CurrentProfileSettings != None)
    {
        for (i = 0; i < AccomplishmentData.Length; ++i)
        {
            if (int(GetAccomplishmentStorage(i)) == 3)
            {
                AccomplishmentIsComplete[AccomplishmentData[i].Index] = CurrentProfileSettings.HasCompletedAccomplishment(AccomplishmentData[i].Index) ? 1 : 0;
            }
        }
        if (AccomplishmentStorage != None)
        {
            AccomplishmentStorage.ReadFromProfileSettings(Self, CurrentProfileSettings);
        }
    }
}
public final function LoadStorageData(byte LocalUserNum, bool bWasSuccessful)
{
    if (!IsDataValidated)
    {
        Validate();
    }
    if (bWasSuccessful)
    {
        AccomplishmentStorage.LoadCompleted();
        AccomplishmentStorage.ReadFromStorage(Self);
    }
}
private final function bool PropagateAccomplishmentCompletion(int Index, bool IsComplete, BioPlayerController PC, bool bSaveProfile)
{
    if (Index < 0 && Index >= AccomplishmentIsComplete.Length)
    {
        return FALSE;
    }
    AccomplishmentIsComplete[Index] = IsComplete ? 1 : 0;
    if (PC == None || PC.ProfileSettings == None)
    {
        return FALSE;
    }
    if (IsComplete)
    {
        return PC.ProfileSettings.SetAccomplishmentCompleted(Index, PC, bSaveProfile);
    }
    else
    {
        return PC.ProfileSettings.SetAccomplishmentUncompleted(Index, PC, bSaveProfile);
    }
}
public final function SaveComplete(byte LocalUserNum, bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        AccomplishmentStorage.SaveCompleted();
        AccomplishmentStorage.IsInvalid = FALSE;
    }
    AccomplishmentStorage.AcknowledgeWriteComplete(LocalUserNum, SaveComplete);
}
public final function bool SetAccomplishmentCompleted(Name AccomplishmentName, BioPlayerController PC)
{
    local LocalPlayer LP;
    local array<GrinderAccomplishment> GAList;
    local GrinderAccomplishment GA;
    local Accomplishment CurrentAccomplishment;
    local int i;
    local int CurrentIndex;
    local int PlatformAchievementId;
    local int PlatformAvatarAwardId;
    
    if (PC == None || PC.ProfileSettings == None)
    {
        return FALSE;
    }
    CurrentIndex = -1;
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (AccomplishmentData[i].Name == AccomplishmentName)
        {
            PropagateAccomplishmentCompletion(AccomplishmentData[i].Index, TRUE, PC, TRUE);
            CurrentIndex = i;
            break;
        }
    }
    if (CurrentIndex < 0)
    {
        return FALSE;
    }
    UnlockReward(AccomplishmentName, PC);
    UpdateAccomplishmentTree(AccomplishmentData[CurrentIndex].Parent, PC);
    if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE || AccomplishmentData[CurrentIndex].LinkedAchievementID == EAchievementID.ACHIEVEMENT_NONE)
    {
        if (GetGrinderAccomplishment(AccomplishmentName, GAList))
        {
            GA = GAList[0];
        }
        CurrentAccomplishment = AccomplishmentData[CurrentIndex];
        PC.HintSystem.AddNotification_AccomplishmentUnlocked(CurrentAccomplishment, GA);
    }
    if (AccomplishmentData[CurrentIndex].IsMultiplayerOnly && PC.OnlineSub != None)
    {
        SFXOnlineSubsystem(PC.OnlineSub).GetComponentJobQueue().AddJob(CreateJobSendAchievementMessage(CurrentIndex));
    }
    Class'SFXTelemetry'.static.SendAchievement(int(AccomplishmentData[CurrentIndex].LinkedAchievementID));
    if (int(GetAccomplishmentStorage(CurrentIndex)) != 1)
    {
        return TRUE;
    }
    if (PC.OnlineSub != None && PC.OnlineSub.PlayerInterfaceEx != None)
    {
        LP = LocalPlayer(PC.Player);
        PlatformAchievementId = int(AccomplishmentData[CurrentIndex].LinkedAchievementID);
        PlatformAvatarAwardId = -1;
        if (Class'WorldInfo'.static.IsConsoleBuild(1))
        {
            PlatformAchievementId = AccomplishmentData[CurrentIndex].XboxAchievementID;
            PlatformAvatarAwardId = AccomplishmentData[CurrentIndex].XboxAvatarAwardID;
        }
        else if (Class'WorldInfo'.static.IsConsoleBuild(2))
        {
            PlatformAchievementId = AccomplishmentData[CurrentIndex].PS3TrophyID;
        }
        if (PlatformAvatarAwardId >= 0)
        {
            if (PC.OnlineSub.PlayerInterfaceEx.UnlockAvatarAward(byte(LP.ControllerId), PlatformAvatarAwardId) == FALSE)
            {
            }
        }
        if (PlatformAchievementId < 0)
        {
            return FALSE;
        }
        if (PC.OnlineSub.PlayerInterface.UnlockAchievement(byte(LP.ControllerId), PlatformAchievementId) == FALSE)
        {
        }
    }
    return TRUE;
}
public final function bool SetAccomplishmentUncompleted(Name AccomplishmentName, BioPlayerController PC);

public final function SetGrinderAccomplishmentProgress(Name AccomplishmentProgressName, int Progress, BioPlayerController PC)
{
    local int i;
    local EProfileSetting ProfileSettingId;
    
    ProfileSettingId = GetProfileSettingFromAccomplishmentProgress(AccomplishmentProgressName);
    if (ProfileSettingId != EProfileSetting.Setting_Unknown)
    {
        if (PC != None && PC.ProfileSettings != None && PC.ProfileSettings.SetProfileSettingValueInt(int(ProfileSettingId), Progress))
        {
            PC.SaveProfile(TRUE, FALSE);
        }
    }
    for (i = 0; i < AccomplishmentProgressData.Length; ++i)
    {
        if (AccomplishmentProgressData[i].Name == AccomplishmentProgressName)
        {
            AccomplishmentStorage.ProgressValues[AccomplishmentProgressData[i].Index] = Progress;
            break;
        }
    }
}
public final function bool SetGrinderAccomplishmentProgressWithUpdate(Name AccomplishmentProgressName, int Progress, BioPlayerController PC)
{
    local int i;
    local int J;
    local int CurrentIndex;
    local int OldProgress;
    local string Title;
    local string Description;
    local GrinderAccomplishment CurrentGrinder;
    local bool IsProgressStillUsed;
    local bool bFound;
    local array<Name> AccomplishmentTreeBranchAlreadyNotified;
    
    if (BioWorldInfo(PC.WorldInfo).GetGlobalVariables().GetBoolByName('IgnoreGrinderAccomplishments'))
    {
        return FALSE;
    }
    OldProgress = GetGrinderAccomplishmentProgress(AccomplishmentProgressName, PC);
    if (OldProgress == Progress)
    {
        return FALSE;
    }
    for (i = 0; i < GrinderAccomplishmentData.Length; ++i)
    {
        if (GrinderAccomplishmentData[i].AccomplishmentProgressName == AccomplishmentProgressName)
        {
            CurrentGrinder = GrinderAccomplishmentData[i];
            bFound = FALSE;
            for (J = 0; J < AccomplishmentData.Length; ++J)
            {
                if (AccomplishmentData[J].Name == CurrentGrinder.AccomplishmentName)
                {
                    CurrentIndex = J;
                    bFound = TRUE;
                    break;
                }
            }
            if (!bFound)
            {
            }
            if (bFound && AccomplishmentIsComplete[AccomplishmentData[CurrentIndex].Index] == 0 && AccomplishmentTreeBranchAlreadyNotified.Find(AccomplishmentData[CurrentIndex].Parent) < 0)
            {
                IsProgressStillUsed = TRUE;
                AccomplishmentTreeBranchAlreadyNotified.AddItem(AccomplishmentData[CurrentIndex].Parent);
                if (Progress >= CurrentGrinder.Goal)
                {
                    PC.UnlockAccomplishment(CurrentGrinder.AccomplishmentName);
                    continue;
                }
                if (Progress %  CurrentGrinder.Interval == 0 || Progress == 1)
                {
                    Title = Class'SFXGame'.static.GetSimpleString(CurrentGrinder.Title);
                    ClearCustomTokens();
                    if (CurrentGrinder.Goal > 0)
                    {
                        SetCustomToken(0, string(CurrentGrinder.Goal));
                    }
                    if (CurrentGrinder.MPDescription != 0 && (PC.WorldInfo.NetMode != ENetMode.NM_Standalone || PC.WorldInfo.bIsLobbyLevel))
                    {
                        Description = Class'SFXGame'.static.GetSimpleString(CurrentGrinder.MPDescription, TRUE);
                    }
                    else
                    {
                        Description = Class'SFXGame'.static.GetSimpleString(CurrentGrinder.Description, TRUE);
                    }
                    PC.HintSystem.AddNotification_AccomplishmentChange(Title, Progress $ "/" $ CurrentGrinder.Goal, Description, Progress, CurrentGrinder.Goal, AccomplishmentData[CurrentIndex].Icon);
                }
            }
        }
    }
    if (IsProgressStillUsed)
    {
        SetGrinderAccomplishmentProgress(AccomplishmentProgressName, Progress, PC);
    }
    return IsProgressStillUsed;
}
public function bool UnlockReward(Name AccomplishmentName, BioPlayerController PC)
{
    local int idx;
    local SFXModule_GameEffectManager GEManager;
    local Class<SFXGameEffect> EffectClass;
    local SFXGameEffect Reward;
    
    if (PC == None || PC.Pawn == None)
    {
        return FALSE;
    }
    for (idx = 0; idx < Rewards.Length; idx++)
    {
        if (AccomplishmentName == Rewards[idx].AccomplishmentName)
        {
            GEManager = PC.Pawn.GetModule(Class'SFXModule_GameEffectManager');
            if (GEManager != None)
            {
                EffectClass = Class<SFXGameEffect>(FindObject(Rewards[idx].Effect, Class'Class'));
                if (EffectClass != None)
                {
                    Reward = GEManager.CreateEffect(EffectClass, 'Achievement_Reward', 0.0, 0, 0.0);
                    if (Reward != None)
                    {
                        Reward.OnApplied();
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}
private final function UpdateAccomplishmentTree(Name ParentAccomplishment, BioPlayerController PC)
{
    local int i;
    
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (AccomplishmentData[i].Name == ParentAccomplishment)
        {
            if (AreAllChildAccomplishmentsCompleted(AccomplishmentData[i].Name))
            {
                SetAccomplishmentCompleted(AccomplishmentData[i].Name, PC);
            }
            return;
        }
    }
}
public final function Validate()
{
    local int i;
    local int J;
    local int K;
    local array<Name> TempAccomplishmentNames;
    local array<int> TempAccomplishmentIndexes;
    local bool bFound;
    
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (TempAccomplishmentNames.Find(AccomplishmentData[i].Name) > -1)
        {
        }
        TempAccomplishmentNames.AddItem(AccomplishmentData[i].Name);
        if (TempAccomplishmentIndexes.Find(AccomplishmentData[i].Index) > -1)
        {
        }
        TempAccomplishmentIndexes.AddItem(AccomplishmentData[i].Index);
        if (AccomplishmentData[i].IsMultiplayerOnly)
        {
            for (J = 0; J < GrinderAccomplishmentData.Length; ++J)
            {
                if (GrinderAccomplishmentData[J].AccomplishmentName == AccomplishmentData[i].Name)
                {
                    for (K = 0; K < AccomplishmentProgressData.Length; ++K)
                    {
                        if (AccomplishmentProgressData[K].LinkedProfileSetting != EProfileSetting.Setting_Unknown && AccomplishmentProgressData[K].Name == GrinderAccomplishmentData[J].AccomplishmentProgressName)
                        {
                        }
                    }
                }
            }
        }
    }
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        J = i;
        while (AccomplishmentData[J].Parent != Name("none"))
        {
            if (AccomplishmentData[J].Parent == AccomplishmentData[i].Name)
            {
                break;
                continue;
            }
            bFound = FALSE;
            for (K = 0; K < AccomplishmentData.Length; ++K)
            {
                if (AccomplishmentData[K].Name == AccomplishmentData[J].Parent)
                {
                    J = K;
                    bFound = TRUE;
                    break;
                }
            }
            if (!bFound)
            {
                break;
            }
        }
    }
    TempAccomplishmentNames.Length = 0;
    TempAccomplishmentIndexes.Length = 0;
    for (i = 0; i < AccomplishmentProgressData.Length; ++i)
    {
        if (TempAccomplishmentNames.Find(AccomplishmentProgressData[i].Name) > -1)
        {
        }
        TempAccomplishmentNames.AddItem(AccomplishmentProgressData[i].Name);
        if (TempAccomplishmentIndexes.Find(AccomplishmentProgressData[i].Index) > -1)
        {
        }
        TempAccomplishmentIndexes.AddItem(AccomplishmentProgressData[i].Index);
    }
    IsDataValidated = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AccomplishmentData = ({
                           Icon = "GUI_Achievement_Images.01_driven", 
                           Name = 'PROEAR', 
                           Parent = 'None', 
                           Index = 0, 
                           XboxAchievementID = 102, 
                           XboxAvatarAwardID = 3, 
                           PS3TrophyID = 1, 
                           Title = $558082, 
                           Incomplete = $558104, 
                           Complete = $558104, 
                           PointValue = 5, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_00_PROEAR
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.02_bringer_of_war", 
                           Name = 'PROMAR', 
                           Parent = 'None', 
                           Index = 1, 
                           XboxAchievementID = 103, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 2, 
                           Title = $558083, 
                           Incomplete = $558105, 
                           Complete = $558105, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_01_PROMAR
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.03_mobilizer", 
                           Name = 'KROGAR', 
                           Parent = 'None', 
                           Index = 2, 
                           XboxAchievementID = 104, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 3, 
                           Title = $660010, 
                           Incomplete = $660027, 
                           Complete = $660027, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_02_KROGAR
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.04_world_shaker", 
                           Name = 'KRO001', 
                           Parent = 'None', 
                           Index = 3, 
                           XboxAchievementID = 105, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 4, 
                           Title = $558085, 
                           Incomplete = $558107, 
                           Complete = $558107, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_03_KRO001
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.05_pathfinder", 
                           Name = 'KRO002', 
                           Parent = 'None', 
                           Index = 4, 
                           XboxAchievementID = 106, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 5, 
                           Title = $558086, 
                           Incomplete = $558108, 
                           Complete = $558108, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_04_KRO002
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.06_tunnel_rat", 
                           Name = 'KROGRU', 
                           Parent = 'None', 
                           Index = 5, 
                           XboxAchievementID = 107, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 6, 
                           Title = $558087, 
                           Incomplete = $558109, 
                           Complete = $558109, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_05_KROGRU
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.07_party_crasher", 
                           Name = 'GTH001', 
                           Parent = 'None', 
                           Index = 6, 
                           XboxAchievementID = 108, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 7, 
                           Title = $558089, 
                           Incomplete = $558111, 
                           Complete = $558111, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_06_GTH001
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.08_hard_target", 
                           Name = 'GTH002', 
                           Parent = 'None', 
                           Index = 7, 
                           XboxAchievementID = 109, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 8, 
                           Title = $558090, 
                           Incomplete = $558112, 
                           Complete = $558112, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_07_GTH002
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.09_saboteur", 
                           Name = 'GTHLEG', 
                           Parent = 'None', 
                           Index = 8, 
                           XboxAchievementID = 110, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 9, 
                           Title = $558091, 
                           Incomplete = $558113, 
                           Complete = $558113, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_08_GTHLEG
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.10_arbiter", 
                           Name = 'CAT003', 
                           Parent = 'None', 
                           Index = 9, 
                           XboxAchievementID = 111, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 10, 
                           Title = $558092, 
                           Incomplete = $558114, 
                           Complete = $558114, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_09_CAT003
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.11_last_witness", 
                           Name = 'CAT002', 
                           Parent = 'None', 
                           Index = 10, 
                           XboxAchievementID = 112, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 11, 
                           Title = $558093, 
                           Incomplete = $558115, 
                           Complete = $558115, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_10_CAT002
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.12_executioner", 
                           Name = 'CAT004', 
                           Parent = 'None', 
                           Index = 11, 
                           XboxAchievementID = 113, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 12, 
                           Title = $558094, 
                           Incomplete = $558116, 
                           Complete = $558116, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_11_CAT004
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.13_well_connected", 
                           Name = 'CERMIR', 
                           Parent = 'None', 
                           Index = 12, 
                           XboxAchievementID = 114, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 13, 
                           Title = $558095, 
                           Incomplete = $558117, 
                           Complete = $558117, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_12_CERMIR
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.14_fact_finder", 
                           Name = 'CITSAM', 
                           Parent = 'None', 
                           Index = 13, 
                           XboxAchievementID = 115, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 14, 
                           Title = $558096, 
                           Incomplete = $558118, 
                           Complete = $558118, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_13_CITSAM
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.15_liberator", 
                           Name = 'OMGJCK', 
                           Parent = 'None', 
                           Index = 14, 
                           XboxAchievementID = 116, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 15, 
                           Title = $558097, 
                           Incomplete = $558119, 
                           Complete = $558119, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_14_OMGJCK
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.16_problem_solver", 
                           Name = 'CERJCB', 
                           Parent = 'None', 
                           Index = 15, 
                           XboxAchievementID = 117, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 16, 
                           Title = $558098, 
                           Incomplete = $558120, 
                           Complete = $558120, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_15_CERJCB
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.17_patriot", 
                           Name = 'END001', 
                           Parent = 'None', 
                           Index = 16, 
                           XboxAchievementID = 118, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 17, 
                           Title = $558099, 
                           Incomplete = $558121, 
                           Complete = $558121, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_16_END001
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.18_legend", 
                           Name = 'END002', 
                           Parent = 'None', 
                           Index = 17, 
                           XboxAchievementID = 119, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 18, 
                           Title = $558100, 
                           Incomplete = $558122, 
                           Complete = $558122, 
                           PointValue = 50, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_17_END002
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.19_shopaholic", 
                           Name = 'Store', 
                           Parent = 'None', 
                           Index = 18, 
                           XboxAchievementID = 120, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 19, 
                           Title = $558079, 
                           Incomplete = $558101, 
                           Complete = $558101, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_18_STORE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.20_commander", 
                           Name = 'ENDGAMEMAX', 
                           Parent = 'None', 
                           Index = 19, 
                           XboxAchievementID = 121, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 20, 
                           Title = $558080, 
                           Incomplete = $558102, 
                           Complete = $558102, 
                           PointValue = 50, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_19_ENDGAMEMAX
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.21_lost_and_found", 
                           Name = 'FINDSALVAGE', 
                           Parent = 'None', 
                           Index = 20, 
                           XboxAchievementID = 122, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 21, 
                           Title = $558081, 
                           Incomplete = $558103, 
                           Complete = $558103, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_20_FINDSALVAGE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.22_long_service", 
                           Name = 'Import', 
                           Parent = 'None', 
                           Index = 21, 
                           XboxAchievementID = 123, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 22, 
                           Title = $582571, 
                           Incomplete = $582586, 
                           Complete = $582586, 
                           PointValue = 50, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_21_IMPORT
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.23_insanity", 
                           Name = 'INSANITY', 
                           Parent = 'None', 
                           Index = 22, 
                           XboxAchievementID = 124, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 23, 
                           Title = $582572, 
                           Incomplete = $582587, 
                           Complete = $582587, 
                           PointValue = 75, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_22_INSANITY
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.24_a_personal_touch", 
                           Name = 'WEAPONMOD', 
                           Parent = 'None', 
                           Index = 23, 
                           XboxAchievementID = 125, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 24, 
                           Title = $582573, 
                           Incomplete = $582588, 
                           Complete = $582588, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_23_WEAPONMOD
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.25_paramour", 
                           Name = 'ROMANCE', 
                           Parent = 'None', 
                           Index = 24, 
                           XboxAchievementID = 126, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 25, 
                           Title = $582574, 
                           Incomplete = $582589, 
                           Complete = $582589, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_24_ROMANCE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.26_combined_arms", 
                           Name = 'POWERCOMBO', 
                           Parent = 'None', 
                           Index = 25, 
                           XboxAchievementID = 127, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 26, 
                           Title = $582575, 
                           Incomplete = $582590, 
                           Complete = $582590, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_25_POWERCOMBO
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.27_focused", 
                           Name = 'MAXPOWER', 
                           Parent = 'None', 
                           Index = 26, 
                           XboxAchievementID = 128, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 27, 
                           Title = $582576, 
                           Incomplete = $582591, 
                           Complete = $582591, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_26_MAXPOWER
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.28_recruit", 
                           Name = 'KILLA', 
                           Parent = 'None', 
                           Index = 27, 
                           XboxAchievementID = 129, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 28, 
                           Title = $582577, 
                           Incomplete = $582592, 
                           Complete = $582592, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_27_KILLA
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.29_soldier", 
                           Name = 'KILLB', 
                           Parent = 'None', 
                           Index = 28, 
                           XboxAchievementID = 130, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 29, 
                           Title = $582578, 
                           Incomplete = $582593, 
                           Complete = $582593, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_28_KILLB
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.30_veteran", 
                           Name = 'KILLC', 
                           Parent = 'None', 
                           Index = 29, 
                           XboxAchievementID = 131, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 30, 
                           Title = $582579, 
                           Incomplete = $582594, 
                           Complete = $582594, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_29_KILLC
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.31_bruiser", 
                           Name = 'Melee', 
                           Parent = 'None', 
                           Index = 30, 
                           XboxAchievementID = 132, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 31, 
                           Title = $582580, 
                           Incomplete = $582595, 
                           Complete = $582595, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_30_MELEE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.32_untouchable", 
                           Name = 'ESCAPEREAPER', 
                           Parent = 'None', 
                           Index = 31, 
                           XboxAchievementID = 133, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 32, 
                           Title = $660005, 
                           Incomplete = $660022, 
                           Complete = $660022, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_31_ESCAPEREAPER
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.33_defender", 
                           Name = 'MAXSECURITY', 
                           Parent = 'None', 
                           Index = 32, 
                           XboxAchievementID = 134, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 33, 
                           Title = $660006, 
                           Incomplete = $660023, 
                           Complete = $660023, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_32_MAXSECURITY
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.34_overload_specialist", 
                           Name = 'OVERLOADSHIELDS', 
                           Parent = 'None', 
                           Index = 33, 
                           XboxAchievementID = 135, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 34, 
                           Title = $582581, 
                           Incomplete = $582596, 
                           Complete = $582596, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_33_OVERLOADSHIELDS
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.35_sky_high", 
                           Name = 'ENEMIESFLYING', 
                           Parent = 'None', 
                           Index = 34, 
                           XboxAchievementID = 136, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 35, 
                           Title = $582582, 
                           Incomplete = $582597, 
                           Complete = $582597, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_34_ENEMIESFLYING
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.36_pyromaniac", 
                           Name = 'ENEMIESONFIRE', 
                           Parent = 'None', 
                           Index = 35, 
                           XboxAchievementID = 137, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 36, 
                           Title = $660007, 
                           Incomplete = $660024, 
                           Complete = $660024, 
                           PointValue = 15, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_35_ENEMIESONFIRE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.37_eye_of_the_hurricaine", 
                           Name = 'BRUTECHARGE', 
                           Parent = 'None', 
                           Index = 36, 
                           XboxAchievementID = 138, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 37, 
                           Title = $660008, 
                           Incomplete = $660025, 
                           Complete = $660025, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_36_BRUTECHARGE
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.38_peekaboo", 
                           Name = 'GUARDIANMAILSLOT', 
                           Parent = 'None', 
                           Index = 37, 
                           XboxAchievementID = 139, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 38, 
                           Title = $582583, 
                           Incomplete = $582598, 
                           Complete = $582598, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_37_GUARDIANMAILSLOT
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.39_hijacker", 
                           Name = 'HIJACKATLAS', 
                           Parent = 'None', 
                           Index = 38, 
                           XboxAchievementID = 140, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 39, 
                           Title = $582584, 
                           Incomplete = $582599, 
                           Complete = $582599, 
                           PointValue = 10, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_38_HIJACKATLAS
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.40_big_game_hunter", 
                           Name = 'HARVESTER', 
                           Parent = 'None', 
                           Index = 39, 
                           XboxAchievementID = 141, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 40, 
                           Title = $558084, 
                           Incomplete = $558106, 
                           Complete = $558106, 
                           PointValue = 5, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_39_HARVESTER
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.41_trainee", 
                           Name = 'CREATECHAR', 
                           Parent = 'None', 
                           Index = 40, 
                           XboxAchievementID = 143, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 41, 
                           Title = $660009, 
                           Incomplete = $660026, 
                           Complete = $660026, 
                           PointValue = 15, 
                           NotificationText = $723150, 
                           MPNotificationText = $723149, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_40_CREATECHAR
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.42_tour_of_duty", 
                           Name = 'PLAYALLMAPS', 
                           Parent = 'None', 
                           Index = 41, 
                           XboxAchievementID = 144, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 42, 
                           Title = $582585, 
                           Incomplete = $582600, 
                           Complete = $582600, 
                           PointValue = 15, 
                           NotificationText = $723152, 
                           MPNotificationText = $723151, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_41_PLAYALLMAPS
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.43_always_prepared", 
                           Name = 'PREPARED', 
                           Parent = 'None', 
                           Index = 42, 
                           XboxAchievementID = 146, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 43, 
                           Title = $660011, 
                           Incomplete = $660028, 
                           Complete = $660028, 
                           PointValue = 10, 
                           NotificationText = $723154, 
                           MPNotificationText = $723153, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_42_PREPARED
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.44_tourist", 
                           Name = 'MISSIONSA', 
                           Parent = 'None', 
                           Index = 43, 
                           XboxAchievementID = 147, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 44, 
                           Title = $660012, 
                           Incomplete = $660029, 
                           Complete = $660029, 
                           PointValue = 10, 
                           NotificationText = $723156, 
                           MPNotificationText = $723155, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_43_MISSIONSA
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.45_explorer", 
                           Name = 'MISSIONSB', 
                           Parent = 'None', 
                           Index = 44, 
                           XboxAchievementID = 148, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 45, 
                           Title = $660013, 
                           Incomplete = $660030, 
                           Complete = $660030, 
                           PointValue = 15, 
                           NotificationText = $723158, 
                           MPNotificationText = $723157, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_44_MISSIONSB
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.46_gunsmith", 
                           Name = 'WEAPONMAXED', 
                           Parent = 'None', 
                           Index = 45, 
                           XboxAchievementID = 149, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 46, 
                           Title = $660014, 
                           Incomplete = $660031, 
                           Complete = $660031, 
                           PointValue = 25, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_45_WEAPONMAXED
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.47_half-way_there", 
                           Name = 'HighLevel', 
                           Parent = 'None', 
                           Index = 46, 
                           XboxAchievementID = 150, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 47, 
                           Title = $660015, 
                           Incomplete = $660032, 
                           Complete = $660032, 
                           PointValue = 15, 
                           NotificationText = $723160, 
                           MPNotificationText = $723159, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_46_HIGHLEVEL
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.26_peak_condition", 
                           Name = 'MaxLevel', 
                           Parent = 'None', 
                           Index = 47, 
                           XboxAchievementID = 151, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 48, 
                           Title = $660016, 
                           Incomplete = $660033, 
                           Complete = $660033, 
                           PointValue = 25, 
                           NotificationText = $723162, 
                           MPNotificationText = $723161, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_47_MAXLEVEL
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.49_starbound", 
                           Name = 'NEWGAME', 
                           Parent = 'None', 
                           Index = 48, 
                           XboxAchievementID = 152, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 49, 
                           Title = $660017, 
                           Incomplete = $660034, 
                           Complete = $660034, 
                           PointValue = 25, 
                           NotificationText = $723164, 
                           MPNotificationText = $723163, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_48_NEWGAME
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.00_hardcore", 
                           Name = 'ALLMAPSGOLD', 
                           Parent = 'None', 
                           Index = 49, 
                           XboxAchievementID = 153, 
                           XboxAvatarAwardID = -1, 
                           PS3TrophyID = 50, 
                           Title = $660018, 
                           Incomplete = $660035, 
                           Complete = $660035, 
                           PointValue = 50, 
                           NotificationText = $723166, 
                           MPNotificationText = $723165, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.ACHIEVEMENT_49_ALLMAPSGOLD
                          }, 
                          {
                           Icon = "GUI_Achievement_Images.OmniBlade_256", 
                           Name = 'AVATAROMNIBLADE', 
                           Parent = 'None', 
                           Index = 50, 
                           XboxAchievementID = -1, 
                           XboxAvatarAwardID = 4, 
                           PS3TrophyID = -1, 
                           Title = $723147, 
                           Incomplete = $723148, 
                           Complete = $723148, 
                           PointValue = 0, 
                           NotificationText = $0, 
                           MPNotificationText = $0, 
                           IsMultiplayerOnly = FALSE, 
                           LinkedAchievementID = EAchievementID.AVATAR_00_OMNIBLADE
                          }
                         )
    AccomplishmentProgressData = ({Name = 'SALVAGECOUNT', Index = 1, LinkedProfileSetting = EProfileSetting.Setting_NumSalvageFound}, 
                                  {Name = 'LEVELCOUNT', Index = 2, LinkedProfileSetting = EProfileSetting.Setting_SPLevel}, 
                                  {Name = 'MPLEVELCOUNT', Index = 3, LinkedProfileSetting = EProfileSetting.Setting_Unknown}, 
                                  {Name = 'KILLCOUNT', Index = 4, LinkedProfileSetting = EProfileSetting.Setting_NumKills}, 
                                  {Name = 'MELEEKILLCOUNT', Index = 5, LinkedProfileSetting = EProfileSetting.Setting_NumMeleeKills}, 
                                  {Name = 'OVERLOADCOUNT', Index = 6, LinkedProfileSetting = EProfileSetting.Setting_NumShieldsOverloaded}, 
                                  {Name = 'FLYINGCOUNT', Index = 7, LinkedProfileSetting = EProfileSetting.Setting_NumEnemiesFlying}, 
                                  {Name = 'ONFIRECOUNT', Index = 8, LinkedProfileSetting = EProfileSetting.Setting_NumEnemiesOnFire}, 
                                  {Name = 'COMBOCOUNT', Index = 9, LinkedProfileSetting = EProfileSetting.Setting_NumPowerCombos}, 
                                  {Name = 'GUARDIANHEADKILLCOUNT', Index = 10, LinkedProfileSetting = EProfileSetting.Setting_NumGuardianHeadKilled}, 
                                  {Name = 'SPPLAYEDMAPS', Index = 11, LinkedProfileSetting = EProfileSetting.Setting_SPMaps}, 
                                  {Name = 'SPMAPSCOUNT', Index = 12, LinkedProfileSetting = EProfileSetting.Setting_SPMapsCount}, 
                                  {Name = 'MPPLAYEDMAPS', Index = 13, LinkedProfileSetting = EProfileSetting.Setting_Unknown}, 
                                  {Name = 'MPMAPSCOUNT', Index = 14, LinkedProfileSetting = EProfileSetting.Setting_Unknown}, 
                                  {Name = 'SPPLAYEDMAPSINSANE', Index = 15, LinkedProfileSetting = EProfileSetting.Setting_SPMapsInsane}, 
                                  {Name = 'SPMAPSINSANECOUNT', Index = 16, LinkedProfileSetting = EProfileSetting.Setting_SPMapsInsaneCount}, 
                                  {Name = 'MPPLAYEDMAPSGOLD', Index = 17, LinkedProfileSetting = EProfileSetting.Setting_Unknown}, 
                                  {Name = 'MPMAPSGOLDCOUNT', Index = 18, LinkedProfileSetting = EProfileSetting.Setting_Unknown}, 
                                  {Name = 'ARMORCOUNT', Index = 19, LinkedProfileSetting = EProfileSetting.Setting_NumArmorBought}, 
                                  {Name = 'WeaponLevel', Index = 20, LinkedProfileSetting = EProfileSetting.Setting_WeaponLevel}, 
                                  {Name = 'POWERLEVEL', Index = 21, LinkedProfileSetting = EProfileSetting.Setting_PowerLevel}
                                 )
    GrinderAccomplishmentData = ({
                                  AccomplishmentName = 'FINDSALVAGE', 
                                  AccomplishmentProgressName = 'SALVAGECOUNT', 
                                  Goal = 10, 
                                  Interval = 1, 
                                  Title = $558081, 
                                  Description = $558103, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'KILLA', 
                                  AccomplishmentProgressName = 'KILLCOUNT', 
                                  Goal = 250, 
                                  Interval = 25, 
                                  Title = $582577, 
                                  Description = $582592, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'KILLB', 
                                  AccomplishmentProgressName = 'KILLCOUNT', 
                                  Goal = 1000, 
                                  Interval = 100, 
                                  Title = $582578, 
                                  Description = $582593, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'KILLC', 
                                  AccomplishmentProgressName = 'KILLCOUNT', 
                                  Goal = 5000, 
                                  Interval = 500, 
                                  Title = $582579, 
                                  Description = $582594, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'AVATAROMNIBLADE', 
                                  AccomplishmentProgressName = 'MELEEKILLCOUNT', 
                                  Goal = 25, 
                                  Interval = 5, 
                                  Title = $723147, 
                                  Description = $723148, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'Melee', 
                                  AccomplishmentProgressName = 'MELEEKILLCOUNT', 
                                  Goal = 100, 
                                  Interval = 10, 
                                  Title = $582580, 
                                  Description = $582595, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'OVERLOADSHIELDS', 
                                  AccomplishmentProgressName = 'OVERLOADCOUNT', 
                                  Goal = 100, 
                                  Interval = 10, 
                                  Title = $582581, 
                                  Description = $582596, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'ENEMIESFLYING', 
                                  AccomplishmentProgressName = 'FLYINGCOUNT', 
                                  Goal = 100, 
                                  Interval = 10, 
                                  Title = $582582, 
                                  Description = $582597, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'ENEMIESONFIRE', 
                                  AccomplishmentProgressName = 'ONFIRECOUNT', 
                                  Goal = 100, 
                                  Interval = 10, 
                                  Title = $660007, 
                                  Description = $660024, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'POWERCOMBO', 
                                  AccomplishmentProgressName = 'COMBOCOUNT', 
                                  Goal = 50, 
                                  Interval = 5, 
                                  Title = $582575, 
                                  Description = $582590, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'GUARDIANMAILSLOT', 
                                  AccomplishmentProgressName = 'GUARDIANHEADKILLCOUNT', 
                                  Goal = 10, 
                                  Interval = 1, 
                                  Title = $582583, 
                                  Description = $582598, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'HighLevel', 
                                  AccomplishmentProgressName = 'MPLEVELCOUNT', 
                                  Goal = 15, 
                                  Interval = 5, 
                                  Title = $660015, 
                                  Description = $660032, 
                                  MPDescription = $723159
                                 }, 
                                 {
                                  AccomplishmentName = 'HighLevel', 
                                  AccomplishmentProgressName = 'LEVELCOUNT', 
                                  Goal = 50, 
                                  Interval = 5, 
                                  Title = $660015, 
                                  Description = $723160, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'MaxLevel', 
                                  AccomplishmentProgressName = 'MPLEVELCOUNT', 
                                  Goal = 20, 
                                  Interval = 5, 
                                  Title = $660016, 
                                  Description = $660033, 
                                  MPDescription = $723161
                                 }, 
                                 {
                                  AccomplishmentName = 'MaxLevel', 
                                  AccomplishmentProgressName = 'LEVELCOUNT', 
                                  Goal = 60, 
                                  Interval = 5, 
                                  Title = $660016, 
                                  Description = $723162, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'MISSIONSA', 
                                  AccomplishmentProgressName = 'MPMAPSCOUNT', 
                                  Goal = 1, 
                                  Interval = 1, 
                                  Title = $660012, 
                                  Description = $660029, 
                                  MPDescription = $723155
                                 }, 
                                 {
                                  AccomplishmentName = 'MISSIONSA', 
                                  AccomplishmentProgressName = 'SPMAPSCOUNT', 
                                  Goal = 2, 
                                  Interval = 1, 
                                  Title = $660012, 
                                  Description = $723156, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'MISSIONSB', 
                                  AccomplishmentProgressName = 'MPMAPSCOUNT', 
                                  Goal = 3, 
                                  Interval = 1, 
                                  Title = $660013, 
                                  Description = $660030, 
                                  MPDescription = $723157
                                 }, 
                                 {
                                  AccomplishmentName = 'MISSIONSB', 
                                  AccomplishmentProgressName = 'SPMAPSCOUNT', 
                                  Goal = 5, 
                                  Interval = 1, 
                                  Title = $660013, 
                                  Description = $723158, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'PLAYALLMAPS', 
                                  AccomplishmentProgressName = 'MPMAPSCOUNT', 
                                  Goal = 6, 
                                  Interval = 1, 
                                  Title = $582585, 
                                  Description = $582600, 
                                  MPDescription = $723151
                                 }, 
                                 {
                                  AccomplishmentName = 'PLAYALLMAPS', 
                                  AccomplishmentProgressName = 'SPMAPSCOUNT', 
                                  Goal = 6, 
                                  Interval = 1, 
                                  Title = $582585, 
                                  Description = $723152, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'PREPARED', 
                                  AccomplishmentProgressName = 'ARMORCOUNT', 
                                  Goal = 2, 
                                  Interval = 1, 
                                  Title = $660011, 
                                  Description = $723154, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'WEAPONMAXED', 
                                  AccomplishmentProgressName = 'WeaponLevel', 
                                  Goal = 10, 
                                  Interval = 1, 
                                  Title = $660014, 
                                  Description = $660031, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'ALLMAPSGOLD', 
                                  AccomplishmentProgressName = 'MPMAPSGOLDCOUNT', 
                                  Goal = 6, 
                                  Interval = 1, 
                                  Title = $660018, 
                                  Description = $660035, 
                                  MPDescription = $723165
                                 }, 
                                 {
                                  AccomplishmentName = 'ALLMAPSGOLD', 
                                  AccomplishmentProgressName = 'SPMAPSINSANECOUNT', 
                                  Goal = 27, 
                                  Interval = 1, 
                                  Title = $660018, 
                                  Description = $723166, 
                                  MPDescription = $0
                                 }, 
                                 {
                                  AccomplishmentName = 'MAXPOWER', 
                                  AccomplishmentProgressName = 'POWERLEVEL', 
                                  Goal = 6, 
                                  Interval = 1, 
                                  Title = $582576, 
                                  Description = $582591, 
                                  MPDescription = $0
                                 }
                                )
}