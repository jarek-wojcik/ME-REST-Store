Class SFXAICmd_ResetHenchman extends SFXAICommand within SFXAI_Henchman;

public function Pushed()
{
    Super(GameAICommand).Pushed();
    GotoState('ResetHenchman', , , );
}
public function bool TeleportToPlayer()
{
    local Pawn oPlayer;
    
    if (Outer.MyBP == None || Outer.MyBP.Squad == None)
    {
        return FALSE;
    }
    oPlayer = Outer.MyBP.Squad.Members[0];
    if (oPlayer == None)
    {
        return FALSE;
    }
    if (Outer.m_bTeleportHenchman)
    {
        return Outer.TeleportNearLeader();
    }
    else
    {
        return Outer.TeleportToActor(oPlayer, Outer.m_bResetHenchman);
    }
}

state ResetHenchman extends DebugState 
{
    
Begin:
    Outer.m_bFollowPlayer = FALSE;
    Outer.m_vHoldLocation = vect(0.0, 0.0, 0.0);
    Outer.m_bHoldingPosition = FALSE;
    Outer.ForcedTarget = None;
    if (Outer.MyBP != None)
    {
        Outer.MyBP.StopMovement();
        if (Outer.MyBP.bHidden == TRUE)
        {
            Outer.MyBP.SetHidden(FALSE);
        }
        Outer.MyBP.SetCollision(TRUE, TRUE, FALSE);
    }
    Outer.m_nTeleportAttemptCounter = 0;
    while (TeleportToPlayer() == FALSE && Outer.m_nTeleportAttemptCounter < 3)
    {
        if (Outer.m_bTeleportHenchman)
        {
            Outer.m_nTeleportAttemptCounter++;
        }
        Outer.Sleep(0.5);
    }
    Outer.m_bResetHenchman = FALSE;
    Outer.m_bTeleportHenchman = FALSE;
    if (Outer.MyBP != None)
    {
        Outer.MyBP.m_fGravityScaling = 1.0;
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}