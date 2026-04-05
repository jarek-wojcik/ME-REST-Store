Class SFXDroppedPickup extends DroppedPickup;

var Class<SFXWeapon> WeaponClass;
var editinline export SkeletalMeshComponent PickupMesh;
var editinline export LightEnvironmentComponent LightEnvironment;
var float PickupTimer;
var float PlayerPickupTimer;
var WwiseEvent PickupSound;
var repnotify bool bTargetable;
var const ETargetTipText EquipWeaponToolTip;

public function Landed(Vector HitNormal, Actor FloorActor);

public simulated function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    SetPhysics(2);
    if (Role == ENetRole.ROLE_Authority)
    {
        SetTimer(PickupTimer, FALSE, 'InitPickup', );
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    Super.ReplicatedEvent(VarName);
    if (VarName == 'bTargetable')
    {
        if (bTargetable)
        {
            EnableUseModule();
        }
    }
}
public simulated function SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    local SkeletalMeshComponent SkelMesh;
    
    SkelMesh = SkeletalMeshComponent(NewPickupMesh);
    if (SkelMesh != None && SkelMesh.SkeletalMesh != None)
    {
        PickupMesh.SetSkeletalMesh(SkelMesh.SkeletalMesh);
    }
}
public function PickedUpBy(Pawn P)
{
    Destroy();
}
public function GiveTo(Pawn P)
{
    Used(P);
}
public simulated function EnableUseModule()
{
    local SFXSimpleUseModule UseModule;
    
    UseModule = GetModule(Class'SFXSimpleUseModule');
    UseModule.m_srGameName = Class<SFXWeapon>(InventoryClass).default.PrettyName;
    UseModule.m_TargetTipText = EquipWeaponToolTip;
    UseModule.m_bTargetable = TRUE;
}
public function InitPickup()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(Inventory);
    if (Weapon == None || Weapon.OutOfAmmo())
    {
        LifeSpan = SFXGRI(WorldInfo.GRI).gameconfig.EmptyDroppedWeaponLifespan;
    }
    else
    {
        LifeSpan = SFXGRI(WorldInfo.GRI).gameconfig.DroppedWeaponLifespan;
        bTargetable = TRUE;
        EnableUseModule();
    }
}
public function Used(Actor User)
{
    local SFXPawn_Player Player;
    local SFXWeapon Weapon;
    local BioPawn MyBP;
    
    Player = SFXPawn_Player(User);
    Weapon = SFXWeapon(Inventory);
    if (Player == None || Weapon == None)
    {
        return;
    }
    MyBP = BioPawn(User);
    if (MyBP.IsInAnimatedTransition() || MyBP.CurrentCustomAction != 0)
    {
        return;
    }
    Player.GiveWeaponToPlayer(Weapon);
    Inventory = None;
    PickedUpBy(Player);
    Player.PlaySound(PickupSound, TRUE);
}

auto state Idle 
{
    
    stop;
};

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        bTargetable;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
        BlockZeroExtent = FALSE
        BlockRigidBody = TRUE
    End Template
    Begin Object Class=DynamicLightEnvironmentComponent Name=DroppedPickupLightEnvironment
        AmbientGlow = {R = 0.200000003, G = 0.200000003, B = 0.200000003, A = 1.0}
        bCastShadows = FALSE
        bDynamic = FALSE
    End Object
    Begin Object Class=SFXSimpleUseModule Name=SelMod0
        __OnUsed__Delegate = class'SFXDroppedPickup'.Used
        fUseRange = 225.0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=DroppedPickupMesh0
        ReplacementPrimitive = None
        LightEnvironment = DroppedPickupLightEnvironment
        Scale = 1.20000005
    End Object
    PickupMesh = DroppedPickupMesh0
    LightEnvironment = DroppedPickupLightEnvironment
    PickupTimer = 0.5
    PlayerPickupTimer = 2.0
    PickupSound = WwiseEvent'Wwise_Generic_GUI.Play_HeavyWeaponEquip'
    EquipWeaponToolTip = ETargetTipText.TargetTipText_PickUp
    Components = (None, CollisionCylinder, DroppedPickupLightEnvironment, DroppedPickupMesh0)
    Modules = (SelMod0)
    LifeSpan = 0.0
    CollisionComponent = CollisionCylinder
    bAlwaysRelevant = TRUE
}