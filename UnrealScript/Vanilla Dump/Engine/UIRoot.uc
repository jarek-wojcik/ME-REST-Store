Class UIRoot
    native
    abstract;

struct native UIInputAliasClassMap 
{
    var string WidgetClassName;
    var array<UIInputAliasStateMap> WidgetStates;
    var Class<UIScreenObject> WidgetClass;
    var const transient native Object StateLookupTable;
    var const transient native Object StateReverseLookupTable;
};
struct native export UIInputAliasStateMap 
{
    var string StateClassName;
    var array<UIInputActionAlias> StateInputAliases;
    var Class<UIState> State;
};
struct native export UIInputAliasMap 
{
    var const transient native MultiMap_Mirror InputAliasLookupTable;
};
struct native export transient UIInputAliasValue 
{
    var init Name InputAliasName;
    var init byte ModifierFlagMask;
};
struct native export UIInputActionAlias 
{
    var array<RawInputKeyEventData> LinkedInputKeys;
    var Name InputAliasName;
};
struct native export RawInputKeyEventData 
{
    var Name InputKeyName;
    var byte ModifierKeyFlags;
    
    structdefaultproperties
    {
        ModifierKeyFlags = 56
    }
};
struct native UIAxisEmulationDefinition 
{
    var Name InputKeyToEmulate[2];
    var Name AxisInputKey;
    var Name AdjacentAxisInputKey;
    var bool bEmulateButtonPress;
};
struct native transient SubscribedInputEventParameters extends InputEventParameters 
{
    var const transient init Name InputAliasName;
};
struct native transient InputEventParameters 
{
    var const transient init Name InputKeyName;
    var const transient init int PlayerIndex;
    var const transient init int ControllerId;
    var const transient init float InputDelta;
    var const transient init float DeltaTime;
    var const transient init bool bAltPressed;
    var const transient init bool bCtrlPressed;
    var const transient init bool bShiftPressed;
    var const transient init EInputEvent EventType;
};
struct native export UIMouseCursor 
{
    var(UIMouseCursor) Name CursorStyle;
    var(UIMouseCursor) UITexture Cursor;
};
struct native transient WrappedStringElement 
{
    var init string Value;
    var init Vector2D LineExtent;
};
struct native transient UIStringNode_FormattedNodeParent extends UIStringNode_Text 
{
    
    structdefaultproperties
    {
        NodeStyleParameters = {
                               AdjustmentType[0] = {AdjustmentType = EMaterialAdjustmentType.ADJUST_None}, 
                               AdjustmentType[1] = {AdjustmentType = EMaterialAdjustmentType.ADJUST_None}, 
                               TextColor = {R = 0.0, G = 0.0, B = 0.0, A = 0.0}, 
                               ImageColor = {R = 0.0, G = 0.0, B = 0.0, A = 0.0}, 
                               TextAutoScaling = {MinScale = 0.0}, 
                               TextScale = {X = 0.0, Y = 0.0}, 
                               TextClipMode = ETextClipMode.CLIP_None
                              }
    }
};
struct native transient UIStringNode_NestedMarkupParent extends UIStringNode 
{
    
    structdefaultproperties
    {
        Scaling = {X = 0.0, Y = 0.0}
    }
};
struct native transient UIStringNode_Image extends UIStringNode 
{
    var(UIStringNode_Image) init TextureCoordinates TexCoords;
    var(UIStringNode_Image) init Vector2D ForcedExtent;
    var(UIStringNode_Image) init UITexture RenderedImage;
    
    structdefaultproperties
    {
        Scaling = {X = 0.0, Y = 0.0}
    }
};
struct native transient UIStringNode_Text extends UIStringNode 
{
    var(UIStringNode_Text) init string RenderedText;
    var init UICombinedStyleData NodeStyleParameters;
    
