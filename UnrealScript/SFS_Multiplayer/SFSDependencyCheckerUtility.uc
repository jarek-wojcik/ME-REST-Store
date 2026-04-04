Class SFSDependencyCheckerUtility;

public static final function bool CheckForCrouchModPresence(BioPlayerController PC)
{
    local SFXGameModeBase GameMode;
    local BioPlayerInput Input;
    local KeyBind CurrentBind;
    local StaticKeyBind StaticBind;
    local int i;
    
    // Check game mode bindings
    if (PC.GameModeManager2 != None)
    {
        GameMode = PC.GameModeManager2.GameModes[int(PC.GameModeManager2.CurrentMode)];
        if (GameMode != None)
        {
            for (i = 0; i < GameMode.Bindings.Length; i++)
            {
                CurrentBind = GameMode.Bindings[i];
                if (CurrentBind.Name == 'LeftAlt' && InStr(Caps(CurrentBind.command), Caps("CrouchUniversal"), , , ) != -1)
                {
                    return TRUE;
                }
            }
        }
    }
    // Check static PC bindings
    Input = BioPlayerInput(PC.PlayerInput);
    if (Input != None)
    {
        for (i = 0; i < Input.StaticPCBinds.Length; i++)
        {
            StaticBind = Input.StaticPCBinds[i];
            if (StaticBind.Name == 'LeftAlt' && InStr(Caps(StaticBind.command), Caps("CrouchUniversal"), , , ) != -1)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}