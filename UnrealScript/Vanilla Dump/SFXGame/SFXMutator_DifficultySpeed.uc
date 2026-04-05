Class SFXMutator_DifficultySpeed extends SFXMutator;

public function bool MutatorIsAllowed()
{
    if (WorldInfo.bIsMenuLevel || WorldInfo.bIsUIWorld || WorldInfo.bIsLobbyLevel)
    {
        return FALSE;
    }
    return Super(Mutator).MutatorIsAllowed();
}
public function SetGameSpeed(out float NewSpeed)
{
    local SFXMutator NextMut;
    local SFXGRI GRI;
    local float GlobalSpeed;
    
    GlobalSpeed = 1.0;
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI != None && GRI.DifficultyHandler != None)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild(2) == FALSE)
        {
            GlobalSpeed = GRI.DifficultyHandler.GetFloat('GlobalGameSpeed', 'MPGlobal');
            if (GlobalSpeed <= 0.0)
            {
                GlobalSpeed = 1.0;
            }
        }
    }
    NewSpeed *= GlobalSpeed;
    NextMut = SFXMutator(NextMutator);
    if (NextMut != None)
    {
        NextMut.SetGameSpeed(NewSpeed);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GroupNames = ("DifficultySpeed")
}