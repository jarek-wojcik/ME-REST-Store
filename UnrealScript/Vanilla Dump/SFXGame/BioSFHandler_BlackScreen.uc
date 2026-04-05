Class BioSFHandler_BlackScreen extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum BlackScreenDisplayModes
{
    BlackScreenMode_None,
    BlackScreenMode_TurnBlackOn,
    BlackScreenMode_TurnBlackOff,
    BlackScreenMode_FadeToBlack,
    BlackScreenMode_FadeFromBlack,
};

var string m_ASPath;
var float m_CurrentAlpha;
var float m_AccumulatedFadeTime;
var float m_FadeTime;
var BlackScreenDisplayModes m_eDisplayMode;

public native function Hide(bool bWithFade, optional float FadeTime);

public native function bool IsFading();

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    SetMouseShown(FALSE);
}
public event function OnStart()
{
    Hide(FALSE);
}
public native function Show(bool bWithFade, optional float FadeTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_ASPath = "_root.BlackoutMC._alpha"
    m_FadeTime = 2.0
    nHandlerID = 26
    bSetGameMode = FALSE
}