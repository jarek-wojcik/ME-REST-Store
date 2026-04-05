Class SFXAICmd_Base_MountedGunner extends SFXAICommand_Base_Combat within SFXAI_Core;

public function Popped()
{
    Super.Popped();
    if (Vehicle(Outer.Pawn) != None)
    {
        Vehicle(Outer.Pawn).DriverLeave(TRUE);
    }
}
public function bool ShouldAttack()
{
    local int EnemyIdx;
    
    EnemyIdx = Outer.GetEnemyIndex(Pawn(Outer.FireTarget));
    if (EnemyIdx != -1 && Outer.TimeSinceEnemyVisible(EnemyIdx) <= 3.0)
    {
        return TRUE;
    }
    return FALSE;
}

auto state Combat extends InCombat 
{
    public function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
    {
        local Rotator POVRot;
        local Vector POVLoc;
        local SFXVehicle_MountedGun Turret;
        
        Outer.GetPlayerViewPoint(POVLoc, POVRot);
        if (Pawn(Outer.FireTarget) != None)
        {
            POVRot = Rotator(Outer.GetAimLocation() - StartFireLoc);
        }
        POVRot.Pitch += int(RandRange(-256.0, 128.0));
        POVRot.Yaw += int(RandRange(-512.0, 512.0));
        Turret = SFXVehicle_MountedGun(Outer.Pawn);
        if (Turret != None)
        {
            Turret.TurretClampYaw(POVRot);
        }
        return POVRot;
    }
    public function Tick(float DeltaTime)
    {
        local SFXVehicle_MountedGun Turret;
        
        Turret = SFXVehicle_MountedGun(Outer.Pawn);
        if (Turret != None)
        {
            Turret.UpdateAIController(Outer, DeltaTime);
        }
        Super(GameAICommand).Tick(DeltaTime);
    }
    public function TriggerIdleNotification()
    {
        local SFXVehicle_MountedGun Turret;
        
        Turret = SFXVehicle_MountedGun(Outer.Pawn);
        if (Turret != None)
        {
            Turret.AIIdleNotification(Outer);
        }
    }
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    if (Vehicle(Outer.Pawn) != None)
    {
        if (Outer.CanTurretFireAt(Outer.FireTarget))
        {
            Outer.StartFiring();
            Outer.Focus = None;
        }
        else
        {
            TriggerIdleNotification();
            Outer.Sleep(1.0);
            if (Outer.LastFireTime != float(0) && Outer.WorldInfo.GameTimeSeconds - Outer.LastFireTime >= 60.0 || !SFXVehicle_MountedGun(Outer.Pawn).IsWithinRotationClamps(Outer.FireTarget.location))
            {
                Outer.PopCommand(Self);
            }
        }
        Outer.Sleep(0.100000001);
        goto 'Begin';
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}