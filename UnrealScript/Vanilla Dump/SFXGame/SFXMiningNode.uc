Class SFXMiningNode extends SFXPointOfInterest
    placeable;

var(SFXMiningNode) float ImpulseMinStrength;
var(SFXMiningNode) float ImpulseMaxStrength;
var(SFXMiningNode) float ImpulseMinFrequency;
var(SFXMiningNode) float ImpulseMaxFrequency;
var(SFXMiningNode) float Radius;
var(SFXMiningNode) float Duration;
var(SFXMiningNode) editinline export ParticleSystemComponent PSC_GroundReticle;
var bool bAlreadyMined;

public function PostBeginPlay()
{
    PSC_GroundReticle.SetScale(Radius / float(425));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=Reticle
        Template = ParticleSystem'BioVFX_C_Mako2.Particles.Mining_Indicator'
        ReplacementPrimitive = None
    End Object
    Begin Template Class=SFXSimpleUseModule Name=tempSelectionModule
    End Template
    ImpulseMinStrength = 5000.0
    ImpulseMaxStrength = 10000.0
    ImpulseMinFrequency = 0.0250000004
    ImpulseMaxFrequency = 0.100000001
    Radius = 600.0
    Duration = 5.0
    PSC_GroundReticle = Reticle
    Components = (None, Reticle)
    Modules = (tempSelectionModule)
}