    structdefaultproperties
    {
        NodeStyleParameters = {
                               AdjustmentType[0] = {
                                                    ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                                    ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                                    AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                                                    Alignment = EUIAlignment.UIALIGN_Left
                                                   }, 
                               AdjustmentType[1] = {
                                                    ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                                    ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                                    AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                                                    Alignment = EUIAlignment.UIALIGN_Left
                                                   }, 
                               TextColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}, 
                               ImageColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}, 
                               AtlasCoords = {U = 0.0, V = 0.0, UL = 0.0, VL = 0.0}, 
                               TextPadding[0] = 0.0, 
                               TextPadding[1] = 0.0, 
                               ImagePadding[0] = 0.0, 
                               ImagePadding[1] = 0.0, 
                               TextAutoScaling = {MinScale = 0.600000024, AutoScaleMode = ETextAutoScaleMode.UIAUTOSCALE_None}, 
                               TextScale = {X = 1.0, Y = 1.0}, 
                               TextSpacingAdjust = {X = 0.0, Y = 0.0}, 
                               DrawFont = None, 
                               FallbackImage = None, 
                               TextAttributes = {Bold = FALSE, Italic = FALSE, Underline = FALSE, Shadow = FALSE, Strikethrough = FALSE}, 
                               bInitialized = FALSE, 
                               TextAlignment[0] = EUIAlignment.UIALIGN_Left, 
                               TextAlignment[1] = EUIAlignment.UIALIGN_Left, 
                               TextClipMode = None, 
                               TextClipAlignment = EUIAlignment.UIALIGN_Left
                              }
        Scaling = {X = 0.0, Y = 0.0}
    }
};
struct native transient UIStringNode 
{
    var const transient native noexport init Pointer VfTable;
    var(UIStringNode) init string SourceText;
    var const transient native init Pointer ParentNode;
    var(UIStringNode) init Vector2D Extent;
    var(UIStringNode) init Vector2D Scaling;
    var const transient init UIDataStore NodeDataStore;
    var init bool bForceWrap;
    
    structdefaultproperties
    {
        Scaling = {X = 1.0, Y = 1.0}
    }
};
struct native transient UIStringNodeModifier 
{
    struct native transient ModifierData 
    {
        var const transient init array<Font> InlineFontStack;
        var const transient init UIStyle_Data Style;
    };
    var const transient init array<ModifierData> ModifierStack;
    var const transient init UICombinedStyleData CustomStyleData;
    var const transient init UICombinedStyleData BaseStyleData;
    var const transient init UIState CurrentMenuState;
};
struct native transient UICombinedStyleData 
{
    var init UIImageAdjustmentData AdjustmentType[2];
    var init LinearColor TextColor;
    var init LinearColor ImageColor;
    var init TextureCoordinates AtlasCoords;
    var init float TextPadding[2];
    var init float ImagePadding[2];
    var init TextAutoScaleValue TextAutoScaling;
    var init Vector2D TextScale;
    var init Vector2D TextSpacingAdjust;
    var init Font DrawFont;
    var init Surface FallbackImage;
    var init UITextAttributes TextAttributes;
    var const init bool bInitialized;
    var init EUIAlignment TextAlignment[2];
    var init ETextClipMode TextClipMode;
    var init EUIAlignment TextClipAlignment;
    
    structdefaultproperties
    {
        TextScale = {X = 1.0, Y = 1.0}
        TextClipMode = None
    }
};
struct native UIImageStyleOverride extends UIStyleOverride 
{
    var(UIImageStyleOverride) UIImageAdjustmentData Formatting[2];
    var(UIImageStyleOverride) TextureCoordinates Coordinates;
    var bool bOverrideCoordinates;
    var bool bOverrideFormatting;
    
    structdefaultproperties
    {
        Formatting[0] = {
                         ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                         Alignment = EUIAlignment.UIALIGN_Left
                        }
        Formatting[1] = {
                         ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                         ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                         AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                         Alignment = EUIAlignment.UIALIGN_Left
                        }
        DrawColor = {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
        Opacity = 0.0
    }
};
struct native UITextStyleOverride extends UIStyleOverride 
{
    var(UITextStyleOverride) TextAutoScaleValue AutoScaling;
    var(UITextStyleOverride) float DrawScale[2];
    var(UITextStyleOverride) float SpacingAdjust[2];
    var(UITextStyleOverride) Font DrawFont;
    var(UITextStyleOverride) UITextAttributes TextAttributes;
    var bool bOverrideDrawFont;
    var bool bOverrideAttributes;
    var bool bOverrideAlignment;
    var bool bOverrideClipMode;
    var bool bOverrideClipAlignment;
    var bool bOverrideAutoScale;
    var bool bOverrideScale;
    var bool bOverrideSpacingAdjust;
    var(UITextStyleOverride) EUIAlignment TextAlignment[2];
    var(UITextStyleOverride) ETextClipMode ClipMode;
    var(UITextStyleOverride) EUIAlignment ClipAlignment;
    
