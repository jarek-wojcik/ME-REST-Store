Class SFXTracer_Bullet extends SFXTracer
    abstract
    deprecated
    transient;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=ParticleSystemComponent0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
    End Template
    Mesh = StaticMeshComponent0
    Trail = ParticleSystemComponent0
    Components = (StaticMeshComponent0, ParticleSystemComponent0)
}