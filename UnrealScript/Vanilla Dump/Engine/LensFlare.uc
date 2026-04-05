Class LensFlare
    native;

struct native LensFlareElement 
{
    var(Material) editinline RawDistributionFloat LFMaterialIndex;
    var(Scaling) editinline RawDistributionFloat Scaling;
    var(Scaling) editinline RawDistributionVector AxisScaling;
    var(Rotation) editinline RawDistributionFloat Rotation;
    var(Color) editinline RawDistributionVector Color;
    var(Color) editinline RawDistributionFloat Alpha;
    var(Offset) editinline RawDistributionVector Offset;
    var(Scaling) editinline RawDistributionVector DistMap_Scale;
    var(Scaling) editinline RawDistributionVector DistMap_Color;
    var(Scaling) editinline RawDistributionFloat DistMap_Alpha;
    var(Material) array<MaterialInterface> LFMaterials;
    var(LensFlareElement) Vector Size;
    var(LensFlareElement) Name ElementName;
    var(LensFlareElement) float RayDistance;
    var(LensFlareElement) bool bIsEnabled;
    var(LensFlareElement) bool bUseSourceDistance;
    var(LensFlareElement) bool bNormalizeRadialDistance;
    var(LensFlareElement) bool bModulateColorBySource;
};
struct native transient LensFlareElementCurvePair 
{
    var init string CurveName;
    var init Object CurveObject;
};

