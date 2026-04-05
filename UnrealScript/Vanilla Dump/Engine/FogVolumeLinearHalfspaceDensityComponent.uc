Class FogVolumeLinearHalfspaceDensityComponent extends FogVolumeDensityComponent
    native
    editinlinenew
    collapsecategories;

var(FogVolumeLinearHalfspaceDensityComponent) interp Plane HalfspacePlane;
var(FogVolumeLinearHalfspaceDensityComponent) interp float PlaneDistanceFactor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HalfspacePlane = {W = -300.0, X = 0.0, Y = 0.0, Z = 1.0}
    PlaneDistanceFactor = 0.100000001
}