Class BioParticleModuleVelocityWorldSpace extends ParticleModuleVelocity
    native
    editinlinenew
    collapsecategories;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatUniform Name=DistributionStartVelocityRadial
    End Template
    Begin Template Class=DistributionVectorUniform Name=DistributionStartVelocity
    End Template
    Begin Template Class=DistributionVectorUniform Name=DistributionStartVelocityRw
    End Template
    StartVelocityRw = {Distribution = DistributionStartVelocityRw}
    StartVelocityRadial = {Distribution = DistributionStartVelocityRadial}
}