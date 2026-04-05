Class SplineComponent extends PrimitiveComponent
    native;

var(SplineComponent) InterpCurveVector SplineInfo;
var(SplineComponent) InterpCurveFloat SplineReparamTable;
var(SplineComponent) editconst float SplineCurviness;
var(SplineComponent) Color SplineColor;
var(SplineComponent) float SplineDrawRes;
var(SplineComponent) float SplineArrowSize;
var(SplineComponent) bool bSplineDisabled;

public native function Vector GetLocationAtDistanceAlongSpline(float Distance);

public native function float GetSplineLength();

public native function Vector GetTangentAtDistanceAlongSpline(float Distance);

public native function UpdateSplineCurviness();

public native function UpdateSplineReparamTable();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplineColor = {B = 255, G = 0, R = 255, A = 255}
    SplineDrawRes = 0.100000001
    SplineArrowSize = 60.0
    ReplacementPrimitive = None
}