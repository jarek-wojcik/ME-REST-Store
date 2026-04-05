Class SFXGUI_Option_LanguageBase extends SFXGUI_OptionsObject within BioSFHandler_Options
    native
    abstract;

struct native LanguageOptionInfo 
{
    var string Code;
    var stringref Label;
};

var array<LanguageOptionInfo> Languages;
var int nCurrentValue;
var bool bInitialized;
var ESFXLanguageContentType LanguageType;

public event function ApplyOptionValue(int nValue)
{
    if (nValue < 0 || nValue >= Languages.Length)
    {
        return;
    }
    nCurrentValue = nValue;
}
public event function ConstructTextSliderOption(out TextSliderOption Option)
{
    local string sCurrentLang;
    
    if (!bInitialized)
    {
        sCurrentLang = GetLanguage();
        bInitialized = TRUE;
    }
    else
    {
        sCurrentLang = Languages[nCurrentValue].Code;
    }
    RebuildSliderOptions(sCurrentLang, Option);
}
public native function GetAvailableSKULanguages(out array<LanguageOptionInfo> aReturnLangs);

public native function string GetLanguage(optional bool bGetDefault = FALSE);

public event function int GetOptionValue()
{
    return nCurrentValue;
}
public event function bool OptionIsAvailable()
{
    return Outer.GuiMode == EOptionsGuiMode.GuiMode_MainMenu || Outer.GuiMode == EOptionsGuiMode.GuiMode_NewGame;
}
public event function ResetToDefault()
{
    local TextSliderOption Option;
    
    RebuildSliderOptions(GetLanguage(TRUE), Option);
}
public function RebuildSliderOptions(string SelectedLanguageCode, out TextSliderOption Option)
{
    local OptionText oValue;
    local int nValue;
    
    GetAvailableSKULanguages(Languages);
    nCurrentValue = 0;
    for (nValue = 0; nValue < Languages.Length; ++nValue)
    {
        oValue.Label = Languages[nValue].Label;
        oValue.Story = Option.Story;
        oValue.Value = nValue;
        Option.Values.AddItem(oValue);
        if (Languages[nValue].Code == SelectedLanguageCode)
        {
            nCurrentValue = nValue;
            Option.DefaultVal = nValue;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LanguageType = ESFXLanguageContentType.ESFXLanguageContentType_Text
}