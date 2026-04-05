Class Weapon extends Inventory
    native
    abstract
    config(Game);

enum EWeaponFireType
{
    EWFT_InstantHit,
    EWFT_Projectile,
    EWFT_Custom,
    EWFT_None,
};

var array<Name> FiringStatesArray;
var array<EWeaponFireType> WeaponFireTypes;
var array<Class<Projectile>> WeaponProjectiles;
var(Weapon) array<float> FireInterval;
var(Weapon) array<float> Spread;
var(Weapon) array<float> InstantHitDamage;
var(Weapon) array<float> InstantHitMomentum;
var array<Class<DamageType>> InstantHitDamageTypes;
var array<byte> ShouldFireOnRelease;
var(Weapon) Vector FireOffset;
var(Weapon) float EquipTime;
var(Weapon) float PutDownTime;
var(Weapon) float WeaponRange;
var(Weapon) editinline export MeshComponent Mesh;
var(Weapon) float DefaultAnimSpeed;
var config databinding float Priority;
var protectedwrite AIController AIController;
var float AIRating;
var float CachedMaxRange;
var bool bWeaponPutDown;
var bool bCanThrow;
var bool bWasOptionalSet;
var bool bWasDoNotActivate;
var bool bInstantHit;
var bool bMeleeWeapon;
var byte CurrentFireMode;

public simulated function Activate()
{
    if (!IsFiring())
    {
        GotoState('WeaponEquipping', , , );
    }
}
public event simulated function Destroyed()
{
    DetachWeapon();
    Super.Destroyed();
}
public simulated function FireAmmunition()
{
    ConsumeAmmo(CurrentFireMode);
    PlayFiringSound();
    switch (WeaponFireTypes[int(CurrentFireMode)])
    {
        case 0:
            InstantFire();
            break;
        case 1:
            ProjectileFire();
            break;
        case 2:
            CustomFire();
            break;
        default:
    }
    NotifyWeaponFired(CurrentFireMode);
}
public event simulated function Vector GetMuzzleLoc()
{
    if (Instigator != None)
    {
        return Instigator.GetPawnViewLocation() + (FireOffset >> Instigator.GetViewRotation());
    }
    return location;
}
public event simulated native function Vector GetPhysicalFireStartLoc(optional Vector AimDir);

public event simulated function float GetTraceRange()
{
    return WeaponRange;
}
public event simulated function bool IsFiring()
{
    return FALSE;
}
public simulated function float MaxRange()
{
    local int i;
    
    if (CachedMaxRange > float(0))
    {
        return CachedMaxRange;
    }
    if (bInstantHit)
    {
        CachedMaxRange = WeaponRange;
    }
    for (i = 0; i < WeaponProjectiles.Length; i++)
    {
        if (WeaponProjectiles[i] != None)
        {
            CachedMaxRange = FMax(CachedMaxRange, WeaponProjectiles[i].static.GetRange());
        }
    }
    return CachedMaxRange;
}
public final simulated function bool PendingFire(int FireMode)
{
    if (InvManager != None)
    {
        return InvManager.IsPendingFire(Self, FireMode);
    }
    return FALSE;
}
public simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local int TotalDamage;
    local KActorFromStatic NewKActor;
    local StaticMeshComponent HitStaticMesh;
    
    if (Impact.HitActor != None)
    {
        NumHits = Max(NumHits, 1);
        TotalDamage = int(InstantHitDamage[int(CurrentFireMode)] * float(NumHits));
        if (Impact.HitActor.bWorldGeometry)
        {
            HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
            if (HitStaticMesh != None && HitStaticMesh.CanBecomeDynamic())
            {
                NewKActor = Class'KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
                if (NewKActor != None)
                {
                    Impact.HitActor = NewKActor;
                }
            }
        }
        Impact.HitActor.TakeDamage(float(TotalDamage), Instigator.Controller, Impact.HitLocation, InstantHitMomentum[int(FiringMode)] * Impact.RayDir, InstantHitDamageTypes[int(FiringMode)], Impact.HitInfo, Self);
    }
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int i;
    
    GetWeaponDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, 255, 0);
    for (i = 0; i < DebugInfo.Length; i++)
    {
        HUD.Canvas.DrawText("  " @ DebugInfo[i]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}
public function int AddAmmo(int Amount);

public simulated function Rotator AddSpread(Rotator BaseAim)
{
    local Vector X;
    local Vector Y;
    local Vector Z;
    local float CurrentSpread;
    local float RandY;
    local float RandZ;
    
    CurrentSpread = Spread[int(CurrentFireMode)];
    if (CurrentSpread == float(0))
    {
        return BaseAim;
    }
    else
    {
        GetAxes(BaseAim, X, Y, Z);
        RandY = FRand() - 0.5;
        RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
        return Rotator(X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z);
    }
}
public simulated function float AdjustFOVAngle(float FOVAngle)
{
    return FOVAngle;
}
public simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName);

