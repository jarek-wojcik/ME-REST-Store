Class EmitterSpawnable extends Emitter;

var repnotify ParticleSystem ParticleTemplate;

public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ParticleTemplate')
    {
        SetTemplate(ParticleTemplate, bDestroyOnSystemFinish);
        ParticleSystemComponent.ActivateSystem();
        if (ParticleTemplate == None && bDestroyOnSystemFinish)
        {
            Destroy();
        }
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public event simulated function SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish)
{
    Super.SetTemplate(NewTemplate, bDestroyOnFinish);
    ParticleTemplate = NewTemplate;
}

replication
{
    if (bNetInitial)
        ParticleTemplate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=ParticleSystemComponent0
        SecondsBeforeInactive = 0.0
        ReplacementPrimitive = None
    End Template
    ParticleSystemComponent = ParticleSystemComponent0
    bDestroyOnSystemFinish = TRUE
    Components = (None, ParticleSystemComponent0, None)
    bNoDelete = FALSE
    bNetTemporary = TRUE
}