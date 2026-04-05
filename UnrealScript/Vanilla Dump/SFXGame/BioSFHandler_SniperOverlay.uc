Class BioSFHandler_SniperOverlay extends SFXGUIMovieLegacyAdapter
    config(UI);

public function SetDistance(int nDistance)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = nDistance;
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("SetDistance", lstParams);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nHandlerID = 39
    bSetGameMode = FALSE
}