public simulated function BeginFire(byte FireModeNum)
{
    SetPendingFire(int(FireModeNum));
}
public simulated function CacheAIController()
{
    if (Instigator == None)
    {
        AIController = None;
    }
    else
    {
        AIController = AIController(Instigator.Controller);
    }
}
public simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent)
{
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector Dir;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local ImpactInfo CurrentImpact;
    local PortalTeleporter Portal;
    local float HitDist;
    local bool bToggledBlockActors;
    
    HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, TRUE, Extent, HitInfo, 1);
    if (HitActor == None)
    {
        HitLocation = EndTrace;
    }
    CurrentImpact.HitActor = HitActor;
    CurrentImpact.HitLocation = HitLocation;
    CurrentImpact.HitNormal = HitNormal;
    CurrentImpact.RayDir = Normal(EndTrace - StartTrace);
    CurrentImpact.StartTrace = StartTrace;
    CurrentImpact.HitInfo = HitInfo;
    ImpactList[ImpactList.Length] = CurrentImpact;
    if (HitActor != None)
    {
        if (PassThroughDamage(HitActor))
        {
            HitActor.bProjTarget = FALSE;
            if (HitActor.bBlockActors)
            {
                HitActor.SetCollision(HitActor.bCollideActors, FALSE, );
                bToggledBlockActors = TRUE;
            }
            CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList, Extent);
            HitActor.bProjTarget = TRUE;
            if (bToggledBlockActors)
            {
                HitActor.SetCollision(HitActor.bCollideActors, TRUE, );
            }
        }
        else
        {
            Portal = PortalTeleporter(HitActor);
            if (Portal != None && Portal.SisterPortal != None)
            {
                Dir = EndTrace - StartTrace;
                HitDist = VSize(HitLocation - StartTrace);
                StartTrace = Portal.TransformHitLocation(HitLocation);
                EndTrace = StartTrace + Portal.TransformVectorDir(Normal(Dir) * (VSize(Dir) - HitDist));
                CalcWeaponFire(StartTrace, EndTrace, ImpactList, Extent);
            }
        }
    }
    return CurrentImpact;
}
public function bool CanAttack(Actor Other)
{
    return TRUE;
}
public simulated function bool CanThrow()
{
    return bCanThrow;
}
public final simulated function ClearAllPendingFire()
{
    if (InvManager != None)
    {
        InvManager.ClearAllPendingFire(Self);
    }
}
public simulated function ClearFlashCount()
{
    if (Instigator != None)
    {
        Instigator.ClearFlashCount(Self);
    }
}
public function ClearFlashLocation()
{
    if (Instigator != None)
    {
        Instigator.ClearFlashLocation(Self);
    }
}
public final simulated function ClearPendingFire(int FireMode)
{
    if (InvManager != None)
    {
        InvManager.ClearPendingFire(Self, FireMode);
    }
}
public reliable client function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    Super.ClientGivenTo(NewOwner, bDoNotActivate);
    ClientWeaponSet(TRUE, bDoNotActivate);
}
public reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
    bWasOptionalSet = bOptionalSet;
    bWasDoNotActivate = bDoNotActivate;
    if (Instigator == None)
    {
        GotoState('PendingClientWeaponSet', , , );
        return;
    }
    if (InvManager == None)
    {
        GotoState('PendingClientWeaponSet', , , );
        return;
    }
    InvManager.ClientWeaponSet(Self, bOptionalSet, bDoNotActivate);
}
public reliable client function ClientWeaponThrown()
{
    GotoState('Inactive', , , );
    if (Instigator != None && Instigator.Weapon == Self)
    {
        Instigator.Weapon = None;
    }
    ForceEndFire();
    DetachWeapon();
}
public function ConsumeAmmo(byte FireModeNum);

public simulated function CustomFire();

