Class ParticleModuleRotationOverLifetime extends ParticleModuleRotationBase
    native
    editinlinenew;

var(Rotation) editinline RawDistributionFloat RotationOverLife;
var(Rotation) bool Scale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstantCurve Name=DistributionRotOverLife
    End Object
    RotationOverLife = {
                        Distribution = DistributionRotOverLife, 
                        Type = 0, 
                        Op = 1, 
                        LookupTableNumElements = 1, 
                        LookupTableChunkSize = 1, 
                        LookupTable = (0.0, 0.0, 0.0, 0.0), 
                        LookupTableTimeScale = 0.0, 
                        LookupTableStartTime = 0.0
                       }
    Scale = TRUE
    bUpdateModule = TRUE
}