Class SFXObjectPool extends Actor
    native
    transient
    config(Game);

const MAX_WwiseAC = 20;
struct native SFXObjectPoolEmitters 
{
    var array<Emitter> Emitters;
    var ParticleSystem Template;
    var int NextIdx;
};
struct native SFXObjectPoolPSCs 
{
    var editinline export array<ParticleSystemComponent> PSysComponents;
    var ParticleSystem Template;
    var int NextIdx;
};
struct native SFXObjectPoolImpactPSCs 
{
    var editinline export array<ParticleSystemComponent> PSysComponents;
    var ParticleSystem Template;
    var int NextIdx;
};
struct native SFXObjectPoolDroppedAmmos 
{
    var array<DroppedPickup> DroppedAmmos;
    var Class<DroppedPickup> DroppedAmmoClass;
    var int NextIdx;
};
struct native SFXObjectPoolProjectiles 
{
    var array<Projectile> Projectiles;
    var Class<Projectile> ProjectileClass;
    var int NextIdx;
};
struct native SFXObjectPoolTracers 
{
    var array<SFXTracer> Tracers;
    var StaticMesh Mesh;
    var ParticleSystem Template;
    var int NextIdx;
};

var array<SFXObjectPoolTracers> TracerPool;
var array<SFXObjectPoolProjectiles> ProjectilePool;
var array<SFXObjectPoolDroppedAmmos> DroppedPool;
var editinline array<SFXObjectPoolImpactPSCs> ImpactPSCPool;
var editinline array<SFXObjectPoolPSCs> GenericPSCPool;
var array<SFXObjectPoolEmitters> EmitterPool;
var editinline export WwiseAudioComponent WwiseACPool[20];
var const config int MaxTracers;
var const config int MaxImpacts;
var int WwiseNextIdx;
var bool bDebugLogOnCleanup;

public final native function ApplyBloodColor(ParticleSystemComponent PSC, Actor HitActor);

public final native function ApplyLODLevel(ParticleSystemComponent PSC, Vector EffectLocation);

public final native function AttachParticleSystemComponent(ParticleSystemComponent PSC, Actor HitActor, PrimitiveComponent HitComponent, Name HitBone, Vector HitLocation, Vector HitNormal, bool bStaticLocation);

public final native function AttachParticleSystemComponentToSocket(ParticleSystemComponent PSC, PrimitiveComponent HitComponent, Name Socket);

public native function CleanUpPools(bool bPreserveRunningEffects, optional bool bClearAmmo = TRUE);

private final event function DroppedPickup CreatePooledDroppedAmmo(Class<DroppedPickup> DroppedAmmoClass, Vector SpawnLocation)
{
    local SFXDroppedAmmo SFXDrop;
    
    if (ClassIsChildOf(DroppedAmmoClass, Class'DroppedPickup'))
    {
        SFXDrop = SFXDroppedAmmo(Spawn(DroppedAmmoClass, , , SpawnLocation));
        if (SFXDrop != None)
        {
            SFXDrop.bPooled = TRUE;
            SFXDrop.Recycle();
        }
    }
    return SFXDrop;
}
private final event function Emitter CreatePooledEmitter(ParticleSystem Template)
{
    local SFXEmitter SFXEmit;
    
    SFXEmit = Spawn(Class'SFXEmitter');
    if (SFXEmit != None)
    {
        SFXEmit.bPooled = TRUE;
        SFXEmit.Initialize(Template);
        SFXEmit.Recycle();
    }
    return SFXEmit;
}
private final event function Projectile CreatePooledProjectile(Class<Projectile> ProjClass, Vector SpawnLocation)
{
    local SFXProjectile SFXProj;
    
    if (ClassIsChildOf(ProjClass, Class'SFXProjectile'))
    {
        SFXProj = SFXProjectile(Spawn(ProjClass, , , SpawnLocation));
        if (SFXProj != None)
        {
            SFXProj.bPooled = TRUE;
            SFXProj.Recycle();
        }
    }
    return SFXProj;
}
public final native function coerce DroppedPickup GetDroppedAmmo(Class<DroppedPickup> DroppedAmmoClass, Vector SpawnLocation);

public final native function ParticleSystemComponent GetGenericParticleSystemComponent(ParticleSystem Template);

private final native function Emitter GetImpactEmitterInternal(ParticleSystem Template, Vector SpawnLocation, Rotator SpawnRotation);

public final native function ParticleSystemComponent GetImpactParticleSystemComponent(ParticleSystem Template);

public final native function coerce Projectile GetProjectile(Class<Projectile> ProjectileClass, Actor ProjOwner, Pawn ProjInstigator, Vector ProjLocation, Rotator ProjRotation);

public final native function SFXTracer GetTracer(StaticMesh Mesh, ParticleSystem Template);

public final native function WwiseAudioComponent GetWwiseAudioComponent();

public final native function PrecacheGenericParticleSystemComponent(ParticleSystem Template);

public final native function PrecacheImpactEmitter(ParticleSystem Template);

public final native function PrecacheImpactParticleSystemComponent(ParticleSystem Template, optional int MinCount = 1);

public final native function PrecacheProjectile(Class<Projectile> ProjectileClass);

public final native function PrecacheTracer(StaticMesh Mesh, ParticleSystem Template, optional int MinCount = 1);

public static native function ResetActorParticleSystemComponents(Actor ParOwner);

public final native function ResetPooledPSC(ParticleSystemComponent PSC, bool bHide);

private final event function ReusePooledDroppedAmmo(DroppedPickup Dropped)
{
    local SFXDroppedAmmo SFXDrop;
    
    SFXDrop = SFXDroppedAmmo(Dropped);
    if (SFXDrop != None)
    {
        SFXDrop.Reuse();
    }
}
private final event function ReusePooledEmitter(Emitter Emit)
{
    local SFXEmitter SFXEmit;
    
    SFXEmit = SFXEmitter(Emit);
    if (SFXEmit != None)
    {
        SFXEmit.Reuse();
    }
}
private final event function ReusePooledProjectile(Projectile Proj)
{
    local SFXProjectile SFXProj;
    
    SFXProj = SFXProjectile(Proj);
    if (SFXProj != None)
    {
        SFXProj.Reuse();
    }
}
public final function SFXEmitter GetImpactEmitter(ParticleSystem Template, Vector SpawnLocation, Rotator SpawnRotation)
{
    return SFXEmitter(GetImpactEmitterInternal(Template, SpawnLocation, SpawnRotation));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxTracers = 15
    MaxImpacts = 15
    bMovable = FALSE
}