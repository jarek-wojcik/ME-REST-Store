Class BroadcastHandler extends Info
    config(Game);

var int SentText;
var config bool bMuteSpectators;

public function Broadcast(Actor Sender, coerce string Msg, optional Name Type)
{
    local PlayerController P;
    local PlayerReplicationInfo PRI;
    
    if (!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }
    if (Pawn(Sender) != None)
    {
        PRI = Pawn(Sender).PlayerReplicationInfo;
    }
    else if (Controller(Sender) != None)
    {
        PRI = Controller(Sender).PlayerReplicationInfo;
    }
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        BroadcastText(PRI, P, Msg, Type);
    }
}
public function BroadcastLocalized(Actor Sender, PlayerController Receiver, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    Receiver.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public event function AllowBroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}
public event function AllowBroadcastLocalizedTeam(int TeamIndex, Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.Team != None && P.PlayerReplicationInfo.Team.TeamIndex == TeamIndex)
        {
            BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }
}
public function bool AllowsBroadcast(Actor broadcaster, int InLen)
{
    if (bMuteSpectators && PlayerController(broadcaster) != None && PlayerController(broadcaster).PlayerReplicationInfo.bOnlySpectator)
    {
        return FALSE;
    }
    SentText += InLen;
    return WorldInfo.Pauser != None || SentText < 260;
}
public function BroadcastTeam(Controller Sender, coerce string Msg, optional Name Type)
{
    local PlayerController P;
    
    if (!AllowsBroadcast(Sender, Len(Msg)))
    {
        return;
    }
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        if (P.PlayerReplicationInfo.Team == Sender.PlayerReplicationInfo.Team)
        {
            BroadcastText(Sender.PlayerReplicationInfo, P, Msg, Type);
        }
    }
}
public function BroadcastText(PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional Name Type)
{
    Receiver.TeamMessage(SenderPRI, Msg, Type);
}
public function UpdateSentText()
{
    SentText = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}