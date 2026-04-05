Class InventoryManager extends Actor
    native;

var array<int> PendingFire;
var Inventory InventoryChain;
var Weapon PendingWeapon;
var Weapon LastAttemptedSwitchToWeapon;
var bool bMustHoldWeapon;

public simulated function Inventory CreateInventory(Class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local Inventory Inv;
    
    if (NewInventoryItemClass != None)
    {
        Inv = Spawn(NewInventoryItemClass, Owner);
        if (Inv != None)
        {
            if (!AddInventory(Inv, bDoNotActivate))
            {
                Inv.Destroy();
                Inv = None;
            }
        }
    }
    return Inv;
}
public event function Destroyed()
{
    DiscardInventory();
}
public event simulated function DiscardInventory()
{
    local Inventory Inv;
    local Vector TossVelocity;
    local bool bBelowKillZ;
    
    bBelowKillZ = Instigator == None || Instigator.location.Z < WorldInfo.KillZ;
    foreach InventoryActors(Class'Inventory', Inv)
    {
        if (Inv.bDropOnDeath && !bBelowKillZ)
        {
            TossVelocity = Vector(Instigator.GetViewRotation());
            TossVelocity = TossVelocity * (Instigator.Velocity Dot TossVelocity + 500.0) + 250.0 * VRand() + vect(0.0, 0.0, 250.0);
            Inv.DropFrom(Instigator.location, TossVelocity);
        }
        else
        {
            Inv.Destroy();
        }
    }
    Instigator.Weapon = None;
    PendingWeapon = None;
}
public event simulated function Inventory FindInventoryType(Class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    local Inventory Inv;
    
    foreach InventoryActors(DesiredClass, Inv)
    {
        if (bAllowSubclass || Inv.Class == DesiredClass)
        {
            return Inv;
        }
    }
    return None;
}
public final iterator native function InventoryActors(Class<Inventory> BaseClass, out Inventory Inv);

