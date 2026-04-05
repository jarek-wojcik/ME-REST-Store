Class BioPawn extends Pawn
    native
    nativereplication
    config(Game);

struct native MantleInfo 
{
    var CoverSlot CurrentSlot;
    var CoverSlot LeftSlot;
    var CoverSlot RightSlot;
    var BasedPosition MantleStartLoc;
    var BasedPosition MantleEndLoc;
    var BasedPosition EstimatedLandingLoc;
    var float MantleDistance;
    var CoverLink DestLink;
    var CoverLink LeftLink;
    var CoverLink RightLink;
    var CoverLink CurrentLink;
    var int CurrentSlotIdx;
    var int LeftSlotIdx;
    var int RightSlotIdx;
    var float CurrentSlotPct;
    var float FallForwardVelocity;
    var float RootMotionScaleFactor;
    var float DefaultMantleDistance;
    var bool bForced;
    var bool bIsOnASlot;
    
    structdefaultproperties
    {
        FallForwardVelocity = 300.0
        RootMotionScaleFactor = 1.0
        DefaultMantleDistance = 190.0
    }
};
struct native BioVOSettings 
{
    var Color cSubtitleColour;
    var float fSubtitleLength;
    var Object pSubtitleRefObject;
    var float fDelayStarting;
    var bool bSuppressSubtitlesIfVO;
    var bool bAlert;
    var bool bAlwaysHideSubtitle;
    var bool bHasPriority;
    var byte nSubtitleMode;
};
const UCONST_BIO_PAWN_ANIM_WALK_START_SPEED = 0.05f;
const BIO_PAWN_ANIM_RUN_RIGHT_FOOT_END = 0.75f;
const BIO_PAWN_ANIM_RUN_RIGHT_FOOT_START = 0.25f;
enum EBioAnimGetUpState
{
    eBioAnimGetUp_Idle,
    eBioAnimGetUp_Start,
    eBioAnimGetUp_Processing,
};
enum EBioAnimTurnDirState
{
    eBioAnimTurn_NoTurn,
    eBioAnimTurn_ReqStartLeft,
    eBioAnimTurn_ReqStartRight,
    eBioAnimTurn_AckStartLeft,
    eBioAnimTurn_AckStartRight,
    eBioAnimTurn_ProcessLeft,
    eBioAnimTurn_ProcessRight,
};
enum EBioAnimSkidTurnState
{
    eBioAnimSkid_NoState,
    eBioAnimSkid_StartingLeft,
    eBioAnimSkid_StartingRight,
    eBioAnimSkid_TurningLeft,
    eBioAnimSkid_TurningRight,
    eBioAnimSkid_FinishingLeft,
    eBioAnimSkid_FinishingRight,
};
enum EBioAnimStopState
{
    eBioAnimStop_NoState,
    eBioAnimStop_StopLeftMove,
    eBioAnimStop_StopRightMove,
    eBioAnimStop_FinishLeftMove,
    eBioAnimStop_FinishRightMove,
    eBioAnimStop_InterruptLeftMove,
    eBioAnimStop_InterruptRightMove,
    eBioAnimStop_DoneFinishLeftMove,
    eBioAnimStop_DoneFinishRightMove,
    eBioAnimStop_DoneIntLeftMove,
    eBioAnimStop_DoneIntRightMove,
};
struct native ReplicatedPowerComboImpact 
{
    var int PowerType;
    var BioPawn Instigator;
    var int CustomActionReactionType;
    var int PowerComboTypeUniqueID;
    var byte TriggerCounter;
    var byte PowerRank;
    var byte MiscFlags;
};
struct native ReplicatedPowerCombo 
{
    var Class<SFXGameEffect_PowerCombo> EffectClass;
    var Vector HitLocation;
    var BioPawn DetonatorPowerInstigator;
    var BioPawn SourcePowerInstigator;
    var byte TriggerCounter;
    var byte DetonatorPowerID;
    var byte SourcePowerID;
};
const ANIMATED_REACTION_TIME_MARGIN = 1.0f;
struct native ReplicatedAnimatedReaction 
{
    var Class<SFXDamageType> DamageType;
    var Vector HitLocation;
    var Vector HitNormal;
    var int CustomActionType;
    var int BoneIndex;
    var byte TriggerCounter;
    var byte RandomRoll;
};
struct native ReplicatedRadiusDamage 
{
    var Class<DamageType> DamageType;
    var Vector HitLocation;
    var Vector Momentum;
    var float Damage;
    var Actor DamageCauser;
    var int CustomActionReactionType;
    var byte TriggerCounter;
};
const REPLICATIONPOWERSUBSEQUENTIMPACT_POOL_SIZE = 4;
struct native ReplicatedPowerSubsequentImpact 
{
    var int PowerType;
    var BioPawn Instigator;
    var int CustomActionReactionType;
    var int ImpactCount;
    var bool DoCallback;
    var byte TriggerCounter;
    var byte Duration;
    var byte Delay;
};
const REPLICATIONCUSTOMACTIONIMPACT_POOL_SIZE = 4;
struct native ReplicatedCustomActionImpact 
{
    var Vector HitLocation;
    var Vector HitNormal;
    var int CustomActionType;
    var BioPawn Instigator;
    var int ImpactCount;
    var int CustomActionReactionType;
    var int PowerCustomActionType;
    var bool bFirstTarget;
    var byte TriggerCounter;
};
struct native ReplicatedWeaponImpact 
{
    var SFXWeapon oWeapon;
    var SFXProjectile oProjectile;
    var int CustomActionReactionType;
    var byte TriggerCounter;
    var byte Delay;
};
struct native ReplicatedCustomAction 
{
    var Vector TargetLocation;
    var int TriggerCounter;
    var int CustomActionType;
    var Object Target;
    var int PowerCustomActionType;
    var EReplicatedCustomActionCmd Cmd;
};
enum EReplicatedCustomActionCmd
{
    eRCACmd_Start,
    eRCACmd_Override,
    eRCACmd_Interrupt,
};
const CALCULATE_RBLOCATION_ERROR_TOLERANCE_SQ = 100.0f;
enum EBioAnimStartState
{
    eBioAnimStart_NoState,
    eBioAnimStart_StartingMove,
    eBioAnimStart_FinishStartMove,
    eBioAnimStart_DoneStartMove,
    eBioAnimStart_RotationUnlocked,
    eBioAnimStart_PlayingMove,
};
enum EBioAnimNodeCombatModeFadeOut
{
    BIO_ANIM_NODE_COMBAT_MODE_FADEOUT_NONE,
    BIO_ANIM_NODE_COMBAT_MODE_FADEOUT_ANIMATING_ENTER,
    BIO_ANIM_NODE_COMBAT_MODE_FADEOUT_ENTER,
    BIO_ANIM_NODE_COMBAT_MODE_FADEOUT_ANIMATING_EXIT,
    BIO_ANIM_NODE_COMBAT_MODE_FADEOUT_EXIT,
};
struct native WeaponAnimSpec 
{
    var(WeaponAnimSpec) array<AnimSet> m_animSets;
    var(WeaponAnimSpec) AnimSet m_drawAnimSet;
};
struct native AbilityTimeStamp 
{
    var Name AbilityName;
    var float TimeStamp;
};
struct native ReactionPart 
{
    var(ReactionPart) array<Name> BoneNames;
    var(ReactionPart) Name BodyPart;
};
enum EAimNodes
{
    AimNode_Cover,
    AimNode_Head,
    AimNode_LeftShoulder,
    AimNode_RightShoulder,
    AimNode_Chest,
    AimNode_Groin,
    AimNode_LeftKnee,
    AimNode_RightKnee,
};
struct native TemporaryAnimSetInfo 
{
    var AnimSet TempAnimSet;
    var int RefCount;
    var float TimeLeft;
};
struct native RigidBodyCallback 
{
    var delegate<RBCollisionCallback> RBCallback;
    var int nPriority;
};
struct native AttackReservation 
{
    var int nID;
    var int nTicketCost;
    var float fTimeUntilExpiry;
    var bool bUsingTicket;
};
enum EWeaponRange
{
    WeaponRange_Invalid,
    WeaponRange_Melee,
    WeaponRange_Short,
    WeaponRange_Medium,
    WeaponRange_Long,
};
struct native RootMotionOverrideEntry 
{
    var AnimNode Node;
    var ERootMotionMode RMMode;
    var ERootMotionRotationMode RMRMode;
};
struct native BodyStance 
{
    var(BodyStance) array<Name> AnimName;
};
enum EBodyStance
{
    BS_FullBody,
    BS_Standing_Upper,
    BS_Standing_Lower,
    BS_Standing_Cov_Upper,
    BS_Standing_Cov_Lean_Upper,
    BS_Mid_Cov_Upper,
    BS_Mid_Cov_Lean_Upper,
    BS_Mid_Cov_Popup_Upper,
    BS_Standing_Cov_PartLean_Upper,
    BS_Mid_Cov_PartLean_Upper,
    BS_Mid_Cov_PartPopup_Upper,
    BS_Crouching_Upper,
};
const CA_REPLICATION_TIME = 3.0f;

var const native MultiMap_Mirror m_mAnimsetRegistration;
var transient repnotify ReplicatedRadiusDamage ReplicatedRadiusDamageInfo;
var transient repnotify ReplicatedAnimatedReaction ReplicatedAnimatedReactionInfo;
var ScaledFloat DesiredSpeedMultiplier;
var transient repnotify ReplicatedPowerCombo ReplicatedPowerComboInfo;
var(BioPawn) array<Name> AttachSlots;
var(CustomActions) transient array<AnimNodeSlot> BodyStanceNodes;
var(CustomActions) array<Class<BioCustomAction>> CustomActionClasses;
var(CustomActions) editconst transient array<BioCustomAction> CustomActions;
var(CustomActions) array<Class<BioCustomAction>> PowerCustomActionClasses;
var(CustomActions) editconst transient array<BioCustomAction> PowerCustomActions;
var const array<Class<ReachSpec>> SupportedCustomReachSpecs;
var const array<Name> SupportedSyncActions;
var(BioPawn) editinline editconst export array<SkeletalMeshComponent> m_aoAccessories;
var transient array<RootMotionOverrideEntry> RootMotionOverrides;
var transient array<Name> m_afnCinematicLevels;
var array<Object> m_aAdditionalResourcesToCook;
var(BioPawn) string AIBarkAnimName;
var transient array<AttackReservation> m_aReservations;
var transient array<RigidBodyCallback> m_CollisionCallbacks;
var array<TemporaryAnimSetInfo> TemporaryAnims;
var array<SFXVocalizationBank> CombatVocVariants;
var(Combat) array<Name> AimNodes;
var(Combat) array<Vector> AimNodeOffsets;
var(Combat) array<ReactionPart> ReactionBones;
var array<AbilityTimeStamp> AbilityTimeStamps;
var(Appearance) array<WeaponAnimSpec> WeaponAnimSpecs;
var delegate<RBCollisionCallback> __RBCollisionCallback__Delegate;
var delegate<DamageCallback> __DamageCallback__Delegate;
var(BioPawn) transient Class<DamageType> KilledByDamageType;
var transient native repnotify ReplicatedCustomActionImpact ReplicatedCustomActionImpactPool[4];
var transient native repnotify ReplicatedPowerSubsequentImpact ReplicatedPowerSubsequentImpactPool[4];
var transient ReplicatedCustomActionImpact ReplicatedCustomActionImpactInfo;
var transient repnotify ReplicatedCustomAction ReplicatedCustomActionInfo;
var transient ReplicatedPowerSubsequentImpact ReplicatedPowerSubsequentImpactInfo;
var transient repnotify ReplicatedPowerComboImpact ReplicatedPowerComboImpactInfo;
var(Save) const Guid MyGuid;
var Guid GUID_LifetimeCrust;
var transient repnotify ReplicatedWeaponImpact ReplicatedWeaponImpactInfo;
var transient native float CAImpactEndReplicationTime[4];
var transient native float CAPowerSubsequentImpactEndReplicationTime[4];
var(BioPawn) transient Vector KilledByHitLocation;
var transient Vector m_vSafeTeleportLocation;
var transient Vector MeshTranslationOffset;
var transient Vector DesiredMeshTranslationOffset;
var transient Vector LastMantleLocation;
var transient Vector ReplicatedAimDeltaRot;
var transient Vector m_vFixedRotation;
var transient Rotator m_rLastStopRotation;
var transient Rotator m_rSkidStartRotation;
var transient Rotator m_rSkidTargetRotation;
var transient Vector ReplicatedDirection;
var Rotator ReplicatedRotation;
var transient Vector ReplicatedRootBodyPos;
var transient Vector CameraHookOffset;
var transient Vector CameraArmOffset;
var const Name RightHandSocketName;
var const Name LeftHandSocketName;
var(BioPawn) transient Name DeathHitBoneName;
var(BioPawn) Vector2D AimOffsetPct;
var(Combat) Name m_nmPhysicsImpactBone;
var(Combat) Name m_nmRagdollRecoverBone;
var(Combat) Name m_nmRagdollRecoverDirSwapBone;
var(CustomActions) int CurrentCustomAction;
var(CustomActions) int PreviousCustomAction;
var(CustomActions) int CurrentPowerCustomAction;
var transient Pawn SyncPawn;
var transient BioCustomAction SyncPawnOwner;
var int GrammarID;
var int DeathCustomAction;
var transient NavigationPoint PreRagdollAnchor;
var transient Weapon WeaponFromLastGameState;
var transient Weapon WeaponOnDeck;
var float WalkSpeed;
var float CombatWalkSpeed;
var float CombatGroundSpeed;
var float CoverGroundSpeed;
var float CoverCrouchGroundSpeed;
var float TightAimGroundSpeed;
var float CrouchGroundSpeed;
var float StormSpeed;
var float StormTurnSpeed;
var float StormSpeedScale;
var float StormSpeedScaleTime;
var float StormStartSpeed;
var transient float fMoveMag;
var transient float LastAnimatedReactionTime;
var float HitReactionChanceMultiplier;
var transient float LastLargeReactionTime;
var float LargeReactionInterval;
var(BioPawn) transient Controller KilledBy;
var int m_nTalkedToCount;
var(BioPawn) editinline export SkeletalMeshComponent HeadMesh;
var(BioPawn) BioMorphFace MorphHead;
var(BioPawn) editinline editconst export SkeletalMeshComponent m_oHairMesh;
var(BioPawn) editinline editconst export SkeletalMeshComponent m_oHeadGearMesh;
var(BioPawn) editinline editconst export SkeletalMeshComponent m_oVisorMesh;
var(BioPawn) editinline editconst export SkeletalMeshComponent m_oFacePlateMesh;
var transient int TalentPoints;
var float m_fRunAnimPlaybackPos;
var float m_fRunAnimPlaybackRate;
var float m_fRunAnimPlaybackLen;
var float m_fWalkAnimPlaybackPos;
var float m_fWalkAnimPlaybackRate;
var float m_fWalkAnimPlaybackLen;
var transient float m_fWalkStopDistance;
var transient float m_fRunStopDistance;
var float m_fCollisionReadyHeight;
var transient float PortArmsTimer;
var config transient float PortArmsExitDelay;
var config transient float PortArmsPlayerInterval;
var config transient float PortArmsNPCInterval;
var config transient float PortArmsWedgeHeight;
var config transient float PortArmsWedgeRadius;
var transient float DelayedPortArmsTimeAccumulator;
var float PortArmsDelay;
var CoverLink CurrentLink;
var int CurrentSlotIdx;
var int TargetSlotIdx;
var int PreviousSlotIdx;
var int LeftSlotIdx;
var int RightSlotIdx;
var float CurrentSlotPct;
var float LastCoverActionTime;
var transient float LastPopOutOfCoverTime;
var const transient int AnimationTransitionCount;
var const transient int AnimationTransitionPending;
var transient float m_fRBSleepEnergyThreshold;
var const config transient float m_fEnableCCDMultiplierThreshold;
var(Lighting) editinline export LightEnvironmentComponent LightEnvironment;
var const transient int m_eClassification;
var float m_fPhysicsForceIncurred;
var transient float ThreatRadiusSquared;
var(BioPawn) FaceFXAnimSet AIBarkAnimSet;
var transient float TimeOfDeath;
var const int MaxBodyCount;
var WwiseEvent DyingSound;
var WwiseEvent NotifyNewEnemySound;
var transient Object LastPhysicsSetter;
var config float FallingStateEntranceTime;
var config int m_nMaxTargetTickets;
var config int m_nMaxAttackTickets;
var config float m_fTicketExpiryTime;
var transient int m_nTargetTickets;
var transient int m_nAttackTickets;
var transient int m_nCurrentReservationID;
var config int ConformTraceInterval;
var transient int ConformTraceFrameCount;
var transient float InterpZTranslation;
var const float MeshAdjustFrequency;
var transient float CurrentMeshAdjustTime;
var transient float LastMantleTime;
var(BioPawn) const float AimOffsetInterpSpeed;
var(BioPawn) const float RemoteAimOffsetInterpSpeed;
var transient float TemporaryAimInterpSpeed;
var(BioPawn) const float PortArmsAndAimInterpSpeed;
var float ReloadingAimInterpTimeToGo;
var(BioPawn) const float AimOriginOffset;
var transient float m_fInitialZVal;
var transient Actor m_aLastCollidedActor;
var transient float ScaleLimitTimeToGo;
var config float RadarRange;
var config float RadarFOV;
var transient float m_fDesiredMaxSpeed;
var(Combat) repnotify BioBaseSquad Squad;
var(Combat) float m_fPowerUsePercent;
var(Combat) int m_nPhysicsLevel;
var(Combat) float m_fPhysicsRecoverSpeedThreshold;
var(Combat) int m_nRemainInRagdoll;
var SFXVocalizationBank CombatVoc;
var SFXVocalizationBank ExplorationVoc;
var SFXVocalizationBank StealthVoc;
var(Combat) SFXLoadoutData Loadout;
var(Combat) float fSleepPerceptionDistance;
var transient int ResistanceType;
var(Combat) float m_fRagdollRecoverPhysBlendTime;
var(Combat) float PowerThreshold_Standard;
var(Combat) float PowerThreshold_Stagger;
var(Combat) float PowerThreshold_Knockback;
var RvrClientEffectInterface CE_LifetimeCrust;
var(Animation) float m_fTurningAngle;
var(Animation) float m_fAnimStartTime;
var(Animation) float m_fMoveStartElapsedTime;
var(Animation) float m_fMoveStopElapsedTime;
var(Animation) float m_fAnimMoveSpeedSnapshot;
var(Animation) float m_fAnimMoveStartSpeedSnapshot;
var transient int InvalidRagdollStateCounter;
var transient repnotify int ReplicatedEnsurePawnHasLandedFromRagdoll;
var transient float CAEndReplicationTime;
var transient float CAPowerComboReplicationTime;
var transient float CAPowerComboImpactReplicationTime;
var transient int LastReplicatedCustomActionInfoTriggerCounter;
var transient int CurrentReplicatedCustomActionImpactIndex;
var transient int CurrentReplicatedCustomActionImpactRefCount;
var transient int CurrentReplicatedPowerSubsequentImpactIndex;
var transient int CurrentReplicatedPowerSubsequentImpactRefCount;
var transient float LastAnimatedReaction;
var config float ReplicatedRotationInterpolationRate;
var(Animation) float CoverTransitionStdLeanOutRight;
var(Animation) float CoverTransitionStdLeanInRight;
var(Animation) float CoverTransitionStdLeanOutLeft;
var(Animation) float CoverTransitionStdLeanInLeft;
var(Animation) float CoverTransitionMidLeanOutRight;
var(Animation) float CoverTransitionMidLeanInRight;
var(Animation) float CoverTransitionMidLeanOutLeft;
var(Animation) float CoverTransitionMidLeanInLeft;
var(Combat) Color BloodColor;
var transient SFXSkelControlLimb LeftHandIK;
var transient BioAnimNodeBlendByAction ActionNode;
var transient BioAnimNodeFrame SnapshotNode;
var(SoundSet) FaceFXAnimSet m_pOverrideSndSetFaceFXPkg;
var(FaceFX) FaceFXAnimSet m_pSndSetFaceFXPkg;
var float FollowDistanceModifier;
var config float AchievementForceThreshold;
var float CameraHookScale;
var transient float CameraArmScale;
var transient export SFXPowerManager PowerManager;
var config bool bUseAnimatedRagdoll;
var(CustomActions) transient bool bHACKStopCustomActionInstantly;
var(Kinect) bool SupportsCombatGrammar;
var const bool bCombatPawn;
var const bool bInjuredPawn;
var transient bool bIgnoreSelectionMaxRange;
var bool bFullyInitialized;
var bool bFullyInitializedMP;
var(Optimization) bool bCanPlayReactions;
var(Optimization) bool bSpawnPHATInstance;
var(Optimization) bool bKillOnRagdoll;
var(Optimization) bool bCollidesAfterDeath;
var(Save) bool bSaveMe;
var transient bool bIsSniping;
var bool bAllowSuperStormSpeed;
var bool bCanEarlyMantle;
var bool bCanRagdoll;
var bool bAffectedByRagdollPowers;
var bool bCanBeReaped;
var bool bCanPlayMoveStopAnims;
var transient bool bPreventPermanentDeath;
var transient bool bIsFrozen;
var(BioPawn) transient bool bPlayDeathAnimation;
var bool bUseLargeReactions;
var const bool bOverrideHeadMat;
var const bool bOverrideBodyMats;
var bool m_bOldUpdateSkelWhenNotRendered;
var bool m_bEnableStartRootMotion;
var bool m_bEnableStopRootMotion;
var transient bool bRootMotionOverriden;
var transient bool m_bTurnInPlaceRequested;
var bool m_bUseWallSlidingSpeedAdj;
var transient bool m_bSafeTeleportQueued;
var bool m_bHideWithCameraCollision;
var transient bool bPortArmsEnabled;
var const bool bCanPortArms;
var transient bool bInPortArms;
var transient bool bPlayingPortArmsAnim;
var(BioPawn) bool bDisablePlayerPortArmsEvenIfFriendly;
var(Debug) globalconfig bool bWeaponDebug_Accuracy;
var(Debug) globalconfig bool bWeaponDebug_DamageRadius;
var bool bWasInCover;
var bool bIsInStationaryCover;
var bool bIgnoreDuringCoverSelection;
var bool bDoUpdateCoverData;
var transient bool bDisableCoverAdjust;
var transient bool bRecentlyTookCover;
var(BioPawn) bool bDisableVocEvents;
var transient bool bScalingToZero;
var const bool bAdjustMeshTranslationOnSlopes;
var bool bReloadingAimInterp;
var bool bDisableAnimatedTransitions;
var transient bool m_bRagdollEnteredPendingBodyFallSound;
var transient bool m_bPowerInvokedLeanOut;
var(BioPawn) bool bActive;
var(BioPawn) bool bHeadGearVisible;
var(Combat) bool m_bMin1Health;
var(Combat) bool m_bPhysicsDamageEnabled;
var(Combat) bool m_bPlotProtected;
var(Combat) bool bSleeping;
var(Combat) bool bShouldSpawnWeapons;
var(Combat) transient bool bScalePowers;
var(Combat) transient bool bIsStealthed;
var transient bool bInStealthVolume;
var(Combat) bool m_bInvertRagdollRecoverBoneAxis;
var(Combat) bool m_bRecoverDirSwap;
var(Combat) bool m_bInvertRagdollRecoverDirSwapBoneAxis;
var transient bool bIsAPlayer;
var transient bool bStorming;
var transient bool bReplicatedWantsToStorm;
var transient repnotify bool bIsFalling;
var transient repnotify bool bIsDowned;
var transient repnotify bool bIsDead;
var transient bool bIsInRagdollRecovery;
var transient repnotify bool bMashSuccess;
var transient bool bPlayerInRagdoll;
var transient bool bReplicateCustomActionInfoToOwner;
var transient bool bHasReplicatedBufferedCustomAction;
var config bool bInterpolateReplicatedRotation;
var(Animation) transient bool bTurnInPlaceRequested;
var transient bool bNotifyCoverAlignment;
var transient bool bBusyConversation;
var bool bAchievementDisruptedGranted;
var bool bAchievementFlyingGranted;
var bool bAchievementFireGranted;
var ECoverDirection CurrentSlotDirection;
var ECoverDirection CoverDirection;
var repnotify ECoverType CoverType;
var repnotify ECoverAction CoverAction;
var(Classification) ERaceType RaceType;
var(Classification) ECharacterType CharacterType;
var(Classification) EAffiliationType AffiliationType;
var(Classification) EChallengeType ChallengeType;
var(Combat) EAxis m_eRagdollRecoverBoneAxis;
var(Combat) EAxis m_eRagdollRecoverDirSwapBoneAxis;
var EBioAnimNodeCombatModeFadeOut m_eCombatModeFadeoutState;
var transient byte LastReplicatedRadiusDamageInfoTriggerCounter;
var(Animation) transient EBioAnimTurnDirState m_eTurningDirection;
var(Animation) transient EBioAnimStartState m_eAnimStartState;
var(Animation) transient EBioAnimStopState m_eAnimStopState;
var(Animation) transient EBioAnimSkidTurnState m_eAnimSkidState;
var(Animation) transient EBioAnimGetUpState m_eGetUpState;

public native function int AcquireAttackTicket(int nCost);

public final native function AddAnimSet(AnimSet Set);

public function AddDefaultInventory()
{
    GenerateInventoryFromLoadout(Loadout);
    ScaleEquipment(GetScaledLevel(), Loadout);
}
public function bool AddForce(Vector impulse, Controller instigatedBy, optional Vector HitLocation, optional bool bIgnorePhysicsThreshold, optional Name HitBone, optional bool bVelChange);

public event simulated function bool AddRagdollImpulse(Vector impulse, Controller instigatedBy, optional Vector HitLocation, optional bool bIgnorePhysicsThreshold, optional Name HitBone, optional bool bVelChange, optional EAICustomAction AnimatedRagdoll)
{
    local BioCustomAction CustomAction;
    local SFXCustomAction_Ragdoll RagdollCA;
    local SFXCustomAction_AnimatedRagdoll AnimRagdollCA;
    
    if (HitBone == 'None')
    {
        HitBone = m_nmPhysicsImpactBone;
    }
    if (IsDead())
    {
        if (Physics != EPhysics.PHYS_RigidBody)
        {
            if (!InitRagdoll())
            {
            }
        }
        Mesh.AddImpulse(impulse, HitLocation, HitBone, bVelChange);
        return TRUE;
    }
    if (Physics == EPhysics.PHYS_RigidBody)
    {
        Mesh.AddImpulse(impulse, HitLocation, HitBone, bVelChange);
        return TRUE;
    }
    if (bUseAnimatedRagdoll)
    {
        if (GetCurrentCustomAction(CustomAction))
        {
            AnimRagdollCA = SFXCustomAction_AnimatedRagdoll(CustomAction);
            if (AnimRagdollCA != None)
            {
                AnimRagdollCA.AddImpulse(impulse);
                return TRUE;
            }
        }
        if (AnimatedRagdoll != EAICustomAction.CA_None)
        {
            if (Role == ENetRole.ROLE_Authority && StartCustomAction(int(AnimatedRagdoll)))
            {
                if (GetCurrentCustomAction(CustomAction))
                {
                    AnimRagdollCA = SFXCustomAction_AnimatedRagdoll(CustomAction);
                    if (AnimRagdollCA != None)
                    {
                        AnimRagdollCA.impulse = impulse;
                    }
                }
                return TRUE;
            }
        }
    }
    if (Role == ENetRole.ROLE_Authority && StartCustomAction(1))
    {
        if (GetCurrentCustomAction(CustomAction))
        {
            RagdollCA = SFXCustomAction_Ragdoll(CustomAction);
            if (RagdollCA != None)
            {
                RagdollCA.impulse = impulse;
                RagdollCA.HitLocation = HitLocation;
                RagdollCA.HitBone = HitBone;
                RagdollCA.bVelocityChange = bVelChange;
            }
        }
        return TRUE;
    }
    return FALSE;
}
public final native function AddTalentPoints(int nPoints);

