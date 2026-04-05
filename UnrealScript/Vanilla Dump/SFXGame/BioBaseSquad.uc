Class BioBaseSquad extends Actor
    native
    abstract;

enum EBioCapMode
{
    BIO_CAPMODE_WEAPON,
    BIO_CAPMODE_BIOTICS,
    BIO_CAPMODE_TECH,
    BIO_CAPMODE_COMBAT,
    BIO_CAPMODE_GRENADES,
    BIO_CAPMODE_ERROR,
};

var array<Pawn> Members;
var(Squad) array<BioPlaypenVolume> PlaypenVolumes;
var(Squad) array<SFXCombatZone> CombatZones;
var BioSquadTargetData TargetData;
var transient BioPawn CachedPlayerPawn;
var bool m_bSquadHasVehicle;
var const bool bIsPlayerSquad;
var transient bool m_bCombatEnabled;
var(Squad) bool bSquadEnabled;
var bool PathingTowardCombatZone;

public native function AddCombatZone(SFXCombatZone CombatZone);

public event function int AddMember(Pawn Pawn, optional bool bCheckPlaypens = TRUE)
{
    local BioPawn BP;
    local int idx;
    local SFXAI_NativeBase AI;
    
    BP = BioPawn(Pawn);
    idx = -1;
    if (Pawn != None && (BP == None || BP.Squad != Self))
    {
        if (BP != None)
        {
            if (BP.Squad != None)
            {
                BP.Squad.RemoveMember(Pawn);
            }
            BP.Squad = Self;
        }
        if (Pawn.Controller.bIsPlayer)
        {
            Members.InsertItem(0, Pawn);
            idx = 0;
        }
        else
        {
            Members.AddItem(Pawn);
            idx = Members.Length - 1;
        }
        AI = SFXAI_NativeBase(Pawn.Controller);
        if (AI != None)
        {
            if (bCheckPlaypens && HasPlaypen())
            {
                if (IsPositionInPlaypen(Pawn.location) == FALSE)
                {
                    AI.OnLeftPlaypen();
                }
                else
                {
                    AI.OnEnteredPlaypen();
                }
            }
            AI.EnableAI(bSquadEnabled, 4);
        }
    }
    return idx;
}
public native function AddVolumeToPlaypen(BioPlaypenVolume Volume);

public event function DisableSquad()
{
    local BioAiController AI;
    local SFXAI_NativeBase oSFXAI;
    
    if (bSquadEnabled)
    {
        foreach SquadMembers(AI)
        {
            oSFXAI = SFXAI_NativeBase(AI);
            if (oSFXAI != None)
            {
                oSFXAI.EnableAI(FALSE, 4);
            }
        }
        bSquadEnabled = FALSE;
    }
}
public event function EnableSquad()
{
    local BioAiController AI;
    local SFXAI_NativeBase oSFXAI;
    
    if (!bSquadEnabled)
    {
        foreach SquadMembers(AI)
        {
            oSFXAI = SFXAI_NativeBase(AI);
            if (oSFXAI != None)
            {
                oSFXAI.EnableAI(TRUE, 4);
            }
        }
        bSquadEnabled = TRUE;
    }
}
public native function bool GetClosestCombatZoneOrigin(Vector Position, out Vector Origin);

public native function BioTacticalMoveToIndicator GetMemberMoveIndicator(int nIndex);

public native function Actor GetPlaypenNavOrigin(optional Pawn oPawn);

public native function Actor GetPlaypenReturnPoint(Pawn oPawn);

public native function bool HasCombatZone(SFXCombatZone CombatZone);

public native function bool HasPlaypen();

public native function bool IsActorInPlaypen(Actor oActor);

public native function bool IsActorInSubtractivePlaypen(Actor oActor);

public native function bool IsCoverInCombatZone(CoverSlotMarker SlotMarker);

public native function bool IsPositionInCombatZone(Vector Position);

public native function bool IsPositionInPlaypen(const out Vector vLocation);

public native function bool IsPositionInSubtractivePlaypen(const out Vector vLocation);

public native function bool IsVolumeInPlaypen(BioPlaypenVolume Volume);

public final native function BioBaseSquad MakeHackable();

public event function MemberRemoved(Pawn oPawn)
{
    local BioPawn Pawn;
    
    Pawn = BioPawn(oPawn);
    if (Pawn != None)
    {
        Pawn.Squad = None;
    }
}
public event function NotifyEnemyPerceived();

public event function NotifyNoEnemiesPerceived();

public native function RemoveCombatZone(SFXCombatZone CombatZone);

public native function bool RemoveMember(Pawn pPawn);

public native function RemoveVolumeFromPlaypen(BioPlaypenVolume Volume);

public native function SetMemberMoveIndicator(int nIndex, BioTacticalMoveToIndicator oIndicator);

public final iterator native function SquadMembers(out BioAiController oController);

public native function UpdatePlaypen();

public function bool Died(Pawn member, Controller Killer)
{
    local int idx;
    local BioAiController oMember;
    
    if (Members.Length == 2)
    {
        foreach SquadMembers(oMember)
        {
            if (oMember.Pawn != None && oMember.Pawn != member && oMember.Pawn.IsDead() == FALSE)
            {
                oMember.OnLastManStanding();
            }
        }
    }
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        if (ClassIsChildOf(GeneratedEvents[idx].Class, Class'SeqEvent_Death') != FALSE)
        {
            if (Killer != None)
            {
                GeneratedEvents[idx].SetObjectVars("Killer", Killer.Pawn);
            }
            GeneratedEvents[idx].CheckActivate(Self, member);
        }
    }
    return TRUE;
}
public function NotifyCombatZoneAdded()
{
    local BioAiController AIController;
    local SFXAI_Core AI;
    
    foreach SquadMembers(AIController)
    {
        AI = SFXAI_Core(AIController);
        if (AI != None)
        {
            AI.NotifyCombatZoneAdded();
        }
    }
}
public function NotifyCombatZoneRemoved()
{
    local BioAiController AIController;
    local SFXAI_Core AI;
    
    foreach SquadMembers(AIController)
    {
        AI = SFXAI_Core(AIController);
        if (AI != None)
        {
            AI.NotifyCombatZoneRemoved();
        }
    }
}
public function NotifyPlaypenChanged()
{
    local BioAiController AI;
    local SFXAI_Core oSFXAI;
    
    foreach SquadMembers(AI)
    {
        oSFXAI = SFXAI_Core(AI);
        if (oSFXAI != None)
        {
            oSFXAI.NotifyPlaypenChanged();
        }
    }
}
public function RemoveDyingMember(Pawn oPawn)
{
    RemoveMember(oPawn);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 30.0
        CollisionRadius = 10.0
        ReplacementPrimitive = None
    End Object
    Begin Object Class=BioSquadLinesComponent Name=SquadLines
        ReplacementPrimitive = None
        HiddenGame = TRUE
    End Object
    bSquadEnabled = TRUE
    Components = (None, SquadLines)
    DrawScale = 2.0
    bAlwaysRelevant = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}