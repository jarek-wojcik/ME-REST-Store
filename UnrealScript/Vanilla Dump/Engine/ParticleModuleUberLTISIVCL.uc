Class ParticleModuleUberLTISIVCL extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories;

var(Lifetime) editinline export noclear RawDistributionFloat Lifetime;
var(Size) editinline export noclear RawDistributionVector StartSize;
var(Velocity) editinline export noclear RawDistributionVector StartVelocity;
var(Velocity) editinline export noclear RawDistributionFloat StartVelocityRadial;
var(Color) editinline export noclear RawDistributionVector ColorOverLife;
var(Color) editinline export noclear RawDistributionFloat AlphaOverLife;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlphaOverLife
        Constant = 255.899994
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLifetime
        Min = 1.0
        Max = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionStartVelocityRadial
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorOverLife
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartSize
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
        Min = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartVelocity
        Max = {X = 0.0, Y = 0.0, Z = 10.0}
    End Object
    Lifetime = {
                Distribution = DistributionLifetime, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (1.0, 1.0, 1.0, 1.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    StartSize = {
                 Distribution = DistributionStartSize, 
                 Type = 0, 
                 Op = 1, 
                 LookupTableNumElements = 1, 
                 LookupTableChunkSize = 3, 
                 LookupTable = (1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0
                               ), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    StartVelocity = {
                     Distribution = DistributionStartVelocity, 
                     Type = 0, 
                     Op = 2, 
                     LookupTableNumElements = 2, 
                     LookupTableChunkSize = 6, 
                     LookupTable = (0.0, 
                                    10.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    10.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    10.0
                                   ), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    StartVelocityRadial = {
                           Distribution = DistributionStartVelocityRadial, 
                           Type = 0, 
                           Op = 1, 
                           LookupTableNumElements = 1, 
                           LookupTableChunkSize = 1, 
                           LookupTable = (0.0, 0.0, 0.0, 0.0), 
                           LookupTableTimeScale = 0.0, 
                           LookupTableStartTime = 0.0
                          }
    ColorOverLife = {
                     Distribution = DistributionColorOverLife, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 3, 
                     LookupTable = (0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0
                                   ), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    AlphaOverLife = {
                     Distribution = DistributionAlphaOverLife, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 1, 
                     LookupTable = (255.899994, 255.899994, 255.899994, 255.899994), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    RequiredModules = ('ParticleModuleLifetime', 'ParticleModuleSize', 'ParticleModuleVelocity', 'ParticleModuleColorOverLife')
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}