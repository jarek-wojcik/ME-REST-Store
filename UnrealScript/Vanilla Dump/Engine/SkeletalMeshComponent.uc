Class SkeletalMeshComponent extends MeshComponent
    native
    noexport
    editinlinenew;

struct BoneDrivenMaterialParameter 
{
    var int MaterialSlot;
    var Name ParameterName;
    var Name BoneName;
    var bool LocalSpace;
    var int Axis;
};
enum EPhysBodyOp
{
    PBO_None,
    PBO_Term,
    PBO_Disable,
};
struct native BoneOverrideInfo 
{
    var int BoneIndex;
    var Vector Position;
    var Quat Orientation;
    var Matrix BasesInvMatrix;
};
enum EFaceFXRegOp
{
    FXRO_Add,
    FXRO_Multiply,
    FXRO_Replace,
};
enum EFaceFXBlendMode
{
    FXBM_Overwrite,
    FXBM_Additive,
};
enum ERootMotionRotationMode
{
    RMRM_Ignore,
    RMRM_RotateActor,
};
enum ERootMotionMode
{
    RMM_Translate,
    RMM_Velocity,
    RMM_Ignore,
    RMM_Accel,
    RMM_Relative,
};
struct BonePair 
{
    var Name Bones[2];
};
struct BioActorAttach 
{
    var Actor Attachment;
    var Vector RelativeOffset;
    var Rotator RelativeRotation;
    var Name BoneName;
    var bool bDetach;
    var bool bHardAttach;
    var bool bUseRelativeOffset;
    var bool bUseRelativeRotation;
};
struct BioActorReBase 
{
    var Actor ActorToReBase;
    var Actor NewBase;
    var editinline export SkeletalMeshComponent SkelComponent;
    var Vector NewFloor;
    var Name AttachName;
    var bool bNotifyActor;
};
struct Attachment 
{
    var(Attachment) editinline export ActorComponent Component;
    var(Attachment) Name BoneName;
    var(Attachment) Vector RelativeLocation;
    var(Attachment) Rotator RelativeRotation;
    var(Attachment) Vector RelativeScale;
    
    structdefaultproperties
    {
        RelativeScale = {X = 1.0, Y = 1.0, Z = 1.0}
    }
};
struct ActiveMorph 
{
    var MorphTarget Target;
    var float Weight;
};
struct AnimTickEntry 
{
    var AnimNode Node;
    var float TotalWeight;
    var float TotalWeightAccumulator;
    var bool bRelevant;
    var bool bBioNeedTickingCompleteCall;
    var bool bSkipTickWhenZeroWeight;
    var bool bTickDuringPausedAnims;
};

