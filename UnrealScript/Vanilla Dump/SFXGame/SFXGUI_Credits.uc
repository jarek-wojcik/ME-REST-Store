Class SFXGUI_Credits extends SFXGUIMovie
    native
    config(Credits);

struct native SFXCreditEntry 
{
    var stringref Title;
    var stringref Names;
    var float FontScale;
    var int Columns;
    var float StartTime;
    var float FadeInTime;
    var float HoldTime;
    var float FadeOutTime;
    var float DelayTime;
    var float BreakSpace;
    var ECreditEntryType Type;
    
    structdefaultproperties
    {
        FontScale = 1.0
        Columns = 1
        FadeInTime = -1.0
        HoldTime = -1.0
        FadeOutTime = -1.0
        BreakSpace = -1.0
        Type = ECreditEntryType.CREDIT_Scrolling
    }
};
enum EFlashingCreditState
{
    FLASHCREDIT_FadeIn,
    FLASHCREDIT_Hold,
    FLASHCREDIT_FadeOut,
    FLASHCREDIT_Delay,
};
enum ECreditEntryType
{
    CREDIT_Heading,
    CREDIT_Flashing,
    CREDIT_Scrolling,
    CREDIT_Delay,
    CREDIT_LineBreak,
};

var config array<SFXCreditEntry> Credits;
var config array<SFXCreditEntry> DLCCredits;
var config array<SFXCreditEntry> EndCredits;
var delegate<OnCreditsFinished> __OnCreditsFinished__Delegate;
var(SFXGUI_Credits) transient Name m_nmCreditMusic;
var(SFXGUI_Credits) config float FadeInTime;
var(SFXGUI_Credits) config float HoldTime;
var(SFXGUI_Credits) config float FadeOutTime;
var(SFXGUI_Credits) config float BreakSpace;
var(SFXGUI_Credits) config float ColumnPadding;
var(SFXGUI_Credits) config float TotalRunningTime;
var(SFXGUI_Credits) config float ScrollingCreditStartTime;
var config stringref ConfirmExitMessage;
var config stringref ExitYes;
var config stringref ExitNo;
var(SFXGUI_Credits) transient float m_fElapsedPlayTime;
var(SFXGUI_Credits) transient int m_nCreditIndex;
var(SFXGUI_Credits) transient float m_fScrollingCreditsEpoch;
var(SFXGUI_Credits) transient float m_fTransitionTime;
var(SFXGUI_Credits) transient float m_fTargetTransitionTime;
var transient GFxValue m_oFlashingCredit;
var(SFXGUI_Credits) transient bool m_bPlaying;
var(SFXGUI_Credits) transient bool m_bPlayingScrollingCredits;
var(SFXGUI_Credits) transient bool m_bFromMainMenu;
var(SFXGUI_Credits) transient bool m_bFromAdditionalContent;
var(SFXGUI_Credits) transient bool m_bFromPRCChoiceGUI;
var transient bool m_bGameWasPausedOnStart;
var transient bool m_bGameWasUsingVSync;
var(SFXGUI_Credits) transient EFlashingCreditState m_eFlashingCreditState;

public final native function bool GetVSync();

public delegate function OnCreditsFinished(SFXGUI_Credits creditsMovie);

public event function OnStart()
{
    Super.OnStart();
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("FX_Volume", 0.0);
    SetGameMode(TRUE, 9);
    GetSFXUIController().HideMainMenu();
    m_bGameWasPausedOnStart = oWorldInfo.bPlayersOnly;
    oWorldInfo.PauseGame(TRUE);
    m_bGameWasUsingVSync = GetVSync();
    SetVSync(TRUE);
    SetBackgroundAlpha(1.0);
}
public final event function SetFromAdditionalContent()
{
    m_bFromAdditionalContent = TRUE;
}
public final event function SetFromPRCChoiceGUI()
{
    m_bFromPRCChoiceGUI = TRUE;
}
public final native function SetVSync(bool bVsync);

