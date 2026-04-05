Class SFXPreAsyncWorkTicker extends Actor
    native
    transient;

struct native SFXPreAsyncWorkQueuedPowerImpact 
{
    var delegate<OnActorImpacted> ImpactCallback;
    var Class<SFXDamageType> DamageType;
    var Class<SFXDamageType> MaxRagdollDmgTypeOverride;
    var AreaEffectParameters Params;
    var Vector HitLocation;
    var Vector HitNormal;
    var SFXPowerCustomActionBase Power;
    var Actor Target;
    var float Damage;
    var int MaxRagdollOverride;
    var float Force;
    var int ImpactCount;
    var SFXProjectile_PowerCustomAction Projectile;
    var int FrameCount;
    var bool bAreaExplosion;
    var bool bFirstTarget;
};
struct native SFXPreAsyncWorkQueuedShot 
{
    var editinline ImpactInfo Impact;
    var SFXWeapon_NativeBase Weapon;
    var int NumHits;
    var int FrameCount;
    var bool bSuppressAudio;
    var byte FiringMode;
};
struct native AreaEffectParameters 
{
    var Vector ConeDirection;
    var Rotator HitDirectionOffset;
    var float ConeAngle;
    var bool ImpactFriends;
    var bool ImpactDeadPawns;
    var bool ImpactPlaceables;
    var bool BlockedByObjects;
    var bool DistancedSorted;
};

var editinline array<SFXPreAsyncWorkQueuedShot> QueuedShots;
var array<SFXPreAsyncWorkQueuedPowerImpact> QueuedPowerImpacts;
var delegate<OnActorImpacted> __OnActorImpacted__Delegate;

public final native function bool DoAreaExplosionForActor(SFXPowerCustomActionBase Power, Actor Target, Vector ExplosionLocation, int ImpactCount, float Damage, Class<SFXDamageType> DamageType, float Force, const out AreaEffectParameters Params, int MaxRagdollOverride, delegate<OnActorImpacted> ImpactCallback, optional Class<SFXDamageType> MaxRagdollDmgTypeOverride);

public final native function bool DoPowerDetonationForActor(SFXPowerCustomActionBase Power, Actor Target, Vector HitLocation, Vector HitNormal, int ImpactCount, bool bFirstTarget, optional SFXProjectile_PowerCustomAction Projectile);

public delegate function bool OnActorImpacted(EPowerResistance Resistance, Actor Impacted, int PreviouslyImpacted, Vector HitLocation, Vector HitNormal);

public final native function ProcessInstantHit(SFXWeapon_NativeBase Weapon, byte FiringMode, const out ImpactInfo Impact, bool bSuppressAudio, optional int NumHits);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}