var(SkeletalMeshComponent) SkeletalMesh SkeletalMesh;
var editinline export SkeletalMeshComponent AttachedToSkelComponent;
var(SkeletalMeshComponent) const AnimTree AnimTreeTemplate;
var(SkeletalMeshComponent) const export AnimNode Animations;
var const transient array<AnimTickEntry> AnimTickArray;
var(SkeletalMeshComponent) const PhysicsAsset PhysicsAsset;
var const transient export PhysicsAssetInstance PhysicsAssetInstance;
var(SkeletalMeshComponent) transient native Pointer ApexClothing;
var(SkeletalMeshComponent) interp float PhysicsWeight;
var(SkeletalMeshComponent) float GlobalAnimRateScale;
var const transient native Pointer MeshObject;
var(SkeletalMeshComponent) Color WireframeColor;
var const transient native array<Matrix> SpaceBases;
var const transient native array<BoneAtom> LocalAtoms;
var const transient native array<byte> RequiredBones;
var const transient native array<byte> ComposeOrderedRequiredBones;
var const transient native int ComposeOrderedRequiredBonesSkelControlIndex;
var const transient native array<int> PhysicsBodySetupToBoneIndex;
var(SkeletalMeshComponent) const editinline export SkeletalMeshComponent ParentAnimComponent;
var const transient array<int> ParentBoneMap;
var(SkeletalMeshComponent) array<AnimSet> AnimSets;
var const transient native array<AnimSet> TemporarySavedAnimSets;
var(SkeletalMeshComponent) array<MorphTargetSet> MorphSets;
var transient array<ActiveMorph> ActiveMorphs;
var transient array<ActiveMorph> ActiveCurveMorphs;
var const native Object MorphTargetIndexMap;
var const editinline duplicatetransient array<Attachment> Attachments;
var const transient array<byte> SkelControlIndex;
var const transient array<byte> PostPhysSkelControlIndex;
var(SkeletalMeshComponent) int ForcedLodModel;
var(SkeletalMeshComponent) int MinLodModel;
var int PredictedLODLevel;
var int OldPredictedLODLevel;
var const float MaxDistanceFactor;
var int bForceWireframe;
var int bForceRefpose;
var int bOldForceRefPose;
var(SkeletalMeshComponent) bool bNoSkeletonUpdate;
var int bDisplayBones;
var int bShowPrePhysBones;
var int bHideSkin;
var int bForceRawOffset;
var int bIgnoreControllers;
var int bTransformFromAnimParent;
var const transient int TickTag;
var const transient int CachedAtomsTag;
var const int bUseSingleBodyPhysics;
var transient int bRequiredBonesUpToDate;
var float MinDistFactorForKinematicUpdate;
var transient int FramesPhysicsAsleep;
var bool bSkipAllUpdateWhenPhysicsAsleep;
var(SkeletalMeshComponent) bool bConsiderAllBodiesForBounds;
var(SkeletalMeshComponent) bool bUpdateSkelWhenNotRendered;
var bool bIgnoreControllersWhenNotRendered;
var bool bTickAnimNodesWhenNotRendered;
var const bool bNotUpdatingKinematicDueToDistance;
var(SkeletalMeshComponent) bool bForceDiscardRootMotion;
var bool bRootMotionModeChangeNotify;
var bool bRootMotionExtractedNotify;
var(SkeletalMeshComponent) bool bDisableFaceFXMaterialInstanceCreation;
var const transient bool bAnimTreeInitialised;
var transient bool bAnimSetUpdated;
var transient bool bForceMeshObjectUpdate;
var(SkeletalMeshComponent) const bool bHasPhysicsAssetInstance;
var(SkeletalMeshComponent) bool bUpdateKinematicBonesFromAnimation;
var(SkeletalMeshComponent) bool bUpdateJointsFromAnimation;
var const bool bSkelCompFixed;
var const bool bHasHadPhysicsBlendedIn;
var(SkeletalMeshComponent) bool bForceUpdateAttachmentsInTick;
var transient bool bEnableFullAnimWeightBodies;
var(SkeletalMeshComponent) bool bPerBoneVolumeEffects;
var(SkeletalMeshComponent) bool bSyncActorLocationToRootRigidBody;
var const bool bUseRawData;
var bool bDisableWarningWhenAnimNotFound;
var bool bOverrideAttachmentOwnerVisibility;
var const transient bool bNeedsToDeleteHitMask;
var const transient bool bBioComputedValidPose;
var const transient bool bBioAllowResubmitPose;
var bool bPauseAnims;
var bool bChartDistanceFactor;
var bool bEnableLineCheckWithBounds;
var bool bIsFrozen;
var transient bool bFrozenMeshProcessed;
var transient bool bMeshShouldBeFrozen;
var Vector LineCheckBoundsScale;
var const editinline transient array<BioActorReBase> BioActorsToReBase;
var const transient array<BioActorAttach> BioActorsToAttach;
var(Cloth) const bool bEnableClothSimulation;
var(Cloth) const bool bDisableClothCollision;
var(Cloth) const bool bClothFrozen;
var(Cloth) bool bAutoFreezeClothWhenNotRendered;
var(Cloth) bool bClothAwakeOnStartup;
var(Cloth) bool bClothBaseVelClamp;
var(Cloth) bool bClothBaseVelInterp;
var(Cloth) bool bAttachClothVertsToBaseBody;
var(Cloth) bool bIsClothOnStaticObject;
var bool bUpdatedFixedClothVerts;
var(Cloth) bool bClothPositionalDampening;
var(Cloth) bool bClothWindRelativeToOwner;
var bool bRecentlyRendered;
var bool bCacheAnimSequenceNodes;
var bool bAlwaysUpdateMeshObject;
var const transient bool bNeedsInstanceWeightUpdate;
var const transient bool bAlwaysUseInstanceWeights;
var const transient bool bUpdateComposeSkeletonPasses;
var const transient array<bool> HiddenMaterials;
var const transient native array<BonePair> InstanceVertexWeightBones;
var const Vector FrozenLocalToWorldPos;
var const Rotator FrozenLocalToWorldRot;
var(Cloth) const Vector ClothExternalForce;
var(Cloth) Vector ClothWind;
var(Cloth) Vector ClothBaseVelClampRange;
var(Cloth) float ClothBlendWeight;
var float ClothDynamicBlendWeight;
var(Cloth) float ClothBlendMinDistanceFactor;
var(Cloth) float ClothBlendMaxDistanceFactor;
var(Cloth) Vector MinPosDampRange;
var(Cloth) Vector MaxPosDampRange;
var(Cloth) Vector MinPosDampScale;
var(Cloth) Vector MaxPosDampScale;
var const transient native Pointer ClothSim;
var const transient native int SceneIndex;
var const array<Vector> ClothMeshPosData;
var const array<Vector> ClothMeshNormalData;
var const array<int> ClothMeshIndexData;
var int NumClothMeshVerts;
var int NumClothMeshIndices;
var const array<int> ClothMeshParentData;
var int NumClothMeshParentIndices;
var const transient native array<Vector> ClothMeshWeldedPosData;
var const transient native array<Vector> ClothMeshWeldedNormalData;
var const transient native array<int> ClothMeshWeldedIndexData;
var int ClothDirtyBufferFlag;
var(Cloth) const ERBCollisionChannel ClothRBChannel;
var(Cloth) const RBCollisionChannelContainer ClothRBCollideWithChannels;
var(Cloth) const float ClothForceScale;
var(Cloth) float ClothImpulseScale;
var(Cloth) const float ClothAttachmentTearFactor;
var(Cloth) const bool bClothUseCompartment;
var(Cloth) const float MinDistanceForClothReset;
var const transient Vector LastClothLocation;
var const transient native Pointer SoftBodySim;
var const transient native int SoftBodySceneIndex;
var(SoftBody) const bool bEnableSoftBodySimulation;
var const array<Vector> SoftBodyTetraPosData;
var const array<int> SoftBodyTetraIndexData;
var int NumSoftBodyTetraVerts;
var int NumSoftBodyTetraIndices;
var(SoftBody) float SoftBodyImpulseScale;
var(SoftBody) const bool bSoftBodyFrozen;
var(SoftBody) bool bAutoFreezeSoftBodyWhenNotRendered;
var(SoftBody) bool bSoftBodyAwakeOnStartup;
var(SoftBody) const bool bSoftBodyUseCompartment;
var(SoftBody) const ERBCollisionChannel SoftBodyRBChannel;
var(SoftBody) const RBCollisionChannelContainer SoftBodyRBCollideWithChannels;
var const transient native Pointer SoftBodyASVPlane;
var Material LimitMaterial;
var const transient BoneAtom RootMotionDelta;
var transient Vector RootMotionVelocity;
var const transient Vector RootBoneTranslation;
var Vector RootMotionAccelScale;
var(SkeletalMeshComponent) ERootMotionMode RootMotionMode;
var const ERootMotionMode PreviousRMM;
var ERootMotionMode PendingRMM;
var ERootMotionMode OldPendingRMM;
var const int bRMMOneFrameDelay;
var(SkeletalMeshComponent) ERootMotionRotationMode RootMotionRotationMode;
var(SkeletalMeshComponent) EFaceFXBlendMode FaceFXBlendMode;
var transient native Pointer FaceFXActorInstance;
var transient int bFaceFXDisabled;
var float FaceFXTimer;
var const transient native array<BoneAtom> FaceBlendAtoms;
var const transient native array<float> MaterialBlendValues;
var transient bool bDoClipToClipBlend;
var transient bool bNotThisFrame;
var transient bool bSetNotThisFrame;
var transient bool bBioFaceFXOpenInMatinee;
var transient float FaceBlendTimer;
var transient float FaceBlendSpeed;
var transient float FaceBlendInterpolator;
var bool bOverrideParentSkeleton;
var Name nmOverrideStartBoneName;
var transient array<BoneOverrideInfo> OverrideBones;
var int MinAutoLODLevel;
var editinline export AudioComponent CachedFaceFXAudioComp;
var const transient array<byte> BoneVisibility;
var const transient BoneAtom LocalToWorldBoneAtom;
var transient float ProgressiveDrawingFraction;
var const transient WwiseBaseSoundObject WwiseSound;
var transient array<BoneDrivenMaterialParameter> BoneMaterialDrivers;
var bool m_bBioAreRigidBodiesAwake;
var transient bool bCachedRootBodyOffset;
var transient Matrix RootBodyOffsetInvTM;
var transient native bool m_bStopFaceFXAnim;
var transient Matrix WoundEllipse[2];
var transient FaceFXAsset m_pBioFaceFXAsset;
var transient native array<byte> m_aBioFFXBoneMap;
var transient bool m_bBioFFXShouldRelinkBoneMap;
var(Rendering) bool bSupportsLowDetailProxyRendering;
var transient int LowDetailLODIndex;

