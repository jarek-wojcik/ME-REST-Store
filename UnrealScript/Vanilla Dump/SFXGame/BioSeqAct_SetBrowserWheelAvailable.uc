Class BioSeqAct_SetBrowserWheelAvailable extends SequenceAction;

var(BioSeqAct_SetBrowserWheelAvailable) bool m_bMakeAvailable;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo != None)
    {
        oWorldInfo.m_bAllowBrowserWheel = m_bMakeAvailable;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bMakeAvailable = TRUE
}