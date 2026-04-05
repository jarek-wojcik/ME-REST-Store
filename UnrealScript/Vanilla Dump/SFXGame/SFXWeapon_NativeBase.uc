Class SFXWeapon_NativeBase extends Weapon
    native
    nativereplication
    abstract
    config(Game);

var int CurrentSpareAmmo;
var int AmmoUsedCount;
var(SFXWeapon_NativeBase) bool bWeaponExpanded;
var(SFXWeapon_NativeBase) bool bInstantExpansion;
var bool bForceReplayAnimation;
var(SFXWeapon_NativeBase) config bool bCanDropWeapon;
var(SFXWeapon_NativeBase) config bool bCanDropAmmo;
var transient bool bDrawingWeaponBlendOut;
var transient bool bReloadWeaponBlendOut;
var bool bIsZoomed;
var bool bCanBlindUp;
var(Debug) config bool bInfiniteAmmo;
var bool bShowGlowInZoom;
var bool bGlowOnlyThroughSmoke;
var transient bool bIsInitialized;
var bool bSuppressAudio;
var ESFXVocalizationWeapon VocalizationType;
var repnotify byte FizzleCount;
var repnotify EAttachSlot CharacterSlot;

public event simulated function bool CalculateCoverLeanOutOffset(out Vector Offset, ECoverDirection Direction, ECoverType Type);

public native function ImpactInfo CalcWeaponFire_Native(out Vector StartTrace, out Vector EndTrace, out array<ImpactInfo> ImpactList, float PenetrationDistance, optional Vector Extent);

public final native function bool CanPartialLean();

public event simulated function DummyFire(byte FireModeNum, Vector TargetLoc, optional Actor AttachedTo, optional float AimErrorDeg, optional Actor TargetActor);

public simulated native function FireAmmunition();

public event simulated function float GetPenetrationDepth();

public event simulated function bool HasLoopingFire();

public final native function bool IsZoomed();

public event simulated function ProcessInstantHit_Internal(byte FiringMode, ImpactInfo Impact, optional int NumHits);

public event simulated function WeaponStoppedFiring(byte FiringMode);


//Replication conditions for this class are native. This block has no effect
replication
{
    if (Role == ENetRole.ROLE_Authority && !bNetOwner)
        bIsZoomed;
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        CharacterSlot;
    if (bNetOwner && bNetDirty && Role == ENetRole.ROLE_Authority)
        CurrentSpareAmmo, AmmoUsedCount, bInfiniteAmmo;
    if (!bNetOwner && bNetDirty && Role == ENetRole.ROLE_Authority)
        FizzleCount;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}