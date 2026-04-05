Class LensFlareComponent extends PrimitiveComponent
    native
    editinlinenew;

struct LensFlareElementInstance 
{
};

var const native Pointer ReleaseResourcesFence;
var(Rendering) LinearColor SourceColor;
var(LensFlareComponent) const LensFlare Template;
var const editinline export DrawLightConeComponent PreviewInnerCone;
var const editinline export DrawLightConeComponent PreviewOuterCone;
var const editinline export DrawLightRadiusComponent PreviewRadius;
var transient float OuterCone;
var transient float InnerCone;
var transient float ConeFudgeFactor;
var transient float Radius;
var(LensFlareComponent) bool bAutoActivate;
var transient bool bIsActive;
var transient bool bHasTranslucency;
var transient bool bHasUnlitTranslucency;
var transient bool bHasUnlitDistortion;
var transient bool bUsesSceneColor;

public native function SetIsActive(bool bInIsActive);

public native function SetSourceColor(LinearColor InSourceColor);

public final native function SetTemplate(LensFlare NewTemplate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SourceColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
    bAutoActivate = TRUE
    ReplacementPrimitive = None
    bFirstFrameOcclusion = TRUE
    bIgnoreNearPlaneIntersection = TRUE
    bTickInEditor = TRUE
    TickGroup = ETickingGroup.TG_PostAsyncWork
}