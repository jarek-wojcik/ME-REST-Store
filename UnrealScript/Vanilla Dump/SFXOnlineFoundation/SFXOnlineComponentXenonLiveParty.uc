Class SFXOnlineComponentXenonLiveParty extends SFXOnlineComponent
    implements(OnlinePartyChatInterface, ISFXOnlineComponent)
    native;

struct native PartyGameInviteDelegates 
{
    var array<delegate<OnSendPartyGameInvitesComplete>> Delegates;
    
    structdefaultproperties
    {
        Delegates = ()
    }
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var transient QWord TotalBandwidthUsed;
var PartyGameInviteDelegates PartyChatGameInviteDelegates[4];
var const native array<Pointer> AsyncTasks;
var delegate<OnSendPartyGameInvitesComplete> __OnSendPartyGameInvitesComplete__Delegate;
var transient int BandwidthUsed;
var transient float ElapsedTime;

public native function Name GetAPIName();

public native function bool GetPartyMemberInformation(out array<OnlinePartyMember> PartyMembers);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public delegate function OnSendPartyGameInvitesComplete(bool bWasSuccessful);

public native function OnTick(SFXOnlineEvent oEvent);

public native function bool SendPartyGameInvites(byte LocalUserNum);

public native function bool SetPartyMemberCustomData(byte LocalUserNum, QWord Data1, QWord Data2);

public native function bool ShowCommunitySessionsUI(byte LocalUserNum);

public native function bool ShowPartyUI(byte LocalUserNum);

public native function bool ShowVoiceChannelUI(byte LocalUserNum);

public native function TickBandwidthTracking(float DeltaTime);

public function AddSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (PartyChatGameInviteDelegates[int(LocalUserNum)].Delegates.Find(SendPartyGameInvitesCompleteDelegate) == -1)
        {
            PartyChatGameInviteDelegates[int(LocalUserNum)].Delegates.AddItem(SendPartyGameInvitesCompleteDelegate);
        }
    }
}
public function ClearSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = PartyChatGameInviteDelegates[int(LocalUserNum)].Delegates.Find(SendPartyGameInvitesCompleteDelegate);
        if (RemoveIndex != -1)
        {
            PartyChatGameInviteDelegates[int(LocalUserNum)].Delegates.Remove(RemoveIndex, 1);
        }
    }
}
public function int GetPartyBandwidth()
{
    return BandwidthUsed;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}