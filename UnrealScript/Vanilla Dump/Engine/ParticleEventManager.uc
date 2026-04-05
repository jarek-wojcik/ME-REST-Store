Class ParticleEventManager extends Actor
    native
    abstract;

public event function HandleParticleModuleEventSendToGame(ParticleModuleEventSendToGame InEvent, const out Vector InCollideDirection, const out Vector InHitLocation, const out Vector InHitNormal, const out Name InBoneName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}