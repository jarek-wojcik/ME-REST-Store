Class SFXSeqAct_ShowCharacterRecordGUI extends BioSequenceLatentAction;

var bool m_bIsFinished;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local SFXGUIInteraction oMgr;
    local SFXGUIMovie oNewPanel;
    
    bAborted = FALSE;
    m_bIsFinished = FALSE;
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oMgr = Class'SFXGUIInteraction'.static.GetInstance();
        oNewPanel = oMgr.OpenMovie(oController, oMgr.MovieTag_SquadRecord, TRUE);
        if (oNewPanel != None)
        {
            oNewPanel.SetRequiresUIWorld(TRUE);
            SFXGUI_SquadRecord(oNewPanel).SetOnCloseCallback(onScreenClosed);
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
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oMgr = Class'SFXGUIInteraction'.static.GetInstance();
        if (oMgr != None)
        {
            oMgr.RemoveMovie(oController, oMgr.MovieTag_SquadRecord);
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
    bHasTargets = FALSE
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}