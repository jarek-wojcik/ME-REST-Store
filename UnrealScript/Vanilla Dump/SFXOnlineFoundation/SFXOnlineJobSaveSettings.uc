Class SFXOnlineJobSaveSettings extends SFXOnlineJob
    native
    config(Game);

var array<SettingsPair> Settings;
var transient array<delegate<SFXOnlineComponentUnrealPlayer.OnWritePlayerStorageComplete>> JobCompleteDelegates;
var delegate<SaveSettingsCallback> __SaveSettingsCallback__Delegate;
var int CallbackArg;
var int OutstandingSubJobs;
var bool CallbackHasRun;

public final event function AddCompletionDelegate(delegate<SFXOnlineComponentUnrealPlayer.OnWritePlayerStorageComplete> JobCompleteDelegate)
{
    if (JobCompleteDelegates.Find(JobCompleteDelegate) == -1)
    {
        JobCompleteDelegates.AddItem(JobCompleteDelegate);
    }
}
public event function AddSetting(const out string InKey, const out string InValue)
{
    local SettingsPair Pair;
    
    Pair.Key = InKey;
    Pair.Value = InValue;
    Settings.AddItem(Pair);
}
public final event function CallCompletionDelegates(bool Success)
{
    local delegate<SFXOnlineComponentUnrealPlayer.OnWritePlayerStorageComplete> WriteDelegate;
    
    foreach JobCompleteDelegates(WriteDelegate, )
    {
        WriteDelegate(byte(CallbackArg), Success);
    }
}
public static event function SFXOnlineJobSaveSettings CreateJob(delegate<SaveSettingsCallback> InCallback, int InCallbackArg)
{
    local SFXOnlineJobSaveSettings Job;
    
    Job = new Class'SFXOnlineJobSaveSettings';
    Job.__SaveSettingsCallback__Delegate = InCallback;
    Job.CallbackArg = InCallbackArg;
    return Job;
}
public delegate function SaveSettingsCallback(OnlineJobErrorCode errorCode, int InJobId, int InCallbackArg);

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 5
    JobCategory = OnlineJobCategory.OJC_Storage
    JobType = OnlineJobType.OJT_SaveSettings
}