public event function AdjustInventoryResource(EInventoryResourceTypes eResourceType, int nAmt, optional bool bNotifyTicker = FALSE)
{
    SFXInventoryManager(InvManager).AdjustResource(eResourceType, nAmt, bNotifyTicker);
}
public final native function AnimNodeBlendComplete(Name sBlendName, int nChild);

public final native function AnimNodePlayFinished(Name sBlendName);

public final simulated function AnimNotify(AnimNodeSequence SeqNode, BioAnimNotify_CustomAction NotifyObject)
{
    local BioCustomAction pAction;
    
    GetCurrentCustomAction(pAction);
    if (pAction != None)
    {
        pAction.AnimNotify(SeqNode, NotifyObject);
    }
}
public event simulated function AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
    Super(Actor).AnimTreeUpdated(SkelMesh);
    CacheCrucialAnimNodes();
}
public final native function BeginAnimatedTransition();

public event simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
    local AnimNodeSequence SeqNode;
    local SkeletalMeshComponent MeshComponent;
    local SFXModule_Gestures pGestMod;
    
    SeqNode = AnimNodeSequence(Mesh.FindAnimNode('MatineeAnim'));
    EnsurePawnIsUpright(FALSE);
    HardResetActionAndAnimationState();
    pGestMod = GetModule(Class'SFXModule_Gestures');
    if (pGestMod != None)
    {
        pGestMod.m_aBackupAnimSets = Mesh.AnimSets;
        pGestMod.m_bInMatinee = TRUE;
    }
    if (SeqNode != None)
    {
        if (InInterpGroup == None)
        {
            Mesh.AnimSets.Length = 0;
        }
        else
        {
            InInterpGroup.SFXScriptCopyGroupAnimSets(Mesh.AnimSets);
        }
        SeqNode.SetAnim('None');
    }
    if (Mesh != None)
    {
        m_bOldUpdateSkelWhenNotRendered = Mesh.bUpdateSkelWhenNotRendered;
        Mesh.bUpdateSkelWhenNotRendered = TRUE;
        foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
        {
            MeshComponent.bUpdateSkelWhenNotRendered = TRUE;
        }
    }
}
public simulated function BeginMovementControl(InterpGroup InInterpGroup)
{
    if (WorldInfo.IsShippingPCBuild() == FALSE && WorldInfo.IsFinalReleaseDebugConsoleBuild() == FALSE)
    {
        if (!bActive)
        {
            appScreenDebugMessage("Error, Movement track started on inactive pawn" @ PathName(Self) @ "[" $ Tag $ "]");
        }
    }
    Super(Actor).BeginMovementControl(InInterpGroup);
    EnsurePawnIsUpright(FALSE);
}
public simulated function BioBaseRemovedFromWorld()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (bNoTick || bTickIsDisabled)
        {
        }
        else if (Physics == EPhysics.PHYS_Interpolating)
        {
        }
        else if (Class'SFXModule_Conversation'.static.ScriptIsInConversation(Self))
        {
        }
        else
        {
            KillOrStasis(TRUE, None, None, "BaseRemovedFromWorld");
        }
    }
}
public final native function BioSetDesiredRotation(Rotator rDesiredRotation, optional bool bForce = FALSE);

public final simulated native function float BS_GetPlayRate(const out BodyStance Stance);

public final simulated native function float BS_GetTimeLeft(const out BodyStance Stance);

public final simulated native function BS_ScalePlayRate(const out BodyStance Stance, float RateScale);

public final simulated native function BS_SetPlayingFlag(const out BodyStance Stance, bool bNewPlaying);

public final simulated native function BS_SetPlayRate(const out BodyStance Stance, float NewRate);

public final simulated native function BS_SetPosition(const out BodyStance Stance, float Position);

public final native function CalcIdealCoverPos(float SlotPct, out Vector IdealPosition, out Rotator IdealRotation);

private final native function float CalculateDesiredGroundConformHeight(const out Vector vNewLocation);

public final native function CalculateMeshTranslationOffset(float DeltaSeconds);

public final native function bool CanCombat();

public final native function bool CanDoCoverAction(ECoverAction CovAction, optional bool bPrecise = FALSE, optional bool bTestCamera = FALSE);

public event function bool CanDoCoverCustomAction(ReachSpec Path)
{
    local ECoverDirection CurrentCoverDir;
    local bool bCanDoCoverCustomAction;
    
    bCanDoCoverCustomAction = FALSE;
    if (Path != None && IsInCover())
    {
        CurrentCoverDir = CoverDirection;
        if (Path.IsA('SwatTurnReachSpec'))
        {
            if (bCanSwatTurn)
            {
                if (int(SwatTurnReachSpec(Path).SpecDirection) == 2)
                {
                    CoverDirection = ECoverDirection.CD_Right;
                    bCanDoCoverCustomAction = CanDoCustomAction(45);
                }
                else
                {
                    CoverDirection = ECoverDirection.CD_Left;
                    bCanDoCoverCustomAction = CanDoCustomAction(44);
                }
            }
        }
        else if (Path.IsA('CoverSlipReachSpec'))
        {
            if (bCanCoverSlip)
            {
                if (int(CoverSlipReachSpec(Path).SpecDirection) == 2)
                {
                    CoverDirection = ECoverDirection.CD_Right;
                    if (CoverType == ECoverType.CT_Standing)
                    {
                        bCanDoCoverCustomAction = CanDoCustomAction(39);
                    }
                    else
                    {
                        bCanDoCoverCustomAction = CanDoCustomAction(38);
                    }
                }
                else
                {
                    CoverDirection = ECoverDirection.CD_Left;
                    if (CoverType == ECoverType.CT_Standing)
                    {
                        bCanDoCoverCustomAction = CanDoCustomAction(37);
                    }
                    else
                    {
                        bCanDoCoverCustomAction = CanDoCustomAction(36);
                    }
                }
            }
        }
        else if (Path.IsA('SlotToSlotReachSpec'))
        {
            bCanDoCoverCustomAction = CanDoCustomAction(35);
        }
        else if (Path.IsA('MantleReachSpec'))
        {
            if (MantleMarker(Path.End.Actor) != None)
            {
                bCanDoCoverCustomAction = CanDoCustomAction(33);
            }
            else if (MantleMarker(Path.Start) != None)
            {
                bCanDoCoverCustomAction = CanDoCustomAction(34);
            }
            else
            {
                bCanDoCoverCustomAction = CanDoCustomAction(31);
            }
        }
        CoverDirection = CurrentCoverDir;
    }
    return bCanDoCoverCustomAction;
}
public event simulated function bool CanDoCustomAction(int CAction, optional Pawn Sync, optional bool bForced, optional int PowerCustomAction)
{
    if (CAction != 0)
    {
        if (CAction == 132)
        {
            if (PowerCustomAction != 0 && PowerCustomAction < PowerCustomActionClasses.Length && PowerCustomActionClasses[PowerCustomAction] != None)
            {
                if (VerifyCAHasBeenInstanced(CAction, PowerCustomAction))
                {
                    return PowerCustomActions[PowerCustomAction].CanDoCustomAction(Sync, bForced);
                }
            }
        }
        else if (CAction < CustomActionClasses.Length && CustomActionClasses[CAction] != None)
        {
            if (VerifyCAHasBeenInstanced(CAction))
            {
                return CustomActions[CAction].CanDoCustomAction(Sync, bForced);
            }
        }
    }
    return FALSE;
}
public final native function bool CanExplore();

public event simulated function bool CanFireWeapon()
{
    local BioCustomAction CA;
    
    if (Weapon != None && SFXWeapon(Weapon).MaxChargeTime > float(0))
    {
        GetCurrentCustomAction(CA);
        if (CA != None && !CA.bAllowChargeHolding || DoesCoverStateAllowImmediateFire() == FALSE)
        {
            return FALSE;
        }
    }
    else if (IsInAnimatedTransition() || DoesCoverStateAllowImmediateFire() == FALSE || bStorming || bNoWeaponFiring)
    {
        return FALSE;
    }
    if (IsDead() || Physics == EPhysics.PHYS_Falling || IsInState('LandingState', ))
    {
        return FALSE;
    }
    return TRUE;
}
public final native function bool CanPlayAnimNode(Name sBlendName, int nFlags, out float fWeight);

public native function bool CanRagdoll();

public final native function bool CanRagdollReachAnchor(NavigationPoint Nav);

public final native function bool CanUseAnchor(NavigationPoint Nav);

public final event function ClearRBCallbacks()
{
    m_CollisionCallbacks.Length = 0;
}
public final native function ClearRegisteredCustomAnimsets(Name nmSetGroupName);

public final native function ClearUnregisteredAnimsets();

public event function CollectAnimListForCooking(BioPawn Pawn, out array<Name> OutResults);

public event function CopyPawnAppearance(BioPawn pSrcPawn);

public delegate function DamageCallback(Pawn oPawn, float fDamage, Controller instigatedBy, Class<DamageType> DamageType, Actor DamageCauser);

public simulated function Destroyed()
{
    EndCustomAction();
    if (PowerManager != None)
    {
        PowerManager.OnOwnerDestroyed();
    }
    if (Squad != None)
    {
        Squad.RemoveMember(Self);
    }
    RemoveLifeTimeCrust();
    ClearAnimNodes();
    UnRegisterJoinInProgressDelegate();
    Super.Destroyed();
}
public final event simulated function DoCustomAction(int NewAction, optional bool bForced, optional int PowerCustomAction)
{
    local BioCustomAction CurrentAction;
    
    if (CurrentCustomAction != 0)
    {
        CustomActionEnded();
    }
    PreviousCustomAction = CurrentCustomAction;
    CurrentCustomAction = NewAction;
    CurrentPowerCustomAction = PowerCustomAction;
    if (CurrentCustomAction != 0)
    {
        GetCurrentCustomAction(CurrentAction);
        if (CurrentAction != None)
        {
            CurrentAction.StartCustomAction();
        }
    }
    else if (Role < ENetRole.ROLE_Authority && bHasReplicatedBufferedCustomAction)
    {
        CustomActionInfoUpdated();
    }
}
public final native function bool DoesCoverStateAllowImmediateFire();

public event function EmergeFromObscuringSpawnEffect(bool bEnableAI)
{
    local SFXAI_Core AI;
    
    SetActive(TRUE);
    AI = SFXAI_Core(Controller);
    if (bEnableAI && AI != None)
    {
        AI.EnableAI(TRUE, 4);
    }
}
public final native function EndAnimatedTransition();

public simulated function EndCrouch(float HeightAdjust)
{
    local Vector Translation;
    
    Super.EndCrouch(HeightAdjust);
    Translation = Mesh.Translation;
    Translation.Z -= HeightAdjust;
    Mesh.SetTranslation(Translation);
}
public native function EnsurePawnIsUpright(bool bResetAI, optional bool bTeleport = FALSE);

public final event function bool EnsurePhysics(EPhysics NewMode)
{
    if (NewMode == EPhysics.PHYS_RigidBody)
    {
        OutputState();
        ScriptTrace();
        GotoState('Broken', , , );
        return FALSE;
    }
    if (NewMode != EPhysics.PHYS_RigidBody && IsInState('InRagdoll', ))
    {
        OutputState();
        ScriptTrace();
        GotoState('Broken', , , );
        return FALSE;
    }
    if (Physics == EPhysics.PHYS_Falling && !CollisionComponent.bAttached)
    {
        OutputState();
        ScriptTrace();
        GotoState('Broken', , , );
        return FALSE;
    }
    return TRUE;
}
public function Falling()
{
    SetTimer(FallingStateEntranceTime, FALSE, 'StartFall', );
}
public simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (bNoTick || bTickIsDisabled)
        {
        }
        else if (Physics == EPhysics.PHYS_Interpolating)
        {
        }
        else if (Class'SFXModule_Conversation'.static.ScriptIsInConversation(Self))
        {
        }
        else
        {
            KillOrStasis(FALSE, LastHitBy, dmgType, "FellOutOfWorld");
        }
    }
}
public final native function bool FindBumpAdjust(const out Vector vHitNormal, Actor oHitActor);

public final native function bool FindNearestOpenLocation(Vector vStartLocation, out Vector vFoundLocation, optional Pawn oTarget, optional int nMaxShellsToCheck = 2);

public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    local SkeletalMeshComponent MeshComponent;
    local SFXModule_Gestures pGestMod;
    
    pGestMod = GetModule(Class'SFXModule_Gestures');
    if (pGestMod != None)
    {
        if (pGestMod.m_bInMatinee)
        {
            pGestMod.m_bInMatinee = FALSE;
            Mesh.AnimSets = pGestMod.m_aBackupAnimSets;
            HardResetActionAndAnimationState();
        }
    }
    if (Mesh != None)
    {
        Mesh.bUpdateSkelWhenNotRendered = m_bOldUpdateSkelWhenNotRendered;
        foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
        {
            MeshComponent.bUpdateSkelWhenNotRendered = m_bOldUpdateSkelWhenNotRendered;
        }
    }
}
public event simulated function FireSingleShot()
{
    local bool bIsWeaponPendingFire;
    local SFXWeapon W;
    local int FireMode;
    
    W = SFXWeapon(Weapon);
    if (W == None)
    {
        return;
    }
    FireMode = int(W.DefaultFireMode);
    if (InvManager != None && InvManager.IsPendingFire(W, FireMode))
    {
        bIsWeaponPendingFire = TRUE;
    }
    if (bIsWeaponPendingFire == FALSE && CanFireWeapon())
    {
        StartFire(byte(FireMode));
        if (IsInvisible() && W.HasAmmo(W.CurrentFireMode))
        {
            BreakStealth();
        }
    }
}
public final simulated native function bool FitCollision();

public event simulated function ForceEndRagdoll();

public final native function ForceGroundConform();

public native function string GetActorGameName();

public native function GetAdjustedMoveDirection(const out Vector Dest, Actor MoveTarget, out Vector Direction);

public final native function bool GetAimNodeLocation(EAimNodes AimNode, out Vector AimLocation, optional bool bLogError = TRUE);

public simulated native function Vector GetAimOffsetOrigin();

public final native function bool GetAnimLengthAndPos(Name sAnimName, out float fAnimLength, out float fAnimPos);

public final simulated native function bool GetCurrentCustomAction(out BioCustomAction pAction);

public final event simulated function float GetCurrentHealth()
{
    local SFXModule_Damage DmgModule;
    
    DmgModule = GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        return DmgModule.GetCurrentHealth();
    }
    return 0.0;
}
public final event simulated function float GetCurrentShields()
{
    local SFXShield_Base ShieldObj;
    local float Shields;
    
    if (InvManager == None)
    {
        return 0.0;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ShieldObj)
    {
        Shields += ShieldObj.GetCurrentShields();
    }
    return Shields;
}
public final native function WwiseAudioComponent GetCurrentVOAudio();

public event simulated function EAttachSlot GetCurrentWeaponCharacterSlot()
{
    if (SFXWeapon(Weapon) != None)
    {
        return SFXWeapon(Weapon).CharacterSlot;
    }
    return 5;
}
public final native function ECoverAction GetDefaultCoverAction();

public event function BioPawn GetDriver();

public final native function Name GetEffectsMaterialType(optional SkeletalMeshComponent Component);

public final native function float GetFractionOfEffectsMaterialEnabled();

public event function Texture2D GetGUIIcon()
{
    return None;
}
public native function SkeletalMeshComponent GetHeadSkelMeshComponent();

public final simulated native function float GetHealthPct();

public event function int GetInventoryResource(EInventoryResourceTypes eResourceType)
{
    return SFXInventoryManager(InvManager).GetResource(eResourceType);
}
public event function int GetMaxAttackTickets()
{
    local int Tickets;
    
    Tickets = m_nMaxAttackTickets;
    return Tickets;
}
public final event simulated function float GetMaxHealth()
{
    local SFXModule_Damage DmgModule;
    
    DmgModule = GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        return DmgModule.GetMaxHealth();
    }
    return 0.0;
}
public final event simulated function float GetMaxShields()
{
    local SFXShield_Base ShieldObj;
    local float MaxShields;
    
    if (InvManager == None)
    {
        return 0.0;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ShieldObj)
    {
        MaxShields += ShieldObj.GetMaxShields();
    }
    return MaxShields;
}
public event function int GetMaxTargetTickets()
{
    local int Tickets;
    
    Tickets = m_nMaxTargetTickets;
    return Tickets;
}
public simulated native function Vector GetPawnViewLocation();

protected event function bool GetPossibleReactions(EReactionTypes ReactionType, out array<EAICustomAction> OutActions, optional Name HitPart, optional Controller instigatedBy, optional Vector Momentum, optional out TraceHitInfo HitInfo)
{
    local Vector FromSource;
    local Vector X;
    local Vector Y;
    local Vector Z;
    local float Angle;
    local float SideAngle;
    
    if (bUseLargeReactions)
    {
        if (ReactionType == EReactionTypes.Reaction_Light || WorldInfo.GameTimeSeconds - LastLargeReactionTime < LargeReactionInterval)
        {
            return FALSE;
        }
        ReactionType = ReactionType == EReactionTypes.Reaction_Heavy ? EReactionTypes.Reaction_Medium : EReactionTypes.Reaction_Light;
    }
    if (IsZero(Momentum) == FALSE)
    {
        FromSource = Normal(Momentum);
    }
    else if (instigatedBy != None && instigatedBy.Pawn != None)
    {
        FromSource = Normal(location - instigatedBy.Pawn.location);
    }
    else
    {
        FromSource = Vector(Rotation) * -1.0;
    }
    GetAxes(Rotation, X, Y, Z);
    Angle = X Dot FromSource;
    SideAngle = Y Dot FromSource;
    if (ReactionType == EReactionTypes.Reaction_Heavy)
    {
        GetKnockbackReactions(Angle, SideAngle, OutActions);
    }
    if (ReactionType == EReactionTypes.Reaction_Medium || ReactionType == EReactionTypes.Reaction_Heavy && OutActions.Length == 0)
    {
        GetStaggerReactions(Angle, SideAngle, OutActions);
    }
    if (ReactionType == EReactionTypes.Reaction_Light || (ReactionType == EReactionTypes.Reaction_Medium || ReactionType == EReactionTypes.Reaction_Heavy) && OutActions.Length == 0)
    {
        if (Angle < -0.707000017 && (HitPart == 'LeftLeg' || HitPart == 'RightLeg'))
        {
            if (CustomActionClasses[86] != None)
            {
                OutActions.AddItem(86);
            }
        }
        else
        {
            if (!bIsAPlayer)
            {
                GetMeleeReactions(Angle, SideAngle, OutActions);
            }
            if (IsInCover() == FALSE)
            {
                GetStandardReactions(Angle, SideAngle, OutActions);
            }
        }
    }
    if (ReactionType == EReactionTypes.Reaction_Pain)
    {
        if (CustomActionClasses[105] != None)
        {
            OutActions.AddItem(105);
        }
        if (CustomActionClasses[106] != None)
        {
            OutActions.AddItem(106);
        }
    }
    else if (ReactionType == EReactionTypes.Reaction_Fire)
    {
        if (CustomActionClasses[103] != None)
        {
            OutActions.AddItem(103);
        }
        if (CustomActionClasses[104] != None)
        {
            OutActions.AddItem(104);
        }
    }
    else if (ReactionType == EReactionTypes.Reaction_ShieldBreach)
    {
        if (CustomActionClasses[100] != None)
        {
            OutActions.AddItem(100);
        }
    }
    if (ReactionType == EReactionTypes.Reaction_DeathHeavy)
    {
        switch (HitPart)
        {
            case 'Head':
                if (bIsCrouched && CustomActionClasses[131] != None)
                {
                    OutActions.AddItem(131);
                }
                break;
            case 'LeftArm':
                if (Angle < 0.0)
                {
                    if (CustomActionClasses[124] != None)
                    {
                        OutActions.AddItem(124);
                    }
                    if (CustomActionClasses[130] != None)
                    {
                        OutActions.AddItem(130);
                    }
                }
                break;
            case 'RightArm':
                if (Angle < 0.0)
                {
                    if (CustomActionClasses[125] != None)
                    {
                        OutActions.AddItem(125);
                    }
                    if (CustomActionClasses[130] != None)
                    {
                        OutActions.AddItem(130);
                    }
                }
                break;
            default:
        }
    }
    if (ReactionType == EReactionTypes.Reaction_DeathLight || ReactionType == EReactionTypes.Reaction_DeathHeavy && OutActions.Length == 0)
    {
        switch (HitPart)
        {
            case 'Head':
                if (bIsCrouched == FALSE && CustomActionClasses[121] != None)
                {
                    OutActions.AddItem(121);
                }
                break;
            case 'LeftArm':
                if (Angle < 0.0 && CustomActionClasses[122] != None)
                {
                    OutActions.AddItem(122);
                }
                break;
            case 'RightArm':
                if (Angle < 0.0 && CustomActionClasses[123] != None)
                {
                    OutActions.AddItem(123);
                }
                break;
            case 'LeftLeg':
                if (Angle < 0.0 && CustomActionClasses[126] != None)
                {
                    OutActions.AddItem(126);
                }
                break;
            case 'RightLeg':
                if (Angle < 0.0 && CustomActionClasses[127] != None)
                {
                    OutActions.AddItem(127);
                }
                break;
            case 'Chest':
                if (Angle < 0.0)
                {
                    if (CustomActionClasses[128] != None)
                    {
                        OutActions.AddItem(128);
                    }
                    if (CustomActionClasses[129] != None)
                    {
                        OutActions.AddItem(129);
                    }
                }
                break;
            default:
        }
    }
    ValidateReactionsForGibs(OutActions);
    if (OutActions.Length > 0)
    {
        return TRUE;
    }
    return FALSE;
}
public final event simulated function Vector GetPulledInMuzzleLocation(SFXWeapon_NativeBase SW, Vector AimDir)
{
    local float MuzzleDist;
    local Vector MuzzleLoc;
    local Vector PulledInMuzzleLoc;
    local Vector ExtraPullIn;
    local Vector HitLocation;
    local Vector HitNormal;
    local Actor HitActor;
    
    MuzzleLoc = SW.GetPhysicalFireStartLoc(SW.FireOffset);
    MuzzleDist = VSize2D(MuzzleLoc - location);
    if (MuzzleDist > CylinderComponent.CollisionRadius)
    {
        PulledInMuzzleLoc = MuzzleLoc - MuzzleDist * AimDir;
        MuzzleDist = VSize2D(PulledInMuzzleLoc - location);
        if (MuzzleDist < CylinderComponent.CollisionRadius)
        {
            MuzzleLoc = PulledInMuzzleLoc;
        }
        else
        {
            HitActor = SW.GetTraceOwner().Trace(HitLocation, HitNormal, PulledInMuzzleLoc, location, FALSE, , , 1);
            if (HitActor != None)
            {
                ExtraPullIn = location - PulledInMuzzleLoc;
                ExtraPullIn.Z = 0.0;
                ExtraPullIn = (2.0 + MuzzleDist - CylinderComponent.CollisionRadius) * Normal(ExtraPullIn);
            }
            MuzzleLoc = PulledInMuzzleLoc + ExtraPullIn;
        }
    }
    return MuzzleLoc;
}
public final event simulated function Name GetRightHandSocketName()
{
    return RightHandSocketName;
}
public event simulated function float GetShieldPct()
{
    local SFXShield_Base ShieldObj;
    local float Shields;
    local float MaxShields;
    
    if (InvManager == None)
    {
        return 0.0;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ShieldObj)
    {
        Shields += ShieldObj.GetCurrentShields();
        MaxShields += ShieldObj.GetMaxShields();
    }
    if (MaxShields <= 0.0)
    {
        return 0.0;
    }
    return Shields / MaxShields;
}
public final native function float GetTimeSinceLastRender();

public final native function EWalkingSpeedMode GetWalkingSpeedMode();

public final event simulated function Vector GetWeaponIdlePosition()
{
    local SFXWeapon SFXWeapon;
    
    SFXWeapon = SFXWeapon(Weapon);
    if (SFXWeapon != None)
    {
        return SFXWeapon.MuzzleIdlePosition;
    }
    else
    {
        return location + vect(0.0, 0.0, 1.0) * BaseEyeHeight;
    }
}
public final event function float GetWeaponRange(EWeaponRange RangeType)
{
    local SFXWeapon oWeapon;
    
    oWeapon = SFXWeapon(Weapon);
    if (oWeapon != None)
    {
        switch (RangeType)
        {
            case EWeaponRange.WeaponRange_Melee:
                return oWeapon.MeleeRange;
                break;
            case EWeaponRange.WeaponRange_Short:
                return oWeapon.IdealMinRange;
                break;
            case EWeaponRange.WeaponRange_Medium:
                return oWeapon.IdealTargetDistance;
                break;
            case EWeaponRange.WeaponRange_Long:
                return oWeapon.IdealMaxRange;
                break;
            default:
        }
    }
    return -1.0;
}
public simulated native function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon);

public native function HACKResetRootMotion();

public native function HardResetActionAndAnimationState();

public native function bool HasValidAttackTicket(int nID);

public simulated function bool InCombat()
{
    local BioAiController AI;
    local SFXGRI GRI;
    
    AI = BioAiController(Controller);
    if (AI != None)
    {
        return AI.HasAnyEnemies();
    }
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI != None)
    {
        return GRI.InCombat();
    }
    return FALSE;
}
public native function bool InitRagdoll();

public final native function bool IsAnimatedTransitionPending();

public final native function bool IsAtLeftEdgeSlot(optional float InLimit = 0.100000001, optional bool bMustLean);

public final native function bool IsAtRightEdgeSlot(optional float InLimit = 0.100000001, optional bool bMustLean);

