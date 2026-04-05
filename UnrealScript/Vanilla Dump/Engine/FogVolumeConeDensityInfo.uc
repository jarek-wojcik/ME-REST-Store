Class FogVolumeConeDensityInfo extends FogVolumeDensityInfo
    native
    abstract;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=FogVolumeConeDensityComponent Name=FogVolumeComponent0
    End Object
    Begin Template Class=StaticMeshComponent Name=AutomaticMeshComponent0
        ReplacementPrimitive = None
    End Template
    DensityComponent = FogVolumeComponent0
    AutomaticMeshComponent = AutomaticMeshComponent0
    Components = (None, AutomaticMeshComponent0, None, FogVolumeComponent0)
}