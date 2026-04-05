Class PrimitiveComponent extends ActorComponent
    native
    noexport
    abstract;

enum ERadialImpulseFalloff
{
    RIF_Constant,
    RIF_Linear,
};
enum GJKResult
{
    GJK_Intersect,
    GJK_NoIntersection,
    GJK_Fail,
};
struct RBCollisionChannelContainer 
{
    var(RBCollisionChannelContainer) const bool Default;
    var const bool Nothing;
    var(RBCollisionChannelContainer) const bool Pawn;
    var(RBCollisionChannelContainer) const bool Vehicle;
    var(RBCollisionChannelContainer) const bool Water;
    var(RBCollisionChannelContainer) const bool GameplayPhysics;
    var(RBCollisionChannelContainer) const bool EffectPhysics;
    var(RBCollisionChannelContainer) const bool Untitled1;
    var(RBCollisionChannelContainer) const bool Untitled2;
    var(RBCollisionChannelContainer) const bool Untitled3;
    var(RBCollisionChannelContainer) const bool Untitled4;
    var(RBCollisionChannelContainer) const bool Cloth;
    var(RBCollisionChannelContainer) const bool FluidDrain;
    var(RBCollisionChannelContainer) const bool SoftBody;
    var(RBCollisionChannelContainer) const bool FracturedMeshPart;
    var(RBCollisionChannelContainer) const bool BlockingVolume;
    var(RBCollisionChannelContainer) const bool DeadPawn;
};
enum ERBCollisionChannel
{
    RBCC_Default,
    RBCC_Nothing,
    RBCC_Pawn,
    RBCC_Vehicle,
    RBCC_Water,
    RBCC_GameplayPhysics,
    RBCC_EffectPhysics,
    RBCC_Untitled1,
    RBCC_Untitled2,
    RBCC_Untitled3,
    RBCC_Untitled4,
    RBCC_Cloth,
    RBCC_FluidDrain,
    RBCC_SoftBody,
    RBCC_FracturedMeshPart,
    RBCC_BlockingVolume,
    RBCC_DeadPawn,
    RBCC_Clothing,
    RBCC_ClothingCollision,
};
struct MaterialViewRelevance 
{
    var bool bOpaque;
    var bool bTranslucent;
    var bool bDistortion;
    var bool bOneLayerDistortionRelevance;
    var bool bLit;
    var bool bUsesSceneColor;
};

