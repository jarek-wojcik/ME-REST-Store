Class DistributionFloatParameterBase extends DistributionFloatConstant
    native
    editinlinenew
    abstract
    collapsecategories;

enum DistributionParamMode
{
    DPM_Normal,
    DPM_Abs,
    DPM_Direct,
};

var(DistributionFloatParameterBase) Name ParameterName;
var(DistributionFloatParameterBase) float MinInput;
var(DistributionFloatParameterBase) float MaxInput;
var(DistributionFloatParameterBase) float MinOutput;
var(DistributionFloatParameterBase) float MaxOutput;
var(DistributionFloatParameterBase) DistributionParamMode ParamMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxInput = 1.0
    MaxOutput = 1.0
}