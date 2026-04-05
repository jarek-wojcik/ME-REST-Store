Class CheatManager within PlayerController
    native;

var Class<DebugCameraController> DebugCameraControllerClass;
var DebugCameraController DebugCameraControllerRef;

public exec function Avatar(Name className)
{
    local Pawn P;
    local Pawn TargetPawn;
    local Pawn FirstPawn;
    local Pawn OldPawn;
    local bool bPickNextPawn;
    
    foreach Outer.DynamicActors(Class'Pawn', P, )
    {
        if (P == Outer.Pawn)
        {
            bPickNextPawn = TRUE;
        }
        else if (P.IsA(className))
        {
            if (FirstPawn == None)
            {
                FirstPawn = P;
            }
            if (bPickNextPawn)
            {
                TargetPawn = P;
                break;
            }
        }
    }
    if (TargetPawn == None)
    {
        TargetPawn = FirstPawn;
    }
    if (TargetPawn != None)
    {
        TargetPawn.DetachFromController(TRUE);
        if (Outer.Pawn != None)
        {
            OldPawn = Outer.Pawn;
            Outer.Pawn.DetachFromController();
        }
        Outer.Possess(TargetPawn, FALSE);
        if (OldPawn != None)
        {
            OldPawn.SpawnDefaultController();
        }
    }
}
public exec native function LogParticleActivateSystemCalls(bool bShouldLog);

public exec native function LogPlaySoundCalls(bool bShouldLog);

public exec native function VerifyNavMeshObjects();

public exec function AffectedByHitEffects()
{
    if (Outer.bAffectedByHitEffects)
    {
        Outer.bAffectedByHitEffects = FALSE;
        Outer.ClientMessage("EffectsAffect mode off");
        return;
    }
    Outer.bAffectedByHitEffects = TRUE;
    Outer.ClientMessage("EffectsAffect Mode on");
}
public exec function AllAmmo();

public exec function AllWeapons();

public exec function Amphibious()
{
    Outer.Pawn.UnderWaterTime = 999999.0;
}
public exec function ChangeSize(float F)
{
    Outer.Pawn.CylinderComponent.SetCylinderSize(Outer.Pawn.default.CylinderComponent.CollisionRadius * F, Outer.Pawn.default.CylinderComponent.CollisionHeight * F);
    Outer.Pawn.SetDrawScale(F);
    Outer.Pawn.SetLocation(Outer.Pawn.location, );
}
public exec function DebugAI(optional coerce Name Category);

public exec function DebugPause()
{
    Outer.WorldInfo.Game.DebugPause();
}
public exec function DestroyFractures(optional float Radius)
{
    local FracturedStaticMeshActor FracActor;
    
    if (Radius == 0.0)
    {
        Radius = 256.0;
    }
    foreach Outer.CollidingActors(Class'FracturedStaticMeshActor', FracActor, Radius, Outer.Pawn.location, TRUE, , )
    {
        if (FracActor.Physics == EPhysics.PHYS_None)
        {
            FracActor.BreakOffPartsInRadius(Outer.Pawn.location, Radius, 500.0, TRUE);
        }
    }
}
public exec function DumpOnlineSessionState();

public exec function DumpVoiceMutingState();

public function EnableDebugCamera()
{
    local Player P;
    local Vector eyeLoc;
    local Rotator eyeRot;
    
    P = Outer.Player;
    if (P != None && Outer.Pawn != None && Outer.IsLocalPlayerController())
    {
        if (DebugCameraControllerRef == None)
        {
            DebugCameraControllerRef = Outer.Spawn(DebugCameraControllerClass);
        }
        DebugCameraControllerRef.OryginalPlayer = P;
        DebugCameraControllerRef.OryginalControllerRef = Outer;
        Outer.GetPlayerViewPoint(eyeLoc, eyeRot);
        DebugCameraControllerRef.SetLocation(eyeLoc, );
        DebugCameraControllerRef.SetRotation(eyeRot);
        DebugCameraControllerRef.PlayerCamera.SetFOV(Outer.GetFOVAngle());
        DebugCameraControllerRef.PlayerCamera.UpdateCamera(0.0);
        P.SwitchController(DebugCameraControllerRef);
        DebugCameraControllerRef.OnActivate(Outer);
    }
}
public exec function EndPath();

