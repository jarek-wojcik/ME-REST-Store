Class PhysXDestructibleStructure
    native;

struct native PhysXDestructibleOverlap 
{
    var int ChunkIndex0;
    var int ChunkIndex1;
    var int Adjacent;
};
struct native PhysXDestructibleChunk 
{
    var Matrix RelativeMatrix;
    var Matrix WorldMatrix;
    var native Pointer Structure;
    var Vector RelativeCentroid;
    var Vector WorldCentroid;
    var Name BoneName;
    var int ActorIndex;
    var int FragmentIndex;
    var int Index;
    var int MeshIndex;
    var int BoneIndex;
    var int BodyIndex;
    var float Radius;
    var int ParentIndex;
    var int FirstChildIndex;
    var int NumChildren;
    var int Depth;
    var float Age;
    var float Damage;
    var float Size;
    var native int FIFOIndex;
    var int FirstOverlapIndex;
    var int NumOverlaps;
    var int ShortestRoute;
    var int NumSupporters;
    var int NumChildrenDup;
    var bool WorldCentroidValid;
    var bool WorldMatrixValid;
    var bool bCrumble;
    var bool IsEnvironmentSupported;
    var bool IsRouting;
    var bool IsRouteValid;
    var bool IsRouteBlocker;
    var EPhysXDestructibleChunkState CurrentState;
};
enum EPhysXDestructibleChunkState
{
    DCS_StaticRoot,
    DCS_StaticChild,
    DCS_DynamicRoot,
    DCS_DynamicChild,
    DCS_Hidden,
};

var transient native array<PhysXDestructibleActor> Actors;
var transient native array<PhysXDestructibleActor> ActorKillList;
var transient native array<PhysXDestructibleChunk> Chunks;
var transient native array<PhysXDestructibleOverlap> Overlaps;
var transient native array<int> Active;
var transient native array<int> PseudoSupporterFifo;
var transient native array<int> FractureOriginFifo;
var transient native array<int> FractureOriginChunks;
var transient native array<int> RouteUpdateArea;
var transient native array<int> PassiveFractureChunks;
var transient native array<int> RouteUpdateFifo;
var native Pointer Manager;
var transient native int PseudoSupporterFifoStart;
var transient native int FractureOriginFifoStart;
var const transient native int PerFrameProcessBudget;
var transient native int RouteUpdateFifoStart;
var transient native int SupportDepth;

public native function CrumbleChunk(int ChunkIndex);

public native function bool DamageChunk(int ChunkIndex, Vector Point, float BaseDamage, float Radius, bool bFullDamage, float DamageFalloffExp, out array<int> Output);

public native function FractureChunk(int ChunkIndex, Vector Point, Vector impulse, bool bInheritRootVel);

public native function Vector GetChunkCentroid(int ChunkIndex);

public native function Matrix GetChunkMatrix(int ChunkIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}