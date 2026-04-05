Class SFXAICmd_Disabled extends SFXAICommand_Base_Combat within SFXAI_Core;

public function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
    if (Outer.m_nEnabledFlags != 0)
    {
        return FALSE;
    }
    if (AttemptCommand == Class'SFXAICmd_ReturnToPlaypen')
    {
        return FALSE;
    }
    return Super(GameAICommand).AllowTransitionTo(AttemptCommand);
}
public function bool CancelCommand(optional int nReason)
{
    if (nReason == 8)
    {
        return FALSE;
    }
    return Super(SFXAICommand).CancelCommand(nReason);
}
public function bool FireWeaponAtTarget(Actor oTarget, bool bCheckLOS, bool bForceShoot, float fAttackDuration, optional delegate<FireWeaponDelegate> FireDelegate)
{
    if (ChildCommand == None)
    {
        if (Outer.MyBP != None && Outer.MyBP.Weapon == None)
        {
        }
        Outer.m_bCheckLOS = bCheckLOS;
        if (fAttackDuration > 0.0)
        {
            Outer.CurrentKismetOrder.bForceShoot = bForceShoot;
            Outer.CurrentKismetOrder.fAttackDuration = fAttackDuration;
            Outer.CurrentKismetOrder.FireCallback = FireDelegate;
            Outer.CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_FIRE_WEAPON;
            Outer.CurrentKismetOrder.oTargetActor = oTarget;
            PushState('SustainedWeaponFire');
        }
        else
        {
            Outer.FireTarget = oTarget;
            Outer.__FireWeaponDelegate__Delegate = FireDelegate;
            Outer.ShootWeaponAtFireTarget();
        }
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
    GotoState('Disabled', , , );
}
public function bool StartFollowingActor(Actor ActorToFollow)
{
    if (ChildCommand == None)
    {
        if (Outer.MyBP == None || Outer.MyBP.IsDead() || ActorToFollow == None)
        {
            return FALSE;
        }
        Outer.m_RequestedActorToFollow = ActorToFollow;
        Outer.m_ActorToFollow = Outer.m_RequestedActorToFollow;
        Class'SFXAICmd_FollowActor'.static.InitCommand(Outer);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function bool UseInteractionPoint(Actor InteractionPoint, float fFidelityTimeout)
{
    if (ChildCommand == None)
    {
        if (Outer.MyBP == None || InteractionPoint == None)
        {
            return FALSE;
        }
        return Class'SFXAICmd_HenchmanInteraction'.static.StartWorldInteraction(Outer, InteractionPoint, fFidelityTimeout);
    }
    else
    {
        return FALSE;
    }
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

state Disabled 
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