public simulated function bool DenyClientWeaponSet()
{
    return FALSE;
}
public function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
    if (ItemClass == Class)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function DetachWeapon();

public simulated function bool DoOverrideNextWeapon()
{
    return FALSE;
}
public simulated function bool DoOverridePrevWeapon()
{
    return FALSE;
}
public function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    if (!CanThrow())
    {
        return;
    }
    GotoState('Inactive', , , );
    ForceEndFire();
    DetachWeapon();
    Super.DropFrom(StartLocation, StartVelocity);
    AIController = None;
}
public simulated function EndFire(byte FireModeNum)
{
    ClearPendingFire(int(FireModeNum));
}
public simulated function FireModeUpdated(byte FiringMode, bool bViaReplication);

public function bool FireOnRelease()
{
    return ShouldFireOnRelease.Length > 0 && int(ShouldFireOnRelease[int(CurrentFireMode)]) != 0;
}
public function bool FocusOnLeader(bool bLeaderFiring)
{
    return FALSE;
}
public simulated function ForceEndFire()
{
    local int i;
    
    if (InvManager != None)
    {
        for (i = 0; i < GetPendingFireLength(); i++)
        {
            if (PendingFire(i))
            {
                EndFire(byte(i));
            }
        }
    }
}
public simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator R;
    
    if (Instigator != None)
    {
        R = Instigator.GetAdjustedAimFor(Self, StartFireLoc);
    }
    return AddSpread(R);
}
public function float GetAIRating()
{
    return AIRating;
}
public function float GetDamageRadius()
{
    local Class<Projectile> CurrentProjectileClass;
    
    CurrentProjectileClass = GetProjectileClass();
    if (CurrentProjectileClass == None)
    {
        return 0.0;
    }
    return CurrentProjectileClass.default.DamageRadius;
}
public simulated function float GetFireInterval(byte FireModeNum)
{
    return FireInterval[int(FireModeNum)] > float(0) ? FireInterval[int(FireModeNum)] : 0.00999999978;
}
public final simulated function int GetPendingFireLength()
{
    if (InvManager != None)
    {
        return InvManager.GetPendingFireLength(Self);
    }
    return 0;
}
public simulated function Class<Projectile> GetProjectileClass()
{
    return int(CurrentFireMode) < WeaponProjectiles.Length ? WeaponProjectiles[int(CurrentFireMode)] : None;
}
public simulated function Actor GetTraceOwner()
{
    return Instigator != None ? Instigator : Self;
}
public simulated function GetViewAxes(out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
    local Rotator AimRot;
    
    AimRot = Instigator.GetBaseAimRotation();
    GetAxes(AimRot, XAxis, YAxis, ZAxis);
}
public simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
    local AnimTree Tree;
    local AnimNodeSequence AnimSeq;
    local SkeletalMeshComponent SkelMesh;
    
    SkelMesh = SkeletalMeshComponent(Mesh);
    if (SkelMesh != None)
    {
        Tree = AnimTree(SkelMesh.Animations);
        if (Tree != None)
        {
            AnimSeq = AnimNodeSequence(Tree.Children[0].Anim);
        }
        else
        {
            AnimSeq = AnimNodeSequence(SkelMesh.Animations);
        }
        return AnimSeq;
    }
    return None;
}
public simulated function GetWeaponDebug(out array<string> DebugInfo)
{
    local string T;
    local int i;
    
    DebugInfo[DebugInfo.Length] = "Weapon:" $ GetItemName(string(Self)) @ "State:" $ GetStateName() @ "Instigator:" $ Instigator @ "Owner:" $ Owner;
    DebugInfo[DebugInfo.Length] = "IsFiring():" $ IsFiring() @ "CurrentFireMode:" $ CurrentFireMode @ "bWeaponPutDown:" $ bWeaponPutDown;
    if (Instigator != None)
    {
        DebugInfo[DebugInfo.Length] = "ShotCount:" $ Instigator.ShotCount @ "FlashCount:" $ Instigator.FlashCount @ "FlashLocation:" $ Instigator.FlashLocation;
    }
    T = "PendingFires:";
    for (i = 0; i < GetPendingFireLength(); i++)
    {
        T = T $ PendingFire(i) $ " ";
    }
    DebugInfo[DebugInfo.Length] = T;
    if (Timers.Length > 0)
    {
        for (i = 0; i < Timers.Length; i++)
        {
            DebugInfo[DebugInfo.Length] = "Timer" @ Timers[i].FuncName @ Timers[i].Count @ Timers[i].Rate @ int(Timers[i].Count / Timers[i].Rate * float(100)) $ "%";
        }
    }
}
public simulated function float GetWeaponRating()
{
    if (InvManager != None)
    {
        return InvManager.GetWeaponRatingFor(Self);
    }
    if (!HasAnyAmmo())
    {
        return -1.0;
    }
    return 1.0;
}
public simulated function HandleFinishedFiring()
{
    GotoState('Active', , , );
}
public simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    return TRUE;
}
public simulated function bool HasAnyAmmo()
{
    return TRUE;
}
public function HolderDied()
{
    ServerStopFire(CurrentFireMode);
}
public simulated function IncrementFlashCount()
{
    if (Instigator != None)
    {
        Instigator.IncrementFlashCount(Self, CurrentFireMode);
    }
}
public simulated function InstantFire()
{
    local Vector StartTrace;
    local Vector EndTrace;
    local array<ImpactInfo> ImpactList;
    local int idx;
    local ImpactInfo RealImpact;
    
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    EndTrace = StartTrace + Vector(GetAdjustedAim(StartTrace)) * GetTraceRange();
    RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    if (Role == ENetRole.ROLE_Authority)
    {
        SetFlashLocation(RealImpact.HitLocation);
    }
    for (idx = 0; idx < ImpactList.Length; idx++)
    {
        ProcessInstantHit(CurrentFireMode, ImpactList[idx]);
    }
}
public simulated function bool IsActiveWeapon()
{
    if (InvManager != None)
    {
        return InvManager.IsActiveWeapon(Self);
    }
    return FALSE;
}
public function ItemRemovedFromInvManager()
{
    GotoState('Inactive', , , );
    ForceEndFire();
    DetachWeapon();
    ClientWeaponThrown();
    Super.ItemRemovedFromInvManager();
    if (IsActiveWeapon())
    {
        Instigator.Weapon = None;
    }
}
public function NotifyWeaponFinishedFiring(byte FireMode)
{
    if (AIController != None)
    {
        AIController.NotifyWeaponFinishedFiring(Self, FireMode);
    }
}
public function NotifyWeaponFired(byte FireMode)
{
    if (AIController != None)
    {
        AIController.NotifyWeaponFired(Self, FireMode);
    }
}
public static simulated function bool PassThroughDamage(Actor HitActor)
{
    return !HitActor.bBlockActors && (HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume')) || HitActor.IsA('InteractiveFoliageActor');
}
public simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation);