    structdefaultproperties
    {
        AutoScaling = {MinScale = 0.600000024, AutoScaleMode = ETextAutoScaleMode.UIAUTOSCALE_None}
        DrawScale[0] = 1.0
        DrawScale[1] = 1.0
        DrawColor = {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
        Opacity = 0.0
    }
};
struct native UIStyleOverride 
{
    var(UIStyleOverride) LinearColor DrawColor;
    var(UIStyleOverride) float Padding[2];
    var(UIStyleOverride) float Opacity;
    var bool bOverrideDrawColor;
    var bool bOverrideOpacity;
    var bool bOverridePadding;
    
    structdefaultproperties
    {
        DrawColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
        Opacity = 1.0
    }
};
struct native TextAutoScaleValue 
{
    var(TextAutoScaleValue) float MinScale;
    var(TextAutoScaleValue) ETextAutoScaleMode AutoScaleMode;
    
    structdefaultproperties
    {
        MinScale = 0.600000024
    }
};
struct native transient RenderParameters 
{
    var init TextureCoordinates DrawCoords;
    var init LinearColor OverideDrawColor;
    var init Vector2D Scaling;
    var init Vector2D ImageExtent;
    var init Vector2D SpacingAdjust;
    var init float DrawX;
    var init float DrawY;
    var init float DrawXL;
    var init float DrawYL;
    var init Font DrawFont;
    var init float ViewportHeight;
    var init bool bUseOverrideColor;
    var init EUIAlignment TextAlignment[2];
};
struct native UIStringCaretParameters 
{
    var(UIStringCaretParameters) Name CaretStyle;
    var(UIStringCaretParameters) float CaretWidth;
    var transient int CaretPosition;
    var transient MaterialInterface CaretMaterial;
    var(UIStringCaretParameters) bool bDisplayCaret;
    var(UIStringCaretParameters) EUIDefaultPenColor CaretType;
    
    structdefaultproperties
    {
        CaretStyle = 'DefaultCaretStyle'
        CaretWidth = 1.0
    }
};
struct native UIImageAdjustmentData 
{
    var(UIImageAdjustmentData) UIScreenValue_Extent ProtectedRegion[2];
    var(UIImageAdjustmentData) EMaterialAdjustmentType AdjustmentType;
    var(UIImageAdjustmentData) EUIAlignment Alignment;
    
    structdefaultproperties
    {
        AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal
    }
};
struct native UITextAttributes 
{
    var(UITextAttributes) bool Bold;
    var(UITextAttributes) bool Italic;
    var(UITextAttributes) bool Underline;
    var(UITextAttributes) bool Shadow;
    var(UITextAttributes) bool Strikethrough;
};
struct native transient StyleReferenceId 
{
    var init Name StyleReferenceTag;
    var init Property StyleProperty;
};
struct native transient UIStyleSubscriberReference 
{
    var init Name SubscriberId;
    var init UIStyleResolver Subscriber;
};
struct native UIDataStoreBinding 
{
    var(UIDataStoreBinding) const string MarkupString;
    var const transient UIDataStoreSubscriber Subscriber;
    var const transient Name DataStoreName;
    var const transient Name DataStoreField;
    var const transient int BindingIndex;
    var const transient UIDataStore ResolvedDataStore;
    var(UIDataStoreBinding) const editconst EUIDataProviderFieldType RequiredFieldType;
    
    structdefaultproperties
    {
        BindingIndex = -1
        RequiredFieldType = None
    }
};
struct native UIRotation 
{
    var const transient Matrix TransformMatrix;
    var(UIRotation) const UIAnchorPosition AnchorPosition;
    var(UIRotation) const Rotator Rotation;
    var(UIRotation) ERotationAnchor AnchorType;
    
