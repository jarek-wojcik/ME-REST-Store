Class UISceneClient extends UIRoot
    native
    abstract
    transient;

const SCENEFILTER_Any = 0xFFFFFFFF;
const SCENEFILTER_ReceivesFocus = 0x00000020;
const SCENEFILTER_UsesPostProcessing = 0x00000010;
const SCENEFILTER_PrimitiveUsersOnly = 0x00000008;
const SCENEFILTER_PausersOnly = 0x00000004;
const SCENEFILTER_InputProcessorOnly = 0x00000002;
const SCENEFILTER_IncludeTransient = 0x00000001;
const SCENEFILTER_None = 0x00000000;

var const native noexport Pointer VfTable_FExec;
var const transient Matrix CanvasToScreen;
var const transient Matrix InvCanvasToScreen;
var const transient native Pointer RenderViewport;
var const transient IntPoint MousePosition;
var const transient Name OpacityParameterName;
var transient UISkin ActiveSkin;
var const transient UIObject ActiveControl;
var const transient DataStoreClient DataStoreManager;
var transient MaterialInstanceConstant OpacityParameter;
var transient PostProcessChain UIScenePostProcess;
var transient bool bEnablePostProcess;

public final native function bool ChangeActiveSkin(UISkin NewActiveSkin);

public final native function bool ChangeMouseCursor(Name CursorName);

public final native function bool CloseScene(UIScene Scene, optional bool bCloseChildScenes = TRUE, optional bool bForceCloseImmediately);

public final native function bool CloseSceneAtIndex(int SceneStackIndex, optional bool bCloseChildScenes = TRUE, optional bool bForceCloseImmediately);

public final native function Matrix GetCanvasToScreen(optional const UIObject Widget);

public final native function Matrix GetInverseCanvasToScreen(optional const UIObject Widget);

public final native function bool InitializeScene(UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene InitializedScene);

public event function InitializeSceneClient();

public final native function bool InsertScene(int DesiredInsertIndex, UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional out int ActualInsertIndex, optional byte ForcedPriority);

public final native function bool IsSceneInitialized(UIScene Scene);

public final native function bool IsUIActive(optional int Flags = -1);

public final native function bool OpenScene(UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority);

public final native function bool ReplaceScene(UIScene SceneInstanceToReplace, UIScene SceneToOpen, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority);

public final native function bool ReplaceSceneAtIndex(int IndexOfSceneToReplace, UIScene SceneToOpen, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority);

public final native function SetMousePosition(int NewMouseX, int NewMouseY);

public final native function UpdateCanvasToScreen();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OpacityParameterName = 'UI_Opacity'
    bEnablePostProcess = TRUE
}