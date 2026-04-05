Class SFXDroppedAmmo extends DroppedPickup;

var(SFXDroppedAmmo) editinline export StaticMeshComponent AmmoMesh;
var WwiseEvent AmmoPickupSound;
var float DecayTime;
var(SFXDroppedAmmo) editinline export LightEnvironmentComponent LightEnvironment;
var transient bool bPooled;

public event function EncroachedBy(Actor Other)
{
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Destroy();
    }
}
public event function Landed(Vector HitNormal, Actor FloorActor)
{
    Super.Landed(HitNormal, FloorActor);
    SetCollisionCylinderSize(120.0, 10.0);
}
public function Recycle()
{
    DecayTime = default.DecayTime;
    Inventory = default.Inventory;
    InventoryClass = default.InventoryClass;
    Velocity = default.Velocity;
    Instigator = default.Instigator;
    PickupCache = default.PickupCache;
    bFadeOut = default.bFadeOut;
    SetHidden(TRUE);
    SetTickIsDisabled(TRUE);
    SetCollision(FALSE, FALSE, FALSE);
}
public function Reset()
{
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Super.Reset();
    }
}
public function Reuse()
{
    SetHidden(FALSE);
    SetTickIsDisabled(FALSE);
    SetCollision(TRUE, FALSE, FALSE);
    if (DecayTime != float(0))
    {
        SetTimer(DecayTime, FALSE, 'Recycle', );
    }
}
public function PickedUpBy(Pawn P)
{
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Destroy();
    }
}
public function GiveTo(Pawn P)
{
    Inventory = None;
    GiveAmmo(P);
    if (BioPawn(P) != None)
    {
        BioPawn(P).PlaySoundForOwnerOnly(AmmoPickupSound);
    }
    PickedUpBy(P);
    ClearTimer('RecheckValidTouch');
}
public final simulated function bool CanPickUpAmmo(Pawn ChkPawn)
{
    local SFXWeapon Weapon;
    
    if (ChkPawn != None && ChkPawn.InvManager != None)
    {
        foreach ChkPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            if (SFXHeavyWeapon(Weapon) == None && Weapon.GetCurrentSpareAmmo() < Weapon.GetMaxSpareAmmo())
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function GiveAmmo(Pawn P)
{
    local SFXGRI GRI;
    local float AmmoAwardPct;
    local SFXWeapon Weapon;
    
    if (P != None && P.InvManager != None)
    {
        GRI = SFXGRI(WorldInfo.GRI);
        if (GRI != None)
        {
            AmmoAwardPct = GRI.DifficultyHandler.AmmoPct;
            foreach P.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
            {
                if (SFXHeavyWeapon(Weapon) == None)
                {
                    Weapon.AddAmmo(int(float(Weapon.GetMaxSpareAmmo()) * AmmoAwardPct));
                }
            }
            if (GRI.IsMultiplayerGame())
            {
                Class'SFXGUIInteraction'.static.GetInstance().PlayGuiSound('MPAmmoPickupSuccess');
            }
        }
    }
}
public function SetCollisionCylinderSize(float CollisionRadius, float CollisionHeight)
{
    local CylinderComponent Comp;
    
    foreach AllOwnedComponents(Class'CylinderComponent', Comp)
    {
        Comp.SetCylinderSize(CollisionRadius, CollisionHeight);
    }
}
public simulated function ShowAmmoFullMessage(Pawn Other)
{
    local PlayerController PC;
    local SFXGUIInteraction GUI;
    local SFXSFHandler_HUD HUD;
    
    if (Other != None && Other.IsLocallyControlled())
    {
        PC = PlayerController(Other.Controller);
        if (PC != None)
        {
            GUI = Class'SFXGUIInteraction'.static.GetInstance();
            if (GUI != None)
            {
                HUD = GUI.CastGetMovie(Class'SFXSFHandler_HUD', PC, GUI.MovieTag_HUD);
                if (HUD != None)
                {
                    HUD.PulseFullAmmoMessage(FALSE);
                }
            }
        }
    }
}

auto state Pickup 
{
    public function CheckTouching()
    {
        local Pawn P;
        
        foreach TouchingActors(Class'Pawn', P, )
        {
            Touch(P, None, location, Normal(location - P.location));
        }
    }
    public function RecheckValidTouch()
    {
        CheckTouching();
    }
    public simulated function bool ValidTouch(Pawn Other)
    {
        if (bTickIsDisabled)
        {
            return FALSE;
        }
        if (Other == None || !Other.bCanPickupInventory || Other.DrivenVehicle == None && Other.Controller == None)
        {
            return FALSE;
        }
        return CanPickUpAmmo(Other);
    }
    public event simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local BioPawn P;
        local SFXGRI GRI;
        local bool IsAuthority;
        local bool IsLocallyControlled;
        
        P = BioPawn(Other);
        if (P == None)
        {
            return;
        }
        IsAuthority = P.Role >= ENetRole.ROLE_Authority;
        IsLocallyControlled = P.IsLocallyControlled();
        if (IsAuthority || IsLocallyControlled)
        {
            if (ValidTouch(P))
            {
                if (IsAuthority)
                {
                    GiveTo(P);
                }
            }
            else if (IsLocallyControlled)
            {
                ShowAmmoFullMessage(P);
                GRI = SFXGRI(WorldInfo.GRI);
                if (GRI != None && GRI.IsMultiplayerGame())
                {
                    Class'SFXGUIInteraction'.static.GetInstance().PlayGuiSound('MPAmmoPickupFail');
                }
            }
        }
    }
    public function BeginState(Name PreviousStateName);
    
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 10.0
        CollisionRadius = 120.0
        ReplacementPrimitive = None
    End Template
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Begin Object Class=StaticMeshComponent Name=DroppedAmmoMesh0
        StaticMesh = StaticMesh'BioApl_Uti_AmmoClip01.AmmoClip01'
        Materials = (Material'BioApl_Uti_AmmoClip01.Clip_MM')
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        bUseAsOccluder = FALSE
        CollideActors = FALSE
        BlockRigidBody = FALSE
    End Object
    AmmoMesh = DroppedAmmoMesh0
    AmmoPickupSound = WwiseEvent'Wwise_Generic_GUI.Play_PUGeneric'
    DecayTime = 40.0
    LightEnvironment = MyLightEnvironment
    Components = (None, CollisionCylinder, MyLightEnvironment, DroppedAmmoMesh0)
    LifeSpan = 0.0
    CollisionComponent = DroppedAmmoMesh0
    bAlwaysRelevant = TRUE
}