public final native function AddInstanceVertexWeightBoneParented(Name BoneName, optional bool bPairWithParent = TRUE);

public final iterator native function AllAnimNodes(Class<AnimNode> BaseClass, out AnimNode Node);

public final simulated native function AttachClothToCollidingShapes(bool AttatchTwoWay, bool AttachTearable);

public final native function AttachComponent(ActorComponent Component, Name BoneName, optional Vector RelativeLocation, optional Rotator RelativeRotation, optional Vector RelativeScale);

public final native function AttachComponentToSocket(ActorComponent Component, Name SocketName);

public final iterator native function AttachedComponents(Class<ActorComponent> BaseClass, out ActorComponent OutComponent);

public final native function bool BioComputeAttachedComponentPositionRotation(ActorComponent Component, out Vector Position, out Rotator Orientation, optional Name BoneName);

public final native function BioEnableFaceFX(bool bEnable);

public final native function BioFindClosestBones(Vector vTestLocation, out array<Name> BoneNames, float fRadius, optional bool bOutsideRadius);

public final native function string BioGetDetails();

public final native function bool BoneIsChildOf(Name BoneName, Name ParentBoneName);

public final native function CalculateRootBodyOffsetInvTM();

public final native function DeclareFaceFXRegister(string RegName);

public final native function DetachComponent(ActorComponent Component);

