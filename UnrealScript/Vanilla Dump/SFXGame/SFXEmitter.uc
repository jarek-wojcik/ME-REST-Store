Class SFXEmitter extends Emitter
    placeable;

var bool bPooled;

public function Initialize(ParticleSystem Template)
{
    local int idx;
    
    SetCollision(FALSE, FALSE, TRUE);
    LifeSpan = 0.0;
    SetTemplate(Template, FALSE);
    if (ParticleSystemComponent != None)
    {
        ParticleSystemComponent.bAutoActivate = FALSE;
        ParticleSystemComponent.LODMethod = ParticleSystemLODMethod.PARTICLESYSTEMLODMETHOD_DirectSet;
        for (idx = 0; idx < ParticleSystemComponent.EmitterInstances.Length; ++idx)
        {
            ParticleSystemComponent.SetKillOnDeactivate(idx, FALSE);
            ParticleSystemComponent.SetKillOnCompleted(idx, FALSE);
        }
    }
}
public function Recycle()
{
    ClearTimer('Recycle');
    ParticleSystemComponent.DeactivateSystem();
    SetHidden(TRUE);
    SetTickIsDisabled(TRUE);
    StopAllSounds();
}
public function Reset()
{
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Super(Actor).Reset();
    }
}
public function Reuse()
{
    SetTickIsDisabled(FALSE);
    ClearTimer('Recycle');
    SetTimer(180.0, FALSE, 'Recycle', );
    SetHidden(FALSE);
}
public simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Destroy();
    }
}
public function SetLifetime(float Seconds)
{
    if (!bTickIsDisabled)
    {
        ClearTimer('Recycle');
        SetTimer(Seconds, FALSE, 'Recycle', );
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=ParticleSystemComponent0
        ReplacementPrimitive = None
    End Template
    ParticleSystemComponent = ParticleSystemComponent0
    bDestroyOnSystemFinish = TRUE
    Components = (ParticleSystemComponent0)
    bNoDelete = FALSE
    bNetInitialRotation = TRUE
    bNoEncroachCheck = TRUE
}