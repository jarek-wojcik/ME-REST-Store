Class SFXAICmd_MoveToCover extends SFXAICommand within SFXAI_Cover;

var transient bool m_bDoPeriodicCoverCheck;
var transient bool m_bAllowedToFire;

public function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen)
{
    local CoverSlotMarker oCoverSlot;
    local Pawn VisibleEnemy;
    local Vector VectToEnemyFromCover;
    
    Super.NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
    if (TimeSinceSeen > 10.0)
    {
        if (Outer.CoverGoal.Link != None && Outer.CoverGoal.SlotIdx != -1)
        {
            oCoverSlot = Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker;
            VisibleEnemy = Outer.EnemyList[EnemyIdx].Pawn;
            VectToEnemyFromCover = VisibleEnemy.location - oCoverSlot.location;
            if ((VisibleEnemy == Outer.FireTarget || VSizeSq(VectToEnemyFromCover) < 250000.0) && Vector(Outer.CoverGoal.Link.GetSlotRotation(Outer.CoverGoal.SlotIdx)) Dot Normal(VectToEnemyFromCover) <= 0.5)
            {
                Outer.MoveTarget = None;
                Outer.bReachedMoveGoal = FALSE;
            }
        }
    }
}
public static function bool MoveToCover(SFXAI_Cover AI, optional bool bInDoPeriodicCoverCheck = TRUE, optional bool bInAllowedToFire = TRUE)
{
    local SFXAICmd_MoveToCover Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveToCover';
        if (Cmd != None)
        {
            Cmd.m_bDoPeriodicCoverCheck = bInDoPeriodicCoverCheck;
            Cmd.m_bAllowedToFire = bInAllowedToFire;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function PeriodicCoverValidation()
{
    local CoverSlotMarker oCoverSlot;
    local int idx;
    local Pawn oEnemyPawn;
    local float fDistFromEnemySq;
    
    if (Outer.CoverGoal.Link != None && Outer.CoverGoal.SlotIdx != -1)
    {
        oCoverSlot = Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker;
        if (oCoverSlot != None)
        {
            for (idx = 0; idx < Outer.EnemyList.Length && !Outer.m_bInvalidatedCover; idx++)
            {
                oEnemyPawn = Outer.EnemyList[idx].Pawn;
                if (oEnemyPawn != None && (Outer.TimeSinceEnemyLocationUpdate(idx) < 5.0 || oEnemyPawn == Outer.FireTarget))
                {
                    fDistFromEnemySq = VSizeSq(oCoverSlot.location - oEnemyPawn.location);
                    Outer.m_bInvalidatedCover = fDistFromEnemySq <= Outer.EnemyDistance_Short * Outer.EnemyDistance_Short;
                }
            }
        }
    }
    if (Outer.m_bInvalidatedCover)
    {
        Outer.MoveTarget = None;
        Outer.bReachedMoveGoal = FALSE;
    }
}
public event function Popped()
{
    if (Outer.bReachedMoveGoal == FALSE && Outer.CoverGoal.Link != None && Outer.CoverGoal.SlotIdx != -1 && Outer.Pawn != None)
    {
        Outer.CoverGoal.Link.UnClaim(Outer.Pawn, Outer.CoverGoal.SlotIdx, FALSE);
    }
    Outer.CoverGoal.Link = None;
    Outer.CoverGoal.SlotIdx = -1;
    if (m_bDoPeriodicCoverCheck)
    {
        Outer.ClearTimer('PeriodicCoverValidation', Self);
    }
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    GotoState('MovingToCover', , , );
}

state MovingToCover extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead() || Outer.CoverGoal.Link == None)
    {
        PopState();
    }
    if (Outer.IsValidCover(Outer.CoverGoal) == FALSE || Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker == None)
    {
        PopState();
    }
    Outer.m_bInvalidatedCover = FALSE;
    if (m_bDoPeriodicCoverCheck)
    {
        Outer.SetTimer(0.5, TRUE, 'PeriodicCoverValidation', Self);
    }
    Outer.Sleep(0.00999999978);
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(18, Outer.MyBP, , , , TRUE);
    if (Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker == Outer.MyBP.Anchor)
    {
        Outer.bReachedMoveGoal = TRUE;
    }
    else
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker, 0.0, m_bAllowedToFire, FALSE);
    }
    if (m_bDoPeriodicCoverCheck)
    {
        Outer.ClearTimer('PeriodicCoverValidation', Self);
    }
    if (Outer.bReachedMoveGoal == FALSE)
    {
        if (Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotOwner == Outer.MyBP)
        {
            Outer.CoverGoal.Link.SetInvalidUntil(Outer.CoverGoal.SlotIdx, Outer.WorldInfo.GameTimeSeconds + 0.5);
        }
        Outer.UnClaimCover();
        Outer.PopCommand(Self);
    }
    if (Outer.Cover != Outer.CoverGoal)
    {
        if (!Outer.ClaimCover(Outer.CoverGoal))
        {
            Outer.UnClaimCover();
            Outer.PopCommand(Self);
        }
    }
    Class'SFXAICmd_EnterCover'.static.EnterCover(Outer);
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}