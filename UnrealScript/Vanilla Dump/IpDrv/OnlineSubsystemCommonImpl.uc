Class OnlineSubsystemCommonImpl extends OnlineSubsystem
    native
    config(Engine);

var const transient native Pointer VoiceEngine;
var config int MaxLocalTalkers;
var config int MaxRemoteTalkers;
var OnlineGameInterfaceImpl GameInterfaceImpl;
var config bool bIsUsingSpeechRecognition;

public event function string GetPlayerNicknameFromIndex(int UserIndex);

public event function UniqueNetId GetPlayerUniqueNetIdFromIndex(int UserIndex);

public native function bool IsPlayerInSession(Name SessionName, UniqueNetId PlayerID);

public function GetRegisteredPlayers(Name SessionName, out array<UniqueNetId> OutRegisteredPlayers)
{
    local int idx;
    local int PlayerIdx;
    
    OutRegisteredPlayers.Length = 0;
    for (idx = 0; idx < Sessions.Length; idx++)
    {
        if (Sessions[idx].SessionName == SessionName)
        {
            OutRegisteredPlayers.Length = Sessions[idx].Registrants.Length;
            for (PlayerIdx = 0; PlayerIdx < Sessions[idx].Registrants.Length; PlayerIdx++)
            {
                OutRegisteredPlayers[PlayerIdx] = Sessions[idx].Registrants[PlayerIdx].PlayerNetId;
            }
            break;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxLocalTalkers = 1
    MaxRemoteTalkers = 16
}