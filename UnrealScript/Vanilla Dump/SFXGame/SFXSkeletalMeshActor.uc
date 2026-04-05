Class SFXSkeletalMeshActor extends SkeletalMeshActor
    native
    placeable;

struct native SMATextureParameter 
{
    var(SMATextureParameter) Name ParameterName;
    var(SMATextureParameter) editconst Name Group;
    var(SMATextureParameter) Texture Parameter;
    
    structdefaultproperties
    {
        Group = 'User'
    }
};
struct native SMAScalarParameter 
{
    var(SMAScalarParameter) Name ParameterName;
    var(SMAScalarParameter) editconst Name Group;
    var(SMAScalarParameter) float Parameter;
    
    structdefaultproperties
    {
        Group = 'User'
    }
};
struct native SMAVectorParameter 
{
    var(SMAVectorParameter) LinearColor Parameter;
    var(SMAVectorParameter) Name ParameterName;
    var(SMAVectorParameter) editconst Name Group;
    
    structdefaultproperties
    {
        Group = 'User'
    }
};

var(SkeletalMeshActor) array<SMAVectorParameter> VectorParameters;
var(SkeletalMeshActor) array<SMAScalarParameter> ScalarParameters;
var(SkeletalMeshActor) array<SMATextureParameter> TextureParameters;
var(SkeletalMeshActor) editinline export SkeletalMeshComponent HeadMesh;
var(SkeletalMeshActor) editinline export SkeletalMeshComponent HairMesh;
var(SkeletalMeshActor) editinline export SkeletalMeshComponent HeadGearMesh;
var(SkeletalMeshActor) BioMorphFace MorphHead;
var(SkeletalMeshActor) bool bAnimFrozen;
var(SkeletalMeshActor) bool UpdateSkelWhenNotRendered;
var bool bHasWrinkles;

public simulated function BioBaseRemovedFromWorld();

public simulated function FellOutOfWorld(Class<DamageType> dmgType);

public native function SkeletalMeshComponent GetHeadSkelMeshComponent();

public native function SkeletalMeshComponent GetPrimarySkelMeshComponent();

public simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        BioApplyStasis("OutsideWorldBounds");
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bAnimFrozen)
    {
        SkeletalMeshComponent.SetFrozen(TRUE);
        HeadMesh.SetFrozen(TRUE);
        HairMesh.SetFrozen(TRUE);
        HeadGearMesh.SetFrozen(TRUE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnv0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = SkeletalMeshComponent0
        MinAutoLODLevel = 1
        ShadowParent = SkeletalMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        CastShadow = FALSE
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
        Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
        End Template
        Animations = AnimNodeSeq0
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        CollideActors = FALSE
        BlockZeroExtent = FALSE
    End Template
    HeadMesh = HeadMesh0
    HairMesh = HairMesh0
    HeadGearMesh = GearMesh0
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = BioLightEnv0
    Components = (SkeletalMeshComponent0, BioLightEnv0, HeadMesh0, HairMesh0, GearMesh0)
    CollisionComponent = SkeletalMeshComponent0
}