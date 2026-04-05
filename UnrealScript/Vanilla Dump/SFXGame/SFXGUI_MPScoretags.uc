Class SFXGUI_MPScoretags extends SFXGUIMovie
    native
    config(UI);

struct native SFXGUIScoreTag 
{
    var string Text;
};

var array<SFXGUIScoreTag> QueuedTags;
var SFXGUIValue_ManualAnimController ActiveScoreTagAnim;
var config float LocationX;
var config float LocationY;
var config float Lifetime;
var float ScreenLocationX;
var float ScreenLocationY;

public final event function DisplayScoreTag()
{
    if (!ActiveScoreTagAnim.IsActive)
    {
        AS_SetScoreTagText(QueuedTags[0].Text);
        ActiveScoreTagAnim.BeginAnimation(Lifetime);
    }
}
public event function OnStart()
{
    local float x0;
    local float y0;
    local float X1;
    local float Y1;
    
    Super.OnStart();
    SetViewScaleMode(0);
    GetVisibleFrameRect(x0, y0, X1, Y1);
    ScreenLocationX = (X1 - x0) * (0.5 + LocationX) + x0;
    ScreenLocationY = (Y1 - y0) * (0.5 + LocationY) + y0;
    ActiveScoreTagAnim = GetVariableObject("_root.ScoreTagInstance").CastTo(Class'SFXGUIValue_ManualAnimController');
    ActiveScoreTagAnim.Initialize();
    ActiveScoreTagAnim.__OnAnimFinished__Delegate = FinishScoreTagClip;
    ActiveScoreTagAnim.__OnAnimAborted__Delegate = FinishScoreTagClip;
    ActiveScoreTagAnim.SetPosition(ScreenLocationX, ScreenLocationY);
    UpdateEnabledState();
}
private final function AS_SetScoreTagText(string ScoreText)
{
    ActionScriptVoid("screen.SetScoreTagText");
}
public final function FinishScoreTagClip()
{
    QueuedTags.Remove(0, 1);
    UpdateEnabledState();
}
public final function QueueScoretag(int Amount, string Message)
{
    local SFXGUIScoreTag NewTag;
    
    if (Amount == 0 && Message == "")
    {
        return;
    }
    NewTag.Text = (Amount >= 0 ? "+" $ Amount : string(Amount)) @ Message;
    QueuedTags.AddItem(NewTag);
    UpdateEnabledState();
}
public final function UpdateEnabledState()
{
    local bool IsEnabled;
    
    IsEnabled = QueuedTags.Length > 0;
    SetEnabled(IsEnabled);
    ActiveScoreTagAnim.SetVisible(IsEnabled);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LocationY = -0.200000003
    Lifetime = 2.0
}