public final simulated native function EnableClothValidBounds(bool IfEnableClothValidBounds);

public final native function AnimNode FindAnimNode(Name InNodeName);

public final native function AnimSequence FindAnimSequence(Name AnimSeqName);

public final native function RB_BodyInstance FindBodyInstanceNamed(Name BoneName);

public final native function Name FindClosestBone(Vector TestLocation, optional out Vector BoneLocation, optional float IgnoreScale);

public final native function ActorComponent FindComponentAttachedToBone(Name InBoneName);

public final native function Name FindConstraintBoneName(int ConstraintIndex);

public final native function int FindConstraintIndex(Name ConstraintName);

public final native function int FindInstanceVertexweightBonePair(BonePair Bones);

public final native function MorphNodeBase FindMorphNode(Name InNodeName);

public final native function MorphTarget FindMorphTarget(Name MorphTargetName);

public final native function SkelControlBase FindSkelControl(Name InControlName);

public final native function ForceSkelUpdate();

public final simulated native function FaceFXAsset GetBioFaceFXAsset();

public final native function Vector GetBoneAxis(Name BoneName, EAxis Axis);

public final native function Vector GetBoneLocation(Name BoneName, optional int Space);

public final native function Matrix GetBoneMatrix(int BoneIndex);

public final native function Name GetBoneName(int BoneIndex);

public final native function GetBoneNames(out array<Name> BoneNames);

public final native function Quat GetBoneQuaternion(Name BoneName, optional int Space);

public final native function bool GetBonesWithinRadius(Vector Origin, float Radius, int TraceFlags, out array<Name> out_Bones);

public final native function Vector GetClosestCollidingBoneLocation(Vector TestLocation, bool bCheckZeroExtent, bool bCheckNonZeroExtent);

public final simulated native function float GetClothAttachmentResponseCoefficient();

public final simulated native function float GetClothAttachmentTearFactor();

public final simulated native function float GetClothBendingStiffness();

public final simulated native function float GetClothCollisionResponseCoefficient();

public final simulated native function float GetClothDampingCoefficient();

public final simulated native function int GetClothFlags();

public final simulated native function float GetClothFriction();

public final simulated native function float GetClothPressure();

public final simulated native function float GetClothSleepLinearVelocity();

public final simulated native function int GetClothSolverIterations();

public final simulated native function float GetClothStretchingStiffness();

public final simulated native function float GetClothTearFactor();

public final simulated native function float GetClothThickness();

public final native function float GetFaceFXRegister(string RegName);

public final native function Name GetParentBone(Name BoneName);

