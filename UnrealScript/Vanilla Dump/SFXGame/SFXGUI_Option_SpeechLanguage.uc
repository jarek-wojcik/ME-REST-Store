Class SFXGUI_Option_SpeechLanguage extends SFXGUI_Option_LanguageBase within BioSFHandler_Options
    native;

var string CurrentTextLanguage;

public native function GetAvailableSKULanguages(out array<LanguageOptionInfo> aReturnLangs);

public event function bool OptionIsAvailable()
{
    if (Outer.GuiMode != EOptionsGuiMode.GuiMode_Multiplayer)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild(1))
        {
            return Class'SFXGUI_MainMenu_RTT'.static.IsKinectEnabled();
        }
    }
    return FALSE;
}
public event function SaveOption()
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    oEngine.SetLanguageForSpeech(Languages[nCurrentValue].Code, TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LanguageType = ESFXLanguageContentType.ESFXLanguageContentType_Speech
}