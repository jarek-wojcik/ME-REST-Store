Class GFxMovie
    native;

enum GFxAlign
{
    Align_Center,
    Align_TopCenter,
    Align_BottomCenter,
    Align_CenterLeft,
    Align_CenterRight,
    Align_TopLeft,
    Align_TopRight,
    Align_BottomLeft,
    Align_BottomRight,
};
enum GFxScaleMode
{
    SM_NoScale,
    SM_ShowAll,
    SM_ExactFit,
    SM_NoBorder,
};
struct native ASValue 
{
    var(ASValue) init string S;
    var(ASValue) float N;
    var(ASValue) bool B;
    var(ASValue) ASType Type;
};
enum ASType
{
    AS_Undefined,
    AS_Null,
    AS_Number,
    AS_String,
    AS_Boolean,
};
struct native GFxDataStoreBinding 
{
    var(GFxDataStoreBinding) UIDataStoreBinding DataSource;
    var(GFxDataStoreBinding) string VarPath;
    var(GFxDataStoreBinding) string ModelId;
    var(GFxDataStoreBinding) string ControlId;
    var(GFxDataStoreBinding) array<Name> CellTags;
    var const transient array<byte> ModelIdUtf8;
    var const transient array<byte> ControlIdUtf8;
    var const transient array<Name> FullCellTags;
    var const transient native Pointer ModelRef;
    var const transient native Pointer ControlRef;
    var const transient UIListElementProvider ListDataProvider;
    var(GFxDataStoreBinding) bool bEditable;
    
    structdefaultproperties
    {
        ModelIdUtf8 = ""
        ControlIdUtf8 = ""
        bEditable = TRUE
    }
};
enum GFxRenderTextureMode
{
    RTM_Opaque,
    RTM_Alpha,
    RTM_AlphaComposite,
};
enum GFxTimingMode
{
    TM_Game,
    TM_Real,
};
struct native ExternalTexture 
{
    var(ExternalTexture) string Resource;
    var(ExternalTexture) Texture Texture;
};

var(GFxMovie) array<Name> CaptureKeys;
var(GFxMovie) array<Name> FocusIgnoreKeys;
var(GFxMovie) array<ExternalTexture> ExternalTextures;
var(GFxMovie) array<GFxDataStoreBinding> DataStoreBindings;
var const transient native Pointer pMovie;
var const transient native Pointer pCaptureKeys;
var const transient native Pointer pFocusIgnoreKeys;
var const transient native Object OwnedGFxValues;
var const transient native Object ASUClasses;
var const transient native Object ASUObjects;
var(GFxMovie) GFxMovieInfo MovieInfo;
var(GFxMovie) TextureRenderTarget2D RenderTexture;
var(GFxMovie) GFxFSCmdHandler FSCmdHandler;
var(GFxMovie) Object ExternalInterface;
var transient int LocalPlayerOwnerIndex;
var const transient int NextASUObject;
var(GFxMovie) int nZOrder;
var(GFxMovie) float CreationTime;
var(GFxMovie) float fRenderTime;
var transient GFxDataStoreSubscriber DataStoreSubscriber;
var(GFxMovie) bool bDisplayWithHudOff;
var bool bOnlyOwnerFocusable;
var bool bDiscardNonOwnerInput;
var(GFxMovie) bool bGammaCorrection;
var(GFxMovie) ESceneDepthPriorityGroup SceneDPG;
var(GFxMovie) GFxTimingMode TimingMode;
var(GFxMovie) GFxRenderTextureMode RenderTextureMode;

public native function Close(optional bool Unload = TRUE);

public native function Pause(optional bool pauseplay = TRUE);

public final native function SetAlignment(GFxAlign A);

public native function SetFocus(bool captureInput, optional bool Focus = TRUE);

public event native function bool Start(optional bool StartPaused = FALSE);

public final native function float ActionScriptFloat(string Path);

public final native function int ActionScriptInt(string Path);

public final native function GFxValue ActionScriptObject(string Path);

protected final native function ActionScriptSetFunction(GFxValue Obj, string member);

public final native function string ActionScriptString(string Path);

public final native function ActionScriptVoid(string Path);

public final native function AddCaptureKey(Name Key);

public final native function AddFocusIgnoreKey(Name Key);

public native function Advance(float Time);

public final native function ClearCaptureKeys();

public final native function ClearFocusIgnoreKeys();

public native function GFxValue CreateArray();

public native function GFxValue CreateObject(string ASClass, optional Class<GFxValue> Type);

public final native function FlushPlayerInput(bool capturekeysonly);

public final native function GameViewportClient GetGameViewportClient();

public final native function LocalPlayer GetLP();

public final native function PlayerController GetPC();

public native function bool GetVariableArray(string Path, int Index, out array<ASValue> Arg);

public native function bool GetVariableBool(string Path);

public native function bool GetVariableFloatArray(string Path, int Index, out array<float> Arg);

public native function bool GetVariableIntArray(string Path, int Index, out array<int> Arg);

public native function GFxValue GetVariableObject(string Path, optional Class<GFxValue> Type);

public native function string GetVariableString(string Path);

public native function bool GetVariableStringArray(string Path, int Index, out array<string> Arg);

public final native function GetVisibleFrameRect(out float x0, out float y0, out float X1, out float Y1);

public native function ASValue Invoke(string method, const out array<ASValue> Args);

public event function OnClose();

public native function PublishDataStoreValues();

public native function RefreshDataStoreBindings();

public final native function bool RegisterGFxValue(GFxValue i_val);

public native function bool SetExternalTexture(string Resource, Texture Texture);

public final native function SetPerspective3D(const out Matrix matPersp);

public final native function SetSceneDPG(ESceneDepthPriorityGroup NewDPG);

public native function SetTimingMode(GFxTimingMode mode);

public native function SetVariable(string Path, ASValue Arg);

public native function bool SetVariableArray(string Path, int Index, array<ASValue> Arg);

public native function SetVariableBool(string Path, bool B);

public native function bool SetVariableFloatArray(string Path, int Index, array<float> Arg);

public native function bool SetVariableIntArray(string Path, int Index, array<int> Arg);

public native function SetVariableNumber(string Path, float F);

public native function SetVariableObject(string Path, GFxValue Value);

public native function SetVariableString(string Path, string S);

public native function bool SetVariableStringArray(string Path, int Index, array<string> Arg);

public final native function SetView3D(const out Matrix matView);

public final native function SetViewport(int X, int Y, int Width, int Height);

public final native function SetViewScaleMode(GFxScaleMode sm);

public final native function bool UnregisterGFxValue(GFxValue i_val);

public native function ASValue GetVariable(string Path);

public native function float GetVariableNumber(string Path);

public function SetExternalInterface(Object H)
{
    ExternalInterface = H;
}
public function SetFsCmdHandler(GFxFSCmdHandler H)
{
    FSCmdHandler = H;
}
public function SetMovieInfo(GFxMovieInfo Data)
{
    MovieInfo = Data;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LocalPlayerOwnerIndex = -1
    bGammaCorrection = TRUE
    SceneDPG = ESceneDepthPriorityGroup.SDPG_PostProcess
}