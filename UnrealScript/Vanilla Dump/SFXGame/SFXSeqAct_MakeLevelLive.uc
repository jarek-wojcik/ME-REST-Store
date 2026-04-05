Class SFXSeqAct_MakeLevelLive extends SequenceAction;

public event function Activated()
{
    local int idx;
    local array<SequenceObject> Events;
    local BioWorldInfo oWorldInfo;
    local SFXSeqEvt_LevelIsLive LevelLiveEvent;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo.m_bLevelIsLive == FALSE)
    {
        oWorldInfo.MakeLevelLive();
        oWorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SFXSeqEvt_LevelIsLive', TRUE, Events);
        for (idx = 0; idx < Events.Length; idx++)
        {
            LevelLiveEvent = SFXSeqEvt_LevelIsLive(Events[idx]);
            if (LevelLiveEvent != None && LevelLiveEvent.m_bInitialized)
            {
                LevelLiveEvent.CheckActivate(oWorldInfo, None);
            }
        }
        SFXGame(oWorldInfo.Game).PostMakeLevelLive();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ()
}