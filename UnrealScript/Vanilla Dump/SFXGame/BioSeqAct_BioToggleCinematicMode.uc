Class BioSeqAct_BioToggleCinematicMode extends SeqAct_ToggleCinematicMode;

var(BioSeqAct_BioToggleCinematicMode) string sSkipEvent;
var(BioSeqAct_BioToggleCinematicMode) bool bCinematicInputMode;
var(BioSeqAct_BioToggleCinematicMode) bool bDisableCinematicSkip;
var(BioSeqAct_BioToggleCinematicMode) bool m_bSupportsPlayerHelmet;
var(BioSeqAct_BioToggleCinematicMode) bool m_bSupportsPlayerFace;

public function Activated()
{
    ToggleCineMode();
}
public function ToggleCineMode()
{
    local BioWorldInfo oBioInfo;
    local BioPlayerController oPlayerController;
    
    oBioInfo = BioWorldInfo(GetWorldInfo());
    if (oBioInfo != None)
    {
        oPlayerController = oBioInfo.GetLocalPlayerController();
        if (oPlayerController != None)
        {
            oPlayerController.OnToggleCinematicMode(Self);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCinematicInputMode = TRUE
    m_bSupportsPlayerHelmet = TRUE
    m_bSupportsPlayerFace = TRUE
}