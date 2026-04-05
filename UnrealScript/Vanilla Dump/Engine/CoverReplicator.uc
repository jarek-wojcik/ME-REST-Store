Class CoverReplicator extends ReplicationInfo;

struct CoverReplicationInfo 
{
    var array<byte> SlotsEnabled;
    var array<byte> SlotsDisabled;
    var array<byte> SlotsAdjusted;
    var array<ManualCoverTypeInfo> SlotsCoverTypeChanged;
    var CoverLink Link;
    
    structdefaultproperties
    {
        SlotsEnabled = ""
        SlotsDisabled = ""
        SlotsAdjusted = ""
    }
};
struct ManualCoverTypeInfo 
{
    var byte SlotIndex;
    var ECoverType ManualCoverType;
};

var array<CoverReplicationInfo> CoverReplicationData;

public reliable client function ClientReceiveAdjustedSlots(int Index, CoverLink Link, byte NumSlotsAdjusted, byte SlotsAdjusted[8], bool bDone)
{
    local int i;
    
    if (Link == None)
    {
        if (bDone)
        {
            ServerSendAdjustedSlots(Index);
        }
    }
    else
    {
        for (i = 0; i < int(NumSlotsAdjusted); i++)
        {
            if (Link.AutoAdjustSlot(int(SlotsAdjusted[i]), TRUE) && Link.Slots[int(SlotsAdjusted[i])].SlotOwner != None && Link.Slots[int(SlotsAdjusted[i])].SlotOwner.Controller != None)
            {
                Link.Slots[int(SlotsAdjusted[i])].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
    }
}
public reliable client function ClientReceiveDisabledSlots(int Index, CoverLink Link, byte NumSlotsDisabled, byte SlotsDisabled[8], bool bDone)
{
    local int i;
    
    if (Link == None)
    {
        if (bDone)
        {
            ServerSendDisabledSlots(Index);
        }
    }
    else
    {
        for (i = 0; i < int(NumSlotsDisabled); i++)
        {
            Link.SetSlotEnabled(int(SlotsDisabled[i]), FALSE);
        }
    }
}
public reliable client function ClientReceiveEnabledSlots(int Index, CoverLink Link, byte NumSlotsEnabled, byte SlotsEnabled[8], bool bDone)
{
    local int i;
    
    if (Link == None)
    {
        if (bDone)
        {
            ServerSendEnabledSlots(Index);
        }
    }
    else
    {
        for (i = 0; i < int(NumSlotsEnabled); i++)
        {
            Link.SetSlotEnabled(int(SlotsEnabled[i]), TRUE);
        }
    }
}
public reliable client function ClientReceiveInitialCoverReplicationInfo(int Index, CoverLink Link, bool bLinkDisabled, byte NumSlotsEnabled, byte SlotsEnabled[8], byte NumSlotsDisabled, byte SlotsDisabled[8], byte NumSlotsAdjusted, byte SlotsAdjusted[8], byte NumCoverTypesChanged, ManualCoverTypeInfo SlotsCoverTypeChanged[8], bool bDone)
{
    local int i;
    
    if (Link == None)
    {
        if (bDone)
        {
            ServerSendInitialCoverReplicationInfo(Index);
        }
    }
    else
    {
        Link.bDisabled = bLinkDisabled;
        for (i = 0; i < int(NumSlotsEnabled); i++)
        {
            Link.SetSlotEnabled(int(SlotsEnabled[i]), TRUE);
        }
        for (i = 0; i < int(NumSlotsDisabled); i++)
        {
            Link.SetSlotEnabled(int(SlotsDisabled[i]), FALSE);
        }
        for (i = 0; i < int(NumSlotsAdjusted); i++)
        {
            if (Link.AutoAdjustSlot(int(SlotsAdjusted[i]), FALSE) && Link.Slots[int(SlotsAdjusted[i])].SlotOwner != None && Link.Slots[int(SlotsAdjusted[i])].SlotOwner.Controller != None)
            {
                Link.Slots[int(SlotsAdjusted[i])].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
        for (i = 0; i < int(NumCoverTypesChanged); i++)
        {
            Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].CoverType = SlotsCoverTypeChanged[i].ManualCoverType;
            if (Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner != None && Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner.Controller != None)
            {
                Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
        if (bDone)
        {
            ServerSendInitialCoverReplicationInfo(Index + 1);
        }
    }
}
public reliable client function ClientReceiveLinkDisabledState(int Index, CoverLink Link, bool bLinkDisabled)
{
    if (Link == None)
    {
        ServerSendLinkDisabledState(Index);
    }
    else
    {
        Link.bDisabled = bLinkDisabled;
    }
}
public reliable client function ClientReceiveManualCoverTypeSlots(int Index, CoverLink Link, byte NumCoverTypesChanged, ManualCoverTypeInfo SlotsCoverTypeChanged[8], bool bDone)
{
    local int i;
    
    if (Link == None)
    {
        if (bDone)
        {
            ServerSendManualCoverTypeSlots(Index);
        }
    }
    else
    {
        for (i = 0; i < int(NumCoverTypesChanged); i++)
        {
            Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].CoverType = SlotsCoverTypeChanged[i].ManualCoverType;
            if (Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner != None && Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner.Controller != None)
            {
                Link.Slots[int(SlotsCoverTypeChanged[i].SlotIndex)].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
    }
}
public reliable client function ClientSetOwner(PlayerController PC)
{
    SetOwner(PC);
}
public function NotifyAutoAdjustSlots(CoverLink Link, const out array<int> SlotIndices)
{
    local int Index;
    local int SlotIndex;
    local int i;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (i = 0; i < SlotIndices.Length; i++)
        {
            CoverReplicationData[Index].SlotsAdjusted[i] = byte(SlotIndices[i]);
        }
    }
    else
    {
        for (i = 0; i < SlotIndices.Length; i++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsAdjusted.Find(byte(SlotIndices[i]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsAdjusted[CoverReplicationData[Index].SlotsAdjusted.Length] = byte(SlotIndices[i]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Find('SlotIndex', byte(SlotIndices[i]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsCoverTypeChanged.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == Self)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == None)
            {
                PC.SpawnCoverReplicator();
            }
            else
            {
                PC.MyCoverReplicator.NotifyAutoAdjustSlots(Link, SlotIndices);
            }
        }
    }
    if (PlayerController(Owner) != None)
    {
        ServerSendAdjustedSlots(Index);
    }
}
public function NotifyDisabledSlots(CoverLink Link, const out array<int> SlotIndices)
{
    local int Index;
    local int SlotIndex;
    local int i;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (i = 0; i < SlotIndices.Length; i++)
        {
            CoverReplicationData[Index].SlotsDisabled[i] = byte(SlotIndices[i]);
        }
    }
    else
    {
        for (i = 0; i < SlotIndices.Length; i++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsDisabled.Find(byte(SlotIndices[i]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsDisabled[CoverReplicationData[Index].SlotsDisabled.Length] = byte(SlotIndices[i]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsEnabled.Find(byte(SlotIndices[i]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsEnabled.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == Self)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == None)
            {
                PC.SpawnCoverReplicator();
            }
            else
            {
                PC.MyCoverReplicator.NotifyDisabledSlots(Link, SlotIndices);
            }
        }
    }
    if (PlayerController(Owner) != None)
    {
        ServerSendDisabledSlots(Index);
    }
}
public function NotifyEnabledSlots(CoverLink Link, const out array<int> SlotIndices)
{
    local int Index;
    local int SlotIndex;
    local int i;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (i = 0; i < SlotIndices.Length; i++)
        {
            CoverReplicationData[Index].SlotsEnabled[i] = byte(SlotIndices[i]);
        }
    }
    else
    {
        for (i = 0; i < SlotIndices.Length; i++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsEnabled.Find(byte(SlotIndices[i]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsEnabled[CoverReplicationData[Index].SlotsEnabled.Length] = byte(SlotIndices[i]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsDisabled.Find(byte(SlotIndices[i]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsDisabled.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == Self)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == None)
            {
                PC.SpawnCoverReplicator();
            }
            else
            {
                PC.MyCoverReplicator.NotifyEnabledSlots(Link, SlotIndices);
            }
        }
    }
    if (PlayerController(Owner) != None)
    {
        ServerSendEnabledSlots(Index);
    }
}
public function NotifyLinkDisabledStateChange(CoverLink Link)
{
    local int Index;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
    }
    if (WorldInfo.Game.GetCoverReplicator() == Self)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == None)
            {
                PC.SpawnCoverReplicator();
            }
            else
            {
                PC.MyCoverReplicator.NotifyLinkDisabledStateChange(Link);
            }
        }
    }
    if (PlayerController(Owner) != None)
    {
        ServerSendLinkDisabledState(Index);
    }
}
public function NotifySetManualCoverTypeForSlots(CoverLink Link, const out array<int> SlotIndices, ECoverType NewCoverType)
{
    local int Index;
    local int SlotIndex;
    local int i;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        CoverReplicationData[Index].SlotsCoverTypeChanged.Length = SlotIndices.Length;
        for (i = 0; i < SlotIndices.Length; i++)
        {
            CoverReplicationData[Index].SlotsCoverTypeChanged[i].SlotIndex = byte(SlotIndices[i]);
            CoverReplicationData[Index].SlotsCoverTypeChanged[i].ManualCoverType = NewCoverType;
        }
    }
    else
    {
        for (i = 0; i < SlotIndices.Length; i++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Find('SlotIndex', byte(SlotIndices[i]));
            if (SlotIndex == -1)
            {
                SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Length;
                CoverReplicationData[Index].SlotsCoverTypeChanged.Length = CoverReplicationData[Index].SlotsCoverTypeChanged.Length + 1;
                CoverReplicationData[Index].SlotsCoverTypeChanged[SlotIndex].SlotIndex = byte(SlotIndices[i]);
            }
            CoverReplicationData[Index].SlotsCoverTypeChanged[SlotIndex].ManualCoverType = NewCoverType;
            SlotIndex = CoverReplicationData[Index].SlotsAdjusted.Find(byte(SlotIndices[i]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsAdjusted.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == Self)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == None)
            {
                PC.SpawnCoverReplicator();
            }
            else
            {
                PC.MyCoverReplicator.NotifySetManualCoverTypeForSlots(Link, SlotIndices, NewCoverType);
            }
        }
    }
    if (PlayerController(Owner) != None)
    {
        ServerSendManualCoverTypeSlots(Index);
    }
}
public function PurgeOldEntries()
{
    local int i;
    
    for (i = 0; i < CoverReplicationData.Length; i++)
    {
        if (CoverReplicationData[i].Link == None)
        {
            CoverReplicationData.Remove(i--, 1);
        }
    }
}
public function ReplicateInitialCoverInfo()
{
    local CoverReplicator CoverReplicatorBase;
    
    CoverReplicatorBase = WorldInfo.Game.GetCoverReplicator();
    CoverReplicatorBase.PurgeOldEntries();
    CoverReplicationData = CoverReplicatorBase.CoverReplicationData;
    if (PlayerController(Owner) != None)
    {
        ClientSetOwner(PlayerController(Owner));
        ServerSendInitialCoverReplicationInfo(0);
    }
}
public reliable server function ServerSendAdjustedSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsAdjusted;
    local byte SlotsAdjusted[8];
    local int i;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != None)
    {
        SlotsArrayIndex = 0;
        do {
            NumSlotsAdjusted = byte(Clamp(CoverReplicationData[Index].SlotsAdjusted.Length - SlotsArrayIndex, 0, 8));
            for (i = 0; i < int(NumSlotsAdjusted); i++)
            {
                SlotsAdjusted[i] = CoverReplicationData[Index].SlotsAdjusted[SlotsArrayIndex + i];
            }
            bDone = CoverReplicationData[Index].SlotsAdjusted.Length - SlotsArrayIndex <= 8;
            ClientReceiveAdjustedSlots(Index, CoverReplicationData[Index].Link, NumSlotsAdjusted, SlotsAdjusted, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}
public reliable server function ServerSendDisabledSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsDisabled;
    local byte SlotsDisabled[8];
    local int i;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != None)
    {
        SlotsArrayIndex = 0;
        do {
            NumSlotsDisabled = byte(Clamp(CoverReplicationData[Index].SlotsDisabled.Length - SlotsArrayIndex, 0, 8));
            for (i = 0; i < int(NumSlotsDisabled); i++)
            {
                SlotsDisabled[i] = CoverReplicationData[Index].SlotsDisabled[SlotsArrayIndex + i];
            }
            bDone = CoverReplicationData[Index].SlotsDisabled.Length - SlotsArrayIndex <= 8;
            ClientReceiveDisabledSlots(Index, CoverReplicationData[Index].Link, NumSlotsDisabled, SlotsDisabled, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}
public reliable server function ServerSendEnabledSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsEnabled;
    local byte SlotsEnabled[8];
    local int i;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != None)
    {
        SlotsArrayIndex = 0;
        do {
            NumSlotsEnabled = byte(Clamp(CoverReplicationData[Index].SlotsEnabled.Length - SlotsArrayIndex, 0, 8));
            for (i = 0; i < int(NumSlotsEnabled); i++)
            {
                SlotsEnabled[i] = CoverReplicationData[Index].SlotsEnabled[SlotsArrayIndex + i];
            }
            bDone = CoverReplicationData[Index].SlotsEnabled.Length - SlotsArrayIndex <= 8;
            ClientReceiveEnabledSlots(Index, CoverReplicationData[Index].Link, NumSlotsEnabled, SlotsEnabled, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}
public reliable server function ServerSendInitialCoverReplicationInfo(int Index)
{
    local byte SlotsArrayIndex;
    local byte NumSlotsEnabled;
    local byte NumSlotsDisabled;
    local byte NumSlotsAdjusted;
    local byte NumCoverTypesChanged;
    local byte SlotsEnabled[8];
    local byte SlotsDisabled[8];
    local byte SlotsAdjusted[8];
    local ManualCoverTypeInfo SlotsCoverTypeChanged[8];
    local int i;
    local bool bDone;
    
    while (Index < CoverReplicationData.Length && CoverReplicationData[Index].Link == None)
    {
        CoverReplicationData.Remove(Index, 1);
    }
    if (Index < CoverReplicationData.Length)
    {
        SlotsArrayIndex = 0;
        do {
            NumSlotsEnabled = byte(Clamp(CoverReplicationData[Index].SlotsEnabled.Length - int(SlotsArrayIndex), 0, 8));
            NumSlotsDisabled = byte(Clamp(CoverReplicationData[Index].SlotsDisabled.Length - int(SlotsArrayIndex), 0, 8));
            NumSlotsAdjusted = byte(Clamp(CoverReplicationData[Index].SlotsAdjusted.Length - int(SlotsArrayIndex), 0, 8));
            NumCoverTypesChanged = byte(Clamp(CoverReplicationData[Index].SlotsCoverTypeChanged.Length - int(SlotsArrayIndex), 0, 8));
            if (int(NumSlotsEnabled) == 0)
            {
                for (i = 0; i < 8; i++)
                {
                    SlotsEnabled[i] = 0;
                }
            }
            else
            {
                for (i = 0; i < int(NumSlotsEnabled); i++)
                {
                    SlotsEnabled[i] = CoverReplicationData[Index].SlotsEnabled[int(SlotsArrayIndex) + i];
                }
            }
            if (int(NumSlotsDisabled) == 0)
            {
                for (i = 0; i < 8; i++)
                {
                    SlotsDisabled[i] = 0;
                }
            }
            else
            {
                for (i = 0; i < int(NumSlotsDisabled); i++)
                {
                    SlotsDisabled[i] = CoverReplicationData[Index].SlotsDisabled[int(SlotsArrayIndex) + i];
                }
            }
            if (int(NumSlotsAdjusted) == 0)
            {
                for (i = 0; i < 8; i++)
                {
                    SlotsAdjusted[i] = 0;
                }
            }
            else
            {
                for (i = 0; i < int(NumSlotsAdjusted); i++)
                {
                    SlotsAdjusted[i] = CoverReplicationData[Index].SlotsAdjusted[int(SlotsArrayIndex) + i];
                }
            }
            if (int(NumCoverTypesChanged) == 0)
            {
                for (i = 0; i < 8; i++)
                {
                    SlotsCoverTypeChanged[i].SlotIndex = 0;
                    SlotsCoverTypeChanged[i].ManualCoverType = ECoverType.CT_None;
                }
            }
            else
            {
                for (i = 0; i < int(NumCoverTypesChanged); i++)
                {
                    SlotsCoverTypeChanged[i] = CoverReplicationData[Index].SlotsCoverTypeChanged[int(SlotsArrayIndex) + i];
                }
            }
            bDone = CoverReplicationData[Index].SlotsEnabled.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsDisabled.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsAdjusted.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsCoverTypeChanged.Length - int(SlotsArrayIndex) <= 8;
            ClientReceiveInitialCoverReplicationInfo(Index, CoverReplicationData[Index].Link, CoverReplicationData[Index].Link.bDisabled, NumSlotsEnabled, SlotsEnabled, NumSlotsDisabled, SlotsDisabled, NumSlotsAdjusted, SlotsAdjusted, NumCoverTypesChanged, SlotsCoverTypeChanged, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}
public reliable server function ServerSendLinkDisabledState(int Index)
{
    if (CoverReplicationData[Index].Link != None)
    {
        ClientReceiveLinkDisabledState(Index, CoverReplicationData[Index].Link, CoverReplicationData[Index].Link.bDisabled);
    }
}
public reliable server function ServerSendManualCoverTypeSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumCoverTypesChanged;
    local ManualCoverTypeInfo SlotsCoverTypeChanged[8];
    local int i;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != None)
    {
        SlotsArrayIndex = 0;
        do {
            NumCoverTypesChanged = byte(Clamp(CoverReplicationData[Index].SlotsCoverTypeChanged.Length - SlotsArrayIndex, 0, 8));
            for (i = 0; i < int(NumCoverTypesChanged); i++)
            {
                SlotsCoverTypeChanged[i] = CoverReplicationData[Index].SlotsCoverTypeChanged[SlotsArrayIndex + i];
            }
            bDone = CoverReplicationData[Index].SlotsCoverTypeChanged.Length - SlotsArrayIndex <= 8;
            ClientReceiveManualCoverTypeSlots(Index, CoverReplicationData[Index].Link, NumCoverTypesChanged, SlotsCoverTypeChanged, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NetUpdateFrequency = 0.100000001
    bOnlyRelevantToOwner = TRUE
    bAlwaysRelevant = FALSE
}