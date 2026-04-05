Class UIAnimation extends UIRoot
    native
    abstract;

struct native transient UIAnimSequence 
{
    var init array<UIAnimTrack> AnimationTracks;
    var init UIAnimationSeq SequenceRef;
    var init float PlaybackRate;
    var init EUIAnimationLoopMode LoopMode;
};
struct native UIAnimTrack 
{
    var array<UIAnimationKeyFrame> KeyFrames;
    var transient array<UIAnimationKeyFrame> LoopFrames;
    var EUIAnimType TrackType;
};
struct native UIAnimationKeyFrame 
{
    var UIAnimationRawData Data;
    var float RemainingTime;
    var float InterpExponent;
    var EUIAnimationInterpMode InterpMode;
    
    structdefaultproperties
    {
        InterpExponent = 1.5
    }
};
struct native UIAnimationRawData 
{
    var LinearColor DestAsColor;
    var Rotator DestAsRotator;
    var Vector DestAsVector;
    var UIAnimationNotify DestAsNotify;
    var float DestAsFloat;
};
struct native UIAnimationNotify 
{
    var Name NotifyName;
    var EUIAnimNotifyType NotifyType;
};
enum EUIAnimNotifyType
{
    EANT_WidgetFunction,
    EANT_SceneFunction,
    EANT_KismetEvent,
    EANT_Sound,
};
enum EUIAnimationLoopMode
{
    UIANIMLOOP_None,
    UIANIMLOOP_Continuous,
    UIANIMLOOP_Bounce,
};
enum EUIAnimationInterpMode
{
    UIANIMMODE_Linear,
    UIANIMMODE_EaseIn,
    UIANIMMODE_EaseOut,
    UIANIMMODE_EaseInOut,
};
enum EUIAnimType
{
    EAT_None,
    EAT_Position,
    EAT_PositionOffset,
    EAT_RelPosition,
    EAT_Rotation,
    EAT_RelRotation,
    EAT_Color,
    EAT_Opacity,
    EAT_Visibility,
    EAT_Scale,
    EAT_Left,
    EAT_Top,
    EAT_Right,
    EAT_Bottom,
    EAT_PPBloom,
    EAT_PPBlurSampleSize,
    EAT_PPBlurAmount,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}