Class SkeletalMesh
    native
    noexport;

struct native SoftBodySpecialBoneInfo 
{
    var(SoftBodySpecialBoneInfo) Name BoneName;
    var(SoftBodySpecialBoneInfo) SoftBodyBoneType BoneType;
    var const array<int> AttachedVertexIndices;
};
enum SoftBodyBoneType
{
    SOFTBODYBONE_Fixed,
    SOFTBODYBONE_BreakableAttachment,
    SOFTBODYBONE_TwoWayAttachment,
};
struct native SoftBodyTetraLink 
{
    var int Index;
    var Vector Bary;
};
struct native ClothSpecialBoneInfo 
{
    var(ClothSpecialBoneInfo) Name BoneName;
    var(ClothSpecialBoneInfo) ClothBoneType BoneType;
    var const array<int> AttachedVertexIndices;
};
enum ClothBoneType
{
    CLOTHBONE_Fixed,
    CLOTHBONE_BreakableAttachment,
    CLOTHBONE_TearLine,
};
struct native SkeletalMeshLODInfo 
{
    var(SkeletalMeshLODInfo) float DisplayFactor;
    var(SkeletalMeshLODInfo) float LODHysteresis;
    var(SkeletalMeshLODInfo) editfixedsize array<int> LODMaterialMap;
    var(SkeletalMeshLODInfo) editfixedsize array<bool> bEnableShadowCasting;
    var(SkeletalMeshLODInfo) editfixedsize array<TriangleSortOption> TriangleSorting;
};
enum ClothMovementScaleGen
{
    ECMDM_DistToFixedVert,
    ECMDM_VertexBoneWeight,
    ECMDM_Empty,
};
enum TriangleSortOption
{
    TRISORT_None,
    TRISORT_CenterRadialDistance,
    TRISORT_Random,
    TRISORT_Tootle,
    TRISORT_MergeContiguous,
    TRISORT_Custom,
};
struct native BoneMirrorExport 
{
    var(BoneMirrorExport) Name BoneName;
    var(BoneMirrorExport) Name SourceBoneName;
    var(BoneMirrorExport) EAxis BoneFlipAxis;
};
struct native BoneMirrorInfo 
{
    var(BoneMirrorInfo) int SourceIndex;
    var(BoneMirrorInfo) EAxis BoneFlipAxis;
};

