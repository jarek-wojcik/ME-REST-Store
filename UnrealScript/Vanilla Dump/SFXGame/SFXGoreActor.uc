Class SFXGoreActor extends SkeletalMeshActor
    native
    placeable;

public native function CopyBindPose(BioPawn Pawn);

public native function SwitchBodiesBelow(Name ParentBoneName, SkeletalMeshComponent FromSkelComp, SkeletalMeshComponent ToSkelComp, PhysicsAssetInstance FromInst, PhysicsAssetInstance ToInst);

public function CreateGoreActor(Pawn Pawn, Name BoneName)
{
    SkeletalMeshComponent.SetAnimTreeTemplate(new Class'AnimTree');
    SwitchBodiesBelow(BoneName, Pawn.Mesh, SkeletalMeshComponent, Pawn.Mesh.PhysicsAssetInstance, SkeletalMeshComponent.PhysicsAssetInstance);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
        End Template
        SkeletalMesh = SkeletalMesh'BioBaseResources.MissingResources.Missing_Creature_Class'
        Animations = AnimNodeSeq0
        bIgnoreControllersWhenNotRendered = TRUE
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_Pawn
        BlockRigidBody = TRUE
        RBCollideWithChannels = {Pawn = TRUE, Vehicle = TRUE}
        ScriptRigidBodyCollisionThreshold = 200.0
    End Template
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    CollisionComponent = SkeletalMeshComponent0
    bNoDelete = FALSE
    Physics = EPhysics.PHYS_RigidBody
}