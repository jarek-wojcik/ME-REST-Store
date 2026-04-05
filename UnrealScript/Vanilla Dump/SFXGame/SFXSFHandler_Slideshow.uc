Class SFXSFHandler_Slideshow extends SFXGUIMovieLegacyAdapter
    native
    transient
    config(UI);

struct native SFXSlideshowParams 
{
    var(SFXSlideshowParams) array<SFXSlideshowEntry> Slides;
    var(SFXSlideshowParams) Name Music;
    var(SFXSlideshowParams) float SlideFadeScalar;
    var(SFXSlideshowParams) bool AutoAdvance;
    var(SFXSlideshowParams) bool AllowRewind;
    var(SFXSlideshowParams) bool AllowAdvancePastEnd;
    var(SFXSlideshowParams) bool SlidesFadeIn;
    var(SFXSlideshowParams) bool SlidesFadeOut;
    var(SFXSlideshowParams) bool BlackBackground;
    
    structdefaultproperties
    {
        Music = 'MainMenu'
        SlideFadeScalar = 0.25
        AllowRewind = TRUE
        SlidesFadeIn = TRUE
        SlidesFadeOut = TRUE
    }
};
struct native SFXSlideshowEntry 
{
    var(SFXSlideshowEntry) string ImagePath;
    var(SFXSlideshowEntry) Texture2D Image;
    var(SFXSlideshowEntry) float DisplayTime;
    var(SFXSlideshowEntry) float MinDisplayTime;
    var(SFXSlideshowEntry) stringref NextText;
    var(SFXSlideshowEntry) stringref PrevText;
    var(SFXSlideshowEntry) stringref ExitText;
    var(SFXSlideshowEntry) bool CanExit;
    
    structdefaultproperties
    {
        NextText = $174522
        PrevText = $163277
        ExitText = $256627
        CanExit = TRUE
    }
};

var SFXSlideshowEntry m_CurrentSlide;
var SFXSlideshowParams m_ShowParams;
var delegate<SlideshowFinished> __SlideshowFinished__Delegate;
var float m_fCurrentSlideElapsedTime;
var int m_nCurrentSlideIndex;
var int m_nAdjacentPreloadCount;
var bool m_bWaitingForInit;
var bool m_bBeginWhenDoneInit;
var bool m_bCanGoNext;
var bool m_bCanGoPrev;
var bool m_bCanExit;

public function OnPanelAdded()
{
    m_nCurrentSlideIndex = -1;
    oPanel.SetExternalInterface(Self);
    m_bWaitingForInit = TRUE;
    Super.OnPanelAdded();
}
public delegate function SlideshowFinished(SFXSFHandler_Slideshow slideshow);

