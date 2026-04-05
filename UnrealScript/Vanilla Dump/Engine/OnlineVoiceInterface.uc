Class OnlineVoiceInterface extends Interface
    abstract;

var delegate<OnRecognitionComplete> __OnRecognitionComplete__Delegate;
var delegate<OnPlayerTalkingStateChange> __OnPlayerTalkingStateChange__Delegate;

public function AddRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate);

public function ClearRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate);

public function bool GetRecognitionResults(byte LocalUserNum, out array<SpeechRecognizedWord> Words);

public function bool IsHeadsetPresent(byte LocalUserNum);

public function bool IsLocalPlayerTalking(byte LocalUserNum);

public function bool IsRemotePlayerTalking(UniqueNetId PlayerID);

public function bool MuteAll(byte LocalUserNum, bool bAllowFriends);

public function bool MuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID);

public delegate function OnPlayerTalkingStateChange(UniqueNetId Player, bool bIsTalking);

public delegate function OnRecognitionComplete();

public function bool RegisterLocalTalker(byte LocalUserNum);

public function bool RegisterRemoteTalker(UniqueNetId PlayerID);

public function bool SelectVocabulary(byte LocalUserNum, int VocabularyId);

public function bool SetRemoteTalkerPriority(byte LocalUserNum, UniqueNetId PlayerID, int Priority);

public function bool SetSpeechRecognitionObject(byte LocalUserNum, SpeechRecognition SpeechRecogObj);

public function StartNetworkedVoice(byte LocalUserNum);

public function bool StartSpeechRecognition(byte LocalUserNum);

public function StopNetworkedVoice(byte LocalUserNum);

public function bool StopSpeechRecognition(byte LocalUserNum);

public function bool UnmuteAll(byte LocalUserNum);

public function bool UnmuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID);

public function bool UnregisterLocalTalker(byte LocalUserNum);

public function bool UnregisterRemoteTalker(UniqueNetId PlayerID);

public function AddPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate);

public function ClearPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}