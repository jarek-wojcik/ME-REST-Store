Class SFXGUI_Option_TextLanguage extends SFXGUI_Option_LanguageBase within BioSFHandler_Options
    native;

public event function SaveOption()
{
    local SFXEngine oEngine;
    local string sCurrentLang;
    
    sCurrentLang = GetLanguage();
    if (Languages[nCurrentValue].Code != sCurrentLang)
    {
        oEngine = SFXEngine(Class'Engine'.static.GetEngine());
        oEngine.SetLanguageForText(Languages[nCurrentValue].Code, TRUE);
        Outer.GetSFXUIController().NotifyLanguageChanged();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}