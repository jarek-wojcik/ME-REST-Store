Class SFXAICmd_Reaction_Flank extends SFXAICommand_Base_Combat within SFXAI_Cover;

auto state ReactToFlank extends InCombat 
{
    
Begin:
    Outer.Sleep(Outer.FlankReactionTime);
    while (TRUE)
    {
        if (Outer.MyBP.IsInCover())
        {
            Outer.MyBP.LeaveCover();
        }
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