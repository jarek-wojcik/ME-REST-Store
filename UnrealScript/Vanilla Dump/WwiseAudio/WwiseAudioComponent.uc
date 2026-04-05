Class WwiseAudioComponent extends ActorComponent
    native
    editinlinenew
    transient
    config(Engine)
    collapsecategories;

struct native WwiseRTPCForActorHandler 
{
    var init string m_sRTPCName;
    var Actor m_actor;
    var float m_currentValue;
};

var transient Double m_fLastObstructionUpdate;
var const editconst transient duplicatetransient array<WwiseComponentCallbackInfo> Callbacks;
var transient native duplicatetransient Pointer m_pNotifyCriticalSection;
var transient native duplicatetransient Object WwiseEvents;
var native duplicatetransient Vector location;
var native duplicatetransient Vector Orientation;
var const native duplicatetransient Vector ComponentLocation;
var const native duplicatetransient Vector ComponentOrientation;
var transient Vector CachedLastPosition;
var transient Vector CachedLastOrientation;
var(WwiseAudioComponent) Name m_ComponentGroup;
var editinline transient export SkeletalMeshComponent m_OwnerSkelMeshComponent;
var(WwiseAudioComponent) int m_nAttachBoneIndex;
var const editconst transient duplicatetransient int Cleaned;
var native duplicatetransient float m_fDistanceToListener;
var native duplicatetransient float m_fMaxAudible3DSoundDistance;
var native duplicatetransient int m_nMaxAudible3DSoundEventPlayingID;
var native duplicatetransient int m_nNumberOf3DSoundsPlaying;
var native duplicatetransient int m_nNumberOfSoundsUseAttenuation;
var native duplicatetransient int m_nNumberOfSoundsWithUserDefinedPositioning;
var transient int m_nNumberOfEventsUsingOrientationRTPC;
var transient int m_nNumberOfEventsUsingDistanceRTPC;
var native duplicatetransient float m_fDotToListener;
var transient float m_fTargetOcclusion;
var transient float m_fTargetObstruction;
var transient float m_fCurrentOcclusion;
var transient float m_fCurrentObstruction;
var config float ObstructionUpdateSpeed;
var bool bUseOwnerLocation;
var(WwiseAudioComponent) bool m_bEnableEnvAudio;
var(WwiseAudioComponent) bool m_bEnableObstructionOcclusion;
var transient bool m_bIsRegistered;
var bool m_bUpdateAudioEnginePosition;

public static final native function WwiseAudioComponent CreateComponentFromScript(Actor pActor, optional string Label, optional Name ComponentGroup, optional Name AttachBone, optional bool bRegister = TRUE);

public final native function int FindPlayingID(WwiseBaseSoundObject BaseSound, optional WwiseEvent StopEvent);

public final native function float GetDistanceToListener();

public final native function bool GetEnvironmentalAudioEnabled();

public static native function Vector GetMicPosition();

public final native function bool GetObstructionOcclusionEnabled();

public final native function bool IsEventPlaying(int WwisePlayingID);

public final native function bool IsPlaying(optional WwiseBaseSoundObject Event);

public native function bool KillSound(WwiseEvent Event);

public final native function bool Play(WwiseBaseSoundObject Base, optional bool bTrackPosition);

public final native function bool PlayWwiseEvent(WwiseEventPair AudioEvent, optional bool bTrackPosition);

public final native function bool PostGlobalEvent(Name GlobalEventName);

public native function bool RegisterGameObject(optional string GameObjectName);

public native function Set2D();

public native function Set3D();

public static native function SetDrawMic(bool bDraw);

public final native function SetEnvironmentalAudioEnabled(bool i_bValue);

public static native function bool SetGlobalRTPCFromScript(string in_pszRtpcName, float in_value);

public final simulated function SetLocation(Vector NewLocation)
{
    location = NewLocation;
}
public final native function SetObstructionOcclusionEnabled(bool i_bValue);

public static final native function SetRTPCWithHandler(out WwiseRTPCForActorHandler RTPCHandler, float fValue);

public final native function bool SetWwiseRTPC(string sName, float fValue);

public final native function bool SetWwiseRTPCs(array<string> sName, array<float> fValue);

public final native function bool SetWwiseSwitch(string sGroup, string sState);

public final native function bool SetWwiseTrigger(string sTrigger);

public final native function float SoundPosition(WwiseBaseSoundObject Base);

public final native function float SoundPositionByID(int WwisePlayingID);

public static native function bool StaticPostGlobalEventFromScript(Name GlobalEventName);

public final native function bool Stop(WwiseBaseSoundObject Base);

public final native function bool StopAll();

public final native function bool StopWwiseEvent(WwiseEventPair AudioEvent);

public native function bool UnregisterGameObject();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ObstructionUpdateSpeed = 1.0
    m_bEnableEnvAudio = TRUE
    m_bEnableObstructionOcclusion = TRUE
    m_bUpdateAudioEnginePosition = TRUE
}