Class BioConversationController
    native
    transient
    config(Game);

struct native BioConvActorInitMeshTrans 
{
    var Vector vOrigTranslation;
    var Actor pActor;
};
struct native BioConvActorPropData 
{
    var native Map_Mirror mapMeshPropData;
    var native Map_Mirror mapWeaponPropData;
};
struct native BioNextLightingData 
{
    var(BioNextLightingData) BioConvLightingData tData;
    var(BioNextLightingData) Actor pActor;
    var(BioNextLightingData) bool bUseThis;
};
struct native BioConvLightingData 
{
    var(BioConvLightingData) Name TargetBoneName;
    var(KeyLight) float KeyLight_Scale_Red;
    var(KeyLight) float KeyLight_Scale_Green;
    var(KeyLight) float KeyLight_Scale_Blue;
    var(FillLight) float FillLight_Scale_Red;
    var(FillLight) float FillLight_Scale_Green;
    var(FillLight) float FillLight_Scale_Blue;
    var(RimLight) Color RimLightColor;
    var(RimLight) float RimLightScale;
    var(RimLight) float RimLightYaw;
    var(RimLight) float RimLightPitch;
    var(BioConvLightingData) float BouncedLightingIntensity;
    var(BioConvLightingData) SFXLightRig LightRig;
    var(BioConvLightingData) float LightRigOrientation;
    var(BioConvLightingData) bool bLockEnvironment;
    var(BioConvLightingData) bool bTriggerFullUpdate;
    var(BioConvLightingData) bool bUseForNextCamera;
    var(BioConvLightingData) bool bCastShadows;
    var(RimLight) ERimLightControlType RimLightControl;
    var(BioConvLightingData) EConvLightingType LightingType;
    
    structdefaultproperties
    {
        BouncedLightingIntensity = 0.300000012
        bCastShadows = TRUE
    }
};
enum EConvLightingType
{
    ConvLighting_Cinematic,
    ConvLighting_Exploration,
    ConvLighting_Dynamic,
};
struct native BioInterruptReplyInfo 
{
    var int nReplyListIndex;
    var float fWindowStartTimeRemaining;
    var float fWindowTimeRemaining;
    var bool bEnabled;
    var bool bActivated;
    var EInterruptionType eInterruptType;
};
struct native BioSavedActorPos 
{
    var Vector vPos;
    var Rotator rRot;
    var Actor pActor;
};
struct native BioNextCamData 
{
    var(BioNextCamData) Vector vPos;
    var(BioNextCamData) Rotator rRot;
    var(BioNextCamData) BioStageDOFData tDOFData;
    var(BioNextCamData) Name sCameraName;
    var(BioNextCamData) float fFov;
    var(BioNextCamData) float fNearPlane;
    var(BioNextCamData) bool bUseThis;
};
struct native BioDialogLookat 
{
    var Actor pActor;
    var float fLookAtDelay;
    var Actor pLookAtTarget;
};
struct native BioSpeakerData 
{
    var Name nmSpeakerTag;
    var Actor pSpeakerActor;
};
enum EBioConversationType
{
    BIOCONV_NULL,
    BIOCONV_FOVO,
    BIOCONV_Ambient,
    BIOCONV_Full,
};

