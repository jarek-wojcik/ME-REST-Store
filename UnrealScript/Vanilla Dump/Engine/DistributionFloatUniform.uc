Class DistributionFloatUniform extends DistributionFloat
    native
    editinlinenew
    collapsecategories;

struct CachedValue 
{
    var float Value;
};

var(DistributionFloatUniform) float Min;
var(DistributionFloatUniform) float Max;
var transient native CachedValue fCachedValue;
var(DistributionFloatUniform) bool bConsistentValue;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}