Class SFXInterpTrackMovieBase extends SFXGameInterpTrackCustom
    native
    abstract
    collapsecategories;

struct native SFXMoviePlayStateData 
{
    var int PlaceHolder;
    var(SFXMoviePlayStateData) EMoviePlayState m_eState;
};
enum EMoviePlayState
{
    EMPS_Play,
    EMPS_Stop,
    EMPS_Pause,
};

var(SFXInterpTrackMovieBase) array<SFXMoviePlayStateData> m_aMovieKeyData;

public static event function string KeyDataArrayName()
{
    return "m_aMovieKeyData";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Movie Base"
}