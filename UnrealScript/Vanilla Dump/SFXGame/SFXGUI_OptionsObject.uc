Class SFXGUI_OptionsObject within BioSFHandler_Options
    native
    abstract;

var(SFXGUI_OptionsObject) byte OptionId;

public event function ApplyOptionValue(int nValue);

public event function ConstructRadioGroupOption(out RadioGroupOption Option);

public event function ConstructSliderOption(out SliderOption Option);

public event function ConstructTextSliderOption(out TextSliderOption Option);

public event function int GetOptionValue()
{
    return 0;
}
public event function bool OptionIsAvailable()
{
    return FALSE;
}
public event function ResetToDefault();

public event function SaveOption();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}