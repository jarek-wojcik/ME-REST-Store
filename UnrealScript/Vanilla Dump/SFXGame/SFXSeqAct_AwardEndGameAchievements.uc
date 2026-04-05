Class SFXSeqAct_AwardEndGameAchievements extends SequenceAction;

var const int PlayedME2VarIndex;

public function Activated()
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local SFXProfileSettings Profile;
    local BioGlobalVariableTable VarTable;
    local int NumGameCompletions;
    local string LastCompletedCareer;
    local string CurrentCareer;
    local SFXPlayerController SPC;
    
    VarTable = BioWorldInfo(GetWorldInfo()).GetGlobalVariables();
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        PC.UnlockAccomplishment('END002');
        Profile = PC.ProfileSettings;
        Engine = SFXEngine(PC.Player.Outer);
        if (Profile != None && Engine != None)
        {
            Profile.GetProfileSettingValue(64, LastCompletedCareer);
            CurrentCareer = Engine.GetCurrentSaveDescriptor().Career;
            if (CurrentCareer != LastCompletedCareer)
            {
                Profile.SetProfileSettingValue(64, CurrentCareer);
                Profile.GetProfileSettingValueInt(60, NumGameCompletions);
                NumGameCompletions++;
                Profile.SetProfileSettingValueInt(60, NumGameCompletions);
                if (NumGameCompletions >= 2 || VarTable.GetBool(PlayedME2VarIndex))
                {
                    PC.UnlockAccomplishment('Import');
                }
            }
            if (int(Profile.GetDifficultyConfigOption()) == 4)
            {
                SPC = SFXPlayerController(PC);
                if (SPC != None)
                {
                    SPC.UpdateSPInsaneMapsCompleted('Biop_End002');
                }
            }
            if (int(Profile.GetDifficultyConfigOption()) == 4 && !VarTable.GetBoolByName('ChangedDifficulty'))
            {
                PC.UnlockAccomplishment('INSANITY');
            }
        }
    }
    OutputLinks[0].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayedME2VarIndex = 21554
    bManualHandleOutputs = TRUE
}