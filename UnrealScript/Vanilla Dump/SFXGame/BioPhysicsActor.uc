Class BioPhysicsActor extends SFXKActor
    native
    placeable;

var(Combat) float m_fHealth;
var float m_fCurrentHealth;
var(Combat) bool m_bToughPlaceable;

public native function ChangeMaterialParameters();

public event simulated function TakeDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (m_fCurrentHealth > 0.0)
    {
        m_fCurrentHealth -= Damage;
        ChangeMaterialParameters();
    }
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    Super.TakeRadiusDamage(instigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent, HitInfo);
    if (m_fCurrentHealth > 0.0)
    {
        m_fCurrentHealth -= BaseDamage;
        ChangeMaterialParameters();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBCollideWithChannels = {GameplayPhysics = FALSE, EffectPhysics = FALSE}
    End Template
    m_fHealth = 1000.0
    m_fCurrentHealth = 1000.0
    bImmovable = FALSE
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bNoDelete = FALSE
    bPathColliding = FALSE
}