Class SFXPowerCustomAction_MultiProjectile extends SFXPowerCustomAction
    config(Game);

var config AreaEffectParameters SecondTargetParams;
var Vector SecondLocation;
var config float SecondProjectileDelay;
var config float SecondProjectileSpeedPercent;
var config float SecondProjectileMaxRange;
var Actor SecondTarget;
var config float CastConeHalfAngleDeg;
var bool bSecondProjectile;

public function ReleasePower()
{
    Super.ReleasePower();
    if (bSecondProjectile)
    {
        FindSecondTarget();
        m_oPawn.SetTimer(SecondProjectileDelay, FALSE, 'ReleaseSecondProjectile', Self);
    }
}
public function FindSecondTarget()
{
    local array<Actor> NearbyActors;
    local Actor oActor;
    local SFXPawn_Player Player;
    
    if (m_oTargetToAimAt != None)
    {
        GetNearbyActors(NearbyActors, m_oTargetToAimAt.location, SecondProjectileMaxRange, SecondProjectileMaxRange, SecondTargetParams);
        Player = SFXPawn_Player(m_oPawn);
        foreach NearbyActors(oActor, )
        {
            if (oActor != m_oTargetToAimAt)
            {
                if (Player != None && Vector(m_oPawn.Rotation) Dot Normal(oActor.location - m_oPawn.location) < Cos(CastConeHalfAngleDeg * 0.0174532924))
                {
                    continue;
                }
                SecondTarget = oActor;
                break;
            }
        }
        if (SecondTarget != None)
        {
            SecondLocation = SecondTarget.location;
            return;
        }
        else
        {
            SecondTarget = m_oTargetToAimAt;
            SecondLocation = m_oTargetToAimAt.location;
        }
    }
    else
    {
        SecondTarget = m_oTargetToAimAt;
        SecondLocation = m_vLocationToAimAt;
    }
}
public function ReleaseSecondProjectile()
{
    local EPowerType eType;
    local BioPawn oPawnTarget;
    local SFXProjectile_PowerCustomAction oProjectile;
    
    m_oTargetToAimAt = SecondTarget;
    m_vLocationToAimAt = SecondLocation;
    oPawnTarget = BioPawn(SecondTarget);
    if (oPawnTarget != None)
    {
        oPawnTarget.OnCastAt(m_oPawn, Self);
    }
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        eType = HenchmanPowerType;
    }
    else
    {
        eType = PowerType;
    }
    switch (eType)
    {
        case EPowerType.PowerType_Projectile:
            oProjectile = ReleaseProjectilePower();
            if (oProjectile != None)
            {
                oProjectile.ChangeSpeedDynamically(oProjectile.Speed * SecondProjectileSpeedPercent);
            }
            break;
        case EPowerType.PowerType_Instant:
            ReleaseInstantPower();
            break;
        default:
    }
    SecondTarget = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SecondTargetParams = {
                          ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                          ConeAngle = 0.0, 
                          ImpactFriends = FALSE, 
                          ImpactDeadPawns = FALSE, 
                          ImpactPlaceables = TRUE, 
                          BlockedByObjects = FALSE, 
                          DistancedSorted = TRUE
                         }
    SecondProjectileSpeedPercent = 1.0
    SecondProjectileMaxRange = 800.0
    CastConeHalfAngleDeg = 60.0
}