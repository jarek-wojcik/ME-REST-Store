Class SFXGameInterpTrackWwiseMicLock extends SFXGameInterpTrack
    native
    collapsecategories;

struct native BioMicLockData 
{
    var(BioMicLockData) Name m_nmFindActor;
    var(BioMicLockData) bool m_bLock;
    var(BioMicLockData) ESFXFindByTagTypes m_eFindActorMode;
    
    structdefaultproperties
    {
        m_bLock = TRUE
    }
};

var(SFXGameInterpTrackWwiseMicLock) array<BioMicLockData> m_aMicLockKeys;
var(SFXGameInterpTrackWwiseMicLock) bool m_bUnlockAtEnd;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string KeyDataArrayName()
{
    return "m_aMicLockKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Mic Locking Data";
}
public static event function string NewKeyDefaultName()
{
    return "Mic Locking";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bUnlockAtEnd = TRUE
    TrackInstClass = Class'SFXGameInterpTrackInstWwiseMicLock'
    TrackTitle = "Wwise Mic Lock"
    bOnePerGroup = TRUE
}