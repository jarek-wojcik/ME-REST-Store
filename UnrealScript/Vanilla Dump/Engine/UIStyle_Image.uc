Class UIStyle_Image extends UIStyle_Data
    native;

var(UIStyle_Image) UIImageAdjustmentData AdjustmentType[2];
var(UIStyle_Image) TextureCoordinates Coordinates;
var(UIStyle_Image) Surface DefaultImage;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AdjustmentType[0] = {
                         ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                         Alignment = EUIAlignment.UIALIGN_Left
                        }
    AdjustmentType[1] = {
                         ProtectedRegion[0] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         ProtectedRegion[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}, 
                         AdjustmentType = EMaterialAdjustmentType.ADJUST_Normal, 
                         Alignment = EUIAlignment.UIALIGN_Left
                        }
    DefaultImage = Texture2D'EngineResources.DefaultTexture'
}