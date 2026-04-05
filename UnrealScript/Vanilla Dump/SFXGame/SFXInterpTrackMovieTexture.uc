Class SFXInterpTrackMovieTexture extends SFXInterpTrackMovieBase
    native
    collapsecategories;

var(SFXInterpTrackMovieTexture) TextureMovie m_oTextureMovie;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aTextureMovieKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Texture Movie Data";
}
public static event function string NewKeyDefaultName()
{
    return "TextureMovie";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackTitle = "Texture Movie"
}