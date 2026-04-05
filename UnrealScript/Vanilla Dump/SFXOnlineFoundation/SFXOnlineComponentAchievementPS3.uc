Class SFXOnlineComponentAchievementPS3 extends SFXOnlineComponent
    implements(ISFXOnlineComponentAchievement)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponentAchievement;

public native function Name GetAPIName();

public final native function Grant(byte LocalUserNum, int AchievementId);

public final native function bool IsGranted(byte LocalUserNum, int AchievementId);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}