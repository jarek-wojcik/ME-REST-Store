Class MorphNodeWeight extends MorphNodeWeightBase
    native;

var float NodeWeight;

public native function SetNodeWeight(float NewWeight);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NodeConns = ({
                  ChildNodes = (), 
                  ConnName = 'In', 
                  DrawY = 0
                 }
                )
    bDrawSlider = TRUE
}