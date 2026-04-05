Class SFXAICmd_MoveAwayFromPlayer extends SFXAICommand_Base_Combat within SFXAI_Henchman;

public function bool GetMoveLocation(out Vector vLocation)
{
    local BioBaseSquad oPlayerSquad;
    local PlayerController oPlayerController;
    local Vector vCameraLocation;
    local Vector vPlayerDirection;
    local Vector vUp;
    local Vector vNewDirection;
    local Rotator rCameraRotation;
    local Rotator rToHenchman;
    local SFXPawn oPlayerPawn;
    
    if (Outer.bAILogging)
    {
        Outer.FlushPersistentDebugLines();
    }
    if (Outer.MyBP == None || Outer.WorldInfo == None)
    {
        return FALSE;
    }
    oPlayerSquad = Outer.MyBP.Squad;
    if (oPlayerSquad == None || !oPlayerSquad.bIsPlayerSquad)
    {
        return FALSE;
    }
    oPlayerPawn = SFXPawn(oPlayerSquad.CachedPlayerPawn);
    if (oPlayerPawn == None)
    {
        return FALSE;
    }
    if (oPlayerPawn.DrivenAtlas != None)
    {
        oPlayerPawn = oPlayerPawn.DrivenAtlas;
    }
    oPlayerController = PlayerController(oPlayerPawn.Controller);
    if (oPlayerController == None || oPlayerController.PlayerCamera == None)
    {
        return FALSE;
    }
    vCameraLocation = oPlayerController.PlayerCamera.CameraCache.POV.location;
    vPlayerDirection = Normal(Outer.MyBP.location - vCameraLocation);
    vPlayerDirection.Z = 0.0;
    vPlayerDirection = Normal(vPlayerDirection);
    vUp.Z = 1.0;
    vNewDirection = vPlayerDirection Cross vUp;
    rCameraRotation = Normalize(oPlayerController.PlayerCamera.CameraCache.POV.Rotation);
    rToHenchman = Rotator(Outer.MyBP.location - oPlayerPawn.location);
    if (rToHenchman.Yaw - rCameraRotation.Yaw >= 0)
    {
        vNewDirection *= float(-1);
    }
    vLocation = Outer.MyBP.location + vNewDirection * 200.0;
    if (Outer.bAILogging)
    {
        Outer.DrawDebugLine(Outer.MyBP.location, vLocation, 255, 0, 0, TRUE);
    }
    if (Outer.PointReachable(vLocation) == FALSE)
    {
        vNewDirection *= float(-1);
        vLocation = Outer.MyBP.location + vNewDirection * 200.0;
        if (Outer.bAILogging)
        {
            Outer.DrawDebugLine(Outer.MyBP.location, vLocation, 0, 255, 0, TRUE);
        }
        if (Outer.PointReachable(vLocation) == FALSE)
        {
            vLocation = Outer.MyBP.location + vPlayerDirection * 200.0;
            if (Outer.bAILogging)
            {
                Outer.DrawDebugLine(Outer.MyBP.location, vLocation, 0, 0, 255, TRUE);
            }
            if (Outer.PointReachable(vLocation) == FALSE)
            {
                return FALSE;
            }
        }
    }
    return TRUE;
}
public function Popped()
{
    if (Outer.MyBP != None)
    {
        Outer.MyBP.StopMovement(FALSE);
        Outer.MyBP.m_bEnableStartRootMotion = Outer.m_bOriginalStartRootMotion;
        Outer.MyBP.m_bEnableStopRootMotion = Outer.m_bOriginalStopRootMotion;
    }
    Super.Popped();
}
public function Pushed()
{
    Super.Pushed();
    if (Outer.MyBP != None)
    {
        Outer.m_bOriginalStartRootMotion = Outer.MyBP.m_bEnableStartRootMotion;
        Outer.m_bOriginalStopRootMotion = Outer.MyBP.m_bEnableStopRootMotion;
        Outer.MyBP.m_bEnableStartRootMotion = FALSE;
        Outer.MyBP.m_bEnableStopRootMotion = FALSE;
    }
    GotoState('MovingAwayFromPlayer', , , );
}
public function bool ShouldRun()
{
    return TRUE;
}

state MovingAwayFromPlayer extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None)
    {
        Outer.PopCommand(Self);
    }
    if (GetMoveLocation(Outer.MovePoint) == FALSE)
    {
        Outer.PopCommand(Self);
    }
    Outer.MoveOffset = 0.0;
    Outer.MoveTimer = 5.0;
    Outer.SetMovementSpeed();
    Class'SFXAICmd_MoveToLocation'.static.MoveToLocation(Outer, Outer.MovePoint, Outer.MoveOffset);
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InitialTransitionCheckTime = {X = 5.0, Y = 5.0}
    TransitionCheckTime = {X = 5.0, Y = 5.0}
}