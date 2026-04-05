Class SFXGameEffect_HenchmenIgnorePawn extends SFXGameEffect;

public function OnRemoved()
{
    local BioAiController Controller;
    local BioPlayerController PlayerController;
    local BioPawn PlayerPawn;
    
    Super.OnRemoved();
    PlayerController = BioWorldInfo(Owner.WorldInfo).GetLocalPlayerController();
    if (PlayerController != None)
    {
        PlayerPawn = BioPawn(PlayerController.Pawn);
        if (PlayerPawn != None && PlayerPawn.Squad != None)
        {
            foreach PlayerPawn.Squad.SquadMembers(Controller)
            {
                Controller.IgnoredTargets.RemoveItem(Owner);
            }
        }
    }
}
public function OnApplied()
{
    local BioAiController Controller;
    local BioPlayerController PlayerController;
    local BioPawn PlayerPawn;
    local SFXAI_Core AICore;
    
    Super.OnApplied();
    PlayerController = BioWorldInfo(Owner.WorldInfo).GetLocalPlayerController();
    if (PlayerController != None)
    {
        PlayerPawn = BioPawn(PlayerController.Pawn);
        if (PlayerPawn != None && PlayerPawn.Squad != None)
        {
            foreach PlayerPawn.Squad.SquadMembers(Controller)
            {
                if (Controller.IgnoredTargets.Find(Owner) == -1)
                {
                    Controller.IgnoredTargets.AddItem(Owner);
                }
                AICore = SFXAI_Core(Controller);
                if (AICore != None && AICore.FireTarget == Owner)
                {
                    AICore.SelectTarget();
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}