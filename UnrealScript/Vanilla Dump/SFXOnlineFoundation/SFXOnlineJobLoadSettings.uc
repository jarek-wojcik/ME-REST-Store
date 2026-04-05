Class SFXOnlineJobLoadSettings extends SFXOnlineJob
    native
    config(Game);

var array<SettingsPair> Settings;
var delegate<LoadSettingsCallback> __LoadSettingsCallback__Delegate;
var int CallbackArg;
var OnlineJobErrorCode RunningErrorCode;

public static event function SFXOnlineJobLoadSettings CreateJob(delegate<LoadSettingsCallback> InCallback, int InCallbackArg)
{
    local SFXOnlineJobLoadSettings Job;
    
    Job = new Class'SFXOnlineJobLoadSettings';
    Job.__LoadSettingsCallback__Delegate = InCallback;
    Job.CallbackArg = InCallbackArg;
    return Job;
}
public delegate function LoadSettingsCallback(OnlineJobErrorCode errorCode, int InJobId, array<SettingsPair> InSettings, int InCallbackArg);

public event function bool ShouldReschedule()
{
    return FALSE;
}
public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    JobType = OnlineJobType.OJT_LoadSettings
}