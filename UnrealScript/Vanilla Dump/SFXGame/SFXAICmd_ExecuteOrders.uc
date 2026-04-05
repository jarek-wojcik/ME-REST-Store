Class SFXAICmd_ExecuteOrders extends SFXAICommand within SFXAI_Henchman;

public function ExecuteAttackOrder()
{
    Outer.ForcedTarget = Outer.m_Orders[0].oTargetActor;
    Outer.m_bFollowPlayer = FALSE;
    Outer.ApplyOrderBonus();
}
public function ExecuteFollowOrder()
{
    Outer.m_bFollowPlayer = TRUE;
    Outer.ForcedTarget = None;
    Outer.m_vHoldLocation = vect(0.0, 0.0, 0.0);
    Outer.m_bHoldingPosition = FALSE;
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(8, Outer.MyBP, , , , TRUE);
    Outer.ApplyOrderBonus();
}
public function ExecuteHoldPositionOrder()
{
    Outer.m_vHoldLocation = Outer.m_Orders[0].vTargetLocation;
    Outer.m_bHoldingPosition = FALSE;
    Outer.ForcedTarget = None;
    Outer.m_bFollowPlayer = FALSE;
    Outer.ApplyOrderBonus();
}
public function ExecutePowerOrder()
{
    if (Outer.m_Orders[0].nmPower != 'None')
    {
        Outer.m_bIgnorePowerSuppression = TRUE;
        Class'SFXAICmd_UsePower'.static.UsePower(Outer, Outer.m_Orders[0].nmPower, Outer.m_Orders[0].oTargetActor, Outer.m_Orders[0].vTargetLocation, TRUE, TRUE);
    }
}
public function ExecuteSwitchWeaponOrder()
{
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(6, Outer.MyBP, None, , , TRUE);
    Class'SFXAICmd_SwitchWeapon'.static.SwitchWeapon(Outer, Outer.m_Orders[0].oWeapon);
}
public function Popped()
{
    Outer.m_Orders.Length = 0;
    Outer.SetTimer(0.300000012, TRUE, 'ExecuteOrders', );
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.ClearTimer('ExecuteOrders');
    GotoState('ExecutingOrders', , , );
}

state ExecutingOrders extends DebugState 
{
    
Begin:
    while (Outer.m_Orders.Length > 0)
    {
        Outer.m_Orders[0].bExecutingOrder = TRUE;
        if (Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
        {
            if (Outer.m_Orders[0].bPowerUseIsInstant == FALSE || Outer.CanInstantlyUsePowers() == FALSE || Outer.IsTimerActive('InstantUsePower') == FALSE)
            {
                if (Outer.IsTimerActive('InstantUsePower'))
                {
                    Outer.ClearTimer('InstantUsePower');
                }
                Outer.m_Orders[0].bPowerUseIsInstant = FALSE;
                while (Outer.MyBP != None && Outer.MyBP.IsReloading(TRUE))
                {
                    Outer.Sleep(0.25);
                }
                ExecutePowerOrder();
                Outer.m_Orders.Remove(0, 1);
            }
            else
            {
                Outer.Sleep(0.25);
            }
            continue;
        }
        if (Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_ATTACK_TARGET)
        {
            ExecuteAttackOrder();
            Outer.m_Orders.Remove(0, 1);
            continue;
        }
        if (Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_FOLLOW)
        {
            ExecuteFollowOrder();
            Outer.m_Orders.Remove(0, 1);
            continue;
        }
        if (Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_SWITCH_WEAPON)
        {
            ExecuteSwitchWeaponOrder();
            Outer.m_Orders.Remove(0, 1);
            continue;
        }
        if (Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_HOLD_POSITION)
        {
            ExecuteHoldPositionOrder();
            Outer.m_Orders.Remove(0, 1);
        }
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}