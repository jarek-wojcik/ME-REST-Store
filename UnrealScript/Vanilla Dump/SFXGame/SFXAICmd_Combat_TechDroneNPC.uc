Class SFXAICmd_Combat_TechDroneNPC extends SFXAICommand_Base_Combat within SFXAI_TechDrone_NPC;

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
            Outer.Sleep(0.200000003);
        }
        if (Outer.Enemy != None && Outer.Pawn != None)
        {
            Outer.Focus = Outer.Enemy;
        }
        Outer.Attack();
        if (VSize(Outer.Enemy.location - Outer.MyBP.location) > float(300))
        {
            SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(13, Outer.MyBP, BioPawn(Outer.FireTarget), , , TRUE);
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.Enemy, 250.0);
        }
        Outer.Sleep(0.200000003);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}