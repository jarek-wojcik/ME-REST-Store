Class BioSubtitles
    native
    config(Game);

struct native SFXSubtitleEntry 
{
    var string sSubtitle;
    var Color colFontColor;
    var float fTimeRemaining;
    var Object pRefObject;
    var Actor pActor;
    var float fDelayStarting;
    var bool bAlert;
    var bool bHasPriority;
    var ESubtitlesRenderMode eRenderMode;
    
    structdefaultproperties
    {
        colFontColor = {B = 255, G = 255, R = 255, A = 255}
        eRenderMode = ESubtitlesRenderMode.SUBTITLE_RENDER_DEFAULT
    }
};
enum ESubtitlesRenderMode
{
    SUBTITLE_RENDER_NONE,
    SUBTITLE_RENDER_DEFAULT,
    SUBTITLE_RENDER_TOP,
    SUBTITLE_RENDER_BOTTOM,
    SUBTITLE_RENDER_ABOVE_WHEEL,
    SUBTITLE_RENDER_LOADSCREEN,
};

var transient array<SFXSubtitleEntry> m_aSubtitles;
var transient int m_nCurrentSubtitle;
var transient bool m_bSubtitleVisible;
var config ESubtitlesRenderMode m_DefaultRenderMode;

public final native function AddSubtitle(string sSubtitle, Object pRefObject, Actor pActor, Color colFontColor, bool bAlert, ESubtitlesRenderMode eRenderMode, bool bHasPriority, optional float fDuration = -1.0, optional float fDelayStarting = 0.0);

public final native function ClearAllSubtitles();

public final native function ClearSubtitleText(Object pRefObject);

public final native function Enforce16x9(bool bEnforce);

public final native function bool HasSubtitle();

public final native function RemoveSubtitle(Object pRefObject);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nCurrentSubtitle = -1
    m_DefaultRenderMode = ESubtitlesRenderMode.SUBTITLE_RENDER_TOP
}