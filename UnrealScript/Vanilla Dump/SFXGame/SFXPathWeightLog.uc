Class SFXPathWeightLog
    native;

struct native transient NavWeight 
{
    var init array<float> ConstraintWeights;
    var init NavigationPoint Nav;
    var init float Weight;
    var init int FailedIndex;
};

var transient NavWeight BestWeight;
var transient array<NavWeight> NavWeights;

public native function int AddNav(NavigationPoint Nav, int NumConstraints);

public native function SetNavWeight(int NavIndex, float Weight, optional int ConstraintIndex = -1, optional bool bRejected);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}