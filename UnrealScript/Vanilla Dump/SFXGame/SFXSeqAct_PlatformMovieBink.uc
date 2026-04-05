Class SFXSeqAct_PlatformMovieBink extends BioSeqAct_MovieBink
    native;

enum EMoviePlatform
{
    MoviePlatform_None,
    MoviePlatform_PC,
    MoviePlatform_PS3,
    MoviePlatform_Xbox360,
};

var(SFXSeqAct_PlatformMovieBink) array<EMoviePlatform> Platforms;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}