public final native function int GetParentBoneIndex(int BoneIndex);

public final native function Vector GetRefPosePosition(int BoneIndex);

public final native function Name GetSocketBoneName(Name InSocketName);

public final native function SkeletalMeshSocket GetSocketByName(Name InSocketName);

public final native function bool GetSocketWorldLocationAndRotation(Name InSocketName, out Vector OutLocation, optional out Rotator OutRotation, optional int Space);

public final native function HideBone(int BoneIndex, EPhysBodyOp PhysBodyOption);

public final native function HideBoneByName(Name BoneName, EPhysBodyOp PhysBodyOption);

public final native function InitMorphTargets();

public final native function InitSkelControls();

public final native function bool IsBoneHidden(int BoneIndex);

public final native function bool IsComponentAttached(ActorComponent Component, optional Name BoneName);

public final native function bool IsFrozen();

public final native function bool IsPlayingFaceFXAnim(optional Name nmAnimName);

public final native function int MatchRefBone(Name BoneName);

public function PlayAnim(Name AnimName, optional float Duration, optional bool bLoop, optional bool bRestartIfAlreadyPlaying = TRUE, optional float StartTime = 0.0, optional bool bPlayBackwards = FALSE)
{
    local AnimNodeSequence AnimNode;
    local float DesiredRate;
    
    AnimNode = AnimNodeSequence(Animations);
    if (AnimNode == None && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    if (AnimNode == None)
    {
    }
    else if (AnimNode.AnimSeq != None && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        DesiredRate = Duration > 0.0 ? AnimNode.AnimSeq.SequenceLength / Duration : 1.0;
        DesiredRate = bPlayBackwards ? -DesiredRate : DesiredRate;
        if (bRestartIfAlreadyPlaying || !AnimNode.bPlaying)
        {
            AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);
        }
        else
        {
            AnimNode.Rate = DesiredRate;
            AnimNode.bLooping = bLoop;
        }
    }
    else
    {
        AnimNode.SetAnim(AnimName);
        if (AnimNode.AnimSeq != None)
        {
            DesiredRate = Duration > 0.0 ? AnimNode.AnimSeq.SequenceLength / Duration : 1.0;
            DesiredRate = bPlayBackwards ? -DesiredRate : DesiredRate;
            AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);
        }
    }
}
public final native function bool PlayFaceFXAnim(FaceFXAnimSet FaceFXAnimSetRef, string AnimName, string GroupName, SoundCue SoundCueToPlay);

public event function PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
    local Vector Loc;
    local Rotator Rot;
    local ParticleSystemComponent PSC;
    
    if (AnimNotifyData.PSTemplate == None)
    {
        return;
    }
    if (AnimNotifyData.bIsExtremeContent == TRUE && Class'WorldInfo'.static.GetWorldInfo().GRI.ShouldShowGore() == FALSE)
    {
        return;
    }
    if (AnimNotifyData.bAttach == TRUE)
    {
        PSC = new (Self) Class'ParticleSystemComponent';
        PSC.SetTemplate(AnimNotifyData.PSTemplate);
        if (AnimNotifyData.SocketName != 'None')
        {
            AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
        }
        else if (AnimNotifyData.BoneName != 'None')
        {
            AttachComponent(PSC, AnimNotifyData.BoneName);
        }
        PSC.ActivateSystem(TRUE);
        PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
    }
    else
    {
        if (AnimNotifyData.SocketName != 'None')
        {
            GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);
        }
        else if (AnimNotifyData.BoneName != 'None')
        {
            Loc = GetBoneLocation(AnimNotifyData.BoneName);
            Rot = rot(0, 0, 1);
        }
        else
        {
            Loc = GetPosition();
            Rot = rot(0, 0, 1);
        }
        if (Owner != None && Owner.WorldInfo != None && Owner.WorldInfo.MyEmitterPool != None)
        {
            Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, Rot);
        }
        else if (Class'Engine'.static.IsGame() == TRUE)
        {
            PSC = new (Self) Class'ParticleSystemComponent';
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
            PSC.SetAbsolute(TRUE, TRUE, TRUE);
            PSC.SetTranslation(Loc);
            PSC.SetRotation(Rot);
            PSC.ActivateSystem(TRUE);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
        }
        else if (Class'Engine'.static.IsEditor() == TRUE)
        {
            PSC = new (Self) Class'ParticleSystemComponent';
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
            PSC.SetAbsolute(TRUE, TRUE, TRUE);
            PSC.SetTranslation(Loc);
            PSC.SetRotation(Rot);
            if (AnimNotifyData.SocketName != 'None')
            {
                AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
            }
            else if (AnimNotifyData.BoneName != 'None')
            {
                AttachComponent(PSC, AnimNotifyData.BoneName);
            }
            PSC.ActivateSystem(TRUE);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
        }
    }
}
public static final native function bool RefSkeletonsMatch(const SkeletalMesh SkelMeshA, const SkeletalMesh SkelMeshB);