    structdefaultproperties
    {
        TransformMatrix = {
                           XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                           YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                           ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                           WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
                          }
        AnchorPosition = {ZDepth = 0.0, Value[0] = 0.0, Value[1] = 0.0, ScaleType[0] = EPositionEvalType.EVALPOS_PixelOwner, ScaleType[1] = EPositionEvalType.EVALPOS_PixelOwner}
        AnchorType = ERotationAnchor.RA_Center
    }
};
struct native UIDockingNode 
{
    var(UIDockingNode) UIObject Widget;
    var(UIDockingNode) EUIWidgetFace Face;
};
struct native UIDockingSet 
{
    var(UIDockingSet) editconst UIScreenValue_DockPadding DockPadding;
    var(UIDockingSet) editconst UIObject TargetWidget[4];
    var const UIObject OwnerWidget;
    var(UIDockingSet) bool bLockWidthWhenDocked;
    var(UIDockingSet) bool bLockHeightWhenDocked;
    var(UIDockingSet) editconst EUIWidgetFace TargetFace[4];
    var transient byte bResolved[4];
    var transient byte bLinking[4];
    
    structdefaultproperties
    {
        TargetFace[0] = None
        TargetFace[1] = None
        TargetFace[2] = None
        TargetFace[3] = None
    }
};
struct native UINavigationData 
{
    var(UINavigationData) editconst transient UIObject NavigationTarget[4];
    var(UINavigationData) editconst UIObject ForcedNavigationTarget[4];
    var(UINavigationData) byte bNullOverride[4];
};
struct native UIFocusPropagationData 
{
    var(UIFocusPropagationData) const editconst transient UIObject FirstFocusTarget;
    var(UIFocusPropagationData) const editconst transient UIObject LastFocusTarget;
    var(UIFocusPropagationData) const editconst transient UIObject NextFocusTarget;
    var(UIFocusPropagationData) const editconst transient UIObject PrevFocusTarget;
    var transient bool bPendingReceiveFocus;
};
struct native transient PlayerInteractionData 
{
    var transient init UIObject FocusedControl;
    var transient init UIObject LastFocusedControl;
};
struct native StateInputKeyAction extends InputKeyAction 
{
    var(StateInputKeyAction) Class<UIState> Scope;
    
    structdefaultproperties
    {
        Scope = Class'UIState_Enabled'
        InputKeyState = EInputEvent.IE_Pressed
    }
};
struct native InputKeyAction 
{
    var array<SeqOpOutputInputLink> TriggeredOps;
    var(InputKeyAction) Name InputKeyName;
    var(InputKeyAction) EInputEvent InputKeyState;
    
    structdefaultproperties
    {
        InputKeyState = EInputEvent.IE_Released
    }
};
struct native DefaultEventSpecification 
{
    var Class<UIState> EventState;
    var UIEvent EventTemplate;
};
struct native transient InputEventSubscription 
{
    var init array<UIScreenObject> Subscribers;
    var init Name KeyName;
};
struct native UIRenderingSubregion 
{
    var(UIRenderingSubregion) UIScreenValue_Extent ClampRegionSize;
    var(UIRenderingSubregion) UIScreenValue_Extent ClampRegionOffset;
    var(UIRenderingSubregion) bool bSubregionEnabled;
    var(UIRenderingSubregion) EUIAlignment ClampRegionAlignment;
    
    structdefaultproperties
    {
        ClampRegionSize = {Value = 1.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Horizontal}
        ClampRegionOffset = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Horizontal}
        ClampRegionAlignment = EUIAlignment.UIALIGN_Default
    }
};
struct native AutoSizeData 
{
    var(AutoSizeData) UIScreenValue_AutoSizeRegion Extent;
    var(AutoSizeData) AutoSizePadding Padding;
    var(AutoSizeData) bool bAutoSizeEnabled;
};
struct native AutoSizePadding extends UIScreenValue_AutoSizeRegion 
{
};
struct native UIScreenValue_AutoSizeRegion 
{
    var(UIScreenValue_AutoSizeRegion) float Value[2];
    var(UIScreenValue_AutoSizeRegion) EUIExtentEvalType EvalType[2];
};
struct native UIScreenValue_DockPadding 
{
    var(UIScreenValue_DockPadding) editconst float PaddingValue[4];
    var(UIScreenValue_DockPadding) editconst EUIDockPaddingEvalType PaddingScaleType[4];
};
struct native ScreenPositionRange extends UIScreenValue_Position 
{
    
