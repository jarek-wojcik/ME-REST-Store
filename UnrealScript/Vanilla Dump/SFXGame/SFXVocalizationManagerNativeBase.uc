Class SFXVocalizationManagerNativeBase extends Actor
    native
    transient;

struct native SFXVocalizationEventProperties 
{
    var array<ESFXVocalizationRole> Roles;
    var(SFXVocalizationEventProperties) float ChanceToPlay;
    var(SFXVocalizationEventProperties) float MinTimeBetweenSec;
    var float TimeLastPlayed;
    var float Delay;
    var float MaxWitnessDistSq;
    var float MaxDelayedTime;
    var bool bQueueIfBlocked;
    var bool bCanInterrupt;
    var bool bCanPlayIfDead;
    var bool bCanPlayIfRagdolled;
    
    structdefaultproperties
    {
        Roles = (ESFXVocalizationRole.SFXVocalizationRole_Instigator, ESFXVocalizationRole.SFXVocalizationRole_Recipient, ESFXVocalizationRole.SFXVocalizationRole_TeammateWitness, ESFXVocalizationRole.SFXVocalizationRole_EnemyWitness)
        ChanceToPlay = 1.0
        MinTimeBetweenSec = 20.0
        TimeLastPlayed = -999.0
        MaxWitnessDistSq = 1e09
    }
};
struct native SFXVocalization 
{
    var SFXVocalizationEvent Event;
    var BioPawn Speaker;
    var int Specific;
    var ESFXVocalizationRole Role;
};
struct native SFXVocalizationEvent 
{
    var BioPawn Instigator;
    var BioPawn Recipient;
    var int Id;
    var float DelayTimeRemainingSec;
    var float TriggerTimeSec;
    var int DebugIndex;
};

var transient array<BioPawn> m_aIgnorePawn;
var array<SFXVocalizationEventProperties> EventProperties;
var transient array<SFXVocalizationEvent> QueuedEvents;
var SFXVocalizationBank OverridesAllIfSet;
var transient int DebugCounter;
var transient bool bDebugging;
var transient bool bAlwaysPlay;

public event function string DebugOutput(int Type, int Value)
{
    local Object En;
    local string Output;
    
    En = Class'SFXVocalizationTypes'.default.EnumForType[Type];
    Output = byte(Type) @ "---" @ GetEnum(En, Value);
    return Output;
}
public event function SFXVocalizationBank GetPawnVocalizationBank(BioPawn P)
{
    if (OverridesAllIfSet != None)
    {
        return OverridesAllIfSet;
    }
    if (P != None)
    {
        if (P.InCombat())
        {
            return P.CombatVoc;
        }
        else if (P.bInStealthVolume)
        {
            return P.StealthVoc;
        }
        else
        {
            return P.ExplorationVoc;
        }
    }
    return None;
}
public native function bool HandleSFXVocalizationEvent(const out SFXVocalizationEvent Event);

protected event simulated function bool PlaySFXVocalizationSLineInternal(const out SFXVocalizationEvent Event, const out SFXVocalizationLine LineToPlay, BioPawn Speaker, optional float DelaySec)
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(WorldInfo);
    if (BWI == None)
    {
        return FALSE;
    }
    if (LineToPlay.Sound != None)
    {
        Speaker.PlayFOVO(LineToPlay.Sound);
        Class'BioRemoteLogger'.static.SendVocalizationEvent(Speaker.Tag, LineToPlay.Sound.Name);
    }
    return TRUE;
}
public native function bool SpecificAffiliationMatches(int idx, BioPawn Pawn);

public native function bool SpecificChallengeMatches(EChallengeType Type, BioPawn Pawn);

public native function bool SpecificCharacterTypeMatches(ECharacterType Type, BioPawn Pawn);

public native function bool SpecificGenderMatches(ESFXVocalizationGender Type, BioPawn Pawn);

public native function bool SpecificLocationMatches(ESFXVocalizationLocation Type, BioPawn BP, BioPawn Speaker);

public native function bool SpecificNameMatches(ESFXVocalizationName Type, BioPawn Pawn);

public native function bool SpecificWeaponMatches(ESFXVocalizationWeapon Type, BioPawn Pawn);

public event simulated function TickEvents(float DeltaTime);

public function AddToIgnoreList(BioPawn oPawn)
{
    if (m_aIgnorePawn.Find(oPawn) == -1)
    {
        m_aIgnorePawn.AddItem(oPawn);
    }
}
public function QueueReplicatedVocalization(SFXVocalizationEvent VocEvent)
{
    QueuedEvents.AddItem(VocEvent);
}
public function RemoveFromIgnoreList(BioPawn oPawn)
{
    m_aIgnorePawn.RemoveItem(oPawn);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bReplicateMovement = FALSE
    bMovable = FALSE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}