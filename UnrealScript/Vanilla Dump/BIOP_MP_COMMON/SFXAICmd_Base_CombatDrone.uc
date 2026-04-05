Class SFXAICmd_Base_CombatDrone extends SFXAICommand_Base_Combat within SFXAI_CombatDrone;

var Name ZapPower;
var Name ShockPower;
var Name RocketPower;
var Name PowerToUse;
var float IdealMaxRangeToTarget;
var float IdealMinRangeToTarget;
var float IdealRangeToTarget;

public function bool ShouldUsePower(out Name PowerName)
{
    local SFXPowerCustomAction oPower;
    
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ShockPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        PowerName = ShockPower;
        return TRUE;
    }
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(RocketPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        PowerName = RocketPower;
        return TRUE;
    }
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ZapPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        PowerName = ZapPower;
        return TRUE;
    }
    return FALSE;
}
public function Pushed()
{
    local SFXPowerCustomAction oPower;
    
    Super.Pushed();
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(RocketPower));
    if (oPower != None && oPower.IsEnabled())
    {
        IdealMaxRangeToTarget = 1200.0;
        IdealMinRangeToTarget = 900.0;
    }
    else
    {
        IdealMaxRangeToTarget = 400.0;
        IdealMinRangeToTarget = 150.0;
    }
    IdealRangeToTarget = IdealMinRangeToTarget + (IdealMaxRangeToTarget - IdealMinRangeToTarget) / 2.0;
}
public function float GetIdealRange()
{
    local SFXPowerCustomAction oPower;
    
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(RocketPower));
    if (oPower != None && oPower.IsEnabled())
    {
        return 1200.0;
    }
    return 200.0;
}

auto state Combat extends InCombat 
{
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    Outer.TotalMoveTime = 0.0;
    Outer.MoveTimeout = RandRange(Outer.MoveTime.X, Outer.MoveTime.Y);
    if (ShouldUsePower(PowerToUse))
    {
        Class'SFXAICmd_UsePower'.static.UsePower(Outer, PowerToUse, Outer.FireTarget, , TRUE);
        Outer.Sleep(0.5);
    }
    else if (VSize(Outer.FireTarget.location - Outer.MyBP.location) > IdealMaxRangeToTarget)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, IdealRangeToTarget);
        Outer.Sleep(0.200000003);
    }
    else if (VSize(Outer.FireTarget.location - Outer.MyBP.location) < IdealMinRangeToTarget)
    {
        Class'SFXAICmd_MoveAway'.static.MoveAway(Outer, Outer.FireTarget, , IdealRangeToTarget, TRUE);
        Outer.Sleep(0.200000003);
    }
    else
    {
        Outer.Sleep(0.5);
    }
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ZapPower = 'CombatDroneZap'
    ShockPower = 'CombatDroneShock'
    RocketPower = 'CombatDroneRocket'
}