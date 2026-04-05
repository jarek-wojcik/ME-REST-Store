Class SFXModule_DamageBase extends SFXModule
    native;

public simulated function SFXTakeDamage(float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, Controller instigatedBy, optional Actor DamageCauser);

public simulated function SFXTakeRadiusDamage(float Damage, float DamageRadius, bool bFullDamage, Vector HurtOrigin, float Momentum, Class<DamageType> DamageType, Controller instigatedBy, Actor DamageCauser, optional TraceHitInfo HitInfo);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bNetVisible = TRUE
}