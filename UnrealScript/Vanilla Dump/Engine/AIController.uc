Class AIController extends Controller
    native;

var float Skill;
var Actor ScriptedMoveTarget;
var Route ScriptedRoute;
var int ScriptedRouteIndex;
var Actor ScriptedFocus;
var bool bAdjustFromWalls;
var bool bReverseScriptedRoute;

public function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
    return TRUE;
}
public event simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    if (Pawn != None)
    {
        out_Location = Pawn.location;
        out_rotation = Pawn.Rotation;
    }
    else
    {
        Super.GetPlayerViewPoint(out_Location, out_rotation);
    }
}
public event function PreBeginPlay()
{
    Super(Actor).PreBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    if (WorldInfo.Game != None)
    {
        Skill += WorldInfo.Game.GameDifficulty;
    }
    Skill = FClamp(Skill, 0.0, 3.0);
}
public function Reset()
{
    Super.Reset();
}
public event function SetTeam(int inTeamIdx)
{
    WorldInfo.Game.ChangeTeam(Self, inTeamIdx, TRUE);
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local int i;
    local string T;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawColor.B = 255;
        if (Pawn != None && MoveTarget != None && Pawn.ReachedDestination(MoveTarget))
        {
            Canvas.DrawText("     Skill " $ Skill $ " NAVIGATION MoveTarget " $ GetItemName(string(MoveTarget)) $ "(REACHED) MoveTimer " $ MoveTimer, FALSE);
        }
        else
        {
            Canvas.DrawText("     Skill " $ Skill $ " NAVIGATION MoveTarget " $ GetItemName(string(MoveTarget)) $ " MoveTimer " $ MoveTimer, FALSE);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("      Destination " $ GetDestinationPosition() $ " Focus " $ GetItemName(string(Focus)) $ " Preparing Move " $ bPreparingMove, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("     RouteGoal " $ GetItemName(string(RouteGoal)) $ " RouteDist " $ RouteDist, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        for (i = 0; i < RouteCache.Length; i++)
        {
            if (RouteCache[i] == None)
            {
                if (i > 5)
                {
                    T = T $ "--" $ GetItemName(string(RouteCache[i - 1]));
                }
                break;
                continue;
            }
            if (i < 5)
            {
                T = T $ GetItemName(string(RouteCache[i])) $ "-";
            }
        }
        Canvas.DrawText("     RouteCache: " $ T, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}
public function Actor GetOrderObject()
{
    return None;
}
public function Name GetOrders()
{
    return 'None';
}
public function NotifyWeaponFinishedFiring(Weapon W, byte FireMode);

public function NotifyWeaponFired(Weapon W, byte FireMode);

public function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    local Actor destActor;
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(Class'SeqAct_AIMoveToActor', TRUE, Action);
    destActor = Action.PickDestination(Pawn);
    if (destActor != None)
    {
        ScriptedRoute = Route(destActor);
        if (ScriptedRoute != None)
        {
            if (ScriptedRoute.RouteList.Length == 0)
            {
            }
            else
            {
                ScriptedRouteIndex = 0;
                if (!IsInState('ScriptedRouteMove', ))
                {
                    PushState('ScriptedRouteMove');
                }
            }
        }
        else
        {
            ScriptedMoveTarget = destActor;
            if (!IsInState('ScriptedMove', ))
            {
                PushState('ScriptedMove');
            }
        }
        ScriptedFocus = None;
        foreach Action.LinkedVariables(Class'SeqVar_Object', ObjVar, "Look At")
        {
            ScriptedFocus = Actor(ObjVar.GetObjectValue());
            if (ScriptedFocus != None)
            {
                break;
            }
        }
    }
}
public function bool PriorityObjective()
{
    return FALSE;
}
public function SetOrders(Name NewOrders, Controller OrderGiver);

public function bool ShouldRefire();


state ScriptedRouteMove 
{
    public event function PoppedState()
    {
        ClearLatentAction(Class'SeqAct_AIMoveToActor', ScriptedRoute == None);
        ScriptedRoute = None;
    }
    
Begin:
    while (Pawn != None && ScriptedRoute != None && ScriptedRouteIndex < ScriptedRoute.RouteList.Length && ScriptedRouteIndex >= 0)
    {
        ScriptedMoveTarget = ScriptedRoute.RouteList[ScriptedRouteIndex].Actor;
        if (ScriptedMoveTarget != None)
        {
            PushState('ScriptedMove');
        }
        if (Pawn != None && Pawn.ReachedDestination(ScriptedRoute.RouteList[ScriptedRouteIndex].Actor))
        {
            if (bReverseScriptedRoute)
            {
                ScriptedRouteIndex--;
            }
            else
            {
                ScriptedRouteIndex++;
            }
            continue;
        }
        ScriptedRoute = None;
        PopState();
    }
    if (Pawn != None && ScriptedRoute != None && ScriptedRoute.RouteList.Length > 0)
    {
        switch (ScriptedRoute.RouteType)
        {
            case ERouteType.ERT_Linear:
                PopState();
                break;
            case ERouteType.ERT_Loop:
                bReverseScriptedRoute = !bReverseScriptedRoute;
                if (bReverseScriptedRoute)
                {
                    ScriptedRouteIndex--;
                }
                else
                {
                    ScriptedRouteIndex++;
                }
                goto 'Begin';
                break;
            case ERouteType.ERT_Circle:
                ScriptedRouteIndex = 0;
                goto 'Begin';
                break;
            default:
                ScriptedRoute = None;
                PopState();
                break;
        }
    }
    else
    {
        ScriptedRoute = None;
        PopState();
    }
    ScriptedRoute = None;
    PopState();
    stop;
};
state ScriptedMove 
{
    public event function PushedState()
    {
        if (Pawn != None)
        {
            Pawn.SetMovementPhysics();
        }
    }
    public event function PoppedState()
    {
        if (ScriptedRoute == None)
        {
            ClearLatentAction(Class'SeqAct_AIMoveToActor', ScriptedMoveTarget == None);
        }
        ScriptedMoveTarget = None;
    }
    
Begin:
    while (Pawn != None && ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget))
    {
        if (ActorReachable(ScriptedMoveTarget))
        {
            MoveToward(ScriptedMoveTarget, ScriptedFocus, , , );
            continue;
        }
        MoveTarget = FindPathToward(ScriptedMoveTarget, , , );
        if (MoveTarget != None)
        {
            MoveToward(MoveTarget, ScriptedFocus, , , );
            continue;
        }
        ScriptedMoveTarget = None;
    }
    PopState();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAdjustFromWalls = TRUE
    MinHitWall = -0.5
    bCanDoSpecial = TRUE
}