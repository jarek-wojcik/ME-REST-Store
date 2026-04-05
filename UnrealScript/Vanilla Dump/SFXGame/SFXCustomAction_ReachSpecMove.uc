Class SFXCustomAction_ReachSpecMove extends SFXCustomAction_ProceduralMoveBase
    native
    config(Game);

var transient ReachSpec MovementPath;
var SFXReachSpecPlaceholderCylinder BlockingStartCylinder;
var SFXReachSpecPlaceholderCylinder BlockingEndCylinder;

public function StartCustomAction()
{
    local SFXNav_BlockingPathNode BlockingPathNode;
    
    if (MovementPath != None)
    {
        Destination = MovementPath.End.Actor.location;
        BlockingPathNode = SFXNav_BlockingPathNode(MovementPath.Start);
        if (BlockingPathNode != None)
        {
            BlockingPathNode.StartPathMove(m_oPawn);
        }
        BlockMoveEndPoints();
    }
    Super.StartCustomAction();
}
public function BlockMoveEndPoints()
{
    local SFXCustomReachSpec CustomReachSpec;
    local NavigationPoint EndNav;
    
    BlockingStartCylinder = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , MovementPath.Start.location);
    if (BlockingStartCylinder != None)
    {
        BlockingStartCylinder.PawnsToIgnore[0] = m_oPawn;
        BlockingStartCylinder.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.14999998, m_oPawn.GetCollisionHeight());
    }
    BlockingEndCylinder = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , MovementPath.End.Actor.location);
    if (BlockingEndCylinder != None)
    {
        BlockingEndCylinder.PawnsToIgnore[0] = m_oPawn;
        BlockingEndCylinder.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.14999998, m_oPawn.GetCollisionHeight());
    }
    CustomReachSpec = SFXCustomReachSpec(MovementPath);
    if (CustomReachSpec != None)
    {
        CustomReachSpec.BlockingPawn = m_oPawn;
    }
    EndNav = NavigationPoint(MovementPath.End.Actor);
    if (EndNav != None)
    {
        CustomReachSpec = SFXCustomReachSpec(EndNav.GetReachSpecTo(MovementPath.Start));
        if (CustomReachSpec != None)
        {
            CustomReachSpec.BlockingPawn = m_oPawn;
        }
    }
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        if (ReachSpec(m_oPawn.ReplicatedCustomActionInfo.Target) != None)
        {
            MovementPath = ReachSpec(m_oPawn.ReplicatedCustomActionInfo.Target);
        }
        Super(BioCustomAction).ClientDoCustomAction(bForced);
    }
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (MovementPath != None)
    {
        return TRUE;
    }
    else if (m_oPawn.Controller != None && m_oPawn.Controller.CurrentPath != None)
    {
        MovementPath = m_oPawn.Controller.CurrentPath;
        return TRUE;
    }
    return FALSE;
}
public function PreAlignPawnLocation()
{
    local NavigationPoint Start;
    
    Start = MovementPath.Start;
    if (Start != None)
    {
        SetReachPreciseDestination(Start.location);
    }
}
public function RemoveBlockingEndPoints()
{
    local SFXCustomReachSpec CustomReachSpec;
    local NavigationPoint EndNav;
    
    if (BlockingStartCylinder != None)
    {
        BlockingStartCylinder.Destroy();
        BlockingStartCylinder = None;
    }
    if (BlockingEndCylinder != None)
    {
        BlockingEndCylinder.Destroy();
        BlockingEndCylinder = None;
    }
    CustomReachSpec = SFXCustomReachSpec(MovementPath);
    if (CustomReachSpec != None)
    {
        CustomReachSpec.BlockingPawn = None;
    }
    EndNav = NavigationPoint(MovementPath.End.Actor);
    if (EndNav != None)
    {
        CustomReachSpec = SFXCustomReachSpec(EndNav.GetReachSpecTo(MovementPath.Start));
        if (CustomReachSpec != None)
        {
            CustomReachSpec.BlockingPawn = None;
        }
    }
}
public function Replicate()
{
    Super(BioCustomAction).Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.Target = MovementPath;
    }
}
public function StopCustomAction()
{
    local SFXNav_BlockingPathNode BlockingPathNode;
    
    if (MovementPath != None)
    {
        BlockingPathNode = SFXNav_BlockingPathNode(MovementPath.Start);
        if (BlockingPathNode != None)
        {
            BlockingPathNode.EndPathMove(m_oPawn);
        }
        RemoveBlockingEndPoints();
    }
    MovementPath = None;
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}