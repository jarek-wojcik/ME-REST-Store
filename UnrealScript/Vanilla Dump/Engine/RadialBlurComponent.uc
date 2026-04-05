Class RadialBlurComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories;

var const transient native Matrix LocalToWorld;
var(RadialBlurComponent) const MaterialInterface Material;
var(RadialBlurComponent) const interp float BlurScale;
var(RadialBlurComponent) const interp float BlurFalloffExponent;
var(RadialBlurComponent) const interp float BlurOpacity;
var(RadialBlurComponent) const float MaxCullDistance;
var(RadialBlurComponent) const float DistanceFalloffExponent;
var(RadialBlurComponent) const bool bRenderAsVelocity;
var(RadialBlurComponent) const bool bEnabled;
var(RadialBlurComponent) const ESceneDepthPriorityGroup DepthPriorityGroup;

public native function SetBlurFalloffExponent(float InBlurFalloffExponent);

public native function SetBlurOpacity(float InBlurOpacity);

public native function SetBlurScale(float InBlurScale);

public native function SetEnabled(bool bInEnabled);

public native function SetMaterial(MaterialInterface InMaterial);

public function OnUpdatePropertyBlurFalloffExponent()
{
    SetBlurFalloffExponent(BlurFalloffExponent);
}
public function OnUpdatePropertyBlurOpacity()
{
    SetBlurOpacity(BlurOpacity);
}
public function OnUpdatePropertyBlurScale()
{
    SetBlurScale(BlurScale);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlurScale = 1.0
    BlurFalloffExponent = 1.5
    BlurOpacity = 1.0
    MaxCullDistance = 2000.0
    DistanceFalloffExponent = 1.5
    bEnabled = TRUE
    DepthPriorityGroup = ESceneDepthPriorityGroup.SDPG_Foreground
}