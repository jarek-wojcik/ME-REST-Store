Class UIStyle_Text extends UIStyle_Data
    native;

var TextAutoScaleValue AutoScaling;
var Vector2D Scale;
var Vector2D SpacingAdjust;
var Font StyleFont;
var UITextAttributes Attributes;
var EUIAlignment Alignment[2];
var ETextClipMode ClipMode;
var EUIAlignment ClipAlignment;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AutoScaling = {MinScale = 0.600000024, AutoScaleMode = ETextAutoScaleMode.UIAUTOSCALE_None}
    Scale = {X = 1.0, Y = 1.0}
    StyleFont = Font'EngineFonts.SmallFont'
    Alignment[1] = EUIAlignment.UIALIGN_Center
}