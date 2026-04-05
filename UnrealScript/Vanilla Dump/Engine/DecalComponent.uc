Class DecalComponent extends PrimitiveComponent
    native
    editinlinenew;

enum EFilterMode
{
    FM_None,
    FM_Ignore,
    FM_Affect,
};
enum EDecalTransform
{
    DecalTransform_OwnerAbsolute,
    DecalTransform_OwnerRelative,
    DecalTransform_SpawnRelative,
};
struct native DecalReceiver 
{
    var const native Pointer RenderData;
    var const editinline export PrimitiveComponent Component;
};

var const transient native duplicatetransient noimport array<Pointer> StaticReceivers;
var const transient array<int> HitNodeIndices;
var const editinline duplicatetransient noimport array<DecalReceiver> DecalReceivers;
var transient array<Plane> Planes;
var(DecalFilter) array<Actor> Filter;
var(DecalFilter) editinline export array<PrimitiveComponent> ReceiverImages;
var const transient native duplicatetransient Pointer ReleaseResourcesFence;
var transient Vector location;
var transient Rotator Orientation;
var Vector HitLocation;
var Vector HitNormal;
var Vector HitTangent;
var Vector HitBinormal;
var(DecalRender) Vector ParentRelativeLocation;
var(DecalRender) Rotator ParentRelativeOrientation;
var const transient Vector OriginalParentRelativeLocation;
var const transient Vector OriginalParentRelativeOrientationVec;
var transient Name HitBone;
var(DecalRender) Vector2D BlendRange;
var(Decal) const MaterialInterface DecalMaterial;
var(Decal) float Width;
var(Decal) float Height;
var(Decal) float TileX;
var(Decal) float TileY;
var(Decal) float OffsetX;
var(Decal) float OffsetY;
var(Decal) float DecalRotation;
var float FieldOfView;
var(Decal) float NearPlane;
var(Decal) float FarPlane;
var editinline transient export PrimitiveComponent HitComponent;
var transient int HitNodeIndex;
var transient int HitLevelIndex;
var transient int FracturedStaticMeshComponentIndex;
var(DecalRender) float DepthBias;
var(DecalRender) float SlopeScaleDepthBias;
var(DecalRender) int SortOrder;
var(DecalRender) float BackfaceAngle;
var(Decal) bool bNoClip;
var const bool bStaticDecal;
var(DecalFilter) bool bProjectOnBackfaces;
var(DecalFilter) bool bProjectOnHidden;
var(DecalFilter) bool bProjectOnBSP;
var(DecalFilter) bool bProjectOnStaticMeshes;
var(DecalFilter) bool bProjectOnSkeletalMeshes;
var(DecalFilter) bool bProjectOnTerrain;
var bool bFlipBackfaceDirection;
var bool bMovableDecal;
var transient bool bHasBeenAttached;
var const EDecalTransform DecalTransform;
var(DecalFilter) EFilterMode FilterMode;

public final native function MaterialInterface GetDecalMaterial();

public final native function ResetToDefaults();

public final native function SetDecalMaterial(MaterialInterface NewDecalMaterial);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendRange = {X = 89.5, Y = 180.0}
    Width = 200.0
    Height = 200.0
    TileX = 1.0
    TileY = 1.0
    FieldOfView = 80.0
    FarPlane = 300.0
    HitNodeIndex = -1
    HitLevelIndex = -1
    DepthBias = -0.0000599999985
    BackfaceAngle = 0.00999999978
    bProjectOnBSP = TRUE
    bProjectOnStaticMeshes = TRUE
    bProjectOnSkeletalMeshes = TRUE
    bProjectOnTerrain = TRUE
    DecalTransform = EDecalTransform.DecalTransform_SpawnRelative
    ReplacementPrimitive = None
    bAcceptsDynamicDecals = FALSE
    bCastDynamicShadow = FALSE
    bAcceptsDynamicLights = FALSE
}