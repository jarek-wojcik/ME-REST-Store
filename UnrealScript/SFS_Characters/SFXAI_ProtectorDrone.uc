Class SFXAI_ProtectorDrone extends SFXAI_Core
    placeable
    config(AI);

var(SFXAI_ProtectorDrone) Vector2D MoveTime;
var(SFXAI_ProtectorDrone) float TotalMoveTime;
var(SFXAI_ProtectorDrone) float MoveTimeout;

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
    DefaultCommand = Class'SFXAICmd_Base_ProtectorDrone'
}