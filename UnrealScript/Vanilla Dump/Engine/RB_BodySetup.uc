Class RB_BodySetup extends KMeshProps
    native;

struct KCachedConvexData 
{
    var native array<KCachedConvexDataElement> CachedConvexElements;
};
struct KCachedConvexDataElement 
{
    var native array<byte> ConvexElementData;
};
enum ESleepFamily
{
    SF_Normal,
    SF_Sensitive,
};
enum EBioPartGroup
{
    BIOPARTGROUP_NONE,
    BIOPARTGROUP_INHERIT_FROM_PARENT,
    BIOPARTGROUP_HEAD,
    BIOPARTGROUP_LEFT_LEG,
    BIOPARTGROUP_RIGHT_LEG,
    BIOPARTGROUP_LEFT_ARM,
    BIOPARTGROUP_RIGHT_ARM,
    BIOPARTGROUP_TORSO,
    BIOPARTGROUP_SPECIAL,
};

var const native array<Pointer> CollisionGeom;
var const native array<Vector> CollisionGeomScale3D;
var const native array<KCachedConvexData> PreCachedPhysData;
var(RB_BodySetup) const array<Vector> PreCachedPhysScale;
var(RB_BodySetup) editconst Name BoneName;
var(RB_BodySetup) PhysicalMaterial PhysMaterial;
var(RB_BodySetup) float MassScale;
var const int PreCachedPhysDataVersion;
var(RB_BodySetup) bool bFixed;
var(RB_BodySetup) bool bNoCollision;
var(RB_BodySetup) bool bBlockZeroExtent;
var(RB_BodySetup) bool bBlockNonZeroExtent;
var(RB_BodySetup) bool bEnableContinuousCollisionDetection;
var(RB_BodySetup) bool bAlwaysFullAnimWeight;
var(RB_BodySetup) bool bConsiderForBounds;
var(PartBasedDamage) EBioPartGroup ePartGroup;
var(RB_BodySetup) ESleepFamily SleepFamily;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MassScale = 1.0
    bBlockZeroExtent = TRUE
    bBlockNonZeroExtent = TRUE
    bConsiderForBounds = TRUE
}