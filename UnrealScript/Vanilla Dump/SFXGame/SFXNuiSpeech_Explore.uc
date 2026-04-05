Class SFXNuiSpeech_Explore
    native
    transient;

public static final event function NuiSpeechUseModule()
{
    local BioPlayerController oPC;
    local WorldInfo oWI;
    
    oWI = Class'WorldInfo'.static.GetWorldInfo();
    oPC = BioWorldInfo(oWI).GetLocalPlayerController();
    if (oPC != None && oPC.GameModeManager2.IsActive(0))
    {
        oPC.GetGameModeDefault().Used();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}