public final event function bool IsDeathReaction(EReactionTypes ReactionType)
{
    if (ReactionType == EReactionTypes.Reaction_DeathLight || ReactionType == EReactionTypes.Reaction_DeathHeavy)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated native function bool IsHumanControlled(optional Controller PawnController);

public final native function bool IsInAnimatedTransition();

public final native function bool IsInCover();

public final native function bool IsInCoverLeaning();

public native function bool IsInvisible();

public final native function bool IsOnACoverSlot();

public final native function bool IsPerformingBlockingAction();

public final native function bool IsPerformingCustomAction(optional bool bOnlyCheckBlockingActions);

public simulated native function bool IsPlayerPawn();

public final simulated native function bool IsPlayingBodyStance(const out BodyStance Stance);

public final native function bool IsReloading(optional bool bCheckReloadRequest = FALSE, optional bool bBlendOut = FALSE);

public event function bool IsReturningToPlaypen()
{
    local SFXAI_Core oAI;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None)
    {
        return oAI.IsReturningToPlaypen();
    }
    return FALSE;
}
public final event function bool IsSelectedWeaponOneHanded()
{
    local SFXInventoryManager pInvMan;
    
    pInvMan = SFXInventoryManager(InvManager);
    if (pInvMan == None || pInvMan.CurrentWeaponSelection == None || pInvMan.CurrentWeaponSelection.default.AnimType == WeaponAnimType.WeaponAnimType_Pistol || pInvMan.CurrentWeaponSelection.default.AnimType == WeaponAnimType.WeaponAnimType_AutoPistol)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public final native function bool IsSwitchingWeapons(optional bool bBlendOut = FALSE);

public final native function bool IsUsingPower();

public final native function bool IsWalking();

public function Landed(Vector HitNormal, Actor FloorActor)
{
    local Controller OldLastHitBy;
    
    OldLastHitBy = LastHitBy;
    ClearTimer('StartFall');
    TakeFallingDamage();
    LastHitBy = OldLastHitBy;
    if (!bIsFalling)
    {
        ++ReplicatedEnsurePawnHasLandedFromRagdoll;
    }
    bIsFalling = FALSE;
    bForceNetUpdate = TRUE;
}
public event simulated function LeaveCover()
{
    local BioPlayerController ControllerPlayer;
    
    ControllerPlayer = BioPlayerController(Controller);
    if (IsInCover() || CoverAction == ECoverAction.CA_Aimback)
    {
        CurrentLink.UnClaim(Self, CurrentSlotIdx, FALSE);
        PreviousSlotIdx = CurrentSlotIdx;
        CurrentSlotPct = -1.0;
        CurrentLink = None;
        CurrentSlotIdx = -1;
        LeftSlotIdx = -1;
        RightSlotIdx = -1;
        CoverType = ECoverType.CT_None;
        CoverAction = ECoverAction.CA_Default;
        CoverDirection = ECoverDirection.CD_Default;
        ShouldCrouch(FALSE);
        if (IsHumanControlled())
        {
            SetAnchor(None);
        }
        if (ControllerPlayer != None && ControllerPlayer.IsLocalPlayerController())
        {
            ControllerPlayer.CoverLog("leave cover", string(GetFuncName()));
            ControllerPlayer.HintSystem.HintEvent('LeaveCover');
        }
        else
        {
            LockDesiredRotation(FALSE);
        }
    }
}
public final simulated native function ManageRagdolls();

public native function MoveToRagdollRecoverStartPosition();

public event simulated function NotifyFallingAnimationComplete();

public event function NotifyFinishedCoverAlign()
{
    bNotifyCoverAlignment = FALSE;
}
public event function NotifyLimbDetached(EBioPartGroup ePartGroup)
{
    local int idx;
    local BioSeqEvt_NotifyLimbDetached detachEvent;
    
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        detachEvent = BioSeqEvt_NotifyLimbDetached(GeneratedEvents[idx]);
        if (detachEvent != None)
        {
            detachEvent.SetIntVars("WhichLimb", int(ePartGroup));
            detachEvent.CheckActivate(Self, Self);
        }
    }
}
public event simulated function NotifyRagdollRecoverAnimationComplete();

public event simulated function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local int i;
    
    Super(Actor).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    for (i = 0; i < BodyStanceNodes.Length; i++)
    {
        if (BodyStanceNodes[i] != None)
        {
            if (SeqNode == BodyStanceNodes[i].GetCustomAnimNodeSeq())
            {
                BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
                return;
            }
        }
    }
}
public event simulated function OnDeathAnimationFinished()
{
    if (!InitRagdoll())
    {
    }
}
public event simulated function OnEnterRagdoll()
{
    if (m_bEnableRagdollRecovery && !IsDead())
    {
        GotoState('InRagdoll', , , );
    }
    TriggerEventClass(Class'SFXSeqEvt_Ragdoll', Self, 0);
    bPlayerInRagdoll = bIsAPlayer;
}
public final function OnJoinInProgress()
{
    local BioCustomAction Action;
    
    if (PowerManager != None)
    {
        PowerManager.InitializeJoinInProgress();
    }
    if (!IsDead() && !bIsInRagdollRecovery)
    {
        if (GetCurrentCustomAction(Action) && Action.ShouldReplicate())
        {
            if (Physics == EPhysics.PHYS_RigidBody && Action.IsA('SFXCustomAction_Ragdoll'))
            {
                Action.Replicate();
            }
            else if (Action.IsA('SFXCustomAction_AnimatedRagdoll'))
            {
                Action.Replicate();
            }
        }
        else if (Physics == EPhysics.PHYS_RigidBody && m_nRemainInRagdoll > 0)
        {
        }
    }
}
public event simulated function OnLeaveRagdoll()
{
    TriggerEventClass(Class'SFXSeqEvt_Ragdoll', Self, 1);
    if (bPlayerInRagdoll && Controller != None)
    {
        BioPlayerController(Controller).CleanOutSavedMoves();
        BioPlayerController(Controller).ClearServerMoveExtrapolation();
    }
    bPlayerInRagdoll = FALSE;
}
public simulated function OnToggle(SeqAct_Toggle Action)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Mesh.FindAnimNode('MatineeAnim'));
    if (SeqNode != None)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            if (!SeqNode.bPlaying)
            {
                SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
            }
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            if (SeqNode.bPlaying)
            {
                SeqNode.StopAnim();
            }
        }
        else if (Action.InputLinks[2].bHasImpulse)
        {
            if (SeqNode.bPlaying)
            {
                SeqNode.StopAnim();
            }
            else
            {
                SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
            }
        }
    }
}
public simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        KillOrStasis(TRUE, LastHitBy, None, "OutsideWorldBounds");
    }
}
public final native function int PickClosestCoverSlot(optional bool bRequireOverlap = TRUE, optional float RadiusScale = 0.5, optional bool bIgnoreCurrentCoverAction);

public final simulated native function float PlayBodyStance(const out BodyStance Stance, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride = TRUE, optional Name GroupName, optional float StartTime, optional AlphaBlendType BlendType);

public final simulated native function PlayBodyStanceByDuration(const out BodyStance Stance, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride = TRUE, optional Name GroupName, optional AlphaBlendType BlendType);

public event simulated function PlayFootStepSound(int FootDown)
{
    local SFXModule_Audio AudioModule;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local float Loudness;
    local float MaxSpeed;
    
    AudioModule = GetModule(Class'SFXModule_Audio');
    if (AudioModule != None)
    {
        TraceActor = AudioModule.PlayFootStepSound(FootDown, HitInfo);
        if (TraceActor != None)
        {
            MaxSpeed = CombatGroundSpeed;
            if (MaxSpeed > 0.0)
            {
                Loudness = VSize(Velocity) / MaxSpeed;
            }
            MakeNoise(Loudness * Loudness * Loudness, 'NoiseType_Footstep');
            PlayStepEffect(FootDown, HitInfo, Loudness);
        }
    }
}
public final native function PlayFOVO(WwiseEvent Sound);

public simulated function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, Pawn DamageCauser)
{
    local Class<SFXDamageType> damageClass;
    local SFXCustomAction_DamageReaction Action;
    local float HealthPct;
    local SFXGRI GRI;
    local SFXWeapon ChkWeapon;
    local float DamageVocProbMod;
    local SFXModule_Wound WoundMod;
    local Name HitPart;
    local int BoneIndex;
    local SFXModule_AimAssist AimAssist;
    local bool bCanGibHead;
    local BioPlayerController BioPC;
    
    Super.PlayHit(Damage, instigatedBy, HitLocation, DamageType, Momentum, HitInfo, DamageCauser);
    if (Damage <= 0.0)
    {
        return;
    }
    BioPC = BioPlayerController(instigatedBy);
    damageClass = Class<SFXDamageType>(DamageType);
    if (damageClass == None || instigatedBy == None)
    {
        return;
    }
    HitPart = GetPartFromHit(HitInfo);
    if (Role == ENetRole.ROLE_Authority)
    {
        if (RequestWeaponReaction(instigatedBy, HitLocation, damageClass, Momentum, HitInfo))
        {
            Action = SFXCustomAction_DamageReaction(CustomActions[CurrentCustomAction]);
            if (Action != None)
            {
                BoneIndex = Mesh.MatchRefBone(HitInfo.BoneName);
                Action.Init(HitLocation, -Normal(Momentum), BoneIndex, TRUE, damageClass);
            }
            ReplicateAnimatedReaction(CurrentCustomAction, HitLocation, -Normal(Momentum), BoneIndex, damageClass);
        }
        if (GetCurrentHealth() <= 0.0 && HitPart == 'Head' && IsDead() == FALSE)
        {
            if (FRand() < damageClass.default.HeadGibChance)
            {
                if (BioPC != None)
                {
                    if (BioPC.IsLocalPlayerController())
                    {
                        AimAssist = BioPC.GetModule(Class'SFXModule_AimAssist');
                        bCanGibHead = AimAssist == None || AimAssist.CurrentAimAssistTarget == Self && AimAssist.CurrentAimAssistSoftMargin >= float(1);
                    }
                    else
                    {
                        bCanGibHead = BioPC.RemoteAimAssistActive == FALSE;
                    }
                }
                if (bCanGibHead)
                {
                    GibHead(HitLocation, -Normal(Momentum), HitInfo.BoneName, damageClass);
                }
            }
        }
    }
    if (HasAnyShieldResistance() == FALSE)
    {
        GRI = SFXGRI(WorldInfo.GRI);
        if (GRI != None && IsDead() == FALSE)
        {
            ChkWeapon = SFXWeapon(instigatedBy.Pawn.Weapon);
            if (ChkWeapon != None && ChkWeapon.__GetDamageVocProbabilityMod__Delegate != None)
            {
                DamageVocProbMod = ChkWeapon.__GetDamageVocProbabilityMod__Delegate();
            }
            else
            {
                DamageVocProbMod = 1.0;
            }
            HealthPct = GetHealthPct();
            if (HealthPct > 0.5)
            {
                GRI.TriggerVocalizationEvent(24, Self, BioPawn(instigatedBy.Pawn), 0.0, DamageVocProbMod);
            }
            else if (HealthPct > 0.200000003)
            {
                GRI.TriggerVocalizationEvent(25, Self, BioPawn(instigatedBy.Pawn), 0.0, DamageVocProbMod);
            }
            else if (HealthPct > 0.0)
            {
                GRI.TriggerVocalizationEvent(26, Self, BioPawn(instigatedBy.Pawn), 0.0, DamageVocProbMod);
            }
            GRI.TriggerVocalizationEvent(104, BioPawn(instigatedBy.Pawn), Self, 1.0, DamageVocProbMod);
        }
        WoundMod = GetModule(Class'SFXModule_Wound');
        if (WoundMod != None)
        {
            WoundMod.CreateBestWound(HitPart, HitLocation, DamageType, Momentum);
        }
    }
    if (Physics == EPhysics.PHYS_RigidBody)
    {
        Mesh.AddImpulse(Momentum, HitLocation, HitInfo.BoneName);
        return;
    }
}
public event function bool PlaySpawnEntrance()
{
    local SFXSelectionModule SelectionMod;
    
    if (CustomActionClasses[15] != None)
    {
        if (StartCustomAction(15))
        {
            SetHidden(TRUE);
            SelectionMod = GetModule(Class'SFXSelectionModule');
            if (SelectionMod != None)
            {
                SelectionMod.DisableSelection();
            }
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    CacheCrucialAnimNodes();
    if (!bFullyInitialized)
    {
        bFullyInitialized = TRUE;
        AddDefaultInventory();
        if (Squad != None)
        {
            Squad.AddMember(Self, FALSE);
        }
        if (CE_LifetimeCrust != None)
        {
            SetLifeTimeCrust(CE_LifetimeCrust);
        }
        if (BioWorldInfo(WorldInfo).SelectableActors.Find(Self) == -1)
        {
            BioWorldInfo(WorldInfo).SelectableActors.AddItem(Self);
        }
        if (CombatVoc == None && CombatVocVariants.Length > 0)
        {
            CombatVoc = CombatVocVariants[Rand(CombatVocVariants.Length)];
        }
        RegisterJoinInProgressDelegate();
    }
    if (bSpawnPHATInstance)
    {
        Mesh.SetHasPhysicsAssetInstance(TRUE);
    }
    LoadCharacterClassData();
    if (!bActive)
    {
        SetActive(FALSE);
    }
    Class'SFXGame'.static.ReCalculate(DesiredSpeedMultiplier);
}
public simulated native function PostInitAnimTree(SkeletalMeshComponent SkelComp);

public static event function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    local Class<BioCustomAction> CustomActionClass;
    local int i;
    
    if (default.Loadout != None)
    {
        for (i = 0; i != default.Loadout.Weapons.Length; ++i)
        {
            default.Loadout.Weapons[i].static.PrecacheVFX(ObjectPool, ClientEffects);
        }
        for (i = 0; i != default.Loadout.ShieldLoadouts.Length; ++i)
        {
            default.Loadout.ShieldLoadouts[i].Shields.static.PrecacheVFX(ObjectPool, ClientEffects);
        }
    }
    foreach default.CustomActionClasses(CustomActionClass, )
    {
        CustomActionClass.static.PrecacheVFX(ObjectPool, ClientEffects);
    }
    foreach default.PowerCustomActionClasses(CustomActionClass, )
    {
        CustomActionClass.static.PrecacheVFX(ObjectPool, ClientEffects);
    }
    ClientEffects.PrimeClass(default.Class);
}
public delegate function RBCollisionCallback(Pawn oPawn, Actor oImpactActor, Vector vImpactDir);

public event simulated function ReachedCoverSlot(int SlotIdx)
{
    local BioPlayerController PC;
    local int OldSlotIdx;
    
    if (CurrentLink != None)
    {
        OldSlotIdx = CurrentSlotIdx;
        SetCoverType(CurrentLink.Slots[SlotIdx].CoverType);
        CurrentSlotIdx = SlotIdx;
        PC = BioPlayerController(Controller);
        if (PC != None)
        {
            PC.NotifyReachedCoverSlot(SlotIdx, OldSlotIdx);
        }
    }
}
public final event simulated function RecacheAnimNodes()
{
    CacheAnimNodes();
}
public event function RecoverFromBleedout(optional bool bResetHealth = TRUE)
{
    local SFXModule_DamagePlayer DmgPlayer;
    
    DmgPlayer = GetModule(Class'SFXModule_DamagePlayer');
    if (DmgPlayer != None)
    {
        DmgPlayer.RecoverFromBleedout(bResetHealth);
    }
}
public final native function RegisterCustomAnimset(Name nmSetGroupName, AnimSet oAnim);

public native function ReleaseAttackTicket(int nID, bool bKillTicket);

public final native function RemoveTalentPoints(int nPoints);

public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedWeaponImpactInfo':
            WeaponImpactInfoUpdated();
            break;
        case 'ReplicatedCustomActionInfo':
            if (LastReplicatedCustomActionInfoTriggerCounter != ReplicatedCustomActionInfo.TriggerCounter)
            {
                CustomActionInfoUpdated();
                LastReplicatedCustomActionInfoTriggerCounter = ReplicatedCustomActionInfo.TriggerCounter;
            }
            break;
        case 'ReplicatedCustomActionImpactPool':
            CustomActionImpactInfoUpdated(TRUE);
            break;
        case 'ReplicatedPowerComboInfo':
            PowerComboInfoUpdated();
            break;
        case 'ReplicatedPowerComboImpactInfo':
            PowerComboImpactInfoUpdated();
            break;
        case 'ReplicatedPowerSubsequentImpactPool':
            PowerSubsequentImpactInfoUpdated(TRUE);
            break;
        case 'ReplicatedAnimatedReactionInfo':
            CustomActionAnimatedReactionUpdated();
            break;
        case 'bIsFalling':
            if (bIsFalling == TRUE && IsInState('FallingState', ) == FALSE)
            {
                SetPhysics(2);
                GotoState('FallingState', , , );
            }
            else if (bIsFalling == FALSE && IsInState('FallingState', ) == TRUE)
            {
                GotoState('LandingState', , , );
            }
            break;
        case 'ReplicatedEnsurePawnHasLandedFromRagdoll':
            DeferedEnsurePawnHasLandedFromRagdoll();
            break;
        case 'bIsDowned':
            IsDownedUpdated();
            break;
        case 'bIsDead':
            IsDeadUpdated();
            break;
        case 'ReplicatedRadiusDamageInfo':
            if (int(LastReplicatedRadiusDamageInfoTriggerCounter) != int(ReplicatedRadiusDamageInfo.TriggerCounter))
            {
                ReplicatedRadiusDamageInfoUpdated();
                LastReplicatedRadiusDamageInfoTriggerCounter = ReplicatedRadiusDamageInfo.TriggerCounter;
            }
            break;
        case 'Squad':
            SquadUpdated();
            break;
        case 'bMashSuccess':
            if (bMashSuccess)
            {
                MashSuccessUpdated();
            }
            break;
        case 'CoverType':
            if (CoverType != ECoverType.CT_None)
            {
                bRecentlyTookCover = TRUE;
                SetTimer(0.649999976, FALSE, 'ClearRecentCoverFlag', );
            }
            break;
        case 'CoverAction':
            if (CoverAction == ECoverAction.CA_LeanLeft || CoverAction == ECoverAction.CA_LeanRight || CoverAction == ECoverAction.CA_PopUp)
            {
                LastPopOutOfCoverTime = WorldInfo.GameTimeSeconds;
            }
        default:
            Super.ReplicatedEvent(VarName);
            break;
    }
}
public final native function bool RequestTurnInPlace(Rotator rDesDir);

public final native function bool RequestWeaponReaction(Controller instigatedBy, Vector HitLocation, Class<SFXDamageType> DamageType, Vector Momentum, out TraceHitInfo HitInfo);

public event function bool Resurrect(float PercentOfHealthRegained, bool bIsInstantaneous)
{
    local SFXModule_Damage DmgMod;
    
    DmgMod = GetModule(Class'SFXModule_Damage');
    if (DmgMod == None)
    {
        return FALSE;
    }
    if (!IsDead())
    {
        return FALSE;
    }
    DmgMod.SetCurrentHealth(DmgMod.GetMaxHealth() * PercentOfHealthRegained, TRUE);
    DmgMod.bOwnerIsDead = FALSE;
    bIsDead = FALSE;
    if (bIsInstantaneous)
    {
        ForceEndRagdoll();
    }
    else
    {
        if (Physics != EPhysics.PHYS_RigidBody)
        {
            if (!InitRagdoll())
            {
            }
        }
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            GotoState('InRagdoll', , , );
        }
        else
        {
            GotoState('Auto', , , );
        }
    }
    return TRUE;
}
public event function RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local int idx;
    local delegate<RBCollisionCallback> RBCallback;
    local float fContactMag;
    
    if (m_CollisionCallbacks.Length > 0)
    {
        if (HitComponent != None && OtherComponent != None && HitComponent.Owner != OtherComponent.Owner)
        {
            fContactMag = VSize(RigidCollisionData.ContactInfos[0].ContactVelocity[ContactIndex]);
            if (fContactMag > HitComponent.ScriptRigidBodyCollisionThreshold)
            {
                for (idx = 0; idx < m_CollisionCallbacks.Length; idx++)
                {
                    RBCallback = m_CollisionCallbacks[idx].RBCallback;
                    RBCallback(Self, OtherComponent.Owner, RigidCollisionData.ContactInfos[0].ContactVelocity[ContactIndex]);
                }
            }
        }
    }
}
public final native function RmvAnimSet(AnimSet Set);

public event simulated function RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
    if (SkelComp.RootMotionMode == ERootMotionMode.RMM_Translate)
    {
        StopMovement(FALSE);
    }
    Mesh.bRootMotionModeChangeNotify = FALSE;
}
public final native function RootMotionOverride(AnimNode Node, ERootMotionMode RMMode, ERootMotionRotationMode RMRMode);

public final native function RootMotionRelease(AnimNode Node);

public native function SafeSetLocation(Vector vDest);

public final event function ScriptedDeath()
{
    Died(Controller, Class'SFXDamageType_Suicide', location + vect(0.0, 0.0, 32.0));
}
public final native function SetAnimatedTransitionPending();

public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Mesh.FindAnimNode('MatineeAnim'));
    if (SeqNode != None)
    {
        if (SeqNode.AnimSeqName != InAnimSeqName)
        {
            SeqNode.SetAnim(InAnimSeqName);
        }
        SeqNode.bLooping = bLooping;
        SeqNode.SetPosition(InPosition, bFireNotifies);
    }
}
public final simulated native function SetBodyStanceAnimEndNotification(const out BodyStance Stance, bool bNewStatus);

public final simulated native function SetBodyStanceAnimLooping(const out BodyStance Stance, bool bNewLooping);

public final simulated native function SetBodyStanceRootBoneAxisOption(const out BodyStance Stance, optional ERootBoneAxis AxisX = 0, optional ERootBoneAxis AxisY = 0, optional ERootBoneAxis AxisZ = 0);

public final simulated native function SetBodyStanceRootRotationOption(const out BodyStance Stance, optional ERootRotationOption RPitch = 0, optional ERootRotationOption RYaw = 0, optional ERootRotationOption RRoll = 0);

public final event function SetCoverAction(ECoverAction NewCoverAction)
{
    if (int(NewCoverAction) != int(CoverAction))
    {
        if (IsHumanControlled() && Controller != None)
        {
            BioPlayerController(Controller).CoverLog("NewCoverAction:" @ NewCoverAction, string(GetFuncName()));
        }
        CoverAction = NewCoverAction;
        LastCoverActionTime = WorldInfo.GameTimeSeconds;
        if (CoverAction == ECoverAction.CA_LeanLeft || CoverAction == ECoverAction.CA_LeanRight || CoverAction == ECoverAction.CA_PopUp)
        {
            LastPopOutOfCoverTime = WorldInfo.GameTimeSeconds;
        }
    }
}
public final native function SetCrouchStateInstantly(bool bDoCrouch);

public native function SetDesiredSpeed(float fSpeedScaling);

public final native function SetEffectsMaterialType(Name EffectsMaterialType);

public final native function SetFractionOfEffectsMaterialEnabled(float FractionEnabled);

public event function SetHeadGearVisibility(bool bVisible)
{
    bHeadGearVisible = bVisible;
    m_oHeadGearMesh.SetHidden(!bHeadGearVisible);
}
public final native function SetMeshTranslationOffset(Vector NewOffset, bool bForce);

public event function SetRTPCHelmetIsEnabled(WwiseAudioComponent WwiseComponent)
{
    if (WwiseComponent != None)
    {
        if (m_oFacePlateMesh != None && m_oFacePlateMesh.bAttached)
        {
            WwiseComponent.SetWwiseRTPC("Pawn_Wearing_Helmet", 1.0);
        }
        else
        {
            WwiseComponent.SetWwiseRTPC("Pawn_Wearing_Helmet", 0.0);
        }
    }
}
public final native function SetScalarParameterValue(Name ParameterName, float Value);

public simulated function SetScale(float fScale)
{
    Mesh.SetScale(fScale);
}
public final native function SetShadowMode(ELightShadowMode ShadowMode, bool EnableShadowCasting);

public event function SetShouldCrouch(bool bCrouch)
{
    ShouldCrouch(bCrouch);
}
public final native function SetTextureParameterValue(Name ParameterName, Texture Value);

public native function SetTicketDuration(int nID, float fDuration);

public final native function SetVectorParameterValue(Name ParameterName, const out Color Value);

public event simulated function SetWeaponFromSlot(EAttachSlot eSlot)
{
    if (SFXInventoryManager(InvManager) != None)
    {
        SFXInventoryManager(InvManager).SetWeaponFromSlot(eSlot);
    }
}
public event simulated function bool SetWeaponImmediately(SFXWeapon Wpn)
{
    return SFXInventoryManager(InvManager).SetWeaponImmediately(Wpn);
}
public event simulated function bool SetWeaponImmediatelyByClass(Class<SFXWeapon> WpnClass)
{
    local SFXWeapon Wpn;
    
    Wpn = GetWeaponForSwitch(WpnClass);
    return SFXInventoryManager(InvManager).SetWeaponImmediately(Wpn);
}
public event simulated function SFXSetAudioComponentRTPCs(ActorComponent pWwiseAudioComponent)
{
    local WwiseAudioComponent AudioComponent;
    local SFXModule_Audio AudioMod;
    
    AudioMod = GetModule(Class'SFXModule_Audio');
    AudioMod.SFXSetAudioComponentRTPCs(pWwiseAudioComponent);
    AudioComponent = WwiseAudioComponent(pWwiseAudioComponent);
    if (AudioComponent != None)
    {
        SetRTPCHelmetIsEnabled(AudioComponent);
    }
}
public final native function SoftResetMovementAndAnimationState();

public simulated function StartCrouch(float HeightAdjust)
{
    local Vector Translation;
    
    Super.StartCrouch(HeightAdjust);
    Translation = Mesh.Translation;
    Translation.Z += HeightAdjust;
    Mesh.SetTranslation(Translation);
}
public event simulated function bool StartCustomAction(int NewAction, optional Pawn Sync, optional bool bForced, optional int PowerCustomAction)
{
    local SFXAI_Core AI;
    local SFXAICmd_CustomAction CustomActionCommand;
    local BioCustomAction NewCA;
    
    if (CanDoCustomAction(NewAction, Sync, bForced, PowerCustomAction))
    {
        if (bForced || CanOverrideCurrentCustomAction(NewAction, PowerCustomAction))
        {
            CAEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
            if (NewAction == 132)
            {
                NewCA = PowerCustomActions[PowerCustomAction];
            }
            else
            {
                NewCA = CustomActions[NewAction];
            }
            SyncPawn = Sync;
            if (SyncPawn == None)
            {
                SyncPawnOwner = None;
            }
            else
            {
                SyncPawnOwner = NewCA;
            }
            AI = SFXAI_Core(Controller);
            if (AI != None)
            {
            }
            if (AI != None && NewCA.bPushAICommand)
            {
                if (CurrentCustomAction != 0)
                {
                    CustomActionEnded();
                }
                CustomActionCommand = SFXAICmd_CustomAction(AI.GetActiveCommand());
                if (CustomActionCommand != None)
                {
                    AI.PopCommand(CustomActionCommand);
                }
                PreviousCustomAction = CurrentCustomAction;
                CurrentCustomAction = NewAction;
                CurrentPowerCustomAction = PowerCustomAction;
                Class'SFXAICmd_CustomAction'.static.StartCustomAction(AI, NewCA.AICommand);
                return TRUE;
            }
            else
            {
                if (AI != None)
                {
                    if (CurrentCustomAction != 0)
                    {
                        CustomActionEnded();
                    }
                    CustomActionCommand = SFXAICmd_CustomAction(AI.GetActiveCommand());
                    if (CustomActionCommand != None)
                    {
                        AI.PopCommand(CustomActionCommand);
                    }
                }
                DoCustomAction(NewAction, bForced, PowerCustomAction);
                return TRUE;
            }
        }
    }
    else
    {
        AI = SFXAI_Core(Controller);
        if (AI != None)
        {
        }
    }
    return FALSE;
}
public final simulated native function StopAllBodyStances(float BlendOutTime);

public final simulated native function StopBodyStance(const out BodyStance Stance, optional float BlendOutTime);

public final native function StopMovement(optional bool bStopRotation = TRUE);

