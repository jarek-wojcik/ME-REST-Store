Class SFXLightProbeBlendVolume extends Volume
    native
    placeable;

var(SFXLightProbeBlendVolume) array<SFXLightProbe> LightProbes;

public event simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local BioDynamicLightEnvironmentComponent DLE;
    
    DLE = Class'BioDynamicLightEnvironmentComponent'.static.ScriptFindDLE(Other);
    if (DLE != None && DLE.bSupportsLightProbes)
    {
        DLE.TouchLightProbeBlendVolume(Self);
    }
    Super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
}
public event simulated function UnTouch(Actor Other)
{
    local BioDynamicLightEnvironmentComponent DLE;
    
    DLE = Class'BioDynamicLightEnvironmentComponent'.static.ScriptFindDLE(Other);
    if (DLE != None && DLE.bSupportsLightProbes)
    {
        DLE.UntouchLightProbeBlendVolume(Self);
    }
    Super(Actor).UnTouch(Other);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushColor = {B = 255, G = 32, R = 32, A = 255}
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}