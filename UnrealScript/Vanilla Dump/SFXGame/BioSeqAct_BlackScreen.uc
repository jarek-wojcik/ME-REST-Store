Class BioSeqAct_BlackScreen extends BioSequenceLatentAction
    native;

enum BlackScreenActionSet
{
    BlackScreenAction_TurnBlackOn,
    BlackScreenAction_TurnBlackOff,
    BlackScreenAction_FadeToBlack,
    BlackScreenAction_FadeFromBlack,
};

var transient float fTimeExpired;
var(BioSeqAct_BlackScreen) float fTimeDelay;
var(BioSeqAct_BlackScreen) BlackScreenActionSet m_eBlackScreenAction;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    fTimeExpired = 0.0;
    if (oController != None)
    {
        switch (m_eBlackScreenAction)
        {
            case BlackScreenActionSet.BlackScreenAction_TurnBlackOn:
                Class'SFXGUIInteraction'.static.GetInstance().ShowBlackScreen(oController, FALSE);
                break;
            case BlackScreenActionSet.BlackScreenAction_TurnBlackOff:
                Class'SFXGUIInteraction'.static.GetInstance().HideBlackScreen(oController, FALSE);
                break;
            case BlackScreenActionSet.BlackScreenAction_FadeFromBlack:
                Class'SFXGUIInteraction'.static.GetInstance().HideBlackScreen(oController, TRUE);
                break;
            case BlackScreenActionSet.BlackScreenAction_FadeToBlack:
                Class'SFXGUIInteraction'.static.GetInstance().ShowBlackScreen(oController, TRUE);
                break;
            default:
                break;
        }
    }
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    OutputLinks[2].bHasImpulse = FALSE;
}
public function bool UpdateOp(float fDeltaT)
{
    local bool bFinished;
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    bFinished = FALSE;
    fTimeExpired += fDeltaT;
    if (oController != None)
    {
        switch (m_eBlackScreenAction)
        {
            case BlackScreenActionSet.BlackScreenAction_TurnBlackOn:
                if (fTimeDelay > 0.0)
                {
                    if (fTimeExpired >= fTimeDelay)
                    {
                        bFinished = TRUE;
                    }
                }
                else
                {
                    bFinished = TRUE;
                }
                break;
            case BlackScreenActionSet.BlackScreenAction_TurnBlackOff:
                bFinished = TRUE;
                break;
            case BlackScreenActionSet.BlackScreenAction_FadeFromBlack:
            case BlackScreenActionSet.BlackScreenAction_FadeToBlack:
                bFinished = Class'SFXGUIInteraction'.static.GetInstance().BlackScreenFadeFinished(oController);
                break;
            default:
                break;
        }
    }
    OutputLinks[0].bHasImpulse = bFinished;
    OutputLinks[1].bHasImpulse = FALSE;
    OutputLinks[2].bHasImpulse = FALSE;
    return bFinished;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bHasTargets = FALSE
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}