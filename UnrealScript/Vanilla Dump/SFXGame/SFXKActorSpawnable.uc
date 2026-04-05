Class SFXKActorSpawnable extends KActorSpawnable
    native;

var transient float m_fPhysicsSoundLastTimePlayed;
var transient Actor m_aLastCollidedActor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
}