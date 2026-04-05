Class BioSkillGame_Decryption_Handler extends BioSkillGame_Base_Handler
    native
    config(UI);

var int m_nPercentDanger;
var int m_nPercentGood;
var float m_fSpeed;

public function OnPanelAdded()
{
    oPanel.m_bUseThumbstickAsDPad = TRUE;
    oPanel.SetExternalInterface(Self);
    Super(SFXGUIMovieLegacyAdapter).OnPanelAdded();
}
public function Update(float fDeltaT)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    if (oPanel != None)
    {
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = fDeltaT * float(1000);
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("Update", lstParams);
    }
}
public function onDownPressed()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    if (oPanel != None)
    {
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = 1.0;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("OnVerticalInput", lstParams);
    }
}
public function onLeftPressed()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    if (oPanel != None)
    {
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = -1.0;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("OnHorizontalInput", lstParams);
    }
}
public function onRightPressed()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    if (oPanel != None)
    {
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = 1.0;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("OnHorizontalInput", lstParams);
    }
}
public function onSelectPressed()
{
    if (oPanel != None)
    {
        oPanel.InvokeMethod("DoSelection");
    }
}
public function onUpPressed()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    if (oPanel != None)
    {
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = -1.0;
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("OnVerticalInput", lstParams);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nPercentDanger = 20
    m_nPercentGood = 20
    m_fSpeed = 1.0
    m_sBackgroundMusic = "SkillGameBackgroundDecoding"
    m_sTecPlotStateName = 'Tec_MiniGameHack'
    m_fTecTimeMultiplier = 2.0
}