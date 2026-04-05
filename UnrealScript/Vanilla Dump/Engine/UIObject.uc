Class UIObject extends UIScreenObject
    native
    placeable
    abstract
    config(UI);

const CONTEXTMENU_BINDING_INDEX = 101;
const TOOLTIP_BINDING_INDEX = 100;
const FIRST_DEFAULT_DATABINDING_INDEX = 100;

var(Appearance) UIRotation Rotation;
var(Data) UIDataStoreBinding ToolTip;
var(Data) editconst UIDataStoreBinding ContextMenuData;
var UIStyleReference PrimaryStyle;
var transient array<UIStyleResolver> StyleSubscribers;
var delegate<OnCreate> __OnCreate__Delegate;
var delegate<OnPreSceneUpdate> __OnPreSceneUpdate__Delegate;
var delegate<OnPostSceneUpdate> __OnPostSceneUpdate__Delegate;
var delegate<OnValueChanged> __OnValueChanged__Delegate;
var delegate<OnRefreshSubscriberValue> __OnRefreshSubscriberValue__Delegate;
var delegate<OnPressed> __OnPressed__Delegate;
var delegate<OnPressRepeat> __OnPressRepeat__Delegate;
var delegate<OnPressRelease> __OnPressRelease__Delegate;
var delegate<OnClicked> __OnClicked__Delegate;
var delegate<OnDoubleClick> __OnDoubleClick__Delegate;
var delegate<OnOpenContextMenu> __OnOpenContextMenu__Delegate;
var delegate<OnCloseContextMenu> __OnCloseContextMenu__Delegate;
var delegate<OnContextMenuItemSelected> __OnContextMenuItemSelected__Delegate;
var(Appearance) editconst UIDockingSet DockTargets;
var(Interaction) UINavigationData NavigationTargets;
var(Appearance) const editconst transient Vector2D RenderBoundsVertices[4];
var noimport WIDGET_ID WidgetID;
var(Appearance) const editconst transient float RenderBounds[4];
var(Appearance) Vector RenderOffset;
var(Appearance) editconst Name WidgetTag;
var const duplicatetransient UIObject Owner;
var const duplicatetransient UIScene OwnerScene;
var(Interaction) int TabIndex;
var int PrivateFlags;
var UIObject AnimationParent;
var(ZDebug) Color DebugBoundsColor;
var bool bEnableActiveCursorUpdates;
var const bool bSupportsPrimaryStyle;
var bool bEnableSceneUpdateNotifications;
var(ZDebug) bool bDebugShowBounds;
var(Interaction) byte PlayerInputMask;
var(PostProcess) EUIPostProcessGroup MaskPostProcess;

public final native function AddStyleSubscriber(UIStyleResolver Subscriber);

public native function bool CanAcceptFocus(optional int PlayerIndex = 0, optional bool bIncludeParentVisibility = TRUE);

public final native function ClearDefaultDataBinding(int BindingIndex);

public final native function int FindStyleSubscriberIndex(const out UIStyleResolver Subscriber);

public final native function int FindStyleSubscriberIndexById(Name StyleSubscriberId);

public native function string GenerateSceneDataStoreMarkup(optional string Group = "ContextMenuItems");

public final native function Matrix GenerateTransformMatrix(optional bool bIncludeParentTransforms = TRUE);

public final native function Vector GetAnchorPosition(optional bool bRelativeToWidget = TRUE, optional bool bPixelSpace);

public final native function string GetDefaultDataBinding(int BindingIndex);

public final native function GetDefaultDataStores(out array<UIDataStore> out_BoundDataStores);

public final native function bool GetDockParameters(EUIWidgetFace SourceFace, out UIScreenObject TargetWidget, out EUIWidgetFace TargetFace, out float TargetPadding);

public final function UIObject GetOwner()
{
    return Owner;
}
public final native function float GetPositionExtent(EUIWidgetFace Face, optional bool bIncludeRotation, optional bool bIncludeOrigin);

