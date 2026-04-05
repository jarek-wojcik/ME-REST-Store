Class SkeletalMeshCinematicActor extends SkeletalMeshActor
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bSynthesizeSHLight = TRUE
        bIsCharacterLightEnvironment = TRUE
    End Template
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
        End Template
        Animations = AnimNodeSeq0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        bAcceptsStaticDecals = TRUE
        bAcceptsDynamicDecals = TRUE
        bAllowAmbientOcclusion = FALSE
    End Template
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    CollisionComponent = SkeletalMeshComponent0
}