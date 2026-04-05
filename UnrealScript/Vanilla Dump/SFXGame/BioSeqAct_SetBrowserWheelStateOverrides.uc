Class BioSeqAct_SetBrowserWheelStateOverrides extends SequenceAction;

var(BioSeqAct_SetBrowserWheelStateOverrides) array<SubPageState> PageStates;

public event function Activated()
{
    local BioWorldInfo oWorldInfo;
    local SubPageState oStateOverride;
    local int nIndex;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo != None)
    {
        oWorldInfo.ClearBrowserWheelStateOverride();
        for (nIndex = 0; nIndex < PageStates.Length; nIndex++)
        {
            oStateOverride = PageStates[nIndex];
            oWorldInfo.AddBrowserWheelStateOverride(oStateOverride);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
}