public function Update(float fDeltaT)
{
    local bool bCanGoNext;
    local bool bCanGoPrev;
    local bool bCanExit;
    
    m_fCurrentSlideElapsedTime += fDeltaT;
    if (m_ShowParams.AutoAdvance != FALSE)
    {
        if (m_nCurrentSlideIndex >= 0 && m_nCurrentSlideIndex < m_ShowParams.Slides.Length)
        {
            if (m_CurrentSlide.DisplayTime > 0.0 && m_fCurrentSlideElapsedTime >= m_CurrentSlide.DisplayTime)
            {
                AdvanceShow(TRUE, TRUE);
            }
        }
    }
    bCanGoNext = FALSE;
    bCanGoPrev = FALSE;
    bCanExit = FALSE;
    if (m_fCurrentSlideElapsedTime >= m_CurrentSlide.MinDisplayTime)
    {
        bCanGoNext = m_nCurrentSlideIndex < m_ShowParams.Slides.Length - 1 && m_nCurrentSlideIndex != -1;
        bCanGoPrev = m_ShowParams.AllowRewind && m_nCurrentSlideIndex > 0;
        bCanExit = m_CurrentSlide.CanExit && m_nCurrentSlideIndex != -1;
    }
    UpdateNavButtonDisplay(bCanGoNext, bCanGoPrev, bCanExit);
    Super.Update(fDeltaT);
}
public function AdvanceShow(bool bForward, optional bool bAutoAdvanced = FALSE)
{
    local int nNextImage;
    local string sNextImage;
    local array<ASParams> aParams;
    
    nNextImage = m_nCurrentSlideIndex + (bForward ? 1 : -1);
    nNextImage = Max(0, nNextImage);
    if (nNextImage >= m_ShowParams.Slides.Length)
    {
        if (m_ShowParams.AllowAdvancePastEnd != FALSE || bAutoAdvanced != FALSE)
        {
            nNextImage = -1;
            sNextImage = "";
        }
    }
    else
    {
        m_CurrentSlide = m_ShowParams.Slides[nNextImage];
        sNextImage = m_CurrentSlide.ImagePath;
    }
    m_fCurrentSlideElapsedTime = 0.0;
    aParams.Length = 1;
    aParams[0].Type = ASParamTypes.ASParam_String;
    aParams[0].sVar = sNextImage;
    oPanel.InvokeMethodArgs("SetImage", aParams);
    m_nCurrentSlideIndex = nNextImage;
    UpdateNavButtonDisplay(FALSE, FALSE, FALSE);
    if (sNextImage != "")
    {
        PreloadAdjacentSlides();
    }
}
public function BeginSlideshow()
{
    m_nCurrentSlideIndex = -1;
    if (m_bWaitingForInit)
    {
        m_bBeginWhenDoneInit = TRUE;
        return;
    }
    if (m_ShowParams.Music != 'None')
    {
        PlayGuiMusic(m_ShowParams.Music);
    }
    AdvanceShow(TRUE);
}
public function EndSlideshow(bool bFadeToBlack)
{
    if (m_ShowParams.SlidesFadeOut == FALSE && bFadeToBlack == TRUE)
    {
        bFadeToBlack = FALSE;
    }
    if (!bFadeToBlack)
    {
        StopGuiMusic();
        if (__SlideshowFinished__Delegate != None)
        {
            __SlideshowFinished__Delegate(Self);
            __SlideshowFinished__Delegate = None;
        }
        if (m_ShowParams.Music != 'None')
        {
            StopGuiMusic();
        }
        oPanel.oParentManager.RemovePanel(oPanel);
    }
    else
    {
        m_nCurrentSlideIndex = m_ShowParams.Slides.Length;
        AdvanceShow(TRUE, TRUE);
    }
}
public function ExInt_OnInitializationComplete()
{
    if (m_bWaitingForInit)
    {
        m_bWaitingForInit = FALSE;
        if (m_bBeginWhenDoneInit)
        {
            if (m_ShowParams.Slides.Length == 0)
            {
                EndSlideshow(FALSE);
            }
            else
            {
                BeginSlideshow();
            }
        }
    }
}
public function ExInt_OnTransitionComplete()
{
    if (m_nCurrentSlideIndex == -1)
    {
        EndSlideshow(FALSE);
    }
}
public function PlaySlideshow(const out SFXSlideshowParams oParams, delegate<SlideshowFinished> OnFinished)
{
    local int nImage;
    local array<ASParams> aParams;
    
    m_ShowParams = oParams;
    __SlideshowFinished__Delegate = OnFinished;
    for (nImage = 0; nImage < m_ShowParams.Slides.Length; ++nImage)
    {
        if (m_ShowParams.Slides[nImage].Image != None)
        {
            m_ShowParams.Slides[nImage].ImagePath = PathName(m_ShowParams.Slides[nImage].Image);
        }
    }
    aParams.Length = 1;
    aParams[0].Type = ASParamTypes.ASParam_Boolean;
    aParams[0].bVar = oParams.BlackBackground;
    oPanel.InvokeMethodArgs("Initialize", aParams);
    SetTransitionOptions(oParams.SlidesFadeIn, oParams.SlidesFadeOut, oParams.SlideFadeScalar);
    BeginSlideshow();
}
public function PreloadAdjacentSlides()
{
    local int nSlide;
    
    for (nSlide = 0; nSlide < m_ShowParams.Slides.Length; ++nSlide)
    {
        if (Abs(float(m_nCurrentSlideIndex - nSlide)) <= float(m_nAdjacentPreloadCount))
        {
            if (m_ShowParams.Slides[nSlide].Image == None)
            {
                m_ShowParams.Slides[nSlide].Image = Texture2D(Class'SFXEngine'.static.GetSeekFreeObject(m_ShowParams.Slides[nSlide].ImagePath, Class'Texture2D'));
            }
            continue;
        }
        m_ShowParams.Slides[nSlide].Image = None;
    }
}
public function SetTransitionOptions(bool bFadeIn, bool bFadeOut, float fFadeScalar)
{
    local array<ASParams> aParams;
    
    aParams.Length = 3;
    aParams[0].Type = ASParamTypes.ASParam_Boolean;
    aParams[0].bVar = bFadeIn;
    aParams[1].Type = ASParamTypes.ASParam_Boolean;
    aParams[1].bVar = bFadeOut;
    aParams[2].Type = ASParamTypes.ASParam_Float;
    aParams[2].fVar = fFadeScalar;
    oPanel.InvokeMethodArgs("SetTransitionOptions", aParams);
}
public function TryAdvanceShow(bool bForward)
{
    local bool bCanAdvance;
    
    bCanAdvance = bForward ? m_bCanGoNext : m_bCanGoPrev;
    if (!bCanAdvance)
    {
        return;
    }
    AdvanceShow(bForward);
}
public function TryExitShow()
{
    if (!m_bCanExit)
    {
        return;
    }
    EndSlideshow(TRUE);
}
public function UpdateNavButtonDisplay(bool bCanGoNext, bool bCanGoPrev, bool bCanExit)
{
    local array<ASParams> aParams;
    
    if (bCanGoNext != m_bCanGoNext || bCanGoPrev != m_bCanGoPrev || bCanExit != m_bCanExit)
    {
        aParams.Length = 3;
        aParams[0].Type = ASParamTypes.ASParam_String;
        aParams[0].sVar = bCanGoNext ? string(m_CurrentSlide.NextText) : "";
        aParams[1].Type = ASParamTypes.ASParam_String;
        aParams[1].sVar = bCanGoPrev ? string(m_CurrentSlide.PrevText) : "";
        aParams[2].Type = ASParamTypes.ASParam_String;
        aParams[2].sVar = bCanExit ? string(m_CurrentSlide.ExitText) : "";
        oPanel.InvokeMethodArgs("ShowNavButtons", aParams);
        m_bCanGoNext = bCanGoNext;
        m_bCanGoPrev = bCanGoPrev;
        m_bCanExit = bCanExit;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_CurrentSlide = {
                      ImagePath = "", 
                      Image = None, 
                      DisplayTime = 0.0, 
                      MinDisplayTime = 0.0, 
                      NextText = $174522, 
                      PrevText = $163277, 
                      ExitText = $256627, 
                      CanExit = TRUE
                     }
    m_ShowParams = {
                    Slides = (), 
                    Music = 'MainMenu', 
                    SlideFadeScalar = 0.25, 
                    AutoAdvance = FALSE, 
                    AllowRewind = TRUE, 
                    AllowAdvancePastEnd = FALSE, 
                    SlidesFadeIn = TRUE, 
                    SlidesFadeOut = TRUE, 
                    BlackBackground = FALSE
                   }
    m_nCurrentSlideIndex = -1
    m_nAdjacentPreloadCount = 1
}