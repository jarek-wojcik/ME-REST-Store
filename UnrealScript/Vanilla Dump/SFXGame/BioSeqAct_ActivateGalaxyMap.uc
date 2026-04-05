Class BioSeqAct_ActivateGalaxyMap extends SequenceAction
    native
    config(UI);

var config string m_sGalaxyMapResource;
var GFxMovieInfo m_oGalaxyMapReferenced;
var(BioSeqAct_ActivateGalaxyMap) SFXGalaxy m_pGalaxyMap;
var(BioSeqAct_ActivateGalaxyMap) editconst export SFXGalaxyMapGameData Data;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGalaxyMapGameData Name=GameData
    End Object
    m_sGalaxyMapResource = "GUI_SF_GalaxyMap.GalaxyMap"
    Data = GameData
    VariableLinks = ()
}