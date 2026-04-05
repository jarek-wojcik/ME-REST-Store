Class DamageType
    native
    abstract;

var(DamageType) const localized string DeathString;
var(DamageType) const localized string FemaleSuicide;
var(DamageType) const localized string MaleSuicide;
var(RigidBody) float KDamageImpulse;
var(RigidBody) float KDeathVel;
var(RigidBody) float KDeathUpKick;
var(RigidBody) float RadialDamageImpulse;
var float VehicleDamageScaling;
var float VehicleMomentumScaling;
var ForceFeedbackWaveform DamagedFFWaveform;
var ForceFeedbackWaveform KilledFFWaveform;
var float FracturedMeshDamage;
var(DamageType) bool bArmorStops;
var(DamageType) bool bAlwaysGibs;
var(DamageType) bool bNeverGibs;
var(DamageType) bool bLocationalHit;
var(DamageType) bool bCausesBlood;
var bool bCausedByWorld;
var bool bExtraMomentumZ;
var(DamageType) bool bCausesFracture;
var bool bIgnoreDriverDamageMult;
var(RigidBody) bool bRadialDamageVelChange;

public static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    return default.DeathString;
}
public static function string SuicideMessage(PlayerReplicationInfo Victim)
{
    if (Victim != None && Victim.bIsFemale)
    {
        return default.FemaleSuicide;
    }
    else
    {
        return default.MaleSuicide;
    }
}
public static function float VehicleDamageScalingFor(Vehicle V)
{
    return default.VehicleDamageScaling;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DeathString = "`o was killed by `k."
    FemaleSuicide = "`o killed herself."
    MaleSuicide = "`o killed himself."
    KDamageImpulse = 800.0
    VehicleDamageScaling = 1.0
    VehicleMomentumScaling = 1.0
    FracturedMeshDamage = 1.0
    bArmorStops = TRUE
    bLocationalHit = TRUE
    bCausesBlood = TRUE
    bExtraMomentumZ = TRUE
}