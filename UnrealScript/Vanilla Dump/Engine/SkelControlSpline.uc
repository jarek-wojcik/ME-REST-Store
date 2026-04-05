Class SkelControlSpline extends SkelControlBase
    native;

enum ESplineControlRotMode
{
    SCR_NoChange,
    SCR_AlongSpline,
    SCR_Interpolate,
};

var(Spline) int SplineLength;
var(Spline) float EndSplineTension;
var(Spline) float StartSplineTension;
var(Spline) bool bInvertSplineBoneAxis;
var(Spline) EAxis SplineBoneAxis;
var(Spline) ESplineControlRotMode BoneRotMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplineLength = 2
    EndSplineTension = 10.0
    StartSplineTension = 10.0
    SplineBoneAxis = EAxis.AXIS_X
}