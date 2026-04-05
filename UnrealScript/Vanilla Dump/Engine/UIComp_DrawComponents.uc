Class UIComp_DrawComponents extends UIComponent within UIObject
    native;

enum EFadeType
{
    EFT_None,
    EFT_Fading,
    EFT_Pulsing,
};

var delegate<OnFadeComplete> __OnFadeComplete__Delegate;
var(Rendering) transient float FadeAlpha;
var(Rendering) transient float FadeTarget;
var(Rendering) transient float FadeTime;
var transient float LastRenderTime;
var transient float FadeRate;
var(Rendering) transient EFadeType FadeType;

public final native function Fade(float FromAlpha, float ToAlpha, float TargetFadeTime);

public delegate function OnFadeComplete(UIComp_DrawComponents Sender);

public final native function Pulse(optional float MaxAlpha = 1.0, optional float MinAlpha = 0.0, optional float PulseRate = 1.0);

public final native function ResetFade();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}