Class Teleporter extends NavigationPoint
    native
    abstract;

var(Teleporter) string URL;
var(Teleporter) Vector TargetVelocity;
var(Teleporter) Name ProductRequired;
var float LastFired;
var(Teleporter) bool bChangesVelocity;
var(Teleporter) bool bChangesYaw;
var(Teleporter) bool bReversesX;
var(Teleporter) bool bReversesY;
var(Teleporter) bool bReversesZ;
var(Teleporter) bool bEnabled;
var(Teleporter) bool bCanTeleportVehicles;

public event simulated function bool Accept(Actor Incoming, Actor Source)
{
    local Rotator NewRot;
    local Rotator oldRot;
    local float Mag;
    local Vector oldDir;
    local Controller C;
    
    if (Incoming == None)
    {
        return FALSE;
    }
    NewRot = Incoming.Rotation;
    if (bChangesYaw)
    {
        oldRot = Incoming.Rotation;
        NewRot.Yaw = Rotation.Yaw;
        if (Source != None)
        {
            NewRot.Yaw += 32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw;
        }
    }
    if (Pawn(Incoming) != None)
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            foreach WorldInfo.AllControllers(Class'Controller', C)
            {
                if (C.Enemy == Incoming)
                {
                    C.EnemyJustTeleported();
                }
            }
        }
        if (!Pawn(Incoming).SetLocation(location, ))
        {
            return FALSE;
        }
        if (Role == ENetRole.ROLE_Authority || WorldInfo.TimeSeconds - LastFired > 0.5)
        {
            NewRot.Roll = 0;
            Pawn(Incoming).SetRotation(NewRot);
            Pawn(Incoming).SetViewRotation(NewRot);
            Pawn(Incoming).ClientSetRotation(NewRot);
            LastFired = WorldInfo.TimeSeconds;
        }
        if (Pawn(Incoming).Controller != None)
        {
            Pawn(Incoming).Controller.MoveTimer = -1.0;
            Pawn(Incoming).SetAnchor(Self);
            Pawn(Incoming).SetMoveTarget(Self);
        }
        Incoming.PlayTeleportEffect(FALSE, TRUE);
    }
    else
    {
        if (!Incoming.SetLocation(location, ))
        {
            return FALSE;
        }
        if (bChangesYaw)
        {
            Incoming.SetRotation(NewRot);
        }
    }
    if (bChangesVelocity)
    {
        Incoming.Velocity = TargetVelocity;
    }
    else
    {
        if (bChangesYaw)
        {
            if (Incoming.Physics == EPhysics.PHYS_Walking)
            {
                oldRot.Pitch = 0;
            }
            oldDir = Vector(oldRot);
            Mag = Incoming.Velocity Dot oldDir;
            Incoming.Velocity = Incoming.Velocity - Mag * oldDir + Mag * Vector(Incoming.Rotation);
        }
        if (bReversesX)
        {
            Incoming.Velocity.X *= -1.0;
        }
        if (bReversesY)
        {
            Incoming.Velocity.Y *= -1.0;
        }
        if (bReversesZ)
        {
            Incoming.Velocity.Z *= -1.0;
        }
    }
    Incoming.PostTeleport(Self);
    return TRUE;
}
public native function bool CanTeleport(Actor A);

public event function PostBeginPlay()
{
    if (URL ~= "")
    {
        SetCollision(FALSE, FALSE, );
    }
    Super(Actor).PostBeginPlay();
}
public event simulated function PostTouch(Actor Other)
{
    local Teleporter D;
    local Teleporter Dest[16];
    local int i;
    
    if (InStr(URL, "/", , , ) >= 0 || InStr(URL, "#", , , ) >= 0)
    {
        if (Role == ENetRole.ROLE_Authority && Pawn(Other) != None && Pawn(Other).IsHumanControlled())
        {
            WorldInfo.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
        }
    }
    else
    {
        foreach AllActors(Class'Teleporter', D, )
        {
            if (string(D.Tag) ~= URL && D != Self)
            {
                Dest[i] = D;
                i++;
                if (i > 16)
                {
                    break;
                }
            }
        }
        i = Rand(i);
        if (Dest[i] != None)
        {
            if (Other.IsA('Pawn'))
            {
                Other.PlayTeleportEffect(TRUE, TRUE);
            }
            Dest[i].Accept(Other, Self);
        }
    }
}
public event function Actor SpecialHandling(Pawn Other)
{
    if (bEnabled && Other.Controller.RouteCache.Length > 1 && Teleporter(Other.Controller.RouteCache[1]) != None && string(Other.Controller.RouteCache[1].Tag) ~= URL)
    {
        if (IsOverlapping(Other))
        {
            PostTouch(Other);
        }
        return Self;
    }
    return None;
}
public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (!bEnabled || Other == None)
    {
        return;
    }
    if (CanTeleport(Other) && !Other.PreTeleport(Self))
    {
        PendingTouch = Other.PendingTouch;
        Other.PendingTouch = Self;
    }
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        URL, bEnabled;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        TargetVelocity, bChangesVelocity, bChangesYaw, bReversesX, bReversesY, bReversesZ;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 80.0
        CollisionRadius = 40.0
        ReplacementPrimitive = None
        CollideActors = TRUE
    End Template
    bChangesYaw = TRUE
    bEnabled = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bCollideActors = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}