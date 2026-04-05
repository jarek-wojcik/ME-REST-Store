Class SFXAICmd_Combat_Turret extends SFXAICommand_Base_Combat within SFXAI_Core;

public function Pushed()
{
    Super.Pushed();
    GotoState('Combat', , , );
}

state Combat extends InCombat 
{
    
Begin:
    while (TRUE)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
        if (Outer.Enemy != None && Outer.Pawn != None)
        {
            Outer.Focus = Outer.Enemy;
        }
        Outer.Attack();
        Outer.Sleep(0.200000003);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}