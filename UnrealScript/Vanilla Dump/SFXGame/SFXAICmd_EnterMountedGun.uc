Class SFXAICmd_EnterMountedGun extends SFXAICommand_Base_Combat within SFXAI_Cover;

var transient bool bEnteredMountedGun;

public function Popped()
{
    Super.Popped();
    if (!bEnteredMountedGun)
    {
        UnclaimTurret();
    }
    Outer.DriveTarget = None;
}
public function UnclaimTurret()
{
    local SFXVehicle_MountedGun Turret;
    
    Turret = SFXVehicle_MountedGun(Outer.DriveTarget);
    if (Turret != None)
    {
        Turret.UnclaimTurret(Outer);
    }
}

auto state EnterMountedGun extends InCombat 
{
    
Begin:
    if (SFXVehicle_MountedGun(Outer.DriveTarget) != None)
    {
        if (SFXVehicle_MountedGun(Outer.DriveTarget).MountingPoint != None)
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, SFXVehicle_MountedGun(Outer.DriveTarget).MountingPoint, 10.0, TRUE, FALSE);
        }
        else
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.DriveTarget, 100.0, TRUE, FALSE);
        }
        if (Outer.bReachedMoveGoal)
        {
            bEnteredMountedGun = TRUE;
            BioPawn(Outer.Pawn).RegisterTemporaryAnim(SFXVehicle_MountedGun(Outer.DriveTarget).DriverAnimInfo.AnimSet);
            BioPawn(Outer.Pawn).StartCustomAction(13, Vehicle(Outer.DriveTarget));
        }
        else
        {
            UnclaimTurret();
        }
    }
    Outer.Sleep(0.100000001);
    Outer.BeginDefaultCommand();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}