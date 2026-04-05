Class DroppedPickup extends Actor
    native;

var repnotify Class<Inventory> InventoryClass;
var Inventory Inventory;
var NavigationPoint PickupCache;
var repnotify bool bFadeOut;

public final native function AddToNavigation();

public event function Destroyed()
{
    if (Inventory != None)
    {
        Inventory.Destroy();
    }
}
public function float DetourWeight(Pawn Other, float PathWeight)
{
    return Inventory.DetourWeight(Other, PathWeight);
}
public event function EncroachedBy(Actor Other)
{
    Destroy();
}
public event function Landed(Vector HitNormal, Actor FloorActor)
{
    bForceNetUpdate = TRUE;
    bNetDirty = TRUE;
    NetUpdateFrequency = 3.0;
    AddToNavigation();
}
public final native function RemoveFromNavigation();

public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'InventoryClass')
    {
        SetPickupMesh(InventoryClass.default.DroppedPickupMesh);
        SetPickupParticles(InventoryClass.default.DroppedPickupParticles);
    }
    else if (VarName == 'bFadeOut')
    {
        GotoState('FadeOut', , , );
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public function Reset()
{
    Destroy();
}
public event simulated function SetPickupMesh(PrimitiveComponent PickupMesh)
{
    local ActorComponent Comp;
    
    if (PickupMesh != None && WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
    {
        Comp = new (Self) PickupMesh.Class (PickupMesh);
        AttachComponent(Comp);
    }
}
public event simulated function SetPickupParticles(ParticleSystemComponent PickupParticles)
{
    local ParticleSystemComponent Comp;
    
    if (PickupParticles != None && WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
    {
        Comp = new (Self) PickupParticles.Class (PickupParticles);
        AttachComponent(Comp);
        Comp.SetActive(TRUE);
    }
}
public function PickedUpBy(Pawn P)
{
    Destroy();
}
public function GiveTo(Pawn P)
{
    if (Inventory != None)
    {
        Inventory.AnnouncePickup(P);
        Inventory.GiveTo(P);
        Inventory = None;
    }
    PickedUpBy(P);
}
public function RecheckValidTouch();


state FadeOut extends Pickup 
{
    public event simulated function BeginState(Name PreviousStateName)
    {
        bFadeOut = TRUE;
        RotationRate.Yaw = 60000;
        SetPhysics(5);
        LifeSpan = 1.0;
    }
    
    stop;
};
auto state Pickup 
{
    public event function EndState(Name NextStateName)
    {
        RemoveFromNavigation();
    }
    public event function BeginState(Name PreviousStateName)
    {
        AddToNavigation();
        SetTimer(LifeSpan - float(1), FALSE, , );
    }
    public function CheckTouching()
    {
        local Pawn P;
        
        foreach TouchingActors(Class'Pawn', P, )
        {
            Touch(P, None, location, vect(0.0, 0.0, 1.0));
        }
    }
    public event function Timer()
    {
        GotoState('FadeOut', , , );
    }
    public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn P;
        
        P = Pawn(Other);
        if (P != None && ValidTouch(P))
        {
            GiveTo(P);
        }
    }
    public function RecheckValidTouch()
    {
        CheckTouching();
    }
    public function bool ValidTouch(Pawn Other)
    {
        if (Other == None || !Other.bCanPickupInventory || Other.DrivenVehicle == None && Other.Controller == None)
        {
            return FALSE;
        }
        if (Physics == EPhysics.PHYS_Falling && Other == Instigator && Velocity.Z > float(0))
        {
            return FALSE;
        }
        if (!FastTrace(Other.location, location, , ))
        {
            SetTimer(0.5, FALSE, 'RecheckValidTouch', );
            return FALSE;
        }
        if (WorldInfo.Game.PickupQuery(Other, Inventory.Class, Self))
        {
            return TRUE;
        }
        return FALSE;
    }
    
Begin:
    CheckTouching();
    stop;
};

replication
{
    if (Role == ENetRole.ROLE_Authority)
        InventoryClass, bFadeOut;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 20.0
        CollisionRadius = 30.0
        ReplacementPrimitive = None
        CollideActors = TRUE
    End Object
    Components = (None, CollisionCylinder)
    RotationRate = {Pitch = 0, Yaw = 5000, Roll = 0}
    NetUpdateFrequency = 8.0
    NetPriority = 1.39999998
    LifeSpan = 16.0
    CollisionComponent = CollisionCylinder
    bIgnoreRigidBodyPawns = TRUE
    bOrientOnSlope = TRUE
    bUpdateSimulatedPosition = TRUE
    bOnlyDirtyReplication = TRUE
    bShouldBaseAtStartup = TRUE
    bCollideActors = TRUE
    bCollideWorld = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}