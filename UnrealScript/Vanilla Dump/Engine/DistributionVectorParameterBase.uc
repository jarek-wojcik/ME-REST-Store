Class DistributionVectorParameterBase extends DistributionVectorConstant
    native
    editinlinenew
    abstract
    collapsecategories;

var(DistributionVectorParameterBase) Vector MinInput;
var(DistributionVectorParameterBase) Vector MaxInput;
var(DistributionVectorParameterBase) Vector MinOutput;
var(DistributionVectorParameterBase) Vector MaxOutput;
var(DistributionVectorParameterBase) Name ParameterName;
var(DistributionVectorParameterBase) editinline export DistributionParamMode ParamModes[3];

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxInput = {X = 1.0, Y = 1.0, Z = 1.0}
    MaxOutput = {X = 1.0, Y = 1.0, Z = 1.0}
}