public exec function Fly()
{
    if (Outer.Pawn != None && Outer.Pawn.CheatFly())
    {
        Outer.ClientMessage("You feel much lighter");
        Outer.bCheatFlying = TRUE;
        Outer.GotoState('PlayerFlying', , , );
    }
}
public exec function FractureAllMeshes()
{
    local FracturedStaticMeshActor FracActor;
    
    foreach Outer.AllActors(Class'FracturedStaticMeshActor', FracActor, )
    {
        FracActor.HideOneFragment();
    }
}
public exec function FractureAllMeshesToMaximizeMemoryUsage()
{
    local FracturedStaticMeshActor FracActor;
    
    foreach Outer.AllActors(Class'FracturedStaticMeshActor', FracActor, )
    {
        FracActor.HideFragmentsToMaximizeMemoryUsage();
    }
}
public exec function FreezeFrame(float Delay)
{
    Outer.WorldInfo.Game.SetPause(Outer, Outer.CanUnpause);
    Outer.WorldInfo.PauseDelay = Outer.WorldInfo.TimeSeconds + Delay;
}
public exec function Ghost()
{
    local BioRemoteLogger GLogger;
    
    if (Outer.Pawn != None && Outer.Pawn.CheatGhost())
    {
        Outer.bCheatFlying = TRUE;
        Outer.GotoState('PlayerFlying', , , );
    }
    else
    {
        Outer.bCollideWorld = FALSE;
    }
    Outer.ClientMessage("You feel ethereal");
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("Ghost");
    }
}
public exec function Weapon GiveWeapon(string WeaponClassStr)
{
    local Weapon Weap;
    local Class<Weapon> WeaponClass;
    
    WeaponClass = Class<Weapon>(DynamicLoadObject(WeaponClassStr, Class'Class'));
    Weap = Weapon(Outer.Pawn.FindInventoryType(WeaponClass));
    if (Weap != None)
    {
        return Weap;
    }
    return Weapon(Outer.Pawn.CreateInventory(WeaponClass));
}
public exec function God()
{
    local BioRemoteLogger GLogger;
    
    if (Outer.bGodMode)
    {
        Outer.bGodMode = FALSE;
        Outer.ClientMessage("God mode off");
        return;
    }
    Outer.bGodMode = TRUE;
    Outer.ClientMessage("God Mode on");
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("God");
    }
}
public function InitCheatManager();

