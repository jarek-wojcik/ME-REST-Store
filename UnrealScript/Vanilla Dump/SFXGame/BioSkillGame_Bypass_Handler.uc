Class BioSkillGame_Bypass_Handler extends BioSkillGame_Base_Handler
    native
    config(UI);

var Vector m_vRightInput;
var Vector m_vLeftInput;
var int m_nNumToSpawn;
var int m_nPCBurnDown;
var int m_nConsoleBurnDown;

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            m_vLeftInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            m_vLeftInput.Y = -fValue;
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public function OnPanelAdded()
{
    oPanel.SetExternalInterface(Self);
    oPanel.m_bApplyLeftThumbstickDeadzone = TRUE;
    oPanel.m_bApplyRightThumbstickDeadzone = TRUE;
    oPanel.SetMouseVisible(TRUE);
    Super(SFXGUIMovieLegacyAdapter).OnPanelAdded();
}
public function Update(float fDeltaT)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    local float DeadZone;
    local float fDeadzoneModifier;
    
    if (oPanel != None)
    {
        DeadZone = 0.100000001;
        fDeadzoneModifier = FClamp((VSize(m_vLeftInput) - DeadZone) / (1.0 - DeadZone), 0.0, 1.0);
        if (fDeadzoneModifier > 0.0)
        {
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = m_vLeftInput.X * fDeadzoneModifier;
            lstParams.AddItem(stParam);
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = m_vLeftInput.Y * fDeadzoneModifier;
            lstParams.AddItem(stParam);
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = 0.0;
            lstParams.AddItem(stParam);
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = 0.0;
            lstParams.AddItem(stParam);
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = fDeltaT;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("SetCursorPositions", lstParams);
        }
        lstParams.Length = 0;
        stParam.Type = ASParamTypes.ASParam_Float;
        stParam.fVar = fDeltaT * float(1000);
        lstParams.AddItem(stParam);
        oPanel.InvokeMethodArgs("Update", lstParams);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nNumToSpawn = 3
    m_nPCBurnDown = 1250
    m_nConsoleBurnDown = 2000
    m_sBackgroundMusic = "SkillGameBackgroundDecoding"
    m_sTecPlotStateName = 'Tec_MiniGameDecrypt'
    m_fTecTimeMultiplier = 2.0
}