var const transient native int Tag;
var const transient native BoxSphereBounds Bounds;
var const transient native Pointer SceneInfo;
var const native int DetachFence;
var const transient native float LocalToWorldDeterminant;
var const transient native Matrix LocalToWorld;
var const transient native int MotionBlurInfoIndex;
var const native noimport array<Pointer> DecalList;
var const editinline transient export array<DecalComponent> DecalsToReattach;
var const editinline export PrimitiveComponent ShadowParent;
var(Rendering) editinline export crosslevelpassive PrimitiveComponent ReplacementPrimitive;
var const editinline transient export FogVolumeDensityComponent FogVolumeComponent;
var const editinline export LightEnvironmentComponent LightEnvironment;
var const editinline transient export LightEnvironmentComponent PreviousLightEnvironment;
var(Rendering) float MinDrawDistance;
var(Rendering) float MassiveLODDistance;
var(Rendering) const noexport float MaxDrawDistance;
var(Rendering) editconst float CachedMaxDrawDistance;
var(Rendering) const ESceneDepthPriorityGroup DepthPriorityGroup;
var const ESceneDepthPriorityGroup ViewOwnerDepthPriorityGroup;
var(Rendering) const EDetailMode DetailMode;
var(Collision) const ERBCollisionChannel RBChannel;
var(Physics) byte RBDominanceGroup;
var(Rendering) float MotionBlurScale;
var const bool bUseViewOwnerDepthPriorityGroup;
var(Rendering) const bool bAllowCullDistanceVolume;
var(Rendering) const bool HiddenGame;
var(Rendering) const bool HiddenEditor;
var(Rendering) const bool bOwnerNoSee;
var(Rendering) const bool bOnlyOwnerSee;
var(Rendering) const bool bIgnoreOwnerHidden;
var bool bUseAsOccluder;
var(Rendering) bool bAllowApproximateOcclusion;
var bool bFirstFrameOcclusion;
var bool bIgnoreNearPlaneIntersection;
var bool bSelectable;
var(Rendering) const bool bForceMipStreaming;
var(Rendering) const bool bAcceptsStaticDecals;
var(Rendering) const bool bAcceptsDynamicDecals;
var const transient native bool bIsRefreshingDecals;
var transient native bool bAllowDecalAutomaticReAttach;
var(Rendering) const bool bAcceptsFoliage;
var(Lighting) bool CastShadow;
var(Lighting) const bool bForceDirectLightMap;
var(Lighting) bool bCastDynamicShadow;
var(Lighting) bool bSelfShadowOnly;
var(Lighting) bool bAcceptsDynamicDominantLightShadows;
var(Lighting) bool bCastHiddenShadow;
var(Lighting) const bool bAcceptsLights;
var(Lighting) const bool bAcceptsDynamicLights;
var(Lighting) const bool bUseOnePassLightingOnTranslucency;
var(Lighting) const bool bUsePrecomputedShadows;
var const transient bool bHasExplicitShadowParent;
var(Lighting) bool bCullModulatedShadowOnBackfaces;
var(Lighting) bool bCullModulatedShadowOnEmissive;
var(Lighting) bool bAllowAmbientOcclusion;
var(Lighting) const bool bBioForcePrecomputedShadows;
var const bool CollideActors;
var const bool AlwaysCheckCollision;
var const bool BlockActors;
var const bool BlockZeroExtent;
var const bool BlockNonZeroExtent;
var(Collision) const bool CanBlockCamera;
var(Collision) const bool BlockRigidBody;
var(Physics) const bool bDisableAllRigidBody;
var(Physics) const bool bSkipRBGeomCreation;
var(Physics) const bool bNotifyRigidBodyCollision;
var(Physics) const bool bFluidDrain;
var(Physics) const bool bFluidTwoWay;
var(Physics) bool bIgnoreRadialImpulse;
var(Physics) bool bIgnoreRadialForce;
var(Physics) bool bIgnoreForceField;
var(Physics) const bool bUseCompartment;
var const bool AlwaysLoadOnClient;
var const bool AlwaysLoadOnServer;
var(PrimitiveComponent) bool bIgnoreHiddenActorsMembership;
var(PrimitiveComponent) const bool AbsoluteTranslation;
var(PrimitiveComponent) const bool AbsoluteRotation;
var(PrimitiveComponent) const bool AbsoluteScale;
var(Lighting) bool bAllowShadowFade;
var const transient native bool bUmbraUpdated;
var const transient native bool bWasSNFiltered;
var const transient native array<int> OctreeNodes;
var(Rendering) int TranslucencySortPriority;
var(Rendering) int LocalTranslucencySortPriority;
var(Lighting) const LightingChannelContainer LightingChannels;
var(Collision) const RBCollisionChannelContainer RBCollideWithChannels;
var(Physics) const PhysicalMaterial PhysMaterialOverride;
var const native duplicatetransient RB_BodyInstance BodyInstance;
var const transient native Matrix CachedParentToWorld;
var(PrimitiveComponent) const Vector Translation;
var(PrimitiveComponent) const Rotator Rotation;
var(PrimitiveComponent) const float Scale;
var(PrimitiveComponent) const Vector Scale3D;
var const transient float LastSubmitTime;
var transient float LastRenderTime;
var const transient native Pointer UmbraObjectHandle;
var transient native int UmbraCameraMask;
var float ScriptRigidBodyCollisionThreshold;

public native function AddForce(Vector Force, optional Vector Position, optional Name BoneName);

public native function AddImpulse(Vector impulse, optional Vector Position, optional Name BoneName, optional bool bVelChange);

public native function AddRadialForce(Vector Origin, float Radius, float Strength, ERadialImpulseFalloff Falloff);

public native function AddRadialImpulse(Vector Origin, float Radius, float Strength, ERadialImpulseFalloff Falloff, optional bool bVelChange);

public final native function AddTorque(Vector Torque, optional Name BoneName);

public native function GJKResult ClosestPointOnComponentToComponent(out PrimitiveComponent OtherComponent, out Vector PointOnComponentA, out Vector PointOnComponentB);

