Class SFXGUI_PlayerCountdown extends SFXGUIMovie
    transient
    config(UI);

enum EPlayerCountdownTypes
{
    PCT_Death,
    PCT_ThisPlayerRevive,
    PCT_OtherPlayerRevive,
};

var SFXGUIValue_ManualAnimController Animations[3];
var float LastBleedOutTimer;
var bool bTappingPromptVisible;

public final function AbortAnimation(EPlayerCountdownTypes AnimType)
{
    Animations[int(AnimType)].AbortAnimation();
}
public event function OnStart()
{
    Super.OnStart();
    Animations[0] = GetVariableObject("_root.DeathRootInstance.DeathCoreInstance").CastTo(Class'SFXGUIValue_ManualAnimController');
    Animations[0].__OnAnimStarted__Delegate = OnDeathStarted;
    Animations[0].__OnAnimAborted__Delegate = OnDeathAborted;
    Animations[0].__OnAnimFinished__Delegate = OnDeathFinished;
    Animations[0].Initialize();
    Animations[1] = GetVariableObject("_root.ThisPlayerReviveRootInstance.ThisPlayerReviveCoreInstance").CastTo(Class'SFXGUIValue_ManualAnimController');
    Animations[1].__OnAnimStarted__Delegate = ASPlayThisPlayerRevive;
    Animations[1].__OnAnimAborted__Delegate = OnThisPlayerReviveAborted;
    Animations[1].__OnAnimFinished__Delegate = OnThisPlayerReviveFinished;
    Animations[1].Initialize();
    Animations[2] = GetVariableObject("_root.OtherPlayerReviveRootInstance.OtherPlayerReviveCoreInstance").CastTo(Class'SFXGUIValue_ManualAnimController');
    Animations[2].__OnAnimStarted__Delegate = ASPlayOtherPlayerRevive;
    Animations[2].__OnAnimAborted__Delegate = OnOtherPlayerReviveAborted;
    Animations[2].__OnAnimFinished__Delegate = OnOtherPlayerReviveFinished;
    Animations[2].Initialize();
    UpdateEnabledState();
}
public final function PauseAnimation(EPlayerCountdownTypes AnimType)
{
    Animations[int(AnimType)].PauseAnimation();
}
public final function ResumeAnimation(EPlayerCountdownTypes AnimType)
{
    Animations[int(AnimType)].ResumeAnimation();
}
public event function Update(float DeltaTime)
{
    local int i;
    local BioPlayerController PC;
    local float BleedOutTimer;
    
    PC = BioPlayerController(GetPC());
    if (!PC.GameModeManager2.IsActive(9) && (PC.GameModeManager2.ShouldShowHUD() || PC.GameModeManager2.IsActive(19) == TRUE || PC.GameModeManager2.IsActive(20) == TRUE))
    {
        if (!GetVisible())
        {
            SetVisible(TRUE);
        }
    }
    else if (GetVisible())
    {
        SetVisible(FALSE);
    }
    BleedOutTimer = PC.Pawn.GetRemainingTimeForTimer('PermaDeath');
    if (PC.GameModeManager2.GameModes[20] != None && SFXGameModeDying(PC.GameModeManager2.GameModes[20]).ShouldShowTappingPrompt(BleedOutTimer))
    {
        ShowTappingPrompt(TRUE);
    }
    else
    {
        ShowTappingPrompt(FALSE, TRUE);
    }
    if (BleedOutTimer > LastBleedOutTimer)
    {
        Animations[0].TotalAnimationTime += BleedOutTimer - LastBleedOutTimer;
    }
    for (i = 0; i < 3; i++)
    {
        Animations[i].UpdateAnimation(DeltaTime);
    }
    LastBleedOutTimer = BleedOutTimer;
}
private final function ASAbortDeath()
{
    ActionScriptVoid("AbortDeath");
}
private final function ASAbortOtherPlayerRevive()
{
    ActionScriptVoid("AbortOtherPlayerRevive");
}
private final function ASAbortThisPlayerRevive()
{
    ActionScriptVoid("AbortThisPlayerRevive");
}
private final function ASFinishDeath()
{
    ActionScriptVoid("FinishDeath");
}
private final function ASFinishOtherPlayerRevive()
{
    ActionScriptVoid("FinishOtherPlayerRevive");
}
private final function ASFinishThisPlayerRevive()
{
    ActionScriptVoid("FinishThisPlayerRevive");
}
private final function ASPlayDeath(string PCText)
{
    ActionScriptVoid("PlayDeath");
}
private final function ASPlayOtherPlayerRevive()
{
    ActionScriptVoid("PlayOtherPlayerRevive");
}
private final function ASPlayThisPlayerRevive()
{
    ActionScriptVoid("PlayThisPlayerRevive");
}
public final function OnDeathAborted()
{
    UpdateEnabledState();
    ASAbortDeath();
}
public final function OnDeathFinished()
{
    UpdateEnabledState();
    ASFinishDeath();
}
public final function OnDeathStarted()
{
    ASPlayDeath("[" $ GetBoundKeyString("ProlongLife", FALSE, 20) $ "]");
}
public final function OnOtherPlayerReviveAborted()
{
    UpdateEnabledState();
    ASAbortOtherPlayerRevive();
}
public final function OnOtherPlayerReviveFinished()
{
    UpdateEnabledState();
    ASFinishOtherPlayerRevive();
}
public final function OnThisPlayerReviveAborted()
{
    UpdateEnabledState();
    ASAbortThisPlayerRevive();
}
public final function OnThisPlayerReviveFinished()
{
    UpdateEnabledState();
    ASFinishThisPlayerRevive();
}
public final function PlayAnimation(EPlayerCountdownTypes AnimType, float AnimationLength)
{
    Animations[int(AnimType)].BeginAnimation(AnimationLength);
    UpdateEnabledState();
    if (AnimType == EPlayerCountdownTypes.PCT_Death)
    {
        LastBleedOutTimer = AnimationLength;
    }
}
public function ShowTappingPrompt(bool bVisible, optional bool bForce = FALSE)
{
    if (bTappingPromptVisible != bVisible || bForce)
    {
        GetVariableObject("DeathRootInstance").GetObject("ButtonIconInstance").SetVisible(bVisible);
        bTappingPromptVisible = bVisible;
    }
}
public final function UpdateEnabledState()
{
    local int i;
    local bool AnimationIsActive;
    
    AnimationIsActive = FALSE;
    for (i = 0; i < 3 && !AnimationIsActive; i++)
    {
        AnimationIsActive = AnimationIsActive || Animations[i].IsActive;
    }
    SetEnabled(AnimationIsActive);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bTappingPromptVisible = TRUE
}