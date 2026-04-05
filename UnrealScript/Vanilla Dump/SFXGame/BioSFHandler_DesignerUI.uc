Class BioSFHandler_DesignerUI extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

struct native BioDUIElementStatus 
{
    var bool bVisible;
    var bool bFading;
};
struct native BioDUIPulseDetails 
{
    var float fHalfCycleTime;
    var float fMinAlpha;
    var float fCurCycle;
    var BioDUIElements nElement;
};
struct native BioDUITimerDetails 
{
    var float fCurTime;
    var float fEndTime;
    var float fIntervalTime;
    var float fNextInterval;
    var bool bIncrementing;
    var bool bIntervalTriggered;
    var bool bCompleted;
    var bool bRunning;
    var bool bActive;
    var bool bFirstUpdate;
};
enum BioDUIElements
{
    BIO_DUI_PassiveTimer,
    BIO_DUI_PassiveCounter,
    BIO_DUI_PassiveText,
    BIO_DUI_PassiveBar,
    BIO_DUI_PassiveBarMarker1,
    BIO_DUI_PassiveBarMarker2,
    BIO_DUI_ModalBar,
    BIO_DUI_ModalBarMarker1,
    BIO_DUI_ModalBarMarker2,
    BIO_DUI_ModalCounter,
    BIO_DUI_ModalTimer,
    BIO_DUI_ModalText,
    BIO_DUI_ModalBackground,
    BIO_DUI_ButtonA,
    BIO_DUI_ButtonAText,
    BIO_DUI_ButtonB,
    BIO_DUI_ButtonBText,
    BIO_DUI_ButtonX,
    BIO_DUI_ButtonXText,
    BIO_DUI_ButtonY,
    BIO_DUI_ButtonYText,
    BIO_DUI_ModalBackground2,
};

var array<BioDUIPulseDetails> lstPulsingElements;
var BioDUIElementStatus lstElementStatus[22];
var BioDUITimerDetails stModalTimer;
var BioDUITimerDetails stPassiveTimer;
var int nElementVisibleCount;
var int m_nLayout;
var bool m_bCanInvoke;

public native function ClearAll(bool bModal);

public native function ClearElementPulse(BioDUIElements nElement);

public native function ExIntInitialize();

public native function float GetTimerValue(bool bModalTimer);

public native function bool IsActive(bool bModal);

public native function bool IsQuasarLayout();

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetVisible(nElementVisibleCount > 0);
    oPanel.SetExternalInterface(Self);
    oPanel.SetInputDisabled(TRUE);
}
public native function SetBarFillDirection(bool bModalBar, bool bLeftToRight);

public native function SetBarFillPercent(bool bModalBar, int nPercent);

public native function SetBarMarkerPoints(bool bModalBar, int nMarker1, int nMarker2);

public native function SetCounterValue(bool bModalCounter, int nValue);

public native function SetElementAlpha(BioDUIElements nElement, float fAlpha);

public native function SetElementColor(BioDUIElements nElement, const out Color stColor);

public native function SetElementText(BioDUIElements nElement, const out string sText);

public native function SetElementVisible(BioDUIElements nElement, bool bVisible, optional float fFadeTime = 0.0);

public native function SetQuasarLayout(bool bShow);

public native function SetTextStringRef(BioDUIElements nElement, stringref srText);

public native function SetTimerDetails(bool bModalTimer, bool bVisible, float fStartTime, float fEndTime, float fInterval);

public native function int SetupElementPulse(BioDUIElements nElement, float fMinAlpha, float fCycleTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nLayout = 1
    bSetGameMode = FALSE
}