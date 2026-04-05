Class SFXInterpTrackMovieBink extends SFXInterpTrackMovieBase
    native
    collapsecategories;

var(SFXInterpTrackMovieBink) string m_sMovieName;
var(SFXInterpTrackMovieBink) float m_fAutoResizeBuffer;
var(SFXInterpTrackMovieBink) WwiseBaseSoundObject m_SoundEvent;
var(SFXInterpTrackMovieBink) bool m_bIgnoreShrinking;
var(SFXInterpTrackMovieBink) bool m_bIgnoreGrowing;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataDisplayName()
{
    return "Bink Movie Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "MovieBink";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fAutoResizeBuffer = 0.119999997
    TrackInstClass = Class'SFXGameInterpTrackInstMovieBink'
    TrackTitle = "Bink Movie"
    bOnePerGroup = TRUE
}