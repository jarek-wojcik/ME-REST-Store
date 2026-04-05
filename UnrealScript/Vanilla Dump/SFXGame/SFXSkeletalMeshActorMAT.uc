Class SFXSkeletalMeshActorMAT extends SkeletalMeshActorMAT
    native
    placeable;

var(SkeletalMeshActor) array<SMAVectorParameter> VectorParameters;
var(SkeletalMeshActor) array<SMAScalarParameter> ScalarParameters;
var(SkeletalMeshActor) array<SMATextureParameter> TextureParameters;
var(SkeletalMeshActor) editinline export SkeletalMeshComponent HeadMesh;
var editinline export SkeletalMeshComponent HairMesh;
var(SkeletalMeshActor) BioMorphFace MorphHead;
var(SkeletalMeshActor) bool UpdateSkelWhenNotRendered;
var bool bHasWrinkles;

public simulated function BioBaseRemovedFromWorld()
{
    if (Physics == EPhysics.PHYS_None || Physics == EPhysics.PHYS_Interpolating)
    {
    }
    else
    {
        BioApplyStasis("BaseRemovedFromWorld");
    }
}
public simulated function FellOutOfWorld(Class<DamageType> dmgType);

public simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        BioApplyStasis("OutsideWorldBounds");
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnv0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = SkeletalMeshComponent0
        MinAutoLODLevel = 1
        ShadowParent = SkeletalMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        CastShadow = FALSE
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = SkeletalMeshComponent0
        bOverrideParentSkeleton = TRUE
        nmOverrideStartBoneName = 'headBase'
        MinAutoLODLevel = 1
        ShadowParent = SkeletalMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        TickGroup = ETickingGroup.TG_PostDirtyComponentsWork
    End Object
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        CollideActors = FALSE
        BlockZeroExtent = FALSE
    End Template
    HeadMesh = HeadMesh0
    HairMesh = HairMesh0
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = BioLightEnv0
    Components = (SkeletalMeshComponent0, BioLightEnv0, HeadMesh0, HairMesh0)
    CollisionComponent = SkeletalMeshComponent0
}