    structdefaultproperties
    {
        ScaleType[0] = EPositionEvalType.EVALPOS_None
        ScaleType[1] = EPositionEvalType.EVALPOS_None
    }
};
struct native UIAnchorPosition extends UIScreenValue_Position 
{
    var(UIAnchorPosition) float ZDepth;
    
    structdefaultproperties
    {
        ScaleType[0] = EPositionEvalType.EVALPOS_None
        ScaleType[1] = EPositionEvalType.EVALPOS_None
    }
};
struct native UIScreenValue_Bounds 
{
    var(UIScreenValue_Bounds) editconst float Value[4];
    var(UIScreenValue_Bounds) editconst EPositionEvalType ScaleType[4];
    var transient byte bInvalidated[4];
    var(UIScreenValue_Bounds) EUIAspectRatioConstraint AspectRatioMode;
    
    structdefaultproperties
    {
        Value[2] = 1.0
        Value[3] = 1.0
        ScaleType[0] = EPositionEvalType.EVALPOS_PercentageOwner
        ScaleType[1] = EPositionEvalType.EVALPOS_PercentageOwner
        ScaleType[2] = EPositionEvalType.EVALPOS_PercentageOwner
        ScaleType[3] = EPositionEvalType.EVALPOS_PercentageOwner
        bInvalidated[0] = 1
        bInvalidated[1] = 1
        bInvalidated[2] = 1
        bInvalidated[3] = 1
    }
};
struct native UIScreenValue_Position 
{
    var(UIScreenValue_Position) float Value[2];
    var(UIScreenValue_Position) EPositionEvalType ScaleType[2];
    
    structdefaultproperties
    {
        ScaleType[0] = EPositionEvalType.EVALPOS_PixelOwner
        ScaleType[1] = EPositionEvalType.EVALPOS_PixelOwner
    }
};
struct native UIScreenValue_Extent 
{
    var(UIScreenValue_Extent) float Value;
    var(UIScreenValue_Extent) EUIExtentEvalType ScaleType;
    var(UIScreenValue_Extent) EUIOrientation Orientation;
};
struct native UIScreenValue 
{
    var(UIScreenValue) float Value;
    var(UIScreenValue) EPositionEvalType ScaleType;
    var(UIScreenValue) EUIOrientation Orientation;
    
