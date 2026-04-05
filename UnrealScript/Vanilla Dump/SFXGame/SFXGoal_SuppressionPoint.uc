Class SFXGoal_SuppressionPoint extends PathGoalEvaluator
    native;

var Vector TargetFacing;
var transient NavigationPoint TargetNav;
var transient SFXAI_NativeBase AI;
var float DesiredDistance;
var float MinDistance;
var NavigationPoint BestNode;
var int BestRating;
var int MaxNodes;
var transient int NumNodesTested;
var bool bFlank;

public event function Recycle()
{
    Super.Recycle();
    TargetNav = None;
    DesiredDistance = 0.0;
    MinDistance = 0.0;
    AI = None;
    NumNodesTested = 0;
    BestNode = None;
    BestRating = 0;
}
public static function bool SuppressPoint(Pawn P, Actor Target, float SuppressDist, optional bool bPreferFlank, optional float fMinDistance)
{
    local SFXGoal_SuppressionPoint Eval;
    local float Dist;
    local NavigationPoint Nav;
    local Pawn TargetPawn;
    
    if (P == None || SFXAI_NativeBase(P.Controller) == None)
    {
        return FALSE;
    }
    TargetPawn = Pawn(Target);
    if (TargetPawn != None)
    {
        if (TargetPawn.ValidAnchor())
        {
            Nav = TargetPawn.Anchor;
        }
        if (Nav == None)
        {
            Nav = TargetPawn.GetBestAnchor(Target, Target.location, FALSE, TRUE, Dist);
        }
    }
    else
    {
        Nav = NavigationPoint(Target);
    }
    if (Nav != None)
    {
        Eval = SFXGoal_SuppressionPoint(P.CreatePathGoalEvaluator(default.Class));
        if (Eval != None)
        {
            Eval.AI = SFXAI_NativeBase(P.Controller);
            Eval.TargetNav = Nav;
            Eval.DesiredDistance = SuppressDist;
            Eval.MinDistance = fMinDistance;
            if (TargetPawn != None)
            {
                Eval.bFlank = bPreferFlank;
                Eval.TargetFacing = Vector(TargetPawn.Rotation);
            }
            else
            {
                Eval.bFlank = FALSE;
            }
            Eval.BestRating = 10000000;
            P.AddGoalEvaluator(Eval);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxNodes = 300
    CacheIdx = 3
}