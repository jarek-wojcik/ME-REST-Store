Class SFXSeqAct_InitMainMenu extends SequenceAction;

public function Activated()
{
    local BioPlayerController PC;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    PC = oWorldInfo.GetLocalPlayerController();
    PC.UpdateProfileData();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}