public event function SyncPawnAppearance(BioPawn pSrcPawn)
{
    CopyPawnAppearance(pSrcPawn);
}
public simulated function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int idx;
    local SeqEvent_TakeDamage dmgEvent;
    local BioPlayerController PC;
    
    if (Squad != None)
    {
        for (idx = 0; idx < Squad.GeneratedEvents.Length; idx++)
        {
            dmgEvent = SeqEvent_TakeDamage(Squad.GeneratedEvents[idx]);
            if (dmgEvent != None)
            {
                dmgEvent.HandleDamage(Self, EventInstigator, DamageType, DamageAmount, HitLocation, DamageCauser);
            }
        }
    }
    if (IsHumanControlled())
    {
        PC = BioPlayerController(Controller);
        if (PC != None && PC.IsLocalPlayerController())
        {
            PC.HintSystem.HintEvent('Damaged', DamageType.Name);
        }
    }
    if (__DamageCallback__Delegate != None)
    {
        __DamageCallback__Delegate(Self, DamageAmount, EventInstigator, DamageType, DamageCauser);
    }
    Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}
public final event simulated function TerminateCurrentCustomAction()
{
    InterruptCustomAction();
}
public native function bool TermRagdoll();

public simulated function Tick(float DeltaTime)
{
    if (Controller == None)
    {
        return;
    }
    if (IsLocallyControlled() && Weapon != None)
    {
        HandleWeaponFiring();
    }
}
public event simulated function TornOff()
{
    if (!bPlayedDeath)
    {
        PlayDeathEffect(Class<SFXDamageType>(HitDamageType));
    }
    Super.TornOff();
}
public event function bool TryEarlyMantle(NavigationPoint Start, NavigationPoint End)
{
    LastMantleTime = WorldInfo.GameTimeSeconds;
    LastMantleLocation = Start.location;
    return StartCustomAction(32);
}
public native function TryLoadCombatGrammar();

public native function TryUnLoadCombatGrammar();

public final native function UnWeldPhysicsAssetInstance();

public final simulated native function UpdateAimOffset(Vector2D NewAimOffsetPct, float DeltaTime);

public event simulated function UpdateShadowSettings(bool bInWantShadow)
{
    local bool bNewCastShadow;
    local bool bNewCastDynamicShadow;
    
    if (Mesh != None)
    {
        bNewCastShadow = default.Mesh.CastShadow && bInWantShadow;
        bNewCastDynamicShadow = default.Mesh.bCastDynamicShadow && bInWantShadow;
        if (bNewCastShadow != Mesh.CastShadow || bNewCastDynamicShadow != Mesh.bCastDynamicShadow)
        {
            Mesh.CastShadow = bNewCastShadow;
            Mesh.bCastDynamicShadow = bNewCastDynamicShadow;
        }
    }
}
public native function bool ValidateRagdoll();

public simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
    if (SFXWeapon(InWeapon) != None)
    {
        SFXWeapon(InWeapon).WeaponStoppedFiring(GetWeaponFiringMode(InWeapon));
    }
}
public final native function WeldPhysicsAssetInstance();

public simulated function EPowerResistance GetPowerResistance(Pawn Caster, Vector HitLocation, Vector HitNormal, out float Damage, out Vector Force, Class<DamageType> DamageType, out Actor TargetOverride)
{
    local Class<SFXDamageType> damageClass;
    
    damageClass = Class<SFXDamageType>(DamageType);
    if (damageClass != None && damageClass.default.bDisableAIControl)
    {
        if (HasAnyShieldResistance())
        {
            return 1;
        }
    }
    else if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Fire'))
    {
        if (HasAnyShieldResistance())
        {
            return 1;
        }
    }
    else if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Electrocute'))
    {
        if (HasAnyShieldResistance())
        {
            return 1;
        }
    }
    else if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Freeze'))
    {
        if (HasAnyShieldResistance() || bCanRagdoll == FALSE || bAffectedByRagdollPowers == FALSE)
        {
            return 1;
        }
    }
    else if (damageClass != None && damageClass.default.bCausesRagdoll)
    {
        if (HasAnyShieldResistance() || bCanRagdoll == FALSE || bAffectedByRagdollPowers == FALSE)
        {
            return 1;
        }
    }
    return Super(Actor).GetPowerResistance(Caster, HitLocation, HitNormal, Damage, Force, DamageType, TargetOverride);
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    local float ForceMag;
    local EAICustomAction Action;
    local Vector X;
    local Vector Y;
    local Vector Z;
    local float Angle;
    local float SideAngle;
    local Class<SFXDamageType> dmgType;
    local array<EAICustomAction> Actions;
    local Class<SFXDamageType_Power_Fire> FireDmgType;
    local BioPlayerController PC;
    
    if (Resistance == EPowerResistance.Resistance_Full)
    {
        return FALSE;
    }
    if (Damage > 0.0)
    {
        TakeDamage(Damage, Caster != None ? Caster.Controller : None, HitLocation, vect(0.0, 0.0, 0.0), DamageType, , Caster);
    }
    dmgType = Class<SFXDamageType>(DamageType);
    if (bCanRagdoll && Resistance == EPowerResistance.Resistance_None && (dmgType.default.bCausesRagdoll || dmgType.default.bCausesRagdollOnDeath && IsDead()))
    {
        if (DrivenVehicle != None)
        {
            DrivenVehicle.DriverLeave(TRUE);
        }
        AddRagdollImpulse(Force, Caster != None ? Caster.Controller : None, HitLocation);
        PC = BioPlayerController(Caster.Instigator.Controller);
        if (PC != None && bAchievementFlyingGranted == FALSE && VSize(Force) >= AchievementForceThreshold && dmgType.default.bIsMelee == FALSE)
        {
            PC.UpdateAccomplishmentProgression('FLYINGCOUNT');
            bAchievementFlyingGranted = TRUE;
        }
        return FALSE;
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        if (Resistance == EPowerResistance.Resistance_None && bUseLargeReactions == FALSE)
        {
            if (DrivenVehicle != None)
            {
                DrivenVehicle.DriverLeave(TRUE);
            }
            FireDmgType = Class<SFXDamageType_Power_Fire>(DamageType);
            if (FireDmgType != None)
            {
                Action = FireDmgType.static.PickFireReaction(Self);
            }
            if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Freeze'))
            {
                Action = Class'SFXDamageType_Power_Freeze'.static.PickFreezeReaction(Self);
            }
            if (ClassIsChildOf(DamageType, Class'SFXDamageType_Power_Electrocute'))
            {
                Action = Class'SFXDamageType_Power_Electrocute'.static.PickElectrocuteReaction(Self);
            }
            if (Action != EAICustomAction.CA_None)
            {
                return StartCustomAction(int(Action));
            }
        }
        ForceMag = VSize(Force);
        if (ForceMag > 0.0)
        {
            GetAxes(Rotation, X, Y, Z);
            Angle = Vector(Rotation) Dot Normal(Force);
            SideAngle = Y Dot Normal(Force);
            if (ClassIsChildOf(DamageType, Class'SFXDamageType_Melee'))
            {
                GetMeleeReactions(Angle, SideAngle, Actions);
            }
            if (ClassIsChildOf(DamageType, Class'SFXDamageType_SecondMelee'))
            {
                GetMeleeReactions(Angle, SideAngle, Actions);
            }
            if (bUseLargeReactions == FALSE && ClassIsChildOf(DamageType, Class'SFXDamageType_ThirdMelee'))
            {
                GetKnockbackReactions(Angle, SideAngle, Actions);
            }
            if (IsPlayerOwned() && IsInCover())
            {
                return FALSE;
            }
            if (HasAnyShieldResistance() == FALSE || !IsInCover() || IsInCoverLeaning())
            {
                if (Actions.Length == 0 && ForceMag >= PowerThreshold_Knockback)
                {
                    GetKnockbackReactions(Angle, SideAngle, Actions);
                }
                if (Actions.Length == 0 && ForceMag >= PowerThreshold_Stagger)
                {
                    GetStaggerReactions(Angle, SideAngle, Actions);
                }
                if (Actions.Length == 0 && ForceMag >= PowerThreshold_Standard)
                {
                    GetStandardReactions(Angle, SideAngle, Actions);
                }
            }
            if (Actions.Length > 0)
            {
                return StartCustomAction(int(Actions[Rand(Actions.Length)]));
            }
        }
    }
    return FALSE;
}
public simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    if (Action.newPhysics == EPhysics.PHYS_RigidBody)
    {
        if (!InitRagdoll())
        {
        }
    }
    else
    {
        Super(Actor).OnSetPhysics(Action);
    }
}
public simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Vector vLocation;
    local Rotator rRotation;
    local Actor destActor;
    local BioPlayerController oPlayerController;
    
    oPlayerController = BioPlayerController(Controller);
    if (oPlayerController != None)
    {
        oPlayerController.bSkipPhysicsForOneFrame = TRUE;
        oPlayerController.OnTeleportCameraSync(Action);
    }
    LeaveCover();
    Super.OnTeleport(Action);
    if (Action.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        if (Action.bUpdateRotation)
        {
            Controller.Focus = None;
            Controller.SetFocalPoint(location + (vect(100.0, 0.0, 0.0) >> rRotation));
        }
    }
}
public simulated function CacheAnimNodes()
{
    local AnimNodeSlot SlotNode;
    
    ClearAnimNodes();
    if (Mesh != None && Mesh.Animations != None)
    {
        foreach Mesh.AllAnimNodes(Class'AnimNodeSlot', SlotNode)
        {
            if (SlotNode.NodeName == 'None')
            {
                continue;
            }
            switch (SlotNode.NodeName)
            {
                case 'Custom_FullBody':
                    BodyStanceNodes[0] = SlotNode;
                    break;
                case 'Custom_Std_Upper':
                    BodyStanceNodes[1] = SlotNode;
                    break;
                case 'Custom_Std_Idle_Lower':
                    BodyStanceNodes[2] = SlotNode;
                    break;
                case 'Custom_Std_Cov_Upper':
                    BodyStanceNodes[3] = SlotNode;
                    break;
                case 'Custom_Std_Cov_Lean_Upper':
                    BodyStanceNodes[4] = SlotNode;
                    break;
                case 'Custom_Std_Cov_PartLean_Upper':
                    BodyStanceNodes[8] = SlotNode;
                    break;
                case 'Custom_Mid_Cov_Upper':
                    BodyStanceNodes[5] = SlotNode;
                    break;
                case 'Custom_Mid_Cov_Lean_Upper':
                    BodyStanceNodes[6] = SlotNode;
                    break;
                case 'Custom_Mid_Cov_PartLean_Upper':
                    BodyStanceNodes[9] = SlotNode;
                    break;
                case 'Custom_Mid_Cov_Popup_Upper':
                    BodyStanceNodes[7] = SlotNode;
                    break;
                case 'Custom_Mid_Cov_PartPopup_Upper':
                    BodyStanceNodes[10] = SlotNode;
                    break;
                case 'Custom_Crouching_Upper':
                    BodyStanceNodes[11] = SlotNode;
                    break;
                default:
                    break;
            }
        }
    }
}
public simulated function ClearAnimNodes()
{
    BodyStanceNodes.Length = 0;
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    local SFXModule_Damage DmgModule;
    local Class<SFXDamageType> SFXDamageType;
    local SFXAI_Core AI;
    local bool bPermanentDeath;
    
    SFXDamageType = Class<SFXDamageType>(DamageType);
    DmgModule = GetModule(Class'SFXModule_Damage');
    PlayDeathVocalization(Killer != None ? BioPawn(Killer.Pawn) : None);
    AI = SFXAI_Core(Controller);
    if (AI == None && DrivenVehicle != None)
    {
        AI = SFXAI_Core(DrivenVehicle.Controller);
    }
    bPermanentDeath = FALSE;
    if (!SFXGame(WorldInfo.Game).PreventPermanentDeath(Self) && bPreventPermanentDeath == FALSE)
    {
        if (SFXDamageType != None && SFXDamageType.default.bImmediateDeath || IsInState('Downed', ) || HasDeathReaction() == FALSE && IsPlayingDeathReaction() == FALSE)
        {
            bPermanentDeath = TRUE;
        }
    }
    if (!bPermanentDeath)
    {
        if (AI != None && !Squad.bIsPlayerSquad)
        {
            AI.EnableAI(FALSE, 16);
        }
        KilledBy = Killer;
        KilledByDamageType = DamageType;
        KilledByHitLocation = HitLocation;
        GotoState('Downed', , , );
        return FALSE;
    }
    if (AI != None)
    {
        AI.NotifyDeathBlow(DamageType);
    }
    if (Squad != None)
    {
        Squad.Died(Self, Killer);
    }
    MakeNoise(1.0, 'NoiseType_Death');
    Controller.ClearTimer('UpdateAllEnemyInfo');
    if (DmgModule != None)
    {
        DmgModule.SetCurrentHealth(float(Min(0, int(DmgModule.GetCurrentHealth()))));
    }
    HitDamageType = DamageType;
    TakeHitLocation = HitLocation;
    Super.Died(Killer, DamageType, HitLocation);
    return TRUE;
}
public simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
    local SFXWeapon ChkWeapon;
    local bool bValidFiringUpdate;
    
    ChkWeapon = SFXWeapon(InWeapon);
    bValidFiringUpdate = !IsZero(InFlashLocation);
    if (int(FiringMode) == 4)
    {
        bValidFiringUpdate = FALSE;
    }
    if (bValidFiringUpdate)
    {
        WeaponFired(InWeapon, bViaReplication, InFlashLocation);
        if (IsInvisible())
        {
            BreakStealth();
        }
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
    if (bValidFiringUpdate && bViaReplication && ChkWeapon != None)
    {
        ChkWeapon.CalcRemoteImpactEffects(FiringMode, FlashLocation, bViaReplication);
    }
}
public function gibbedBy(Actor Other);