var native Map_Mirror m_mapActorProps;
var array<BioSpeakerData> m_aSpeakerData;
var array<BioSpeakerData> m_aAllFoundActors;
var array<BioDialogLookat> m_aLookAtList;
var array<int> m_aCurrentReplyIndices;
var array<BioSavedActorPos> m_aPrevPositions;
var string m_sCurrentSubTitle;
var string m_sCurrentStageDirection;
var string m_sCurrentFaceFXAnim;
var array<WwiseBaseSoundObject> m_aPreLoadingSounds;
var array<Actor> m_aExtraParticipants;
var const array<AnimSequence> PreloadAnimations;
var const array<stringref> PreloadStrRefs;
var array<BioConvActorInitMeshTrans> m_aActorOrigMeshTrans;
var string m_sWaitingOnReplySubtitle;
var native Object m_CachedLightingState;
var BioNextLightingData m_tNextLightingOverride;
var BioNextCamData m_tNextCamOverride;
var BioInterruptReplyInfo m_tInterruptInfo;
var Vector m_vLineOfAction;
var BioConversation m_pConvData;
var BioConversationManager m_pManager;
var int m_nCurrentEntry;
var float m_fStartTime;
var Actor m_pOwner;
var Actor m_pPlayer;
var Actor m_pSpeaker;
var Actor m_pPreviousSpeaker;
var Actor m_pListener;
var int m_nSelectedReply;
var SFXSeqAct_StartAmbientConv m_pKismetStart;
var int m_nCurrentReply;
var int m_nIntimacy;
var BioStage m_pStage;
var config float m_fShowRepliesOffset;
var config float m_fShowLastLineOffset;
var float m_fNodePlayTimer;
var float m_fInterruptRange;
var config float m_fSubtitleTimingModifier;
var config float m_fSubtitleTimingMinimum;
var config float m_fVOPreloadDelayTime;
var int m_nNodeStateFlags;
var WwiseBaseSoundObject m_pCurrentSound;
var FaceFXAnimSet m_pCurrentFaceFXSet;
var SeqAct_Interp m_pCurrentLineMatinee;
var float m_fRemainingVOElemsLength;
var float m_fRemainingVOAudioLength;
var float m_fRemainingLastLineSubtitleDelay;
var int m_nDelayedReplyChoice;
var Sequence m_pEvtSysSeq;
var config Color m_colSubtitleColor;
var float m_fAudioHitchBuffer;
var float m_fPreLoadTimer;
var float m_fPreLoadStartDelay;
var config float m_fDefaultInterruptWindowDuration;
var config float m_fDefaultInterruptWindowStart;
var int m_nTeleLinesHit;
var int m_nTeleLinesSkipped;
var int m_nTeleKinectRepliesSelected;
var int m_nTeleReplyLinesSelected;
var bool m_bAutoActivate;
var bool m_bConversationEnded;
var bool m_bHasAttachedCameraTrack;
var bool m_bHasAttachedDOFTrack;
var bool m_bSkipRequested;
var config bool m_bDisplayNonAmbientName;
var bool m_bSkipProtectionDisabled;
var bool m_bCurrentlyAmbient;
var bool m_bForceAmbientStart;
var bool m_bPutPlayerIntoCombat;
var bool m_bDisableTargeting;
var bool m_bSkippable;
var bool m_bFailed;
var bool m_bInterrupted;
var bool m_bKismetInitiated;
var bool m_bConversationOver;
var bool m_bHideCurrentSubtitle;
var bool m_bNoGestures;
var bool m_bForceShowReplies;
var bool m_bNeedsUnprepare;
var bool m_bNeedsFullCleanup;
var bool m_bHavePrimedTextures;
var config bool m_bRemoveWeapons;
var bool m_bPlayingNonTextLine;
var bool m_bHidePlayerHelmet;
var bool m_bShowPlayerHelmet;
var bool m_bHideHenchmenHelmet;
var bool m_bShowHenchmenHelmet;
var config bool m_bShowCinematicComments;
var config bool m_bAutoAdvanceSkippableLinesWithNoVO;
var bool m_bReplySubtitleOverridden;
var EBioConversationType m_eControllerType;

public event function DisableCamera(bool bDisableCamera)
{
    local Pawn Pawn;
    
    Pawn = Pawn(m_pPlayer);
    if (Pawn != None && PlayerController(Pawn.Controller) != None)
    {
        SFXPlayerCamera(PlayerController(Pawn.Controller).PlayerCamera).bDisabled = bDisableCamera;
    }
}
public event function ForceCineModeOff()
{
    local BioSeqAct_BioToggleCinematicMode pTempKismet;
    
    pTempKismet = new Class'BioSeqAct_BioToggleCinematicMode';
    if (pTempKismet != None)
    {
        pTempKismet.InputLinks[0].bHasImpulse = FALSE;
        pTempKismet.InputLinks[1].bHasImpulse = TRUE;
        pTempKismet.InputLinks[2].bHasImpulse = FALSE;
        pTempKismet.ToggleCineMode();
    }
}
public native function int GetReplyCategory(int nIndex);

