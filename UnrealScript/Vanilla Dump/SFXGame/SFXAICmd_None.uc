Class SFXAICmd_None extends SFXAICommand_Base_Combat within SFXAI_None;

public function SwitchWeapon(SFXWeapon oWpn)
{
    Outer.SwitchWeapon(oWpn);
    if (ChildCommand == None)
    {
        Class'SFXAICmd_SwitchWeapon'.static.SwitchWeapon(Outer, oWpn);
    }
}
public function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
    return FALSE;
}
public function bool FireWeaponAtTarget(Actor oTarget, bool bCheckLOS, bool bForceShoot, float fAttackDuration, optional delegate<FireWeaponDelegate> FireDelegate)
{
    if (ChildCommand == None)
    {
        if (Outer.MyBP != None && Outer.MyBP.Weapon == None)
        {
        }
        Outer.m_bCheckLOS = bCheckLOS;
        Outer.FireTarget = oTarget;
        Outer.__FireWeaponDelegate__Delegate = FireDelegate;
        Outer.ShootWeaponAtFireTarget();
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function bool MoveToGoalExternal(Actor NewMoveGoal, optional float NewMoveOffset, optional bool bForceWalk, optional delegate<MoveToDelegate> MoveDelegate)
{
    if (ChildCommand == None)
    {
        Outer.__MoveToDelegate__Delegate = MoveDelegate;
        Outer.bKismetForcedWalk = bForceWalk;
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, NewMoveGoal, NewMoveOffset);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function Pushed()
{
    Super.Pushed();
    GotoState('NoAI', , , );
}
public function bool UsePowerOnTarget(Name nmPowerToUse, Actor oTarget, optional delegate<UsePowerDelegate> PowerDelegate, optional bool bIgnoreSuppression)
{
    if (ChildCommand == None)
    {
        Outer.m_bIgnorePowerSuppression = bIgnoreSuppression;
        Outer.RequestPowerReservation(nmPowerToUse, TRUE);
        Outer.FireTarget = oTarget;
        Outer.__UsePowerDelegate__Delegate = PowerDelegate;
        Class'SFXAICmd_UsePower'.static.UsePower(Outer, nmPowerToUse, oTarget);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

state NoAI extends DebugState 
{
    
Begin:
    while (TRUE)
    {
        Outer.Sleep(1.0);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}