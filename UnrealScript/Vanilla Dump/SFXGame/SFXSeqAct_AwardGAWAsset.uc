Class SFXSeqAct_AwardGAWAsset extends BioSequenceLatentAction;

var string Text;
var(SFXSeqAct_AwardGAWAsset) string AssetName;
var stringref srErrorText;
var stringref srAButton;
var(SFXSeqAct_AwardGAWAsset) int Id;
var bool m_bFinished;
var bool m_bWasPaused;
var SFX_MB_Skin m_Skin;
var SFX_MB_TextAlign m_TextAlign;

public function Activated()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams MessageBox_Params;
    local BioPlayerController PC;
    local BioWorldInfo MyWorldInfo;
    local SFXGUIInteraction GUIInteraction;
    local SFXGAWAssetsHandler GAWHandler;
    local bool bSuccess;
    
    MyWorldInfo = BioWorldInfo(GetWorldInfo());
    if (MyWorldInfo == None)
    {
        return;
    }
    PC = MyWorldInfo.GetLocalPlayerController();
    if (PC == None)
    {
        return;
    }
    m_bFinished = FALSE;
    OutputLinks[0].bHasImpulse = TRUE;
    GUIInteraction = PC.GetSFXUIController();
    if (GUIInteraction == None)
    {
        return;
    }
    messageBox = GUIInteraction.CreateMessageBox(PC);
    if (messageBox == None)
    {
        return;
    }
    messageBox.SetInputDelegate(MessageInputPressed);
    MessageBox_Params.bNoFade = TRUE;
    MessageBox_Params.m_SkinType = m_Skin;
    MessageBox_Params.m_TextAlign = m_TextAlign;
    MessageBox_Params.srAText = srAButton;
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    if (Id >= 0)
    {
        bSuccess = GAWHandler.GetGAWAssetGUIInfo(Id, Text);
        if (bSuccess)
        {
            bSuccess = GAWHandler.UnlockGAWAsset(Id);
        }
    }
    else if (AssetName != "")
    {
        bSuccess = GAWHandler.GetGAWAssetGUIInfoByName(AssetName, Text);
        if (bSuccess)
        {
            bSuccess = GAWHandler.UnlockGAWAssetByAssetName(AssetName);
        }
    }
    if (!bSuccess)
    {
        Text = string(srErrorText);
    }
    messageBox.DisplayMessageBoxEx(Text, MessageBox_Params);
    m_bWasPaused = MyWorldInfo.bPlayersOnly;
    GetWorldInfo().bPlayersOnly = TRUE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public function bool UpdateOp(float fDeltaT)
{
    if (m_bFinished)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return TRUE;
    }
    return FALSE;
}
public final function MessageInputPressed(bool bAPressed, int nContext)
{
    m_bFinished = TRUE;
    GetWorldInfo().bPlayersOnly = m_bWasPaused;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srErrorText = $610183
    srAButton = $152938
    Id = -1
    m_Skin = SFX_MB_Skin.SFX_MB_Skin_Shepard
    bHasTargets = FALSE
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
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
                   }
                  )
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}