var const native BoxSphereBounds Bounds;
var(SkeletalMesh) const native array<MaterialInterface> Materials;
var(SkeletalMesh) const native array<ApexClothingAsset> ClothingAssets;
var(SkeletalMesh) const native Vector Origin;
var(SkeletalMesh) const native Rotator RotOrigin;
var const native array<int> RefSkeleton;
var const native int SkeletalDepth;
var const native Object NameIndexMap;
var const native IndirectArray_Mirror LODModels;
var const native array<BoneTransform> RefBasesInvMatrix;
var(SkeletalMesh) editfixedsize array<BoneMirrorInfo> SkelMirrorTable;
var(SkeletalMesh) EAxis SkelMirrorAxis;
var(SkeletalMesh) EAxis SkelMirrorFlipAxis;
var array<SkeletalMeshSocket> Sockets;
var(SkeletalMesh) const editconst native array<string> BoneBreakNames;
var(SkeletalMesh) editfixedsize array<SkeletalMeshLODInfo> LODInfo;
var(SkeletalMesh) array<Name> PerPolyCollisionBones;
var(SkeletalMesh) array<Name> AddToParentPerPolyCollisionBone;
var const native array<int> PerPolyBoneKDOPs;
var(SkeletalMesh) bool bPerPolyUseSoftWeighting;
var(SkeletalMesh) bool bUseSimpleLineCollision;
var(SkeletalMesh) bool bUseSimpleBoxCollision;
var(SkeletalMesh) const bool bForceCPUSkinning;
var(SkeletalMesh) const bool bUseFullPrecisionUVs;
var(SkeletalMesh) const bool bUsePackedPosition;
var(SkeletalMesh) int LODBiasPC;
var(SkeletalMesh) int LODBiasPS3;
var(SkeletalMesh) int LODBiasXbox360;
var const transient native array<Pointer> ClothMesh;
var const transient native array<float> ClothMeshScale;
var const array<int> ClothToGraphicsVertMap;
var const array<float> ClothMovementScale;
var(Cloth) ClothMovementScaleGen ClothMovementScaleGenMode;
var(Cloth) float ClothToAnimMeshMaxDist;
var(Cloth) bool bLimitClothToAnimMesh;
var const array<int> ClothWeldingMap;
var const int ClothWeldingDomain;
var const array<int> ClothWeldedIndices;
var(ClothAdvanced) const bool bForceNoWelding;
var const int NumFreeClothVerts;
var const array<int> ClothIndexBuffer;
var(Cloth) const array<Name> ClothBones;
var(Cloth) const int ClothHierarchyLevels;
var(Cloth) const bool bEnableClothBendConstraints;
var(Cloth) const bool bEnableClothDamping;
var(Cloth) const bool bUseClothCOMDamping;
var(Cloth) const float ClothStretchStiffness;
var(Cloth) const float ClothBendStiffness;
var(Cloth) const float ClothDensity;
var(Cloth) const float ClothThickness;
var(Cloth) const float ClothDamping;
var(Cloth) const int ClothIterations;
var(Cloth) const int ClothHierarchicalIterations;
var(Cloth) const float ClothFriction;
var(ClothAdvanced) const float ClothRelativeGridSpacing;
var(ClothAdvanced) const float ClothPressure;
var(ClothAdvanced) const float ClothCollisionResponseCoefficient;
var(ClothAdvanced) const float ClothAttachmentResponseCoefficient;
var(ClothAdvanced) const float ClothAttachmentTearFactor;
var(ClothAdvanced) const float ClothSleepLinearVelocity;
var(Cloth) const float HardStretchLimitFactor;
var(Cloth) const bool bHardStretchLimit;
var(ClothAdvanced) const bool bEnableClothOrthoBendConstraints;
var(ClothAdvanced) const bool bEnableClothSelfCollision;
var(ClothAdvanced) const bool bEnableClothPressure;
var(ClothAdvanced) const bool bEnableClothTwoWayCollision;
var(ClothAdvanced) const array<ClothSpecialBoneInfo> ClothSpecialBones;
var(Cloth) const bool bEnableClothLineChecks;
var(ClothAdvanced) const bool bClothMetal;
var(ClothAdvanced) const float ClothMetalImpulseThreshold;
var(ClothAdvanced) const float ClothMetalPenetrationDepth;
var(ClothAdvanced) const float ClothMetalMaxDeformationDistance;
var(Cloth) const bool bEnableClothTearing;
var(Cloth) const float ClothTearFactor;
var(Cloth) const int ClothTearReserve;
var(Cloth) bool bEnableValidBounds;
var(Cloth) Vector ValidBoundsMin;
var(Cloth) Vector ValidBoundsMax;
var const native Map_Mirror ClothTornTriMap;
var const array<int> SoftBodySurfaceToGraphicsVertMap;
var const array<int> SoftBodySurfaceIndices;
var const array<Vector> SoftBodyTetraVertsUnscaled;
var const array<int> SoftBodyTetraIndices;
var const array<SoftBodyTetraLink> SoftBodyTetraLinks;
var const transient native array<Pointer> CachedSoftBodyMeshes;
var const transient native array<float> CachedSoftBodyMeshScales;
var(SoftBody) const array<Name> SoftBodyBones;
var(SoftBody) const array<SoftBodySpecialBoneInfo> SoftBodySpecialBones;
var(SoftBody) const float SoftBodyVolumeStiffness;
var(SoftBody) const float SoftBodyStretchingStiffness;
var(SoftBody) const float SoftBodyDensity;
var(SoftBody) const float SoftBodyParticleRadius;
var(SoftBody) const float SoftBodyDamping;
var(SoftBody) const int SoftBodySolverIterations;
var(SoftBody) const float SoftBodyFriction;
var(SoftBody) const float SoftBodyRelativeGridSpacing;
var(SoftBody) const float SoftBodySleepLinearVelocity;
var(SoftBody) const bool bEnableSoftBodySelfCollision;
var(SoftBody) const float SoftBodyAttachmentResponse;
var(SoftBody) const float SoftBodyCollisionResponse;
var(SoftBody) const float SoftBodyDetailLevel;
var(SoftBody) const int SoftBodySubdivisionLevel;
var(SoftBody) const bool bSoftBodyIsoSurface;
var(SoftBody) const bool bEnableSoftBodyDamping;
var(SoftBody) const bool bUseSoftBodyCOMDamping;
var(SoftBody) const float SoftBodyAttachmentThreshold;
var(SoftBody) const bool bEnableSoftBodyTwoWayCollision;
var(SoftBody) const float SoftBodyAttachmentTearFactor;
var(SoftBody) const bool bEnableSoftBodyLineChecks;
var const native array<bool> GraphicsIndexIsCloth;
var const transient native int ReleaseResourcesFence;
var const transient QWord SkelMeshRUID;
var transient native Pointer m_VerticesPerBone;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SkelMirrorAxis = EAxis.AXIS_X
    SkelMirrorFlipAxis = EAxis.AXIS_Z
    bUseSimpleLineCollision = TRUE
    bUseSimpleBoxCollision = TRUE
    bUsePackedPosition = TRUE
    ClothStretchStiffness = 1.0
    ClothBendStiffness = 1.0
    ClothDensity = 1.0
    ClothThickness = 0.5
    ClothDamping = 0.5
    ClothIterations = 5
    ClothHierarchicalIterations = 2
    ClothFriction = 0.5
    ClothRelativeGridSpacing = 1.0
    ClothPressure = 1.0
    ClothCollisionResponseCoefficient = 0.200000003
    ClothAttachmentResponseCoefficient = 0.200000003
    ClothAttachmentTearFactor = 1.5
    ClothSleepLinearVelocity = -1.0
    HardStretchLimitFactor = 1.10000002
    ClothMetalImpulseThreshold = 10.0
    ClothTearFactor = 3.5
    ClothTearReserve = 128
    SoftBodyVolumeStiffness = 1.0
    SoftBodyStretchingStiffness = 1.0
    SoftBodyDensity = 1.0
    SoftBodyParticleRadius = 0.100000001
    SoftBodyDamping = 0.5
    SoftBodySolverIterations = 5
    SoftBodyFriction = 0.5
    SoftBodyRelativeGridSpacing = 1.0
    SoftBodySleepLinearVelocity = -1.0
    SoftBodyAttachmentResponse = 0.200000003
    SoftBodyCollisionResponse = 0.200000003
    SoftBodyDetailLevel = 0.5
    SoftBodySubdivisionLevel = 4
    bSoftBodyIsoSurface = TRUE
    SoftBodyAttachmentThreshold = 0.5
    bEnableSoftBodyTwoWayCollision = TRUE
    SoftBodyAttachmentTearFactor = 1.5
}