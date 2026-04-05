Class FracturedSMActorSpawnable extends FracturedStaticMeshActor
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=LightEnvironment0
    End Template
    Begin Template Class=FracturedSkinnedMeshComponent Name=FracturedSkinnedComponent0
        ReplacementPrimitive = None
        LightEnvironment = LightEnvironment0
    End Template
    Begin Template Class=FracturedStaticMeshComponent Name=FracturedStaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = LightEnvironment0
        bForceDirectLightMap = FALSE
    End Template
    FracturedStaticMeshComponent = FracturedStaticMeshComponent0
    SkinnedComponent = FracturedSkinnedComponent0
    Components = (LightEnvironment0, FracturedSkinnedComponent0, FracturedStaticMeshComponent0)
    CollisionComponent = FracturedStaticMeshComponent0
    bNoDelete = FALSE
}