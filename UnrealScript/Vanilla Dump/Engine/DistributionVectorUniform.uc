Class DistributionVectorUniform extends DistributionVector
    native
    editinlinenew
    collapsecategories;

var(DistributionVectorUniform) Vector Max;
var(DistributionVectorUniform) Vector Min;
var bool bLockAxes;
var(DistributionVectorUniform) bool bUseExtremes;
var(DistributionVectorUniform) EDistributionVectorMirrorFlags MirrorFlags[3];
var(DistributionVectorUniform) EDistributionVectorLockFlags LockedAxes;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MirrorFlags[0] = EDistributionVectorMirrorFlags.EDVMF_Different
    MirrorFlags[1] = EDistributionVectorMirrorFlags.EDVMF_Different
    MirrorFlags[2] = EDistributionVectorMirrorFlags.EDVMF_Different
}