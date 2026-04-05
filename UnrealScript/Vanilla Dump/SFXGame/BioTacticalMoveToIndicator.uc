Class BioTacticalMoveToIndicator extends Actor
    native;

var editinline export ParticleSystemComponent ParticleSystem;
var float m_fFadeInTime;
var float m_fTimePassed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ParticleSystemComponent Name=BioTacSelArrowParticle
        Template = ParticleSystem'BioBaseResources.HUD_Holograms.Particle.MoveToIndicatorParticleSystem'
        ReplacementPrimitive = None
    End Object
    ParticleSystem = BioTacSelArrowParticle
    m_fFadeInTime = 0.200000003
    m_fTimePassed = -1.0
    Components = (BioTacSelArrowParticle)
    bAlwaysTick = TRUE
    bTickDuringPlayersOnly = TRUE
}