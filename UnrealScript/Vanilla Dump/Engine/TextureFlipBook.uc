Class TextureFlipBook extends Texture2D
    native
    config(Engine);

enum TextureFlipBookMethod
{
    TFBM_UL_ROW,
    TFBM_UL_COL,
    TFBM_UR_ROW,
    TFBM_UR_COL,
    TFBM_LL_ROW,
    TFBM_LL_COL,
    TFBM_LR_ROW,
    TFBM_LR_COL,
    TFBM_RANDOM,
};

var const native noexport Pointer VfTable_FTickableObject;
var const native Pointer ReleaseResourcesFence;
var const transient float TimeIntoMovie;
var const transient float TimeSinceLastFrame;
var const transient float HorizontalScale;
var const transient float VerticalScale;
var(FlipBook) int HorizontalImages;
var(FlipBook) int VerticalImages;
var(FlipBook) float FrameRate;
var float FrameTime;
var const transient int CurrentRow;
var const transient int CurrentColumn;
var const transient float RenderOffsetU;
var const transient float RenderOffsetV;
var const bool bPaused;
var const bool bStopped;
var(FlipBook) bool bLooping;
var(FlipBook) bool bAutoPlay;
var(FlipBook) TextureFlipBookMethod FBMethod;

public native function Pause();

public native function Play();

public native function SetCurrentFrame(int Row, int Col);

public native function Stop();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HorizontalImages = 1
    VerticalImages = 1
    FrameRate = 4.0
    FrameTime = 0.25
    bLooping = TRUE
    bAutoPlay = TRUE
    AddressX = TextureAddress.TA_Clamp
    AddressY = TextureAddress.TA_Clamp
}