public simulated function bool ModifyDamage(out float Damage, Vector Momentum, out DamageCalculationAlgorithm DamageCalc, const out TraceHitInfo HitInfo, Vector HitLocation, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser)
{
    local SFXGRI GRI;
    local SFXWeapon WeaponDamageCauser;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (InGodMode() || m_bPlotProtected || !bCanBeDamaged)
    {
        return FALSE;
    }
    if (PhysicsVolume != None && PhysicsVolume.bNeutralZone)
    {
        return FALSE;
    }
    if (DamageType.default.bDamagesFriends == FALSE && IsDead() == FALSE && instigatedBy != None && instigatedBy.PlayerReplicationInfo != None && (instigatedBy.Pawn == Self || !IsHostile(instigatedBy.Pawn)))
    {
        return FALSE;
    }
    WeaponDamageCauser = SFXWeapon(DamageCauser);
    if (WeaponDamageCauser != None && WeaponDamageCauser.bDummyFireWeapon)
    {
        if (!WeaponDamageCauser.bDamagesFriends && (int(GetTeamNum()) == int(WeaponDamageCauser.DummyTeamIndex) || int(GetTeamNum()) == 255 || int(WeaponDamageCauser.DummyTeamIndex) == 255))
        {
            return FALSE;
        }
    }
    if (GetCurrentHealth() <= float(0))
    {
        Damage = 1.0;
    }
    if (Physics == EPhysics.PHYS_RigidBody && SFXWeapon(DamageCauser) != None && SFXPawn_Player(Self) == None)
    {
        DamageCalc.Weapon_RagdollDamageMultiplier = GRI.gameconfig.PawnInRagdollDamageMultiplier;
    }
    return TRUE;
}
public simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
    local SFXShield_Base ChkShield;
    local ShieldLoadout ShieldLoadout;
    local ScaledFloat MaxShields;
    
    Super.OnGiveInventory(inAction);
    if (Loadout != None)
    {
        foreach InvManager.InventoryActors(Class'SFXShield_Base', ChkShield)
        {
            foreach Loadout.ShieldLoadouts(ShieldLoadout, )
            {
                if (ShieldLoadout.Shields == ChkShield.Class)
                {
                    ChkShield.ShieldScale = Loadout.ShieldScale;
                    ChkShield.ShieldOffset = Loadout.ShieldOffset;
                    MaxShields = ChkShield.GetMaxShieldStruct();
                    MaxShields.Level = int(Lerp(ShieldLoadout.ShieldLevelRange.X, ShieldLoadout.ShieldLevelRange.Y, 0.0));
                    if (ShieldLoadout.MaxShields.X != float(0) || ShieldLoadout.MaxShields.Y != float(0))
                    {
                        MaxShields.X = ShieldLoadout.MaxShields.X;
                        MaxShields.Y = ShieldLoadout.MaxShields.Y;
                    }
                    ChkShield.SetMaxShields(MaxShields);
                }
            }
        }
        ScaleEquipment(GetScaledLevel(), Loadout);
    }
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    local SFXPowerCustomActionBase Power;
    local SFXModule_Damage DmgModule;
    
    DmgModule = GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        DmgModule.SetCurrentHealth(0.0);
    }
    if (Squad != None)
    {
        Squad.RemoveDyingMember(Self);
    }
    ScaleLimitTimeToGo = 1.0;
    GotoState('Dying', , , );
    if (!InitRagdoll())
    {
    }
    Mesh.AddImpulse(TearOffMomentum, HitLoc, DeathHitBoneName);
    bReplicateMovement = FALSE;
    bTearOff = TRUE;
    Velocity += TearOffMomentum;
    bPlayedDeath = TRUE;
    if (!bCollidesAfterDeath)
    {
        Mesh.SetRBChannel(16);
        Mesh.SetRBCollidesWithChannel(2, FALSE);
    }
    TimeOfDeath = WorldInfo.GameTimeSeconds;
    ManageRagdolls();
    m_bEnableRagdollRecovery = FALSE;
    if (!IsPlayerPawn())
    {
        InterruptCustomAction();
    }
    RemoveLifeTimeCrust();
    if (PowerManager != None)
    {
        foreach PowerManager.Powers(Power, )
        {
            Power.OnOwnerDied();
        }
    }
    bIsDead = TRUE;
}
public simulated function PlayDyingSound()
{
    if (DyingSound != None)
    {
        PlaySound(DyingSound, TRUE);
    }
    Super.PlayDyingSound();
}
public function PossessedBy(Controller C, bool bVehicleTransition)
{
    Super.PossessedBy(C, bVehicleTransition);
    if (IsPlayerPawn())
    {
        bIsAPlayer = TRUE;
    }
}
public function bool SpecialMoveTo(NavigationPoint Start, NavigationPoint End, Actor Next)
{
    local ReachSpec CurrentPath;
    
    if (Start == None)
    {
        return FALSE;
    }
    if (Start == End)
    {
        return FALSE;
    }
    CurrentPath = Start.GetReachSpecTo(End);
    if (CurrentPath != Controller.CurrentPath)
    {
        CurrentPath = Controller.CurrentPath;
    }
    if (CurrentPath != None)
    {
        if (CurrentPath.IsA('MantleReachSpec'))
        {
            if (MantleMarker(End) != None)
            {
                return SpecialMoveTo_ClimbUp(Start, End);
            }
            else if (MantleMarker(Start) != None)
            {
                return SpecialMoveTo_ClimbDown(Start, End);
            }
            else
            {
                return SpecialMoveTo_Mantle(Start, End);
            }
        }
        else if (CurrentPath.IsA('SwatTurnReachSpec'))
        {
            return SpecialMoveTo_SwatTurn(Start, End);
        }
        else if (CurrentPath.IsA('CoverSlipReachSpec'))
        {
            return SpecialMoveTo_CoverSlip(Start, End);
        }
        else if (CurrentPath.IsA('SlotToSlotReachSpec'))
        {
            return SpecialMoveTo_MoveAlongCover(CoverSlotMarker(Start), CoverSlotMarker(End));
        }
        else if (CurrentPath.IsA('SFXBoostReachSpec'))
        {
            return SpecialMoveTo_Boost(Start, End);
        }
        else if (CurrentPath.IsA('SFXJumpDownReachSpec'))
        {
            return SpecialMoveTo_JumpDown(Start, End);
        }
        else if (CurrentPath.IsA('SFXClimbWallReachSpec'))
        {
            return SpecialMoveTo_ClimbWall(Start, End);
        }
        else if (CurrentPath.IsA('SFXLeapReachSpecBase'))
        {
            return SpecialMoveTo_Leap(Start, End);
        }
        else if (CurrentPath.IsA('SFXLadderReachSpec'))
        {
            return SpecialMoveTo_LadderClimb(Start, End);
        }
        else if (CurrentPath.IsA('SFXJumpReachSpec'))
        {
            return SpecialMoveTo_GapJump(Start, End);
        }
        else if (CurrentPath.IsA('SFXLargeClimbReachSpec'))
        {
            if (SFXNav_LargeClimbNode(Start).bTopNode)
            {
                return SpecialMoveTo_ClimbDown(Start, End);
            }
            else
            {
                return SpecialMoveTo_ClimbUp(Start, End);
            }
        }
        else if (CurrentPath.IsA('SFXLargeMantleReachSpec'))
        {
            return SpecialMoveTo_Mantle(Start, End);
        }
        else if (CurrentPath.IsA('SFXLargeBoostReachSpec'))
        {
            return SpecialMoveTo_Boost(Start, End);
        }
    }
    return FALSE;
}
public function TakeFallingDamage()
{
    local float EffectiveSpeed;
    
    if (Velocity.Z < -0.5 * MaxFallSpeed)
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            MakeNoise(1.0, );
            if (Velocity.Z < float(-1) * MaxFallSpeed)
            {
                EffectiveSpeed = Velocity.Z;
                if (TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                if (EffectiveSpeed < float(-1) * MaxFallSpeed)
                {
                    TakeDamage(-100.0 * (EffectiveSpeed + MaxFallSpeed) / MaxFallSpeed, None, location, vect(0.0, 0.0, 0.0), Class'SFXDamageType_PowerPhysics');
                }
            }
        }
    }
    else if (Velocity.Z < -1.39999998 * JumpZ)
    {
        MakeNoise(0.5, );
    }
    else if (Velocity.Z < -0.800000012 * JumpZ)
    {
        MakeNoise(0.200000003, );
    }
}
public function UnPossessed()
{
    Super.UnPossessed();
    bIsAPlayer = FALSE;
}
public simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
    if (SFXWeapon(InWeapon) != None)
    {
        SFXWeapon(InWeapon).WeaponFired(GetWeaponFiringMode(InWeapon), bViaReplication, HitLocation);
    }
}
public function AcquireReplicatedCustomActionImpact()
{
    CurrentReplicatedCustomActionImpactRefCount++;
}
public function AcquireReplicatedPowerSubsequentImpact()
{
    CurrentReplicatedPowerSubsequentImpactRefCount++;
}
public function bool AcquireTargetTicket(int nCost)
{
    m_nTargetTickets += nCost;
    return m_nTargetTickets <= GetMaxTargetTickets();
}
public final function AdjustCredits(int i)
{
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo != None)
    {
        AdjustInventoryResource(0, i, TRUE);
    }
}
public final function AdjustMediGel(int i)
{
    AdjustInventoryResource(1, i, TRUE);
}
public simulated function AnimNotifyBreakout()
{
    local BioCustomAction CurrentAction;
    
    if (IsHumanControlled() == TRUE)
    {
        if (GetCurrentCustomAction(CurrentAction) && CurrentAction != None && CurrentAction.IsA('SFXCustomAction_DamageReaction'))
        {
            InterruptCustomAction();
        }
    }
}
public simulated function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local BioCustomAction pAction;
    
    GetCurrentCustomAction(pAction);
    if (pAction != None)
    {
        pAction.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
    }
}
public final simulated function BreakStealth()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory('BreakableStealth');
    }
}
public final simulated function BS_AccelerateBlend(const out BodyStance Stance, float BlendAmount)
{
    local int i;
    
    for (i = 0; i < Stance.AnimName.Length; i++)
    {
        if (Stance.AnimName[i] != 'None' && i < BodyStanceNodes.Length && BodyStanceNodes[i] != None)
        {
            BodyStanceNodes[i].AccelerateBlend(BlendAmount);
        }
    }
}
public simulated function CacheCrucialAnimNodes()
{
    if (Mesh != None && Mesh.Animations != None)
    {
        LeftHandIK = SFXSkelControlLimb(Mesh.FindSkelControl('LeftArm'));
        foreach Mesh.AllAnimNodes(Class'BioAnimNodeFrame', SnapshotNode)
        {
            break;
        }
        foreach Mesh.AllAnimNodes(Class'BioAnimNodeBlendByAction', ActionNode)
        {
            break;
        }
    }
}
public simulated function bool CanBeBioticCharged()
{
    return TRUE;
}
public final simulated function bool CanGib()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return TRUE;
    }
    foreach Manager.GameEffects(Effect, )
    {
        if (Effect.bPreventGibs)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public simulated function bool CanHavePhysicsImpulse()
{
    if (IsDead())
    {
        return TRUE;
    }
    return !bPlayDeathAnimation && m_bPhysicsDamageEnabled && m_bEnableRagdollRecovery;
}
public simulated function bool CanOverrideCurrentCustomAction(int NewAction, optional int PowerCustomAction)
{
    local BioCustomAction CurrentCA;
    local BioCustomAction NewCA;
    local bool CanOverride;
    
    if (CurrentCustomAction == 0 || NewAction == 0)
    {
        return TRUE;
    }
    GetCurrentCustomAction(CurrentCA);
    if (CurrentCA == None)
    {
        return TRUE;
    }
    if (NewAction == 132)
    {
        NewCA = PowerCustomActions[PowerCustomAction];
    }
    else
    {
        NewCA = CustomActions[NewAction];
    }
    if (NewCA == None)
    {
        return FALSE;
    }
    CanOverride = CurrentCA.CanOverrideMoveWith(CurrentCustomAction, NewAction) || NewCA.CanOverrideCustomAction(CurrentCustomAction, NewAction);
    return CanOverride;
}
public simulated function bool CanPerformMantleSlow(out MantleInfo OutMantleInfo, optional bool bForceLocalSimulation = TRUE)
{
    local CovPosInfo FoundCover;
    local BioPlayerController BPC;
    
    OutMantleInfo.CurrentLink = None;
    OutMantleInfo.DestLink = None;
    OutMantleInfo.CurrentSlotIdx = -1;
    BPC = BioPlayerController(Controller);
    if (IsInCover() == FALSE)
    {
        if (CoverAction == ECoverAction.CA_Aimback)
        {
            return FALSE;
        }
        if (!IsLocallyControlled())
        {
            if (BPC != None && BPC.Role == ENetRole.ROLE_Authority)
            {
                if (Anchor == None)
                {
                    return FALSE;
                }
            }
            else
            {
                SetAnchor(NavigationPoint(ReplicatedCustomActionInfo.Target));
            }
        }
        else if (BPC != None && !ValidAnchor())
        {
            if (BPC.GetGameModeDefault().FindCover(FoundCover, TRUE))
            {
                if (FoundCover.LtToRtPct < 0.5)
                {
                    SetAnchor(FoundCover.Link.GetSlotMarker(FoundCover.LtSlotIdx));
                }
                else
                {
                    SetAnchor(FoundCover.Link.GetSlotMarker(FoundCover.RtSlotIdx));
                }
            }
        }
        if (CoverSlotMarker(Anchor) != None)
        {
            OutMantleInfo.CurrentLink = CoverSlotMarker(Anchor).OwningSlot.Link;
            OutMantleInfo.CurrentSlotIdx = CoverSlotMarker(Anchor).OwningSlot.SlotIdx;
        }
    }
    else
    {
        OutMantleInfo.CurrentSlotIdx = CurrentSlotIdx;
        OutMantleInfo.CurrentLink = CurrentLink;
        if (BPC != None)
        {
            OutMantleInfo.LeftSlotIdx = LeftSlotIdx;
            OutMantleInfo.RightSlotIdx = RightSlotIdx;
            OutMantleInfo.LeftSlot = OutMantleInfo.CurrentLink.Slots[OutMantleInfo.LeftSlotIdx];
            OutMantleInfo.RightSlot = OutMantleInfo.CurrentLink.Slots[OutMantleInfo.RightSlotIdx];
            OutMantleInfo.LeftLink = CoverLink(OutMantleInfo.LeftSlot.MantleTarget.Actor);
            OutMantleInfo.RightLink = CoverLink(OutMantleInfo.RightSlot.MantleTarget.Actor);
            OutMantleInfo.CurrentSlotPct = CurrentSlotPct;
            SetAnchor(OutMantleInfo.CurrentLink.GetSlotMarker(OutMantleInfo.CurrentSlotPct < 0.5 ? OutMantleInfo.LeftSlotIdx : OutMantleInfo.RightSlotIdx));
        }
    }
    if (OutMantleInfo.CurrentLink != None && OutMantleInfo.CurrentSlotIdx >= 0 && OutMantleInfo.CurrentSlotIdx < OutMantleInfo.CurrentLink.Slots.Length && OutMantleInfo.CurrentLink.Slots[OutMantleInfo.CurrentSlotIdx].MantleTarget.Actor != None)
    {
        OutMantleInfo.DestLink = CoverLink(OutMantleInfo.CurrentLink.Slots[OutMantleInfo.CurrentSlotIdx].MantleTarget.Actor);
    }
    OutMantleInfo.bIsOnASlot = TRUE;
    if (BPC != None && BPC.IsLocalPlayerController())
    {
        if (IsInCover())
        {
            if (Abs(BPC.RemappedJoyUp) < Abs(BPC.RemappedJoyRight) || BPC.RemappedJoyUp <= BPC.DeadZoneThreshold)
            {
                return FALSE;
            }
        }
        if (IsInCover())
        {
            OutMantleInfo.CurrentSlotIdx = PickClosestCoverSlot(TRUE);
            if (OutMantleInfo.CurrentSlotIdx == -1)
            {
                OutMantleInfo.bIsOnASlot = FALSE;
            }
        }
        if (OutMantleInfo.bIsOnASlot)
        {
            if ((OutMantleInfo.CurrentSlotIdx < 0 || OutMantleInfo.CurrentSlotIdx >= OutMantleInfo.CurrentLink.Slots.Length || OutMantleInfo.CurrentLink.Slots[OutMantleInfo.CurrentSlotIdx].bCanMantle == FALSE) && !OutMantleInfo.bForced)
            {
                return FALSE;
            }
        }
        else if (!OutMantleInfo.bForced)
        {
            if (OutMantleInfo.LeftSlotIdx < 0 || OutMantleInfo.LeftSlotIdx >= OutMantleInfo.CurrentLink.Slots.Length || OutMantleInfo.RightSlotIdx < 0 || OutMantleInfo.RightSlotIdx >= OutMantleInfo.CurrentLink.Slots.Length)
            {
                return FALSE;
            }
            else if (OutMantleInfo.CurrentSlotPct < 0.5 && OutMantleInfo.CurrentLink.Slots[OutMantleInfo.LeftSlotIdx].bCanMantle == FALSE || OutMantleInfo.CurrentSlotPct >= 0.5 && OutMantleInfo.CurrentLink.Slots[OutMantleInfo.RightSlotIdx].bCanMantle == FALSE)
            {
                return FALSE;
            }
        }
    }
    if (Controller != None || bForceLocalSimulation)
    {
        if (OutMantleInfo.bIsOnASlot)
        {
            if (OutMantleInfo.CurrentLink != None)
            {
                OutMantleInfo.CurrentSlot = OutMantleInfo.CurrentLink.Slots[OutMantleInfo.CurrentSlotIdx];
                OutMantleInfo.DestLink = CoverLink(OutMantleInfo.CurrentSlot.MantleTarget.Actor);
            }
            if ((OutMantleInfo.CurrentLink == None || OutMantleInfo.DestLink == None) && !OutMantleInfo.bForced)
            {
                return FALSE;
            }
        }
        else if ((OutMantleInfo.CurrentLink == None || OutMantleInfo.DestLink == None) && !OutMantleInfo.bForced)
        {
            return FALSE;
        }
        if (FindMantleDistance(OutMantleInfo) == FALSE)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public simulated function bool CanPlayDeathEffect()
{
    return TRUE;
}
public final simulated function bool CanReload()
{
    if (IsPerformingBlockingAction())
    {
        return FALSE;
    }
    if (CurrentCustomAction == 9)
    {
        return FALSE;
    }
    return TRUE;
}
public final simulated function bool CanSwitchWeapons()
{
    if (IsPerformingBlockingAction())
    {
        return FALSE;
    }
    if (CurrentCustomAction == 12 || CurrentCustomAction == 11)
    {
        return FALSE;
    }
    return TRUE;
}
public simulated function bool CanSyncTarget(BioPawn SyncTarget, Name SyncActionName)
{
    if (SyncTarget.SupportedSyncActions.Find(SyncActionName) != -1)
    {
        return TRUE;
    }
    return FALSE;
}
public final simulated function ClearRecentCoverFlag()
{
    bRecentlyTookCover = FALSE;
}
public simulated function ClientPlayAnimatedReaction(int CustomActionType, optional Vector HitLocation, optional Vector HitNormal, optional int BoneIndex, optional Class<SFXDamageType> DamageType, optional byte RandomRoll)
{
    local BioCustomAction CurrentAction;
    
    if (CustomActionType != 0 && VerifyCAHasBeenInstanced(CustomActionType) && !CustomActions[CustomActionType].bReplicateCustomAction)
    {
        if (Physics != EPhysics.PHYS_RigidBody)
        {
            CustomActions[CustomActionType].RandomReactionRolled = RandomRoll;
            StartCustomAction(CustomActionType);
            GetCurrentCustomAction(CurrentAction);
            if (SFXCustomAction_DamageReaction(CurrentAction) != None)
            {
                SFXCustomAction_DamageReaction(CurrentAction).Init(HitLocation, HitNormal, BoneIndex, TRUE, DamageType);
            }
        }
    }
}
public function CollectorPossess();

public function bool CreateWeapon(Class<SFXWeapon> WeaponClass, optional bool bEquipWeapon = FALSE)
{
    local int GroupIdx;
    local int EntryIdx;
    local SFXWeapon Wpn;
    
    if (SFXPawn_PlayerParty(Self) != None)
    {
        Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(WeaponClass, GroupIdx, EntryIdx);
        ReplaceWeapon(byte(GroupIdx), WeaponClass, bEquipWeapon);
    }
    else
    {
        Wpn = SFXWeapon(CreateInventory(WeaponClass));
        if (bCombatPawn && Weapon == None)
        {
            SetWeaponImmediately(Wpn);
        }
    }
    return TRUE;
}
public function CreateWeapons(SFXLoadoutData ChkLoadout, optional bool bForceFromEngineLoadout)
{
    local Class<SFXWeapon> WeaponClass;
    
    foreach ChkLoadout.Weapons(WeaponClass, )
    {
        CreateWeapon(WeaponClass);
    }
}
public final simulated function CustomActionAnimatedReactionUpdated()
{
    ClientPlayAnimatedReaction(ReplicatedAnimatedReactionInfo.CustomActionType, ReplicatedAnimatedReactionInfo.HitLocation, ReplicatedAnimatedReactionInfo.HitNormal, ReplicatedAnimatedReactionInfo.BoneIndex, ReplicatedAnimatedReactionInfo.DamageType, ReplicatedAnimatedReactionInfo.RandomRoll);
}
public final simulated function CustomActionEnded()
{
    local BioCustomAction CurrentAction;
    
    if (CurrentPowerCustomAction != 0)
    {
        CurrentAction = PowerCustomActions[CurrentPowerCustomAction];
    }
    else if (CurrentCustomAction != 0)
    {
        CurrentAction = CustomActions[CurrentCustomAction];
    }
    if (CurrentAction != None && CurrentAction.bStartedCustomAction)
    {
        CurrentAction.StopCustomAction();
    }
}
public final simulated function CustomActionImpactInfoUpdated(bool bKeepReplicationOrder)
{
    local BioCustomAction oAction;
    local BioPawn oInstigator;
    local int i;
    local int CustomActionType;
    local int PowerCustomActionType;
    local int ImpactsProcessCount;
    local int LastValidEntryIndex;
    
    LastValidEntryIndex = -1;
    for (i = 0; i < 4; ++i)
    {
        oInstigator = ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].Instigator;
        if (oInstigator == None)
        {
            if (bKeepReplicationOrder)
            {
                break;
            }
        }
        else
        {
            CustomActionType = ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].CustomActionType;
            PowerCustomActionType = ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].PowerCustomActionType;
            if (oInstigator.VerifyCAHasBeenInstanced(CustomActionType, PowerCustomActionType))
            {
                if (CustomActionType == 132)
                {
                    oAction = oInstigator.PowerCustomActions[PowerCustomActionType];
                }
                else
                {
                    oAction = oInstigator.CustomActions[CustomActionType];
                }
            }
            if (oAction != None)
            {
                oAction.ClientDoCustomActionImpact(Self, ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].ImpactCount, ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].bFirstTarget, ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].HitLocation, ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].HitNormal, ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].CustomActionReactionType);
            }
            ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex].Instigator = None;
            ++ImpactsProcessCount;
            LastValidEntryIndex = CurrentReplicatedCustomActionImpactIndex;
        }
        ++CurrentReplicatedCustomActionImpactIndex;
        if (CurrentReplicatedCustomActionImpactIndex >= 4)
        {
            CurrentReplicatedCustomActionImpactIndex = 0;
        }
    }
    if (!bKeepReplicationOrder)
    {
        CurrentReplicatedCustomActionImpactIndex = LastValidEntryIndex + 1;
        if (CurrentReplicatedCustomActionImpactIndex >= 4)
        {
            CurrentReplicatedCustomActionImpactIndex = 0;
        }
    }
    else if (ImpactsProcessCount == 0)
    {
        CustomActionImpactInfoUpdated(FALSE);
    }
}
public final simulated function CustomActionInfoUpdated()
{
    local BioCustomAction oAction;
    local BioCustomAction CurrentAction;
    local BioPlayerController PC;
    
    bHasReplicatedBufferedCustomAction = FALSE;
    if (VerifyCAHasBeenInstanced(ReplicatedCustomActionInfo.CustomActionType, ReplicatedCustomActionInfo.PowerCustomActionType))
    {
        if (ReplicatedCustomActionInfo.CustomActionType == 132)
        {
            oAction = PowerCustomActions[ReplicatedCustomActionInfo.PowerCustomActionType];
        }
        else
        {
            oAction = CustomActions[ReplicatedCustomActionInfo.CustomActionType];
        }
        if (oAction != None)
        {
            if (ReplicatedCustomActionInfo.Cmd == EReplicatedCustomActionCmd.eRCACmd_Start && CurrentCustomAction == 0 || ReplicatedCustomActionInfo.Cmd == EReplicatedCustomActionCmd.eRCACmd_Override)
            {
                oAction.ClientDoCustomAction(TRUE);
            }
            else if (ReplicatedCustomActionInfo.Cmd == EReplicatedCustomActionCmd.eRCACmd_Start && CurrentCustomAction != 0)
            {
                bHasReplicatedBufferedCustomAction = TRUE;
            }
            else if (ReplicatedCustomActionInfo.Cmd == EReplicatedCustomActionCmd.eRCACmd_Interrupt)
            {
                if (CurrentCustomAction == ReplicatedCustomActionInfo.CustomActionType && CurrentPowerCustomAction == ReplicatedCustomActionInfo.PowerCustomActionType)
                {
                    GetCurrentCustomAction(CurrentAction);
                    if (CurrentAction != None)
                    {
                        CurrentAction.InterruptThisCustomAction();
                    }
                }
            }
            if (Role == ENetRole.ROLE_AutonomousProxy)
            {
                PC = BioPlayerController(Controller);
                if (PC != None && PC.RemotePlayerPendingCustomAction == ReplicatedCustomActionInfo.CustomActionType && PC.RemotePlayerPendingPowerCustomAction == ReplicatedCustomActionInfo.PowerCustomActionType)
                {
                    PC.RemotePlayerResetPendingCustomActionInfo();
                }
            }
        }
    }
}
public final simulated function bool CustomActionMessageEvent(Name EventName, Object Sender)
{
    local BioCustomAction pAction;
    
    if (GetCurrentCustomAction(pAction))
    {
        return pAction.MessageEvent(EventName, Sender);
    }
    return FALSE;
}
public final simulated function DecrementRagdollCount()
{
    if (m_nRemainInRagdoll == 0)
    {
    }
    else
    {
        m_nRemainInRagdoll--;
    }
}
public simulated function DeferedEnsurePawnHasLandedFromRagdoll()
{
    if (Physics == EPhysics.PHYS_Falling)
    {
        SetPhysics(1);
    }
    else if (Physics == EPhysics.PHYS_RigidBody)
    {
        SetTimer(0.100000001, FALSE, 'DeferedEnsurePawnHasLandedFromRagdoll', );
    }
}
public simulated function DisableLeftHandIK()
{
    if (LeftHandIK != None)
    {
        if (ActionNode.ActiveChildIndex == 0 && ActionNode.BlendTimeToGo <= float(0))
        {
            LeftHandIK.bSetStrengthFromAnimNode = FALSE;
            LeftHandIK.SetSkelControlActive(FALSE);
        }
        else
        {
            LeftHandIK.bSetStrengthFromAnimNode = TRUE;
        }
    }
}
public simulated function EnableLeftHandIK()
{
    if (LeftHandIK != None)
    {
        if (ActionNode.ActiveChildIndex == 0 && ActionNode.BlendTimeToGo <= float(0))
        {
            LeftHandIK.bSetStrengthFromAnimNode = TRUE;
        }
        else
        {
            LeftHandIK.bSetStrengthFromAnimNode = FALSE;
            LeftHandIK.SetSkelControlActive(TRUE);
        }
    }
}
public final simulated function EndCustomAction()
{
    DoCustomAction(0);
}
public final simulated function FadeOutReloadAnim()
{
    local SFXWeapon ChkWeapon;
    
    ChkWeapon = SFXWeapon(Weapon);
    if (ChkWeapon != None)
    {
        ChkWeapon.ReloadNearFinished();
    }
}
public static simulated function Pawn FindAttackingPawn(Controller instigatedBy, Actor DamageCauser)
{
    local Pawn P;
    local Weapon W;
    local SFXProjectile T;
    
    if (instigatedBy != None && instigatedBy.Pawn != None)
    {
        return instigatedBy.Pawn;
    }
    else if (DamageCauser != None)
    {
        P = Pawn(DamageCauser);
        if (P != None)
        {
            return P;
        }
        W = Weapon(DamageCauser);
        if (W != None)
        {
            return W.Instigator;
        }
        T = SFXProjectile(DamageCauser);
        if (T != None)
        {
            if (T.Instigator != None)
            {
                return T.Instigator;
            }
            else if (T.ProjectileOwner != None)
            {
                return T.ProjectileOwner.Instigator;
            }
        }
    }
    return None;
}
public final simulated function ECoverType FindCoverType()
{
    local ECoverType LeftType;
    local ECoverType RightType;
    
    if (CurrentLink.Slots.Length > 1)
    {
        if (LeftSlotIdx < 0 || RightSlotIdx < 0 || LeftSlotIdx >= CurrentLink.Slots.Length || RightSlotIdx >= CurrentLink.Slots.Length)
        {
            ScriptTrace();
        }
        LeftType = CurrentLink.Slots[LeftSlotIdx].CoverType;
        RightType = CurrentLink.Slots[RightSlotIdx].CoverType;
        if (CurrentSlotPct <= 0.100000001)
        {
            return LeftType;
        }
        else if (CurrentSlotPct >= 0.899999976)
        {
            return RightType;
        }
        else if (int(LeftType) > int(RightType))
        {
            return LeftType;
        }
        else
        {
            return RightType;
        }
    }
    return CurrentLink.Slots[0].CoverType;
}
public simulated function bool FindMantleDistance(out MantleInfo OutMantleInfo)
{
    local Vector StartTrace;
    local Vector EndTrace;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector BackupExtent;
    local float ExtentRadius;
    local float CollisionRadius;
    local Actor HitActor;
    
    GetMantleInformation(OutMantleInfo);
    StartTrace = GetBasedPosition(OutMantleInfo.MantleEndLoc);
    EndTrace = GetBasedPosition(OutMantleInfo.MantleStartLoc);
    BackupExtent = GetCollisionExtent() * 0.5;
    HitActor = Trace(HitLocation, HitNormal, EndTrace - vect(0.0, 0.0, 32.0), EndTrace, TRUE, , , );
    if (Pawn(HitActor) != None && HitActor.bBlockActors && HitActor.bTearOff == FALSE && !OutMantleInfo.bForced)
    {
        return FALSE;
    }
    StartTrace = GetBasedPosition(OutMantleInfo.MantleEndLoc);
    if (IsInCover())
    {
        EndTrace = StartTrace - Vector(Rotation) * OutMantleInfo.MantleDistance;
    }
    else
    {
        EndTrace = StartTrace - Normal(GetBasedPosition(OutMantleInfo.MantleEndLoc) - GetBasedPosition(OutMantleInfo.MantleStartLoc)) * OutMantleInfo.MantleDistance;
    }
    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, FALSE, vect(1.0, 1.0, 1.0), , );
    if (HitActor == None)
    {
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, FALSE, BackupExtent, , );
    }
    if (HitActor != None)
    {
        CollisionRadius = GetCollisionRadius();
        ExtentRadius = CollisionRadius * Sqrt(2.0) + 1.0;
        SetBasedPosition(OutMantleInfo.MantleEndLoc, HitLocation + Normal(StartTrace - EndTrace) * ExtentRadius);
        OutMantleInfo.MantleDistance = VSize2D(GetBasedPosition(OutMantleInfo.MantleEndLoc) - GetBasedPosition(OutMantleInfo.MantleStartLoc));
        OutMantleInfo.RootMotionScaleFactor = FMax(OutMantleInfo.MantleDistance / OutMantleInfo.DefaultMantleDistance, 1.0);
    }
    else if (!OutMantleInfo.bForced)
    {
        return FALSE;
    }
    if (VerifyLandingClear(OutMantleInfo) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public final function GenerateInventoryFromLoadout(SFXLoadoutData oLoadout)
{
    local ShieldLoadout ShieldLoadout;
    
    if (oLoadout != None)
    {
        if (bShouldSpawnWeapons)
        {
            CreateWeapons(oLoadout);
        }
        foreach oLoadout.ShieldLoadouts(ShieldLoadout, )
        {
            CreateInventory(ShieldLoadout.Shields);
        }
    }
}
public final function GenerateRegenVocalization()
{
    if (IsDead() == FALSE)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(71, Self, None);
    }
}
public final function float GetAbilityTimeStamp(Name AbilityName)
{
    local int idx;
    
    idx = AbilityTimeStamps.Find('AbilityName', AbilityName);
    if (idx != -1)
    {
        return AbilityTimeStamps[idx].TimeStamp;
    }
    return 0.0;
}
public final simulated function ECoverType GetCoverTypeFor(CovPosInfo Cover)
{
    local ECoverType LeftType;
    local ECoverType RightType;
    
    if (Cover.Link == None)
    {
        return 0;
    }
    if (Cover.Link.Slots.Length > 1)
    {
        if (Cover.LtToRtPct == 0.0)
        {
            return Cover.Link.Slots[Cover.LtSlotIdx].CoverType;
        }
        else
        {
            LeftType = Cover.Link.Slots[Cover.LtSlotIdx].CoverType;
            RightType = Cover.Link.Slots[Cover.RtSlotIdx].CoverType;
            return int(LeftType) > int(RightType) ? LeftType : RightType;
        }
    }
    return Cover.Link.Slots[0].CoverType;
}
public final simulated function EResistanceType GetCurrentResistance()
{
    local SFXShield_Base Shield;
    local SFXModule_Damage DamageMod;
    
    if (InvManager != None)
    {
        Shield = SFXShield_Base(InvManager.FindInventoryType(Class'SFXShield_Base', TRUE));
        if (Shield != None && Shield.GetCurrentShields() > float(0))
        {
            return Shield.Resistance;
        }
    }
    DamageMod = GetModule(Class'SFXModule_Damage');
    if (DamageMod != None && DamageMod.HealthType != EHealthType.HealthType_Default)
    {
        switch (DamageMod.HealthType)
        {
            case EHealthType.HealthType_Shields:
                return EResistanceType.ResistanceType_Shield;
            case EHealthType.HealthType_Barrier:
                return EResistanceType.ResistanceType_Biotic;
            case EHealthType.HealthType_Armour:
                return EResistanceType.ResistanceType_Armour;
            default:
        }
    }
    return EResistanceType.ResistanceType_None;
}
public simulated function float GetEstimatedHorizFallDist(out MantleInfo OutMantleInfo)
{
    local float T;
    
    T = Sqrt(GetCollisionHeight() / Abs(GetGravityZ()));
    return VSize(GetInitialFallVelocity(OutMantleInfo) * T);
}
public final simulated function ParticleSystem GetFootStepEffect(PhysicalMaterial PhysMat, int FootDown)
{
    if (PhysMat == None || PhysMat.PhysicalMaterialProperty == None || SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty) == None || SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialFootSteps == None)
    {
        return None;
    }
    return GetSpecificFootStepEffect(SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialFootSteps, FootDown);
}
public final simulated function SFXGameEffect GetGameEffect(Name GEName)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class.Name == GEName)
            {
                return oEffect;
            }
        }
    }
    return None;
}
public simulated function Vector GetInitialFallVelocity(out MantleInfo OutMantleInfo)
{
    return Vector(Rotation) * OutMantleInfo.FallForwardVelocity * OutMantleInfo.RootMotionScaleFactor;
}
protected function bool GetKnockbackReactions(float Angle, float SideAngle, out array<EAICustomAction> OutActions)
{
    if (!bUseLargeReactions)
    {
        if (SideAngle < -0.707000017 && CustomActionClasses[94] != None)
        {
            OutActions.AddItem(94);
        }
        else if (SideAngle > 0.707000017 && CustomActionClasses[95] != None)
        {
            OutActions.AddItem(95);
        }
        else if (Angle < -0.707000017 && CustomActionClasses[92] != None)
        {
            OutActions.AddItem(92);
        }
        else if (Angle > 0.707000017 && CustomActionClasses[93] != None)
        {
            OutActions.AddItem(93);
        }
    }
    if (OutActions.Length > 0)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function GetMantleInformation(out MantleInfo OutMantleInfo)
{
    local Vector MantleDir;
    local Vector Dir1;
    local Vector Dir2;
    local Vector CrouchOffset;
    
    if (OutMantleInfo.bIsOnASlot)
    {
        MantleDir = OutMantleInfo.DestLink.GetSlotLocation(OutMantleInfo.CurrentSlot.MantleTarget.SlotIdx) - location;
        MantleDir.Z = 0.0;
        OutMantleInfo.MantleDistance = VSize2D(MantleDir);
    }
    else if (OutMantleInfo.LeftLink != None && OutMantleInfo.RightLink != None)
    {
        Dir1 = OutMantleInfo.LeftLink.GetSlotLocation(OutMantleInfo.LeftSlot.MantleTarget.SlotIdx) - location;
        Dir1.Z = 0.0;
        Dir2 = OutMantleInfo.RightLink.GetSlotLocation(OutMantleInfo.RightSlot.MantleTarget.SlotIdx) - location;
        Dir2.Z = 0.0;
        MantleDir = VLerp(Dir1, Dir2, OutMantleInfo.CurrentSlotPct);
        OutMantleInfo.MantleDistance = VSize2D(MantleDir);
    }
    else if (OutMantleInfo.LeftLink != None)
    {
        MantleDir = OutMantleInfo.LeftLink.GetSlotLocation(OutMantleInfo.LeftSlot.MantleTarget.SlotIdx) - OutMantleInfo.CurrentLink.GetSlotLocation(OutMantleInfo.LeftSlotIdx);
        MantleDir.Z = 0.0;
        OutMantleInfo.MantleDistance = VSize2D(MantleDir);
    }
    else if (OutMantleInfo.RightLink != None)
    {
        MantleDir = OutMantleInfo.RightLink.GetSlotLocation(OutMantleInfo.RightSlot.MantleTarget.SlotIdx) - OutMantleInfo.CurrentLink.GetSlotLocation(OutMantleInfo.RightSlotIdx);
        MantleDir.Z = 0.0;
        OutMantleInfo.MantleDistance = VSize2D(MantleDir);
    }
    if (IsInCover())
    {
        if (IsLocallyControlled())
        {
            MantleDir = Vector(Rotation);
        }
        else
        {
            MantleDir = Vector(OutMantleInfo.CurrentLink.GetSlotRotation(OutMantleInfo.CurrentSlotIdx));
        }
    }
    else
    {
        MantleDir = Normal(MantleDir);
    }
    CrouchOffset.X = 0.0;
    CrouchOffset.Y = 0.0;
    CrouchOffset.Z = GetCollisionHeight() - CrouchHeight;
    SetBasedPosition(OutMantleInfo.MantleStartLoc, location - CrouchOffset);
    SetBasedPosition(OutMantleInfo.MantleEndLoc, location - CrouchOffset + MantleDir * OutMantleInfo.MantleDistance);
}
protected function bool GetMeleeReactions(float Angle, float SideAngle, out array<EAICustomAction> OutActions)
{
    if (!bUseLargeReactions)
    {
        if (SideAngle < -0.707000017 && CustomActionClasses[98] != None)
        {
            OutActions.AddItem(98);
        }
        else if (SideAngle > 0.707000017 && CustomActionClasses[99] != None)
        {
            OutActions.AddItem(99);
        }
        else if (Angle < -0.707000017 && CustomActionClasses[96] != None)
        {
            OutActions.AddItem(96);
        }
        else if (Angle > 0.707000017 && CustomActionClasses[97] != None)
        {
            OutActions.AddItem(97);
        }
        if (OutActions.Length > 0)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function Name GetPartFromHit(out TraceHitInfo HitInfo)
{
    local array<Name> BoneNames;
    local Name BoneName;
    local int idx;
    
    BoneName = HitInfo.BoneName;
    if (BoneName != 'None')
    {
        for (idx = 0; idx < ReactionBones.Length; idx++)
        {
            BoneNames = ReactionBones[idx].BoneNames;
            if (BoneNames.Find(BoneName) != -1)
            {
                return ReactionBones[idx].BodyPart;
            }
        }
    }
    return 'None';
}
public final simulated function Name GetRandomImpactBone()
{
    local int BodyPartIndex;
    local ReactionPart BodyPart;
    local int BoneIndex;
    local Name BoneName;
    
    BoneName = 'None';
    if (ReactionBones.Length > 0)
    {
        BodyPartIndex = Rand(ReactionBones.Length);
        BodyPart = ReactionBones[BodyPartIndex];
        if (BodyPart.BoneNames.Length > 0)
        {
            BoneIndex = Rand(BodyPart.BoneNames.Length);
            BoneName = BodyPart.BoneNames[BoneIndex];
        }
    }
    return BoneName;
}
public function int GetScaledLevel()
{
    local int PlayerLevel;
    local BioPlayerController oController;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (oWorldInfo != None)
    {
        oController = oWorldInfo.GetLocalPlayerController();
    }
    if (SFXGRI(WorldInfo.GRI).GetPlayerLevel(LocalPlayer(oController.Player).ControllerId, PlayerLevel))
    {
        return PlayerLevel;
    }
    return 1;
}
public final simulated function float GetShieldRegenDelay()
{
    local SFXShield_Base ShieldObj;
    
    if (InvManager == None)
    {
        return 0.0;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ShieldObj)
    {
        return ShieldObj.GetShieldRegenDelay();
    }
    return 0.0;
}
public final simulated function float GetShieldRegenPct()
{
    local SFXShield_Base ShieldObj;
    
    if (InvManager == None)
    {
        return 0.0;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ShieldObj)
    {
        return ShieldObj.ShieldRegenPct;
    }
    return 0.0;
}
public final simulated function SFXShield_Base GetShields()
{
    local SFXShield_Base Shield;
    
    if (InvManager == None)
    {
        return None;
    }
    foreach InvManager.InventoryActors(Class'SFXShield_Base', Shield)
    {
        return Shield;
    }
    return None;
}
public final simulated function int GetSlotIdxByPct()
{
    if (CurrentSlotPct < 0.5)
    {
        return LeftSlotIdx;
    }
    return RightSlotIdx;
}
public simulated function ParticleSystem GetSpecificFootStepEffect(SFXPhysicalMaterialFootSteps FootStepMat, int FootDown)
{
    if (VSize(Velocity) > WalkSpeed * 1.14999998)
    {
        return FootStepMat.FootstepRun;
    }
    return FootStepMat.FootstepWalk;
}
protected function bool GetStaggerReactions(float Angle, float SideAngle, out array<EAICustomAction> OutActions)
{
    if (!bUseLargeReactions)
    {
        if (SideAngle < -0.707000017 && CustomActionClasses[90] != None)
        {
            OutActions.AddItem(90);
        }
        else if (SideAngle > 0.707000017 && CustomActionClasses[91] != None)
        {
            OutActions.AddItem(91);
        }
        else if (Angle < -0.707000017)
        {
            if (CustomActionClasses[87] != None)
            {
                OutActions.AddItem(87);
            }
            if (CustomActionClasses[88] != None)
            {
                OutActions.AddItem(88);
            }
        }
        else if (Angle > 0.707000017 && CustomActionClasses[89] != None)
        {
            OutActions.AddItem(89);
        }
    }
    else if (WorldInfo.GameTimeSeconds - LastLargeReactionTime >= LargeReactionInterval)
    {
        if (SideAngle >= -0.707000017 && SideAngle <= 0.707000017 && Angle < -0.707000017 && CustomActionClasses[110] != None)
        {
            OutActions.AddItem(110);
        }
    }
    if (OutActions.Length > 0)
    {
        return TRUE;
    }
    return FALSE;
}
protected function bool GetStandardReactions(float Angle, float SideAngle, out array<EAICustomAction> OutActions)
{
    if (!bUseLargeReactions)
    {
        if (SideAngle <= -0.707000017 && CustomActionClasses[84] != None)
        {
            OutActions.AddItem(84);
        }
        else if (SideAngle > 0.707000017 && CustomActionClasses[85] != None)
        {
            OutActions.AddItem(85);
        }
        else if (Angle < -0.707000017)
        {
            if (CustomActionClasses[81] != None)
            {
                OutActions.AddItem(81);
            }
            if (CustomActionClasses[82] != None)
            {
                OutActions.AddItem(82);
            }
        }
        else if (CustomActionClasses[83] != None)
        {
            OutActions.AddItem(83);
        }
    }
    else if (WorldInfo.GameTimeSeconds - LastLargeReactionTime >= LargeReactionInterval)
    {
        if (SideAngle <= -0.707000017 && CustomActionClasses[113] != None)
        {
            OutActions.AddItem(113);
        }
        else if (SideAngle > 0.707000017 && CustomActionClasses[114] != None)
        {
            OutActions.AddItem(114);
        }
        else if (Angle < -0.707000017 && CustomActionClasses[111] != None)
        {
            OutActions.AddItem(111);
        }
        else if (CustomActionClasses[112] != None)
        {
            OutActions.AddItem(112);
        }
    }
    if (OutActions.Length > 0)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function SFXWeapon GetWeaponForSwitch(Class<SFXWeapon> cWeapon)
{
    local SFXWeapon Wpn;
    local SFXWeapon WpnForSwitch;
    
    foreach InvManager.InventoryActors(Class'SFXWeapon', Wpn)
    {
        if (ClassIsChildOf(Wpn.Class, cWeapon))
        {
            if (WpnForSwitch == None || Wpn.GetAIRating() > WpnForSwitch.GetAIRating())
            {
                WpnForSwitch = Wpn;
            }
        }
    }
    return WpnForSwitch;
}
public simulated function bool GetWeaponHandPosition(out Vector HandLoc, out Rotator HandRot)
{
    return Mesh.GetSocketWorldLocationAndRotation(RightHandSocketName, HandLoc, HandRot);
}
public simulated function GibHead(Vector HitLocation, Vector HitNormal, Name BoneName, Class<SFXDamageType> DamageType);

private final function bool HandleHitActorInMantle(Actor HitActor, Vector HitLocation, optional Vector StartDownTrace, optional out int bHitSomethingHoriz)
{
    local BioPawn ChkPawn;
    
    if (HitActor != None)
    {
        if (HitActor.bBlockActors && HitActor.bTearOff == FALSE)
        {
            ChkPawn = BioPawn(HitActor);
            if (ChkPawn != None && ChkPawn.IsDead())
            {
                return TRUE;
            }
            return FALSE;
        }
        if (bHitSomethingHoriz == 0)
        {
            bHitSomethingHoriz = 1;
            StartDownTrace = HitLocation;
        }
    }
    return TRUE;
}
public final simulated function HandleWeaponFiring()
{
    local bool bFireInputPressed;
    local bool bIsWeaponPendingFire;
    local SFXWeapon W;
    local int FireMode;
    
    bFireInputPressed = Controller != None && int(Controller.bFire) == 1;
    W = SFXWeapon(Weapon);
    if (W == None)
    {
        return;
    }
    FireMode = int(W.DefaultFireMode);
    if (InvManager != None && InvManager.IsPendingFire(W, FireMode))
    {
        bIsWeaponPendingFire = TRUE;
    }
    if (bIsWeaponPendingFire == FALSE && bFireInputPressed && CanFireWeapon())
    {
        StartFire(byte(FireMode));
        if (IsInvisible() && W.HasAmmo(W.CurrentFireMode))
        {
            BreakStealth();
        }
    }
    else if (bIsWeaponPendingFire && (bFireInputPressed == FALSE || CanFireWeapon() == FALSE))
    {
        if (Weapon == None)
        {
            if (InvManager != None)
            {
                InvManager.ClearPendingFire(None, FireMode);
            }
        }
        else
        {
            StopFire(byte(FireMode));
        }
    }
}
public final simulated function bool HasAnyShieldResistance()
{
    local int Mask;
    
    Mask = 6;
    if ((ResistanceType & Mask) != 0)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function bool HasDeathReaction()
{
    return DeathCustomAction != 0;
}
public final simulated function bool HasGameEffect(Name GEName)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class.Name == GEName)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final simulated function bool HasResistance(EResistanceType Resistance)
{
    local int Mask;
    
    Mask = 1 << int(Resistance);
    if ((ResistanceType & Mask) != 0)
    {
        return TRUE;
    }
    return FALSE;
}
public final simulated function IncrementRagdollCount()
{
    m_nRemainInRagdoll++;
}
public final function bool InFullDecisionMode()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(Controller);
    if (PC != None && PC.ProfileSettings != None)
    {
        return PC.ProfileSettings.GetAutoReplyMode() == 0;
    }
    return TRUE;
}
public final simulated function InterruptCustomAction()
{
    local BioCustomAction CurrentAction;
    
    if (GetCurrentCustomAction(CurrentAction))
    {
        if (CurrentAction != None)
        {
            CurrentAction.InterruptThisCustomAction();
        }
    }
}
public final function bool IsAtRest()
{
    local Vector TraceEnd;
    local Vector TraceExtent;
    
    if (Role > ENetRole.ROLE_SimulatedProxy && VSize(Velocity) < m_fPhysicsRecoverSpeedThreshold)
    {
        TraceExtent = GetCollisionExtent();
        TraceEnd = location;
        TraceEnd.Z -= TraceExtent.Z + MaxStepHeight;
        TraceExtent.Z = 1.0;
        if (!FastTrace(TraceEnd, location, TraceExtent, FALSE))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function bool IsBlindFiring()
{
    return CoverAction == ECoverAction.CA_BlindRight || CoverAction == ECoverAction.CA_BlindLeft || CoverAction == ECoverAction.CA_BlindUp;
}
public simulated function IsDeadUpdated();

public final simulated function IsDownedUpdated()
{
    if (WorldInfo.GRI == None || PlayerReplicationInfo == None || KilledByDamageType == None)
    {
        SetTimer(0.100000001, FALSE, 'IsDownedUpdated', );
        return;
    }
    if (bIsDowned == TRUE && IsInState('Downed', ) == FALSE)
    {
        GotoState('Downed', , , );
    }
    else if (bIsDowned == FALSE && IsInState('Downed', ) == TRUE)
    {
        GotoState('InRagdoll', , , );
    }
    ClearTimer('IsDownedUpdated');
}
public final simulated function bool IsLeaning()
{
    return CoverAction == ECoverAction.CA_LeanRight || CoverAction == ECoverAction.CA_LeanLeft || CoverAction == ECoverAction.CA_PopUp;
}
public final simulated function bool IsPeeking()
{
    return CoverAction == ECoverAction.CA_PeekRight || CoverAction == ECoverAction.CA_PeekLeft || CoverAction == ECoverAction.CA_PeekUp;
}
public simulated function bool IsPlayingDeathReaction()
{
    local BioCustomAction Action;
    local SFXCustomAction_DamageReaction DmgAction;
    
    if (GetCurrentCustomAction(Action))
    {
        DmgAction = SFXCustomAction_DamageReaction(Action);
        if (DmgAction != None && DmgAction.bDeathReaction)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function bool IsPoppingUp()
{
    return CoverAction == ECoverAction.CA_PopUp;
}
private final simulated function KillOrStasis(bool bImmediate, Controller Killer, Class<DamageType> dmgType, string Cause)
{
    local SFXModule_Damage DamageMod;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        DamageMod = GetModule(Class'SFXModule_Damage');
        if (DamageMod == None || DamageMod.KillForStasis(bImmediate, Killer, dmgType) == FALSE)
        {
            BioApplyStasis(Cause);
        }
    }
}
public simulated function LoadCharacterClassData()
{
    local int nIndex;
    
    for (nIndex = 0; nIndex < PowerCustomActionClasses.Length; nIndex++)
    {
        if (ClassIsChildOf(PowerCustomActionClasses[nIndex], Class'SFXPowerCustomActionBase'))
        {
            VerifyCAHasBeenInstanced(132, nIndex);
        }
    }
    if (PowerManager != None)
    {
        PowerManager.MyPawn = Self;
        PowerManager.InitializePowerList();
        StartFirstUsePowerDelay();
    }
}
public simulated function MashSuccessUpdated()
{
    local BioCustomAction CurrentCA;
    
    GetCurrentCustomAction(CurrentCA);
    if (CurrentCA != None)
    {
        CurrentCA.MessageEvent('MashSuccess', None);
    }
}
public simulated function NotifyArmourAppearanceUpdated(int ArmourIdx);

public function NotifyImpactedByPower(SFXPowerCustomAction Power, BioPawn Caster)
{
    local int idx;
    local SFXSeqEvt_ImpactedByPower oImpactedEvent;
    
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        oImpactedEvent = SFXSeqEvt_ImpactedByPower(GeneratedEvents[idx]);
        if (oImpactedEvent != None)
        {
            oImpactedEvent.SetNameVars("Power", Power.PowerName);
            oImpactedEvent.SetObjectVars("Who", Self);
            oImpactedEvent.SetObjectVars("Caster", Caster);
            oImpactedEvent.SetIntVars("Category", int(Power.Discipline));
            oImpactedEvent.CheckActivate(Self, Self);
        }
    }
}
public function OnCastAt(Pawn oAttacker, SFXPowerCustomAction Power)
{
    local BioSeqEvt_OnCastAt Event;
    local int i;
    local BioAiController oAIController;
    
    if (oAttacker != None)
    {
        for (i = 0; i < GeneratedEvents.Length; i++)
        {
            Event = BioSeqEvt_OnCastAt(GeneratedEvents[i]);
            if (Event != None)
            {
                if (Event.CheckActivate(Self, oAttacker))
                {
                    Event.SetNameVars("Power", Power.PowerName);
                    Event.SetObjectVars("Who", Self);
                    Event.SetObjectVars("Caster", BioPawn(oAttacker));
                    Event.SetIntVars("Category", int(Power.Discipline));
                }
            }
        }
        if (Squad != None)
        {
            for (i = 0; i < Squad.GeneratedEvents.Length; i++)
            {
                Event = BioSeqEvt_OnCastAt(Squad.GeneratedEvents[i]);
                if (Event != None)
                {
                    if (Event.CheckActivate(Self, oAttacker))
                    {
                        Event.SetNameVars("Power", Power.PowerName);
                        Event.SetObjectVars("Who", Self);
                        Event.SetObjectVars("Caster", BioPawn(oAttacker));
                        Event.SetIntVars("Category", int(Power.Discipline));
                    }
                }
            }
        }
    }
    oAIController = BioAiController(Controller);
    if (oAIController != None)
    {
        oAIController.NotifyCastAt(oAttacker, Power);
    }
}
public simulated function OnCorpseDestroyed()
{
    local SFXModule_Armour ArmourMod;
    
    ArmourMod = GetModule(Class'SFXModule_Armour');
    if (ArmourMod != None)
    {
        ArmourMod.DestroyAllArmour();
    }
}
public simulated function OnGiveWeapon(SFXSeqAct_GiveWeapon inAction)
{
    local int idx;
    local Class<Inventory> InvClass;
    
    if (inAction.bClearExisting)
    {
        InvManager.RemoveClassFromInventory(Class'SFXWeapon', TRUE);
    }
    if (inAction.WeaponList.Length > 0)
    {
        for (idx = 0; idx < inAction.WeaponList.Length; idx++)
        {
            InvClass = inAction.WeaponList[idx];
            if (ClassIsChildOf(InvClass, Class'SFXWeapon'))
            {
                if (FindInventoryType(InvClass, FALSE) == None)
                {
                    CreateInventory(InvClass);
                }
                continue;
            }
            inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
        }
    }
    else
    {
        inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
    }
    if (Loadout != None)
    {
        ScaleEquipment(GetScaledLevel(), Loadout);
    }
}
public function OnMultiLand(BioSeqAct_MultiLand Action);

public function OnOrbitalGame(BioSeqAct_OrbitalGame Action);

public function OnPowersLoaded();

public function OnSquadMemberAdded(Pawn Pawn)
{
    local SFXPowerCustomActionBase Power;
    
    if (PowerManager != None)
    {
        foreach PowerManager.Powers(Power, )
        {
            Power.OnSquadMemberAdded(Pawn);
        }
    }
}
public function OutputState()
{
}
public simulated function PlayAmbientSound();

public simulated function PlayDeathEffect(Class<SFXDamageType> SFXDamageType, optional Controller Killer)
{
    local RvrClientEffectInterface CE_DeathEffect;
    local SFXGameEffect Effect;
    local SFXModule_GameEffectManager GEM;
    local SFXGameEffect_DeathEffect DeathGE;
    local bool bGameEffectDeath;
    local int HighestPriority;
    local WwiseEvent DeathGESound;
    local RvrClientEffectTarget TargetInfo;
    
    if (!CanPlayDeathEffect())
    {
        return;
    }
    if (SFXDamageType != None)
    {
        if (SFXDamageType.default.CE_DeathEffect != None && SFXDamageType.static.CanPlayDeathEffect(Self, Killer))
        {
            CE_DeathEffect = SFXDamageType.default.CE_DeathEffect;
            HighestPriority = SFXDamageType.default.DeathEffectPriority;
        }
    }
    GEM = GetModule(Class'SFXModule_GameEffectManager');
    foreach GEM.GameEffects(Effect, )
    {
        DeathGE = SFXGameEffect_DeathEffect(Effect);
        if (DeathGE != None)
        {
            if (DeathGE.Priority < HighestPriority || DeathGE.PlayExclusivelyForDamageType != None && DeathGE.PlayExclusivelyForDamageType != SFXDamageType)
            {
                continue;
            }
            HighestPriority = DeathGE.Priority;
            CE_DeathEffect = DeathGE.CE_DeathEffectTemplate;
            bGameEffectDeath = TRUE;
            DeathGESound = DeathGE.DeathSoundEffect;
        }
    }
    if (bGameEffectDeath && DeathGESound != None)
    {
        PlaySound(DeathGESound, TRUE);
    }
    else if (SFXDamageType != None && SFXDamageType.default.DeathSoundEffect != None)
    {
        PlaySound(SFXDamageType.default.DeathSoundEffect, TRUE);
    }
    if (CE_DeathEffect != None)
    {
        TargetInfo.Instigator = Self;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_DeathEffect, TargetInfo);
    }
    if (bGameEffectDeath && DeathGE != None && DeathGE.bCorpseDestroyed || !bGameEffectDeath && SFXDamageType.default.bCorpseDestroyedOnDeath)
    {
        OnCorpseDestroyed();
    }
}
public simulated function PlayDeathReaction()
{
    StartCustomAction(DeathCustomAction);
}
public simulated function PlayDeathVocalization(BioPawn Killer)
{
    if (ChallengeType > EChallengeType.ChallengeType_Elite)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(22, Self, Killer, , , TRUE);
    }
    else
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(21, Self, Killer, , , TRUE);
    }
    if (Killer != None && SFXAI_Henchman(Killer.Controller) != None)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(15, Killer, Self, , , TRUE);
    }
}
public function PlayerCoverAcquired(CovPosInfo CovInfo, byte SlotIdx)
{
    local BioPlayerController PC;
    
    SetCoverType(GetCoverTypeFor(CovInfo));
    CurrentSlotDirection = ECoverDirection.CD_Default;
    SetCoverInfo(CovInfo.Link, int(SlotIdx), CovInfo.LtSlotIdx, CovInfo.RtSlotIdx, CovInfo.LtToRtPct);
    SetCoverAction(GetDefaultCoverAction());
    CurrentLink.Claim(Self, CurrentSlotIdx);
    bNotifyCoverAlignment = TRUE;
    PC = BioPlayerController(Controller);
    if (PC != None && PC.IsLocalPlayerController())
    {
        PC.CoverLog("enter cover", string(GetFuncName()));
        PC.HintSystem.HintEvent('EnterCover');
        PC.GenerateTutorialEvent(1);
    }
}
public function PlayNewEnemySound()
{
    if (NotifyNewEnemySound != None)
    {
        PlaySound(NotifyNewEnemySound);
    }
}
public unreliable client function PlaySoundForOwnerOnly(WwiseBaseSoundObject InSoundCue, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation)
{
    PlaySound(InSoundCue, TRUE, , bStopWhenOwnerDestroyed, SoundLocation);
}
public simulated function PlayStepEffect(int FootDown, TraceHitInfo HitInfo, float Loudness)
{
    local ParticleSystem FootStep;
    local PhysicalMaterial ParentPhysMaterial;
    local SFXDuringAsyncWorkTicker Ticker;
    local Vector BoneLocation;
    
    if (HitInfo.PhysMaterial != None)
    {
        FootStep = GetFootStepEffect(HitInfo.PhysMaterial, FootDown);
        ParentPhysMaterial = HitInfo.PhysMaterial.Parent;
    }
    else if (HitInfo.Material != None)
    {
        FootStep = GetFootStepEffect(HitInfo.Material.PhysMaterial, FootDown);
        if (HitInfo.Material.PhysMaterial != None)
        {
            ParentPhysMaterial = HitInfo.Material.PhysMaterial.Parent;
        }
    }
    while (FootStep == None && ParentPhysMaterial != None)
    {
        FootStep = GetFootStepEffect(ParentPhysMaterial, FootDown);
        ParentPhysMaterial = ParentPhysMaterial.Parent;
    }
    if (FootStep != None)
    {
        if (FootDown == 1)
        {
            BoneLocation = Mesh.GetBoneLocation('RightToe', 0);
        }
        else
        {
            BoneLocation = Mesh.GetBoneLocation('LeftToe', 0);
        }
        if (IsZero(BoneLocation) == FALSE)
        {
            Ticker = SFXGRI(WorldInfo.GRI).DuringAsyncWorker;
            if (Ticker != None)
            {
                Ticker.SpawnImpactEffectAtLocation(Self, FootStep, None, BoneLocation, vect(0.0, 1.0, 0.0), None, 'None');
            }
        }
    }
}
public final simulated function PowerComboImpactInfoUpdated()
{
    local SFXPowerCustomAction oPower;
    local BioPawn oInstigator;
    
    oInstigator = ReplicatedPowerComboImpactInfo.Instigator;
    if (oInstigator == None)
    {
        return;
    }
    if (oInstigator.VerifyCAHasBeenInstanced(132, ReplicatedPowerComboImpactInfo.PowerType))
    {
        oPower = SFXPowerCustomAction(oInstigator.PowerCustomActions[ReplicatedPowerComboImpactInfo.PowerType]);
    }
    if (oPower != None)
    {
        oPower.ClientDoPowerComboImpact(Self, ReplicatedPowerComboImpactInfo.CustomActionReactionType, float(ReplicatedPowerComboImpactInfo.PowerRank), ReplicatedPowerComboImpactInfo.PowerComboTypeUniqueID, int(ReplicatedPowerComboImpactInfo.MiscFlags));
    }
}
public final simulated function PowerComboInfoUpdated()
{
    local SFXPowerCustomAction oPower;
    local BioPawn oInstigator;
    
    oInstigator = ReplicatedPowerComboInfo.DetonatorPowerInstigator;
    if (oInstigator == None)
    {
        return;
    }
    if (oInstigator.VerifyCAHasBeenInstanced(132, int(ReplicatedPowerComboInfo.DetonatorPowerID)))
    {
        oPower = SFXPowerCustomAction(oInstigator.PowerCustomActions[int(ReplicatedPowerComboInfo.DetonatorPowerID)]);
    }
    if (oPower != None)
    {
        oPower.ClientDoPowerCombo(ReplicatedPowerComboInfo.EffectClass, int(ReplicatedPowerComboInfo.SourcePowerID), ReplicatedPowerComboInfo.SourcePowerInstigator, Self, ReplicatedPowerComboInfo.HitLocation, vect(0.0, 0.0, 0.0));
    }
}
public final simulated function PowerSubsequentImpactInfoUpdated(bool bKeepReplicationOrder)
{
    local int i;
    local int PowerCustomActionType;
    local SFXPowerCustomAction oPower;
    local BioPawn oInstigator;
    local int ImpactsProcessCount;
    local int LastValidEntryIndex;
    
    LastValidEntryIndex = -1;
    for (i = 0; i < 4; ++i)
    {
        oInstigator = ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].Instigator;
        if (oInstigator == None)
        {
            if (bKeepReplicationOrder)
            {
                break;
            }
        }
        else
        {
            PowerCustomActionType = ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].PowerType;
            if (oInstigator.VerifyCAHasBeenInstanced(132, PowerCustomActionType))
            {
                oPower = SFXPowerCustomAction(oInstigator.PowerCustomActions[PowerCustomActionType]);
            }
            if (oPower != None)
            {
                oPower.ClientDoPowerSubsequentImpact(Self, ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].CustomActionReactionType, float(ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].Duration) / 10.0, ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].ImpactCount, float(ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].Delay) / 10.0, ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].DoCallback);
            }
            ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex].Instigator = None;
            ++ImpactsProcessCount;
            LastValidEntryIndex = CurrentReplicatedPowerSubsequentImpactIndex;
        }
        ++CurrentReplicatedPowerSubsequentImpactIndex;
        if (CurrentReplicatedPowerSubsequentImpactIndex >= 4)
        {
            CurrentReplicatedPowerSubsequentImpactIndex = 0;
        }
    }
    if (!bKeepReplicationOrder)
    {
        CurrentReplicatedPowerSubsequentImpactIndex = LastValidEntryIndex + 1;
        if (CurrentReplicatedPowerSubsequentImpactIndex >= 4)
        {
            CurrentReplicatedPowerSubsequentImpactIndex = 0;
        }
    }
    else if (ImpactsProcessCount == 0)
    {
        PowerSubsequentImpactInfoUpdated(FALSE);
    }
}
public final function RegisterJoinInProgressDelegate()
{
    if (WorldInfo != None && SFXGame(WorldInfo.Game) != None)
    {
        SFXGame(WorldInfo.Game).RegisterJoinInProgressDelegate(OnJoinInProgress);
    }
}
public final function RegisterRBCallback(delegate<RBCollisionCallback> RBCallback, optional bool bDisablePhysicsDamage = FALSE, optional int nPriority = 5)
{
    local int nInsertIndex;
    local int idx;
    
    for (idx = 0; idx < m_CollisionCallbacks.Length; idx++)
    {
        if (RBCallback == m_CollisionCallbacks[idx].RBCallback)
        {
            return;
        }
    }
    for (nInsertIndex = 0; nInsertIndex < m_CollisionCallbacks.Length; nInsertIndex++)
    {
        if (nPriority > m_CollisionCallbacks[nInsertIndex].nPriority)
        {
            break;
        }
    }
    m_CollisionCallbacks.Insert(nInsertIndex, 1);
    m_CollisionCallbacks[nInsertIndex].nPriority = nPriority;
    m_CollisionCallbacks[nInsertIndex].RBCallback = RBCallback;
    if (bDisablePhysicsDamage)
    {
        m_bPhysicsDamageEnabled = FALSE;
    }
}
public final simulated function RegisterTemporaryAnim(AnimSet TempAnim)
{
    local bool bFoundAnim;
    local int i;
    local TemporaryAnimSetInfo TempAnimSetInfo;
    
    bFoundAnim = FALSE;
    for (i = 0; i < TemporaryAnims.Length && !bFoundAnim; i++)
    {
        if (TemporaryAnims[i].TempAnimSet == TempAnim)
        {
            bFoundAnim = TRUE;
            TemporaryAnims[i].RefCount++;
        }
    }
    if (!bFoundAnim)
    {
        if (Mesh != None)
        {
            if (Mesh.AnimSets.Find(TempAnim) != -1)
            {
                bFoundAnim = TRUE;
            }
        }
    }
    if (!bFoundAnim)
    {
        TempAnimSetInfo.TempAnimSet = TempAnim;
        TempAnimSetInfo.RefCount = 1;
        TemporaryAnims.AddItem(TempAnimSetInfo);
        AddAnimSet(TempAnim);
    }
}
public function ReleaseReplicatedCustomActionImpact()
{
    if (Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    if (CurrentReplicatedCustomActionImpactRefCount == 0)
    {
        return;
    }
    CurrentReplicatedCustomActionImpactRefCount--;
    if (CurrentReplicatedCustomActionImpactRefCount == 0)
    {
        ReplicatedCustomActionImpactPool[CurrentReplicatedCustomActionImpactIndex] = ReplicatedCustomActionImpactInfo;
        bNetDirty = TRUE;
        CAImpactEndReplicationTime[CurrentReplicatedCustomActionImpactIndex] = WorldInfo.TimeSeconds + 3.0;
        CurrentReplicatedCustomActionImpactIndex++;
        if (CurrentReplicatedCustomActionImpactIndex >= 4)
        {
            CurrentReplicatedCustomActionImpactIndex = 0;
        }
    }
}
public function ReleaseReplicatedPowerSubsequentImpact()
{
    if (CurrentReplicatedPowerSubsequentImpactRefCount == 0)
    {
        return;
    }
    CurrentReplicatedPowerSubsequentImpactRefCount--;
    if (CurrentReplicatedPowerSubsequentImpactRefCount == 0)
    {
        ReplicatedPowerSubsequentImpactPool[CurrentReplicatedPowerSubsequentImpactIndex] = ReplicatedPowerSubsequentImpactInfo;
        bNetDirty = TRUE;
        CAPowerSubsequentImpactEndReplicationTime[CurrentReplicatedPowerSubsequentImpactIndex] = WorldInfo.TimeSeconds + 3.0;
        CurrentReplicatedPowerSubsequentImpactIndex++;
        if (CurrentReplicatedPowerSubsequentImpactIndex >= 4)
        {
            CurrentReplicatedPowerSubsequentImpactIndex = 0;
        }
    }
}
public function ReleaseTargetTicket(int nCost)
{
    m_nTargetTickets -= nCost;
    if (m_nTargetTickets < 0)
    {
        m_nTargetTickets = 0;
    }
}
public simulated function ReloadWeapon()
{
    StartCustomAction(9);
}
public final simulated function RemoveLifeTimeCrust()
{
    if (CE_LifetimeCrust != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_LifetimeCrust, GUID_LifetimeCrust, FALSE);
    }
}
public final function bool ReplaceWeapon(ELoadoutWeapons WeaponCategory, Class<SFXWeapon> NewWeapon, bool bEquipWeapon)
{
    local SFXInventoryManager oInventory;
    local int GroupIdx;
    local int EntryIdx;
    local int ModDataIdx;
    local SFXWeapon W;
    local SFXWeapon ReplacementWeapon;
    local int WeaponCount;
    local SFXGameEffect AmmoBonus;
    local SFXModule_WeaponModManager ModManager;
    local SFXEngine MyEngine;
    local Name WeaponModName;
    local int WeaponModLevel;
    local Class<SFXWeaponMod> WeaponModClass;
    
    oInventory = SFXInventoryManager(InvManager);
    if (oInventory == None)
    {
        return FALSE;
    }
    foreach oInventory.InventoryActors(Class'SFXWeapon', W)
    {
        WeaponCount++;
        Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(W.Class, GroupIdx, EntryIdx);
        if (GroupIdx == int(WeaponCategory))
        {
            if (W == Weapon)
            {
                bEquipWeapon = TRUE;
            }
            oInventory.RemoveFromInventory(W);
            ReplacementWeapon = SFXWeapon(CreateInventory(NewWeapon));
            if (ReplacementWeapon == None)
            {
                return FALSE;
            }
            ModManager = ReplacementWeapon.GetModule(Class'SFXModule_WeaponModManager');
            if (ModManager == None)
            {
                return FALSE;
            }
            ModManager.RemoveAllMods();
            MyEngine = SFXEngine(Class'Engine'.static.GetEngine());
            if (MyEngine == None)
            {
                return FALSE;
            }
            for (ModDataIdx = 0; ModDataIdx < MyEngine.PlayerWeaponMods.Length; ModDataIdx++)
            {
                if (MyEngine.PlayerWeaponMods[ModDataIdx].WeaponClassName == Name(PathName(NewWeapon)))
                {
                    foreach MyEngine.PlayerWeaponMods[ModDataIdx].WeaponModClassNames(WeaponModName, )
                    {
                        WeaponModClass = Class'SFXWeaponMod'.static.LoadModClass(string(WeaponModName));
                        if (WeaponModClass != None && WeaponModClass.static.IsUnlocked(WeaponModLevel))
                        {
                            ModManager.AddMod(WeaponModClass, WeaponModLevel);
                        }
                    }
                }
            }
            foreach W.MaxSpareAmmo.Bonuses(AmmoBonus, )
            {
                ReplacementWeapon.MaxSpareAmmo.Bonuses.AddItem(AmmoBonus);
                ReplacementWeapon.ScaleWeapon();
            }
            if (W.GetMaxSpareAmmo() > 0 && ReplacementWeapon.GetMaxSpareAmmo() > 0)
            {
                ReplacementWeapon.CurrentSpareAmmo = int(float(W.GetCurrentSpareAmmo()) * float(ReplacementWeapon.GetMaxSpareAmmo()) / float(W.GetMaxSpareAmmo()));
            }
            else
            {
                ReplacementWeapon.CurrentSpareAmmo = 0;
            }
            ReplacementWeapon.AmmoUsedCount = int(float(W.AmmoUsedCount) * float(ReplacementWeapon.GetMagazineSize()) / float(W.GetMagazineSize()));
            if (bEquipWeapon)
            {
                SetWeaponImmediately(ReplacementWeapon);
            }
            W.Destroy();
            return TRUE;
        }
    }
    if (WeaponCount < Class'SFXPlayerSquadLoadoutData'.default.MaxWeapons)
    {
        ReplacementWeapon = SFXWeapon(CreateInventory(NewWeapon));
        if (bEquipWeapon)
        {
            oInventory.SetCurrentWeapon(ReplacementWeapon);
            SetWeaponImmediately(ReplacementWeapon);
        }
        return TRUE;
    }
    return FALSE;
}
public function ReplicateAnimatedReaction(int CustomActionType, optional Vector HitLocation, optional Vector HitNormal, optional int BoneIndex, optional Class<SFXDamageType> DamageType)
{
    local BioCustomAction Action;
    
    if (CustomActionType != 0 && VerifyCAHasBeenInstanced(CustomActionType))
    {
        Action = CustomActions[CustomActionType];
        if (!Action.bReplicateCustomAction)
        {
            ReplicatedAnimatedReactionInfo.TriggerCounter++;
            ReplicatedAnimatedReactionInfo.CustomActionType = CustomActionType;
            ReplicatedAnimatedReactionInfo.HitLocation = HitLocation;
            ReplicatedAnimatedReactionInfo.HitNormal = HitNormal;
            ReplicatedAnimatedReactionInfo.BoneIndex = BoneIndex;
            ReplicatedAnimatedReactionInfo.DamageType = DamageType;
            ReplicatedAnimatedReactionInfo.RandomRoll = Action.RandomReactionRolled;
            LastAnimatedReaction = WorldInfo.TimeSeconds;
        }
    }
}
public simulated function ReplicatedRadiusDamageInfoUpdated()
{
    Self.TakeDamage(ReplicatedRadiusDamageInfo.Damage, None, ReplicatedRadiusDamageInfo.HitLocation, ReplicatedRadiusDamageInfo.Momentum, ReplicatedRadiusDamageInfo.DamageType, , ReplicatedRadiusDamageInfo.DamageCauser);
    ClientPlayAnimatedReaction(ReplicatedRadiusDamageInfo.CustomActionReactionType);
}
public function ReplicateRadiusDamage(float Damage, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
    local BioCustomAction CurrentCA;
    
    ReplicatedRadiusDamageInfo.TriggerCounter++;
    ReplicatedRadiusDamageInfo.Damage = Damage;
    ReplicatedRadiusDamageInfo.HitLocation = HitLocation;
    ReplicatedRadiusDamageInfo.Momentum = Momentum;
    ReplicatedRadiusDamageInfo.DamageType = DamageType;
    ReplicatedRadiusDamageInfo.DamageCauser = DamageCauser;
    if (GetCurrentCustomAction(CurrentCA) && CurrentCA != None && CurrentCA.IsA('SFXCustomAction_DamageReaction'))
    {
        ReplicatedRadiusDamageInfo.CustomActionReactionType = CurrentCustomAction;
    }
    else
    {
        ReplicatedRadiusDamageInfo.CustomActionReactionType = 0;
    }
}
public final function bool RequestReaction(EReactionTypes ReactionType, Controller instigatedBy, optional Vector Momentum, optional out TraceHitInfo HitInfo)
{
    local array<EAICustomAction> Actions;
    local EAICustomAction NewAction;
    
    if (Role != ENetRole.ROLE_Authority)
    {
        return FALSE;
    }
    if (GetPossibleReactions(ReactionType, Actions, 'None', instigatedBy, Momentum, HitInfo))
    {
        NewAction = Actions[Rand(Actions.Length)];
        if (NewAction != EAICustomAction.CA_None)
        {
            return StartCustomAction(int(NewAction));
        }
    }
    return FALSE;
}
public final simulated function ScaleEquipment(int PlayerLevel, optional SFXLoadoutData oLoadout)
{
    local SFXLoadoutData ChkLoadout;
    local SFXPowerCustomActionBase Power;
    
    if (oLoadout != None)
    {
        ChkLoadout = oLoadout;
    }
    else
    {
        ChkLoadout = Loadout;
    }
    ScaleWeapons(ChkLoadout, 0);
    ScaleShields();
    if (bScalePowers)
    {
        foreach PowerManager.Powers(Power, )
        {
            Power.Rank = Lerp(1.0, 6.0, 0.0);
        }
    }
}
public final simulated function ScaleShields()
{
    local SFXShield_Base ChkShield;
    local float BonusShields;
    local ScaledFloat MaxShields;
    
    BonusShields = 0.0;
    foreach InvManager.InventoryActors(Class'SFXShield_Base', ChkShield)
    {
        MaxShields = ChkShield.GetMaxShieldStruct();
        MaxShields.X += BonusShields;
        MaxShields.Y += BonusShields;
        ChkShield.SetMaxShields(MaxShields);
        ChkShield.ScaleShields();
        ChkShield.SetCurrentShields(ChkShield.GetMaxShields());
    }
}
public final function ScaleWeapons(SFXLoadoutData ChkLoadout, int ScaleLevel)
{
    local SFXWeapon ChkWeapon;
    local int WeaponLevel;
    
    if (SFXPawn_PlayerParty(Self) != None)
    {
        return;
    }
    if (ChkLoadout != None)
    {
        WeaponLevel = int(Lerp(ChkLoadout.WeaponLevelRange.X, ChkLoadout.WeaponLevelRange.Y, 0.0));
        foreach InvManager.InventoryActors(Class'SFXWeapon', ChkWeapon)
        {
            ChkWeapon.WeaponLevel = float(WeaponLevel);
        }
    }
}
public reliable server function ServerInterruptCustomAction(int CustomActionType, int PowerCustomAction)
{
    if (CurrentCustomAction == CustomActionType && CurrentPowerCustomAction == PowerCustomAction && Role == ENetRole.ROLE_Authority)
    {
        if (CurrentCustomAction == 132)
        {
            PowerCustomActions[PowerCustomAction].InterruptThisCustomAction();
        }
        else
        {
            CustomActions[CurrentCustomAction].InterruptThisCustomAction();
        }
    }
}
public reliable server function ServerMashSuccess(BioPawn OtherPawn)
{
    OtherPawn.bMashSuccess = TRUE;
    bForceNetUpdate = TRUE;
    OtherPawn.MashSuccessUpdated();
}
public final function SetAbilityTimeStamp(Name AbilityName)
{
    local int idx;
    local AbilityTimeStamp NewTimestamp;
    
    idx = AbilityTimeStamps.Find('AbilityName', AbilityName);
    if (idx != -1)
    {
        AbilityTimeStamps[idx].TimeStamp = WorldInfo.GameTimeSeconds;
        return;
    }
    NewTimestamp.AbilityName = AbilityName;
    NewTimestamp.TimeStamp = WorldInfo.GameTimeSeconds;
    AbilityTimeStamps.AddItem(NewTimestamp);
}
public final function SetCoverDirection(ECoverDirection NewCoverDirection)
{
    if (int(CoverDirection) != int(NewCoverDirection))
    {
        if (IsHumanControlled() && Controller != None)
        {
            BioPlayerController(Controller).CoverLog("NewCD:" @ NewCoverDirection, string(GetFuncName()));
        }
        CoverDirection = NewCoverDirection;
    }
}
public simulated function SetCoverInfo(CoverLink Link, int SlotIdx, int LeftIdx, int RightIdx, float SlotPct)
{
    CurrentLink = Link;
    CurrentSlotIdx = SlotIdx;
    LeftSlotIdx = LeftIdx;
    RightSlotIdx = RightIdx;
    CurrentSlotPct = SlotPct;
    SetCoverType(FindCoverType());
}
public simulated function SetCoverInfoFromLocation(CoverLink Link, int SlotIdx)
{
    local int NewLeftSlotIdx;
    local float SlotPct;
    local Vector LtToRt;
    local Vector ProjLocToCov;
    
    if (Link == None || SlotIdx < 0)
    {
        return;
    }
    if (SlotIdx == Link.Slots.Length - 1)
    {
        NewLeftSlotIdx = SlotIdx - 1;
    }
    else
    {
        NewLeftSlotIdx = SlotIdx;
    }
    LtToRt = Link.GetSlotLocation(NewLeftSlotIdx + 1) - Link.GetSlotLocation(NewLeftSlotIdx);
    ProjLocToCov = location - Link.GetSlotLocation(NewLeftSlotIdx);
    SlotPct = ProjLocToCov Dot Normal(LtToRt) / VSize2D(LtToRt);
    SlotPct = FClamp(SlotPct, 0.0, 1.0);
    SetCoverInfo(Link, SlotIdx, NewLeftSlotIdx, NewLeftSlotIdx + 1, SlotPct);
}
public simulated function SetCoverType(ECoverType NewCoverType)
{
    if (int(NewCoverType) != int(CoverType))
    {
        if (BioPlayerController(Controller) != None)
        {
            BioPlayerController(Controller).CoverLog("newCoverType:" @ NewCoverType, string(GetFuncName()));
        }
        CoverType = NewCoverType;
    }
}
public final simulated function SetLifeTimeCrust(RvrClientEffectInterface CE_Crust)
{
    local RvrClientEffectTarget CETarget;
    
    RemoveLifeTimeCrust();
    CE_LifetimeCrust = CE_Crust;
    CETarget.HitActor = Self;
    CETarget.Instigator = Self;
    GUID_LifetimeCrust = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_LifetimeCrust, CETarget, Self);
}
public final simulated function SetResistance(EResistanceType Resistance, bool bValue)
{
    local int Mask;
    
    Mask = 1 << int(Resistance);
    if (bValue)
    {
        ResistanceType = ResistanceType | Mask;
    }
    else
    {
        ResistanceType = ResistanceType & ~Mask;
    }
}
public simulated function SetupWeaponAnimations(SFXWeapon NewWeapon, SFXWeapon OldWeapon, optional bool bDrawOnly)
{
    local BioAnimNodeAimOffset AimNode;
    
    if (NewWeapon != None)
    {
        foreach Mesh.AllAnimNodes(Class'BioAnimNodeAimOffset', AimNode)
        {
            AimNode.SetActiveProfileByIndex(int(NewWeapon.AimNodeProfileID));
        }
        if (LeftHandIK != None)
        {
            LeftHandIK.SetSkelControlProfile(int(NewWeapon.IKProfileID));
        }
    }
}
public simulated function ShieldsDown();

