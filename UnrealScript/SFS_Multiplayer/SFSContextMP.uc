Class SFSContextMP extends SFSContext within SFXPawn;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StateListenerClasses = ()
    ConsoleCommandClasses = (Class'SFSGivePowerInterceptorCommandMP', Class'SFSShowBotChoiceUICommand', Class'SFSSpectrePortalRefreshConsoleCommand')
    ManagerClasses = (Class'SFSPortalAsyncLoader', 
                      Class'SFSBotManager', 
                      Class'SFSBotDirectorManager', 
                      Class'SFSMatchManager', 
                      Class'SFSAppearanceManager', 
                      Class'SFSCharacterManager', 
                      Class'SFSSaveManager', 
                      Class'SFSPowerTransferManager', 
                      Class'SFSWeaponManager', 
                      Class'SFSPowerManager', 
                      Class'SFSCustomActionsManager', 
                      Class'SFSConsumableManager', 
                      Class'SFSRESTStoreManager', 
                      Class'SFSStrikeTeamIntegrationService', 
                      Class'SFSSpectreIntegrationService', 
                      Class'SFSMissionSettingsService', 
                      Class'SFSMissionParamsManager', 
                      Class'SFSPortalIntegrationLobbyManager', 
                      Class'SFSSpectrePortalManager'
                     )
}