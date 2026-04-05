Class SFXGUIValue_ManualAnimController extends GFxValue within GFxMovie
    native
    transient;

var delegate<OnAnimStarted> __OnAnimStarted__Delegate;
var delegate<OnAnimAborted> __OnAnimAborted__Delegate;
var delegate<OnAnimFinished> __OnAnimFinished__Delegate;
var int StartFrame;
var int EndFrame;
var float ElapsedAnimationTime;
var float TotalAnimationTime;
var bool IsActive;
var bool IsPlaying;
var bool AbortRequested;

public final native function AbortAnimation();

public final native function BeginAnimation(float AnimationLength);

public final native function Initialize();

public delegate function OnAnimAborted();

public delegate function OnAnimFinished();

public delegate function OnAnimStarted();

public final native function PauseAnimation();

public final native function ResumeAnimation();

public final native function UpdateAnimation(float DeltaTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}