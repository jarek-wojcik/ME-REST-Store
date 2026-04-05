Class SFXKAssetSpawnable extends SFXKAsset;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=SkeletalMeshComponent Name=KAssetSkelMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    SkeletalMeshComponent = KAssetSkelMeshComponent
    Components = (MyLightEnvironment, KAssetSkelMeshComponent)
    CollisionComponent = KAssetSkelMeshComponent
    bNoDelete = FALSE
}