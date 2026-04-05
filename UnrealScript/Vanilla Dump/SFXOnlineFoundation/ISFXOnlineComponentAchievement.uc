Class ISFXOnlineComponentAchievement extends ISFXOnlineComponent
    native
    abstract;

public native function Grant(byte LocalUserNum, int AchievementId);

public native function bool IsGranted(byte LocalUserNum, int AchievementId);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}