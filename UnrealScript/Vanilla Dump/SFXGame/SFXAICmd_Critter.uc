Class SFXAICmd_Critter extends SFXAICommand within SFXAI_Critter;

public function bool AdjustSteeringSpeed(Vector vSteering)
{
    if (IsZero(vSteering))
    {
        Outer.Pawn.SetDesiredSpeed(0.0);
        return FALSE;
    }
    else if (IsZero(Outer.m_vRepulsor) == FALSE && VSize(Outer.m_vRepulsor - Outer.Pawn.location) < 1000.0)
    {
        Outer.Pawn.SetWalking(FALSE);
    }
    else
    {
        Outer.m_vRepulsor.X = 0.0;
        Outer.m_vRepulsor.Y = 0.0;
        Outer.m_vRepulsor.Z = 0.0;
        Outer.Pawn.SetWalking(TRUE);
    }
    Outer.Pawn.SetDesiredSpeed(1.0);
    return TRUE;
}
public function GetSteeringDirection(out Vector vSteering)
{
    if (Outer.MyBP != None)
    {
        vSteering = Outer.MyBP.Velocity + VRand();
        if (IsZero(Outer.m_vRepulsor) == FALSE)
        {
            vSteering += (Outer.MyBP.location - Outer.m_vRepulsor) / 10.0;
        }
    }
}
public function Popped()
{
    Super(GameAICommand).Popped();
    Outer.ClearTimer('PlayAmbientVoc');
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.SetTimer(10.0, TRUE, 'PlayAmbientVoc', );
    GotoState('CritterWander', , , );
}

state CritterWander extends DebugState 
{
    
Begin:
    while (TRUE)
    {
        if (Outer.WorldInfo.GameTimeSeconds - Outer.LastShotAtTime > 1.0)
        {
            Outer.m_bUnderAttack = FALSE;
        }
        GetSteeringDirection(Outer.m_vCurrentSteeringDirection);
        if (AdjustSteeringSpeed(Outer.m_vCurrentSteeringDirection))
        {
            Outer.m_vCurrentSteeringDirection = Normal(Outer.m_vCurrentSteeringDirection);
            Outer.m_bClearVelocityAfterMove = FALSE;
            Outer.MovePoint = Outer.MyBP.location + Outer.m_vCurrentSteeringDirection * float(200);
            Outer.Sleep(0.150000006);
            Outer.MoveTimer = 2.0;
            Class'SFXAICmd_MoveToLocation'.static.MoveToLocation(Outer, Outer.MovePoint, 0.0);
            if (!Outer.bReachedMoveGoal && !Outer.m_bUnderAttack)
            {
                Outer.m_vRepulsor = vect(0.0, 0.0, 0.0);
            }
            continue;
        }
        Outer.Sleep(2.0);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}