public native function EConvGUIStyles GetReplyGUIStyle(int nIndex);

public native function stringref GetReplyParaphraseStrref(int nIndex);

public native function string GetReplyParaphraseText(int nIndex);

public native function bool IsCurrentlyAmbient();

public native function bool NeedToDisplayInterrupt();

public native function bool NeedToDisplayReplies();

public native function bool QueueReply(int nReply);

public event function RestoreHelmet(Actor TargetActor)
{
    local SFXPawn_PlayerParty Pawn;
    
    Pawn = SFXPawn_PlayerParty(TargetActor);
    if (Pawn != None)
    {
        Pawn.ForceSquadHelmet(1, 0);
    }
}
public native function bool SelectInterruption();

public event function ShowHelmet(Actor TargetActor, bool bShowHelmet)
{
    local SFXPawn_PlayerParty Pawn;
    
    Pawn = SFXPawn_PlayerParty(TargetActor);
    if (Pawn != None)
    {
        Pawn.ForceSquadHelmet(1, bShowHelmet ? 1 : 3);
    }
}
public native function bool SkipNode();

public static native function TrackConvCineModeChanges(bool bConvEnabled, bool bConvDisabled, bool bCineEnabled, bool bCineDisabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_tNextLightingOverride = {
                               tData = {
                                        TargetBoneName = 'None', 
                                        KeyLight_Scale_Red = 0.0, 
                                        KeyLight_Scale_Green = 0.0, 
                                        KeyLight_Scale_Blue = 0.0, 
                                        FillLight_Scale_Red = 0.0, 
                                        FillLight_Scale_Green = 0.0, 
                                        FillLight_Scale_Blue = 0.0, 
                                        RimLightColor = {B = 0, G = 0, R = 0, A = 0}, 
                                        RimLightScale = 0.0, 
                                        RimLightYaw = 0.0, 
                                        RimLightPitch = 0.0, 
                                        BouncedLightingIntensity = 0.300000012, 
                                        LightRig = None, 
                                        LightRigOrientation = 0.0, 
                                        bLockEnvironment = FALSE, 
                                        bTriggerFullUpdate = FALSE, 
                                        bUseForNextCamera = FALSE, 
                                        bCastShadows = TRUE, 
                                        RimLightControl = ERimLightControlType.RLCT_Key, 
                                        LightingType = EConvLightingType.ConvLighting_Cinematic
                                       }, 
                               pActor = None, 
                               bUseThis = FALSE
                              }
    m_tNextCamOverride = {
                          vPos = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          rRot = {Pitch = 0, Yaw = 0, Roll = 0}, 
                          tDOFData = {fFocusInnerRadius = 600.0, fFocusDistance = 600.0, bEnable = FALSE}, 
                          sCameraName = 'None', 
                          fFov = 0.0, 
                          fNearPlane = 0.0, 
                          bUseThis = FALSE
                         }
    m_fShowRepliesOffset = 2.0
    m_fShowLastLineOffset = 5.0
    m_fSubtitleTimingModifier = 0.5
    m_fSubtitleTimingMinimum = 2.0
    m_fVOPreloadDelayTime = 0.5
    m_colSubtitleColor = {B = 255, G = 255, R = 204, A = 255}
    m_fDefaultInterruptWindowDuration = 2.0
    m_fDefaultInterruptWindowStart = 1.0
    m_bRemoveWeapons = TRUE
    m_eControllerType = EBioConversationType.BIOCONV_Ambient
}