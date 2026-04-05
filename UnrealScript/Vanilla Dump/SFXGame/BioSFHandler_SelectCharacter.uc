Class BioSFHandler_SelectCharacter extends SFXGUIMovieLegacyAdapter
    deprecated
    config(UI);

const CloseConfirm = 9;
const DeleteCharacterConfirm = 8;
const NewCharacter = 7;
const back = 6;
const PrevCharacter = 5;
const NextCharacter = 4;
const ResumeGame = 3;
const DeleteCharacter = 2;
const InitializeSelectCharacter = 1;

public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    local BioSFHandler_NewCharacter oNCHandler;
    local SFXGUIMovie oNewPanel;
    
    switch (nCommand)
    {
        case 3:
            break;
        case 4:
            UpdateCharacterData();
            break;
        case 5:
            UpdateCharacterData();
            break;
        case 1:
            UpdateCharacterData();
            break;
        case 7:
            oNewPanel = oPanel.oParentManager.OpenMovie(GetPC(), 'NewCharacter', TRUE);
            oNewPanel.SetRequiresUIWorld(TRUE);
            oNCHandler = BioSFHandler_NewCharacter(oNewPanel);
            oNCHandler.bOpenedFromMainMenu = FALSE;
            break;
        case 2:
            break;
        case 8:
            if (DoCharactersExist())
            {
                oNewPanel = oPanel.oParentManager.OpenMovie(GetPC(), 'NewCharacter', TRUE);
                oNewPanel.SetRequiresUIWorld(TRUE);
                oNCHandler = BioSFHandler_NewCharacter(oNewPanel);
                oNCHandler.bOpenedFromMainMenu = TRUE;
            }
            else
            {
                UpdateCharacterData();
            }
            break;
        case 9:
            break;
        case 6:
            oNewPanel = oPanel.oParentManager.OpenMovie(GetPC(), 'MainMenu', TRUE);
            oNewPanel.SetRequiresUIWorld(TRUE);
            oPanel.oParentManager.RemovePanel(oPanel);
            break;
        default:
    }
}
public final function bool DoCharactersExist()
{
    return FALSE;
}
public final function UpdateCharacterData()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = 0;
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    stParam.sVar = "";
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("setCharacterInfo", lstParams);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nHandlerID = 10
}