public final native function RemoveInstanceVertexWeightBoneParented(Name BoneName);

public final simulated native function ResetClothVertsToRefPose();

public final native function RestoreSavedAnimSets();

public final native function SaveAnimSets();

public final native function SetAnimTreeTemplate(AnimTree NewTemplate);

public final simulated native function SetAttachClothVertsToBaseBody(bool bAttachVerts);

public final simulated native function SetClothAttachmentResponseCoefficient(float ClothAttachmentResponseCoefficient);

public final simulated native function SetClothAttachmentTearFactor(float ClothAttachTearFactor);

public final simulated native function SetClothBendingStiffness(float ClothBendingStiffness);

public final simulated native function SetClothCollisionResponseCoefficient(float ClothCollisionResponseCoefficient);

public final simulated native function SetClothDampingCoefficient(float ClothDampingCoefficient);

public final simulated native function SetClothExternalForce(Vector InForce);

public final simulated native function SetClothFlags(int ClothFlags);

public final simulated native function SetClothFriction(float ClothFriction);

public final simulated native function SetClothFrozen(bool bNewFrozen);

public final simulated native function SetClothPosition(Vector ClothOffSet);

public final simulated native function SetClothPressure(float ClothPressure);

public final simulated native function SetClothSleep(bool IfClothSleep);

public final simulated native function SetClothSleepLinearVelocity(float ClothSleepLinearVelocity);

public final simulated native function SetClothSolverIterations(int ClothSolverIterations);

public final simulated native function SetClothStretchingStiffness(float ClothStretchingStiffness);

public final simulated native function SetClothTearFactor(float ClothTearFactor);

public final simulated native function SetClothThickness(float ClothThickness);

public final simulated native function SetClothValidBounds(Vector ClothValidBoundsMin, Vector ClothValidBoundsMax);

public final simulated native function SetClothVelocity(Vector VelocityOffSet);

public final simulated native function SetEnableClothSimulation(bool bInEnable);

public final native function SetFaceFXRegister(string RegName, float RegVal, EFaceFXRegOp RegOp, optional float InterpDuration);

public final native function SetFaceFXRegisterEx(string RegName, EFaceFXRegOp RegOp, float FirstValue, float FirstInterpDuration, float NextValue, float NextInterpDuration);

public final simulated native function SetForceRefPose(bool bNewForceRefPose);

public final native function SetFrozen(bool bFrozen);

public final native function SetHasPhysicsAssetInstance(bool bHasInstance);

public final native function SetParentAnimComponent(SkeletalMeshComponent NewParentAnimComp);

public final simulated native function SetPhysicsAsset(PhysicsAsset NewPhysicsAsset, optional bool bForceReInit);

public final simulated native function SetSkeletalMesh(SkeletalMesh NewMesh, optional bool bKeepSpaceBases, optional bool InbAlwaysUseInstanceWeights);

public final simulated native function SetSoftBodyFrozen(bool bNewFrozen);

public final native function SFXFlushAsyncWork();

public final simulated native function ShowMaterialSection(int MaterialID, bool bShow);

