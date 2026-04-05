Class OnlinePartyChatInterface extends Interface
    abstract;

var delegate<OnSendPartyGameInvitesComplete> __OnSendPartyGameInvitesComplete__Delegate;

public function bool GetPartyMemberInformation(out array<OnlinePartyMember> PartyMembers);

public delegate function OnSendPartyGameInvitesComplete(bool bWasSuccessful);

public function bool SendPartyGameInvites(byte LocalUserNum);

public function bool SetPartyMemberCustomData(byte LocalUserNum, QWord Data1, QWord Data2);

public function bool ShowCommunitySessionsUI(byte LocalUserNum);

public function bool ShowPartyUI(byte LocalUserNum);

public function bool ShowVoiceChannelUI(byte LocalUserNum);

public function AddSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate);

public function ClearSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate);

public function int GetPartyBandwidth();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}