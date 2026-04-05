Class SFXSeqAct_CloseGalaxyMap extends SequenceAction;

public event function Activated()
{
    local BioSFHandler_GalaxyMap oHandler;
    local BioPlayerController PC;
    local SFXGUIInteraction oGUI;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oHandler = oGUI.CastGetMovie(Class'BioSFHandler_GalaxyMap', PC, oGUI.MovieTag_GalaxyMap);
    if (oHandler != None)
    {
        oHandler.ExitGalaxyMap(TRUE);
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}