    structdefaultproperties
    {
        ScaleType = EPositionEvalType.EVALPOS_PixelViewport
    }
};
const MAX_SUPPORTED_GAMEPADS = 4;
const SCENE_DATASTORE_TAG = 'SceneData';
const DEFAULT_SIZE_Y = 768;
const DEFAULT_SIZE_X = 1024;
struct native UIStyleReference 
{
    var const Class<UIStyle_Data> RequiredStyleClass;
    var const STYLE_ID AssignedStyleID;
    var Name DefaultStyleTag;
    var const transient UIStyle ResolvedStyle;
};
struct native UIProviderFieldValue extends UIProviderScriptFieldValue 
{
    var const transient native Pointer CustomStringNode;
};
struct native UIProviderScriptFieldValue 
{
    var UniqueNetId NetIdValue;
    var string StringValue;
    var array<int> ArrayValue;
    var UIRangeData RangeValue;
    var TextureCoordinates AtlasCoordinates;
    var Name PropertyTag;
    var Surface ImageValue;
    var EUIDataProviderFieldType PropertyType;
};
struct native TextureCoordinates 
{
    var(TextureCoordinates) float U;
    var(TextureCoordinates) float V;
    var(TextureCoordinates) float UL;
    var(TextureCoordinates) float VL;
};
struct native UIRangeData 
{
    var(Range) float CurrentValue;
    var(Range) float MinValue;
    var(Range) float MaxValue;
    var(Range) float NudgeValue;
    var(Range) bool bIntRange;
};
struct native atomic STYLE_ID extends Guid 
{
};
struct native atomic WIDGET_ID extends Guid 
{
};
enum EUIPostProcessGroup
{
    UIPostProcess_None,
    UIPostProcess_Background,
    UIPostProcess_Foreground,
    UIPostProcess_BackgroundAndForeground,
    UIPostProcess_Dynamic,
};
enum EInputPlatformType
{
    IPT_PC,
    IPT_360,
    IPT_PS3,
};
enum ERotationAnchor
{
    RA_Absolute,
    RA_Center,
    RA_PivotLeft,
    RA_PivotRight,
    RA_PivotTop,
    RA_PivotBottom,
    RA_UpperLeft,
    RA_UpperRight,
    RA_LowerLeft,
    RA_LowerRight,
};
enum EEditBoxCharacterSet
{
    CHARSET_All,
    CHARSET_NoSpecial,
    CHARSET_AlphaOnly,
    CHARSET_NumericOnly,
    CHARSET_AlphaNumeric,
};
enum EUIDataProviderFieldType
{
    DATATYPE_Property,
    DATATYPE_Provider,
    DATATYPE_RangeProperty,
    DATATYPE_NetIdProperty,
    DATATYPE_Collection,
    DATATYPE_ProviderCollection,
};
enum ESplitscreenRenderMode
{
    SPLITRENDER_Fullscreen,
    SPLITRENDER_PlayerOwner,
};
enum EScreenInputMode
{
    INPUTMODE_None,
    INPUTMODE_Locked,
    INPUTMODE_Selective,
    INPUTMODE_MatchingOnly,
    INPUTMODE_ActiveOnly,
    INPUTMODE_Free,
    INPUTMODE_Simultaneous,
};
enum ENavigationLinkType
{
    NAVLINK_Automatic,
    NAVLINK_Manual,
};
enum EUIDefaultPenColor
{
    UIPEN_White,
    UIPEN_Black,
    UIPEN_Grey,
};
enum EUIAspectRatioConstraint
{
    UIASPECTRATIO_AdjustNone,
    UIASPECTRATIO_AdjustWidth,
    UIASPECTRATIO_AdjustHeight,
};
enum EUIWidgetFace
{
    UIFACE_Left,
    UIFACE_Top,
    UIFACE_Right,
    UIFACE_Bottom,
};
enum EUIOrientation
{
    UIORIENT_Horizontal,
    UIORIENT_Vertical,
};
enum EColumnHeaderState
{
    COLUMNHEADER_Normal,
    COLUMNHEADER_PrimarySort,
    COLUMNHEADER_SecondarySort,
};
enum EUIListElementState
{
    ELEMENT_Normal,
    ELEMENT_Active,
    ELEMENT_Selected,
    ELEMENT_UnderCursor,
};
enum EUIAlignment
{
    UIALIGN_Left,
    UIALIGN_Center,
    UIALIGN_Right,
    UIALIGN_Default,
};
enum ETextAutoScaleMode
{
    UIAUTOSCALE_None,
    UIAUTOSCALE_Normal,
    UIAUTOSCALE_Justified,
    UIAUTOSCALE_ResolutionBased,
};
enum ETextClipMode
{
    CLIP_None,
    CLIP_Normal,
    CLIP_Ellipsis,
    CLIP_Wrap,
};
enum EUIAutoSizeConstraintType
{
    UIAUTOSIZEREGION_Minimum,
    UIAUTOSIZEREGION_Maximum,
};
enum EUIDockPaddingEvalType
{
    UIPADDINGEVAL_Pixels,
    UIPADDINGEVAL_PercentTarget,
    UIPADDINGEVAL_PercentOwner,
    UIPADDINGEVAL_PercentScene,
    UIPADDINGEVAL_PercentViewport,
};
enum EUIExtentEvalType
{
    UIEXTENTEVAL_Pixels,
    UIEXTENTEVAL_PercentSelf,
    UIEXTENTEVAL_PercentOwner,
    UIEXTENTEVAL_PercentScene,
    UIEXTENTEVAL_PercentViewport,
};
enum EPositionEvalType
{
    EVALPOS_None,
    EVALPOS_PixelViewport,
    EVALPOS_PixelScene,
    EVALPOS_PixelOwner,
    EVALPOS_PercentageViewport,
    EVALPOS_PercentageOwner,
    EVALPOS_PercentageScene,
};
enum EMaterialAdjustmentType
{
    ADJUST_None,
    ADJUST_Normal,
    ADJUST_Justified,
    ADJUST_Bound,
    ADJUST_Stretch,
};
const PRIVATE_Protected = 0x380;
const PRIVATE_KeepFocusedState = 0x800;
const PRIVATE_PropagateState = 0x400;
const PRIVATE_EditorNoReparent = 0x200;
const PRIVATE_EditorNoRename = 0x100;
const PRIVATE_EditorNoDelete = 0x080;
const PRIVATE_TreeHiddenRecursive = 0x042;
const PRIVATE_ManagedStyle = 0x020;
const PRIVATE_NotRotatable = 0x010;
const PRIVATE_NotDockable = 0x008;
const PRIVATE_NotFocusable = 0x004;
const PRIVATE_TreeHidden = 0x002;
const PRIVATE_NotEditorSelectable = 0x001;
const DEFAULT_SCENE_PRIORITY = 10;
const TEMP_SPLITSCREEN_INDEX = 0;

public static final native function UIInteraction GetCurrentUIController();

public static final native function bool GetCursorPosition(out int CursorX, out int CursorY, optional const UIScene Scene);

public static final native function bool GetCursorSize(out float CursorXL, out float CursorYL);

public static final native function bool GetDataStoreFieldValue(string InDataStoreMarkup, out UIProviderFieldValue OutFieldValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer);

public static final native function EUIOrientation GetFaceOrientation(EUIWidgetFace Face);

public static final native function EInputPlatformType GetInputPlatformType(optional LocalPlayer OwningPlayer);

public static final native function Matrix GetPrimitiveTransform(UIObject Widget, optional bool bIncludeAnchorPosition, optional bool bIncudeRotation = TRUE, optional bool bIncludeScale = TRUE);

public static final native function GameUISceneClient GetSceneClient();

public static final function bool IsConsole(optional EConsoleType ConsoleType = 0)
{
    return Class'WorldInfo'.static.IsConsoleBuild(ConsoleType);
}
public static final function bool IsEditor()
{
    return GetCurrentUIController() == None;
}
public static final native function bool SetDataStoreFieldValue(string InDataStoreMarkup, const out UIProviderFieldValue InFieldValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer);

public static final native function SetMouseCaptureOverride(bool bCaptureMouse);

public static function bool GetDataStoreStringValue(string InDataStoreMarkup, out string OutStringValue, optional UIScene OwnerScene = None, optional LocalPlayer OwnerPlayer = None)
{
    local UIProviderFieldValue FieldValue;
    local bool Result;
    
    if (GetDataStoreFieldValue(InDataStoreMarkup, FieldValue, OwnerScene, OwnerPlayer))
    {
        OutStringValue = FieldValue.StringValue;
        Result = TRUE;
    }
    return Result;
}
public static function bool SetDataStoreStringValue(string InDataStoreMarkup, string InStringValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer)
{
    local UIProviderFieldValue FieldValue;
    
    FieldValue.StringValue = InStringValue;
    FieldValue.PropertyType = EUIDataProviderFieldType.DATATYPE_Property;
    return SetDataStoreFieldValue(InDataStoreMarkup, FieldValue, OwnerScene, OwnerPlayer);
}
public static final function string ConvertWidgetIDToString(UIObject SourceWidget)
{
    local string Result;
    
    if (SourceWidget != None)
    {
        Result = ToHex(SourceWidget.WidgetID.A) $ ToHex(SourceWidget.WidgetID.B) $ ToHex(SourceWidget.WidgetID.C) $ ToHex(SourceWidget.WidgetID.D);
    }
    return Result;
}
public static final function OnlineGameInterface GetOnlineGameInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface Result;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        Result = OnlineSub.GameInterface;
    }
    return Result;
}
public static final function OnlinePlayerInterface GetOnlinePlayerInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface Result;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        Result = OnlineSub.PlayerInterface;
    }
    return Result;
}
public static final function OnlinePlayerInterfaceEx GetOnlinePlayerInterfaceEx()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    }
    return PlayerIntEx;
}
public static final function UIDataStore StaticResolveDataStore(Name DataStoreTag, optional UIScene OwnerScene, optional LocalPlayer InPlayerOwner)
{
    local UIDataStore Result;
    local DataStoreClient DSClient;
    
    if (OwnerScene != None)
    {
        Result = OwnerScene.ResolveDataStore(DataStoreTag, InPlayerOwner);
    }
    else
    {
        DSClient = Class'UIInteraction'.static.GetDataStoreClient();
        if (DSClient != None)
        {
            Result = DSClient.FindDataStore(DataStoreTag, InPlayerOwner);
        }
    }
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}