public simulated function ShieldsUp();

public function bool SpecialMoveTo_Boost(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core oAI;
    local SFXNav_BoostNode BoostNode;
    local SFXNav_LargeBoostNode LargeBoostNode;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None)
    {
        if (SupportedCustomReachSpecs.Find(Class'SFXBoostReachSpec') != -1)
        {
            SetAnchor(Start);
            BoostNode = SFXNav_BoostNode(Start);
            if (BoostNode != None)
            {
                if (BoostNode.bTopNode)
                {
                    StartCustomAction(48);
                }
                else
                {
                    StartCustomAction(49);
                }
            }
            oAI.MoveTarget = End;
            return TRUE;
        }
        else if (SupportedCustomReachSpecs.Find(Class'SFXLargeBoostReachSpec') != -1)
        {
            SetAnchor(Start);
            LargeBoostNode = SFXNav_LargeBoostNode(Start);
            if (LargeBoostNode != None)
            {
                if (LargeBoostNode.location.Z > End.location.Z)
                {
                    StartCustomAction(48);
                }
                else
                {
                    StartCustomAction(49);
                }
            }
            oAI.MoveTarget = End;
            return TRUE;
        }
    }
    return FALSE;
}
public function bool SpecialMoveTo_ClimbDown(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core AI;
    local bool bSuccessfulMantle;
    
    AI = SFXAI_Core(Controller);
    LastMantleTime = WorldInfo.GameTimeSeconds;
    LastMantleLocation = Start.location;
    bSuccessfulMantle = StartCustomAction(34);
    if (!bSuccessfulMantle && AI != None)
    {
    }
    return bSuccessfulMantle;
}
public function bool SpecialMoveTo_ClimbUp(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core AI;
    local bool bSuccessfulMantle;
    
    AI = SFXAI_Core(Controller);
    LastMantleTime = WorldInfo.GameTimeSeconds;
    LastMantleLocation = Start.location;
    bSuccessfulMantle = StartCustomAction(33);
    if (!bSuccessfulMantle && AI != None)
    {
        AI.MoveTarget = None;
    }
    return bSuccessfulMantle;
}
public function bool SpecialMoveTo_ClimbWall(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core oAI;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None && SupportedCustomReachSpecs.Find(Class'SFXClimbWallReachSpec') != -1)
    {
        SetAnchor(Start);
        oAI.MoveTarget = End;
        if (Start.location.Z < End.location.Z)
        {
            StartCustomAction(50);
        }
        else
        {
            StartCustomAction(51);
        }
        return TRUE;
    }
    return FALSE;
}
public function bool SpecialMoveTo_CoverSlip(NavigationPoint Start, NavigationPoint End)
{
    local CoverSlipReachSpec Spec;
    
    if (bCanCoverSlip == FALSE || IsInCover() == FALSE)
    {
        return FALSE;
    }
    Spec = CoverSlipReachSpec(Start.GetReachSpecTo(End));
    if (Spec != None)
    {
        if (int(Spec.SpecDirection) == 2)
        {
            SetCoverDirection(2);
            if (CoverType == ECoverType.CT_Standing)
            {
                return StartCustomAction(39);
            }
            else
            {
                return StartCustomAction(38);
            }
        }
        else
        {
            SetCoverDirection(1);
            if (CoverType == ECoverType.CT_Standing)
            {
                return StartCustomAction(37);
            }
            else
            {
                return StartCustomAction(36);
            }
        }
    }
    return FALSE;
}
public function bool SpecialMoveTo_GapJump(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core oAI;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None)
    {
        SetAnchor(Start);
        StartCustomAction(28);
        oAI.MoveTarget = End;
        return TRUE;
    }
    return FALSE;
}
public function bool SpecialMoveTo_JumpDown(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core oAI;
    local SFXNav_JumpDownNode JumpDownNode;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None && SupportedCustomReachSpecs.Find(Class'SFXJumpDownReachSpec') != -1)
    {
        SetAnchor(Start);
        JumpDownNode = SFXNav_JumpDownNode(Start);
        if (JumpDownNode != None)
        {
            if (JumpDownNode.bTopNode)
            {
                StartCustomAction(30);
            }
        }
        oAI.MoveTarget = End;
        return TRUE;
    }
    return FALSE;
}
public function bool SpecialMoveTo_LadderClimb(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core oAI;
    local SFXNav_LadderNode oLadderNode;
    
    oAI = SFXAI_Core(Controller);
    if (oAI != None)
    {
        SetAnchor(Start);
        oLadderNode = SFXNav_LadderNode(Start);
        if (oLadderNode.bTopNode)
        {
            StartCustomAction(47);
        }
        else
        {
            StartCustomAction(46);
        }
        oAI.MoveTarget = End;
        return TRUE;
    }
    return FALSE;
}
public function bool SpecialMoveTo_Leap(NavigationPoint Start, NavigationPoint End)
{
    local ReachSpec CurrentPath;
    local SFXAI_Core oAI;
    
    CurrentPath = Start.GetReachSpecTo(End);
    oAI = SFXAI_Core(Controller);
    if (oAI != None && CurrentPath != None)
    {
        if (CurrentPath.IsA('SFXLeapReachSpecHumanoid') && SupportedCustomReachSpecs.Find(Class'SFXLeapReachSpecHumanoid') != -1)
        {
            SetAnchor(Start);
            StartCustomAction(52);
            oAI.MoveTarget = End;
            return TRUE;
        }
        else if (CurrentPath.IsA('SFXLeapReachSpecLarge') && SupportedCustomReachSpecs.Find(Class'SFXLeapReachSpecLarge') != -1)
        {
            SetAnchor(Start);
            StartCustomAction(53);
            oAI.MoveTarget = End;
            return TRUE;
        }
    }
    return FALSE;
}
public function bool SpecialMoveTo_Mantle(NavigationPoint Start, NavigationPoint End)
{
    local SFXAI_Core AI;
    local bool bSuccessfulMantle;
    
    AI = SFXAI_Core(Controller);
    LastMantleTime = WorldInfo.GameTimeSeconds;
    LastMantleLocation = Start.location;
    bSuccessfulMantle = StartCustomAction(31);
    if (!bSuccessfulMantle && AI != None)
    {
        AI.MoveTarget = None;
    }
    return bSuccessfulMantle;
}
public function bool SpecialMoveTo_MoveAlongCover(CoverSlotMarker Start, CoverSlotMarker End)
{
    local SFXAI_Cover oAI;
    local ECoverDirection GoalCoverDir;
    local SFXCustomAction_MoveAlongCover oMoveAlongCover;
    
    oAI = SFXAI_Cover(Controller);
    if (oAI != None && Start != None && End != None && Start.OwningSlot.Link == End.OwningSlot.Link && CanDoCustomAction(35) && CustomActions.Length > 35)
    {
        oMoveAlongCover = SFXCustomAction_MoveAlongCover(CustomActions[35]);
        if (oMoveAlongCover != None)
        {
            if (oMoveAlongCover.bStartedCustomAction && !oMoveAlongCover.DoReStart(End))
            {
                return FALSE;
            }
            if (StartCustomAction(35))
            {
                if (oMoveAlongCover.bStartedCustomAction)
                {
                    if (End.OwningSlot.SlotIdx < Start.OwningSlot.SlotIdx)
                    {
                        GoalCoverDir = ECoverDirection.CD_Left;
                    }
                    else
                    {
                        GoalCoverDir = ECoverDirection.CD_Right;
                    }
                    oMoveAlongCover.Init(GoalCoverDir, End.OwningSlot.Link, End.OwningSlot.SlotIdx);
                    oAI.MoveTarget = End;
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public function bool SpecialMoveTo_SwatTurn(NavigationPoint Start, NavigationPoint End)
{
    local SwatTurnReachSpec Spec;
    
    if (bCanSwatTurn == FALSE || IsInCover() == FALSE)
    {
        LeaveCover();
        return FALSE;
    }
    Spec = SwatTurnReachSpec(Start.GetReachSpecTo(End));
    if (Spec != None)
    {
        if (int(Spec.SpecDirection) == 2)
        {
            SetCoverDirection(2);
            return StartCustomAction(45);
        }
        else
        {
            SetCoverDirection(1);
            return StartCustomAction(44);
        }
    }
    return FALSE;
}
public simulated function SquadUpdated()
{
    local BioWorldInfo oBioWorldInfo;
    local BioPlayerController PC;
    
    if (Squad != None)
    {
        Squad.AddMember(Self);
    }
    PC = BioPlayerController(Controller);
    if (PC != None && Squad != None)
    {
        oBioWorldInfo = BioWorldInfo(WorldInfo);
        if (oBioWorldInfo != None)
        {
            oBioWorldInfo.m_playerSquad = Squad;
        }
        PC.UpdateSquadPlayerPawn(BioPlayerSquad(Squad), Self);
    }
}
public function StartFall()
{
    local Vector Slice;
    local Vector TraceDestination;
    local Vector HitLocation;
    local Vector HitNormal;
    
    if (Physics == EPhysics.PHYS_Falling)
    {
        TraceDestination = location - vect(0.0, 0.0, 220.0);
        Slice = GetCollisionRadius() * vect(1.0, 1.0, 0.0);
        Slice.Z = 2.0;
        if (Trace(HitLocation, HitNormal, TraceDestination, location, FALSE, Slice, , ) == None)
        {
            GotoState('FallingState', , , );
            bIsFalling = TRUE;
            bForceNetUpdate = TRUE;
        }
    }
}
public final function StartFirstUsePowerDelay()
{
    local SFXGRI GRI;
    
    GRI = WorldInfo != None ? SFXGRI(WorldInfo.GRI) : None;
    if (GRI != None && GRI.InCombat())
    {
        if (PowerManager != None)
        {
            PowerManager.StartFirstTimeDelay();
        }
    }
}
public simulated function bool StartPowerCustomAction(int PowerCustomAction, Object Target, Vector TargetLocation, optional bool bForced)
{
    local SFXPowerCustomAction Power;
    
    VerifyCAHasBeenInstanced(132, PowerCustomAction);
    Power = SFXPowerCustomAction(PowerCustomActions[PowerCustomAction]);
    if (Power != None)
    {
        Power.m_oTargetToAimAt = Actor(Target);
        Power.m_vLocationToAimAt = TargetLocation;
        return StartCustomAction(132, None, bForced, PowerCustomAction);
    }
    return FALSE;
}
public simulated function StopReloadWeapon()
{
    if (CurrentCustomAction == 9)
    {
        InterruptCustomAction();
    }
}
public final function bool StopVocalization()
{
    local WwiseAudioComponent CurrentVO;
    
    CurrentVO = GetCurrentVOAudio();
    if (CurrentVO != None)
    {
        if (CurrentVO.IsPlaying())
        {
            CurrentVO.PostGlobalEvent('Stop');
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function TerminateCurrentPowerCustomAction()
{
    if (CurrentCustomAction == 132 && CurrentCustomAction != 0)
    {
        InterruptCustomAction();
    }
}
public final function TossWeapon(Weapon Weap, optional Vector ForceVelocity)
{
    local Vector POVLoc;
    local Vector TossVel;
    local Rotator POVRot;
    local Vector X;
    local Vector Y;
    local Vector Z;
    
    GetActorEyesViewPoint(POVLoc, POVRot);
    if (ForceVelocity != vect(0.0, 0.0, 0.0))
    {
        TossVel = ForceVelocity;
    }
    else
    {
        TossVel = Vector(POVRot);
        TossVel = TossVel * (Velocity Dot TossVel + float(500)) + vect(0.0, 0.0, 200.0);
    }
    GetAxes(Rotation, X, Y, Z);
    Weap.DropFrom(location + 0.800000012 * CylinderComponent.CollisionRadius * X - 0.5 * CylinderComponent.CollisionRadius * Y, TossVel);
}
public final function UnRegisterJoinInProgressDelegate()
{
    if (WorldInfo != None && SFXGame(WorldInfo.Game) != None)
    {
        SFXGame(WorldInfo.Game).UnRegisterJoinInProgressDelegate(OnJoinInProgress);
    }
}
public final simulated function UnregisterTemporaryAnim(AnimSet TempAnim, optional float fTimeLeft = 5.0, optional bool bForceRemove)
{
    local int i;
    local bool bFound;
    local TemporaryAnimSetInfo TempAnimSetInfo;
    
    bFound = FALSE;
    for (i = 0; i < TemporaryAnims.Length; i++)
    {
        if (TemporaryAnims[i].TempAnimSet == TempAnim)
        {
            TemporaryAnims[i].RefCount--;
            if (TemporaryAnims[i].RefCount == 0)
            {
                TemporaryAnims[i].TimeLeft = fTimeLeft;
                bFound = TRUE;
            }
        }
    }
    if (bFound == FALSE && bForceRemove)
    {
        TempAnimSetInfo.TempAnimSet = TempAnim;
        TempAnimSetInfo.RefCount = 0;
        TempAnimSetInfo.TimeLeft = fTimeLeft;
        TemporaryAnims.AddItem(TempAnimSetInfo);
    }
}
public final function UpdateCAPowerComboImpactReplicationTime()
{
    CAPowerComboImpactReplicationTime = WorldInfo.TimeSeconds + 3.0;
}
public final function UpdateCAPowerComboReplicationTime()
{
    CAPowerComboReplicationTime = WorldInfo.TimeSeconds + 3.0;
}
private final function ValidateReactionsForGibs(out array<EAICustomAction> OutActions)
{
    local int idx;
    local Class<BioCustomAction> CAClass;
    
    if (CanGib())
    {
        return;
    }
    for (idx = OutActions.Length - 1; idx >= 0; idx--)
    {
        CAClass = CustomActionClasses[int(OutActions[idx])];
        if (CAClass != None && CAClass.default.bCreatesGibs)
        {
            OutActions.Remove(idx, 1);
        }
    }
}
public final simulated function bool VerifyCAHasBeenInstanced(int CAIndex, optional int PowerCustomAction)
{
    if (CAIndex > 0)
    {
        if (CAIndex == 132)
        {
            if (PowerCustomAction == 0)
            {
                return FALSE;
            }
            if (PowerCustomAction >= PowerCustomActions.Length || PowerCustomActions[PowerCustomAction] == None)
            {
                if (PowerCustomAction < PowerCustomActionClasses.Length && PowerCustomActionClasses[PowerCustomAction] != None)
                {
                    PowerCustomActions[PowerCustomAction] = new (Outer) PowerCustomActionClasses[PowerCustomAction];
                    PowerCustomActions[PowerCustomAction].m_oPawn = Self;
                    if (SFXAI_Core(Controller) != None)
                    {
                        PowerCustomActions[PowerCustomAction].m_oAI = SFXAI_Core(Controller);
                    }
                    else if (SFXPlayerController(Controller) != None)
                    {
                        PowerCustomActions[PowerCustomAction].m_oPC = SFXPlayerController(Controller);
                    }
                }
                else
                {
                    PowerCustomActions[PowerCustomAction] = None;
                    return FALSE;
                }
            }
        }
        else if (CAIndex >= CustomActions.Length || CustomActions[CAIndex] == None)
        {
            if (CAIndex < CustomActionClasses.Length && CustomActionClasses[CAIndex] != None)
            {
                CustomActions[CAIndex] = new (Outer) CustomActionClasses[CAIndex];
                CustomActions[CAIndex].m_oPawn = Self;
                if (SFXAI_Core(Controller) != None)
                {
                    CustomActions[CAIndex].m_oAI = SFXAI_Core(Controller);
                }
                else if (SFXPlayerController(Controller) != None)
                {
                    CustomActions[CAIndex].m_oPC = SFXPlayerController(Controller);
                }
            }
            else
            {
                CustomActions[CAIndex] = None;
                return FALSE;
            }
        }
        return TRUE;
    }
    return FALSE;
}
public simulated function bool VerifyLandingClear(out MantleInfo OutMantleInfo)
{
    local Vector StartTrace;
    local Vector EndTrace;
    local Vector HitLocation;
    local Vector HitNormal;
    local Actor HitActor;
    local Vector Extent;
    local Vector StartDownTrace;
    local int bHitSomethingHoriz;
    local Vector EstimatedLanding;
    local Vector StartLoc;
    local Vector EndLoc;
    
    Extent = GetCollisionExtent() * vect(1.00999999, 1.00999999, 1.0);
    Extent.Z = CrouchHeight * 0.25;
    StartLoc = GetBasedPosition(OutMantleInfo.MantleStartLoc);
    EndLoc = GetBasedPosition(OutMantleInfo.MantleEndLoc);
    StartTrace = StartLoc + vect(0.0, 0.0, 80.0);
    EndTrace = EndLoc + vect(0.0, 0.0, 80.0);
    if (FastTrace(EndTrace, StartTrace, Extent, FALSE) == FALSE && !OutMantleInfo.bForced)
    {
        return FALSE;
    }
    EndTrace = StartTrace + (EndLoc - StartLoc) + Normal(EndLoc - StartLoc) * GetEstimatedHorizFallDist(OutMantleInfo);
    StartDownTrace = EndTrace;
    foreach TraceActors(Class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, Extent, , 8)
    {
        if (HandleHitActorInMantle(HitActor, HitLocation, StartDownTrace, bHitSomethingHoriz) == FALSE && !OutMantleInfo.bForced)
        {
            return FALSE;
        }
    }
    EndTrace = StartDownTrace - vect(0.0, 0.0, 135.0);
    foreach TraceActors(Class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartDownTrace, Extent, , 8)
    {
        if ((Pawn(HitActor) != None || Abs(HitLocation.Z - StartTrace.Z) < Extent.Z * 2.0) && HandleHitActorInMantle(HitActor, HitLocation) == FALSE && !OutMantleInfo.bForced)
        {
            return FALSE;
        }
    }
    EstimatedLanding = EndTrace;
    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartDownTrace, FALSE, Extent, , );
    if (HitActor != None)
    {
        if (Abs(HitLocation.Z - StartTrace.Z) < Extent.Z * 2.0 && !OutMantleInfo.bForced)
        {
            return FALSE;
        }
        EstimatedLanding = HitLocation;
    }
    EstimatedLanding += vect(0.0, 0.0, 1.0) * default.CylinderComponent.CollisionHeight;
    SetBasedPosition(OutMantleInfo.EstimatedLandingLoc, EstimatedLanding);
    return TRUE;
}
public final simulated function WeaponImpactInfoUpdated()
{
    if (ReplicatedWeaponImpactInfo.oWeapon != None)
    {
        ReplicatedWeaponImpactInfo.oWeapon.ClientDoImpact(Self);
    }
}

simulated state Broken 
{
    
Begin:
    while (TRUE)
    {
        Sleep(1.0);
        appScreenDebugMessage("Physics change broke pawn.");
    }
    stop;
};
simulated state Downed 
{
    ignores HitWall, Falling, PhysicsVolumeChange, Bump, HeadVolumeChange
    ;
    public event simulated function OnEnterRagdoll()
    {
        bPlayerInRagdoll = bIsAPlayer;
    }
    public function CheckRagdollStatus()
    {
        local SkeletalMeshComponent MeshComponent;
        
        if (Mesh.FramesPhysicsAsleep > 5 && IsAtRest())
        {
            foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
            {
                MeshComponent.SetFrozen(TRUE);
            }
            ClearTimer('CheckRagdollStatus');
        }
    }
    public event simulated function ForceEndRagdoll()
    {
        local bool bGotoAutoState;
        
        bGotoAutoState = TRUE;
        if (BioPlayerSquad(Squad) == None)
        {
            if (GetCurrentHealth() <= float(0))
            {
                Global.Died(KilledBy, KilledByDamageType, KilledByHitLocation);
                bGotoAutoState = FALSE;
            }
        }
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            if (!TermRagdoll())
            {
            }
        }
        if (bGotoAutoState)
        {
            GotoState('Auto', , , );
        }
    }
    public simulated function bool IsPlayingReaction()
    {
        local BioCustomAction Action;
        local SFXCustomAction_DamageReaction DamageReaction;
        
        if (GetCurrentCustomAction(Action))
        {
            DamageReaction = SFXCustomAction_DamageReaction(Action);
            if (DamageReaction != None && DamageReaction.bDeathReaction || SFXCustomAction_SyncPawnPartner_Base(Action) != None)
            {
                return TRUE;
            }
        }
        return FALSE;
    }
    public event simulated function EndState(Name NextStateName)
    {
        local SkeletalMeshComponent MeshComponent;
        
        if (SFXPawn_Henchman(Self) != None)
        {
            ClearTimer('CheckRagdollStatus');
            foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
            {
                MeshComponent.SetFrozen(FALSE);
            }
        }
        Super(Object).EndState(NextStateName);
        bIsDowned = FALSE;
        Mesh.SetRBChannel(default.Mesh.RBChannel);
        Mesh.SetRBCollidesWithChannel(2, TRUE);
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        local SFXAI_Core AI;
        local SFXAI_Core FriendlyAI;
        
        Super(Object).BeginState(PreviousStateName);
        bIsDowned = TRUE;
        Mesh.SetRBChannel(16);
        Mesh.SetRBCollidesWithChannel(2, FALSE);
        AI = SFXAI_Core(Controller);
        if (AI != None && AI.bNotifyFriendsOnDeath)
        {
            foreach WorldInfo.AllControllers(Class'SFXAI_Core', FriendlyAI)
            {
                if (FriendlyAI != AI && FriendlyAI.bReceiveDeathNotifications && FriendlyAI.Pawn != None && FriendlyAI.Pawn.IsDead() == FALSE && FriendlyAI.IsFriendly(AI))
                {
                    FriendlyAI.NotifyFriendDied(Self);
                }
            }
            AI.bNotifyFriendsOnDeath = FALSE;
        }
    }
    public function PlayDyingSound();
    
    public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation);
    
    public function BreathTimer();
    
    public function StartFall();
    
    
Begin:
    if (HasDeathReaction())
    {
        if (!bCanRagdoll)
        {
            InterruptCustomAction();
        }
        PlayDeathReaction();
        Sleep(0.100000001);
    }
    while (IsPlayingReaction())
    {
        Sleep(0.100000001);
    }
    while (bPreventPermanentDeath)
    {
        Sleep(1.0);
    }
    InterruptCustomAction();
    if (Physics != EPhysics.PHYS_RigidBody && bCanRagdoll)
    {
        if (!InitRagdoll())
        {
        }
    }
    if (SFXAI_Henchman(Controller) != None)
    {
        SFXAI_Henchman(Controller).NotifyDeathBlow(KilledByDamageType);
    }
    if (SFXPawn_PlayerParty(Self) == None)
    {
        SetCollision(TRUE, FALSE, );
    }
    if (bCanRagdoll && SFXPawn_Henchman(Self) != None)
    {
        SetTimer(0.5, TRUE, 'CheckRagdollStatus', );
    }
    while (WorldInfo.Game == None || SFXGame(WorldInfo.Game).PreventPermanentDeath(Self))
    {
        Sleep(1.0);
    }
    Global.Died(KilledBy, KilledByDamageType, KilledByHitLocation);
    stop;
};
state Dying 
{
    public event simulated function OnEnterRagdoll()
    {
        bPlayerInRagdoll = bIsAPlayer;
    }
    public simulated function Tick(float DeltaTime)
    {
        if (bScalingToZero)
        {
            SetDrawScale(DrawScale - DeltaTime);
            if (DrawScale < 0.400000006)
            {
                Mesh.SetRBChannel(16);
                Mesh.SetRBCollidesWithChannel(2, FALSE);
                Mesh.SetRBCollidesWithChannel(0, FALSE);
                Mesh.SetRBCollidesWithChannel(5, FALSE);
                if (DrawScale < 0.0199999996)
                {
                    bScalingToZero = FALSE;
                    if (!bDeleteMe)
                    {
                        Destroy();
                    }
                }
            }
        }
    }
    public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        Global.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    public function CheckRagdollStatus()
    {
        if (Mesh.FramesPhysicsAsleep > 5 && IsAtRest())
        {
            SetPhysics(7);
            Velocity = vect(0.0, 0.0, 0.0);
            ClearTimer('CheckRagdollStatus');
        }
    }
    public simulated function EndState(Name NextState)
    {
        Super(Object).EndState(NextState);
        ClearTimer('CheckRagdollStatus');
    }
    public event function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        if (bCanRagdoll)
        {
            SetTimer(0.5, TRUE, 'CheckRagdollStatus', );
        }
    }
    public event function Timer()
    {
        if (!bCanBeReaped)
        {
            SetTimer(2.0, FALSE, , );
            return;
        }
        if (bHidden || Mesh != None && Mesh.HiddenGame || PlayerCanSeeMe() == FALSE)
        {
            Destroy();
        }
        else
        {
            SetTimer(2.0, FALSE, , );
        }
    }
    
    stop;
};
simulated state RagdollRecovery 
{
    public event simulated function ForceEndRagdoll()
    {
        GotoState('Auto', , , );
    }
    public function UpdateRagdollState(float DeltaTime);
    
    public event simulated function NotifyRagdollRecoverAnimationComplete()
    {
        GotoState('Auto', , , );
    }
    public simulated function EndState(Name NextState)
    {
        bIsInRagdollRecovery = FALSE;
        LockDesiredRotation(FALSE);
        bNoWeaponFiring = FALSE;
        KilledByDamageType = None;
        Super(Object).EndState(NextState);
        if (Physics == EPhysics.PHYS_RigidBody && NextState != 'Dying' && NextState != 'Downed')
        {
            if (!TermRagdoll())
            {
            }
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        MoveToRagdollRecoverStartPosition();
        bIsInRagdollRecovery = TRUE;
        bNoWeaponFiring = TRUE;
    }
    
Begin:
    if (IsPlayerPawn() || ValidateRagdoll())
    {
        Sleep(0.100000001);
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            if (!TermRagdoll())
            {
            }
        }
        Sleep(3.0);
        GotoState('Auto', , , );
    }
    else
    {
        KillOrStasis(FALSE, LastHitBy, None, "Recover From Ragdoll");
    }
    stop;
};
simulated state InRagdoll 
{
    public simulated function bool ReadyToRecover()
    {
        return m_nRemainInRagdoll <= 0;
    }
    public event simulated function ForceEndRagdoll()
    {
        GotoState('Auto', , , );
    }
    public simulated function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, Pawn DamageCauser)
    {
        Super.PlayHit(Damage, instigatedBy, HitLocation, DamageType, Momentum, HitInfo, DamageCauser);
        Mesh.AddImpulse(Momentum, HitLocation, HitInfo.BoneName);
    }
    public simulated function bool ShouldDieOnRagdoll()
    {
        local SFXKillRagdollVolume CurrentVolume;
        
        if (bKillOnRagdoll)
        {
            return TRUE;
        }
        foreach TouchingActors(Class'SFXKillRagdollVolume', CurrentVolume, )
        {
            return TRUE;
        }
        return FALSE;
    }
    public event simulated function EndState(Name NextStateName)
    {
        Super(Object).EndState(NextStateName);
        if (NextStateName != 'Dying' && NextStateName != 'Downed' && NextStateName != 'RagdollRecovery')
        {
            if (Physics == EPhysics.PHYS_RigidBody)
            {
                if (!TermRagdoll())
                {
                }
            }
            Mesh.PhysicsWeight = 0.0;
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        Super(Object).BeginState(PreviousStateName);
        LastPhysicsSetter = None;
        if (ShouldDieOnRagdoll())
        {
            Died(None, Class'SFXDamageType_Suicide', location);
        }
    }
    
Begin:
    Sleep(1.0);
    while (!ReadyToRecover())
    {
        Sleep(0.100000001);
    }
    GotoState('RagdollRecovery', , , );
    stop;
};
simulated state LandingState 
{
    public event simulated function NotifyFallingAnimationComplete()
    {
        GotoState(InitialState, , , );
        StopMovement(TRUE);
    }
    public event simulated function EndState(Name NextStateName)
    {
        Super(Object).EndState(NextStateName);
        if (BioPlayerController(Controller) != None)
        {
            BioPlayerController(Controller).PawnLanded();
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        Super(Object).BeginState(PreviousStateName);
    }
    public event simulated function bool StartCustomAction(int NewAction, optional Pawn Sync, optional bool bForced, optional int PowerCustomAction)
    {
        local bool bReturnVal;
        
        bReturnVal = Global.StartCustomAction(NewAction, Sync, bForced, PowerCustomAction);
        if (bReturnVal)
        {
            NotifyFallingAnimationComplete();
        }
        return bReturnVal;
    }
    
Begin:
    Sleep(2.0);
    GotoState(InitialState, , , );
    stop;
};
simulated state FallingState 
{
    public simulated function Landed(Vector HitNormal, Actor FloorActor)
    {
        Global.Landed(HitNormal, FloorActor);
        GotoState('LandingState', , , );
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        Super(Object).BeginState(PreviousStateName);
        if (BioPlayerController(Controller) != None)
        {
            BioPlayerController(Controller).PawnFalling();
        }
    }
    
Begin:
    while (Role == ENetRole.ROLE_SimulatedProxy || Physics == EPhysics.PHYS_Falling)
    {
        Sleep(0.100000001);
    }
    GotoState('LandingState', , , );
    stop;
};

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ReplicatedRadiusDamageInfo, ReplicatedCustomActionImpactPool, ReplicatedPowerSubsequentImpactPool, ReplicatedWeaponImpactInfo, Squad, bInPortArms, bIsAPlayer, bIsDowned, bIsDead, bMashSuccess;
    if (!bNetInitial && bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < CAPowerComboImpactReplicationTime)
        ReplicatedPowerComboImpactInfo;
    if (!bNetInitial && bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < CAPowerComboReplicationTime)
        ReplicatedPowerComboInfo;
    if (bNetDirty && Role == ENetRole.ROLE_Authority && (WorldInfo.TimeSeconds < CAEndReplicationTime || ReplicatedCustomActionInfo.Cmd != EReplicatedCustomActionCmd.eRCACmd_Start) && (!bNetOwner || bNetOwner && bReplicateCustomActionInfoToOwner))
        ReplicatedCustomActionInfo;
    if (bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < LastAnimatedReaction + 1.0)
        ReplicatedAnimatedReactionInfo;
    if (bNetDirty && !bSkipPawnPropertyReplication && !bNetOwner && !bTearOff && Role == ENetRole.ROLE_Authority)
        CurrentLink, CurrentSlotIdx, LeftSlotIdx, RightSlotIdx, CurrentSlotPct, ReplicatedEnsurePawnHasLandedFromRagdoll, bStorming, bReplicatedWantsToStorm, bIsFalling, bIsInRagdollRecovery, CoverDirection, CoverType, CoverAction;
    if (bNetDirty && !bUseDeltaReplication && !bNetOwner && !bTearOff && Role == ENetRole.ROLE_Authority)
        ReplicatedAimDeltaRot, ReplicatedRotation;
    if (Role == ENetRole.ROLE_Authority && (!bUseDeltaReplication || bPlayerInRagdoll) && !bTearOff && Physics == EPhysics.PHYS_RigidBody)
        ReplicatedRootBodyPos;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 88.0
        CollisionRadius = 30.0
        ReplacementPrimitive = None
        BlockZeroExtent = FALSE
        BlockRigidBody = TRUE
    End Template
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
        TargetBoneName = 'Chest2'
        UseTargetBoneAsOrigin = TRUE
        MinTimeBetweenFullUpdates = 0.5
    End Object
    Begin Object Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        bIgnoreControllersWhenNotRendered = TRUE
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
        RBChannel = ERBCollisionChannel.RBCC_Pawn
        CollideActors = TRUE
        BlockZeroExtent = TRUE
        BlockRigidBody = TRUE
        bNotifyRigidBodyCollision = TRUE
        LocalTranslucencySortPriority = -1
        RBCollideWithChannels = {Default = TRUE, Pawn = TRUE, Vehicle = TRUE, EffectPhysics = TRUE, BlockingVolume = TRUE}
        ScriptRigidBodyCollisionThreshold = 10.0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        bOverrideParentSkeleton = TRUE
        nmOverrideStartBoneName = 'headBase'
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
        TickGroup = ETickingGroup.TG_PostDirtyComponentsWork
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        MinAutoLODLevel = 1
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        MinAutoLODLevel = 1
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
        LocalTranslucencySortPriority = -1
    End Object
    Begin Object Class=SFXPowerManager Name=PowerMgr
    End Object
    Begin Object Class=SFXModule_GameEffectManager Name=GEMod0
    End Object
    Begin Object Class=SFXModule_Radar Name=RadarModule
        RadarType = EBioRadarType.BRT_Pawn_Friendly
    End Object
    Begin Object Class=SFXModule_AimAssistTarget Name=AimAssistMod
        AimAssistRegions = ({Width = 30.0, Height = 30.0, SoftMargin = 40.0, NodeType = EAimNodes.AimNode_Head}, 
                            {Width = 80.0, Height = 50.0, SoftMargin = 80.0, NodeType = EAimNodes.AimNode_Groin}, 
                            {Width = 80.0, Height = 80.0, SoftMargin = 80.0, NodeType = EAimNodes.AimNode_Cover}
                           )
    End Object
    Begin Object Class=SFXModule_Damage Name=DmgMod0
        MaxHealth = {X = 100.0, Y = 100.0}
    End Object
    Begin Object Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Object
    Begin Object Class=SFXModule_Conversation Name=ConvoMod01
    End Object
    Begin Object Class=SFXModule_LookAt Name=LookAtMod01
    End Object
    Begin Object Class=SFXModule_Audio Name=AudioModule
    End Object
    DesiredSpeedMultiplier = {
                              Bonuses = (), 
                              X = 1.0, 
                              Y = 1.0, 
                              MaxLevel = 100, 
                              Level = 0, 
                              Value = 0.0, 
                              StaticBonus = 1.0
                             }
    AttachSlots = ('Socket_05', 'Socket_06', 'Socket_03', 'Socket_04', 'Socket_07')
    CustomActionClasses = (None, 
                           Class'SFXCustomAction_Ragdoll', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_Frozen', 
                           None, 
                           Class'SFXCustomAction_MountedGunReload', 
                           None, 
                           None, 
                           Class'SFXCustomAction_EnterMountedGun', 
                           Class'SFXCustomAction_ExitMountedGun'
                          )
    AIBarkAnimName = "Bark1"
    AimNodes = ('FAKE_Cover', 
                'Head', 
                'LeftShoulder', 
                'RightShoulder', 
                'Chest2', 
                'Root', 
                'LeftKnee', 
                'RightKnee'
               )
    RightHandSocketName = 'Socket_01'
    LeftHandSocketName = 'Socket_02'
    m_nmPhysicsImpactBone = 'Root'
    m_nmRagdollRecoverBone = 'Root'
    m_nmRagdollRecoverDirSwapBone = 'Chest1'
    WalkSpeed = 130.0
    CombatWalkSpeed = 150.0
    CombatGroundSpeed = 300.0
    CoverGroundSpeed = 237.0
    CoverCrouchGroundSpeed = 237.0
    TightAimGroundSpeed = 130.0
    CrouchGroundSpeed = 300.0
    StormSpeed = 525.0
    StormTurnSpeed = 100.0
    LargeReactionInterval = 5.0
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    m_fRunAnimPlaybackRate = 1.0
    m_fRunAnimPlaybackLen = 1.0
    m_fWalkAnimPlaybackRate = 1.0
    m_fWalkAnimPlaybackLen = 1.0
    m_fCollisionReadyHeight = 50.0
    PortArmsExitDelay = 0.449999988
    PortArmsPlayerInterval = 0.100000001
    PortArmsNPCInterval = 0.5
    PortArmsWedgeHeight = 5.0
    PortArmsWedgeRadius = 5.0
    PortArmsDelay = -1.0
    m_fRBSleepEnergyThreshold = 5.0
    m_fEnableCCDMultiplierThreshold = 10.0
    LightEnvironment = BioLightEnvComponent0
    AIBarkAnimSet = FaceFXAnimSet'BIOG_AI_Bark.SFX_HumanMale_FaceFX_AnimSet'
    MaxBodyCount = 3
    FallingStateEntranceTime = 0.100000001
    m_nMaxTargetTickets = 5
    m_nMaxAttackTickets = 3
    m_fTicketExpiryTime = 5.0
    ConformTraceInterval = 10
    MeshAdjustFrequency = 0.150000006
    AimOffsetInterpSpeed = 4.0
    RemoteAimOffsetInterpSpeed = 4.0
    PortArmsAndAimInterpSpeed = 2.5
    AimOriginOffset = 4.0
    RadarRange = 4000.0
    RadarFOV = 45.0
    m_fPhysicsRecoverSpeedThreshold = 4.0
    fSleepPerceptionDistance = 800.0
    PowerThreshold_Stagger = 150.0
    PowerThreshold_Knockback = 300.0
    ReplicatedRotationInterpolationRate = 10.0
    CoverTransitionStdLeanOutRight = 300.0
    CoverTransitionStdLeanInRight = 220.0
    CoverTransitionStdLeanOutLeft = 280.0
    CoverTransitionStdLeanInLeft = 220.0
    CoverTransitionMidLeanOutRight = 225.0
    CoverTransitionMidLeanInRight = 160.0
    CoverTransitionMidLeanOutLeft = 440.0
    CoverTransitionMidLeanInLeft = 310.0
    BloodColor = {B = 0, G = 0, R = 10, A = 255}
    AchievementForceThreshold = 99.0
    CameraHookScale = 1.0
    PowerManager = PowerMgr
    bCanPlayReactions = TRUE
    bSpawnPHATInstance = TRUE
    bCanRagdoll = TRUE
    bAffectedByRagdollPowers = TRUE
    bCanBeReaped = TRUE
    bCanPlayMoveStopAnims = TRUE
    m_bHideWithCameraCollision = TRUE
    bPortArmsEnabled = TRUE
    bCanPortArms = TRUE
    bDoUpdateCoverData = TRUE
    bActive = TRUE
    m_bPhysicsDamageEnabled = TRUE
    bShouldSpawnWeapons = TRUE
    bScalePowers = TRUE
    m_bRecoverDirSwap = TRUE
    bInterpolateReplicatedRotation = TRUE
    RaceType = ERaceType.RaceType_Humanoid
    CharacterType = ECharacterType.CharacterType_Human
    ChallengeType = EChallengeType.ChallengeType_Minion
    m_eRagdollRecoverBoneAxis = EAxis.AXIS_Z
    m_eRagdollRecoverDirSwapBoneAxis = EAxis.AXIS_Z
    InventoryManagerClass = Class'SFXInventoryManager'
    MaxStepHeight = 40.0
    CrouchHeight = 55.0
    CrouchRadius = 30.0
    DesiredSpeed = 0.0
    HearingThreshold = 1500.0
    SightRadius = 3000.0
    PeripheralVision = 0.173999995
    GroundSpeed = 400.0
    AirSpeed = 1000.0
    AccelRate = 380.0
    AirControl = 0.349999994
    BaseEyeHeight = 80.0
    EyeHeight = 75.0
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    ViewPitchMin = -14563.0
    ViewPitchMax = 14563.0
    bUseDeltaReplication = TRUE
    bCanCrouch = TRUE
    bJumpCapable = FALSE
    bCanJump = FALSE
    bCanStrafe = TRUE
    bAvoidLedges = TRUE
    bStopAtLedges = TRUE
    bMuffledHearing = TRUE
    bModifyReachSpecCost = TRUE
    m_bEnableRagdollRecovery = TRUE
    PathSearchType = EPathSearchType.PST_Constraint
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               DmgMod0, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule
              )
    RotationRate = {Pitch = 16384, Yaw = 65535, Roll = 16384}
    CollisionComponent = CollisionCylinder
    m_fPhysicsThreshold = 1000.0
    bAlwaysRelevant = TRUE
    bDontReplicateBaseRotation = TRUE
    bEdShouldSnap = TRUE
    Physics = EPhysics.PHYS_Walking
}