public simulated function PlayFiringSound();

public simulated function PlayWeaponAnimation(Name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    local AnimNodeSequence WeapNode;
    local AnimTree Tree;
    
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        return;
    }
    if (SkelMesh == None)
    {
        SkelMesh = SkeletalMeshComponent(Mesh);
    }
    if (SkelMesh == None || GetWeaponAnimNodeSeq() == None)
    {
        return;
    }
    if (fDesiredDuration > 0.0)
    {
        SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);
    }
    else
    {
        Tree = AnimTree(SkelMesh.Animations);
        if (Tree != None)
        {
            WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
        }
        else
        {
            WeapNode = AnimNodeSequence(SkelMesh.Animations);
        }
        WeapNode.SetAnim(Sequence);
        WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
    }
}
public simulated function Projectile ProjectileFire()
{
    local Vector StartTrace;
    local Vector EndTrace;
    local Vector RealStartLoc;
    local Vector AimDir;
    local ImpactInfo TestImpact;
    local Projectile SpawnedProjectile;
    
    IncrementFlashCount();
    if (Role == ENetRole.ROLE_Authority)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = Vector(GetAdjustedAim(StartTrace));
        RealStartLoc = GetPhysicalFireStartLoc(AimDir);
        if (StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + AimDir * GetTraceRange();
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
        }
        SpawnedProjectile = Spawn(GetProjectileClass(), Self, , RealStartLoc);
        if (SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
        }
        return SpawnedProjectile;
    }
    return None;
}
public simulated function PutDownWeapon()
{
    GotoState('WeaponPuttingDown', , , );
}
public function float RangedAttackTime()
{
    return 0.0;
}
public function bool RecommendLongRangedAttack()
{
    return FALSE;
}
public function bool RecommendRangedAttack()
{
    return FALSE;
}
public simulated function RefireCheckTimer();

