Class UIComp_DrawImage extends UIComp_DrawComponents within UIObject
    implements(UIStyleResolver, CustomPropertyItemHandler)
    native
    editinlinenew;

var const native noexport Pointer VfTable_IUIStyleResolver;
var const native noexport Pointer VfTable_ICustomPropertyItemHandler;
var UIStyleReference ImageStyle;
var(StyleOverride) UIImageStyleOverride StyleCustomization;
var Name StyleResolverTag;
var(StyleOverride) export editinlineuse UITexture ImageRef;

public final native function DisableCustomColor();

public final native function DisableCustomCoordinates();

public final native function DisableCustomFormatting();

public final native function DisableCustomOpacity();

public final native function DisableCustomPadding();

public final native function UIStyle_Image GetAppliedImageStyle(optional UIState DesiredMenuState);

public final native function Surface GetImage();

public final native function Name GetStyleResolverTag();

public final native function bool NotifyResolveStyle(UISkin ActiveSkin, bool bClearExistingValue, optional UIState CurrentMenuState, optional const Name StylePropertyName);

public final native function SetColor(LinearColor NewColor);

public final native function SetCoordinates(TextureCoordinates NewCoordinates);

public final native function SetFormatting(EUIOrientation Orientation, UIImageAdjustmentData NewFormattingData);

public final native function SetImage(Surface NewImage);

public final native function SetOpacity(float NewOpacity);

public final native function SetPadding(float HorizontalPadding, float VerticalPadding);

public final native function bool SetStyleResolverTag(Name NewResolverTag);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ImageStyle = {
                  RequiredStyleClass = Class'UIStyle_Image', 
                  AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                  DefaultStyleTag = 'DefaultImageStyle', 
                  ResolvedStyle = None
                 }
    StyleCustomization = {
                          Formatting[0] = {
                                           ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                           ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                                           AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                                           Alignment = EUIAlignment.UIALIGN_Left
                                          }, 
                          Formatting[1] = {
                                           ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                                           ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}, 
                                           AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                                           Alignment = EUIAlignment.UIALIGN_Left
                                          }, 
                          Coordinates = {U = 0.0, V = 0.0, UL = 0.0, VL = 0.0}, 
                          bOverrideCoordinates = FALSE, 
                          bOverrideFormatting = FALSE, 
                          DrawColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}, 
                          Padding[0] = 0.0, 
                          Padding[1] = 0.0, 
                          Opacity = 1.0, 
                          bOverrideDrawColor = FALSE, 
                          bOverrideOpacity = FALSE, 
                          bOverridePadding = FALSE
                         }
    StyleResolverTag = 'Image Style'
}