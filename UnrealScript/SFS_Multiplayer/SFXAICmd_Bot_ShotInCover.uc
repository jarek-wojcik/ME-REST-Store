Class SFXAICmd_Bot_ShotInCover extends SFXAICommand_Base_Combat within SFXAI_Bot;

auto state ReactToBeingShot extends InCombat 
{
    
Begin:
    while (TRUE)
    {
        Outer.FindNewCover();
        Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_WeaponRange, Outer.FireTarget);
        if (Outer.bReachedCover)
        {
            Outer.SetTimer(Outer.GetCoverDelayTime(), FALSE, 'FindNewCover', );
            Outer.bAcquireNewCover = FALSE;
            Outer.PopCommand(Self);
        }
        Outer.Sleep(0.100000001);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}