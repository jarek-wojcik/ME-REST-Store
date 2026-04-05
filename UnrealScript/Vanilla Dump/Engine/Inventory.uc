Class Inventory extends Actor
    native
    nativereplication
    abstract;

var const localized databinding string ItemName;
var(Inventory) const localized databinding string PickupMessage;
var(Inventory) string PickupForce;
var Class<DroppedPickup> DroppedPickupClass;
var Inventory Inventory;
var InventoryManager InvManager;
var(Inventory) float RespawnTime;
var float MaxDesireability;
var(Inventory) SoundCue PickupSound;
var editinline export PrimitiveComponent DroppedPickupMesh;
var editinline export PrimitiveComponent PickupFactoryMesh;
var editinline export ParticleSystemComponent DroppedPickupParticles;
var bool bRenderOverlays;
var bool bReceiveOwnerEvents;
var bool bDropOnDeath;
var bool bDelayedSpawn;
var bool bPredictRespawns;

public static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
    local Inventory AlreadyHas;
    local float desire;
    
    desire = default.MaxDesireability;
    if (default.RespawnTime < float(10))
    {
        AlreadyHas = P.FindInventoryType(default.Class);
        if (AlreadyHas != None)
        {
            return -1.0;
        }
    }
    return desire;
}
public event function Destroyed()
{
    if (Pawn(Owner) != None && Pawn(Owner).InvManager != None)
    {
        Pawn(Owner).InvManager.RemoveFromInventory(Self);
    }
}
public static function float DetourWeight(Pawn Other, float PathWeight)
{
    return 0.0;
}
public simulated function string GetHumanReadableName()
{
    return default.ItemName;
}
public static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
}
public simulated function ActiveRenderOverlays(HUD H);

public function AnnouncePickup(Pawn Other)
{
    Other.HandlePickup(Self);
    if (PickupSound != None)
    {
        Other.PlaySound(PickupSound);
    }
}
public reliable client function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    SetOwner(NewOwner);
    Instigator = NewOwner;
    if (NewOwner != None && NewOwner.Controller != None)
    {
        NewOwner.Controller.NotifyAddInventory(Self);
    }
}
public function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
    if (ItemClass == Class)
    {
        return TRUE;
    }
    return FALSE;
}
public function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local DroppedPickup P;
    
    if (Instigator != None && Instigator.InvManager != None)
    {
        Instigator.InvManager.RemoveFromInventory(Self);
    }
    if (DroppedPickupClass == None || DroppedPickupMesh == None)
    {
        Destroy();
        return;
    }
    P = Spawn(DroppedPickupClass, , , StartLocation);
    if (P == None)
    {
        Destroy();
        return;
    }
    P.SetPhysics(2);
    P.Inventory = Self;
    P.InventoryClass = Class;
    P.Velocity = StartVelocity;
    P.Instigator = Instigator;
    P.SetPickupMesh(DroppedPickupMesh);
    P.SetPickupParticles(DroppedPickupParticles);
    Instigator = None;
    GotoState('None', , , );
}
public function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    Instigator = thisPawn;
    ClientGivenTo(thisPawn, bDoNotActivate);
}
public final function GiveTo(Pawn Other)
{
    if (Other != None && Other.InvManager != None)
    {
        Other.InvManager.AddInventory(Self);
    }
}
public function ItemRemovedFromInvManager();

public function OwnerEvent(Name EventName);

public simulated function RenderOverlays(HUD H);


//Replication conditions for this class are native. This block has no effect
replication
{
    if (Role == ENetRole.ROLE_Authority && bNetDirty)
        Inventory, InvManager;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PickupMessage = "Snagged an item."
    DroppedPickupClass = Class'DroppedPickup'
    MaxDesireability = 0.100000001
    Components = (None)
    NetPriority = 1.39999998
    bHidden = TRUE
    bAlwaysRelevant = TRUE
    bReplicateMovement = FALSE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}