public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    Instigator = Pawn(Owner);
}
public simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local Inventory Item;
    local Inventory LastItem;
    
    if (NewItem != None && !NewItem.bDeleteMe)
    {
        if (InventoryChain == None)
        {
            InventoryChain = NewItem;
        }
        else
        {
            Item = InventoryChain;
            while (Item != None)
            {
                if (Item == NewItem)
                {
                    return FALSE;
                }
                LastItem = Item;
                Item = Item.Inventory;
            }
            LastItem.Inventory = NewItem;
        }
        NewItem.SetOwner(Instigator);
        NewItem.Instigator = Instigator;
        NewItem.InvManager = Self;
        NewItem.GivenTo(Instigator, bDoNotActivate);
        Instigator.TriggerEventClass(Class'SeqEvent_GetInventory', NewItem);
        return TRUE;
    }
    return FALSE;
}
public simulated function bool CancelWeaponChange()
{
    if (PendingWeapon == None && bMustHoldWeapon)
    {
        PendingWeapon = Instigator.Weapon;
    }
    return FALSE;
}
public simulated function ChangedWeapon()
{
    local Weapon OldWeapon;
    
    OldWeapon = Instigator.Weapon;
    if (PendingWeapon == None && bMustHoldWeapon)
    {
        if (OldWeapon != None)
        {
            OldWeapon.Activate();
            PendingWeapon = OldWeapon;
        }
    }
    Instigator.Weapon = PendingWeapon;
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, PendingWeapon);
    if (PendingWeapon != None)
    {
        PendingWeapon.Instigator = Instigator;
        if (WorldInfo.Game != None)
        {
            Instigator.MakeNoise(0.100000001, 'ChangedWeapon');
        }
        PendingWeapon.Activate();
        PendingWeapon = None;
    }
    if (Instigator.Controller != None)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
}
public simulated function ClearAllPendingFire(Weapon InWeapon)
{
    local int i;
    
    for (i = 0; i < PendingFire.Length; i++)
    {
        PendingFire[i] = 0;
    }
}
public simulated function ClearPendingFire(Weapon InWeapon, int InFiringMode)
{
    if (InFiringMode < PendingFire.Length)
    {
        PendingFire[InFiringMode] = 0;
    }
}
public reliable client function ClientSyncWeapon(Weapon NewWeapon)
{
    local Weapon OldWeapon;
    
    if (NewWeapon == Instigator.Weapon)
    {
        return;
    }
    OldWeapon = Instigator.Weapon;
    Instigator.Weapon = NewWeapon;
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, NewWeapon);
    if (NewWeapon != None)
    {
        Instigator.Weapon.Instigator = Instigator;
        if (WorldInfo.Game != None)
        {
            Instigator.MakeNoise(0.100000001, 'ChangedWeapon');
        }
        Instigator.Weapon.Activate();
    }
    if (Instigator.Controller != None)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
}
public simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
    local Weapon OldWeapon;
    
    if (!bDoNotActivate)
    {
        OldWeapon = Instigator.Weapon;
        if (OldWeapon == None || OldWeapon.bDeleteMe || OldWeapon.IsInState('Inactive', ))
        {
            SetCurrentWeapon(NewWeapon);
            return;
        }
        if (OldWeapon == NewWeapon)
        {
            if (NewWeapon.IsInState('PendingClientWeaponSet', ))
            {
                SetCurrentWeapon(NewWeapon);
            }
            return;
        }
        if (bOptionalSet)
        {
            if (OldWeapon.DenyClientWeaponSet() || Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
            {
                LastAttemptedSwitchToWeapon = NewWeapon;
                return;
            }
        }
        if (PendingWeapon == None || !PendingWeapon.HasAnyAmmo() || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            if (!Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
            {
                SetCurrentWeapon(NewWeapon);
                return;
            }
        }
    }
    NewWeapon.GotoState('Inactive', , , );
}
public simulated function DrawHUD(HUD H)
{
    local Inventory Inv;
    
    foreach InventoryActors(Class'Inventory', Inv)
    {
        if (Inv.bRenderOverlays)
        {
            Inv.RenderOverlays(H);
        }
    }
    if (Instigator.Weapon != None)
    {
        Instigator.Weapon.ActiveRenderOverlays(H);
    }
}
public simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W;
    local Weapon BestWeapon;
    local float Rating;
    local float BestRating;
    
    foreach InventoryActors(Class'Weapon', W)
    {
        if (W.HasAnyAmmo())
        {
            if (bForceADifferentWeapon && IsActiveWeapon(W))
            {
                continue;
            }
            Rating = W.GetWeaponRating();
            if (BestWeapon == None || Rating > BestRating)
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }
    }
    return BestWeapon;
}
public simulated function int GetPendingFireLength(Weapon InWeapon)
{
    return PendingFire.Length;
}
public simulated function float GetWeaponRatingFor(Weapon W)
{
    local float Rating;
    
    if (!W.HasAnyAmmo())
    {
        return -1.0;
    }
    if (!Instigator.IsHumanControlled())
    {
        Rating = W.GetAIRating();
        if (IsActiveWeapon(W) && Instigator.Controller != None && Instigator.Controller.Enemy != None)
        {
            Rating += 0.209999993;
        }
    }
    else
    {
        Rating = 1.0;
    }
    return Rating;
}
public function bool HandlePickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
    local Inventory Inv;
    
    if (InventoryChain == None)
    {
        return TRUE;
    }
    foreach InventoryActors(Class'Inventory', Inv)
    {
        if (Inv.DenyPickupQuery(ItemClass, Pickup))
        {
            return FALSE;
        }
    }
    return TRUE;
}
protected simulated function InternalSetCurrentWeapon(Weapon DesiredWeapon)
{
    local Weapon PrevWeapon;
    
    PrevWeapon = Instigator.Weapon;
    if (PrevWeapon != None && DesiredWeapon == PrevWeapon && !PrevWeapon.IsInState('WeaponPuttingDown', ))
    {
        if (!DesiredWeapon.IsInState('Inactive', ) && !DesiredWeapon.IsInState('PendingClientWeaponSet', ))
        {
            return;
        }
    }
    SetPendingWeapon(DesiredWeapon);
    if (PrevWeapon != None && PrevWeapon != DesiredWeapon && !PrevWeapon.bDeleteMe && !PrevWeapon.IsInState('Inactive', ))
    {
        PrevWeapon.TryPutDown();
    }
    else
    {
        ChangedWeapon();
    }
}
public simulated function bool IsActiveWeapon(Weapon ThisWeapon)
{
    return ThisWeapon == Instigator.Weapon;
}
public simulated function bool IsPendingFire(Weapon InWeapon, int InFiringMode)
{
    return bool(PendingFire[InFiringMode]);
}
public function int ModifyDamage(int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
    return Damage;
}
public simulated function NextWeapon()
{
    local Weapon StartWeapon;
    local Weapon CandidateWeapon;
    local Weapon W;
    local bool bBreakNext;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != None)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(Class'Weapon', W)
    {
        if (bBreakNext || StartWeapon == None)
        {
            CandidateWeapon = W;
            break;
        }
        if (W == StartWeapon)
        {
            bBreakNext = TRUE;
        }
    }
    if (CandidateWeapon == None)
    {
        foreach InventoryActors(Class'Weapon', W)
        {
            CandidateWeapon = W;
            break;
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}
public function OwnerDied()
{
    OwnerEvent('Died');
    Destroy();
    if (Instigator.InvManager == Self)
    {
        Instigator.InvManager = None;
    }
}
public simulated function OwnerEvent(Name EventName)
{
    local Inventory Inv;
    
    foreach InventoryActors(Class'Inventory', Inv)
    {
        if (Inv.bReceiveOwnerEvents)
        {
            Inv.OwnerEvent(EventName);
        }
    }
}
public simulated function PrevWeapon()
{
    local Weapon CandidateWeapon;
    local Weapon StartWeapon;
    local Weapon W;
    
    StartWeapon = Instigator.Weapon;
    if (PendingWeapon != None)
    {
        StartWeapon = PendingWeapon;
    }
    foreach InventoryActors(Class'Weapon', W)
    {
        if (W == StartWeapon)
        {
            break;
        }
        CandidateWeapon = W;
    }
    if (CandidateWeapon == None)
    {
        foreach InventoryActors(Class'Weapon', W)
        {
            CandidateWeapon = W;
        }
    }
    if (CandidateWeapon == Instigator.Weapon)
    {
        return;
    }
    SetCurrentWeapon(CandidateWeapon);
}
public simulated function RemoveClassFromInventory(Class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    local Inventory Inv;
    
    Inv = FindInventoryType(DesiredClass, bAllowSubclass);
    while (Inv != None)
    {
        RemoveFromInventory(Inv);
        Inv = FindInventoryType(DesiredClass, bAllowSubclass);
    }
}
public simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    local Inventory Item;
    local bool bFound;
    
    if (ItemToRemove != None)
    {
        if (InventoryChain == ItemToRemove)
        {
            bFound = TRUE;
            InventoryChain = ItemToRemove.Inventory;
        }
        else
        {
            Item = InventoryChain;
            while (Item != None)
            {
                if (Item.Inventory == ItemToRemove)
                {
                    bFound = TRUE;
                    Item.Inventory = ItemToRemove.Inventory;
                    break;
                }
                Item = Item.Inventory;
            }
        }
        if (bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(None);
            ItemToRemove.Inventory = None;
        }
        if (ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = None;
        }
        if (Instigator.Health > 0 && Instigator.Weapon == None && Instigator.Controller != None)
        {
            Instigator.Controller.ClientSwitchToBestWeapon(TRUE);
        }
    }
}
public reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
    InternalSetCurrentWeapon(DesiredWeapon);
}
public simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
    InternalSetCurrentWeapon(DesiredWeapon);
    if (Role < ENetRole.ROLE_Authority)
    {
        ServerSetCurrentWeapon(DesiredWeapon);
    }
}
public simulated function SetPendingFire(Weapon InWeapon, int InFiringMode)
{
    if (InFiringMode < PendingFire.Length)
    {
        PendingFire[InFiringMode] = 1;
    }
}
public simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
    PendingWeapon = DesiredWeapon;
}
public function SetupFor(Pawn P)
{
    Instigator = P;
    SetOwner(P);
}
public simulated function StartFire(byte FireModeNum)
{
    if (Instigator.Weapon != None)
    {
        Instigator.Weapon.StartFire(FireModeNum);
    }
}
public simulated function StopFire(byte FireModeNum)
{
    if (Instigator.Weapon != None)
    {
        Instigator.Weapon.StopFire(FireModeNum);
    }
}
public simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon BestWeapon;
    
    if (bForceADifferentWeapon || PendingWeapon == None || AIController(Instigator.Controller) != None)
    {
        BestWeapon = GetBestWeapon(bForceADifferentWeapon);
        if (BestWeapon == None)
        {
            return;
        }
        if (BestWeapon == Instigator.Weapon)
        {
            BestWeapon = None;
            PendingWeapon = None;
            Instigator.Weapon.Activate();
        }
    }
    Instigator.Controller.StopFiring();
    SetCurrentWeapon(BestWeapon);
}
public simulated function UpdateController()
{
    local Inventory Item;
    local Weapon Weap;
    
    Item = InventoryChain;
    while (Item != None)
    {
        Weap = Weapon(Item);
        if (Weap != None)
        {
            Weap.CacheAIController();
        }
        Item = Item.Inventory;
    }
}

replication
{
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty)
        InventoryChain;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NetPriority = 1.39999998
    bHidden = TRUE
    bOnlyRelevantToOwner = TRUE
    bReplicateInstigator = TRUE
    bReplicateMovement = FALSE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}