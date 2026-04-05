Class UIScrollbar extends UIObject
    native
    config(UI);

var UIStyleReference IncrementStyle;
var UIStyleReference DecrementStyle;
var UIStyleReference MarkerStyle;
var delegate<OnScrollActivity> __OnScrollActivity__Delegate;
var delegate<OnClickedScrollZone> __OnClickedScrollZone__Delegate;
var transient UIScreenValue_Position MousePosition;
var(Appearance) UIScreenValue_Extent BarWidth;
var(Appearance) UIScreenValue_Extent MinimumMarkerSize;
var(Appearance) UIScreenValue_Extent ButtonsExtent;
var(Components) const editinline export noclear UIComp_DrawImage BackgroundImageComponent;
var const UIScrollbarButton IncrementButton;
var const UIScrollbarButton DecrementButton;
var const UIScrollbarMarkerButton MarkerButton;
var transient float NudgeValue;
var(Interaction) float NudgeMultiplier;
var transient float NudgePercent;
var transient float MarkerPosPercent;
var transient float MarkerSizePercent;
var transient float MousePositionDelta;
var(Appearance) bool bAddCornerPadding;
var transient bool bInitializeMarker;
var(Appearance) EUIOrientation ScrollbarOrientation;

public final native function DragScroll(UIScrollbarMarkerButton Sender, int PlayerIndex);

public final native function DragScrollBegin(UIScreenObject Sender, int PlayerIndex);

public final native function DragScrollEnd(UIScreenObject Sender, int PlayerIndex);

public final native function EnableCornerPadding(bool FlagValue);

public final native function float GetMarkerButtonPosition();

public final native function float GetScrollZoneExtent(optional out float ScrollZoneStart);

public final native function float GetScrollZoneWidth();

public event function Initialized()
{
    Super(UIScreenObject).Initialized();
    IncrementButton.__OnPressed__Delegate = ScrollIncrement;
    IncrementButton.__OnPressRepeat__Delegate = ScrollIncrement;
    DecrementButton.__OnPressed__Delegate = ScrollDecrement;
    DecrementButton.__OnPressRepeat__Delegate = ScrollDecrement;
    MarkerButton.__OnPressed__Delegate = DragScrollBegin;
    MarkerButton.__OnPressRelease__Delegate = DragScrollEnd;
    MarkerButton.__OnButtonDragged__Delegate = DragScroll;
}
public delegate function OnClickedScrollZone(UIScrollbar Sender, float PositionPerc, int PlayerIndex);

public delegate function bool OnScrollActivity(UIScrollbar Sender, float PositionChange, optional bool bPositionMaxed = FALSE);

public event function PostInitialize()
{
    Super(UIScreenObject).PostInitialize();
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}
public final native function ScrollDecrement(UIScreenObject Sender, int PlayerIndex);

public final native function ScrollIncrement(UIScreenObject Sender, int PlayerIndex);

public final native function SetMarkerPosition(float PositionPercentage);

public final native function SetMarkerSize(float SizePercentage);

public final native function SetNudgeSizePercent(float NudgePercentage);

public final native function SetNudgeSizePixels(float NudgePixels);

public final function float GetMarkerPosPercent()
{
    return MarkerPosPercent;
}
public final function float GetMarkerSizePercent()
{
    return MarkerSizePercent;
}
public final function float GetNudgePercent()
{
    return NudgePercent;
}
public final function float GetNudgeValue()
{
    return NudgeValue;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UIComp_DrawImage Name=ScrollBarBackgroundImageTemplate
        ImageStyle = {DefaultStyleTag = 'DefaultScrollZoneStyle'}
        StyleResolverTag = 'Background Image Style'
    End Object
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    IncrementStyle = {
                      RequiredStyleClass = Class'UIStyle_Image', 
                      AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                      DefaultStyleTag = 'DefaultScrollbarIncrement', 
                      ResolvedStyle = None
                     }
    DecrementStyle = {
                      RequiredStyleClass = Class'UIStyle_Image', 
                      AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                      DefaultStyleTag = 'DefaultScrollbarDecrement', 
                      ResolvedStyle = None
                     }
    MarkerStyle = {
                   RequiredStyleClass = Class'UIStyle_Image', 
                   AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                   DefaultStyleTag = 'DefaultScrollBarStyle', 
                   ResolvedStyle = None
                  }
    MousePosition = {Value[0] = 0.0, Value[1] = 0.0, ScaleType[0] = EPositionEvalType.EVALPOS_PixelOwner, ScaleType[1] = EPositionEvalType.EVALPOS_PixelOwner}
    BarWidth = {Value = 16.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}
    MinimumMarkerSize = {Value = 12.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}
    ButtonsExtent = {Value = 16.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}
    BackgroundImageComponent = ScrollBarBackgroundImageTemplate
    NudgeValue = 1.0
    NudgeMultiplier = 1.0
    MarkerSizePercent = 1.0
    bAddCornerPadding = TRUE
    bInitializeMarker = TRUE
    ScrollbarOrientation = EUIOrientation.UIORIENT_Vertical
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Image', DefaultStyleTag = 'DefaultScrollZoneStyle'}
    PrivateFlags = 1044
    bSupportsPrimaryStyle = FALSE
    DefaultStates = (Class'UIState_Enabled', Class'UIState_Disabled', Class'UIState_Focused', Class'UIState_Pressed', Class'UIState_Active')
    EventProvider = WidgetEventComponent
}