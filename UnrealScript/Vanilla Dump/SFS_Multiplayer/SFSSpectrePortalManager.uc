Class SFSSpectrePortalManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSStrikeTeamIntegrationService strikeTeamService;
var SFSCharacterManager characterManager;

public event simulated function HandlePostAdd()
{
    spectreService = Outer.GetModule(Class'SFSSpectreIntegrationService');
    strikeTeamService = Outer.GetModule(Class'SFSStrikeTeamIntegrationService');
    characterManager = Outer.GetModule(Class'SFSCharacterManager');
    initializeSpectre();
}
public function initializeSpectre()
{
    spectreService.RetrieveActiveCharacter(OnCharacterRetrieved);
}
function OnCharacterRetrieved(SFSCharacterModelStruct Character, bool bSuccess)
{
    if (bSuccess)
    {
        //Checks
        // Existing appearance matches target?
        // Existing weapons match target?
        // Existing weapon mods match target?
        // Existing powers match target?
        // Existing consumables match target?
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}