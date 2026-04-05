Class BioMorphFace
    native
    config(Engine);

struct native OffsetBonePos 
{
    var Vector vPos;
    var Name nName;
};
struct native MorphFeature 
{
    var Name sFeatureName;
    var float Offset;
};

var native array<Pointer> m_aVertexBuffers;
var(Data) array<SkeletalMesh> m_oOtherMeshes;
var(Features) array<MorphFeature> m_aMorphFeatures;
var array<OffsetBonePos> m_aFinalSkeleton;
var const native Pointer ReleaseResourcesFence;
var(Data) SkeletalMesh m_oBaseHead;
var(Data) SkeletalMesh m_oHairMesh;
var(Data) MorphTargetSet m_oMorphTargetSet;
var(Data) AnimTree m_oAnimTree;
var config int CurrentMorphFaceContentVersion;
var int m_nInternalMorphFaceContentVersion;
var(Materials) export BioMaterialOverride m_oMaterialOverrides;
var(Data) bool bRequiresDynamicUpdates;

public native function ApplyMaterialOverrides(SkeletalMeshComponent Mesh);

public native function ApplyMaterialOverridesToActor(Actor InTarget);

public native function ApplyMorph();

public native function int GetNumVertexBuffers();

public native function int GetNumVerts(int Buffer);

public native function Vector GetPosition(int Buffer, int vert);

public native function RefreshBuffers(array<int> BufferIndices);

public native function SetPosition(int Buffer, int vert, Vector V);

private final function ApplyMesh(SkeletalMesh SkelMesh, SkeletalMeshComponent MeshCmpt)
{
    local int idx;
    
    if (SkelMesh != None && MeshCmpt != None)
    {
        MeshCmpt.SetSkeletalMesh(SkelMesh);
        for (idx = 0; idx < SkelMesh.Materials.Length; idx++)
        {
            MeshCmpt.SetMaterial(idx, None);
            MeshCmpt.CreateAndSetMaterialInstanceConstant(idx);
        }
    }
}
public final function ApplyToActor(Actor InTarget)
{
    local BioPawn TargetPawn;
    local Controller TargetController;
    local SFXSkeletalMeshActor SMA;
    local SFXStuntActor StuntActor;
    local SkeletalMeshComponent Mesh;
    local SkeletalMeshComponent HeadMesh;
    local SkeletalMeshComponent HairMesh;
    
    if (InTarget != None)
    {
        TargetController = Controller(InTarget);
        if (TargetController != None)
        {
            TargetPawn = BioPawn(TargetController.Pawn);
        }
        else
        {
            TargetPawn = BioPawn(InTarget);
        }
        if (TargetPawn != None)
        {
            TargetPawn.MorphHead = Self;
            Mesh = TargetPawn.Mesh;
            HeadMesh = TargetPawn.HeadMesh;
            HairMesh = TargetPawn.m_oHairMesh;
        }
        else if (SFXSkeletalMeshActor(InTarget) != None)
        {
            SMA = SFXSkeletalMeshActor(InTarget);
            SMA.MorphHead = Self;
            Mesh = SMA.SkeletalMeshComponent;
            HeadMesh = SMA.HeadMesh;
            HairMesh = SMA.HairMesh;
        }
        else if (SFXStuntActor(InTarget) != None)
        {
            StuntActor = SFXStuntActor(InTarget);
            StuntActor.MorphHead = Self;
            Mesh = StuntActor.BodyMesh;
            HeadMesh = StuntActor.HeadMesh;
            HairMesh = StuntActor.HairMesh;
        }
        if (Mesh != None)
        {
            UpdateActorMeshes(Mesh, HeadMesh, HairMesh);
        }
        ApplyMaterialOverridesToActor(InTarget);
    }
}
private final function UpdateActorMeshes(SkeletalMeshComponent Mesh, SkeletalMeshComponent HeadMesh, SkeletalMeshComponent HairMesh)
{
    if (Mesh != None && Mesh.SkeletalMesh != None)
    {
        if (m_oBaseHead != None)
        {
            ApplyMesh(m_oBaseHead, HeadMesh);
            HeadMesh.bTransformFromAnimParent = 1;
            HeadMesh.SetParentAnimComponent(Mesh);
            HeadMesh.SetShadowParent(Mesh);
            HeadMesh.SetLightEnvironment(Mesh.LightEnvironment);
        }
        else
        {
            HeadMesh.SetSkeletalMesh(None);
        }
        if (m_oHairMesh != None)
        {
            ApplyMesh(m_oHairMesh, HairMesh);
            HairMesh.bTransformFromAnimParent = 1;
            HairMesh.SetParentAnimComponent(Mesh);
            HairMesh.SetShadowParent(Mesh);
            HairMesh.SetLightEnvironment(Mesh.LightEnvironment);
        }
        else
        {
            HairMesh.SetSkeletalMesh(None);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioMaterialOverride Name=oMaterialOverrides
    End Object
    CurrentMorphFaceContentVersion = 20
    m_oMaterialOverrides = oMaterialOverrides
}