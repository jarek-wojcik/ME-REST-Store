Class SFXSeqAct_ShowOptionsGUI extends BioSequenceLatentAction;

var bool m_bIsFinished;
var(SFXSeqAct_ShowOptionsGUI) EOptionsGuiMode OptionsGUIMode;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local SFXGUIInteraction oMgr;
    local BioSFHandler_Options oOptions;
    
    bAborted = FALSE;
    m_bIsFinished = FALSE;
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oMgr = Class'SFXGUIInteraction'.static.GetInstance();
        oOptions = oMgr.CastOpenMovie(Class'BioSFHandler_Options', oController, oMgr.MovieTag_Options, FALSE);
        if (oOptions != None)
        {
            oOptions.SetRequiresUIWorld(TRUE);
            oOptions.GuiMode = OptionsGUIMode;
            oOptions.m_bSelfPanelClose = FALSE;
            oOptions.SetOnCloseCallback(onScreenClosed);
            oOptions.Start();
        }
        else
        {
            bAborted = TRUE;
            m_bIsFinished = TRUE;
        }
    }
}
public event function Deactivated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local SFXGUIInteraction oMgr;
    local SFXGUIMovie oPanel;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oMgr = Class'SFXGUIInteraction'.static.GetInstance();
        if (oMgr != None)
        {
            oPanel = oMgr.GetMovie(oController, oMgr.MovieTag_Options);
            if (oPanel != None)
            {
                oMgr.RemovePanel(oPanel);
            }
        }
    }
}
public function bool UpdateOp(float fDeltaT)
{
    if (m_bIsFinished)
    {
        if (!bAborted)
        {
            OutputLinks[0].bHasImpulse = TRUE;
            OutputLinks[1].bHasImpulse = FALSE;
            OutputLinks[2].bHasImpulse = FALSE;
        }
        else
        {
            OutputLinks[0].bHasImpulse = FALSE;
            OutputLinks[1].bHasImpulse = TRUE;
            OutputLinks[2].bHasImpulse = TRUE;
        }
    }
    return m_bIsFinished;
}
public function onScreenClosed()
{
    m_bIsFinished = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OptionsGUIMode = EOptionsGuiMode.GuiMode_NewGame
    bHasTargets = FALSE
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}