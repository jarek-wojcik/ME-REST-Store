Class CurveEdPresetCurve
    native
    editinlinenew;

struct native PresetGeneratedPoint 
{
    var float KeyIn;
    var float KeyOut;
    var float TangentIn;
    var float TangentOut;
    var bool TangentsValid;
    var EInterpCurveMode IntepMode;
};

var(CurveEdPresetCurve) const localized string CurveName;
var array<PresetGeneratedPoint> Points;

public native function bool RetrieveFloatCurvePoints(int CurveIndex, DistributionFloat Distribution);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}