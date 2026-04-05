Class SFXGUIMovieKismet extends SFXGUIMovie
    native
    config(UI);

var(SFXGUIMovieKismet) array<GFxMovieInfo> ReferencedMovies;
var bool KismetMonitored;
var bool CloseRequested;
var bool UnloadOnClose;

public function Close(optional bool bUnload = TRUE)
{
    if (KismetMonitored)
    {
        CloseRequested = TRUE;
        UnloadOnClose = bUnload;
        return;
    }
    KismetMonitored = FALSE;
    CloseRequested = FALSE;
    Super.Close(bUnload);
}
public event function KismetClose()
{
    KismetMonitored = FALSE;
    CloseRequested = FALSE;
    Super.Close(UnloadOnClose);
}
public event function OnStart()
{
    if (oWorldInfo == None)
    {
        oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    }
    Super.OnStart();
    if (m_bFocusOnStart)
    {
        SetGameMode(TRUE);
        SetMouseVisible(TRUE);
    }
}
public event function OnClose()
{
    Super.OnClose();
    if (m_bFocusOnStart)
    {
        SetMouseVisible(FALSE);
        SetGameMode(FALSE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bFocusOnStart = TRUE
}