Class SFXAI_CombatDrone extends SFXAI_Core
    placeable
    config(AI);

var(SFXAI_CombatDrone) Vector2D MoveTime;
var(SFXAI_CombatDrone) float TotalMoveTime;
var(SFXAI_CombatDrone) float MoveTimeout;

public event function BioClearCrossLevelReferences(Level ClearedLevel)
{
    local SFXPawn_CombatDroneBase Drone;
    
    Drone = SFXPawn_CombatDroneBase(Pawn);
    if (Drone != None && Drone.Caster != None && Drone.Caster.Outer == ClearedLevel)
    {
        Drone.__OnDroneKilled__Delegate = None;
        Drone.Caster = None;
    }
}
public function PeriodicMoveCheck()
{
    Super.PeriodicMoveCheck();
    TotalMoveTime += GetPeriodicMoveInterval();
    if (TotalMoveTime >= MoveTimeout)
    {
        MoveTarget = None;
        bReachedMoveGoal = TRUE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MoveTime = {X = 2.0, Y = 4.0}
    DefaultCommand = Class'SFXAICmd_Base_CombatDrone'
}