public final native function GJKResult ClosestPointOnComponentToPoint(out Vector POI, out Vector Extent, out Vector OutPointA, out Vector OutPointB);

public final function Vector GetPosition()
{
    local Vector Position;
    
    Position.X = LocalToWorld.WPlane.X;
    Position.Y = LocalToWorld.WPlane.Y;
    Position.Z = LocalToWorld.WPlane.Z;
    return Position;
}
public final native function RB_BodyInstance GetRootBodyInstance();

public final native function Rotator GetRotation();

public final native function InitRBPhys();

public final native function PutRigidBodyToSleep(optional Name BoneName);

public final native function RetardRBLinearVelocity(Vector RetardDir, float VelScale);

public final native function bool RigidBodyIsAwake(optional Name BoneName);

public native function SetAbsolute(optional bool NewAbsoluteTranslation, optional bool NewAbsoluteRotation, optional bool NewAbsoluteScale);

public final native function SetActorCollision(bool NewCollideActors, bool NewBlockActors, optional bool NewAlwaysCheckCollision);

public final native function SetBlockRigidBody(bool bNewBlockRigidBody);

public final native function SetCullDistance(float NewCullDistance);

public final native function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup);

public final native function SetHidden(bool NewHidden);

public final native function SetHiddenEditor(bool NewHidden);

public final native function SetIgnoreOwnerHidden(bool bNewIgnoreOwnerHidden);

public final native function SetLightEnvironment(LightEnvironmentComponent NewLightEnvironment);

public final native function SetLightingChannels(LightingChannelContainer NewLightingChannels);

public final native function SetNotifyRigidBodyCollision(bool bNewNotifyRigidBodyCollision);

public final native function SetOnlyOwnerSee(bool bNewOnlyOwnerSee);

public final native function SetOwnerNoSee(bool bNewOwnerNoSee);

public final native function SetPhysMaterialOverride(PhysicalMaterial NewPhysMaterial);

public final native function SetRBAngularVelocity(Vector NewAngVel, optional bool bAddToCurrent);

public final native function SetRBChannel(ERBCollisionChannel Channel);

public final native function SetRBCollidesWithChannel(ERBCollisionChannel Channel, bool bNewCollides);

public final native function SetRBCollisionChannels(RBCollisionChannelContainer Channels);

public final native function SetRBDominanceGroup(byte InDomGroup);

public final native function SetRBLinearVelocity(Vector NewVel, optional bool bAddToCurrent);

public final native function SetRBPosition(Vector NewPos, optional Name BoneName);

public final native function SetRBRotation(Rotator NewRot, optional Name BoneName);

public native function SetRotation(Rotator NewRotation);

public native function SetScale(float NewScale);

public native function SetScale3D(Vector NewScale3D);

public final native function SetShadowParent(PrimitiveComponent NewShadowParent);

public final native function SetTraceBlocking(bool NewBlockZeroExtent, bool NewBlockNonZeroExtent);

public native function SetTranslation(Vector NewTranslation);

public final native function SetViewOwnerDepthPriorityGroup(bool bNewUseViewOwnerDepthPriorityGroup, ESceneDepthPriorityGroup NewViewOwnerDepthPriorityGroup);

public final native function bool ShouldComponentAddToScene();

public final native function WakeRigidBody(optional Name BoneName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
    DepthPriorityGroup = ESceneDepthPriorityGroup.SDPG_World
    RBDominanceGroup = 15
    MotionBlurScale = 1.0
    bAllowCullDistanceVolume = TRUE
    bSelectable = TRUE
    bAcceptsDynamicDecals = TRUE
    bAcceptsFoliage = TRUE
    bCastDynamicShadow = TRUE
    bAcceptsDynamicDominantLightShadows = TRUE
    bAcceptsDynamicLights = TRUE
    bAllowAmbientOcclusion = TRUE
    CanBlockCamera = TRUE
    AlwaysLoadOnClient = TRUE
    AlwaysLoadOnServer = TRUE
    bAllowShadowFade = TRUE
    Scale = 1.0
    Scale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    LastRenderTime = -1000.0
    ComponentType = EComponentType.COMPONENT_Gameplay
}