public exec function KillAll(Class<Actor> aClass)
{
    local Actor A;
    
    if (ClassIsChildOf(aClass, Class'AIController'))
    {
        Outer.WorldInfo.Game.KillBots();
        return;
    }
    if (ClassIsChildOf(aClass, Class'Pawn'))
    {
        KillAllPawns(Class<Pawn>(aClass));
        return;
    }
    foreach Outer.DynamicActors(Class'Actor', A, )
    {
        if (ClassIsChildOf(A.Class, aClass))
        {
            A.Destroy();
        }
    }
}
public function KillAllPawns(Class<Pawn> aClass)
{
    local Pawn P;
    
    Outer.WorldInfo.Game.KillBots();
    foreach Outer.DynamicActors(Class'Pawn', P, )
    {
        if (ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
        {
            if (P.Controller != None)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }
    }
}
public exec function KillPawns()
{
    KillAllPawns(Class'Pawn');
}
public exec function KillViewedActor()
{
    if (Outer.ViewTarget != None)
    {
        if (Pawn(Outer.ViewTarget) != None && Pawn(Outer.ViewTarget).Controller != None)
        {
            Pawn(Outer.ViewTarget).Controller.Destroy();
        }
        Outer.ViewTarget.Destroy();
        Outer.SetViewTarget(None);
    }
}
public exec function ListDynamicActors();

public exec function Loaded()
{
    if (Outer.WorldInfo.NetMode != ENetMode.NM_Standalone)
    {
        return;
    }
    AllWeapons();
    AllAmmo();
}
public exec function NavMeshVerification(optional float Interval = 0.5)
{
    if (Interval < float(0))
    {
        Outer.ClearTimer('VerifyNavMeshObjects', Outer);
    }
    else
    {
        Outer.SetTimer(Interval, TRUE, 'VerifyNavMeshObjects', Outer);
    }
}
public exec function PlayersOnly()
{
    if (Outer.WorldInfo.bPlayersOnly || Outer.WorldInfo.bPlayersOnlyPending)
    {
        Outer.WorldInfo.bPlayersOnly = FALSE;
        Outer.WorldInfo.bPlayersOnlyPending = FALSE;
    }
    else
    {
        Outer.WorldInfo.bPlayersOnlyPending = !Outer.WorldInfo.bPlayersOnlyPending;
    }
}
public exec function RememberSpot()
{
    if (Outer.Pawn != None)
    {
        Outer.SetDestinationPosition(Outer.Pawn.location);
    }
    else
    {
        Outer.SetDestinationPosition(Outer.location);
    }
}
public exec function SetGravity(float F)
{
    Outer.WorldInfo.WorldGravityZ = F;
}
public exec function SetJumpZ(float F)
{
    Outer.Pawn.JumpZ = F;
}
public exec function SetMass(float F)
{
    Outer.Pawn.Mass = F;
    Outer.ClientMessage("Changed Vehicle Mass!");
}
public exec function SetOnlineDebugLevel(int DebugLevel)
{
    if (Outer.OnlineSub != None)
    {
        Outer.OnlineSub.SetDebugSpewLevel(DebugLevel);
    }
}
public exec function SetSpeed(float F)
{
    Outer.Pawn.GroundSpeed = Outer.Pawn.default.GroundSpeed * F;
    Outer.Pawn.WaterSpeed = Outer.Pawn.default.WaterSpeed * F;
}
public exec function Slomo(float T)
{
    Outer.WorldInfo.Game.SetGameSpeed(T);
}
public exec function Summon(string className)
{
    local Class<Actor> NewClass;
    local Vector SpawnLoc;
    
    NewClass = Class<Actor>(DynamicLoadObject(className, Class'Class'));
    if (NewClass != None)
    {
        if (Outer.Pawn != None)
        {
            SpawnLoc = Outer.Pawn.location;
        }
        else
        {
            SpawnLoc = Outer.location;
        }
        Outer.Spawn(NewClass, , , SpawnLoc + float(72) * Vector(Outer.Rotation) + vect(0.0, 0.0, 1.0) * float(15));
    }
}
public exec function Teleport()
{
    local Actor HitActor;
    local Vector HitNormal;
    local Vector HitLocation;
    local Vector ViewLocation;
    local Rotator ViewRotation;
    
    Outer.GetPlayerViewPoint(ViewLocation, ViewRotation);
    HitActor = Outer.Trace(HitLocation, HitNormal, ViewLocation + float(1000000) * Vector(ViewRotation), ViewLocation, TRUE, , , );
    if (HitActor != None)
    {
        HitLocation += HitNormal * 4.0;
    }
    Outer.ViewTarget.SetLocation(HitLocation, );
}
public exec function TestLevel()
{
    local Actor A;
    local Actor Found;
    local bool bFoundErrors;
    
    foreach Outer.AllActors(Class'Actor', A, )
    {
        bFoundErrors = bFoundErrors || A.CheckForErrors();
        if (bFoundErrors && Found == None)
        {
            Found = A;
        }
    }
    if (bFoundErrors)
    {
        assert(FALSE);
    }
}
public exec function TestNavMeshPath(optional bool bDrawPath = TRUE)
{
    local Actor HitActor;
    local Vector HitLoc;
    local Vector HitNorm;
    local Vector Start;
    local Vector End;
    local Rotator Rot;
    
    if (Outer.NavigationHandle == None)
    {
        Outer.NavigationHandle = new (Outer) Class'NavigationHandle';
    }
    Outer.GetPlayerViewPoint(Start, Rot);
    End = Start + Vector(Rot) * float(10000);
    HitActor = Outer.Trace(HitLoc, HitNorm, End, Start, FALSE, , , );
    if (HitActor != None)
    {
        Class'NavMeshPath_Toward'.static.TowardPoint(Outer.NavigationHandle, HitLoc);
        Class'NavMeshGoal_At'.static.AtLocation(Outer.NavigationHandle, HitLoc);
        Outer.NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
        if (Outer.NavigationHandle.FindPath())
        {
            Outer.DrawDebugLine(HitLoc, Start, 0, 255, 0, TRUE);
            Outer.DrawDebugCoordinateSystem(HitLoc, rot(0, 0, 0), 25.0, TRUE);
            if (bDrawPath)
            {
                Outer.NavigationHandle.DrawPathCache(, TRUE);
            }
        }
        else
        {
            Outer.DrawDebugLine(HitLoc, Start, 255, 0, 0, TRUE);
            Outer.DrawDebugCoordinateSystem(HitLoc, rot(0, 0, 0), 25.0, TRUE);
            Outer.DrawDebugBox(Outer.Pawn.location, Outer.Pawn.GetCollisionExtent(), 255, 0, 0, TRUE);
        }
    }
}
public exec function ToggleDebugCamera()
{
    local PlayerController PC;
    local DebugCameraController DCC;
    
    foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (PC.bIsPlayer && PC.IsLocalPlayerController())
        {
            DCC = DebugCameraController(PC);
            if (DCC != None && DCC.OryginalControllerRef == None)
            {
                continue;
            }
            break;
        }
    }
    if (DCC != None && DCC.OryginalControllerRef != None)
    {
        DCC.DisableDebugCamera();
    }
    else if (PC != None)
    {
        EnableDebugCamera();
    }
}
public exec function VerbosePathDebug()
{
    local Vector HitLoc;
    local Vector HitNorm;
    local Vector Start;
    local Vector End;
    local Rotator Rot;
    local Pawn P;
    
    Outer.GetPlayerViewPoint(Start, Rot);
    End = Start + Vector(Rot) * float(10000);
    foreach Outer.TraceActors(Class'Pawn', P, HitLoc, HitNorm, End, Start, vect(1.0, 1.0, 1.0), , )
    {
        Outer.Pawn.MessagePlayer("Verbosepathdebug trace hit" @ P);
        if (P != None && P.Controller != None)
        {
            P.Controller.NavigationHandle.bUltraVerbosePathDebugging = !P.Controller.NavigationHandle.bUltraVerbosePathDebugging;
        }
    }
}
public exec function ViewActor(Name actorName)
{
    local Actor A;
    
    foreach Outer.AllActors(Class'Actor', A, )
    {
        if (A.Name == actorName)
        {
            Outer.SetViewTarget(A);
            Outer.SetCameraMode('ThirdPerson');
            return;
        }
    }
}
public exec function ViewBot()
{
    local Actor first;
    local bool bFound;
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        if (C.Pawn != None && C.PlayerReplicationInfo != None)
        {
            if (bFound || first == None)
            {
                first = C;
                if (bFound)
                {
                    break;
                }
            }
            if (C.PlayerReplicationInfo == Outer.RealViewTarget)
            {
                bFound = TRUE;
            }
        }
    }
    if (first != None)
    {
        Outer.SetViewTarget(first);
        Outer.SetCameraMode('ThirdPerson');
        Outer.FixFOV();
    }
    else
    {
        ViewSelf(TRUE);
    }
}
public exec function ViewClass(Class<Actor> aClass)
{
    local Actor Other;
    local Actor first;
    local bool bFound;
    
    first = None;
    foreach Outer.AllActors(aClass, Other, )
    {
        if (bFound || first == None)
        {
            first = Other;
            if (bFound)
            {
                break;
            }
        }
        if (Other == Outer.ViewTarget)
        {
            bFound = TRUE;
        }
    }
    if (first != None)
    {
        if (Pawn(first) != None)
        {
            Outer.ClientMessage(Outer.ViewingFrom @ first.GetHumanReadableName(), 'Event');
        }
        else
        {
            Outer.ClientMessage(Outer.ViewingFrom @ first, 'Event');
        }
        Outer.SetViewTarget(first);
        Outer.FixFOV();
    }
    else
    {
        ViewSelf(FALSE);
    }
}
public exec function ViewFlag()
{
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.bHasFlag)
        {
            Outer.SetViewTarget(C.Pawn);
            return;
        }
    }
}
public exec function ViewPlayer(string S)
{
    local Controller P;
    
    foreach Outer.WorldInfo.AllControllers(Class'Controller', P)
    {
        if (P.bIsPlayer && P.PlayerReplicationInfo.PlayerName ~= S)
        {
            break;
        }
    }
    if (P.Pawn != None)
    {
        Outer.ClientMessage(Outer.ViewingFrom @ P.PlayerReplicationInfo.PlayerName, 'Event');
        Outer.SetViewTarget(P.Pawn);
    }
}
public exec function ViewSelf(optional bool bQuiet)
{
    Outer.ResetCameraMode();
    if (Outer.Pawn != None)
    {
        Outer.SetViewTarget(Outer.Pawn);
    }
    else
    {
        Outer.SetViewTarget(Outer);
    }
    if (!bQuiet)
    {
        Outer.ClientMessage(Outer.OwnCamera, 'Event');
    }
    Outer.FixFOV();
}
public exec function Walk()
{
    Outer.bCheatFlying = FALSE;
    if (Outer.Pawn != None && Outer.Pawn.CheatWalk())
    {
        Outer.Restart(FALSE);
    }
}
public exec function WriteToLog(string Param)
{
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DebugCameraControllerClass = Class'DebugCameraController'
}