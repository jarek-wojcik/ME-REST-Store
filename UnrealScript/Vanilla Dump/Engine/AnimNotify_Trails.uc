Class AnimNotify_Trails extends AnimNotify
    native
    editinlinenew
    collapsecategories;

struct native TrailSample 
{
    var Vector FirstEdgeSample;
    var Vector SecondEdgeSample;
    var Vector ControlPointSample;
    var float RelativeTime;
};
struct native TrailSamplePoint 
{
    var TrailSocketSamplePoint FirstEdgeSample;
    var TrailSocketSamplePoint SecondEdgeSample;
    var TrailSocketSamplePoint ControlPointSample;
    var float RelativeTime;
};
struct native TrailSocketSamplePoint 
{
    var Vector Position;
    var Vector Velocity;
};

var array<TrailSample> TrailSampledData;
var(Trails) Name FirstEdgeSocketName;
var(Trails) Name SecondEdgeSocketName;
var(Trails) Name ControlPointSocketName;
var(Trails) ParticleSystem PSTemplate;
var float LastStartTime;
var float EndTime;
var(Trails) float SamplesPerSecond;
var transient float CurrentTime;
var transient float TimeStep;
var transient AnimNodeSequence AnimNodeSeq;
var(Trails) bool bIsExtremeContent;
var(AnimNotify_Trails) bool bSkipIfOwnerIsHidden;
var bool bResampleRequired;

public native function int GetNumSteps(int InLastTrailIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FirstEdgeSocketName = 'EndControl'
    SecondEdgeSocketName = 'StartControl'
    ControlPointSocketName = 'MidControl'
    SamplesPerSecond = 60.0
    bSkipIfOwnerIsHidden = TRUE
}