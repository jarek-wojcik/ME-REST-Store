Class BioSeqAct_ClearBrowserWheelStateOverrides extends SequenceAction;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo != None)
    {
        oWorldInfo.ClearBrowserWheelStateOverride();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
}