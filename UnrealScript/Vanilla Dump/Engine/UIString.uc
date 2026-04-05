Class UIString extends UIRoot within UIScreenObject
    native
    transient;

var transient native array<Pointer> Nodes;
var transient UICombinedStyleData StringStyleData;
var transient Vector2D StringExtent;

public final native function bool ContainsMarkup();

public final native function GetAutoScaleValue(Vector2D BoundingRegionSize, Vector2D StringSize, out Vector2D out_AutoScalePercent);

public final native function string GetValue(optional bool bReturnProcessedText = TRUE);

public final native function bool SetValue(string InputString, bool bIgnoreMarkup);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StringStyleData = {
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
                       TextClipMode = ETextClipMode.CLIP_Normal, 
                       TextClipAlignment = EUIAlignment.UIALIGN_Left
                      }
}