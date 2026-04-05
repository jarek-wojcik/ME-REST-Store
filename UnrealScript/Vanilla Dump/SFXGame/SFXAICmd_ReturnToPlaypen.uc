Class SFXAICmd_ReturnToPlaypen extends SFXAICommand_Base_Combat within SFXAI_Core;

public function bool CancelCommand(optional int nReason)
{
    return FALSE;
}
public function bool MoveToPlaypen()
{
    local Actor oNodeInPlaypen;
    
    if (Outer.MyBP == None || Outer.MyBP.Squad == None)
    {
        return FALSE;
    }
    oNodeInPlaypen = Outer.MyBP.Squad.GetPlaypenReturnPoint(Outer.MyBP);
    if (oNodeInPlaypen == None)
    {
        return FALSE;
    }
    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, oNodeInPlaypen, 0.0);
    return TRUE;
}
public function bool NotifyMoodChange()
{
    return TRUE;
}
public event function Popped()
{
    Outer.ClearTimer('SelectTarget');
    Super.Popped();
}
public function Pushed()
{
    Super.Pushed();
    Outer.SetTimer(0.5 + FRand() * 0.200000003, TRUE, 'SelectTarget', );
    GotoState('ReturningToPlaypen', , , );
}

state ReturningToPlaypen 
{
    
Begin:
    MoveToPlaypen();
    if (Outer.IsActorInPlaypen(Outer.MyBP) == FALSE)
    {
        Outer.Sleep(1.0);
    }
    Outer.BeginCombatCommand(None, "Leaving return to playpen command");
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}