public function float RelativeStrengthVersus(Pawn P, float Dist)
{
    return 0.0;
}
public simulated function SendToFiringState(byte FireModeNum)
{
    if (int(FireModeNum) >= FiringStatesArray.Length)
    {
        return;
    }
    if (FiringStatesArray[int(FireModeNum)] == 'None' || int(WeaponFireTypes[int(FireModeNum)]) == 3)
    {
        return;
    }
    SetCurrentFireMode(FireModeNum);
    GotoState(FiringStatesArray[int(FireModeNum)], , , );
}
public reliable server function ServerStartFire(byte FireModeNum)
{
    if (Instigator == None || !Instigator.bNoWeaponFiring)
    {
        BeginFire(FireModeNum);
    }
}
public reliable server function ServerStopFire(byte FireModeNum)
{
    EndFire(FireModeNum);
}
public simulated function SetCurrentFireMode(byte FiringModeNum)
{
    CurrentFireMode = FiringModeNum;
    if (Instigator != None)
    {
        Instigator.SetFiringMode(Self, FiringModeNum);
    }
}
public function SetFlashLocation(Vector HitLocation)
{
    if (Instigator != None)
    {
        Instigator.SetFlashLocation(Self, CurrentFireMode, HitLocation);
    }
}
public final simulated function SetPendingFire(int FireMode)
{
    if (InvManager != None)
    {
        InvManager.SetPendingFire(Self, FireMode);
    }
}
public simulated function bool ShouldRefire()
{
    if (!HasAmmo(CurrentFireMode))
    {
        return FALSE;
    }
    return StillFiring(CurrentFireMode);
}
public simulated function StartFire(byte FireModeNum)
{
    if (Instigator == None || !Instigator.bNoWeaponFiring)
    {
        if (Role < ENetRole.ROLE_Authority)
        {
            ServerStartFire(FireModeNum);
        }
        BeginFire(FireModeNum);
    }
}
public simulated function bool StillFiring(byte FireMode)
{
    return PendingFire(int(FireMode));
}
public simulated function StopFire(byte FireModeNum)
{
    EndFire(FireModeNum);
    if (Role < ENetRole.ROLE_Authority)
    {
        ServerStopFire(FireModeNum);
    }
}
public simulated function StopFireEffects(byte FireModeNum);

public simulated function StopWeaponAnimation()
{
    local AnimNodeSequence AnimSeq;
    
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        return;
    }
    AnimSeq = GetWeaponAnimNodeSeq();
    if (AnimSeq != None)
    {
        AnimSeq.StopAnim();
    }
}
public function float SuggestAttackStyle()
{
    return 0.0;
}
public function float SuggestDefenseStyle()
{
    return 0.0;
}
public simulated function TimeWeaponEquipping()
{
    SetTimer(EquipTime > float(0) ? EquipTime : 0.00999999978, FALSE, 'WeaponEquipped', );
}
public simulated function TimeWeaponFiring(byte FireModeNum)
{
    if (!IsTimerActive('RefireCheckTimer'))
    {
        SetTimer(GetFireInterval(FireModeNum), TRUE, 'RefireCheckTimer', );
    }
}
public simulated function TimeWeaponPutDown()
{
    SetTimer(PutDownTime > float(0) ? PutDownTime : 0.00999999978, FALSE, 'WeaponIsDown', );
}
public simulated function bool TryPutDown()
{
    bWeaponPutDown = TRUE;
    return TRUE;
}
public simulated function WeaponCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot);

public simulated function WeaponEmpty();

public simulated function WeaponIsDown();

public simulated function WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
    if (Sound == None || Instigator == None)
    {
        return;
    }
    Instigator.PlaySound(Sound, FALSE, TRUE);
}

