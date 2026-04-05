Class RvrClientEffectSpawnable extends RvrClientEffectActor
    native;

public simulated native function OnFinished(RvrClientEffectComponent pComponent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=RvrClientEffectComponent Name=CEComp
    End Template
    m_bDestroyOnFinished = TRUE
    Components = (None, CEComp)
    bNoDelete = FALSE
}