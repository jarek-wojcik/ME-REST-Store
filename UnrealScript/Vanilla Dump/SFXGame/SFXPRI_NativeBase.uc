Class SFXPRI_NativeBase extends PlayerReplicationInfo
    native;

var(SFXPRI_NativeBase) transient bool bSquadUsesPowers;
var(SFXPRI_NativeBase) transient bool bAutoSave;
var(SFXPRI_NativeBase) transient bool bAutoLogin;
var(SFXPRI_NativeBase) transient bool bSwapCrossCircle;
var(SFXPRI_NativeBase) transient bool bSwapTriggersShoulders;
var(SFXPRI_NativeBase) transient bool bHideCinematicHelmetPreference;
var(SFXPRI_NativeBase) transient EProfileControllerSensitivityOptions ControllerSensitivityConfig;
var(SFXPRI_NativeBase) transient ETriggerConfigOptions TriggerConfig;
var(SFXPRI_NativeBase) transient EStickConfigOptions StickConfig;
var(SFXPRI_NativeBase) transient EAimAssistOptions AimAssistConfig;
var(SFXPRI_NativeBase) transient EAutoLevelOptions AutoLevelUp;
var(SFXPRI_NativeBase) transient EHenchHelmetOptions HenchmenHelmetPreference;

public event simulated function Pawn GetAPawn()
{
    local Controller C;
    
    C = Controller(Owner);
    if (C != None)
    {
        return C.Pawn;
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bSquadUsesPowers = TRUE
    bAutoSave = TRUE
    bAutoLogin = TRUE
    AimAssistConfig = EAimAssistOptions.AAO_Normal
}