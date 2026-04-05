Class SFXGUI_MainMenu_Message
    native
    abstract
    transient;

enum MMM_Status
{
    MMM_DataUnloaded,
    MMM_DataLoading,
    MMM_DataLoadFailed,
    MMM_DataLoadSuccess,
    MMM_DataLoadProcessed,
};

var const native noexport Pointer VfTable_FTickableObject;
var string Message;
var string Title;
var delegate<OnMessageDataLoaded> __OnMessageDataLoaded__Delegate;
var GFxValue MovieClip;
var int Id;
var int ServerID;
var int DLC_ID;
var bool bGFxClassLoaded;
var bool bTelemetryFired;
var MMM_Status Status;
var SFXOnlineConnection_MessageType MessageType;

public function Cleanup()
{
    MovieClip = None;
    __OnMessageDataLoaded__Delegate = None;
}
public native function MMM_Status GetStatus();

public native function Load(optional delegate<OnMessageDataLoaded> aFunction = None);

public native function LoadComplete();

public event function OnLoad();

public event function OnLoadComplete()
{
    AS_SetDataLoadStatus(int(Status));
}
public delegate function OnMessageDataLoaded(SFXGUI_MainMenu_Message aMessageThatFinishedLoading);

public final function AS_SetDataLoadStatus(int nStatus)
{
    MovieClip.ActionScriptVoid("SetDataLoadStatus");
}
public function OnDisplayed()
{
    if (DLC_ID > 0 && MessageType == SFXOnlineConnection_MessageType.SFXONLINE_MT_DOWNLOAD_PROMPT && !bTelemetryFired)
    {
        Class'SFXTelemetry'.static.SendInt('TelemetryHook_DLC_Notified', DLC_ID);
        bTelemetryFired = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}