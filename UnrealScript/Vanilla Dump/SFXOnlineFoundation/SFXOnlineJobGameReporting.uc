Class SFXOnlineJobGameReporting extends SFXOnlineJob
    native
    config(Game);

var config string ReportName;
var delegate<GameReportingCallback> __GameReportingCallback__Delegate;
var native Pointer mGameReport;

public native function BuildReport(OnlineStatsWrite StatsWrite);

public static event function SFXOnlineJobGameReporting CreateJob(delegate<GameReportingCallback> InCallback, OnlineStatsWrite StatsWrite)
{
    local SFXOnlineJobGameReporting Job;
    
    Job = new Class'SFXOnlineJobGameReporting';
    Job.__GameReportingCallback__Delegate = InCallback;
    Job.BuildReport(StatsWrite);
    return Job;
}
public delegate function GameReportingCallback(OnlineJobErrorCode errorCode, int InJobId);

public function OnRelease()
{
    OnReleaseImpl();
    Super.OnRelease();
}
private final native function OnReleaseImpl();

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReportName = "massEffectReport"
    RescheduleCount = 5
    JobType = OnlineJobType.OJT_GameReporting
}