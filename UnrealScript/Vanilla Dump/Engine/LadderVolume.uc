Class LadderVolume extends PhysicsVolume
    native
    placeable;

var(LadderVolume) Rotator WallDir;
var Vector LookDir;
var Vector ClimbDir;
var const Ladder LadderList;
var Pawn PendingClimber;
var editinline export ArrowComponent WallDirArrow;
var(LadderVolume) bool bNoPhysicalLadder;
var(LadderVolume) bool bAutoPath;
var(LadderVolume) bool bAllowLadderStrafing;

public event simulated function PawnEnteredVolume(Pawn P)
{
    local Rotator PawnRot;
    
    Super.PawnEnteredVolume(P);
    if (!P.CanGrabLadder())
    {
        return;
    }
    PawnRot = P.Rotation;
    PawnRot.Pitch = 0;
    if (Vector(PawnRot) Dot LookDir > 0.899999976 || AIController(P.Controller) != None && Ladder(P.Controller.MoveTarget) != None)
    {
        P.ClimbLadder(Self);
    }
    else if (!P.bDeleteMe && P.Controller != None)
    {
        Spawn(Class'PotentialClimbWatcher', P);
    }
}
public event simulated function PawnLeavingVolume(Pawn P)
{
    local Controller C;
    
    if (P.OnLadder != Self)
    {
        return;
    }
    Super.PawnLeavingVolume(P);
    P.OnLadder = None;
    P.EndClimbLadder(Self);
    if (P == PendingClimber)
    {
        PendingClimber = None;
    }
    if (!InUse(P))
    {
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            if (C.bPreparingMove && Ladder(C.MoveTarget) != None && Ladder(C.MoveTarget).MyLadder == Self)
            {
                C.bPreparingMove = FALSE;
                PendingClimber = C.Pawn;
                return;
            }
        }
    }
}
public event simulated function PhysicsChangedFor(Actor Other)
{
    if (Other.Physics == EPhysics.PHYS_Falling || Other.Physics == EPhysics.PHYS_Ladder || Other.bDeleteMe || Pawn(Other) == None || Pawn(Other).Controller == None)
    {
        return;
    }
    Spawn(Class'PotentialClimbWatcher', Other);
}
public event simulated function PostBeginPlay()
{
    local Ladder L;
    local Ladder M;
    local Vector Dir;
    
    Super.PostBeginPlay();
    LookDir = Vector(WallDir);
    if (!bAutoPath && LookDir.Z != float(0))
    {
        ClimbDir = vect(0.0, 0.0, 1.0);
        L = LadderList;
        while (L != None)
        {
            M = LadderList;
            while (M != None)
            {
                if (M != L)
                {
                    Dir = Normal(M.location - L.location);
                    if (Dir Dot ClimbDir < float(0))
                    {
                        Dir *= float(-1);
                    }
                    ClimbDir += Dir;
                }
                M = M.LadderList;
            }
            L = L.LadderList;
        }
        ClimbDir = Normal(ClimbDir);
        if (ClimbDir Dot vect(0.0, 0.0, 1.0) < float(0))
        {
            ClimbDir *= float(-1);
        }
    }
}
public function bool InUse(Pawn Ignored)
{
    local Pawn StillClimbing;
    
    foreach TouchingActors(Class'Pawn', StillClimbing, )
    {
        if (StillClimbing != Ignored && StillClimbing.bCollideActors && StillClimbing.bBlockActors)
        {
            return TRUE;
        }
    }
    if (PendingClimber != None)
    {
        if (PendingClimber.Controller == None || !PendingClimber.bCollideActors || !PendingClimber.bBlockActors || Ladder(PendingClimber.Controller.MoveTarget) == None || Ladder(PendingClimber.Controller.MoveTarget).MyLadder != Self)
        {
            PendingClimber = None;
        }
    }
    return PendingClimber != None && PendingClimber != Ignored;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    ClimbDir = {X = 0.0, Y = 0.0, Z = 1.0}
    bAutoPath = TRUE
    bAllowLadderStrafing = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0, None)
    CollisionComponent = BrushComponent0
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}