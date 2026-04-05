Class DistributionFloat extends Component
    native
    editinlinenew
    abstract
    collapsecategories;

struct native RawDistributionFloat extends RawDistribution 
{
    var(RawDistributionFloat) editinline export noclear DistributionFloat Distribution;
};

var const native noexport Pointer VfTable_FCurveEdInterface;
var(Baked) bool bCanBeBaked;
var bool bIsDirty;

public native function float GetFloatValue(optional float F = 0.0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCanBeBaked = TRUE
    bIsDirty = TRUE
}