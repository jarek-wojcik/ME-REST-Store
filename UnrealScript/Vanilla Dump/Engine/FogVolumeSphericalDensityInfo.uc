Class FogVolumeSphericalDensityInfo extends FogVolumeDensityInfo
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=FogVolumeSphericalDensityComponent Name=FogVolumeComponent0
    End Object
    Begin Template Class=StaticMeshComponent Name=AutomaticMeshComponent0
        StaticMesh = StaticMesh'EngineMeshes.Sphere'
        ReplacementPrimitive = None
        CollideActors = FALSE
    End Template
    DensityComponent = FogVolumeComponent0
    AutomaticMeshComponent = AutomaticMeshComponent0
    Components = (None, AutomaticMeshComponent0, None, FogVolumeComponent0)
}