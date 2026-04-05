Class SFXGameInterpTrackProcFoley extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioProcFoleyData 
{
    var(BioProcFoleyData) float m_fMaxThreshold;
    var(BioProcFoleyData) float m_fSmoothingFactor;
    var(BioProcFoleyData) bool m_bStart;
};

var(SFXGameInterpTrackProcFoley) array<BioProcFoleyData> m_aProcFoleyStartStopKeys;
var(SFXGameInterpTrackProcFoley) WwiseEventPairObject m_TrackFoleySound;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string KeyDataArrayName()
{
    return "m_aProcFoleyStartStopKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Procedural Foley Data";
}
public static event function string NewKeyDefaultName()
{
    return "Procedural Foley";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_TrackFoleySound = WwiseEventPairObject'Wwise_Generic_Foley_Procedural.Foley_Procedural_Blend_Container'
    TrackInstClass = Class'SFXGameInterpTrackInstProcFoley'
    TrackTitle = "Procedural Foley"
}