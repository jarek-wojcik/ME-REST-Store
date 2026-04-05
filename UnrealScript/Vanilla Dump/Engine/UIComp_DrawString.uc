Class UIComp_DrawString extends UIComp_DrawComponents within UIObject
    implements(UIStyleResolver)
    native
    editinlinenew;

var const native noexport Pointer VfTable_IUIStyleResolver;
var UIStyleReference StringStyle;
var const transient Class<UIString> StringClass;
var(StyleOverride) UITextStyleOverride TextStyleCustomization;
var(Appearance) AutoSizeData AutoSizeParameters[2];
var(Appearance) UIRenderingSubregion ClampRegion[2];
var(Appearance) LinearColor DropShadowColor;
var transient UIDataStoreSubscriber SubscriberOwner;
var Name StyleResolverTag;
var(Appearance) Vector2D DropShadowOffset;
var transient UIString ValueString;
var(Appearance) bool bDropShadow;
var(Data) bool bIgnoreMarkup;
var(Appearance) bool bAllowBoundsAdjustment;
var(ZDebug) transient bool bRefreshString;
var transient bool bReapplyFormatting;

public final native function DisableCustomAlignment();

public final native function DisableCustomAttributes();

public final native function DisableCustomAutoScaling();

public final native function DisableCustomClipAlignment();

public final native function DisableCustomClipMode();

public final native function DisableCustomColor();

public final native function DisableCustomFont();

public final native function DisableCustomOpacity();

public final native function DisableCustomPadding();

public final native function DisableCustomScale();

public final native function DisableCustomSpacingAdjust();

public final event function EnableAutoSizing(EUIOrientation Orientation, optional bool bShouldEnable = TRUE)
{
    local bool bNeedsReformatting;
    
    bNeedsReformatting = IsAutoSizeEnabled(Orientation) != bShouldEnable;
    AutoSizeParameters[int(Orientation)].bAutoSizeEnabled = bShouldEnable;
    bReapplyFormatting = bReapplyFormatting || bNeedsReformatting;
    if (bReapplyFormatting)
    {
        Outer.RequestSceneUpdate(TRUE, TRUE);
    }
}
public final native function EnableSubregion(EUIOrientation Orientation, optional bool bShouldEnable = TRUE);

public final native function UIStyle_Combo GetAppliedStringStyle(optional UIState DesiredMenuState);

public final native function bool GetFinalStringStyle(out UICombinedStyleData FinalStyleData);

public final native function Name GetStyleResolverTag();

public final native function EUIAlignment GetSubregionAlignment(EUIOrientation Orientation);

public final native function float GetSubregionOffset(EUIOrientation Orientation, optional EUIExtentEvalType OutputType = 0);

public final native function float GetSubregionSize(EUIOrientation Orientation, optional EUIExtentEvalType OutputType = 0);

public final native function string GetValue(optional bool bReturnProcessedText = TRUE);

public final native function ETextClipMode GetWrapMode();

public final native function bool IsSubregionEnabled(EUIOrientation Orientation);

public final native function bool NotifyResolveStyle(UISkin ActiveSkin, bool bClearExistingValue, optional UIState CurrentMenuState, optional const Name StylePropertyName);

public final native function RefreshValue();

public final native function SetAlignment(EUIOrientation Orientation, EUIAlignment NewAlignment);

public final native function SetAttributes(UITextAttributes NewAttributes);

public final native function SetAutoScaling(ETextAutoScaleMode NewAutoScaleMode, optional float NewMinScaleValue = -1.0);

public final native function SetAutoSizeExtent(EUIOrientation Orientation, float MinValue, float MaxValue, EUIExtentEvalType MinScaleType, EUIExtentEvalType MaxScaleType);

