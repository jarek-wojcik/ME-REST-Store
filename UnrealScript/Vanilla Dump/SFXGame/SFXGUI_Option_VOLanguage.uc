Class SFXGUI_Option_VOLanguage extends SFXGUI_Option_LanguageBase within BioSFHandler_Options;

public event function SaveOption()
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    oEngine.SetLanguageForVO(Languages[nCurrentValue].Code, TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LanguageType = ESFXLanguageContentType.ESFXLanguageContentType_Package
}