public event function Update(float fDeltaT)
{
    Super.Update(fDeltaT);
    if (!m_bPlaying)
    {
        return;
    }
    m_fElapsedPlayTime += fDeltaT;
    if (!m_bPlayingScrollingCredits)
    {
        if (Credits[m_nCreditIndex].Type != ECreditEntryType.CREDIT_Flashing && Credits[m_nCreditIndex].Type != ECreditEntryType.CREDIT_Delay)
        {
            if (m_fElapsedPlayTime >= ScrollingCreditStartTime)
            {
                m_bPlayingScrollingCredits = TRUE;
                Invoke0("credits.StartScrolling");
                m_fScrollingCreditsEpoch = m_fElapsedPlayTime;
                return;
            }
        }
        else
        {
            UpdateFlashingCredits(fDeltaT);
        }
    }
    else
    {
        UpdateScrollingCredits(fDeltaT);
    }
}
public event function OnClose()
{
    local float fFXVolume;
    local BioPlayerController PC;
    local SFXProfileSettings Profile;
    
    StopGuiMusic();
    if (m_bFromMainMenu)
    {
        GetSFXUIController().ShowMainMenu();
    }
    else if (!m_bFromPRCChoiceGUI)
    {
        oWorldInfo.bPlayersOnly = FALSE;
    }
    fFXVolume = 100.0;
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        Profile = PC.ProfileSettings;
        if (Profile != None)
        {
            fFXVolume = float(Profile.GetFXVolume());
        }
    }
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("FX_Volume", fFXVolume * 0.00999999978);
    SetGameMode(FALSE, 9);
    oWorldInfo.PauseGame(m_bGameWasPausedOnStart);
    SetVSync(m_bGameWasUsingVSync);
    Super.OnClose();
}
public final function AddScrollingCreditHeading(string sTitle, float fSpace, float fFontScale)
{
    ActionScriptVoid("credits.AddScrollingCreditHeading");
}
public final function AddScrollingCreditLineBreak(float fSpace)
{
    ActionScriptVoid("credits.AddScrollingCreditLineBreak");
}
public final function AddScrollingCreditSection(string sTitle, string sNames, int nColumns, float fSpace, float fFontScale)
{
    ActionScriptVoid("credits.AddScrollingCreditSection");
}
public final function AppendScrollingCredit(const SFXCreditEntry credit)
{
    local float fBreakSpace;
    
    fBreakSpace = credit.BreakSpace > float(0) ? credit.BreakSpace : BreakSpace;
    switch (credit.Type)
    {
        case ECreditEntryType.CREDIT_Scrolling:
            AddScrollingCreditSection(GetUIString(credit.Title), GetUIString(credit.Names), credit.Columns, fBreakSpace, credit.FontScale);
            break;
        case ECreditEntryType.CREDIT_LineBreak:
            AddScrollingCreditLineBreak(fBreakSpace);
            break;
        case ECreditEntryType.CREDIT_Heading:
            AddScrollingCreditHeading(GetUIString(credit.Title), fBreakSpace, credit.FontScale);
            break;
        default:
    }
}
public final function ConfirmButtonPressed(bool bAPressed, int nContext)
{
    PauseDisplay(FALSE);
    if (bAPressed)
    {
        CreditsFinished();
    }
}
public final function CreditsFinished()
{
    if (__OnCreditsFinished__Delegate != None)
    {
        __OnCreditsFinished__Delegate(Self);
        __OnCreditsFinished__Delegate = None;
    }
    else
    {
        Close();
    }
}
public final function InitializeCredits()
{
    local float fFlashingCreditTime;
    
    fFlashingCreditTime = InitializeFlashingCredits();
    if (ScrollingCreditStartTime > 0.0 && ScrollingCreditStartTime < fFlashingCreditTime)
    {
    }
    InitializeScrollingCredits();
}
public final function float InitializeFlashingCredits()
{
    local float fTime;
    local int nCredit;
    local SFXCreditEntry credit;
    local bool bEndOfFlashingCredits;
    
    fTime = 0.0;
    for (nCredit = 0; bEndOfFlashingCredits == FALSE && nCredit < Credits.Length; ++nCredit)
    {
        credit = Credits[nCredit];
        switch (credit.Type)
        {
            case ECreditEntryType.CREDIT_Flashing:
                if (credit.StartTime > 0.0)
                {
                    credit.DelayTime = FMax(0.0, credit.StartTime - fTime);
                    Credits[nCredit].DelayTime = credit.DelayTime;
                }
                fTime += credit.DelayTime;
                fTime += (credit.FadeInTime < 0.0 ? FadeInTime : credit.FadeInTime);
                fTime += (credit.HoldTime < 0.0 ? HoldTime : credit.HoldTime);
                fTime += (credit.FadeOutTime < 0.0 ? FadeOutTime : credit.FadeOutTime);
                break;
            case ECreditEntryType.CREDIT_Delay:
                fTime += credit.DelayTime;
                break;
            default:
                bEndOfFlashingCredits = TRUE;
                break;
        }
    }
    return fTime;
}
public final function InitializeScrollingCredits()
{
    local int nCredit;
    
    for (nCredit = 0; nCredit < Credits.Length; ++nCredit)
    {
        AppendScrollingCredit(Credits[nCredit]);
    }
    for (nCredit = 0; nCredit < DLCCredits.Length; ++nCredit)
    {
        AppendScrollingCredit(DLCCredits[nCredit]);
    }
    for (nCredit = 0; nCredit < EndCredits.Length; ++nCredit)
    {
        AppendScrollingCredit(EndCredits[nCredit]);
    }
}
public final function OnCreditsMovieLoaded()
{
    m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_FadeIn;
    m_bPlayingScrollingCredits = FALSE;
    m_bPlaying = TRUE;
    m_fElapsedPlayTime = 0.0;
    m_nCreditIndex = 0;
    SetParameters(ColumnPadding);
    InitializeCredits();
    StopGuiMusic();
    PlayGuiMusic(m_nmCreditMusic);
}
public final function PauseDisplay(bool bPause)
{
    m_bPlaying = !bPause;
}
public final function ScrollToPosition(float fScrollPct)
{
    ActionScriptVoid("credits.ScrollToPosition");
}
public final function GFxValue SetFlashingCredit(string sTitle, string sNames, float fFontScale)
{
    return ActionScriptObject("credits.SetFlashingCredit");
}
public final function SetFromMainMenu()
{
    m_bFromMainMenu = TRUE;
}
public final function SetParameters(float fColumnPadding)
{
    ActionScriptVoid("credits.SetParameters");
}
public final function TryExitCredits()
{
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    PauseDisplay(TRUE);
    if (HasFocus() == TRUE)
    {
        oMsgBox = GetSFXUIController().CreateMessageBox(GetPC());
        oMsgBox.SetInputDelegate(ConfirmButtonPressed);
        stParams.srAText = ExitYes;
        stParams.srBText = ExitNo;
        oMsgBox.DisplayMessageBox(ConfirmExitMessage, stParams);
    }
    else
    {
        CreditsFinished();
    }
}
public final function UpdateFlashingCredits(float fDeltaT)
{
    local SFXCreditEntry credit;
    local float fPctDone;
    local ASDisplayInfo oCreditDisplay;
    
    credit = Credits[m_nCreditIndex];
    if (credit.Type == ECreditEntryType.CREDIT_Flashing)
    {
        if (m_oFlashingCredit == None)
        {
            m_oFlashingCredit = SetFlashingCredit(GetUIString(credit.Title), GetUIString(credit.Names), credit.FontScale);
            if (m_oFlashingCredit == None)
            {
                ++m_nCreditIndex;
                return;
            }
            if (credit.DelayTime > 0.0)
            {
                m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_Delay;
                m_fTargetTransitionTime = credit.DelayTime;
                m_fTransitionTime = 0.0;
            }
            else
            {
                m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_FadeIn;
                m_fTargetTransitionTime = credit.FadeInTime < 0.0 ? FadeInTime : credit.FadeInTime;
                m_fTransitionTime = 0.0;
            }
            return;
        }
    }
    else if (credit.Type == ECreditEntryType.CREDIT_Delay)
    {
        if (m_fTargetTransitionTime != credit.DelayTime)
        {
            m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_Delay;
            m_fTargetTransitionTime = credit.DelayTime;
            m_fTransitionTime = 0.0;
            return;
        }
    }
    m_fTransitionTime += fDeltaT;
    if (m_fTargetTransitionTime == 0.0)
    {
        fPctDone = 1.0;
    }
    else
    {
        fPctDone = m_fTransitionTime / m_fTargetTransitionTime;
    }
    switch (m_eFlashingCreditState)
    {
        case EFlashingCreditState.FLASHCREDIT_FadeIn:
            oCreditDisplay = m_oFlashingCredit.GetDisplayInfo();
            oCreditDisplay.Alpha = fPctDone * float(100);
            m_oFlashingCredit.SetDisplayInfo(oCreditDisplay);
            if (fPctDone >= 1.0)
            {
                m_fTransitionTime = 0.0;
                m_fTargetTransitionTime = credit.HoldTime < 0.0 ? HoldTime : credit.HoldTime;
                m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_Hold;
            }
            break;
        case EFlashingCreditState.FLASHCREDIT_Hold:
            if (fPctDone >= 1.0)
            {
                m_fTransitionTime = 0.0;
                m_fTargetTransitionTime = credit.FadeOutTime < 0.0 ? FadeOutTime : credit.FadeOutTime;
                m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_FadeOut;
            }
            break;
        case EFlashingCreditState.FLASHCREDIT_FadeOut:
            oCreditDisplay = m_oFlashingCredit.GetDisplayInfo();
            oCreditDisplay.Alpha = (1.0 - fPctDone) * float(100);
            m_oFlashingCredit.SetDisplayInfo(oCreditDisplay);
            if (fPctDone >= 1.0)
            {
                m_oFlashingCredit = None;
                ++m_nCreditIndex;
                m_fTransitionTime = 0.0;
                m_fTargetTransitionTime = 0.0;
            }
            break;
        case EFlashingCreditState.FLASHCREDIT_Delay:
            if (fPctDone >= 1.0)
            {
                if (credit.Type == ECreditEntryType.CREDIT_Flashing)
                {
                    m_eFlashingCreditState = EFlashingCreditState.FLASHCREDIT_FadeIn;
                    m_fTargetTransitionTime = credit.FadeInTime < 0.0 ? FadeInTime : credit.FadeInTime;
                    m_fTransitionTime = 0.0;
                }
                else if (credit.Type == ECreditEntryType.CREDIT_Delay)
                {
                    m_fTransitionTime = 0.0;
                    m_fTargetTransitionTime = 0.0;
                    ++m_nCreditIndex;
                }
            }
            break;
        default:
    }
}
public final function UpdateScrollingCredits(float fDeltaT)
{
    local float fPctDone;
    
    fPctDone = (m_fElapsedPlayTime - m_fScrollingCreditsEpoch) / (TotalRunningTime - m_fScrollingCreditsEpoch);
    ScrollToPosition(fPctDone);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Credits = ({
                Title = $342757, 
                Names = $342910, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 1.5, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $342758, 
                Names = $342911, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $723655, 
                Names = $391353, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $342760, 
                Names = $342913, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $342761, 
                Names = $342914, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $386331, 
                Names = $386332, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $723656, 
                Names = $723808, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.349999994, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Flashing
               }, 
               {
                Title = $342763, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342770, 
                Names = $723809, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342764, 
                Names = $723810, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342765, 
                Names = $723811, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342769, 
                Names = $723812, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342771, 
                Names = $723819, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723657, 
                Names = $723820, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $362091, 
                Names = $723821, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723658, 
                Names = $723822, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342775, 
                Names = $723823, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $391714, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723659, 
                Names = $723824, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342781, 
                Names = $342939, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723660, 
                Names = $723825, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342785, 
                Names = $342943, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $362097, 
                Names = $360228, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342784, 
                Names = $342942, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723661, 
                Names = $723829, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723662, 
                Names = $723830, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723663, 
                Names = $723831, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342788, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342789, 
                Names = $723832, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342790, 
                Names = $723833, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342791, 
                Names = $723834, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342792, 
                Names = $723835, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342793, 
                Names = $723836, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342794, 
                Names = $723837, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342796, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723664, 
                Names = $723838, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723665, 
                Names = $723839, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342798, 
                Names = $723840, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342797, 
                Names = $723841, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723667, 
                Names = $723842, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $391697, 
                Names = $723843, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342800, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723668, 
                Names = $723844, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342802, 
                Names = $723845, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342803, 
                Names = $723846, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342804, 
                Names = $723847, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342806, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723669, 
                Names = $723848, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723670, 
                Names = $723849, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723671, 
                Names = $723850, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723672, 
                Names = $723851, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723673, 
                Names = $723852, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723674, 
                Names = $723853, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723675, 
                Names = $723854, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723677, 
                Names = $723855, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723678, 
                Names = $723856, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723679, 
                Names = $723857, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723680, 
                Names = $723858, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723681, 
                Names = $723859, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723682, 
                Names = $723860, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342838, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $343003, 
                Names = $722542, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $172370, 
                Names = $172352, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $687343, 
                Names = $722543, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $722544, 
                Names = $342848, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $722545, 
                Names = $342846, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723246, 
                Names = $723247, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343009, 
                Names = $342845, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $156662, 
                Names = $342854, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $172364, 
                Names = $172346, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343005, 
                Names = $342841, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $156665, 
                Names = $342861, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343021, 
                Names = $342857, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $373060, 
                Names = $342856, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343006, 
                Names = $342842, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $178198, 
                Names = $342855, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343023, 
                Names = $342859, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343007, 
                Names = $342843, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $722546, 
                Names = $342847, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $388371, 
                Names = $722547, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $724433, 
                Names = $724434, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $705982, 
                Names = $722548, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $374492, 
                Names = $342862, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $206252, 
                Names = $342844, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723248, 
                Names = $723249, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $172365, 
                Names = $172347, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343022, 
                Names = $342858, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $722549, 
                Names = $722550, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $172360, 
                Names = $172342, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $617293, 
                Names = $722551, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342877, 
                Names = $722552, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342891, 
                Names = $723950, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $725172, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 40.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $724627, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $724637, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $724638, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $724639, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $724640, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342811, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723683, 
                Names = $723861, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723687, 
                Names = $723865, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723684, 
                Names = $723862, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723685, 
                Names = $723863, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723686, 
                Names = $723864, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723689, 
                Names = $723867, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723688, 
                Names = $723866, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723690, 
                Names = $723868, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342812, 
                Names = $723869, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723691, 
                Names = $723870, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723692, 
                Names = $723871, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723693, 
                Names = $723872, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723694, 
                Names = $723873, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723695, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723696, 
                Names = $342969, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723697, 
                Names = $723874, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723698, 
                Names = $342944, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723699, 
                Names = $342996, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342777, 
                Names = $723875, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342825, 
                Names = $723876, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342828, 
                Names = $723877, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723700, 
                Names = $723878, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723701, 
                Names = $723879, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723702, 
                Names = $723880, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723703, 
                Names = $723881, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723704, 
                Names = $723882, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723705, 
                Names = $723883, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723706, 
                Names = $723884, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342823, 
                Names = $342990, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342831, 
                Names = $723885, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723707, 
                Names = $723886, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342827, 
                Names = $723887, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723708, 
                Names = $723888, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723709, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342832, 
                Names = $723889, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342833, 
                Names = $723890, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342835, 
                Names = $723891, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342834, 
                Names = $723892, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723710, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723711, 
                Names = $723893, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723712, 
                Names = $723894, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723713, 
                Names = $723895, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723714, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723715, 
                Names = $342915, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723716, 
                Names = $342937, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723717, 
                Names = $723896, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723724, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723725, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723726, 
                Names = $723898, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723727, 
                Names = $723899, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723728, 
                Names = $343328, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723729, 
                Names = $343324, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723730, 
                Names = $342991, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723731, 
                Names = $723900, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723732, 
                Names = $723901, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723733, 
                Names = $723902, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342823, 
                Names = $723903, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723734, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $343306, 
                Names = $343307, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343308, 
                Names = $723904, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $343310, 
                Names = $343311, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723735, 
                Names = $723905, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723736, 
                Names = $723906, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723737, 
                Names = $343315, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723738, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $343291, 
                Names = $343292, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723739, 
                Names = $343296, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723740, 
                Names = $343298, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723741, 
                Names = $343300, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723742, 
                Names = $343302, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723743, 
                Names = $343304, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723744, 
                Names = $723906, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342904, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $389505, 
                Names = $723909, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $389503, 
                Names = $723910, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342906, 
                Names = $723911, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342905, 
                Names = $723912, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342796, 
                Names = $723913, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723745, 
                Names = $723914, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723746, 
                Names = $723915, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342889, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342796, 
                Names = $723916, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723747, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723748, 
                Names = $723917, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342835, 
                Names = $723918, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723749, 
                Names = $723919, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342806, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342762, 
                Names = $723920, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $348666, 
                Names = $723921, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723751, 
                Names = $389262, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342882, 
                Names = $723922, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342809, 
                Names = $723923, 
                FontScale = 1.0, 
                Columns = 3, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723752, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $348666, 
                Names = $723925, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723753, 
                Names = $723926, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $389268, 
                Names = $723927, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342882, 
                Names = $723928, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342883, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723929, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $343291, 
                Names = $723930, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723754, 
                Names = $723931, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723755, 
                Names = $723932, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723756, 
                Names = $723933, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723757, 
                Names = $723934, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723758, 
                Names = $723935, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723936, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $343291, 
                Names = $723937, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723759, 
                Names = $723938, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723760, 
                Names = $723939, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723761, 
                Names = $723940, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342760, 
                Names = $723941, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723762, 
                Names = $723942, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723763, 
                Names = $723943, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342763, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342887, 
                Names = $723944, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723764, 
                Names = $723945, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723765, 
                Names = $723946, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723766, 
                Names = $723947, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723767, 
                Names = $723948, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $0, 
                Names = $727499, 
                FontScale = 0.800000012, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 20.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723768, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $342890, 
                Names = $723949, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342909, 
                Names = $723951, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723769, 
                Names = $723952, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342899, 
                Names = $723953, 
                FontScale = 1.0, 
                Columns = 2, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342800, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723770, 
                Names = $723954, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $723771, 
                Names = $723955, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }, 
               {
                Title = $342806, 
                Names = $0, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = 100.0, 
                Type = ECreditEntryType.CREDIT_Heading
               }, 
               {
                Title = $723772, 
                Names = $723956, 
                FontScale = 1.0, 
                Columns = 1, 
                StartTime = 0.0, 
                FadeInTime = -1.0, 
                HoldTime = -1.0, 
                FadeOutTime = -1.0, 
                DelayTime = 0.0, 
                BreakSpace = -1.0, 
                Type = ECreditEntryType.CREDIT_Scrolling
               }
              )
    EndCredits = ({
                   Title = $725172, 
                   Names = $0, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 150.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723795, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723796, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723798, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723799, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723800, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723801, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723802, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723803, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723804, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723805, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $345665, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $723797, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $699498, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $699522, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $725172, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 50.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $342836, 
                   Names = $723897, 
                   FontScale = 1.0, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $0, 
                   Names = $725172, 
                   FontScale = 0.800000012, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 50.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }, 
                  {
                   Title = $723723, 
                   Names = $0, 
                   FontScale = 1.5, 
                   Columns = 1, 
                   StartTime = 0.0, 
                   FadeInTime = -1.0, 
                   HoldTime = -1.0, 
                   FadeOutTime = -1.0, 
                   DelayTime = 0.0, 
                   BreakSpace = 20.0, 
                   Type = ECreditEntryType.CREDIT_Scrolling
                  }
                 )
    m_nmCreditMusic = 'Credits'
    FadeInTime = 0.5
    HoldTime = 3.5
    FadeOutTime = 0.5
    BreakSpace = 30.0
    ColumnPadding = 30.0
    TotalRunningTime = 431.0
    ScrollingCreditStartTime = 35.5
    ConfirmExitMessage = $343062
    ExitYes = $343063
    ExitNo = $343064
    m_bFocusOnStart = TRUE
    m_bHandleKeyPresses = TRUE
    m_bRequiresUIWorld = TRUE
    m_bMouseVisibleWhenFocused = FALSE
}