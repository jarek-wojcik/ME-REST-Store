Class DistributionVector extends Component
    native
    editinlinenew
    abstract
    collapsecategories;

struct native BioRawDistributionRwVector3 extends BioRawDistributionRwVector3Base 
{
    var(BioRawDistributionRwVector3) editinline export noclear DistributionVector Distribution;
};
struct native RawDistributionVector extends RawDistribution 
{
    var(RawDistributionVector) editinline export noclear DistributionVector Distribution;
};
enum EDistributionVectorMirrorFlags
{
    EDVMF_Same,
    EDVMF_Different,
    EDVMF_Mirror,
};
enum EDistributionVectorLockFlags
{
    EDVLF_None,
    EDVLF_XY,
    EDVLF_XZ,
    EDVLF_YZ,
    EDVLF_XYZ,
};

var const native noexport Pointer VfTable_FCurveEdInterface;
var(Baked) bool bCanBeBaked;
var bool bIsDirty;

public native function Vector GetVectorValue(optional float F = 0.0, optional int LastExtreme = 0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCanBeBaked = TRUE
    bIsDirty = TRUE
}