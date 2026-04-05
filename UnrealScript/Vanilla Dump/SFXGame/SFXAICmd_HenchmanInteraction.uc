Class SFXAICmd_HenchmanInteraction extends SFXAICommand within SFXAI_Henchman;

enum FallBackMethod
{
    eFBM_None,
    eFBM_MoveToPlayer,
    eFBM_TeleportToNearbyNode,
    eFBM_DirectTeleport,
    eFBM_TeleportWhileVisible,
};

var Actor InteractionPoint;
var float fidelityTimeout;
var transient Pawn PlayerPawn;
var transient bool bReachedInteractionPoint;
var transient bool bStopInteraction;
var transient bool bCalledStopDelegate;
var transient bool bTriedMoveToPlayer;
var transient bool bTriedTeleportToNearbyNode;
var transient bool bTriedDirectTeleport;
var FallBackMethod CurrentFallback;

public function bool CanPlayerSeeActor(Actor oActor)
{
    local Vector vCamera;
    local Rotator rCamera;
    local Vector vToPoint;
    local Vector HitLocation;
    local Vector HitNormal;
    local Actor HitActor;
    local bool bCanSee;
    
    bCanSee = FALSE;
    if (oActor != None)
    {
        if (Outer.WorldInfo.TimeSeconds - oActor.LastRenderTime < 0.25)
        {
            bCanSee = TRUE;
        }
        else if (NavigationPoint(oActor) != None)
        {
            if (PlayerPawn != None && PlayerPawn.Controller != None)
            {
                PlayerPawn.Controller.GetPlayerViewPoint(vCamera, rCamera);
                vToPoint = oActor.location - vCamera;
                if (vToPoint Dot Vector(rCamera) > 0.0)
                {
                    HitActor = PlayerPawn.Trace(HitLocation, HitNormal, oActor.location, vCamera, , , , );
                    if (HitActor == None || HitActor == oActor)
                    {
                        bCanSee = TRUE;
                    }
                }
            }
        }
    }
    return bCanSee;
}
public function FallbackTimeout()
{
    switch (CurrentFallback)
    {
        case FallBackMethod.eFBM_MoveToPlayer:
            CurrentFallback = FallBackMethod.eFBM_TeleportToNearbyNode;
            break;
        case FallBackMethod.eFBM_TeleportToNearbyNode:
            CurrentFallback = FallBackMethod.eFBM_DirectTeleport;
            break;
        case FallBackMethod.eFBM_DirectTeleport:
            CurrentFallback = FallBackMethod.eFBM_TeleportWhileVisible;
            break;
        case FallBackMethod.eFBM_TeleportWhileVisible:
        case FallBackMethod.eFBM_None:
        default:
            break;
    }
}
public function FidelityTimer()
{
    CurrentFallback = FallBackMethod.eFBM_TeleportWhileVisible;
    Outer.ClearTimer('FallbackTimeout', Self);
}
public function bool FindClosestCover(out CoverInfo NearbyCover)
{
    local CoverSlotMarker Marker;
    local float DistToSlotSq;
    local float ShortestDistSq;
    local CoverSlotMarker ClosestMarker;
    
    ShortestDistSq = 1000000.0;
    foreach Outer.WorldInfo.RadiusNavigationPoints(Class'CoverSlotMarker', Marker, InteractionPoint.location, 100.0)
    {
        DistToSlotSq = VSizeSq(Marker.location - InteractionPoint.location);
        if (DistToSlotSq < ShortestDistSq)
        {
            ShortestDistSq = DistToSlotSq;
            ClosestMarker = Marker;
        }
    }
    if (ClosestMarker != None)
    {
        NearbyCover = ClosestMarker.OwningSlot;
        return TRUE;
    }
    return FALSE;
}
public function Popped()
{
    Super(GameAICommand).Popped();
    if (!bCalledStopDelegate)
    {
        if (Outer.__StoppedWorldInteraction__Delegate != None)
        {
            Outer.__StoppedWorldInteraction__Delegate(FALSE);
        }
    }
    Outer.CoverGoal.Link = None;
    Outer.CoverGoal.SlotIdx = -1;
    Outer.UnClaimCover();
    Outer.InvalidateCover();
    Outer.ClearTimer('fidelityTimeout', Self);
    Outer.ClearTimer('FallbackTimeout', Self);
    Outer.EnableAI(TRUE, 32);
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    bReachedInteractionPoint = FALSE;
    bStopInteraction = FALSE;
    bCalledStopDelegate = FALSE;
    bTriedMoveToPlayer = FALSE;
    bTriedTeleportToNearbyNode = FALSE;
    bTriedDirectTeleport = FALSE;
    CurrentFallback = FallBackMethod.eFBM_None;
}
public function bool ResurrectHenchman()
{
    if (Outer.MyBP.Physics != EPhysics.PHYS_RigidBody && Outer.MyBP.Mesh == Outer.MyBP.CollisionComponent)
    {
        Outer.MyBP.SetPhysics(10);
    }
    return Outer.MyBP.Resurrect(1.0, FALSE);
}
public static function bool StartWorldInteraction(SFXAI_Core AI, Actor oInteractionPoint, float fFidelityTimeout)
{
    local SFXAICmd_HenchmanInteraction Cmd;
    local SFXAI_Henchman HenchAI;
    
    HenchAI = SFXAI_Henchman(AI);
    if (HenchAI != None && oInteractionPoint != None)
    {
        Cmd = new (HenchAI) Class'SFXAICmd_HenchmanInteraction';
        if (Cmd != None)
        {
            Cmd.InteractionPoint = oInteractionPoint;
            Cmd.fidelityTimeout = fFidelityTimeout;
            HenchAI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function bool TeleportToNearbyNode()
{
    local NavigationPoint InteractionNavPoint;
    local NavigationPoint TeleportNode;
    local ReachSpec ConnectingReachSpec;
    local array<NavigationPoint> NearbyNodes;
    local array<ReachSpec> NearbyReachSpecs;
    local bool bTeleported;
    
    bTeleported = FALSE;
    InteractionNavPoint = NavigationPoint(InteractionPoint);
    if (InteractionNavPoint != None)
    {
        ConnectingReachSpec = InteractionNavPoint.PathList[Rand(InteractionNavPoint.PathList.Length)];
        if (ConnectingReachSpec != None)
        {
            TeleportNode = NavigationPoint(ConnectingReachSpec.End.Actor);
        }
    }
    else
    {
        Outer.WorldInfo.NavigationPointCheck(InteractionPoint.location, vect(500.0, 500.0, 200.0), NearbyNodes, NearbyReachSpecs);
        if (NearbyNodes.Length > 0)
        {
            TeleportNode = NearbyNodes[Rand(NearbyNodes.Length)];
        }
    }
    if (TeleportNode != None)
    {
        if (!CanPlayerSeeActor(Outer.MyBP) && !CanPlayerSeeActor(TeleportNode))
        {
            bTeleported = Outer.TeleportToActor(TeleportNode, FALSE, FALSE);
        }
    }
    return bTeleported;
}

state RunHenchmanInteraction extends DebugState 
{
    public function bool CancelCommand(optional int nReason)
    {
        local BioCustomAction CurrentCustomAction;
        local SFXCustomAction_InteractionPointAnim InteractionAction;
        
        Outer.MyBP.GetCurrentCustomAction(CurrentCustomAction);
        InteractionAction = SFXCustomAction_InteractionPointAnim(CurrentCustomAction);
        if (InteractionAction != None)
        {
            InteractionAction.TriggerEnd();
        }
        bStopInteraction = TRUE;
        return TRUE;
    }
    
Begin:
    if (SFXNav_InteractionHenchManual(InteractionPoint) != None)
    {
        if (!bStopInteraction)
        {
            if (SFXNav_InteractionPoint(InteractionPoint).bPreciseLocation || SFXNav_InteractionPoint(InteractionPoint).bPreciseRotation)
            {
                Outer.PrecisionMove(InteractionPoint.location, InteractionPoint.Rotation);
            }
        }
        if (Outer.__ReachedInteractionPoint__Delegate != None)
        {
            Outer.__ReachedInteractionPoint__Delegate();
        }
    }
    else
    {
        if (Outer.__ReachedInteractionPoint__Delegate != None)
        {
            Outer.__ReachedInteractionPoint__Delegate();
        }
        if (!bStopInteraction)
        {
            if (SFXNav_InteractionHenchCover(InteractionPoint) != None)
            {
                if (FindClosestCover(Outer.CoverGoal))
                {
                    if (Outer.ClaimCover(Outer.CoverGoal))
                    {
                        Class'SFXAICmd_EnterCover'.static.EnterCover(Outer);
                    }
                }
                while (!bStopInteraction)
                {
                    Outer.Sleep(0.25);
                }
                Outer.InvalidateCover();
            }
            else if (SFXNav_InteractionPoint(InteractionPoint) != None)
            {
                SFXNav_InteractionPoint(InteractionPoint).StartInteraction(Outer.MyBP);
            }
        }
    }
    if (Outer.__StoppedWorldInteraction__Delegate != None)
    {
        bCalledStopDelegate = TRUE;
        Outer.__StoppedWorldInteraction__Delegate(TRUE);
    }
    Outer.PopCommand(Self);
    stop;
};
auto state MoveToInteractionPoint extends DebugState 
{
    public function bool CancelCommand(optional int nReason)
    {
        Global.CancelCommand(nReason);
        bStopInteraction = TRUE;
        return TRUE;
    }
    
Begin:
    if (Outer.m_bResetHenchman)
    {
        Class'SFXAICmd_ResetHenchman'.static.InitCommand(Outer);
    }
    Outer.MyBP.ShouldCrouch(FALSE);
    if (PlayerPawn == None)
    {
        PlayerPawn = Outer.MyBP.Squad.Members[0];
    }
    while (!bReachedInteractionPoint && !bStopInteraction)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, InteractionPoint, , , FALSE);
        if (Outer.bReachedMoveGoal)
        {
            bReachedInteractionPoint = TRUE;
            continue;
        }
        if (!bStopInteraction)
        {
            if (CurrentFallback == FallBackMethod.eFBM_None)
            {
                Outer.SetTimer(fidelityTimeout, FALSE, 'FidelityTimer', Self);
                CurrentFallback = FallBackMethod.eFBM_MoveToPlayer;
            }
            if (CurrentFallback == FallBackMethod.eFBM_MoveToPlayer)
            {
                Outer.bReachedMoveGoal = FALSE;
                if (!bTriedMoveToPlayer)
                {
                    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, PlayerPawn, 300.0, , FALSE);
                    Outer.SetTimer(5.0, FALSE, 'FallbackTimeout', Self);
                    bTriedMoveToPlayer = TRUE;
                }
                if (!Outer.bReachedMoveGoal && !bStopInteraction)
                {
                    if (!CanPlayerSeeActor(Outer.MyBP))
                    {
                        Outer.bReachedMoveGoal = Outer.TeleportToActor(PlayerPawn, FALSE);
                    }
                    Outer.Sleep(0.5);
                }
                bTriedMoveToPlayer = TRUE;
                continue;
            }
            if (CurrentFallback == FallBackMethod.eFBM_TeleportToNearbyNode)
            {
                if (!bTriedTeleportToNearbyNode)
                {
                    Outer.SetTimer(5.0, FALSE, 'FallbackTimeout', Self);
                    bTriedTeleportToNearbyNode = TRUE;
                }
                TeleportToNearbyNode();
                Outer.Sleep(0.5);
                continue;
            }
            if (CurrentFallback == FallBackMethod.eFBM_DirectTeleport)
            {
                if (!bTriedDirectTeleport)
                {
                    Outer.SetTimer(5.0, FALSE, 'FallbackTimeout', Self);
                    bTriedDirectTeleport = TRUE;
                }
                if (!CanPlayerSeeActor(Outer.MyBP) && !CanPlayerSeeActor(InteractionPoint))
                {
                    Outer.bReachedMoveGoal = Outer.TeleportToActor(InteractionPoint, FALSE, FALSE);
                }
                Outer.Sleep(0.5);
                continue;
            }
            if (CurrentFallback == FallBackMethod.eFBM_TeleportWhileVisible)
            {
                if (Outer.TeleportToActor(InteractionPoint, TRUE, FALSE) == FALSE)
                {
                }
                Outer.Sleep(1.0);
                continue;
            }
        }
    }
    if (bStopInteraction)
    {
        if (Outer.__StoppedWorldInteraction__Delegate != None)
        {
            bCalledStopDelegate = TRUE;
            Outer.__StoppedWorldInteraction__Delegate(TRUE);
        }
        Outer.PopCommand(Self);
    }
    else if (bReachedInteractionPoint)
    {
        GotoState('RunHenchmanInteraction', , , );
    }
    else
    {
        Outer.PopCommand(Self);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}