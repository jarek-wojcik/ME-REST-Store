Class BioSFHandler_SharedIGG extends SFXGUIMovieExtension within SFXGUIMovie;

const CloseGui = 2;
const ReturnToBrowserMenu = 1;

public function HandleFSCommand(byte nCommand, const out array<string> lstArguments)
{
    switch (nCommand)
    {
        case 1:
            ReturnToBrowser();
            break;
        case 2:
            CloseGUIs();
            break;
        default:
    }
}
public final function CloseGUIs()
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = Outer.GetSFXUIController();
    if (Outer.oWorldInfo == None || Outer.oWorldInfo.GetInputLock(0.25) == FALSE)
    {
        return;
    }
    oGuiMgr.HideBrowserWheel(Outer, Outer.GetPC());
}
public final function ReturnToBrowser()
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = Outer.GetSFXUIController();
    if (Outer.oWorldInfo == None || Outer.oWorldInfo.GetInputLock(0.25) == FALSE)
    {
        return;
    }
    oGuiMgr.ReturnToBrowserWheel(Outer, FALSE, Outer.GetPC());
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nFSHandlerID = 20
}