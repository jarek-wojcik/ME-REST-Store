Class BioSeqAct_ShowMessage extends BioSequenceLatentAction;

var(BioSeqAct_ShowMessage) stringref srText;
var(BioSeqAct_ShowMessage) stringref srAButton;
var(BioSeqAct_ShowMessage) stringref srBButton;
var(BioSeqAct_ShowMessage) float fDisplayTime;
var(BioSeqAct_ShowMessage) int nIconIndex;
var float m_fRemainingDisplayTime;
var(BioSeqAct_ShowMessage) bool bNoFade;
var bool m_bFinished;
var bool m_bAPressed;
var bool m_bWasPaused;
var(BioSeqAct_ShowMessage) BioMessageBoxIconSets nIconSet;
var(BioSeqAct_ShowMessage) SFX_MB_Skin m_Skin;
var SFX_MB_TextAlign m_TextAlign;

public function Activated()
{
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    m_bFinished = FALSE;
    if (srAButton != 0 || srBButton != 0)
    {
        stParams.srAText = $0;
        stParams.srBText = $0;
        if (srAButton != 0)
        {
            stParams.srAText = srAButton;
        }
        if (srBButton != 0)
        {
            stParams.srBText = srBButton;
        }
        stParams.bNoFade = bNoFade;
        stParams.nIconSet = nIconSet;
        stParams.nIconIndex = nIconIndex;
        stParams.m_SkinType = m_Skin;
        stParams.m_TextAlign = m_TextAlign;
        Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox('KismetMessageBox', 4, srText, stParams, MessageInputPressed, 0, PC);
        m_bWasPaused = GetWorldInfo().bPlayersOnly;
        GetWorldInfo().bPlayersOnly = TRUE;
    }
    else if (fDisplayTime > 0.0)
    {
        oMsgBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(PC);
        m_fRemainingDisplayTime = fDisplayTime;
        oMsgBox.SetUpdateDelegate(MessageBoxUpdate);
        stParams.bNoFade = bNoFade;
        stParams.nIconSet = nIconSet;
        stParams.nIconIndex = nIconIndex;
        oMsgBox.DisplayMessageBox(srText, stParams);
    }
    else
    {
        m_bFinished = TRUE;
    }
}
public function bool UpdateOp(float fDeltaT)
{
    if (m_bFinished)
    {
        if (srAButton != 0 || srBButton != 0)
        {
            if (m_bAPressed)
            {
                OutputLinks[1].bHasImpulse = TRUE;
            }
            else
            {
                OutputLinks[2].bHasImpulse = TRUE;
            }
        }
        else
        {
            OutputLinks[0].bHasImpulse = TRUE;
        }
        return TRUE;
    }
    return FALSE;
}
public final function MessageBoxUpdate(float fDeltaT, BioSFHandler_MessageBox oMsgBox)
{
    m_fRemainingDisplayTime -= fDeltaT;
    if (m_fRemainingDisplayTime <= 0.0)
    {
        m_bFinished = TRUE;
        oMsgBox.HideMessageBox();
    }
}
public final function MessageInputPressed(bool bAPressed, int nContext)
{
    m_bFinished = TRUE;
    m_bAPressed = bAPressed;
    GetWorldInfo().bPlayersOnly = m_bWasPaused;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_Skin = SFX_MB_Skin.SFX_MB_Skin_Shepard
    bHasTargets = FALSE
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "APressed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "BPressed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Message", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srText', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "AText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srAButton', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "BText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'srBButton', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "DisplayTime", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fDisplayTime', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}