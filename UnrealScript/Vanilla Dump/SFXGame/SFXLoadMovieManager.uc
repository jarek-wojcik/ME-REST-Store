Class SFXLoadMovieManager
    native
    transient
    config(Game);

struct native NativeLoadingMovie 
{
    var string Filename;
    var Name Tag;
    var WwiseEventPairObject AudioEventPair;
    var int LoopBackFrame;
    var float MinPlayTime;
    var float FadeInTime;
    var float FadeOutTime;
    var WwiseEvent FadeOutAudioEvent;
};
struct native LoadingLevelTip 
{
    var string LevelName;
    var LoadingTip Tip;
    var bool UseRandomTip;
};
struct native LoadingTip 
{
    var stringref GenericTip;
    var stringref PCOverrideTip;
    var stringref PS3OverrideTip;
    var stringref XBoxOverrideTip;
};
enum LoadingMovieState
{
    LMS_NotPlaying,
    LMS_Playing,
};

var delegate<LoadingMovieDelegate> MovieStateDelegates[2];
var config array<NativeLoadingMovie> NativeMovies;
var config array<LoadingLevelTip> AreaLoadTips;
var config array<LoadingTip> LoadTips;
var array<string> LoadingMovieNames;
var array<BioLoadingMovie> DefaultLoadingMovies;
var delegate<LoadingMovieDelegate> __LoadingMovieDelegate__Delegate;
var config Name WWiseGlobalEvent_LoadMute;
var config Name WWiseGlobalEvent_LoadUnMute;
var WwiseEventPairObject MovieSound;
var int nLoopBackFrame;
var stringref srLevelLoadTipStrRef;
var float FadeInTime;
var float FadeOutTime;
var WwiseEvent FadeOutWwiseEvent;
var float MinPlayTime;
var config float LoadMovieAudioTimerDelay;
var bool bPlayToCompletion;
var bool bRequireExplicitStop;
var bool bResetToDefaultOnPlayLoadMovie;
var bool bShowLevelLoadTip;
var bool bStreamFromDisc;
var LoadingMovieState PlaybackState;

public final native function stringref GetRandomTip();

public final native function InitLoadScreenTip(string LevelName);

public final native function bool IsLoadingMoviePlaying();

public delegate function LoadingMovieDelegate();

public final native function bool PlayLoadingMovie(string LevelName, optional bool bForcePlay = FALSE);

public final native function ResetToDefaultLoadMovie();

public final native function SetupLoadingMovie(const out array<BioLoadingMovie> Movies, BioSFScreenTip ScreenTip, bool HideLoadingTip, bool RequiresExplicitStop, bool PlayToCompletion, bool StreamFromDisc);

public final native function SetupNativeLoadingMovie(Name Tag, optional BioSFScreenTip ScreenTip, optional bool RequiresExplicitStop, optional bool PlayToCompletion, optional bool StreamFromDisc);

public final native function bool StopLoadingMovie(optional bool bDelayStopUntilGameHasRendered = FALSE);

public final event function TriggerDelegates(LoadingMovieState TriggerState)
{
    local delegate<LoadingMovieDelegate> DelegateToCall;
    
    DelegateToCall = MovieStateDelegates[int(TriggerState)];
    if (DelegateToCall != None)
    {
        MovieStateDelegates[int(TriggerState)] = None;
        DelegateToCall();
    }
}
public final function RegisterDelegate(LoadingMovieState TriggerState, delegate<LoadingMovieDelegate> InDelegate)
{
    MovieStateDelegates[int(TriggerState)] = InDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AreaLoadTips = ({
                     LevelName = "Biop_Char", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "Biop_Nor", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_CitHub", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_OmgHub", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "EntryMenu", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "MPLobby", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_ProEar", 
                     Tip = {GenericTip = $720209, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_ProMar", 
                     Tip = {GenericTip = $723283, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_ProCit", 
                     Tip = {GenericTip = $723284, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Gth001", 
                     Tip = {GenericTip = $723282, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Gth002", 
                     Tip = {GenericTip = $723290, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_GthN7a", 
                     Tip = {GenericTip = $723297, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_GthLeg", 
                     Tip = {GenericTip = $723298, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Cat001", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_KroGar", 
                     Tip = {GenericTip = $723285, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Kro001", 
                     Tip = {GenericTip = $723286, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Kro002", 
                     Tip = {GenericTip = $723289, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_KroN7a", 
                     Tip = {GenericTip = $701750, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_KroN7b", 
                     Tip = {GenericTip = $723295, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_KroGru", 
                     Tip = {GenericTip = $723296, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Cat002", 
                     Tip = {GenericTip = $723291, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Cat003", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_CerMir", 
                     Tip = {GenericTip = $723292, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_CerJcb", 
                     Tip = {GenericTip = $723300, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_CitSam", 
                     Tip = {GenericTip = $723299, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_OmgJck", 
                     Tip = {GenericTip = $701627, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPDish", 
                     Tip = {GenericTip = $701805, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPSlum", 
                     Tip = {GenericTip = $701796, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPTowr", 
                     Tip = {GenericTip = $723301, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPCer", 
                     Tip = {GenericTip = $701802, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPMoon", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_SPRctr", 
                     Tip = {GenericTip = $701808, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_SPGeth", 
                     Tip = {GenericTip = $0, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = TRUE
                    }, 
                    {
                     LevelName = "BioP_SPNov", 
                     Tip = {GenericTip = $701794, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_Cat004", 
                     Tip = {GenericTip = $723293, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_End001", 
                     Tip = {GenericTip = $723294, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_End002", 
                     Tip = {GenericTip = $720231, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }, 
                    {
                     LevelName = "BioP_End003", 
                     Tip = {GenericTip = $720221, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                     UseRandomTip = FALSE
                    }
                   )
    LoadTips = ({GenericTip = $720209, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720210, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720211, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720212, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720213, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720214, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720215, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720216, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720217, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720218, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720219, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720220, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720221, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720222, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720223, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720224, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720225, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720226, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720227, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720228, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720229, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720230, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720231, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720232, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720233, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720234, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720235, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720236, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720237, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720238, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720239, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720240, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720241, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720242, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720243, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720244, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720245, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720246, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $720794, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $721605, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $722007, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}, 
                {GenericTip = $722685, PCOverrideTip = $0, PS3OverrideTip = $0, XBoxOverrideTip = $0}
               )
    DefaultLoadingMovies = (BioLoadingMovie'BioSFMovieReference.DefaultLoadingMovie')
    WWiseGlobalEvent_LoadMute = 'Load_Mute'
    WWiseGlobalEvent_LoadUnMute = 'Load_UnMute'
    LoadMovieAudioTimerDelay = 2.0
    bShowLevelLoadTip = TRUE
}