public function StopAnim()
{
    local AnimNodeSequence AnimNode;
    
    AnimNode = AnimNodeSequence(Animations);
    if (AnimNode == None && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    if (AnimNode == None)
    {
    }
    else
    {
        AnimNode.StopAnim();
    }
}
public final native function StopFaceFXAnim(optional bool bBioRampDown = FALSE);

public final native function ToggleInstanceVertexWeights(bool bEnable);

public final native function TransformFromBoneSpace(Name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation);

public final native function TransformToBoneSpace(Name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation);

public final native function UnHideBone(int BoneIndex);

public final native function UnHideBoneByName(Name BoneName);

public final native function UpdateAnimations();

public final simulated native function UpdateClothParams();

public final native function UpdateInstanceVertexWeightBones(array<BonePair> BonePairs);

public final simulated native function UpdateMeshForBrokenConstraints();

public final native function UpdateParentBoneMap();

public final native function UpdateRBBonesFromSpaceBases(bool bMoveUnfixedBodies, bool bTeleport);

public final simulated native function UpdateSoftBodyParams();

public final simulated native function WakeSoftBody();

public simulated function SkelMeshCompOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    DetachComponent(PSC);
}
public final simulated function BreakConstraint(Vector impulse, Vector HitLocation, Name InBoneName, optional bool bVelChange)
{
    local int ConstraintIndex;
    local RB_ConstraintInstance Constraint;
    local RB_ConstraintSetup ConstraintSetup;
    local RB_BodyInstance Body;
    
    ConstraintIndex = FindConstraintIndex(InBoneName);
    if (ConstraintIndex == -1)
    {
        return;
    }
    Constraint = PhysicsAssetInstance.Constraints[ConstraintIndex];
    if (Constraint.bTerminated)
    {
        return;
    }
    ToggleInstanceVertexWeights(TRUE);
    AddInstanceVertexWeightBoneParented(InBoneName);
    ConstraintSetup = PhysicsAsset.ConstraintSetup[Constraint.ConstraintIndex];
    Body = FindBodyInstanceNamed(ConstraintSetup.JointName);
    if (Body != None && Body.IsFixed())
    {
        Body.SetFixed(FALSE);
    }
    Constraint.TermConstraint();
    UpdateMeshForBrokenConstraints();
    AddImpulse(impulse, HitLocation, InBoneName, bVelChange);
}
public final function float GetAnimLength(Name AnimSeqName)
{
    local AnimSequence AnimSeq;
    
    AnimSeq = FindAnimSequence(AnimSeqName);
    if (AnimSeq == None)
    {
        return 0.0;
    }
    return AnimSeq.SequenceLength / AnimSeq.RateScale;
}
public final function float GetAnimRateByDuration(Name AnimSeqName, float Duration)
{
    local AnimSequence AnimSeq;
    
    AnimSeq = FindAnimSequence(AnimSeqName);
    if (AnimSeq == None)
    {
        return 1.0;
    }
    return AnimSeq.SequenceLength / Duration;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GlobalAnimRateScale = 1.0
    WireframeColor = {B = 28, G = 221, R = 221, A = 255}
    bTransformFromAnimParent = 1
    bUpdateSkelWhenNotRendered = TRUE
    bTickAnimNodesWhenNotRendered = TRUE
    bUpdateKinematicBonesFromAnimation = TRUE
    bSyncActorLocationToRootRigidBody = TRUE
    LineCheckBoundsScale = {X = 1.0, Y = 1.0, Z = 1.0}
    bAutoFreezeClothWhenNotRendered = TRUE
    bCacheAnimSequenceNodes = TRUE
    ClothBlendWeight = 1.0
    ClothBlendMinDistanceFactor = -1.0
    ClothRBChannel = ERBCollisionChannel.RBCC_Cloth
    ClothImpulseScale = 1.0
    ClothAttachmentTearFactor = -1.0
    MinDistanceForClothReset = 256.0
    SoftBodyImpulseScale = 1.0
    bSoftBodyUseCompartment = TRUE
    SoftBodyRBChannel = ERBCollisionChannel.RBCC_SoftBody
    RootMotionAccelScale = {X = 1.0, Y = 1.0, Z = 1.0}
    RootMotionMode = ERootMotionMode.RMM_Ignore
    PreviousRMM = ERootMotionMode.RMM_Ignore
    ProgressiveDrawingFraction = 1.0
    WoundEllipse[0] = {
                       XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                       YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                       ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                       WPlane = {W = 1.0, X = 10000.0, Y = 0.0, Z = 0.0}
                      }
    WoundEllipse[1] = {
                       XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                       YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                       ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                       WPlane = {W = 1.0, X = 10000.0, Y = 0.0, Z = 0.0}
                      }
    m_bBioFFXShouldRelinkBoneMap = TRUE
    bSupportsLowDetailProxyRendering = TRUE
    LowDetailLODIndex = -1
    ReplacementPrimitive = None
    bAcceptsDynamicDecals = FALSE
    bCullModulatedShadowOnBackfaces = FALSE
    TickGroup = ETickingGroup.TG_PreAsyncWork
    ComponentType = EComponentType.COMPONENT_SkinMesh
}