public final native function GetPositionExtents(out float MinX, out float MaxX, out float MinY, out float MaxY, optional bool bIncludeRotation, optional bool bIncludeOrigin);

public final native function Matrix GetRotationMatrix(optional bool bIncludeParentRotations = TRUE);

public final native function string GetToolTipValue();

public final native function bool HasTransform(optional bool bIncludeParentTransforms = TRUE);

public final native function bool IsContainedBy(UIObject TestWidget);

public final native function bool IsDockedTo(const UIScreenObject TargetWidget, optional EUIWidgetFace SourceFace = 4, optional EUIWidgetFace TargetFace = 4);

public final native function bool IsPrivateBehaviorSet(int Behavior);

public final native function bool NeedsActiveCursorUpdates();

public native function NotifyValueChanged(optional int PlayerIndex = -1, optional int NotifyFlags = 0);

public delegate function bool OnClicked(UIScreenObject EventObject, int PlayerIndex);

public delegate function bool OnCloseContextMenu(UIContextMenu ContextMenu, int PlayerIndex);

public delegate function OnContextMenuItemSelected(UIContextMenu ContextMenu, int PlayerIndex, int ItemIndex);

public delegate function OnCreate(UIObject CreatedWidget, UIScreenObject CreatorContainer);

public delegate function OnDoubleClick(UIScreenObject EventObject, int PlayerIndex);

public delegate function bool OnOpenContextMenu(UIObject Sender, int PlayerIndex, out UIContextMenu CustomContextMenu);

public delegate function OnPostSceneUpdate(UIObject Sender);

public delegate function OnPreSceneUpdate(UIObject Sender);

public delegate function OnPressed(UIScreenObject EventObject, int PlayerIndex);

public delegate function OnPressRelease(UIScreenObject EventObject, int PlayerIndex);

public delegate function OnPressRepeat(UIScreenObject EventObject, int PlayerIndex);

public delegate function bool OnRefreshSubscriberValue(UIObject Sender, int BindingIndex);

public delegate function OnValueChanged(UIObject Sender, int PlayerIndex);

public final native function RemoveStyleSubscriber(UIStyleResolver Subscriber);

public final native function bool ResolveDefaultDataBinding(int BindingIndex);

public final native function RotateWidget(Rotator NewRotationAmount, optional bool bAccumulateRotation);

public native function SetActiveCursorUpdate(bool bShouldReceiveCursorUpdates);

public final native function SetAnchorPosition(Vector NewAnchorPosition, optional EPositionEvalType InputType = 1);

public final native function SetDefaultDataBinding(string MarkupText, int BindingIndex);

public native function bool SetDockPadding(EUIWidgetFace SourceFace, float PaddingValue, optional EUIDockPaddingEvalType PaddingInputType = 0, optional bool bModifyPaddingScaleType);

public final native function bool SetDockParameters(EUIWidgetFace SourceFace, UIScreenObject Target, EUIWidgetFace TargetFace, float PaddingValue, optional EUIDockPaddingEvalType PaddingInputType = 0, optional bool bModifyPaddingScaleType);

public native function bool SetDockTarget(EUIWidgetFace SourceFace, UIScreenObject Target, EUIWidgetFace TargetFace);

public final native function bool SetForcedNavigationTarget(EUIWidgetFace Face, UIObject NavTarget, optional bool bIsNullOverride = FALSE);

public final native function bool SetNavigationTarget(EUIWidgetFace Face, UIObject NewNavTarget);

public final native function SetPrivateBehavior(int Behavior, bool Value, optional bool bRecurse);

public final native function bool SetWidgetStyleByName(Name StyleResolverTagToSet, Name StyleFriendlyName);

public final native function UpdateRotationMatrix();

