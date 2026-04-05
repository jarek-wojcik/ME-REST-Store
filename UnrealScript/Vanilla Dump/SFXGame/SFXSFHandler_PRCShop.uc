Class SFXSFHandler_PRCShop extends BioSFHandler_ChoiceGUI
    native
    config(UI);

struct native PRCInfo_t 
{
    var string sCreditsSection;
    var float fFadeTime;
    var float fHoldTime;
    var float fScrollTime;
};

var config array<PRCInfo_t> PRCInfo;
var SFXGameChoiceGUIData_PRCShop m_ChoiceDataNoStrRef;

public native function ShowChoiceGUI();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PRCInfo = ({sCreditsSection = "Credits-DLC_CER_01", fFadeTime = 0.100000001, fHoldTime = 0.0, fScrollTime = 55.0}, 
               {sCreditsSection = "Credits-DLC_CER_02", fFadeTime = 0.100000001, fHoldTime = 0.0, fScrollTime = 55.0}
              )
}