Class SkeletalMeshActorBasedOnExtremeContent extends SkeletalMeshActor
    native
    placeable;

struct native SkelMaterialSetterDatum 
{
    var(SkelMaterialSetterDatum) int MaterialIndex;
    var(SkelMaterialSetterDatum) MaterialInterface TheMaterial;
};

var(SkeletalMeshActorBasedOnExtremeContent) array<SkelMaterialSetterDatum> ExtremeContent;
var(SkeletalMeshActorBasedOnExtremeContent) array<SkelMaterialSetterDatum> NonExtremeContent;

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetMaterialBasedOnExtremeContent();
}
public simulated function SetMaterialBasedOnExtremeContent()
{
    local int idx;
    
    if (WorldInfo.GRI.ShouldShowGore())
    {
        for (idx = 0; idx < ExtremeContent.Length; ++idx)
        {
            SkeletalMeshComponent.SetMaterial(ExtremeContent[idx].MaterialIndex, ExtremeContent[idx].TheMaterial);
        }
    }
    else
    {
        for (idx = 0; idx < NonExtremeContent.Length; ++idx)
        {
            SkeletalMeshComponent.SetMaterial(NonExtremeContent[idx].MaterialIndex, NonExtremeContent[idx].TheMaterial);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
        End Template
        Animations = AnimNodeSeq0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    CollisionComponent = SkeletalMeshComponent0
}