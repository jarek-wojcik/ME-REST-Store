Class SFXSeqAct_SetWeaponVisibility extends SequenceAction;

public function Activated()
{
    local Object ChkObject;
    local Pawn ChkPawn;
    local SFXWeapon Weapon;
    
    foreach Targets(ChkObject, )
    {
        ChkPawn = GetPawn(Actor(ChkObject));
        if (ChkPawn != None && ChkPawn.InvManager != None)
        {
            foreach ChkPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
            {
                if (InputLinks[0].bHasImpulse)
                {
                    Weapon.SetWeaponHidden(FALSE);
                }
                else if (InputLinks[1].bHasImpulse)
                {
                    Weapon.SetWeaponHidden(TRUE);
                }
                else if (InputLinks[2].bHasImpulse)
                {
                    Weapon.SetWeaponHidden(!Weapon.Mesh.HiddenGame);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Show", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Hide", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Toggle", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}