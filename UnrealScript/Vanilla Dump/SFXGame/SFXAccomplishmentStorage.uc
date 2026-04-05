Class SFXAccomplishmentStorage
    native;

const BITS_PER_INT = 32;

var transient string ServerCompletionString;
var transient string ServerProgressString;
var transient array<int> ProgressValues;
var transient SFXOnlinePlayerStorage CachedOnlinePlayerStorage;
var transient bool IsInvalid;

public final function Initialize(int MinProgressValuesLength)
{
    CachedOnlinePlayerStorage = SFXEngine(Class'Engine'.static.GetEngine()).OnlinePlayerStorage;
    if (MinProgressValuesLength > ProgressValues.Length)
    {
        ProgressValues.Length = MinProgressValuesLength;
    }
}
private final native function array<int> StringArrayToIntArray(const out array<string> Strings);

public final function bool Write(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    if (CachedOnlinePlayerStorage == None)
    {
        return FALSE;
    }
    return CachedOnlinePlayerStorage.Write(LocalUserNum, WritePlayerStorageCompleteDelegate);
}
public final function AcknowledgeWriteComplete(byte LocalUserNum, delegate<OnlinePlayerInterface.OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    if (CachedOnlinePlayerStorage == None)
    {
        return;
    }
    CachedOnlinePlayerStorage.AcknowledgeWriteComplete(LocalUserNum, WritePlayerStorageCompleteDelegate);
}
private final function string GetCompletion(const out array<int> AccomplishmentIsComplete)
{
    local int i;
    local string Output;
    
    Output = string(CachedOnlinePlayerStorage.VersionNumber);
    for (i = 0; i < AccomplishmentIsComplete.Length; ++i)
    {
        if (AccomplishmentIsComplete[i] != 0)
        {
            Output = Output $ "," $ i;
        }
    }
    return Output;
}
private final function string GetProgress(const out array<AccomplishmentProgress> AccomplishmentProgressData)
{
    local string Output;
    local int i;
    
    Output = string(CachedOnlinePlayerStorage.VersionNumber);
    for (i = 0; i < ProgressValues.Length; ++i)
    {
        Output = Output $ "," $ ProgressValues[i];
    }
    return Output;
}
public final function LoadCompleted()
{
    UpdateServerValue();
}
public final function ReadFromProfileSettings(SFXAccomplishmentManager AccomplishmentManager, SFXProfileSettings CurrentProfileSettings)
{
    local int i;
    local int Value;
    
    for (i = 0; i < AccomplishmentManager.AccomplishmentProgressData.Length; ++i)
    {
        if (AccomplishmentManager.AccomplishmentProgressData[i].LinkedProfileSetting != EProfileSetting.Setting_Unknown)
        {
            if (CurrentProfileSettings.GetProfileSettingValueInt(int(AccomplishmentManager.AccomplishmentProgressData[i].LinkedProfileSetting), Value))
            {
                ProgressValues[AccomplishmentManager.AccomplishmentProgressData[i].Index] = Value;
                continue;
            }
        }
    }
}
public final function ReadFromStorage(SFXAccomplishmentManager AccomplishmentManager)
{
    local string WarnString;
    
    if (!SetCompletion(AccomplishmentManager.AccomplishmentData, AccomplishmentManager.AccomplishmentIsComplete) || !SetProgress(AccomplishmentManager.AccomplishmentProgressData))
    {
        WarnString = "SFXAccomplishmentStorage:ReadFromStorage encountered an error.";
        if (IsInvalid)
        {
            WarnString = WarnString @ "The version on the server was inconsistent with the local version; the server data will be overwritten and this message should disappear.";
        }
    }
}
public final function SaveCompleted()
{
    UpdateServerValue();
}
private final function bool SetCompletion(out array<Accomplishment> AccomplishmentData, out array<int> AccomplishmentIsComplete)
{
    local int i;
    local int J;
    local int PartsCursor;
    local int Version;
    local array<string> StringParts;
    local array<int> Completion;
    
    if (Len(ServerCompletionString) <= 0)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    ParseStringIntoArray(ServerCompletionString, StringParts, ",", FALSE);
    PartsCursor = 0;
    Version = int(StringParts[PartsCursor]);
    PartsCursor++;
    if (Version < 17)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    Completion = StringArrayToIntArray(StringParts);
    for (i = 0; i < AccomplishmentData.Length; ++i)
    {
        if (int(Class'SFXAccomplishmentManager'.static.GetAccomplishmentParamsStorage(AccomplishmentData[i].LinkedAchievementID, AccomplishmentData[i].IsMultiplayerOnly)) == 2)
        {
            AccomplishmentIsComplete[AccomplishmentData[i].Index] = Completion.Find(AccomplishmentData[i].Index) >= 0 ? 1 : 0;
            Completion.RemoveItem(AccomplishmentData[i].Index);
        }
    }
    for (i = 0; i < Completion.Length; ++i)
    {
        for (J = 0; J < AccomplishmentData.Length; ++J)
        {
            if (AccomplishmentData[J].Index == Completion[i])
            {
                break;
            }
        }
        if (J >= AccomplishmentData.Length)
        {
            AccomplishmentIsComplete[Completion[i]] = 1;
        }
    }
    return TRUE;
}
private final function bool SetProgress(const out array<AccomplishmentProgress> AccomplishmentProgressData)
{
    local int i;
    local int J;
    local int Version;
    local array<string> StringParts;
    local array<int> Values;
    local string logString;
    
    if (Len(ServerProgressString) <= 0)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    ParseStringIntoArray(ServerProgressString, StringParts, ",", FALSE);
    Version = int(StringParts[0]);
    if (Version < 18)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    else if (Version > CachedOnlinePlayerStorage.VersionNumber)
    {
        IsInvalid = TRUE;
        return FALSE;
    }
    Values = StringArrayToIntArray(StringParts);
    Values.Remove(0, 1);
    for (i = 0; i < Values.Length; i++)
    {
        for (J = 0; J < AccomplishmentProgressData.Length; ++J)
        {
            if (AccomplishmentProgressData[J].Index == i)
            {
                break;
            }
        }
        if (J >= AccomplishmentProgressData.Length || AccomplishmentProgressData[J].LinkedProfileSetting == EProfileSetting.Setting_Unknown)
        {
            ProgressValues[i] = Values[i];
            logString = "ACCOMPLISHMENT - Loading AccomplishmentProgress";
            if (J < AccomplishmentProgressData.Length)
            {
                logString = logString @ AccomplishmentProgressData[J].Name;
            }
            else
            {
                logString = logString @ "with index" @ i;
            }
            logString = logString @ "as" @ Values[i] @ "(AccomplishmentStorage - storage)";
        }
    }
    return TRUE;
}
public final function UpdateFromAccomplishments(const out array<int> AccomplishmentIsComplete, const out array<AccomplishmentProgress> AccomplishmentProgressData)
{
    local string BlankString;
    local string PendingString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        PendingString = GetCompletion(AccomplishmentIsComplete);
        if (PendingString != ServerCompletionString)
        {
            if (!CachedOnlinePlayerStorage.SetProfileSettingValue(89, PendingString))
            {
            }
        }
        else
        {
            CachedOnlinePlayerStorage.SetProfileSettingValue(89, BlankString);
        }
        PendingString = GetProgress(AccomplishmentProgressData);
        if (PendingString != ServerProgressString)
        {
            if (!CachedOnlinePlayerStorage.SetProfileSettingValue(90, PendingString))
            {
            }
        }
        else
        {
            CachedOnlinePlayerStorage.SetProfileSettingValue(90, BlankString);
        }
    }
}
private final function UpdateServerValue()
{
    local string SettingString;
    local string BlankString;
    
    if (CachedOnlinePlayerStorage != None)
    {
        BlankString = "";
        CachedOnlinePlayerStorage.GetProfileSettingValue(89, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerCompletionString = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(89, BlankString);
        }
        CachedOnlinePlayerStorage.GetProfileSettingValue(90, SettingString);
        if (Len(SettingString) > 0)
        {
            ServerProgressString = SettingString;
            CachedOnlinePlayerStorage.SetProfileSettingValue(90, BlankString);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}