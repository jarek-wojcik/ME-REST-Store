Class SceneCaptureComponent extends ActorComponent
    native
    abstract;

enum ESceneCaptureViewMode
{
    SceneCapView_Lit,
    SceneCapView_Unlit,
    SceneCapView_LitNoShadows,
    SceneCapView_Wire,
};

var const transient native duplicatetransient noimport array<Pointer> PostProcessProxies;
var const transient native Pointer CaptureInfo;
var const transient native Pointer ViewState;
var const transient native Pointer UmbraCamera;
var(Capture) Color ClearColor;
var(Capture) int SceneLOD;
var(Capture) const float FrameRate;
var(Capture) PostProcessChain PostProcess;
var(Capture) float MaxUpdateDist;
var(Capture) float MaxViewDistanceOverride;
var(Capture) float MaxStreamingUpdateDist;
var(Capture) bool bEnabled;
var(Capture) bool bEnablePostProcess;
var(Capture) bool bEnableFog;
var(Capture) bool bUseMainScenePostProcessSettings;
var(Capture) bool bSkipUpdateIfTextureUsersOccluded;
var(Capture) bool bSkipUpdateIfOwnerOccluded;
var(Capture) bool bSkipRenderingDepthPrepass;
var(Capture) ESceneCaptureViewMode ViewMode;

public final simulated native function SetEnabled(bool bEnable);

public final native function SetFrameRate(float NewFrameRate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ClearColor = {B = 0, G = 0, R = 0, A = 255}
    bEnabled = TRUE
    bSkipRenderingDepthPrepass = TRUE
    ViewMode = ESceneCaptureViewMode.SceneCapView_LitNoShadows
}