Class BioSFHandler_IntroText extends SFXGUIMovieLegacyAdapter
    config(UI);

const IT_Finished = 2;
const IT_Populate = 1;

var stringref srText;

public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    switch (nCommand)
    {
        case 1:
            stParam.Type = ASParamTypes.ASParam_String;
            stParam.sVar = string(srText);
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("SetString", lstParams);
            break;
        case 2:
            oPanel.oParentManager.RemovePanel(oPanel);
            break;
        default:
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nHandlerID = 25
    bSetGameMode = FALSE
}