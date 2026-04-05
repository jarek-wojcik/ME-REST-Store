Class SFXAICmd_KismetOrder extends SFXAICommand_Base_Combat within SFXAI_Core;

public function Popped()
{
    Super.Popped();
    Outer.CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_NONE;
}

auto state ExecuteKismetOrders extends DebugState 
{
    
Begin:
    if (Outer.CurrentKismetOrder.eOrderType == KismetOrderType.KISMET_ORDER_NONE)
    {
        Outer.BeginDefaultCommand();
    }
    if (Outer.CurrentKismetOrder.eOrderType == KismetOrderType.KISMET_ORDER_FIRE_WEAPON)
    {
        if (Outer.CurrentKismetOrder.fAttackDuration > 0.0)
        {
            PushState('SustainedWeaponFire');
        }
        else
        {
            Outer.FireTarget = Outer.CurrentKismetOrder.oTargetActor;
            Outer.__FireWeaponDelegate__Delegate = Outer.CurrentKismetOrder.FireCallback;
            Outer.ShootWeaponAtFireTarget(0.0, Outer.CurrentKismetOrder.bForceShoot);
        }
    }
    else if (Outer.CurrentKismetOrder.eOrderType == KismetOrderType.KISMET_ORDER_MOVE)
    {
        Outer.__MoveToDelegate__Delegate = Outer.CurrentKismetOrder.MoveCallback;
        Outer.bKismetForcedWalk = Outer.CurrentKismetOrder.bWalk;
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.CurrentKismetOrder.oTargetActor, Outer.CurrentKismetOrder.fDistOffset);
    }
    Outer.BeginDefaultCommand();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}