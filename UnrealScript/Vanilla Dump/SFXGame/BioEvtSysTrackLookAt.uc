Class BioEvtSysTrackLookAt extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioLookAtTrackData 
{
    var(BioLookAtTrackData) Name nmFindActor;
    var(BioLookAtTrackData) bool bEnabled;
    var(BioLookAtTrackData) bool bInstantTransition;
    var(BioLookAtTrackData) bool bLockedToTarget;
    var(BioLookAtTrackData) ESFXFindByTagTypes eFindActorMode;
    
    structdefaultproperties
    {
        bEnabled = TRUE
    }
};

var(BioEvtSysTrackLookAt) array<BioLookAtTrackData> m_aLookAtKeys;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "Bio Conversation";
}
public static event function string KeyDataArrayName()
{
    return "m_aLookAtKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Look At";
}
public static event function string NewKeyDefaultName()
{
    return "LookAt";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackLookAtInst'
    TrackTitle = "Look At"
}