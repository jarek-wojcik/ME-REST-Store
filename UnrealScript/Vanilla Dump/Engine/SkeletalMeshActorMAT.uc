Class SkeletalMeshActorMAT extends SkeletalMeshCinematicActor
    native
    placeable;

var transient array<AnimNodeSlot> SlotNodes;

public event simulated function Destroyed()
{
    Super(SkeletalMeshActor).Destroyed();
    ClearAnimNodes();
}
public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}
public native function MAT_SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

public native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

public native function MAT_SetMorphWeight(Name MorphNodeName, float MorphWeight);

public native function MAT_SetSkelControlScale(Name SkelControlName, float Scale);

public event simulated function PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    Super(Actor).PostInitAnimTree(SkelComp);
    ClearAnimNodes();
    CacheAnimNodes();
}
public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
}
public event simulated function SetMorphWeight(Name MorphNodeName, float MorphWeight)
{
    MAT_SetMorphWeight(MorphNodeName, MorphWeight);
}
public event simulated function SetSkelControlScale(Name SkelControlName, float Scale)
{
    MAT_SetSkelControlScale(SkelControlName, Scale);
}
public simulated function CacheAnimNodes()
{
    local AnimNodeSlot SlotNode;
    
    foreach SkeletalMeshComponent.AllAnimNodes(Class'AnimNodeSlot', SlotNode)
    {
        SlotNodes[SlotNodes.Length] = SlotNode;
    }
}
public simulated function ClearAnimNodes()
{
    SlotNodes.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Animations = None
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    CollisionComponent = SkeletalMeshComponent0
}