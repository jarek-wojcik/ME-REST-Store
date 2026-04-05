Class BioTimerList;

struct BioTimer 
{
    var delegate<BioTimerDelegate> OnTimer;
    var string sTimerName;
    var Object Params;
    var float fTickTime;
};

var array<BioTimer> lstTimers;
var delegate<BioTimerDelegate> __BioTimerDelegate__Delegate;

public function Tick(float fDeltaT)
{
    local bool bProcessTick;
    local BioTimer Timer;
    local float fTickTime;
    
    bProcessTick = lstTimers.Length > 0;
    for (fTickTime = fDeltaT; bProcessTick; bProcessTick = lstTimers.Length > 0 && fTickTime > float(0))
    {
        if (lstTimers[0].fTickTime <= fTickTime)
        {
            Timer = lstTimers[0];
            lstTimers.Remove(0, 1);
            __BioTimerDelegate__Delegate = Timer.OnTimer;
            __BioTimerDelegate__Delegate(Timer.Params);
            fTickTime -= Timer.fTickTime;
            continue;
        }
        lstTimers[0].fTickTime -= fTickTime;
        fTickTime = 0.0;
    }
}
public function AddTimer(delegate<BioTimerDelegate> TimerDelegate, Object Params, float fTime, optional string i_sTimerName)
{
    local float fAccumulatedTime;
    local BioTimer Timer;
    local bool bInserted;
    local int i;
    
    Timer.OnTimer = TimerDelegate;
    Timer.Params = Params;
    Timer.fTickTime = fTime;
    Timer.sTimerName = i_sTimerName;
    if (lstTimers.Length == 0)
    {
        lstTimers[0] = Timer;
    }
    else
    {
        bInserted = FALSE;
        fAccumulatedTime = 0.0;
        for (i = 0; i < lstTimers.Length && bInserted == FALSE; i++)
        {
            if (fAccumulatedTime + lstTimers[i].fTickTime > fTime)
            {
                lstTimers.Insert(i, 1);
                lstTimers[i] = Timer;
                lstTimers[i + 1].fTickTime = fAccumulatedTime + lstTimers[i + 1].fTickTime - fTime;
                lstTimers[i].fTickTime -= fAccumulatedTime;
                bInserted = TRUE;
            }
            fAccumulatedTime += lstTimers[i].fTickTime;
        }
        if (!bInserted)
        {
            lstTimers[lstTimers.Length] = Timer;
            lstTimers[lstTimers.Length - 1].fTickTime -= fAccumulatedTime;
        }
    }
}
public delegate function BioTimerDelegate(Object Params);

public function bool KillTimer(string i_sTimerName)
{
    local int nIndex;
    local BioTimer Timer;
    
    for (nIndex = 0; nIndex < lstTimers.Length; nIndex++)
    {
        Timer = lstTimers[nIndex];
        if (Timer.sTimerName == i_sTimerName)
        {
            lstTimers.Remove(nIndex, 1);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}