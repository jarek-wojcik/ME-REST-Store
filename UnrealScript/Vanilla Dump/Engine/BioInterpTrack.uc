Class BioInterpTrack extends InterpTrack
    native
    abstract
    collapsecategories;

struct native BioTrackKey 
{
    var(BioTrackKey) Name KeyName;
    var float fTime;
};

var array<BioTrackKey> m_aTrackKeys;
var transient int m_nCurrentKey;
var transient int m_nNextKey;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string KeyDataArrayName()
{
    return "";
}
public static event function string KeyDataDisplayName()
{
    return "";
}
public static event function string NewKeyDefaultName()
{
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nCurrentKey = -1
    m_nNextKey = -1
}