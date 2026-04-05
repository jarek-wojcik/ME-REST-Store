Class SFXAICmd_Fallen extends SFXAICommand within SFXAI_Core;

public function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
    if (AttemptCommand == Class'SFXAICmd_Resurrect')
    {
        return TRUE;
    }
    return FALSE;
}
public function bool CanInterruptCurrentCommand()
{
    return FALSE;
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    GotoState('Fallen', , , );
}

state Fallen extends DebugState 
{
    
Begin:
    if (Outer.m_bCanResurrect)
    {
        Outer.MyBP.SetCollision(TRUE, FALSE, );
        Outer.MyBP.Mesh.SetRBChannel(7);
        Outer.MyBP.Mesh.SetRBCollidesWithChannel(2, FALSE);
        while (Outer.IsInCombat() && Outer.MyBP.IsInState('Downed', ))
        {
            Outer.Sleep(0.5);
        }
        Outer.BeginCombatCommand(Class'SFXAICmd_Resurrect');
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}