public function ClearDockTargets()
{
    local byte FaceIndex;
    
    for (FaceIndex = 0; int(FaceIndex) < 4; FaceIndex++)
    {
        SetDockParameters(FaceIndex, None, 4, 0.0);
    }
}
public function UIScreenObject GetParent()
{
    local UIScreenObject Result;
    
    Result = GetOwner();
    if (Result == None)
    {
        Result = GetScene();
    }
    return Result;
}
public final function UIScene GetScene()
{
    return OwnerScene;
}
public function LogRenderBounds(int Indent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UIComp_Event Name=WidgetEventComponent
        DefaultEvents = ({EventState = None, EventTemplate = WidgetInitializedEvent}
                        )
    End Object
    Begin Object Class=UIEvent_Initialized Name=WidgetInitializedEvent
        SubobjectVersionModifier = 2
        OutputLinks = ({
                        Links = (), 
                        LinkDesc = "Output", 
                        LinkAction = 'None', 
                        LinkedOp = None, 
                        bHasImpulse = FALSE, 
                        bDisabled = FALSE
                       }
                      )
    End Object
    Rotation = {
                TransformMatrix = {
                                   XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                                   YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                                   ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                                   WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
                                  }, 
                AnchorPosition = {ZDepth = 0.0, Value[0] = 0.0, Value[1] = 0.0, ScaleType[0] = EPositionEvalType.EVALPOS_PixelOwner, ScaleType[1] = EPositionEvalType.EVALPOS_PixelOwner}, 
                Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                AnchorType = ERotationAnchor.RA_Center
               }
    ToolTip = {
               MarkupString = "", 
               Subscriber = None, 
               DataStoreName = 'None', 
               DataStoreField = 'None', 
               BindingIndex = 100, 
               ResolvedDataStore = None, 
               RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Property
              }
    ContextMenuData = {
                       MarkupString = "", 
                       Subscriber = None, 
                       DataStoreName = 'None', 
                       DataStoreField = 'None', 
                       BindingIndex = 101, 
                       ResolvedDataStore = None, 
                       RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Collection
                      }
    PrimaryStyle = {
                    RequiredStyleClass = None, 
                    AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                    DefaultStyleTag = 'DefaultComboStyle', 
                    ResolvedStyle = None
                   }
    DockTargets = {
                   DockPadding = {
                                  PaddingValue[0] = 0.0, 
                                  PaddingValue[1] = 0.0, 
                                  PaddingValue[2] = 0.0, 
                                  PaddingValue[3] = 0.0, 
                                  PaddingScaleType[0] = EUIDockPaddingEvalType.UIPADDINGEVAL_Pixels, 
                                  PaddingScaleType[1] = EUIDockPaddingEvalType.UIPADDINGEVAL_Pixels, 
                                  PaddingScaleType[2] = EUIDockPaddingEvalType.UIPADDINGEVAL_Pixels, 
                                  PaddingScaleType[3] = EUIDockPaddingEvalType.UIPADDINGEVAL_Pixels
                                 }, 
                   TargetWidget[0] = None, 
                   TargetWidget[1] = None, 
                   TargetWidget[2] = None, 
                   TargetWidget[3] = None, 
                   OwnerWidget = None, 
                   bLockWidthWhenDocked = FALSE, 
                   bLockHeightWhenDocked = FALSE, 
                   TargetFace[0] = None, 
                   TargetFace[1] = None, 
                   TargetFace[2] = None, 
                   TargetFace[3] = None, 
                   bResolved[0] = 0, 
                   bResolved[1] = 0, 
                   bResolved[2] = 0, 
                   bResolved[3] = 0, 
                   bLinking[0] = 0, 
                   bLinking[1] = 0, 
                   bLinking[2] = 0, 
                   bLinking[3] = 0
                  }
    TabIndex = -1
    DebugBoundsColor = {B = 255, G = 128, R = 255, A = 255}
    bSupportsPrimaryStyle = TRUE
    PlayerInputMask = 15
    EventProvider = WidgetEventComponent
}