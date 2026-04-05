Class SFXOnlineComponentVoiceInterface extends SFXOnlineComponent
    implements(OnlineVoiceInterface, ISFXOnlineComponent)
    native;

struct native SFXOnlineRemoteTalker extends RemoteTalker 
{
    var TalkerPriority LocalPriorities[4];
};
struct native TalkerPriority 
{
    var int CurrentPriority;
    var int LastPriority;
};
const MAX_LOCAL_PLAYERS = 4;

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var array<SFXOnlineRemoteTalker> RemoteTalkers;
var array<delegate<OnPlayerTalkingStateChange>> TalkingDelegates;
var delegate<OnPlayerTalkingStateChange> __OnPlayerTalkingStateChange__Delegate;
var delegate<OnRecognitionComplete> __OnRecognitionComplete__Delegate;
var native Pointer VoiceEngine;
var LocalTalker LocalTalkers[4];

public native function AddRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate);

public native function ApplyOptions();

public native function ClearRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate);

public native function bool EnumerateInputDevices(out array<string> InputDevices);

public native function bool EnumerateOutputDevices(out array<string> OutputDevices);

public native function Name GetAPIName();

public native function int GetDefaultInputDevice();

public native function int GetDefaultOutputDevice();

public native function bool GetRecognitionResults(byte LocalUserNum, out array<SpeechRecognizedWord> Words);

public native function int GetRemotePlayerStatus(UniqueNetId PlayerID);

public native function bool IsHeadsetPresent(byte LocalUserNum);

public native function bool IsLocalPlayerTalking(byte LocalUserNum);

public native function bool IsRemotePlayerTalking(UniqueNetId PlayerID);

public native function bool IsRemoteTalkerMuted(byte LocalUserNum, UniqueNetId PlayerID);

public native function bool MuteAll(byte LocalUserNum, bool bAllowFriends);

public native function bool MuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnPlayerTalkingStateChange(UniqueNetId Player, bool bIsTalking);

public delegate function OnRecognitionComplete();

public native function OnRelease();

public native function OnTick(SFXOnlineEvent oEvent);

public native function PushToTalkEnd();

public native function PushToTalkStart();

public native function bool RegisterLocalTalker(byte LocalUserNum);

public native function bool RegisterRemoteTalker(UniqueNetId PlayerID);

public native function ResetVoiceSystem();

public native function bool SelectVocabulary(byte LocalUserNum, int VocabularyId);

public native function bool SetInputDevice(int inputDeviceId);

public native function bool SetOutputDevice(int outputDeviceId);

public native function bool SetRemoteTalkerPriority(byte LocalUserNum, UniqueNetId PlayerID, int Priority);

public native function bool SetSpeechRecognitionObject(byte LocalUserNum, SpeechRecognition SpeechRecogObj);

public native function SetVoiceMode(int voiceMode);

public native function bool SetVolume(float Volume);

public native function StartNetworkedVoice(byte LocalUserNum);

public native function bool StartSpeechRecognition(byte LocalUserNum);

public native function StopNetworkedVoice(byte LocalUserNum);

public native function bool StopSpeechRecognition(byte LocalUserNum);

public native function bool UnmuteAll(byte LocalUserNum);

public native function bool UnmuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID);

public native function bool UnregisterLocalTalker(byte LocalUserNum);

public native function bool UnregisterRemoteTalker(UniqueNetId PlayerID);

public function AddPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
    local int AddIndex;
    
    if (TalkingDelegates.Find(TalkerDelegate) == -1)
    {
        AddIndex = TalkingDelegates.Length;
        TalkingDelegates.Length = TalkingDelegates.Length + 1;
        TalkingDelegates[AddIndex] = TalkerDelegate;
    }
}
public function ClearPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = TalkingDelegates.Find(TalkerDelegate);
    if (RemoveIndex != -1)
    {
        TalkingDelegates.Remove(RemoveIndex, 1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}