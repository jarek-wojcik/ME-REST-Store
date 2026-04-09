Class SFXPowerCustomAction_ProtectorDroneBase extends SFXPowerCustomAction
    config(Game);

var Class<SFXPawn_ProtectorDroneBase> DroneClass;
var Class<SFXAI_Core> DroneAIClass;
var float DroneSpawnOffset;

public function DespawnDrone(SFXPawn_ProtectorDroneBase oDrone)
{
    if (oDrone != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (m_oPawn.Controller != None)
        {
            oDrone.KilledBy = m_oPawn.Controller;
        }
        oDrone.Died(m_oPawn.Controller, Class'SFXDamageType_Default', oDrone.location);
    }
}
public function Vector GetBackLocation(Actor Target)
{
    return Target.location + Vector(Target.Rotation) * -DroneSpawnOffset;
}
public function Vector GetFrontLocation(Actor Target, optional float YawOffset = 0.0)
{
    local Rotator Rotation;
    
    Rotation = Target.Rotation;
    Rotation.Yaw += int(YawOffset);
    return Target.location + Vector(Rotation) * DroneSpawnOffset;
}
public function bool IsSafeSpawnLocation(out Vector SpawnLocation)
{
    local Vector FloorLocation;
    
    if (m_oPawn.FindSpot(m_oPawn.GetCollisionExtent(), SpawnLocation) && GetFloorLocation(SpawnLocation, FloorLocation))
    {
        if (VSize(SpawnLocation - FloorLocation) < 300.0)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function OnDroneKilled(SFXPawn_ProtectorDroneBase oDrone);

public function SetupSpawnedDrone(SFXPawn_ProtectorDroneBase SpawnedDrone)
{
    local SFXPowerCustomActionBase oPower;
    
    SpawnedDrone.__OnDroneKilled__Delegate = OnDroneKilled;
    if (SpawnedDrone != None && SpawnedDrone.PowerManager != None)
    {
        foreach SpawnedDrone.PowerManager.Powers(oPower, )
        {
            oPower.Rank = Rank;
        }
    }
}
public function SFXPawn_ProtectorDroneBase SpawnDrone(Vector location, Rotator Rotation)
{
    local SFXPawn_ProtectorDroneBase Drone;
    local SFXAI_Core DroneAI;
    
    Drone = m_oPawn.Spawn(DroneClass, , 'ProtectorDrone', location, Rotation, , , TRUE);
    if (Drone == None)
    {
        return None;
    }
    Drone.SetupCasterAndReplication(m_oPawn);
    DroneAI = m_oPawn.Spawn(DroneAIClass, , , location, Rotation, None, TRUE);
    if (DroneAI == None)
    {
        return None;
    }
    DroneAI.Instigator = m_oPawn;
    Drone.Instigator = m_oPawn;
    DroneAI.Possess(Drone, FALSE);
    DroneAI = SFXAI_Core(Drone.Controller);
    if (DroneAI != None)
    {
        DroneAI.SetTeam(0);
    }
    SetupSpawnedDrone(Drone);
    return Drone;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DroneSpawnOffset = 150.0
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    PowerName = 'ProtectorDrone'
    PowerCustomActionID = 51
    AimingIgnoresObstructions = TRUE
    PowerType = EPowerType.PowerType_Buff
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_CombatDrone
}