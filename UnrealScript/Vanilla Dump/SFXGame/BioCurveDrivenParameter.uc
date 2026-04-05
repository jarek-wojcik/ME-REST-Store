Class BioCurveDrivenParameter
    native
    editinlinenew;

var(BioCurveDrivenParameter) editinline RawDistributionFloat m_curve;
var(BioCurveDrivenParameter) string sParameterName;
var Name nmParameterName;
var(BioCurveDrivenParameter) bool bScaleToLifetime;
var(BioCurveDrivenParameter) bool bLoop;

public native function float GetValue(float fTime, optional float fScale = 1.0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=pDefaultCurve
    End Object
    m_curve = {
               Distribution = pDefaultCurve, 
               Type = 0, 
               Op = 1, 
               LookupTableNumElements = 1, 
               LookupTableChunkSize = 1, 
               LookupTable = (0.0, 0.0, 0.0, 0.0), 
               LookupTableTimeScale = 0.0, 
               LookupTableStartTime = 0.0
              }
    bScaleToLifetime = TRUE
}