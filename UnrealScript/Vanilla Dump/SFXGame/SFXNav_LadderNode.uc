Class SFXNav_LadderNode extends SFXNav_BlockingPathNode
    native
    placeable;

var(SFXNav_LadderNode) NavigationPoint LadderDest;
var SFXAnimSetCookSpec AnimInfo;
var float LadderDistX;
var float MaxJumpHeight;
var(SFXNav_LadderNode) bool bTopNode;
var bool bDisabled;

public simulated function bool CanUse(Actor User)
{
    local SFXLadderReachSpec LadderSpec;
    
    if (!bBlocked)
    {
        LadderSpec = SFXLadderReachSpec(GetReachSpecTo(LadderDest, Class'SFXLadderReachSpec'));
        if (LadderSpec.BlockingPawn != None && LadderSpec.BlockingPawn != User)
        {
            return FALSE;
        }
    }
    return FALSE;
}
public simulated function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (BioWorldInfo(WorldInfo).Ladders.Find(Self) == -1)
    {
        BioWorldInfo(WorldInfo).Ladders.AddItem(Self);
    }
}
public simulated function OnUse(Actor User)
{
    local BioPawn Pawn;
    local BioPawn BlockingPawn;
    local SFXLadderReachSpec LadderSpec;
    local Vector VectToEndNode;
    local Vector CollidingTestLoc;
    local float CollisionTestRadius;
    local Vector VectToEnd2D;
    local float fDot;
    
    Pawn = BioPawn(User);
    if (Pawn != None && !bBlocked)
    {
        LadderSpec = SFXLadderReachSpec(GetReachSpecTo(LadderDest, Class'SFXLadderReachSpec'));
        if (LadderSpec.BlockingPawn == None)
        {
            VectToEndNode = LadderSpec.End.Actor.location - location;
            VectToEnd2D = VectToEndNode;
            VectToEnd2D.Z = 0.0;
            fDot = Vector(Pawn.Rotation) Dot Normal(VectToEnd2D);
            if (fDot < -0.5)
            {
                return;
            }
            CollidingTestLoc = location;
            CollisionTestRadius = Pawn.GetCollisionRadius();
            if (bTopNode)
            {
                CollidingTestLoc.X += VectToEndNode.X;
                CollidingTestLoc.Y += VectToEndNode.Y;
                CollisionTestRadius *= 3.5;
            }
            else
            {
                CollisionTestRadius *= 1.25;
            }
            foreach Pawn.CollidingActors(Class'BioPawn', BlockingPawn, CollisionTestRadius, CollidingTestLoc, TRUE, , )
            {
                if (BlockingPawn != Pawn && !BlockingPawn.IsDead())
                {
                    return;
                }
            }
            if (bTopNode)
            {
                if (location.Z - LadderSpec.End.Actor.location.Z > MaxJumpHeight)
                {
                    StartLadderCustomAction(Pawn, 47, LadderSpec);
                }
                else
                {
                    StartLadderCustomAction(Pawn, 30, LadderSpec);
                }
            }
            else
            {
                StartLadderCustomAction(Pawn, 46, LadderSpec);
            }
        }
    }
}
public simulated function StartLadderCustomAction(BioPawn User, int NewAction, ReachSpec LadderSpec)
{
    local SFXCustomAction_ReachSpecMove Action;
    
    if (User.VerifyCAHasBeenInstanced(NewAction))
    {
        Action = SFXCustomAction_ReachSpecMove(User.CustomActions[NewAction]);
    }
    if (Action != None)
    {
        Action.MovementPath = LadderSpec;
        User.StartCustomAction(NewAction);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_EX_A.HMM_EX_PistolLadder'
    End Object
    AnimInfo = tempAnimInfo
    LadderDistX = 300.0
    MaxJumpHeight = 300.0
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}