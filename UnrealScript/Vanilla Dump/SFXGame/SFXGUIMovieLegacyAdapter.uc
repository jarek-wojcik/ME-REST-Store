Class SFXGUIMovieLegacyAdapter extends SFXGUIMovie
    native
    config(UI);

struct native BioSFQueuedCommand 
{
    var string sCommand;
    var array<ASParams> lstParameters;
};
struct native SFXGUILegacyScaleformResource 
{
    var transient native GPtr_Mirror MovieDef;
    var transient native GPtr_Mirror MovieView;
    var GFxMovie GFxMovie;
};
struct GPtr_Mirror 
{
    var const native Pointer pObject;
};

var SFXGUILegacyScaleformResource MovieResource;
var array<BioSFQueuedCommand> lstQueuedCommands;
var SFXGUIMovieLegacyAdapter oPanel;
var SFXGUIInteraction oParentManager;
var int nHandlerID;
var bool bSetGameMode;
var bool bIgnoreGCOnPanelCleanup;
var bool bPipeDirectInputToGFx;
var EGameModes eGameMode;

public function GameSessionEnded();

public final native function SFXGUIMovie GetDefaultHandler();

public native function Vector2D GetStageViewportOffset();

public final native function float GetVariableFloat(string sPath);

public final native function GotoFrameAndPlay(string sPath, int nFrame);

public final native function GotoFrameAndStop(string sPath, int nFrame);

public final native function GotoLabelAndPlay(string sPath, string sLabel);

public final native function GotoLabelAndStop(string sPath, string sLabel);

public event function HandleEvent(byte nCommand, const out array<string> lstArguments);

public native function InvokeMethod(string sMethodName);

public native function InvokeMethodArgs(string sMethodName, const out array<ASParams> lstArguments);

public native function bool IsMouseShown();

public event function OnPanelAdded()
{
    if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        SetMenuAdvanceSwapped(IsEnterMenuButtonAssignmentSwapped());
    }
}
public event function OnPanelRemoved();

public native function QueueCommand(const out BioSFQueuedCommand stQueuedCommand);

public native function SendMouseToScaleForm(byte nEvent);

public final native function SetClipHeight(string sPath, float fHeight);

public final native function SetClipLocation(string sPath, float fX, float fY);

public final native function SetClipVisibility(string sPath, bool bVisible);

public final native function SetClipWidth(string sPath, float fWidth);

public native function SetEventsDisabled(bool bDisabled);

public native function bool SetExternalTextureOnPanel(string Resource, Texture Texture);

public native function SetInputDisabled(bool bDisabled);

public native function SetMouseShown(optional bool showIt = FALSE);

public native function SetMovieVisibility(bool bVisible);

public final native function SetTextFieldText(string sPath, string sText, optional bool bHTML = FALSE);

public final native function SetVariableFloat(string sPath, float fVar);

public event function Update(float fDeltaT);

public function SetMenuAdvanceSwapped(bool bSwapped)
{
    ActionScriptVoid("_global.com.SFXScreen.SetMenuAdvanceSwapped");
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    nHandlerID = -1
    bSetGameMode = TRUE
    eGameMode = EGameModes.GameMode_GUI
    m_bAcceptingFSCommands = TRUE
}