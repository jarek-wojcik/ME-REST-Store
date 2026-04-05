Class DistributionVectorUniformCurve extends DistributionVector
    native
    editinlinenew
    collapsecategories;

var(DistributionVectorUniformCurve) InterpCurveTwoVectors ConstantCurve;
var bool bLockAxes1;
var bool bLockAxes2;
var(DistributionVectorUniformCurve) bool bUseExtremes;
var(DistributionVectorUniformCurve) EDistributionVectorMirrorFlags MirrorFlags[3];
var(DistributionVectorUniformCurve) EDistributionVectorLockFlags LockedAxes[2];

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MirrorFlags[0] = EDistributionVectorMirrorFlags.EDVMF_Different
    MirrorFlags[1] = EDistributionVectorMirrorFlags.EDVMF_Different
    MirrorFlags[2] = EDistributionVectorMirrorFlags.EDVMF_Different
}