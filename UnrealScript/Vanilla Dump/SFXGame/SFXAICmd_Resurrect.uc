Class SFXAICmd_Resurrect extends SFXAICommand_Base_Combat within SFXAI_Henchman;

public function Pushed()
{
    Super.Pushed();
    GotoState('Resurrecting', , , );
}
public function bool ResurrectHenchman()
{
    local BioPlayerSquad oPlayerSquad;
    
    if (Outer.MyBP == None)
    {
        return FALSE;
    }
    oPlayerSquad = BioPlayerSquad(Outer.MyBP.Squad);
    if (oPlayerSquad == None)
    {
        return FALSE;
    }
    if (Outer.MyBP.Physics != EPhysics.PHYS_RigidBody && Outer.MyBP.Mesh == Outer.MyBP.CollisionComponent)
    {
        Outer.MyBP.SetPhysics(10);
    }
    return Outer.MyBP.Resurrect(oPlayerSquad.m_fPercentHealthOnResurrection, FALSE);
}

state Resurrecting extends DebugState 
{
    
Begin:
    if (Outer.MyBP.IsDead())
    {
        while (ResurrectHenchman() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    Outer.MyBP.SetCollision(TRUE, TRUE, );
    if (Outer.m_bResetHenchman)
    {
        Outer.MyBP.ForceEndRagdoll();
    }
    while (Outer.MyBP.IsInState('InRagdoll', ) || Outer.MyBP.IsInState('RagdollRecovery', ))
    {
        Outer.Sleep(0.100000001);
    }
    Outer.m_bFollowPlayer = FALSE;
    Outer.m_vHoldLocation = vect(0.0, 0.0, 0.0);
    Outer.m_bHoldingPosition = FALSE;
    Outer.ForcedTarget = None;
    if (Outer.m_nEnabledFlags != 0)
    {
        Outer.BeginCombatCommand(Class'SFXAICmd_Disabled');
    }
    else
    {
        Outer.PopCommand(Self);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}