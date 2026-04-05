Class Interaction extends UIRoot
    native
    transient;

var delegate<OnReceivedNativeInputKey> __OnReceivedNativeInputKey__Delegate;
var delegate<OnReceivedNativeInputAxis> __OnReceivedNativeInputAxis__Delegate;
var delegate<OnReceivedNativeInputChar> __OnReceivedNativeInputChar__Delegate;
var delegate<OnInitialize> __OnInitialize__Delegate;

public final native function Init();

public function Initialized();

public function NotifyGameSessionEnded();

public delegate function OnInitialize();

public delegate function bool OnReceivedNativeInputAxis(int ControllerId, Name Key, float Delta, float DeltaTime, optional bool bGamepad);

public delegate function bool OnReceivedNativeInputChar(int ControllerId, string Unicode);

public delegate function bool OnReceivedNativeInputKey(int ControllerId, Name Key, EInputEvent EventType, optional float AmountDepressed = 1.0, optional bool bGamepad);

public event function PostRender(Canvas Canvas);

public event function Tick(float DeltaTime);

public function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer);

public function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    __OnInitialize__Delegate = Initialized
}