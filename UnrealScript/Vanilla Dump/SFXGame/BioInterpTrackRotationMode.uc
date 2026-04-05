Class BioInterpTrackRotationMode extends SFXGameInterpTrack
    native
    collapsecategories;

struct native RotationModeTrackKey 
{
    var(RotationModeTrackKey) Name FindActorTag;
    var(RotationModeTrackKey) float InterpTime;
};

var(BioInterpTrackRotationMode) array<RotationModeTrackKey> EventTrack;

public static event function string GetNewTrackSubMenuName()
{
    return "";
}
public static event function string KeyDataArrayName()
{
    return "EventTrack";
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
    TrackInstClass = Class'BioInterpTrackInstRotationMode'
    TrackTitle = "RotationMode"
}