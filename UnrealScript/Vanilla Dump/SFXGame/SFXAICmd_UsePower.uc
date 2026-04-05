Class SFXAICmd_UsePower extends SFXAICommand within SFXAI_Core;

var transient Vector m_vTargetLocation;
var transient Name nmPowerToUse;
var transient Actor m_oTargetActor;
var transient bool bPlayerOrder;
var transient bool bTargetSpecified;

public function bool ChoosePowerTarget(Actor oTargetActor, Vector vTargetLocation)
{
    local SFXPowerCustomActionBase oPower;
    local EPowerType EPowerType;
    local BioPawn oPawn;
    
    if (Outer.MyBP == None || Outer.MyBP.PowerManager == None)
    {
        return FALSE;
    }
    oPower = Outer.MyBP.PowerManager.GetPower(nmPowerToUse);
    if (oPower == None)
    {
        return FALSE;
    }
    if (!bTargetSpecified)
    {
        EPowerType = oPower.PowerType;
        if (EPowerType == EPowerType.PowerType_Buff)
        {
            oTargetActor = Outer.MyBP;
            vTargetLocation = Outer.MyBP.location;
        }
        else
        {
            if (Outer.FireTarget == None)
            {
                return FALSE;
            }
            oTargetActor = Outer.FireTarget;
            oPawn = BioPawn(Outer.FireTarget);
            if (oPawn == None || oPawn.GetAimNodeLocation(4, vTargetLocation) == FALSE)
            {
                vTargetLocation = Outer.FireTarget.location;
            }
        }
    }
    else if (!bPlayerOrder)
    {
        oPawn = BioPawn(oTargetActor);
        if (oPawn != None)
        {
            oPawn.GetAimNodeLocation(4, vTargetLocation);
        }
    }
    oPower.m_oTargetToAimAt = oTargetActor;
    oPower.m_vLocationToAimAt = vTargetLocation;
    return TRUE;
}
public event function string GetDumpString()
{
    return Super(GameAICommand).GetDumpString() $ "-" $ nmPowerToUse;
}
public static function bool UsePower(SFXAI_Core AI, Name nmPower, optional Actor oTarget, optional Vector vTargetLoc, optional bool bUseSpecifiedTarget = FALSE, optional bool bOrdered = FALSE)
{
    local SFXAICmd_UsePower Cmd;
    
    if (AI != None && nmPower != 'None')
    {
        Cmd = new (AI) Class'SFXAICmd_UsePower';
        if (Cmd != None)
        {
            Cmd.nmPowerToUse = nmPower;
            Cmd.m_oTargetActor = oTarget;
            Cmd.m_vTargetLocation = vTargetLoc;
            Cmd.bTargetSpecified = bUseSpecifiedTarget;
            Cmd.bPlayerOrder = bOrdered;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function Popped()
{
    Outer.ReleaseTicket(Outer.FireTarget, 2);
    Outer.ClearPowerReservation(nmPowerToUse, Outer.m_bPowerProjectileReleased);
    nmPowerToUse = 'None';
    Outer.m_bPowerProjectileReleased = FALSE;
    Outer.m_PowerTargetActor = None;
    Outer.m_PowerTargetLocation = vect(0.0, 0.0, 0.0);
    if (Outer.__UsePowerDelegate__Delegate != None)
    {
        Outer.__UsePowerDelegate__Delegate(Outer.m_nPowerCompletionReason);
        Outer.__UsePowerDelegate__Delegate = None;
    }
    Outer.m_bIgnorePowerSuppression = FALSE;
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.ClearCancelAction();
    GotoState('UsingPower', , , );
}
public function bool ShouldCancelPower()
{
    return FALSE;
}
public function bool StartPower()
{
    local SFXPowerCustomActionBase oPower;
    
    if (Outer.MyBP == None || Outer.MyBP.PowerManager == None)
    {
        return FALSE;
    }
    oPower = Outer.MyBP.PowerManager.GetPower(nmPowerToUse);
    if (oPower == None || oPower.PowerCustomActionID == 0)
    {
        return FALSE;
    }
    Outer.MyBP.StartCustomAction(132, , , oPower.PowerCustomActionID);
    return TRUE;
}

state UsingPower extends DebugState 
{
    
Begin:
    Outer.m_nPowerCompletionReason = 2;
    if (Outer.MyBP == None || Outer.MyBP.IsDead())
    {
        Outer.PopCommand(Self);
    }
    if (ChoosePowerTarget(m_oTargetActor, m_vTargetLocation) == FALSE)
    {
        Outer.PopCommand(Self);
    }
    if (Outer.m_PowerTargetActor != None)
    {
        Outer.Focus = Outer.m_PowerTargetActor;
    }
    else
    {
        Outer.SetFocalPoint(Outer.m_PowerTargetLocation);
    }
    if (Outer.MyBP.CanDoCoverAction(3))
    {
        Outer.MyBP.SetCoverDirection(1);
    }
    else if (Outer.MyBP.CanDoCoverAction(4))
    {
        Outer.MyBP.SetCoverDirection(2);
    }
    if (StartPower() == FALSE)
    {
        Outer.PopCommand(Self);
    }
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(19, Outer.MyBP, BioPawn(Outer.m_PowerTargetActor), , , TRUE);
    Outer.m_nPowerCompletionReason = 1;
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}