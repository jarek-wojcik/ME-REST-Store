Class UITexture extends UIRoot
    native
    editinlinenew;

var transient UICombinedStyleData ImageStyleData;
var Surface ImageTexture;

public final native function UIScreenObject GetOwnerWidget(optional out UIComponent OwnerComponent);

public final native function bool HasValidStyleData();

public final native function SetImageStyle(UIStyle_Image NewImageStyle);

public final function Surface GetSurface()
{
    return ImageTexture;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ImageStyleData = {
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
}