Class Info extends Actor
    native
    abstract;

struct native export transient ServerResponseLine 
{
    var(ServerResponseLine) init string IP;
    var(ServerResponseLine) init string ServerName;
    var(ServerResponseLine) init string MapName;
    var(ServerResponseLine) init string GameType;
    var(ServerResponseLine) init array<KeyValuePair> ServerInfo;
    var(ServerResponseLine) init array<PlayerResponseLine> PlayerInfo;
    var(ServerResponseLine) init int ServerID;
    var(ServerResponseLine) init int Port;
    var(ServerResponseLine) init int QueryPort;
    var(ServerResponseLine) init int CurrentPlayers;
    var(ServerResponseLine) init int MaxPlayers;
    var(ServerResponseLine) init int Ping;
};
struct native export transient PlayerResponseLine 
{
    var(PlayerResponseLine) init string PlayerName;
    var(PlayerResponseLine) init array<KeyValuePair> PlayerInfo;
    var(PlayerResponseLine) init int PlayerNum;
    var(PlayerResponseLine) init int PlayerID;
    var(PlayerResponseLine) init int Ping;
    var(PlayerResponseLine) init int Score;
    var(PlayerResponseLine) init int StatsID;
};
struct native export transient KeyValuePair 
{
    var(KeyValuePair) init string Key;
    var(KeyValuePair) init string Value;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None)
    NetUpdateFrequency = 10.0
    bHidden = TRUE
    bSkipActorPropertyReplication = TRUE
    bOnlyDirtyReplication = TRUE
}