state PendingClientWeaponSet 
{
    public event simulated function EndState(Name NextStateName)
    {
        ClearTimer('PendingWeaponSetTimer');
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        SetTimer(0.0299999993, TRUE, 'PendingWeaponSetTimer', );
    }
    public simulated function PendingWeaponSetTimer()
    {
        ClientWeaponSet(bWasOptionalSet, bWasDoNotActivate);
    }
    
    stop;
};
simulated state WeaponPuttingDown 
{
    public event simulated function EndState(Name NextStateName)
    {
        ClearTimer('WeaponIsDown');
    }
    public reliable client function ClientWeaponThrown()
    {
        WeaponIsDown();
        Global.ClientWeaponThrown();
    }
    public simulated function bool TryPutDown()
    {
        return FALSE;
    }
    public simulated function WeaponIsDown()
    {
        if (InvManager.CancelWeaponChange())
        {
            return;
        }
        DetachWeapon();
        GotoState('Inactive', , , );
        InvManager.ChangedWeapon();
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        TimeWeaponPutDown();
        bWeaponPutDown = FALSE;
        ForceEndFire();
    }
    
    stop;
};
simulated state WeaponEquipping 
{
    public simulated function WeaponEquipped()
    {
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active', , , );
    }
    public event simulated function EndState(Name NextStateName)
    {
        ClearTimer('WeaponEquipped');
    }
    public simulated function Activate();
    
    public event simulated function BeginState(Name PreviousStateName)
    {
        TimeWeaponEquipping();
        bWeaponPutDown = FALSE;
    }
    
    stop;
};
simulated state WeaponFiring 
{
    public event simulated function EndState(Name NextStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        NotifyWeaponFinishedFiring(CurrentFireMode);
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        FireAmmunition();
        TimeWeaponFiring(CurrentFireMode);
    }
    public simulated function RefireCheckTimer()
    {
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        if (ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        HandleFinishedFiring();
    }
    public event simulated function bool IsFiring()
    {
        return TRUE;
    }
    
    stop;
};
simulated state Active 
{
    public simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return TRUE;
    }
    public simulated function Activate();
    
    public simulated function bool ReadyToFire(bool bFinished)
    {
        return TRUE;
    }
    public simulated function BeginFire(byte FireModeNum)
    {
        if (!bDeleteMe && Instigator != None)
        {
            Global.BeginFire(FireModeNum);
            if (PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum))
            {
                SendToFiringState(FireModeNum);
            }
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        local int i;
        
        if (Role == ENetRole.ROLE_Authority)
        {
            CacheAIController();
        }
        if (bWeaponPutDown)
        {
            PutDownWeapon();
        }
        else if (!HasAnyAmmo())
        {
            WeaponEmpty();
        }
        else
        {
            for (i = 0; i < GetPendingFireLength(); i++)
            {
                if (PendingFire(i))
                {
                    BeginFire(byte(i));
                    break;
                }
            }
        }
    }
    
    stop;
};
auto state Inactive 
{
    public simulated function bool TryPutDown()
    {
        return FALSE;
    }
    public simulated function StartFire(byte FireModeNum);
    
    public reliable server function ServerStopFire(byte FireModeNum)
    {
        ClearPendingFire(int(FireModeNum));
    }
    public reliable server function ServerStartFire(byte FireModeNum)
    {
        Global.ServerStartFire(FireModeNum);
        if (Instigator != None && Instigator.Weapon == Self)
        {
            GotoState('Active', , , );
        }
        else if (InvManager != None && InvManager.PendingWeapon == Self)
        {
            if (Instigator.Weapon.IsInState('WeaponPuttingDown', ))
            {
                Instigator.Weapon.WeaponIsDown();
            }
            else
            {
                InvManager.SetCurrentWeapon(Self);
                InvManager.ServerSetCurrentWeapon(Self);
                if (Instigator.Weapon != Self && InvManager.PendingWeapon == Self && Instigator.Weapon.IsInState('WeaponPuttingDown', ))
                {
                    Instigator.Weapon.WeaponIsDown();
                }
            }
        }
        else if (Instigator != None)
        {
            InvManager.SetCurrentWeapon(Self);
            InvManager.ServerSetCurrentWeapon(Self);
            if (Instigator.Weapon != Self && InvManager.PendingWeapon == Self && Instigator.Weapon.IsInState('WeaponPuttingDown', ))
            {
                Instigator.Weapon.WeaponIsDown();
            }
        }
    }
    public event simulated function BeginState(Name PreviousStateName);
    
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EquipTime = 0.330000013
    PutDownTime = 0.330000013
    WeaponRange = 16384.0
    DefaultAnimSpeed = 1.0
    Priority = -1.0
    AIRating = 0.5
    bCanThrow = TRUE
    ItemName = "Weapon"
    RespawnTime = 30.0
    Components = ()
    bOnlyRelevantToOwner = TRUE
    bReplicateInstigator = TRUE
    bOnlyDirtyReplication = FALSE
}