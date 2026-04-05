Class BioSeqAct_HideSniperHudOverlay extends SequenceAction;

public function Activated()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    Class'SFXGUIInteraction'.static.GetInstance().HideSniperOverlay(PC);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}