public final event function SetAutoSizePadding(EUIOrientation Orientation, float NearValue, float FarValue, EUIExtentEvalType NearScaleType, EUIExtentEvalType FarScaleType)
{
    local bool bNeedsReformatting;
    
    bNeedsReformatting = AutoSizeParameters[int(Orientation)].Padding.Value[0] != NearValue || AutoSizeParameters[int(Orientation)].Padding.Value[1] != FarValue || int(AutoSizeParameters[int(Orientation)].Padding.EvalType[0]) != int(NearScaleType) || int(AutoSizeParameters[int(Orientation)].Padding.EvalType[1]) != int(FarScaleType);
    AutoSizeParameters[int(Orientation)].Padding.Value[0] = NearValue;
    AutoSizeParameters[int(Orientation)].Padding.Value[1] = FarValue;
    AutoSizeParameters[int(Orientation)].Padding.EvalType[0] = NearScaleType;
    AutoSizeParameters[int(Orientation)].Padding.EvalType[1] = FarScaleType;
    bReapplyFormatting = bReapplyFormatting || bNeedsReformatting;
    if (bReapplyFormatting)
    {
        Outer.RequestSceneUpdate(FALSE, TRUE);
    }
}
public final native function SetClipAlignment(EUIAlignment NewClipAlignment);

public final native function SetColor(LinearColor NewColor);

public final native function SetFont(Font NewFont);

public final native function SetOpacity(float NewOpacity);

public final native function SetPadding(float HorizontalPadding, float VerticalPadding);

public final native function SetScale(EUIOrientation Orientation, float NewScale);

public final native function SetSpacingAdjust(EUIOrientation Orientation, float NewSpacingAdjust);

public final native function bool SetStyleResolverTag(Name NewResolverTag);

public final native function SetSubregionAlignment(EUIOrientation Orientation, EUIAlignment NewValue);

public final native function SetSubregionOffset(EUIOrientation Orientation, float NewValue, EUIExtentEvalType EvalType);

public final native function SetSubregionSize(EUIOrientation Orientation, float NewValue, EUIExtentEvalType EvalType);

public final native function SetValue(string NewText);

public final native function SetWrapMode(ETextClipMode NewClipMode);

public final function bool IsAutoSizeEnabled(EUIOrientation Orientation)
{
    return AutoSizeParameters[int(Orientation)].bAutoSizeEnabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StringStyle = {
                   RequiredStyleClass = Class'UIStyle_Combo', 
                   AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                   DefaultStyleTag = 'DefaultComboStyle', 
                   ResolvedStyle = None
                  }
    StringClass = Class'UIString'
    TextStyleCustomization = {
                              AutoScaling = {MinScale = 0.600000024, AutoScaleMode = ETextAutoScaleMode.UIAUTOSCALE_None}, 
                              DrawScale[0] = 1.0, 
                              DrawScale[1] = 1.0, 
                              SpacingAdjust[0] = 0.0, 
                              SpacingAdjust[1] = 0.0, 
                              DrawFont = None, 
                              TextAttributes = {Bold = FALSE, Italic = FALSE, Underline = FALSE, Shadow = FALSE, Strikethrough = FALSE}, 
                              bOverrideDrawFont = FALSE, 
                              bOverrideAttributes = FALSE, 
                              bOverrideAlignment = FALSE, 
                              bOverrideClipMode = FALSE, 
                              bOverrideClipAlignment = FALSE, 
                              bOverrideAutoScale = FALSE, 
                              bOverrideScale = FALSE, 
                              bOverrideSpacingAdjust = FALSE, 
                              TextAlignment[0] = EUIAlignment.UIALIGN_Left, 
                              TextAlignment[1] = EUIAlignment.UIALIGN_Left, 
                              ClipMode = ETextClipMode.CLIP_None, 
                              ClipAlignment = EUIAlignment.UIALIGN_Left, 
                              DrawColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}, 
                              Padding[0] = 0.0, 
                              Padding[1] = 0.0, 
                              Opacity = 1.0, 
                              bOverrideDrawColor = FALSE, 
                              bOverrideOpacity = FALSE, 
                              bOverridePadding = FALSE
                             }
    ClampRegion[0] = {
                      ClampRegionSize = {Value = 1.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                      ClampRegionOffset = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                      bSubregionEnabled = FALSE, 
                      ClampRegionAlignment = EUIAlignment.UIALIGN_Default
                     }
    ClampRegion[1] = {
                      ClampRegionSize = {Value = 1.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                      ClampRegionOffset = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentSelf, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                      bSubregionEnabled = FALSE, 
                      ClampRegionAlignment = EUIAlignment.UIALIGN_Default
                     }
    DropShadowColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    StyleResolverTag = 'String Style'
    DropShadowOffset = {X = 2.0, Y = 2.0}
    bAllowBoundsAdjustment = TRUE
}