var editinline export LensFlareElement SourceElement;
var(Occlusion) editinline RawDistributionFloat ScreenPercentageMap;
var editinline export array<LensFlareElement> Reflections;
var(Bounds) Box FixedRelativeBoundingBox;
var Rotator ThumbnailAngle;
var(Source) StaticMesh SourceMesh;
var(Visibility) float OuterCone;
var(Visibility) float InnerCone;
var(Visibility) float ConeFudgeFactor;
var(Visibility) float Radius;
var export InterpCurveEdSetup CurveEdSetup;
var transient int ReflectionCount;
var float ThumbnailDistance;
var Texture2D ThumbnailImage;
var(Bounds) bool bUseFixedRelativeBoundingBox;
var(Debug) bool bRenderDebugLines;
var bool ThumbnailImageOutOfDate;
var(Source) const ESceneDepthPriorityGroup SourceDPG;
var(Reflections) const ESceneDepthPriorityGroup ReflectionsDPG;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlpha
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionDistMap_Alpha
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionLFMaterialIndex
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionRotation
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionScaling
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionScreenPercentageMap
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionAxisScaling
        Constant = {X = 1.0, Y = 1.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionColor
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionDistMap_Color
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionDistMap_Scale
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionOffset
    End Object
    SourceElement = {
                     LFMaterialIndex = {
                                        Distribution = DistributionLFMaterialIndex, 
                                        Type = 0, 
                                        Op = 1, 
                                        LookupTableNumElements = 1, 
                                        LookupTableChunkSize = 1, 
                                        LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                        LookupTableTimeScale = 0.0, 
                                        LookupTableStartTime = 0.0
                                       }, 
                     Scaling = {
                                Distribution = DistributionScaling, 
                                Type = 0, 
                                Op = 1, 
                                LookupTableNumElements = 1, 
                                LookupTableChunkSize = 1, 
                                LookupTable = (1.0, 1.0, 1.0, 1.0), 
                                LookupTableTimeScale = 0.0, 
                                LookupTableStartTime = 0.0
                               }, 
                     AxisScaling = {
                                    Distribution = DistributionAxisScaling, 
                                    Type = 0, 
                                    Op = 1, 
                                    LookupTableNumElements = 1, 
                                    LookupTableChunkSize = 3, 
                                    LookupTable = (0.0, 
                                                   1.0, 
                                                   1.0, 
                                                   1.0, 
                                                   0.0, 
                                                   1.0, 
                                                   1.0, 
                                                   0.0
                                                  ), 
                                    LookupTableTimeScale = 0.0, 
                                    LookupTableStartTime = 0.0
                                   }, 
                     Rotation = {
                                 Distribution = DistributionRotation, 
                                 Type = 0, 
                                 Op = 1, 
                                 LookupTableNumElements = 1, 
                                 LookupTableChunkSize = 1, 
                                 LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                 LookupTableTimeScale = 0.0, 
                                 LookupTableStartTime = 0.0
                                }, 
                     Color = {
                              Distribution = DistributionColor, 
                              Type = 0, 
                              Op = 1, 
                              LookupTableNumElements = 1, 
                              LookupTableChunkSize = 3, 
                              LookupTable = (1.0, 
                                             1.0, 
                                             1.0, 
                                             1.0, 
                                             1.0, 
                                             1.0, 
                                             1.0, 
                                             1.0
                                            ), 
                              LookupTableTimeScale = 0.0, 
                              LookupTableStartTime = 0.0
                             }, 
                     Alpha = {
                              Distribution = DistributionAlpha, 
                              Type = 0, 
                              Op = 1, 
                              LookupTableNumElements = 1, 
                              LookupTableChunkSize = 1, 
                              LookupTable = (1.0, 1.0, 1.0, 1.0), 
                              LookupTableTimeScale = 0.0, 
                              LookupTableStartTime = 0.0
                             }, 
                     Offset = {
                               Distribution = DistributionOffset, 
                               Type = 0, 
                               Op = 1, 
                               LookupTableNumElements = 1, 
                               LookupTableChunkSize = 3, 
                               LookupTable = (0.0, 
                                              0.0, 
                                              0.0, 
                                              0.0, 
                                              0.0, 
                                              0.0, 
                                              0.0, 
                                              0.0
                                             ), 
                               LookupTableTimeScale = 0.0, 
                               LookupTableStartTime = 0.0
                              }, 
                     DistMap_Scale = {
                                      Distribution = DistributionDistMap_Scale, 
                                      Type = 0, 
                                      Op = 1, 
                                      LookupTableNumElements = 1, 
                                      LookupTableChunkSize = 3, 
                                      LookupTable = (1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0
                                                    ), 
                                      LookupTableTimeScale = 0.0, 
                                      LookupTableStartTime = 0.0
                                     }, 
                     DistMap_Color = {
                                      Distribution = DistributionDistMap_Color, 
                                      Type = 0, 
                                      Op = 1, 
                                      LookupTableNumElements = 1, 
                                      LookupTableChunkSize = 3, 
                                      LookupTable = (1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0, 
                                                     1.0
                                                    ), 
                                      LookupTableTimeScale = 0.0, 
                                      LookupTableStartTime = 0.0
                                     }, 
                     DistMap_Alpha = {
                                      Distribution = DistributionDistMap_Alpha, 
                                      Type = 0, 
                                      Op = 1, 
                                      LookupTableNumElements = 1, 
                                      LookupTableChunkSize = 1, 
                                      LookupTable = (1.0, 1.0, 1.0, 1.0), 
                                      LookupTableTimeScale = 0.0, 
                                      LookupTableStartTime = 0.0
                                     }, 
                     LFMaterials = (), 
                     Size = {X = 75.0, Y = 75.0, Z = 75.0}, 
                     ElementName = 'Source', 
                     RayDistance = 0.0, 
                     bIsEnabled = TRUE, 
                     bUseSourceDistance = FALSE, 
                     bNormalizeRadialDistance = FALSE, 
                     bModulateColorBySource = FALSE
                    }
    ScreenPercentageMap = {
                           Distribution = DistributionScreenPercentageMap, 
                           Type = 0, 
                           Op = 1, 
                           LookupTableNumElements = 1, 
                           LookupTableChunkSize = 1, 
                           LookupTable = (1.0, 1.0, 1.0, 1.0), 
                           LookupTableTimeScale = 0.0, 
                           LookupTableStartTime = 0.0
                          }
    ConeFudgeFactor = 0.5
    SourceDPG = ESceneDepthPriorityGroup.SDPG_World
    ReflectionsDPG = ESceneDepthPriorityGroup.SDPG_Foreground
}